	RS equ P1.3
	E equ P1.2
	clr P0.7
	clr RS
	call FuncSet
	call DispCon
	call EntryMode
	mov TMOD, #50H			; put timer 1 in event counting mode
	setb TR1			; start timer 1

	mov DPL, #LOW(LEDcodes)		; | put the low byte of the start address of the
					; | 7-segment code table into DPL

	mov DPH, #HIGH(LEDcodes)	; put the high byte into DPH

	mov P1, #0FFH
	setb P0.7
	clr P3.4			; |
	clr P3.3			; | enable Display 0
	call changeDir
again:
	mov A, TL1			; move timer 1 low byte to A
	movc A, @A+DPTR			; | get 7-segment code from code table - the index into the table is
					; | decided by the value in A 
					; | (example: the data pointer points to the start of the 
					; | table - if there are two revolutions, then A will contain two, 
					; | therefore the second code in the table will be copied to A
	setb P0.7
	mov P2, A			; | move (7-seg code for) number of revolutions and motor direction 
					; | indicator to Display 0
	cjne A, #92H, skip		; if the number of revolutions is not 5 skip next instruction
	call changeDir
	mov R3, #10
	djnz R3, $
	call clearTimer			; if the number of revolutions is 10, reset timer 1
skip:
	jmp again			; do it all again

changeDir:
	cpl F0
	clr P3.0			; |
	clr P3.1			; | stop motor

	call clearTimer			; reset timer 1 (revolution count restarts when motor direction changes)
	clr P0.7
	jb F0, one
	mov A, #'A'
	jmp display
one:
	mov A,#'C'	
display:
	call send
	call CursorReset
	setb RS
	mov C, F0
	mov P3.0, C
	cpl C
	mov P3.1, C
	ret

clearTimer:
	clr A				; reset revolution count in A to zero
	clr TR1				; stop timer 1
	mov TL1, #0			; reset timer 1 low byte to zero
	setb TR1			; start timer 1
	ret				; return from subroutine

FuncSet: 
        clr p1.7
        clr p1.6
        setb p1.5
        clr p1.4

        call Pulse

        Call Delay

        Call Pulse ;Reason exists

        setb p1.7
        clr p1.6
        clr p1.5
        clr p1.4

        call Pulse

        call Delay
Ret

DispCon: 
        clr p1.7
        clr p1.6
        clr p1.5
        clr p1.4

        call Pulse

        setb p1.7
        setb p1.6
        setb p1.6
        setb p1.4

        call Pulse

        call Delay
Ret

EntryMode:
        clr p1.7
        clr p1.6
        clr p1.5
        clr p1.4

        call Pulse

        clr p1.7
        setb p1.6
        setb p1.5
        clr p1.4

        call Pulse

        call Delay
Ret

CursorReset:
        	clr RS
			setb P1.7		; Sets the DDRAM address
			clr P1.6		; Set address. Address starts here - '1'
			Clr P1.5		; 									 '0'
			Clr P1.4		; 									 '0' 
							; high nibble
			Call Pulse

			Clr P1.7		; 									 '0'
			Clr P1.6		; 									 '0'
			Clr P1.5		; 									 '0'
			Clr P1.4		; 									 '0'
							; low nibble
							; Therefore address is 100 0000 or 40H
			Call Pulse

			Call Delay		; wait for BF to clear	
			Ret
			
			
send:	setb RS
		mov c,acc.7  ; |
        mov p1.7,c   ; |
        mov c,acc.6  ; |
        mov p1.6,c   ; |
        mov c,acc.5  ; |
        mov p1.5,c   ; |
        mov c,acc.4  ; |
        mov p1.4,c   ; | high nibble set

        call Pulse

        mov c,acc.3  ; |
        mov p1.7,c   ; |
        mov c,acc.2  ; |
        mov p1.6,c   ; |
        mov c,acc.1  ; |
        mov p1.5,c   ; |
        mov c,acc.0  ; |
        mov p1.4,c   ; | low nibble set

        call Pulse

        call Delay   ; wait for BF to clear
		ret

Pulse:  setb E ; |*P1.2 is connected to 'E' pin of LCD module*
        clr E  ; | negative edge on E
		ret

Delay:  mov r0,#30
        djnz r0,$
		ret
	

LEDcodes:	; | this label points to the start address of the 7-segment code table which is 
		; | stored in program memory using the DB command below
	DB 11000000B, 11111001B, 10100100B, 10110000B, 10011001B, 10010010B, 10000010B, 11111000B, 10000000B, 10010000B
