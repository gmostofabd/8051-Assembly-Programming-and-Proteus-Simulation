;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
;Serial I/O routines using the 8051's built-in UART.
;Tx Routine (only)
;Protocol: UART
;Baud Rate: 9600 BPS
;gmostofabd
;---------------------------------------------------------------------------------------
ORG 0000H		; LOCATION WHERE EXECUTION OF THE PROGRAM STARTS FROM
	LJMP MAIN	; LJMP USED TO BYPASS THE ISR

ORG 0023H		; LOCATION FOR ISR FOR BOTH TI AND RI
;	LJMP SERIAL	; THE CONTROL IS SHIFTED TO THE SERIAL SUBROUTINE
;---------------------------------------------------------------------------------------
ORG 30H			; LOCATION OF THE STARTING ADDRESS OF THE PROGRAM CODE 
MAIN: 
	MOV 	P1,#0FFH	; MAKES P1 INPUT PORT
	MOV 	P2,#00H		; MAKES P1 INPUT PORT
	
INIT_SERIAL:
	MOV 	TMOD, #20H	; SELECTS TIMER 1 MODE 2 FOR GENERATING BAUD RATE
 	MOV 	TH1, #0FDH	; (#-3 FOR 9600 #-6 FOR 4800) GENERATES A BAUD RATE OF 9600
  	MOV 	SCON, #50H	; (#253 DEC) SELECTS MODE 1 WITH THE RECEIVER ENABLED
   	SETB 	TR1
;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
LOOP:
      	MOV	A, #'A'
      	LCALL	SEND
      	MOV	A, #'a'
      	LCALL	SEND
      	MOV	A, #'1'
      	LCALL	SEND
	SJMP LOOP  
;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
SEND:
  	MOV 	SBUF, A 	;MOVE CONTENTS OF A TO THE SERIAL BUFFER - THIS INITIATES THE TRANSMISSION DOWN THE SERIAL LINE
STAY:
	JNB 	TI,STAY 	;WAIT FOR ENTIRE CHARACTER TO BE SENT DOWN SERIAL LINE
 	CLR 	TI 		;CLEAR THE TRANSMIT OVERFLOW
	ACALL 	DELAY
	ACALL 	DELAY
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

  END
  
  
;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
