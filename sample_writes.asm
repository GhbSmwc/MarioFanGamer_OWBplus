;This contains examples as for anyone who does not know how
;to write tiles to the overworld border. Best used on
;UberASM tool's gamemode $0E.

;Write "000" on the border:
	
	
	!WritePosition = $7FEC00 ;>Change to $41EC00 for SA-1
	
	main:
	
	LDA #$22
	;^Number tiles (digits 0-9) are located at page 1 at
	;tiles $22 to $2B. If you are using a display of
	;numbers that can change, after using the Hex->Dec
	;to convert to decimal, you add each digit byte by
	;$22 to convert them to overworld digits. An example is
	;in [Overworld_Border_Plus.asm] under
	;"if !Enable_Lives_Display" (I, GreenHammerBro added comments).
	
	LDX.b #(3-1)*2 ;Write 3 times for each 3 tile byte; indexes 0, 2, and 4 to write.
	
	.LoopTileNumb
	STA !WritePosition,x
	DEX #2
	BPL .LoopTileNumb
	
	;       YXPCCCTT
	LDA.b #%00111001
	;^Bits [TT] is the page number, ranging from 0-3 (%00 to %11), the digit
	;  tiles are located at page 1 (%01).
	; Bits [CCC] is what palette to use, ranging from 0-7 (%000 to %111),
	;  the same way LM displays all the possible colors row. Palette 6 (%110)
	;  is considered the normal palette for numbers.
	; Bits [P] is the priority bit, determines if this tile goes in front
	;  of all layer 1 and 2 stuff. Recommended to have this set to 1 and
	;  and not 0 if you don't want stuff like clouds and other layer 1 stuff
	;  overlapping it.
	; Bits [X] is the X flip of the tile.
	; Bits [Y] is the Y flip of the tile.
	LDX.b #(3-1)*2 ;Write 3 times for each 3 tile properties byte (indexing is same as above)
	
	.LoopTileProps
	STA !WritePosition+$01,x	;>Write at tile tile properties that are +1 byte after each tile number byte.
	DEX #2
	BPL .LoopTileProps
	RTL
;Another example: Write "TEST". Note: On most emulators, the top line of pixels are cutoff:
	
	!WritePosition = $7FEC00 ;>Change to $41EC00 for SA-1
	
	main:
	;Make sure you use fixed-width font in your text editor (uses ASCII art)!
	;|----------Tile Number---------|   |-------------Tile Properties-----------|
	;V                              V   V                                       V
	LDA #$13 : STA !WritePosition+$00 : LDA.b #%00111001 : STA !WritePosition+$01 ;>Tile $13 is "T"
	LDA #$04 : STA !WritePosition+$02 : LDA.b #%00111001 : STA !WritePosition+$03 ;>Tile $04 is "E"
	LDA #$12 : STA !WritePosition+$04 : LDA.b #%00111001 : STA !WritePosition+$05 ;>Tile $12 is "S"
	LDA #$13 : STA !WritePosition+$06 : LDA.b #%00111001 : STA !WritePosition+$07 ;>Tile $13 is "T"
	RTL