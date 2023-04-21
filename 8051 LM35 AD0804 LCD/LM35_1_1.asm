;====================================================================
; DEFINITIONS
; EQU (equate): This is used to define a constant
; without occupying a memory location.
;====================================================================
IO_DECLERATION:
    	LCD_PORT EQU	P1
    	RS 	EQU 	P3.0 ; RS ON LCD
    	RW 	EQU 	P3.1 ; RS ON LCD
	EN 	EQU 	P3.2 ; EN ON LCD

	ADC_WR	EQU	P3.3

	MTR1_EN	EQU	P3.4
	MTR2_EN	EQU	P3.1
	MTR1_IN	EQU	P3.6
	MTR2_IN	EQU	P3.5
	BUZZER	EQU	P3.7

;	PWMPIN	EQU	P3.6


	TEMP	EQU	30H
	PSET	EQU	31H
	L_NRML  EQU	32H
	H_NRML	EQU	33H
	TOO_HI	EQU	34H
	AUD_STL	EQU	35H
	COUNTER	EQU	36H
	DUTY	EQU	37H
	
;====================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ORG	00H		;RESET VECTOR ADDRESS
	LJMP	MAIN	;JUMP TO MAIN PROGRAM
    ORG	000BH		;TIMER0 VECTOR ADDRESS
	LJMP 	ISR_T0 	;jump to ISR TIMER0
    ORG 001BH 		;Timer 1 int. vector table
	LJMP 	ISR_T1 	;jump to ISR TIMER1
    ORG	30H	
;====================================================================
MAIN:	
	MOV 	P3,#00H
	MOV 	P1,#00H
	MOV 	P2,#0FFH
	MOV 	P0,#0FFH
	MOV	COUNTER,#0H
	MOV	AUD_STL,#0H
	MOV	DUTY,#0H

	MOV	L_NRML,#28D
	MOV	H_NRML,#35D
	MOV	TOO_HI,#39D

	LCALL	LCD_INIT
	MOV 	R0, #80H
	ACALL 	CMND_WRT
	MOV	DPTR, #MSG1
	ACALL	PRNT_STRNG
	
	LCALL	SETUP_TMR0
	LCALL	SETUP_TMR1
;====================================================================
;====================================================================
MAIN_LOOP:
	MOV 	R0, #08BH
	ACALL 	CMND_WRT
	
	CLR	ADC_WR
	SETB	ADC_WR
RD_ADC:
	MOV	A,P2
	MOV	TEMP,A
	ACALL	BIN_2_ASCII
	ACALL	CHECK_TEMP
	LCALL	CTRL_FAN
	LJMP	MAIN_LOOP
;====================================================================
;====================================================================

CTRL_FAN:

	MOV	A,AUD_STL
	JZ	OR_BEEP
DNGR_BEEP:
	MOV 	DUTY,#50D
	RET
OR_BEEP:
	MOV 	DUTY,#10D
	RET

;====================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CHECK_TEMP:
	MOV	A,TEMP
	SUBB	A,TOO_HI
	JNC	_2HI

	MOV	A,TEMP
	SUBB	A,H_NRML
	JNC	_HI

	MOV	A,TEMP
	SUBB	A,L_NRML
	JC	_LO

_NRM:
	JMP	TMP_OK
_2HI:
	JMP	TMP_2HI
_HI:
	JMP	TMP_HI
_LO:
	JMP	TMP_LO


TMP_OK:
	SETB	MTR1_EN
	CLR	MTR2_EN
	SETB	BUZZER
	CLR 	TR1
	MOV	DPTR, #STR_NR
	LCALL	PRNT_STAT
	RET

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
TMP_HI:
	SETB	MTR1_EN
	CLR	MTR2_EN
	MOV	AUD_STL,#0H
	SETB 	TR1
	MOV	DPTR, #STR_HI
	LCALL	PRNT_STAT
	RET
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
TMP_2HI:
	CLR	MTR1_EN
	SETB	MTR2_EN
	MOV	AUD_STL,#0FFH
	SETB 	TR1
	MOV	DPTR, #STR_2H
	LCALL	PRNT_STAT
	RET
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
TMP_LO:
	CLR	MTR1_EN
	CLR	MTR2_EN
	MOV	AUD_STL,#0H
	SETB 	TR1
	MOV	DPTR, #STR_LO
	LCALL	PRNT_STAT
	RET
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++




;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRNT_STAT:		
	MOV 	R0,#0C0H
	ACALL 	CMND_WRT
PRNT_STRNG:	
	CLR	A
	MOVC	A, @A+DPTR
	MOV 	R0, A
	JZ	END_STRNG
	ACALL 	DATA_WRT			;call display subroutine
	ACALL 	DELAY			;give LCD some time
	INC	DPTR
	SJMP	PRNT_STRNG
END_STRNG:
	RET
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++




;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SETUP_TMR0:
	MOV 	TMOD,#00H
;	MOV 	DUTY,#150	;160 D WAS EXAMPLE VALUE
	SETB	EA		;mode 1 of Timer0  
	SETB	ET0		;enable timer 0 interrupt  
	SETB	TR0		;start TIMER0 (TIMER)  
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SETUP_TMR1:
	MOV 	TMOD,#10H  	;Sets TMR1 AS counter & TMR0 AS timer
	MOV 	TL1,#0H   	;loads initial value to TL1
	MOV 	TH1,#0H   	;loads initial value to TH1
	SETB	ET0		;enable timer 0 interrupt
	SETB 	TR1             ;starts TIMER1(counter) 
	CLR 	TF0             ;clears Timer Flag 0
	CLR 	TF1             ;clears Timer Flag 1
	MOV	IE,#88h
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;INTERRUPT SERVICE ROUTINE________________________________
ISR_T0:
	JB	F0, HIGH_DONE
LOW_DONE:
	SETB	F0
	SETB	MTR1_IN		; PWMPIN
	MOV	TH0,DUTY
	MOV	TL0,#00H
	CLR	TF0
	RETI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HIGH_DONE:
	CLR	F0
	CLR	MTR1_IN		; PWMPIN
	MOV	A,#0FFH
	CLR	C
	SUBB	A,DUTY
	MOV	TH0,A
	MOV	TL0,#00H
	CLR	TF0
	RETI

;====================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ISR_T1:
	CLR 	TR1              	; stops Timer(counter)1
	CLR 	TR0              	; stops Timer(counter)1
	PUSH	07H
	INC	COUNTER
	MOV	R7,COUNTER
	MOV	A,AUD_STL
	JZ	OUT_RANGE
DANGER:
	CPL 	BUZZER
	SJMP	LEAVE
	
OUT_RANGE:
	CJNE	R7,#03D,TWO_PLUS
	CLR 	BUZZER
TWO_PLUS:
	CJNE	R7,#04H,LEAVE
	SETB	BUZZER
	CLR	COUNTER

LEAVE:
	MOV	TH1,#0C0H
	MOV	TL1,#00H
	SETB	TR1
	CLR 	TF1             ; clears Timer Flag 1
	POP	07H
	RETI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++



;====================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
BIN_2_ASCII:
	MOV 	R7,#10D
	MOV 	A, TEMP		;MOVE VALUE TO ACUMULATOR
	MOV 	B,R7
	DIV 	AB
	ADD 	A,#30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R0,A
	ACALL 	DATA_WRT	;PRINT ON LCD
	MOV 	A,B		;MOVE VALUE TO ACUMULATOR
	ADD 	A, #30H
	MOV 	R0,A
	ACALL 	DATA_WRT		;PRINT ON LCD
	RET
	 

;====================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
LCD_INIT:
	MOV 	R0, #38H
	ACALL 	CMND_WRT	;call command subroutine
	MOV 	R0, #0EH
	ACALL 	CMND_WRT
	MOV 	R0, #01H
	ACALL 	CMND_WRT
	MOV 	A,#06H 		;Increment cursor
	ACALL 	CMND_WRT
	MOV 	R0, #80H
	ACALL 	CMND_WRT
	MOV 	A,#3CH 		;Activate second line
	ACALL 	CMND_WRT
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DATA_WRT:
	MOV 	LCD_PORT, R0
	SETB 	RS
	SETB 	EN
	ACALL 	DELAY
	CLR 	EN
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CMND_WRT:
	MOV 	LCD_PORT, R0
	CLR 	RS
	SETB 	EN
	ACALL 	DELAY
	CLR 	EN
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DELAY:	MOV 	62, #2		;APPROX DELAY DE 0.25s
DELAY1:	MOV 	61, #50
DELAY_:	MOV 	60, #200
	DJNZ 	60, $
	DJNZ 	61, DELAY_
	DJNZ 	62, DELAY1
	RET

;====================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ORG 	200H
	MSG1: 	DB "Temp.(C):",0
	STR_2H: DB 'DANGER',0
	STR_HI: DB 'HIGH  ',0
	STR_NR: DB 'NORMAL',0
	STR_LO: DB 'LOW   ',0
	
	END

;====================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

