!Enable_Extended_Level_Names	= !yes			; Change it to "!yes" to enable it
!Enable_Lives_Display			= !yes			; Change it to "!no" to disable it

!Top_Lines						= 5
!Bottom_Lines					= 2

!TileRAM						= $7FEC00		; You might want to change that
												; At least if you patches which uses the Map16 high byte,
												; which is pretty much unused on the overworld or use too many rows.
												; Each line takes up 64 bytes so by default, you need 448 or 0x1C0, plus 2
												; bytes which you have got plenty.

!TileRAM_SA1					= $41EC00		; Ditto.

; From now on, please edit nothing

if !sa1
	!Tiles_Bank = !Tiles_Bank_SA1
	!TileRAM = !TileRAM_SA1
endif

!TopRowRAM = !TileRAM						;$7FEC00 >ByteUsed = !Top_Lines*64 (320 by default)
!BottomRowRAM = !TileRAM+(64*!Top_Lines)			;$7FED40 >ByteUsed = !Bottom_Lines*64 (128)
!NonBorderRAM = !TileRAM+(64*(!Top_Lines+!Bottom_Lines))	;$7FEDC0 \        1 byte
!UploadFrames = !NonBorderRAM					;$7FEDC0 /
!EnableUpload = !NonBorderRAM+1					;$7FEDC1 >        1 byte (if nonzero, does not upload)
;
;In total bytes required using default values, should take 450 ($1C2) bytes.

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