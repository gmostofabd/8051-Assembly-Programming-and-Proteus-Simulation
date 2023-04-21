;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;EQU (equate): This is used to define a constant 
;without occupying a memory location.
IO_DECLERATION:
    	LCD_PORT EQU	P3
    	RS 	EQU 	P2.0 ; RS ON LCD
	EN 	EQU 	P2.1 ; EN ON LCD
    	U	EQU	30H
    	L	EQU	31H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    ORG	00H		;RESET VECTOR ADDRESS
	LJMP	MAIN	;JUMP TO MAIN PROGRAM
    ORG	30H
    
MAIN:    	
	ACALL	REG_INIT
	ACALL	PORT_INIT
	ACALL	LCD_INIT
	ACALL	STARTUP_MSG
	ACALL	STARTUP_MSG1
	SJMP	$
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
REG_INIT:
	MOV 	R0, #00H
	MOV 	R1, #00H
	MOV 	R2, #00H
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PORT_INIT:
	MOV 	P0, #00H
	MOV 	P1, #00H
	MOV 	P2, #00H
	MOV 	LCD_PORT, #00H
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LCD 8 BIT INTERFACE ROUTINES_____________________________
LCD_INIT:
	ACALL 	DELAY		;CALL DELAY
	MOV 	LCD_PORT,#20H		;Use 2 lines and 5x7 matrix
	CLR 	RS
	SETB 	EN		;ENABLE PIN HIGH
	ACALL 	DELAY		;CALL DELAY
	CLR 	EN		;ENABLE PIN LOW
	
	MOV 	R0,#28H		;Use 2 lines and 5x7 matrix
	ACALL 	COMMAND		;call command subroutine

	MOV 	R0,#0EH		;LCD ON, cursor ON, cursor blinking OFF
	ACALL 	COMMAND		;call command subroutine
	MOV 	R0,#06H 	;Increment cursor
	ACALL 	COMMAND		;call command subroutine
	MOV 	R0,#01H		;Clear screen
	ACALL 	COMMAND		;call command subroutine
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
COMMAND:
	ACALL 	SEPERATOR     	;separate U and L NIBBLES
	CLR 	RS		;RS=0, going to send command
	MOV	R0,U
	ACALL	MOVE_TO_PORT
	MOV	R0,L
	ACALL	MOVE_TO_PORT
	RET	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAY:
	ACALL 	SEPERATOR     	;separate U and L NIBBLES
	SETB 	RS		;RS=1, going to send DATA
	MOV	R0,U
	ACALL	MOVE_TO_PORT
	MOV	R0,L
	ACALL	MOVE_TO_PORT
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SEPERATOR:
	MOV	A,R0
   	MOV 	U,A        	;save A at temp location U
   	ANL 	U,#0F0H    	;mask it  with 0Fh (28h & F0h = 20h) 
   	SWAP 	A         	;swap nibble (28h => 82H)
   	ANL 	A,#0F0H    	;mask it with 0fh (82h & f0h = 80h)
   	MOV 	L,A        	;save it at temp location L
   	RET            		;return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVE_TO_PORT:
	MOV	LCD_PORT,R0	
	SETB 	EN		;ENABLE PIN HIGH
	ACALL 	DELAY		;CALL DELAY
	CLR 	EN		;ENABLE PIN LOW
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STARTUP_MSG:
	MOV 	R0, #083H
	ACALL 	COMMAND
	MOV 	R0, #'H'
	ACALL 	DISPLAY		;call display subroutine
	MOV 	R0, #'E'
	ACALL 	DISPLAY
	MOV 	R0, #'L'
	ACALL 	DISPLAY
	MOV 	R0, #'L'
	ACALL 	DISPLAY
	MOV 	R0, #'O'
	ACALL 	DISPLAY
	MOV 	R0, #' '
	ACALL 	DISPLAY
	MOV 	R0, #'W'
	ACALL 	DISPLAY
	MOV 	R0, #'O'
	ACALL 	DISPLAY
	MOV 	R0, #'R'
	ACALL 	DISPLAY
	MOV 	R0, #'L'
	ACALL 	DISPLAY
	MOV 	R0, #'D'
	ACALL 	DISPLAY
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STARTUP_MSG1:
	MOV 	R0, #0C4H
	ACALL 	COMMAND
	MOV	DPTR, #MSG_START1
DO_LOOP1:	
	CLR	A
	MOVC	A, @A+DPTR
	MOV 	R0, A
	JZ	EXIT1
	ACALL 	DISPLAY		;call display subroutine
	INC	DPTR
	SJMP	DO_LOOP1
EXIT1:
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DELAY:	MOV 	62, #2		;APPROX DELAY DE 0.25s
DELAY1:	MOV 	61, #100
DELAY2:	MOV 	60, #250
	DJNZ 	60, $
	DJNZ 	61, DELAY2
	DJNZ 	62, DELAY1
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORG	200H
	MSG_START1: DB 	'LCD 4 BIT',0   ;START MESSAGE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






