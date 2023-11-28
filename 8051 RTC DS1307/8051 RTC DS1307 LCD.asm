
	SDA 	EQU 	P1.1
	SCL	EQU 	P1.0

	RS 	EQU 	P3.4    ;RS PIN CONNECTION
  	EN 	EQU 	P3.6    ;EN PIN CONNECTION
	PORT 	EQU 	P1      ;DATA PORT TO CONNECT LCD


	SEC	EQU  	30H 
	MIN	EQU	31H
	HOUR	EQU  	32H
	DAY	EQU	33H
	DATE	EQU	34H
	MONTH	EQU	35H
	YEAR	EQU 	36H
	AM 	EQU 	37H
  	U 	EQU 	38H       ;MEMORY LOCATION TO HOLD UPPER NIBBLE
  	L 	EQU 	39H 	;MEMORY LOCATION TO HOLD LOWER NIBBLE

	ADD_LOW	EQU 	40H
	RTC	EQU 	41H
	AHOUR	EQU 	42H
	AMIN	EQU 	43H
	ASEC	EQU 	44H
	CHOUR	EQU  	45H




ORG 100H
	MOV	SEC, #03
	MOV	MIN, #04
	MOV	HOUR, #05
	MOV	DAY, #06
	MOV	DATE, #07
	MOV	MONTH,#08
	MOV	YEAR, #09

  	ACALL 	LCD_INIT
  	LCALL	INIT_I2C
  	LCALL	WRITE_CUR_TIME

MAIN:	
	LCALL 	GET_TIME
	LCALL 	GET_AM
	LCALL 	MASK_HOUR
	LCALL	LCD_HOME
	LCALL 	DISP_TIME
	SJMP 	MAIN



WRITE_CUR_TIME:
	LCALL 	I2C_START		; GENERATE START CONDITION
	MOV	A, #0D0H	; 1101 0000 ADDRESS + WRITE-BIT
	LCALL	I2C_WRITE	; SEND BYTE TO 1307
	MOV	A, #0		; ADDRESS BYTE TO REGISTER 00H
	LCALL	I2C_WRITE	; SEND BYTE TO 1307

;	MOV     ADD_LOW,#0
	MOV	A,SEC
	MOV	RTC,A
	LCALL   I2C_WRITE
	
	MOV     ADD_LOW,#01
	MOV	RTC,MIN
;	MOV	RTC,A
	LCALL   I2C_WRITE

	MOV     ADD_LOW,#02
	MOV	A,HOUR
	MOV	RTC,A
	LCALL   I2C_WRITE

	MOV     ADD_LOW,#03
	MOV	A,DAY
	MOV	RTC,A
	LCALL   I2C_WRITE

	MOV     ADD_LOW,#04
	MOV	A,DATE
	MOV	RTC,A
	LCALL   I2C_WRITE

	MOV     ADD_LOW,#05
	MOV	A,MONTH
	MOV	RTC,A
	LCALL   I2C_WRITE


	MOV     ADD_LOW,#06
	MOV	A,YEAR
	MOV	RTC,A
	LCALL   I2C_WRITE



	LCALL	I2C_STOP

	RET




GET_TIME:
	LCALL 	I2C_START		; GENERATE START CONDITION
	MOV	A, #0D0H	; 1101 0000 ADDRESS + WRITE-BIT
	LCALL	I2C_WRITE	; SEND BYTE TO 1307
	MOV	A, #00H		; ADDRESS BYTE TO REGISTER 00H
	LCALL	I2C_WRITE	; SEND BYTE TO 1307

	MOV	A, #0D1H	; 1101 0001 ADDRESS + READ-BIT
	LCALL	I2C_WRITE	; SEND BYTE TO 1307
LCALL	I2C_STOP
	MOV     ADD_LOW,#00		;READS SECONDS
	LCALL   I2C_READ
	MOV 	SEC, A
LCALL	I2C_STOP
	MOV     ADD_LOW,#01		;READS MINUTES
	LCALL   I2C_READ
	MOV 	MIN, A
LCALL	I2C_STOP
	MOV     ADD_LOW,#02		;READS HOURS
	LCALL   I2C_READ
	MOV 	HOUR, A
LCALL	I2C_STOP
	MOV     ADD_LOW,#03		;READS DAYS
	LCALL   I2C_READ
	MOV 	DAY,A
LCALL	I2C_STOP
	MOV     ADD_LOW,#04		;READS DATE OF WEEK
	LCALL   I2C_READ
	MOV 	DATE,A
LCALL	I2C_STOP
	MOV     ADD_LOW,#05	;READS MONTHS
	LCALL   I2C_READ
;	MOV	A,RTC
	MOV 	MONTH,A
LCALL	I2C_STOP
	MOV     ADD_LOW,#06	;READS YEARS
	LCALL   I2C_READ
	MOV 	YEAR,RTC

	LCALL	I2C_STOP
	RET







DISP_TIME: 
	MOV DPTR, #TABLE
	
	MOV 	A, HOUR		
	LCALL	PRNT_4B

	MOV 	A, #':' 
	LCALL 	LCD_DATA

	MOV 	A, MIN
	LCALL	PRNT_4B

	MOV 	A, #':' 
	LCALL 	LCD_DATA

	MOV 	A, SEC
	LCALL	PRNT_4B	

	MOV 	A, #' ' 
	LCALL 	LCD_DATA
	

	LCALL 	AMPM

	MOV 	A, #' ' 
	LCALL 	LCD_DATA


	MOV	DPTR, #WEEK_DAYS
	MOV 	A, DAY 
	LCALL 	GET_DAY
	
	LCALL 	NEXT_LINE
	
	
	MOV DPTR, #TABLE
	
	MOV 	A,DATE
LCALL	PRNT_4B
	MOV 	A, #'/'
	LCALL 	LCD_DATA
	MOV 	A, MONTH
LCALL	PRNT_4B
	MOV 	A, #'/'
	LCALL 	LCD_DATA
	MOV 	A, YEAR
;LCALL	PRNT_4B
;	RET
PRNT_4B:
	MOV	R2,A
	ANL 	A, #0F0H
	SWAP 	A 
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, R2
	ANL 	A, #0FH
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	RET





MASK_HOUR:
	MOV 	A, HOUR
	ANL 	A, #1FH
	MOV 	CHOUR, A
	RET

GET_AM:	MOV 	A, HOUR
	ANL 	A, #20H
	MOV 	AM, A
	RET

AMPM: 	MOV 	A, AM 
	CJNE 	A, #00H, PM
	MOV 	A, #'a' 
	LCALL 	LCD_DATA
	JMP	MM
PM:	MOV 	A, #'p' 
	LCALL 	LCD_DATA

MM:	MOV 	A, #'m' 
	LCALL 	LCD_DATA
	RET




GET_DAY:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	MOV	DPTR, #WEEK_DAYS
PRINT_DAYS:	
    	MOVC 	A, @A+DPTR  ; Load the character at the address pointed by DPTR
	LCALL	LCD_DATA
	INC 	DPTR
	MOVX 	A, @DPTR
	LCALL	LCD_DATA
	INC 	DPTR
	MOVC 	A, @A+DPTR
	LCALL	LCD_DATA
	RET




; Initialize I2C
INIT_I2C:    SETB 	SDA ; Ensure SDA is high
             SETB 	SCL ; Ensure SCL is high
             RET


; **********************************************************
I2C_START:	
;	CLR 	SCL			; SEND START CONDITION
;	CLR 	SDA

;	SETB 	SCL
	SETB 	SDA
	NOP
	NOP
	NOP
	SETB 	SCL
	NOP
	NOP
	NOP
	CLR 	SCL
	NOP
	NOP
	NOP
	CLR 	SDA
	RET
; **********************************************************





I2C_STOP:
        CLR     SDA		;data low
	NOP
	NOP
	NOP
	SETB	SCL
	NOP
	NOP
	NOP
        SETB    SDA
	NOP
	NOP
	NOP
        RET
; **********************************************************


	

; Write data to DS1307
WRITE_DS1307: 
;	mov A, #0 ; Set seconds to 0 (for example)
 	LCALL I2C_START
  	MOV     A,#0D0H ; DS1307 address with write bit
  	LCALL 	I2C_WRITE
  	MOV 	A, #0 ; DS1307 register address
  	LCALL 	I2C_WRITE
  	MOV 	A, #0 ; Data to be written
  	LCALL 	I2C_WRITE
  	LCALL 	I2C_STOP
   	RET




; I2C WRITE BYTE
I2C_WRITE2:   
	MOV R2, #8      ; 8 BITS TO SEND
I2C_WRITE_LOOP:
        CLR     SCL ; ENSURE SCL IS LOW
	NOP
	NOP
	NOP
 	RLC A            ; ROTATE A LEFT THROUGH CARRY
  	MOV SDA, C   ; SET SDA ACCORDING TO THE ROTATED BIT
	NOP
	NOP
	NOP
        SETB     SCL ; CLOCK IN THE BIT
	NOP
	NOP
	NOP
 	DJNZ R2, I2C_WRITE_LOOP ; LOOP FOR 8 BITS
  	RET









I2C_WRITE:            
	CLR     SDA                   ;START BIT
        CLR     SCL
        MOV     A,#0D0H        ;SEND CONTROL BYTE
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,I2C_WRITE        ;LOOP UNTIL BUSY
        CLR     SCL
        MOV     A,ADD_LOW             ;SEND ADDRESS LOW
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,I2C_WRITE        ;LOOP UNTIL BUSY
        CLR     SCL
        MOV     A, RTC                ;SEND DAVAVA
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,I2C_WRITE        ;LOOP UNTIL BUSY
        CLR     SDA
        CLR     SCL
        SETB    SCL                   ;STOP BIT
        SETB    SDA
        RET

LOOP_BYTE:             
	PUSH    02H
        MOV     R2,#08H
LOOP_SEND:	RLC A
        MOV     SDA,C
        SETB    SCL
        CLR     SCL
        DJNZ    R2,LOOP_SEND
        POP     02H
        RET

I2C_READ:             
	CLR     SDA                   ;START BIT
        CLR     SCL
        MOV     A,#0D0H        ;SEND CONTROL BYTE
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,I2C_READ         ;LOOP UNTIL BUSY
        CLR     SCL
        MOV     A,ADD_LOW             ;SEND ADDRESS LOW
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,I2C_READ         ;LOOP UNTIL BUSY
        CLR     SCL
        SETB    SCL
        SETB    SDA
        CLR     SDA                   ;START BIT
        CLR     SCL
        MOV     A,#0D1H        ;SEND CONTROL BYTE
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,I2C_READ         ;LOOP UNTIL BUSY
        CLR     SCL
        LCALL   LOOP_READ
        SETB    SDA
        SETB    SCL
        CLR     SCL
	SETB    SCL                   ;STOP BIT
        SETB    SDA
        RET

LOOP_READ:             
	PUSH   02H
        MOV    R2,#08H
LOOP_READ1:            
	SETB   SCL
        MOV    C,SDA
        CLR    SCL
        RLC    A
        DJNZ   R2,LOOP_READ1
        MOV    RTC,A
        POP    02H
        RET




;++++++++++++++++++++++++++++++++++++++
LCD_INIT:
   	ACALL 	DELAY     	;SOME DELAY TO LCD AFTER POWER ON
   	ACALL 	DELAY
   	MOV 	PORT, #20H  	;SEND 20H TO LCD TO SET 4 BIT MODE
   	CLR 	RS   		;AFTER THAT WE CAN USE LCD_CMD
   	SETB 	EN         	;MAKE EN SWITCHING
   	ACALL 	DELAY
   	CLR 	EN
   	MOV 	A, #28H
   	ACALL 	LCD_CMD
   	MOV 	A, #0CH
   	ACALL 	LCD_CMD
   	MOV 	A, #06H
   	ACALL 	LCD_CMD
   	MOV 	A, #01H
   	ACALL 	LCD_CMD
   	RET
;++++++++++++++++++++++++++++++++++++++
LCD_HOME: 
	MOV 	A,#02H
	LCALL	LCD_CMD		;call command subroutine
	RET

LCD_CLR: 
	MOV 	A,#01H
	LCALL	LCD_CMD		;call command subroutine
	RET

NEXT_LINE: 
	MOV 	A,#0C0H
	LCALL	LCD_CMD		;call command subroutine
	RET
;++++++++++++++++++++++++++++++++++++++
LCD_CMD:
    	CLR 	RS     		;CLEAR RS, GOING TO SEND COMMAND
    	ACALL 	SEPARATOR     	;SEPARATE THE COMMAND AND SAVE TO U AND L
    	MOV 	A, U     	;COPY U TO A
    	ACALL 	MOVE_TO_PORT  	;MOVE CONTENT OF A TO PORT 
    	MOV 	A, L            ;COPY L TO A
    	ACALL 	MOVE_TO_PORT  	;MOVE CONTENT OF A TO PORT
    	RET       		;RETURN
;++++++++++++++++++++++++++++++++++++++
LCD_DATA:
   	SETB 	RS		;RS=1, GOING TO SEND DATA
   	ACALL 	SEPARATOR    	;SEPARATE THE DATA AND SAVE TO U & L
   	MOV 	A, U           	;COPY U TO A
   	ACALL 	MOVE_TO_PORT 	;SEND IT TO LCD
   	MOV 	A, L           	;COPY L TO A
   	ACALL 	MOVE_TO_PORT 	;SEND IT TO LCD
   	RET                	;RETURN
;++++++++++++++++++++++++++++++++++++++
SEPARATOR:
   	MOV 	U,A        	;SAVE A AT TEMP LOCATION U
   	ANL 	U,#0F0H    	;MASK IT  WITH 0FH (28H & F0H = 20H) 
   	SWAP 	A         	;SWAP NIBBLE (28H => 82H)
   	ANL 	A,#0F0H    	;MASK IT WITH 0FH (82H & F0H = 80H)
   	MOV 	L,A        	;SAVE IT AT TEMP LOCATION L
   	RET            		;RETURN
;++++++++++++++++++++++++++++++++++++++
MOVE_TO_PORT:
   	MOV 	PORT,A       	;PUT CONTENT OF A TO PORT
   	SETB 	EN    		;MAKE EN HIGH
   	ACALL 	DELAY   	;CALL A SHORT DELAY ROUTINE
   	CLR 	EN     		;CLEAR EN
   	ACALL 	DELAY   	;SHORT DELAY
   	RET     		;RETURN
;++++++++++++++++++++++++++++++++++++++







DELAY:
   	MOV 	R0, #10H
L2: 	MOV 	R1, #0FH
L1: 	DJNZ 	R1, L1
   	DJNZ 	R0, L2
   	RET
   	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DB - DEFINE BYTE (INITIALIZE THE MEMORY)
WEEK_DAYS:
;	DB 'ERR',0 
	DB 'MON',0 ;DAY NO 0
	DB 'TUE',0 ;DAY NO 1
	DB 'WED',0 ;DAY NO 2
	DB 'THU',0 ;DAY NO 3
	DB 'FRI',0 ;DAY NO 4
	DB 'SAT',0 ;DAY NO 5
	DB 'SUN',0 ;DAY NO 6


;+++++++++++++++++++++++++++++++++++++++
TABLE:  DB	'0'	;0 USING TABLE FOR ASCII CONVERSION 			
	DB	'1'	;1
	DB	'2'	;2
	DB	'3'	;3
	DB	'4'	;4
	DB	'5'	;5
	DB	'6'	;6
	DB	'7'	;7
	DB	'8'	;8
	DB	'9'	;9
	
	END