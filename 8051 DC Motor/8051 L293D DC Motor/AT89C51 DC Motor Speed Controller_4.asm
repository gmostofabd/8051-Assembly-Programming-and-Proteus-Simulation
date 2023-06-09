;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;EQU (equate): This is used to define a constant 
;without occupying a memory location.

;N1  EQU	30H	;#!RAM location holds first oeprand
;N2  EQU	31H	;#!RAM location holds SECOND oeprand
;OP  EQU	32H	;#!RAM location holds OPERATOR ASCII
;R   EQU	33H	;#!RAM location holds RESULT
;H  EQU	34H	;#!RAM location holds RESULT HIGH BYTE
;F  EQU	35H	;#!RAM location holds RESULTS FLOAT PART
;SIGN  EQU	36H	;#!RAM location holds RESULT SIGN
;TEMP EQU 	37H  ;holds temporary data


IO_DECLERATION:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RS EQU P2.0 ; RS ON LCD
EN EQU P2.1 ; EN ON LCD
NOVONUM EQU P2.7 ; P2.7 IS HIGH WHEN WRITING SECOND NUMBER
NOVODIG EQU P2.6 ; P2.6 IS LOW ONLY WHEN WRITING FIRST DIGIT OF A NUMBER
M1_F	EQU P2.2 ; 
M1_R	EQU P2.3 ; 
PWMPIN	EQU	P1.0
;M2_F	EQU P2.4 ; 
;M2_R	EQU P2.5 ; 
N1  	EQU	30H
N2  	EQU	31H
N3  	EQU	32H
N4  	EQU	33H
DUTY	EQU	34H
FREQ1	EQU	35H
FREQ2	EQU	36H
FREQ3	EQU	37H

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ORG	00H		;RESET VECTOR ADDRESS
	LJMP	MAIN	;JUMP TO MAIN PROGRAM
    ORG	000BH		;TIMER0 VECTOR ADDRESS
	LJMP 	ISR_T0 	;jump to ISR TIMER0
    ORG 001BH 		;Timer 1 int. vector table
	LJMP 	ISR_T1 	;jump to ISR TIMER1
    ORG	30H	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN:	
	CLR	N1
	CLR	M1_F
	CLR	M1_R
INITIALYZE:
	ACALL	REG_INIT
	ACALL	LCD_INIT
	ACALL	STARTUP_MSG

	ACALL	SETUP_TMR0
	ACALL	SETUP_TMR1
	SETB	P2.4
	
	;ACALL	READ_KEY

FREQ_DISP:

	MOV 	R0, #85H
	ACALL 	COMMAND

	MOV	A,FREQ1
	ADD 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD

	MOV	A,FREQ2
	ADD 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD

	MOV	A,FREQ3
	ADD 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD

	ACALL 	MOTOR_TEST
	AJMP	FREQ_DISP






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOTOR_TEST:
ACALL 	M1_ROTATE_F		;Rotate motor forward

ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY

ACALL 	M1_ROTATE_R

ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY


ACALL 	M1_ROTATE_B

ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY
ACALL   DELAY


MOTOR_75:
SETB	M1_F
MOV	N3,#25
ACALL   DELAY_A
CLR	M1_R
MOV	N3,#75
ACALL   DELAY_A


MOTOR_50:
SETB	M1_F
MOV	N3,#50
ACALL   DELAY_A
CLR	M1_R
MOV	N3,#50
ACALL   DELAY_A
;SJMP	MOTOR_75

RET


M1_ROTATE_F:
SETB	M1_F
CLR	M1_R
;SETB	EN1
RET

M1_ROTATE_R:
SETB	M1_R
CLR	M1_F
;SETB	EN1
RET


M1_ROTATE_B:
CLR	M1_R
CLR	M1_F
;CLR	EN1
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;READ_KEY:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SCANNING ALL COLUMN  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
L1:
	JNB 	P3.0, C1	;Jump if Condition Is Met
	JNB 	P3.1, C2
	JNB 	P3.2, C3
	JNB 	P3.3, C4
	SJMP 	L1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SCANNING COLUMN1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C1:
	JNB 	P3.4, JUMP_TO_7	
	JNB 	P3.5, JUMP_TO_4	
	JNB 	P3.6, JUMP_TO_1	
	JNB 	P3.7, JUMP_2CLR	
	SETB 	P3.0
	CLR 	P3.1
	SJMP 	L1
;SCANNING COLUMN2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C2:
	JNB 	P3.4, JUMP_TO_8	
	JNB 	P3.5, JUMP_TO_5	
	JNB 	P3.6, JUMP_TO_2	
	JNB 	P3.7, JUMP_TO_0	
	SETB 	P3.1
	CLR 	P3.2
	SJMP 	L1
;SCANNING COLUMN3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C3:
	JNB 	P3.4, JUMP_TO_9	
	JNB 	P3.5, JUMP_TO_6	
	JNB 	P3.6, JUMP_TO_3	
	JNB 	P3.7, JUMP_EQUAL	
	SETB 	P3.2
	CLR 	P3.3
	SJMP 	L1
;SCANNING COLUMN4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C4:
	JNB 	P3.4, JUMP_DIVIDE	;JUMP_DIVIDE
	JNB 	P3.5, JUMP_MULTI	;JUMP_MULTI
	JNB 	P3.6, JUMP_MINUS	;JUMP_MINUS
	JNB 	P3.7, JUMP_PLUS		;JUMP_PLUS
	SETB 	P3.3
	CLR 	P3.0
	LJMP 	L1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
JUMP_2CLR: 	LJMP 	JUMP_RFRESH
JUMP_TO_0: 	LJMP 	NUM_0
JUMP_TO_1: 	LJMP 	NUM_1
JUMP_TO_2: 	LJMP 	NUM_2
JUMP_TO_3: 	LJMP 	NUM_3
JUMP_TO_4: 	LJMP 	NUM_4
JUMP_TO_5: 	LJMP 	NUM_5
JUMP_TO_6: 	LJMP 	NUM_6
JUMP_TO_7: 	LJMP 	NUM_7
JUMP_TO_8: 	LJMP 	NUM_8
JUMP_TO_9: 	LJMP 	NUM_9
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
JUMP_PLUS: 	LJMP 	ADD_FUNC
JUMP_MINUS: 	LJMP 	SUB_FUNC
JUMP_MULTI: 	LJMP 	MUL_FUNC
JUMP_DIVIDE: 	LJMP	DIV_FUNC
JUMP_EQUAL: 	LJMP 	EQU_FUNC
JUMP_RFRESH: 
	MOV 	R0, #01H
	ACALL 	COMMAND
	;MOV 	R0, #0H
	;MOV 	R1, #00D
	;MOV 	R2, #00D
	;MOV 	R3, #00D
	;MOV 	R4, #00D
	;MOV 	R5, #00D
	;MOV 	R6, #00D
	LJMP 	L1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NUM_0:		;LOAD DECIMAL 0
	JNB 	P3.7,NUM_0
	MOV 	R0, #'0'	;MOVE CHARACTER 0 TO R0 REG	
	ACALL 	ASCII_2_DEC	;SUBROUTINE CONVERT TO ASCII
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

NUM_1:		;LOAD DECIMAL 1 
	JNB 	P3.6,NUM_1			
	MOV 	R0, #'1'
	ACALL 	ASCII_2_DEC	;SUBROUTINE CONVERT TO ASCII
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

NUM_2:		;LOAD DECIMAL 2		
	JNB 	P3.6,NUM_2
	MOV 	R0, #'2'
	ACALL 	ASCII_2_DEC	;SUBROUTINE CONVERT TO ASCII	
	ACALL 	DISPLAY		;PRINT ON LCD	
	LJMP 	L1

NUM_3:		;LOAD DECIMAL 3
	JNB 	P3.6,NUM_3
	MOV 	R0, #'3'
	ACALL 	ASCII_2_DEC	;SUBROUTINE CONVERT TO ASCII	
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

NUM_4:		;LOAD DECIMAL 4
	JNB 	P3.5,NUM_4
	MOV 	R0, #'4'
	ACALL 	ASCII_2_DEC	;SUBROUTINE CONVERT TO ASCII
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

NUM_5:		;LOAD DECIMAL 5
	JNB 	P3.5,NUM_5
	MOV 	R0, #'5'
	ACALL 	ASCII_2_DEC	;SUBROUTINE CONVERT TO ASCII	
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

NUM_6:		;LOAD DECIMAL 6
	JNB 	P3.5,NUM_6
	MOV 	R0, #'6'
	ACALL 	ASCII_2_DEC	;SUBROUTINE CONVERT TO ASCII
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

NUM_7:		;LOAD DECIMAL 7
	JNB 	P3.4,NUM_7
	MOV 	R0, #'7'
	ACALL 	ASCII_2_DEC	;SUBROUTINE CONVERT TO ASCII	
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

NUM_8:		;LOAD DECIMAL 8
	JNB 	P3.4,NUM_8	
	MOV 	R0, #'8'
	ACALL 	ASCII_2_DEC	;SUBROUTINE CONVERT TO ASCII	
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

NUM_9:		;LOAD DECIMAL 9
	JNB 	P3.4,NUM_9
	MOV 	R0, #'9'
	ACALL 	ASCII_2_DEC	;SUBROUTINE CONVERT TO ASCII		
	ACALL 	DISPLAY
	LJMP 	L1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EQU_FUNC:	;LOAD = SIGN
	JNB 	P3.7,EQU_FUNC
	MOV 	R0, #'='			
	ACALL 	DISPLAY
	ACALL 	RESULT		;SUBRUTINE DO RESULT	
	LJMP 	L1

ADD_FUNC: 	;LOAD + SIGN
	JNB 	P3.7,ADD_FUNC
	MOV 	R0, #'+'
	ACALL 	OPERATOR	;CALL OPERATORS FUNCTION	
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

SUB_FUNC:	;LOAD - SIGN
	JNB 	P3.6,SUB_FUNC
	MOV 	R0, #'-'
	ACALL 	OPERATOR	;CALL OPERATORS FUNCTION
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

MUL_FUNC:	;LOAD * SIGN
	JNB 	P3.5,MUL_FUNC
	MOV 	R0, #'*'
	ACALL 	OPERATOR	;CALL OPERATORS FUNCTION
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

DIV_FUNC:	;LOAD / SIGN
	JNB 	P3.4,DIV_FUNC
	MOV 	R0, #'/'
	ACALL 	OPERATOR	;CALL OPERATORS FUNCTION	
	ACALL 	DISPLAY		;PRINT ON LCD
	LJMP 	L1

OPERATOR:
	SETB 	NOVONUM
	CLR 	NOVODIG
	MOV 	A, R0		;MOVE VALUE TO ACUMULATOR
	MOV 	R2, A
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASCII_2_DEC:	;CONVERT DECIMAL TO ASCII
	JB 	NOVONUM, SECOND_NUMBER	;JUMP IF IT'S THE SECOND NUMBER
	JB 	NOVODIG, NEW_DIGIT	;JUMPS IF NOT THE FIRST DIGIT OF THE FIRST NUMBER
	MOV 	A, R0		;MOVE VALUE TO ACUMULATOR
	SUBB 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R1, A		;SAVE THIS NUMBER IN REGISTER R1
	SETB 	NOVODIG		;SET PIN NOVODIG => FIRST DIGIT OF FIRST NUMBER HAS BEEN SAVED
	RET


NEW_DIGIT: 
	MOV 	A, R0			;MOVE VALUE TO ACUMULATOR (0)
	MOV 	B, #10D			;MOVE A CONSTANT 10 TO ACUMULADOR AUXILIARY
	SUBB 	A, #30H			;MOVE VALUE TO ACUMULATOR
	MOV 	R7, A			;MOVES RESULT TO REGISTER R7
	MOV 	A, R1			;MOVE VALUE TO ACUMULATOR
	MUL 	AB			;MULTIPLY THE CURRENT NUMBER BY 10 
	MOV 	R6, B 			;KEEPS THE MOST SIGNIFICANT PART IN R6
	CJNE 	R6, #00H, JUMP_BURST	;IF THERE IS ANY VALUE IN B OR R6, IT EXCEEDS 8 BITS
	ADD 	A, R7			;MOVE VALUE TO ACUMULATOR
	JC 	JUMP_BURST		;IF CARRY IS 1, THE SUM EXCEEDED 8 BITS (JUMP TO LABEL OVERFLOW)
	MOV 	R1, A			;MOVES RESULT FROM FIRST NUMBER TO REGISTER R1
	SETB 	NOVODIG			;SET PIN NEWDIG => NEW NUMBER HAS BEEN SAVED
	RET



SECOND_NUMBER:
	JB 	NOVODIG, NOVODIGITO2
	MOV 	A, R0		;MOVE VALUE TO ACUMULATOR
	SUBB 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R3, A
	SETB 	NOVODIG
	RET

NOVODIGITO2:
	MOV 	A, R0		;MOVE VALUE TO ACUMULATOR
	MOV 	B, #10D
	SUBB 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R7, A
	MOV 	A, R3		;MOVE VALUE TO ACUMULATOR
	MUL 	AB
	MOV 	R6, B
	CJNE 	R6, #00H, JUMP_BURST
	ADD 	A, R7		;MOVE VALUE TO ACUMULATOR
	JC 	JUMP_BURST
	MOV 	R3, A
	SETB 	NOVODIG
	RET



RESULT:
ADD_BYTES:
	CJNE 	R2, #'+', SUB_BYTES
	MOV 	A, R1		;MOVE VALUE TO ACUMULATOR
	CLR 	C
	ADD 	A, R3		;MOVE VALUE TO ACUMULATOR
	JC 	JUMP_BURST
	MOV 	R5, #0H
	MOV 	R4, A
	LJMP 	TO_PRINT


SUB_BYTES:
	CJNE 	R2, #'-', MUL_BYTES
	MOV 	A, R1		;MOVE VALUE TO ACUMULATOR
	CLR 	C
	SUBB 	A, R3		;MOVE VALUE TO ACUMULATOR
	JC 	JUMP_BURST
	MOV 	R5, #0H
	MOV 	R4, A
	LJMP 	TO_PRINT


MUL_BYTES:
	CJNE 	R2, #'*', DIV_BYTES
	MOV 	A, R1		;MOVE VALUE TO ACUMULATOR
	MOV 	B, R3
	MUL 	AB
	MOV 	R7, B
	CJNE 	R7, #0H, ERRORS
	MOV 	R5, #0H
	MOV 	R4, A
	LJMP 	TO_PRINT

DIV_BYTES:
	MOV 	A, R1		;MOVE VALUE TO ACUMULATOR
	MOV 	B, R3
	DIV 	AB
	MOV 	R4, A
	MOV 	R5, B
	LJMP 	TO_PRINT

JUMP_BURST: 	LJMP ERRORS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TO_PRINT:
	CJNE 	R3, #0D, NORMAL
	CJNE 	R2, #'/', NORMAL
	MOV 	R0, #0C0H
	ACALL 	COMMAND
	MOV 	DPTR, #MSG_ERR_0
	CLR 	C
	MOV 	R7, #0D
PROX:	
	MOV 	A, R7		;MOVE VALUE TO ACUMULATOR
	MOVC 	A, @A+DPTR	; Load DPTR with Control port Address
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD
	INC 	R7
	JNZ 	PROX
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ERRORS:
	MOV 	R0, #0C0H
	ACALL 	COMMAND
	MOV 	DPTR, #MSG_ERR_1
	CLR 	C
	MOV 	R7, #0D

PROX2:	
	MOV 	A, R7
	MOVC 	A, @A+DPTR	;MOVE VALUE TO ACUMULATOR
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD
	JZ 	FIM
	INC 	R7
	SJMP 	PROX2

FIM:
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NORMAL:	
	MOV 	R7, #100D
	CLR 	C
	SUBB 	A, R7		;MOVE VALUE TO ACUMULATOR
	JC 	MENOR100
	MOV 	A, R4		;MOVE VALUE TO ACUMULATOR
	MOV 	B, R7
	DIV 	AB
	ADD 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD
	MOV 	R4, B
	MOV 	A, B		;MOVE VALUE TO ACUMULATOR
	MOV 	R7, #10D
	MOV 	B, R7
	DIV 	AB
	ADD 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD
	MOV 	A, B		;MOVE VALUE TO ACUMULATOR
	ADD 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD
	CJNE 	R5, #00H, DECIMAL
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MENOR100: 
	MOV 	R7, #10D
	CLR 	C
	MOV 	A, R4		;MOVE VALUE TO ACUMULATOR
	SUBB 	A, R7
	JC 	MENOR10
	MOV 	A, R4		;MOVE VALUE TO ACUMULATOR
	MOV 	B, R7
	DIV 	AB
	ADD 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD
	MOV 	A, B		;MOVE VALUE TO ACUMULATOR
	ADD 	A, #30H
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD
	CJNE 	R5, #00H, DECIMAL
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MENOR10:
	MOV 	A, R4		;MOVE VALUE TO ACUMULATOR
	ADD 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD
	CJNE 	R5, #00H, DECIMAL
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DECIMAL: 
	MOV 	R0, #'.'
	ACALL 	DISPLAY		;PRINT ON LCD
	MOV 	A, R5		;MOVE VALUE TO ACUMULATOR
	MOV 	B, #10D
	MUL 	AB
	MOV 	B, R3
	DIV 	AB
	ADD 	A, #30H		;MOVE VALUE TO ACUMULATOR
	MOV 	R0, A
	ACALL 	DISPLAY		;PRINT ON LCD
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
REG_INIT:
	CLR	A		;#!Clear ACC
	MOV 	R0, A
	MOV 	R1, A
	MOV 	R2, A
	MOV 	R3, A
	MOV 	R4, A
	MOV 	R5, A
	MOV 	R6, A
	MOV 	R7, A
PORT_INIT:
	MOV 	P0, A
	MOV 	P1, A
	MOV 	P2, A
	MOV 	P3, #0FEH
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LCD 8 BIT INTERFACE ROUTINES_____________________________
LCD_INIT:
	MOV 	R0,#38H		;Use 2 lines and 5x7 matrix
	ACALL 	COMMAND		;call command subroutine
	MOV 	R0,#0EH		;LCD ON, cursor ON, cursor blinking OFF
	ACALL 	COMMAND		;call command subroutine
	MOV 	R0,#01H		;Clear screen
	ACALL 	COMMAND		;call command subroutine
	MOV 	R0,#06H 	;Increment cursor
	ACALL 	COMMAND		;call command subroutine
	MOV 	R0,#80H		;Cursor line one , position 0
	ACALL 	COMMAND		;call command subroutine
	MOV 	R0,#3CH 	;Activate second line
	ACALL 	COMMAND		;call command subroutine
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
COMMAND:
	MOV 	P0, R0		;PUT A COMMAND TO LCD PORT
	CLR 	RS		;RS=0, going to send command
	SETB 	EN		;ENABLE PIN HIGH
	ACALL 	DELAY		;CALL DELAY
	CLR 	EN		;ENABLE PIN LOW
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAY:
	MOV 	P0, R0		;PUT A DATA TO LCD PORT
	SETB 	RS		;;RS=1, going to send DATA
	SETB 	EN		;ENABLE PIN HIGH
	ACALL 	DELAY		;CALL DELAY
	CLR 	EN		;ENABLE PIN LOW
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STARTUP_MSG:		
	MOV 	R0, #01H
	ACALL 	COMMAND
	MOV	DPTR, #MSG_START
DO_LOOP1:	
	CLR	A
	MOVC	A, @A+DPTR
	MOV 	R0, A
	JZ	EXIT1
	ACALL 	DISPLAY			;call display subroutine
	INC	DPTR
	SJMP	DO_LOOP1
EXIT1:
	ACALL 	DELAY
	ACALL 	DELAY
	MOV 	R0, #01H
	ACALL 	COMMAND	;absolute call at the indicated code add
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DELAY_A:			;APPROX DELAY DE 0.25s
DELAY_A1:	MOV 	N1, #100
DELAY_A2:	MOV 	N2, #255
DELAY_A3:	
	DJNZ	N2,DELAY_A3
	DJNZ 	N1, DELAY_A2
	DJNZ 	N3, DELAY_A1
	RET





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DELAY:	MOV 	62, #2		;APPROX DELAY DE 0.25s
DELAY1:	MOV 	61, #100
DELAY2:	MOV 	60, #250
	DJNZ 	60, $
	DJNZ 	61, DELAY2
	DJNZ 	62, DELAY1
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DB - DEFINE BYTE (INITIALIZE THE MEMORY)
;ORG	200H
MSG_START: DB 	'DC MOTOR CONTROL',0   ;START MESSAGE
MSG_ERR_0: DB 	'ERROR: DIV BY 0',0     ;ERROR MESSAGE 0 - DIV BY 0
MSG_ERR_1: DB 	'OVERFLOW!',0	      ;ERROR MESSAGE 1 - OVERFLOW
;KCODE0: DB 	"7","8","9","/" 				;#!ROW 0
;KCODE1: DB 	"4","5","6","*" 				;#!ROW 1
;KCODE2: DB 	"1","2","3","-" 				;#!ROW 2
;KCODE3: DB 	0,"0","=","+" 					;#!ROW 3


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SETUP_TMR0:
	;MOV 	TMOD,#00H
	MOV 	DUTY,#150	;160 D WAS EXAMPLE VALUE
	SETB	EA		;mode 1 of Timer0  
	SETB	ET0		;enable timer 0 interrupt  
	SETB	TR0		;start TIMER0 (TIMER)  
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SETUP_TMR1:
	MOV 	TMOD,#10H  	;Sets TMR1 AS counter & TMR0 AS timer
	MOV 	TL1,#0H   	;loads initial value to TL1
	MOV 	TH1,#0H   	;loads initial value to TH1
	SETB	ET0		;enable timer 0 interrupt
	SETB 	TR1             ;starts TIMER1(counter) 
	;CLR 	TR1             ;stops Timer(counter)1
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
	SETB	PWMPIN
	MOV	TH0,DUTY
	MOV	TL0,#00H
	CLR	TF0
	RETI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HIGH_DONE:
	CLR	F0
	CLR	PWMPIN
	MOV	A,#0FFH
	CLR	C
	SUBB	A,DUTY
	MOV	TH0,A
	MOV	TL0,#00H
	CLR	TF0
	RETI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ISR_T1:
	;CLR TR1              	; stops Timer(counter)1
	CLR TR0              	; stops Timer(counter)1
HERE:
	;MOV	TH1,#00H
	;MOV	TL1,#00H
	;JB 	P2.4, HERE
	CPL 	P2.5 		; complement the bit value at P1.0
HERE1:
	;JB	P2.4, HERE1
	MOV 	A,TL1		;#123D
       	MOV 	B,#100D
       	DIV 	AB              ; isolates the first digit of the count
	MOV	FREQ1,A
       	MOV 	A,B
       	MOV 	B,#10D
       	DIV 	AB              ; isolates the secong digit of the count
	MOV	FREQ2,A
       	MOV 	A,B             ; moves the last digit of the count to accumulator
	MOV	FREQ3,A
	CLR 	TF0             ; clears Timer Flag 0
	CLR 	TF1             ; clears Timer Flag 1
	RETI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



