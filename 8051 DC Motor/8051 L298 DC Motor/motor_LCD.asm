	RS equ P1.3
	E equ P1.2
org 000H
	jmp main
org 001BH
	jmp timerisr

main:
	clr RS
	call FuncSet
	call DispCon
	call EntryMode
	setb RS
	mov TMOD, #50H			; put timer 1 in event counting mode
	setb ET1
	setb EA
	mov TL1, #00H
	mov TH1, #0FFH
	setb TR1			; start timer 1

again:
	call setDirection
	mov A, TL1			; move timer 1 low byte to A
get:
	mov R3, A
	mov B, #0AH
	div AB
	mov R5, B
	mov B, #0AH
	div AB
	mov R1, #50H
	mov @R1, A
	mov A, B
	swap A
	add A, R5
	inc R1
	mov @R1, A
	mov A, 51H
	anl A, #0F0H
	swap A
	add A, #30H
	mov 61H, A
	mov A, 51H
	anl A, #0FH
	add A, #30H
	mov 62H, A
	mov A, 50H
	add A, #30H
	mov 60H, A
	call CursorReset
	setb RS
	mov R1, #60H
rep:
	clr A
	mov A, @R1
	jz enddisp
	call send
	inc R1
	jmp rep
enddisp:
	cjne R3, #255, skip
	sjmp stop
skip:
	jmp again			; do it all again

stop:
	clr P3.0
	clr P3.1
	sjmp $

timerisr:
	clr P3.0
	clr P3.1
	call CursorReset
	setb RS
	mov A, #255
	sjmp get

setDirection:
	PUSH ACC			; save value of A on stack
	PUSH 20H			; save value of location 20H (first bit-addressable 
					;	location in RAM) on stack
	CLR A				; clear A
	MOV 20H, #0			; clear location 20H
	MOV C, P2.0			; put SW0 value in carry
	MOV ACC.0, C			; then move to ACC.0
	MOV C, F0			; move current motor direction in carry
	MOV 0, C			; and move to LSB of location 20H (which has bit address 0)

	CJNE A, 20H, changeDir		; | compare SW0 (LSB of A) with F0 (LSB of 20H)
					; | - if they are not the same, the motor's direction needs to be reversed

	JMP finish			; if they are the same, motor's direction does not need to be changed

changeDir:
	CLR P3.0			; |
	CLR P3.1			; | stop motor

	CALL clearTimer			; reset timer 1 (revolution count restarts when motor direction changes)
	MOV C, P2.0			; move SW0 value to carry
	MOV F0, C			; and then to F0 - this is the new motor direction
	MOV P3.0, C			; move SW0 value (in carry) to motor control bit 1
	CPL C				; invert the carry

	MOV P3.1, C			; | and move it to motor control bit 0 (it will therefore have the opposite
	jb F0, one
	mov 63H, #'A'
	jmp finish
one:
	mov 63H,#'C'	
finish:
	POP 20H				; get original value for location 20H from the stack
	POP ACC				; get original value for A from the stack
	RET				; return from subroutine
clearTimer:
	CLR A				; reset revolution count in A to zero
	CLR TR1				; stop timer 1
	MOV TL1, #0			; reset timer 1 low byte to zero
	SETB TR1			; start timer 1
	RET				; return from subroutine

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
	
