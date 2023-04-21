$INCLUDE(.\Coffee Machine.h)
$INCLUDE (AT89S52.inc)


	ORG 0000H
	LJMP MAIN
	ORG 0003H
	LJMP ISR_IT0
	ORG 0013H
	LJMP ISR_IT1
 
MAIN:
	;SETB TCON.0
	;SETB TCON.2
	MOV P1, #0
	MOV P2, #0
	MOV IE, #85H
	MOV 	TMOD, #1
	SJMP $

;------------------------------------------------------------------------------------
;InterruptServiceRoutines
;------------------------------------------------------------------------------------
ISR_IT0:
	CJNE R7, #5, STATE2
	MOV R0, #2
	BACKS3: MOV R1, #255
		REPEAT: MOV P1, A
			ACALL DELAY
			RL A
			DJNZ R1, REPEAT
			DJNZ R0, BACKS3
	MOV R7, #4
	SJMP FINISH

STATE2: JC STATE1
	MOV R0, #255
	BACKS2:
		MOV P1, A
		ACALL DELAY
		RR A
		DJNZ R0, BACKS2
	MOV R7, #5
	SJMP FINISH

STATE1:	MOV A, #66H
	MOV R0, #255
	BACKS:
		MOV P1, A
		ACALL DELAY
		RR A
		DJNZ R0, BACKS
	MOV R7, #6

FINISH: RETI

ISR_IT1:	
	CJNE R7, #5, TEA
	SETB P2.2
	CLR P2.3
	ACALL DELAY2
	SETB P2.3
	SJMP FINISH2

TEA: JC SUGAR
	MOV R3, #30
	BACKX:
		MOV 	TL0, #70H
		MOV 	TH0, #0BCH
		ACALL TIMER_GO2
		MOV 	TL0, #80H
		MOV 	TH0, #0FBH
		ACALL TIMER_GO2
		DJNZ R3, BACKX

	
		MOV 	TL0, #25H
		MOV 	TH0, #0FAH
		ACALL TIMER_GO2
		MOV 	TL0, #0D9H
		MOV 	TH0, #0BDH
		ACALL TIMER_GO2
	SJMP FINISH2

SUGAR:	MOV R3, #30
	BACK1:
		MOV 	TL0, #70H
		MOV 	TH0, #0BCH
		ACALL TIMER_GO1
		MOV 	TL0, #80H
		MOV 	TH0, #0FBH
		ACALL TIMER_GO1
		DJNZ R3, BACK1



		MOV 	TL0, #25H
		MOV 	TH0, #0FAH
		ACALL TIMER_GO1
		MOV 	TL0, #0D9H
		MOV 	TH0, #0BDH
		ACALL TIMER_GO1

FINISH2: RETI

;------------------------------------------------------------------------------------
;Timer&Delays
;------------------------------------------------------------------------------------
TIMER_GO1:
	SETB	TR0
	JNB	TF0, $
	CLR	TR0
	CLR	TF0
	CPL 	P2.0
	RET

TIMER_GO2:
	SETB	TR0
	JNB	TF0, $
	CLR	TR0
	CLR	TF0
	CPL 	P2.1
	RET

DELAY: 
	MOV R2, #75
	L2: MOV R4, #75
	L1: DJNZ R4, L1
	DJNZ R2, L2
	RET

DELAY2:
	MOV R4,#10
WAIT2:
	MOV R6,#0FFH
WAIT1:
	MOV R5,#0FFH
WAIT:
	DJNZ R5, WAIT
	DJNZ R6, WAIT1
	DJNZ R4, WAIT2
	RET

END