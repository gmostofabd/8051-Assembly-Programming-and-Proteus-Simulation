;====================================================
;====================================================
ORG 0000H
AJMP START

     SDA       BIT   P2.1
     SCL       BIT   P2.0

;====================================================
     LCD_ADDR EQU 04EH  ; if fail try 07EH
     RTC_W    EQU 0D0H
     RTC_R    EQU 0D1H

;====================================================
;====================================================

;---------------- VARIABLES ----------------
     SEC     EQU   30H 
     MIN     EQU   31H
        HOUR    EQU   32H
        DAY     EQU   33H
        DATE    EQU   34H
        MONTH   EQU   35H
        YEAR    EQU   36H
        AM      EQU   37H
        TEMP    EQU   38H
	CHOUR	EQU   39H
	
        MENU_STATE EQU 50H
        KEY_VAL    EQU 51H
;====================================================
;====================================================

START:
    MOV    SP,#70H
    SETB   P2.2

    MOV    MENU_STATE,#00H
    ACALL  I2C_INIT
    
    ACALL  LCD_INIT
    ACALL  BELL_CHAR
    ACALL  STARTUP_MSG

;    ACALL WRITE_CUR_TIME


;====================================================
; MAIN LOOP (MODIFIED ONLY HERE)
;====================================================
MAIN_LOOP:
    ACALL       DELAY_20MS

RTCTIMEUPDATE:
    ACALL       RTC_READ
    ACALL 	MASK_HOUR
    ACALL       DISPLAY_TIME
     
    LJMP        MAIN_LOOP
;====================================================
;====================================================



;====================================================
; RTC READ (DS1307)
;====================================================
RTC_READ:
    ACALL I2C_START
    MOV   A,#RTC_W
    ACALL I2C_WRITE
    MOV   A,#00H
    ACALL I2C_WRITE

    ACALL I2C_START
    MOV   A,#RTC_R
    ACALL I2C_WRITE

    ACALL I2C_READ
    MOV   SEC,A
    ACALL I2C_ACK

    ACALL I2C_READ
    MOV   MIN,A
    ACALL I2C_ACK

    ACALL I2C_READ
    MOV   HOUR,A
    ACALL I2C_ACK

    ACALL I2C_READ
    MOV   DAY,A
    ACALL I2C_ACK

    ACALL I2C_READ
    MOV   DATE,A
    ACALL I2C_ACK

    ACALL I2C_READ
    MOV   MONTH,A
    ACALL I2C_ACK

    ACALL I2C_READ
    MOV   YEAR,A
    ACALL I2C_NACK

    ACALL I2C_STOP
    RET




DISPLAY_TIME:
        MOV     A,#080H
        ACALL   CMD

        MOV     A,HOUR
        ACALL   PRINT_NUM

        MOV     A,#':'
        ACALL   DAT

        MOV     A,MIN
        ACALL   PRINT_NUM

        MOV     A,#':'
        ACALL   DAT

        MOV     A,SEC
        ACALL   PRINT_NUM

        MOV     A,#' '
        ACALL   DAT

        ACALL   AMPM

        MOV     A,#0C0H
        ACALL   CMD

        MOV     A,DATE
        ACALL   PRINT_NUM

        MOV     A,#'/'
        ACALL   DAT

        MOV     A,MONTH
        ACALL   PRINT_NUM

        MOV     A,#'/'
        ACALL   DAT

        MOV     A,YEAR
        ACALL   PRINT_NUM
    
        MOV     A,#' '
        ACALL   DAT

        ACALL PRINT_DAY
        
        MOV    A,#0CEH
        ACALL  CMD

        MOV    A,#00H     ; bell icon
        ACALL  DAT  
          
        RET
    
    
MASK_HOUR:
	MOV 	A, HOUR
	ANL 	A, #1FH
	
CONVERT:
        CJNE A,#13,OK
        SUBB A,#12
OK:	
	MOV 	CHOUR, A
	RET


AMPM:
    MOV A,HOUR
    JB  ACC.5, IS_PM   ; DS1307 12-hour mode check

; ---- AM ----
    MOV       A,#'a'
    ACALL     DAT
    MOV      A,#'m'
    ACALL       DAT
    RET

IS_PM:
    MOV A,#'p'
    ACALL DAT
    MOV A,#'m'
    ACALL DAT
    RET
    

 
BIN2BCD:
    MOV B,#10
    DIV AB          ; A = tens, B = ones

    MOV R0,A        ; tens
    MOV A,B         ; ones

    SWAP A
    ANL A,#0F0H

    ORL A,R0
    RET 

    
  ;====================================================
; PRINT BCD (00 99) ? ASCII
; Input: A = BCD value (e.g. 58H)
;====================================================
PRINT_NUM:
BCD_PRINT:
    MOV TEMP,A

    ANL A,#0F0H
    SWAP A
    ADD A,#30H
    ACALL DAT

    MOV A,TEMP
    ANL A,#0FH
    ADD A,#30H
    ACALL DAT
    RET

;=========================
LCD_INIT:

MOV A,#30H
ACALL RAW
ACALL D20

MOV A,#30H
ACALL RAW
ACALL D20

MOV A,#30H
ACALL RAW
ACALL D20

MOV A,#20H
ACALL RAW
ACALL D20

MOV A,#28H
ACALL CMD

MOV A,#0CH
ACALL CMD

MOV A,#06H
ACALL CMD

MOV A,#01H
ACALL CMD
ACALL D20
RET

;=========================
CMD:
CLR C
ACALL BYTE
RET

DAT:
SETB C
ACALL BYTE
RET

BYTE:
MOV R7,A

ANL A,#0F0H
ACALL SEND

MOV A,R7
SWAP A
ANL A,#0F0H
ACALL SEND
RET

SEND:
JNC S1
ORL A,#01H
S1:
ORL A,#08H

MOV R6,A

MOV A,R6
ORL A,#04H
ACALL OUT1
ACALL DLY

MOV A,R6
ANL A,#0FBH
ACALL OUT1
ACALL DLY
RET

RAW:
ORL A,#08H
MOV R6,A

MOV A,R6
ORL A,#04H
ACALL OUT1
ACALL DLY

MOV A,R6
ANL A,#0FBH
ACALL OUT1
ACALL DLY
RET

OUT1:
MOV R5,A
ACALL ST1
MOV A,#LCD_ADDR
ACALL WR1

MOV A,R5
ACALL WR1

ACALL SP1
RET

;=========================
ST1:
SETB SDA
SETB SCL
CLR SDA
CLR SCL
RET

SP1:
CLR SDA
SETB SCL
SETB SDA
RET

WR1:
MOV R4,#8
L1:
RLC A
MOV SDA,C
SETB SCL
CLR SCL
DJNZ R4,L1
SETB SDA
SETB SCL
CLR SCL
RET


;====================================================
; I2C
;====================================================
I2C_INIT:
    SETB SDA
    SETB SCL
    RET
I2C_START:
    SETB SDA
    SETB SCL
    NOP
    CLR SDA
    NOP
    CLR SCL
    RET

I2C_STOP:
    CLR SDA
    SETB SCL
    NOP
    SETB SDA
    RET

I2C_WRITE:
    MOV R2,#8
WR_LOOP:
    RLC A
    MOV SDA,C
    SETB SCL
    NOP
    CLR SCL
    DJNZ R2,WR_LOOP

    SETB SDA
    SETB SCL
    NOP
    CLR SCL
    RET

; ---- FIXED I2C READ ----
I2C_READ:
    MOV R2,#8
    CLR A

RD_LOOP:
    SETB SDA        ; release SDA
    SETB SCL
    NOP
    MOV C,SDA
    RLC A
    CLR SCL
    DJNZ R2,RD_LOOP
    RET

I2C_ACK:
    CLR SDA
    SETB SCL
    NOP
    CLR SCL
    SETB SDA
    RET

I2C_NACK:
    SETB SDA
    SETB SCL
    NOP
    CLR SCL
    RET


WRITE_CUR_TIME:

TIME_NOW:
    MOV HOUR,#19H
    MOV MIN,#57H  
    MOV SEC,#00H
    
    MOV DAY,#02H
    MOV DATE,#22H
    MOV MONTH,#04H
    MOV YEAR,#26H
WRITE2DS1307:   
    ACALL I2C_START
    MOV A,#0D0H
    ACALL I2C_WRITE
    MOV A,#00H
    ACALL I2C_WRITE

    MOV A,SEC
    ACALL I2C_WRITE
    MOV A,MIN
    ACALL I2C_WRITE
    MOV A,HOUR
    ACALL I2C_WRITE
    MOV A,DAY
    ACALL I2C_WRITE
    MOV A,DATE
    ACALL I2C_WRITE
    MOV A,MONTH
    ACALL I2C_WRITE
    MOV A,YEAR
    ACALL I2C_WRITE

    ACALL I2C_STOP
    RET


    
BELL_CHAR:
; LCD CGRAM address = 40H
    MOV A,#040H
    ACALL CMD

; Row patterns for bell icon
    MOV A,#04H   ;    *
    ACALL DAT
    MOV A,#0EH   ;   ***
    ACALL DAT
    MOV A,#0EH   ;   ***
    ACALL DAT
    MOV A,#0EH
    ACALL DAT
    MOV A,#1FH   ;  *****
    ACALL DAT
    MOV A,#04H
    ACALL DAT
    MOV A,#00H
    ACALL DAT
    MOV A,#04H
    ACALL DAT

; return to DDRAM mode
    MOV A,#080H
    ACALL CMD
    RET


;====================================================
; START MESSAGE
;====================================================
STARTUP_MSG:
    MOV       DPTR,#MSG1
    ACALL     PRNT_STRNG
    MOV       A,#0C0H
    ACALL     CMD
    MOV       DPTR,#MSG2
    ACALL     PRNT_STRNG
    ACALL     DELAY_1S
    MOV       A,#01H
    ACALL     CMD

    RET



;====================================================================
;====================================================================
PRNT_STRNG:	
	CLR	A
	MOVC	A, @A+DPTR
	JZ	END_STRNG
	ACALL 	DAT			;call display subroutine
	INC	DPTR
	SJMP	PRNT_STRNG
END_STRNG:
	RET
;====================================================================
 
;=========================
DLY:
MOV R0,#100
D0:DJNZ R0,D0
RET

D20:
MOV R1,#20
D21:ACALL DLY
DJNZ R1,D21
RET



DELAY_20MS:
    MOV R6,#200
D2:
    MOV R7,#250
D3:
    DJNZ R7,D3
    DJNZ R6,D2
    RET


DELAY_1S:
    MOV R5,#50
D4:
    ACALL DELAY_20MS
    DJNZ R5,D4
    RET



D60US:
    MOV R7,#20
D60_1: DJNZ R7,D60_1
    RET

D480US:
    MOV R7,#200
D480_1: DJNZ R7,D480_1
    RET
 


PRINT_DAY:
    MOV DPTR,#WEEK_DAYS
    MOV R0,DAY          ; number of strings to skip

FIND_DAY:
    CJNE R0,#00,SKIP_STR
    SJMP PRINT_STR

SKIP_STR:
    ; skip characters until 0
NEXT_CHAR:
    CLR A
    MOVC A,@A+DPTR
    INC DPTR
    JNZ NEXT_CHAR       ; keep skipping until 0

    DJNZ R0,FIND_DAY

PRINT_STR:
    ; now DPTR points to correct string
PRINT_LOOP:
    CLR A
    MOVC A,@A+DPTR
    JZ DONE_DAY
    ACALL DAT
    INC DPTR
    SJMP PRINT_LOOP

DONE_DAY:
    RET

;====================================================
;====================================================

MSG1: DB '    AT89S52    ',0
MSG2: DB 'Real Time Clock',0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DB - DEFINE BYTE (INITIALIZE THE MEMORY)
WEEK_DAYS:
    DB 'Mon',0
    DB 'Tue',0
    DB 'Wed',0
    DB 'Thu',0
    DB 'Fri',0
    DB 'Sat',0
    DB 'Sun',0


END