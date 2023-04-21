
  	U EQU 31        ;MEMORY LOCATION TO HOLD UPPER NIBBLE
  	L EQU 32 	;MEMORY LOCATION TO HOLD LOWER NIBBLE

SDA 	EQU 	P1.1
SCL	EQU 	P1.0

DS1307W  EQU    0D0H    ; SLAVE ADDRESS 1101 000 + 0 TO WRITE
DS1307R  EQU    0D1H    ; SLAVE ADDRESS 1101 000 + 1 TO READ

ORG 0000H


	PASS 	EQU 20H
	AM 	EQU 23H
	CONT_BYTE_W	EQU 0D0H
	CONT_BYTE_R	EQU 0D1H

	PORT 	EQU 	P1      ;DATA PORT TO CONNECT LCD
	RS 	EQU 	P3.4    ;RS PIN CONNECTION
  	EN 	EQU 	P3.6    ;EN PIN CONNECTION

	ORG 	060H

	ADD_LOW	EQU 	62H
	RTC	EQU 	63H
	SEC	EQU  	64H 
	MIN	EQU	65H
	HOUR	EQU  	66H
	DAY	EQU	67H
	DATE	EQU	68H
	MONTH	EQU	69H
	YEAR	EQU 	6AH
	AHOUR	EQU 	70H
	AMIN	EQU 	72H
	ASEC	EQU 	73H
	CHOUR	EQU  	74H

ORG 0100H
	MOV TMOD,#01H
	MOV ASEC, #01H
	MOV DPTR, #TABLE

	LCALL START
  	ACALL 	LCD_INIT

MAIN:	
	LCALL 	GET_TIME
	LCALL 	GET_AM
	LCALL 	MASK_HOUR
	LCALL	LCD_HOME
	LCALL 	DISP_TIME
	SJMP 	MAIN

GET_TIME:
	LCALL 	START		; GENERATE START CONDITION
	MOV	A, #CONT_BYTE_W	; 1101 0000 ADDRESS + WRITE-BIT
	LCALL	WRITE_BYTE	; SEND BYTE TO 1307
	MOV	A, #00H		; ADDRESS BYTE TO REGISTER 00H
	LCALL	WRITE_BYTE	; SEND BYTE TO 1307
	MOV	A, CONT_BYTE_R	; 1101 0001 ADDRESS + READ-BIT
	LCALL	WRITE_BYTE	; SEND BYTE TO 1307
	MOV     ADD_LOW,#00H		;READS SECONDS
	LCALL   READ_BYTE
	MOV 	SEC, RTC
	LCALL	I2C_STOP
	MOV     ADD_LOW,#01H		;READS MINUTES
	LCALL   READ_BYTE
	MOV 	MIN, RTC
	LCALL	I2C_STOP
	MOV     ADD_LOW,#02H		;READS HOURS
	LCALL   READ_BYTE
	MOV 	HOUR, RTC
	LCALL	I2C_STOP
	MOV     ADD_LOW,#03H		;READS DAYS
	LCALL   READ_BYTE
	MOV 	DAY,RTC
	LCALL	I2C_STOP
	MOV     ADD_LOW,#04H		;READS DATE OF WEEK
	LCALL   READ_BYTE
	MOV 	DATE,RTC
	LCALL	I2C_STOP
	MOV     ADD_LOW,#05H		;READS MONTHS
	LCALL   READ_BYTE
	MOV 	MONTH,RTC
	LCALL	I2C_STOP
	MOV     ADD_LOW,#06H		;READS YEARS
	LCALL   READ_BYTE
	MOV 	YEAR,RTC
	LCALL	I2C_STOP
	MOV     ADD_LOW,#08H		;READS ALARM HOURS
	LCALL   READ_BYTE
	MOV 	AHOUR,RTC
	LCALL	I2C_STOP
	MOV     ADD_LOW,#09H		;READS ALARM MINS
	LCALL   READ_BYTE
	MOV 	AMIN,RTC
	LCALL	I2C_STOP
	RET

DISP_TIME: 	
	MOV 	A, CHOUR		
	ANL 	A, #0F0H
	SWAP 	A 
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, CHOUR
	ANL 	A, #0FH
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, #':' 
	LCALL 	LCD_DATA
	MOV 	A, MIN
	ANL 	A, #0F0H
	SWAP 	A 
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, MIN
	ANL 	A, #0FH
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, #':' 
	LCALL 	LCD_DATA
	MOV 	A, SEC
	ANL 	A, #0F0H
	SWAP 	A 
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, SEC
	ANL 	A, #0FH
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	LCALL 	AMPM
	MOV 	A, #' ' 
	LCALL 	LCD_DATA
	MOV 	A, DAY 
	LCALL 	GET_DAY
	
	LCALL 	NEXT_LINE
	MOV 	A,MONTH
	ANL 	A,#0F0H
	SWAP 	A 
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, MONTH
	ANL 	A, #0FH
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, #'/'
	LCALL 	LCD_DATA
	MOV 	A, DATE
	ANL 	A, #0F0H
	SWAP 	A 
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, DATE
	ANL 	A, #0FH
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, #'/'
	LCALL 	LCD_DATA
	MOV 	A, YEAR
	ANL 	A, #0F0H
	SWAP 	A 
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, YEAR
	ANL 	A, #0FH
	MOVC 	A, @A+DPTR
	LCALL 	LCD_DATA
	MOV 	A, #' '
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
	MOV 	A, #'A' 
	LCALL 	LCD_DATA
	MOV 	A, #'M' 
	LCALL 	LCD_DATA
	RET
PM:	MOV 	A, #'P' 
	LCALL 	LCD_DATA
	MOV 	A, #'M' 
	LCALL 	LCD_DATA
	RET

; **********************************************************
START:	CLR 	SCL			; SEND START CONDITION
	CLR 	SDA

	SETB 	SCL
	SETB 	SDA
	NOP
	NOP
	NOP
	CLR 	SDA
	RET
; **********************************************************
I2C_STOP:
        CLR     SDA		;data low
	SETB	SCL
	NOP
	NOP
	NOP
        SETB    SDA
        RET
; **********************************************************

WRITE_BYTE:            
	CLR     SDA                   ;START BIT
        CLR     SCL
        MOV     A,#CONT_BYTE_W        ;SEND CONTROL BYTE
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,WRITE_BYTE        ;LOOP UNTIL BUSY
        CLR     SCL
        MOV     A,ADD_LOW             ;SEND ADDRESS LOW
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,WRITE_BYTE        ;LOOP UNTIL BUSY
        CLR     SCL
        MOV     A, RTC                ;SEND DAVAVA
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,WRITE_BYTE        ;LOOP UNTIL BUSY
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

READ_BYTE:             
	CLR     SDA                   ;START BIT
        CLR     SCL
        MOV     A,#CONT_BYTE_W        ;SEND CONTROL BYTE
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,READ_BYTE         ;LOOP UNTIL BUSY
        CLR     SCL
        MOV     A,ADD_LOW             ;SEND ADDRESS LOW
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,READ_BYTE         ;LOOP UNTIL BUSY
        CLR     SCL
        SETB    SCL
        SETB    SDA
        CLR     SDA                   ;START BIT
        CLR     SCL
        MOV     A,#CONT_BYTE_R        ;SEND CONTROL BYTE
        LCALL   LOOP_BYTE
        SETB    SDA
        SETB    SCL
        JB      SDA,READ_BYTE         ;LOOP UNTIL BUSY
        CLR     SCL
        LCALL   LOOP_READ
        SETB    SDA
        SETB    SCL
        CLR     SCL
	SETB    SCL                   ;STOP BIT
        SETB    SDA
        RET

GET_DAY: CJNE 	A,#00000001B,MON
         LCALL 	MONDAY
	 RET
MON:	 CJNE 	A,#00000010B,TUE
         LCALL 	TUESDAY 
	 RET
TUE:	 CJNE 	A,#00000011B,WED
         LCALL 	WEDNESDAY
	 RET
WED:     CJNE 	A,#00000100B,THU        
         LCALL 	THURSDAY  
	 RET
THU:     CJNE 	A,#00000101B,FRI
       	 LCALL 	FRIDAY
	 RET
FRI:     CJNE 	A,#00000110B,SAT
      	 LCALL 	SATURDAY 
	 RET
SAT:     CJNE 	A,#00000111B,WHAT
         LCALL 	SUNDAY 
	 RET

WHAT:	 NOP
	 RET

MONDAY: 
	MOV 	A, #'M' 
	LCALL 	LCD_DATA
	MOV 	A, #'O' 
	LCALL 	LCD_DATA
	MOV 	A, #'N'
	LCALL 	LCD_DATA
	RET

 
TUESDAY: 
	MOV 	A, #'T' 
	LCALL 	LCD_DATA
	MOV 	A, #'U' 
	LCALL 	LCD_DATA
	MOV 	A, #'E'
	LCALL 	LCD_DATA
	MOV 	A, #'S' 
	LCALL 	LCD_DATA
	RET

WEDNESDAY: 
	MOV 	A, #'W' 
	LCALL 	LCD_DATA
	MOV 	A, #'E' 
	LCALL 	LCD_DATA
	MOV 	A, #'D'
	LCALL 	LCD_DATA
	RET

THURSDAY: 
	MOV 	A, #'T' 
	LCALL 	LCD_DATA
	MOV 	A, #'H' 
	LCALL 	LCD_DATA
	MOV 	A, #'U'
	LCALL 	LCD_DATA
	MOV 	A, #'R' 
	LCALL 	LCD_DATA
	MOV 	A, #'S' 
	LCALL 	LCD_DATA
	RET

FRIDAY: 
	MOV 	A, #'F' 
	LCALL 	LCD_DATA
	MOV 	A, #'R' 
	LCALL 	LCD_DATA
	MOV 	A, #'I'
	LCALL 	LCD_DATA
	RET

SATURDAY: 
	MOV 	A, #'S' 
	LCALL 	LCD_DATA
	MOV 	A, #'A' 
	LCALL 	LCD_DATA
	MOV 	A, #'T'
	LCALL 	LCD_DATA
	RET

SUNDAY: 
	MOV 	A, #'S' 
	LCALL 	LCD_DATA
	MOV 	A, #'U' 
	LCALL 	LCD_DATA
	MOV 	A, #'N'
	LCALL 	LCD_DATA
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