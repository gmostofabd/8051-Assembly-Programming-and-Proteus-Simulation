;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
;Serial I/O routines using the 8051's built-in UART.
;Rx Routine (only)
;Protocol: UART
;Baud Rate: 9600 BPS
;gmostofabd
;---------------------------------------------------------------------------------------
ORG 0000H		; LOCATION WHERE EXECUTION OF THE PROGRAM STARTS FROM
	LJMP MAIN	; LJMP USED TO BYPASS THE ISR
;---------------------------------------------------------------------------------------
ORG 0023H		; LOCATION FOR ISR FOR BOTH TI AND RI
	LJMP SERIAL	; THE CONTROL IS SHIFTED TO THE SERIAL SUBROUTINE
;---------------------------------------------------------------------------------------
ORG 30H			; LOCATION OF THE STARTING ADDRESS OF THE PROGRAM CODE 
MAIN: 
	RD_CHAR 	EQU	31H
	
	MOV 	P0,#0H	; MAKES P1 INPUT PORT
	MOV 	P1,#0FFH	; MAKES P1 INPUT PORT
	MOV 	P2,#00H		; MAKES P1 INPUT PORT
	
INIT_SERIAL:
	MOV 	TMOD, #20H	; SELECTS TIMER 1 MODE 2 FOR GENERATING BAUD RATE
 	MOV 	TH1, #0FDH	; (#-3 FOR 9600 #-6 FOR 4800) GENERATES A BAUD RATE OF 9600
  	MOV 	SCON, #50H	; (#253 DEC) SELECTS MODE 1 WITH THE RECEIVER ENABLED
   	SETB 	TR1
;   	SETB	TI		; STARTS TIMER1
	MOV IE, #10010000B; ENABLES SERIAL INTERRUPT WHICH CAN BE CAUSED BY BOTH TI/RI
;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
MAIN_LOOP:
	ACALL	RECV
	MOV	A,RD_CHAR
;	MOV	A,#"A"
	ACALL	SEND
	
	SJMP	MAIN_LOOP
;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
RECV:
	JNB	RI,RECV
	MOV	A,SBUF
	MOV	RD_CHAR,A
	CLR	RI
	RET
;---------------------------------------------------------------------------------------
SEND:
  	MOV 	SBUF, A 	;MOVE CONTENTS OF A TO THE SERIAL BUFFER - THIS INITIATES THE TRANSMISSION DOWN THE SERIAL LINE
STAY:
	JNB 	TI,STAY 	;WAIT FOR ENTIRE CHARACTER TO BE SENT DOWN SERIAL LINE
 	CLR 	TI 		;CLEAR THE TRANSMIT OVERFLOW
	ACALL 	DELAY
	RET
;---------------------------------------------------------------------------------------
DELAY: 
	MOV 	R5, # 250
	MOV 	R6, # 250
DLOOP: 	
	DJNZ 	R5, DLOOP
	DJNZ 	R6, DLOOP
	RET
;---------------------------------------------------------------------------------------
ORG 100H; LOCATION WHERE THE SERIAL SUBROUTINE IS STORED
SERIAL: 
	JB 	TI, TRANS	; IF THE INTERRUPT IS CAUSED BY T1 CONTROL IS TRANSFERRED TO TRANS AS THE OLD DATA HAS BEEN TRANSFERRED AND NEW DATA CAN BE SENT TO THE SBUF
        MOV 	A, SBUF		; OTHERWISE THE INTERRUPT WAS CAUSED DUE TO RI AND RECEIVED DATA IS PUT INTO THE ACCUMULATOR.
        CLR 	RI	; CLEARS RI FLAG
        RETI		; TRANSFERS CONTROL TO MAIN
TRANS: 
	CLR 	TI	;  CLEARS TI FLAG
       	RETI		;  TRANSFERS CONTROL TO MAIN
;---------------------------------------------------------------------------------------
       END



;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
       
       