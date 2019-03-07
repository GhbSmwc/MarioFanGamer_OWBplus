lorom

!yes = 1
!no  = 0

if read1($00FFD5) == $23
	; SA-1 base addresses
	sa1rom
	!sa1 = 1
	!dp = $3000
	!addr = $6000
	!bank = $000000
else
	; Non SA-1 base addresses
	!sa1 = 0
	!dp = $0000
	!addr = $0000
	!bank = $800000
endif

incsrc Border_Defs.asm

!Lives_X	= $08
!Lives_Y	= $04

!Names_X	= $0B
!Names_Y	= $04

!Ex_Names_X	= $0B
!Ex_Names_Y	= $03

math round off	; It must be disabled, else Asar outputs a 16-bit number
				; (technically still a 32-bit number but with a floating point).

incsrc shared/shared.asm

function get_border_RAM(X, Y) = (X<<1)+(select(less(Y, !Top_Lines), !TopRowRAM+(Y<<6), select(greater(Y, 27-!Bottom_Lines), !BottomRowRAM+((Y+!Bottom_Lines-28)<<6), !BottomRowRAM)))|0

org $0081EC|!bank		; Just hijack the same place as Ladida's overworld counter for lolz. XD
autoclean JML NMI_Code	; Not that it really mattered anyway. B)

org $03BB30|!bank	; LM code
JML Level_Name_Code

org $05DBF2|!bank
	JSL Load_Code

	LDA #$00
	STA !EnableUpload

	if !Enable_Lives_Display
		LDX #$00						;\Which player (Mario and Luigi) to display their lives
		LDA $0DB3|!addr						;|(Didn't use "0DB3|!addr,x" in the case should it be a number greater than $01).
		
		BEQ +							;|
		LDX #$01						;/
	+	LDA $0DB4|!addr,x					;\$0DB4,x is the current player's lives, minus 1 (so if your lives HUD display says 1, its 0 on this RAM)
		INC							;/which is why an INC here is needed.
		JSR $DC3A						;>Hex 2 Dec (converts a value in A (8-bit), to BCD with X = 10s and A = 1s)
		CPX #$00						;\If the player's lives is 0-9 (only a single digit was needed to display), skip writing a leading zero.
		BEQ +							;/
		CLC : ADC #$22						;>Convert digit value to overworld digits (a digit 0 is located at tile number $22, 1 -> $23, 2 -> $24 and so on.)
		STA.l get_border_RAM(!Lives_X+1, !Lives_Y)		;>Write ones digit ($009|$004)
		LDA #$39						;\Tile properties for the ones digit
		STA.l get_border_RAM(!Lives_X+1, !Lives_Y)+1		;/
		TXA							;>X (Tens digit) -> A
	+	CLC : ADC #$22						;>Convert to overworld digits.
		STA.l get_border_RAM(!Lives_X, !Lives_Y)		;>Write tens digit ($008|$004)
		LDA #$39						;\Tile properties for the tens digit
		STA.l get_border_RAM(!Lives_X, !Lives_Y)+1		;/
	endif
RTL
warnpc $05DC40|!bank

assert read1($048E81) == $22,"Please edit the level names in LM at least once."

!Level_Names	= read3($03BB57)	; Get the level names

freecode
if !Enable_Extended_Level_Names : prot Level_Names

NMI_Code:
{
	LDA $0D9B|!addr
	LSR
	BNE Correct_Level_Mode
JML $0081F2|!bank
}

{
Correct_Level_Mode:
	LDA $0100|!addr
	CMP #$0D	;\
	BEQ ++		; | On fade ins and at the main code.
	CMP #$0E	;/
	BNE +
++	LDA !EnableUpload
	BNE +
	JSR UploadTiles
+
JML $008222|!bank		; This is, where the code originally jumps to.
}

Load_Code:
{
; Upload top row
	if !Top_Lines
	{
		REP #$20
		LDY #$80	;\ Increment at high-byte write/ read.
		STY $2115	;/
		LDA #$3981	;\ Read from $2139 and $213A
		STA $4310	;/
		LDA.w #$20*!Top_Lines*2
		STA $4315
		LDA.w #!TopRowRAM
		STA $4312
		LDY.b #!TopRowRAM>>16
		STY $4314
		LDA #$5000	;($000|$000), Layer 3
		STA $2116
		LDA $2139	; Dummy
		SEP #$20
		LDY #$02
		STY $420B
	endif

; Upload bottom row
	if !Bottom_Lines
	{
		REP #$20
		LDY #$80	;\ Increment at high-byte write/ read.
		STY $2115	;/
		LDA #$3981	;\ Read from $2139 and $213A
		STA $4310	;/
		LDA.w #$20*!Bottom_Lines*2
		STA $4315
		LDA.w #!BottomRowRAM
		STA $4312
		LDY.b #!BottomRowRAM>>16
		STY $4314
		LDA #$5000|((28-!Bottom_Lines)<<5)	;($000|$01C-max num of bottom rows), Layer 3
		STA $2116
		LDA $2139	; Dummy
		SEP #$20
		LDY #$02
		STY $420B
	}
	endif
}
RTL

Level_Name_Code:
{
	if !Enable_Extended_Level_Names
	{
		ASL
		CLC : ADC.w #Level_Names
		STA $00
		CLC : ADC #$0013
		STA $03
		SEP #$30
		LDA.b #Level_Names>>16
		STA $02
		STA $05
		LDX #$24
		LDY #$12
-		LDA [$00],y
		STA.l get_border_RAM(!Ex_Names_X, !Ex_Names_Y),x	; ($00B|$003)
		LDA [$03],y
		STA.l get_border_RAM(!Ex_Names_X, !Ex_Names_Y+1),x	; ($00B|$004)
		LDA #$39
		STA.l get_border_RAM(!Ex_Names_X, !Ex_Names_Y)+1,x	; Same as above
		STA.l get_border_RAM(!Ex_Names_X, !Ex_Names_Y+1)+1,x	; You have three guesses
		DEX #2
		DEY
		BPL -
	}
	else
	{
		CLC : ADC.w #!Level_Names
		STA $00
		SEP #$30
		LDA.b #!Level_Names>>16
		STA $02
		LDX #$24
		LDY #$12
-		LDA [$00],y
		STA.l get_border_RAM(!Names_X, !Names_Y),x	; ($00B|$004)
		LDA #$39
		STA.l get_border_RAM(!Names_X, !Names_Y)+1,x	; Same as above
		DEX #2
		DEY
		BPL -
	endif
	}
	REP #$30
	RTL
}

UploadTiles:
{
; Only upload each half at every second frame.
	if !Top_Lines && !Bottom_Lines
		LDA !UploadFrames
		INC
		STA !UploadFrames
		AND #$01
		BEQ .bottom
	endif
	
; Upload top row
	if !Top_Lines
	{
		REP #$20
		LDY #$80	;\ Increment at high-byte write/ read.
		STY $2115	;/
		LDA #$1801	;\ Write to $2118 and $2119
		STA $4310	;/
		LDA.w #$20*!Top_Lines*2
		STA $4315
		LDA.w #!TopRowRAM
		STA $4312
		LDY.b #!TopRowRAM>>16
		STY $4314
		LDA #$5000	;($000|$000), Layer 3
		STA $2116
		LDY #$02
		STY $420B
		SEP #$20
	RTS
	}
	endif

.bottom
; Upload bottom row
	if !Bottom_Lines
	{
		REP #$20
		LDY #$80	;\ Increment at high-byte write/ read.
		STY $2115	;/
		LDA #$1801	;\ Write to $2118 and $2119
		STA $4310	;/
		LDA.w #$20*!Bottom_Lines*2
		STA $4315
		LDA.w #!BottomRowRAM
		STA $4312
		LDY.b #!BottomRowRAM>>16
		STY $4314
		LDA #$5000|((28-!Bottom_Lines)<<5)	;($000|$01C-max num of bottom rows), Layer 3
		STA $2116
		LDY #$02
		STY $420B
		SEP #$20
	RTS
	}
	endif
}

incsrc Level_Names.asm
