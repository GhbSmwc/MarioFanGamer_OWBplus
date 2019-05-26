!Enable_Extended_Level_Names	= !yes			; Change it to "!yes" to enable it
!Enable_Lives_Display			= !yes			; Change it to "!no" to disable it

!Top_Lines = 5
!Bottom_Lines = 2
 ;^Number of lines for the top and bottom. Note as you increase these values,
 ; it just extends the range of editable tiles downwards starting at the tops
 ; of...
 ; -The screen for !Top_Lines and;
 ; -The bottom border of !Bottom_Lines

!TileRAM = $7FEC00
 ;^[BytesUsed = ((!Top_Lines + !Bottom_Lines)*64)+2]
 ;
 ; You might want to change that, at least if your patches which uses the Map16
 ; high byte, which is pretty much unused on the overworld or use too many rows.
 ; Each line takes up 64 bytes so by default, you need 448 or 0x1C0 bytes for
 ; the top and bottom lines, plus 2 more for frame counting and flag to upload
 ; the tiles) which you have got plenty. Therefore, you need a total of 450 ($1C2)
 ; bytes for the whole patch to function.
 ;
 ; Memory layout (in this order, and no gaps in between, so 1 byte after the last byte
 ; of data is the next data):
 ; -Top lines tile data [BytesUsed = !Top_Lines*64]: This is tile data in
 ;  [TTTTTTTT YXPCCCTT] format for the top part of the border.
 ; -Bottom lines tile data [BytesUsed = !Bottom_Lines*64]: Same as "Top Lines"
 ;  mentioned above
 ; -Upload frame counter data [1 byte]: This is a frame counter similar to $13,
 ;  used to determine which top or bottom to upload. Uploads the bottom if this
 ;  value is even (FrameCount MOD 2 = 0) and top if odd.
 ; -Enable upload RAM data [1 byte]: This is a flag, that when nonzero, disables
 ;  all uploads to the OW border and the frame counter won't increment (so it stops
 ;  updating the tiles, if you write anything in the tile data RAM, the tiles on
 ;  the border won't change). Useful to set this to nonzero when doing other things
 ;  that require NMI/V-blank (such as custom menus on the map) to prevent black
 ;  bars flickering at the top of the screen.

!TileRAM_SA1					= $41EC00		; Ditto.

; From now on, please edit nothing, these here are "memory position-ers":

if !sa1
	!Tiles_Bank = !Tiles_Bank_SA1
	!TileRAM = !TileRAM_SA1
endif

!TopRowRAM = !TileRAM						;$7FEC00 >BytesUsed = !Top_Lines*64 (320 by default)
!BottomRowRAM = !TileRAM+(64*!Top_Lines)			;$7FED40 >BytesUsed = !Bottom_Lines*64 (128)
!NonBorderRAM = !TileRAM+(64*(!Top_Lines+!Bottom_Lines))	;$7FEDC0 \        1 byte
!UploadFrames = !NonBorderRAM					;$7FEDC0 /
!EnableUpload = !NonBorderRAM+1					;$7FEDC1 >        1 byte (if nonzero, does not upload)

;Display memory locations (and range) on asar's console window during patching:
print ""
print "Total RAM bytes used: ", dec((!Top_Lines*64)+(!Bottom_Lines*64)+2), " (Hex: $", hex((!Top_Lines*64)+(!Bottom_Lines*64)+2), ")"
if !Top_Lines != 0
	print "Top row RAM: $", hex(!TopRowRAM), " to $", hex((!BottomRowRAM-1))
endif
if !Bottom_Lines != 0
	print "Bottom row RAM: $", hex(!BottomRowRAM), " to $", hex((!NonBorderRAM-1))
endif
print "Upload frame counter: $", hex(!UploadFrames)
print "EnableUpload (disables when nonzero): $", hex(!EnableUpload)
print ""