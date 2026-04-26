;====================================================
;====================================================
ORG 0000H
AJMP START



;---------------- LCD ----------------
     LCD_PORT EQU    P0
     RS       EQU    P2.0
     EN       EQU    P2.1



     SDA       BIT   P1.1
     SCL       BIT   P1.0
     PIN_1W    EQU   P1.2


; KEYBOARD PINS
     KEY_DEC   EQU   P1.3
     KEY_INC   EQU   P1.4

; SOUNDER PIN
     PIN_BEEP  EQU   P1.5


;====================================================
     LCD_ADDR EQU 04EH  ; IF FAIL TRY 07EH
     RTC_W    EQU 0D0H
     RTC_R    EQU 0D1H
     
     
; TIMER CONSTS FOR GENERIC 8051 FOR 1 MS DELAY
INIT_TL0 EQU 017H
INIT_TH0 EQU 0FCH
     
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

        AL_H       EQU 52H
        AL_M       EQU 53H
        TEMP_L    EQU 54H
        TEMP_H    EQU 55H
        TEMP_INT  EQU 56H
        TEMP_STATE EQU 57H   ; 0 = START, 1 = READ
        TEMP_DELAY EQU 58H
; SET TEMPERATURE BUFFER START ADDRESS
        SET_TEMP_BUFFER EQU 059H

;====================================================
;====================================================

START:
    MOV    SP,#70H
    ACALL LCD_INIT
    ACALL  BELL_CHAR
    ACALL STARTUP_MSG

    ACALL I2C_INIT

    ACALL WRITE_CUR_TIME


;====================================================
; MAIN LOOP (MODIFIED ONLY HERE)
;====================================================
MAIN_LOOP:

    ACALL       DELAY_20MS

RTCTIMEUPDATE:
    ACALL       RTC_READ
    ACALL       DISPLAY_TIME    

DSTEMPUPDATE:   
    ACALL       TEMP_SERVICE
    ACALL       DISPLAY_TEMP
         
    LJMP        MAIN_LOOP
;====================================================
;====================================================


 
    
    
    
 ;====================================================
; DS18B20 TEMPERATURE SERVICE (NON-BLOCKING)
; STATE MACHINE:
;   0 = START CONVERSION
;   1 = WAIT & READ
;====================================================

TEMP_SERVICE:

    MOV A,TEMP_STATE
    CJNE A,#00H,READ_PHASE

;========================
; START CONVERSION
;========================
START_PHASE:
    ACALL INIT_1W
    JC EXIT_TEMP          ; IF NO DEVICE, EXIT

    MOV A,#0CCH           ; SKIP ROM
    ACALL WRITE_BYTE_1W

    MOV A,#044H           ; CONVERT T
    ACALL WRITE_BYTE_1W

    MOV TEMP_STATE,#01H   ; GO TO WAIT/READ STATE
    RET

;========================
; WAIT + READ PHASE
;========================
READ_PHASE:

    ; CHECK IF CONVERSION COMPLETE (DQ = HIGH)
    SETB PIN_1W
    JB PIN_1W, DO_READ    ; IF HIGH ? READY
    RET                   ; NOT READY YET

;========================
; READ SCRATCHPAD
;========================
DO_READ:

    ACALL INIT_1W
    JC EXIT_TEMP

    MOV A,#0CCH           ; SKIP ROM
    ACALL WRITE_BYTE_1W

    MOV A,#0BEH           ; READ SCRATCHPAD
    ACALL WRITE_BYTE_1W

    ACALL READ_BYTE_1W
    MOV TEMP_L,A

    ACALL READ_BYTE_1W
    MOV TEMP_H,A

;========================
; CORRECT DS18B20 CONVERSION
; TEMP = (TEMP_H << 4) + (TEMP_L >> 4)
;========================

    ; TEMP_H << 4
    MOV A,TEMP_H
    SWAP A
    ANL A,#0F0H       ; KEEP SHIFTED RESULT
    MOV R2,A

    ; TEMP_L >> 4
    MOV A,TEMP_L
    ANL A,#0F0H
    SWAP A            ; NOW IN LOWER NIBBLE

    ORL A,R2          ; COMBINE

    MOV TEMP_INT,A
    
    MOV TEMP_STATE,#00H   ; RESTART CYCLE
    
EXIT_TEMP:
    MOV TEMP_STATE,#00H   ; RESTART CYCLE

    RET
     


; DEBOUNCES BUTTONS AND SETS A TO 1 IF KEY_DEC IS PRESSED
;                                 2 IF KEY_INC IS PRESSED
;                                 3 IF BOTH KEYS ARE PRESSED
GET_KEYS:
	SETB KEY_INC
	SETB KEY_DEC
	JB KEY_INC, GET_KEY_DEC
	
; INCREASE TEMPERATURE KEY PRESSED
	MOV R3, #10

DELAY_INC:
	ACALL DELAY_1MS
	DJNZ R3, DELAY_INC
	JB KEY_INC, GET_KEY_END
	MOV R0, #SET_TEMP_BUFFER
	MOV A, @R0
	CLR C
	ADD A, #8
	MOV @R0, A
	INC R0
	MOV A, @R0
	ADDC A, #0
	MOV @R0, A
	RET

GET_KEY_DEC:
	JB KEY_DEC, GET_KEY_END
	
; DECREASE TEMPERATURE KEY PRESSED
	MOV R3, #10
DELAY_DEC:
	ACALL DELAY_1MS
	DJNZ R3, DELAY_DEC
	JB KEY_DEC, GET_KEY_END
	MOV R0, #SET_TEMP_BUFFER
	MOV A, @R0
	CLR C
	SUBB A, #8
	MOV @R0, A
	INC R0
	MOV A, @R0
	SUBB A, #0
	MOV @R0, A
GET_KEY_END:
	RET
  



 ;====================================================
; LCD
;====================================================
;==================== LCD (delay based) ===============================
LCD_INIT:
    MOV A, #38H
    ACALL LCD_CMD
    ACALL DELAY

    MOV A, #0EH
   ACALL LCD_CMD
    ACALL DELAY

    MOV A, #01H
    ACALL LCD_CMD
    ACALL DELAY

    MOV A, #06H
    ACALL LCD_CMD
    ACALL DELAY

    MOV A, #80H
    ACALL LCD_CMD
    ACALL DELAY
RET

  

LCD_CMD:
CMD:
    MOV LCD_PORT,A
    CLR RS
    SETB EN
    ACALL DELAY
    CLR EN
    RET
    
LCD_DATA:
DAT:
    MOV LCD_PORT,A
    SETB RS
    SETB EN
    ACALL DELAY
    CLR EN
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
    SETB SDA        ; RELEASE SDA
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







INIT_1W:
    CLR   PIN_1W
    MOV   R0, #250     ; WAIT ~500US (ADJUST FOR CLOCK SPEED)
    DJNZ  R0, $

    SETB  PIN_1W
    MOV   R0, #40      ; WAIT ~80US FOR PRESENCE PULSE
    DJNZ  R0, $

    JB    PIN_1W, RESET_ERR ; IF DQ IS STILL HIGH, SENSOR NOT FOUND
    MOV   R0, #200     ; WAIT FOR PRESENCE PULSE TO FINISH
    DJNZ  R0, $
    RET
RESET_ERR:           ; HANDLE ERROR (E.G., LED INDICATOR)
    RET

    
    
    
	
READ_BYTE_1W:
    MOV      R1,#8
 ;   CLR A

RB_LOOP:
    CLR  PIN_1W        ; START READ SLOT
    NOP
    SETB PIN_1W       ; RELEASE BUS
    
    MOV  R0, #5       ; WAIT ~10US BEFORE SAMPLING
    DJNZ R0, $
    MOV  C, PIN_1W        ; SAMPLE THE BIT
    RRC  A            ; SHIFT BIT INTO ACCUMULATOR
    MOV  R0, #25      ; COMPLETE TIME SLOT (~50US)
    DJNZ R0, $
    DJNZ R1, RB_LOOP
    RET    
    
    
; --- WRITE BYTE ROUTINE ---
; SENDS 8 BITS FROM ACCUMULATOR TO DS18B20
WRITE_BYTE_1W:
    MOV R1, #8       ; COUNTER FOR 8 BITS
W_LOOP:
    RRC A            ; MOVE LSB TO CARRY FLAG
    CLR PIN_1W           ; START TIME SLOT
    MOV R0, #2       ; SHORT DELAY (~5US)
    DJNZ R0, $
    MOV PIN_1W, C        ; WRITE BIT (CARRY) TO DQ
    MOV R0, #30      ; WAIT FOR TIME SLOT END (~60US)
    DJNZ R0, $
    SETB PIN_1W          ; RELEASE LINE
    DJNZ R1, W_LOOP
    RET

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
   ACALL 	MASK_HOUR

    MOV A,#080H
    ACALL LCD_CMD

    MOV A,HOUR
    ACALL PRINT_NUM

    MOV A,#':'
    ACALL LCD_DATA

    MOV A,MIN
    ACALL PRINT_NUM

    MOV A,#':'
    ACALL LCD_DATA

    MOV A,SEC
    ACALL PRINT_NUM

    MOV A,#' '
    ACALL LCD_DATA

    
     ACALL AMPM

    MOV A,#0C0H
    ACALL LCD_CMD

    MOV A,DATE
    ACALL PRINT_NUM

    MOV A,#'/'
    ACALL LCD_DATA

    MOV A,MONTH
    ACALL PRINT_NUM

    MOV A,#'/'
    ACALL LCD_DATA

    MOV A,YEAR
    ACALL PRINT_NUM
    
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
	ANL 	A, #01FH
	
CONVERT:
        CJNE A,#13,OK
        SUBB A,#12
OK:	
	MOV 	CHOUR, A
	RET


AMPM:
    MOV A,HOUR
    JNB  ACC.5, IS_PM   ; DS1307 12-HOUR MODE CHECK

; ---- AM ----
    MOV       A,#'A'
    ACALL     DAT
    MOV      A,#'M'
    ACALL       DAT
    RET

IS_PM:
    MOV A,#'P'
    ACALL DAT
    MOV A,#'M'
    ACALL DAT
    RET
    
    
 

DISPLAY_TEMP:
    MOV   A,#08CH
    ACALL CMD

    MOV   A,TEMP_INT
    

    
    ACALL BIN2BCD     ; ? FIX
    SWAP A
    ACALL PRINT_NUM

    MOV   A,#0DFH     ; DEGREE SYMBOL
    ACALL DAT

    MOV   A,#'C'
    ACALL DAT

    RET 
 
  
BIN2BCD:
    MOV B,#10
    DIV AB          ; A = TENS, B = ONES

    MOV R0,A        ; TENS
    MOV A,B         ; ONES

    SWAP A
    ANL A,#0F0H

    ORL A,R0
    RET 
 




    
;====================================================
; PRINT BCD (00 99) ? ASCII
; INPUT: A = BCD VALUE (E.G. 58H)
;====================================================
PRINT_NUM:
BCD_PRINT:
    MOV TEMP,A

    ANL A,#0F0H
    SWAP A
    ADD A,#30H
    ACALL DAT

    MOV A,TEMP
    ANL A,#00FH
    ADD A,#30H
    ACALL DAT
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
	ACALL 	DAT			;CALL DISPLAY SUBROUTINE
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


;====================================================
; DELAYS
;====================================================
DELAY:
    MOV R7,#200
D1: DJNZ R7,D1
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
    
    


DELAY_1MS:
	; LOAD INITIAL TIMER VALUES
	MOV TL0, #INIT_TL0
	MOV TH0, #INIT_TH0
	; ENABLE TIMER
	SETB TR0
	; WAIT FOR OVERFLOW
	WAIT:
		JNB TF0, WAIT
	; DISABLE TIMER
	CLR TR0
	; CLEAR OVERFLOW FLAG
	CLR TF0
	RET

SIMPLE_DELAY:
	DJNZ R7, SIMPLE_DELAY
	RET
    
    
    
    
    
    
    

PRINT_DAY:
    MOV DPTR,#WEEK_DAYS
    MOV R0,DAY          ; NUMBER OF STRINGS TO SKIP

FIND_DAY:
    CJNE R0,#00,SKIP_STR
    SJMP PRINT_STR

SKIP_STR:
    ; SKIP CHARACTERS UNTIL 0
NEXT_CHAR:
    CLR A
    MOVC A,@A+DPTR
    INC DPTR
    JNZ NEXT_CHAR       ; KEEP SKIPPING UNTIL 0

    DJNZ R0,FIND_DAY

PRINT_STR:
    ; NOW DPTR POINTS TO CORRECT STRING
PRINT_LOOP:
    CLR A
    MOVC A,@A+DPTR
    JZ DONE_DAY
    ACALL DAT
    INC DPTR
    SJMP PRINT_LOOP

DONE_DAY:
    RET


 
    
BELL_CHAR:
; LCD CGRAM ADDRESS = 40H
    MOV A,#040H
    ACALL CMD

; ROW PATTERNS FOR BELL ICON
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

; RETURN TO DDRAM MODE
    MOV A,#080H
    ACALL CMD
    RET


;====================================================
;====================================================

MSG1: DB '    AT89S52    ',0
MSG2: DB 'REAL TIME CLOCK',0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DB - DEFINE BYTE (INITIALIZE THE MEMORY)
WEEK_DAYS:
    DB 'MON',0
    DB 'TUE',0
    DB 'WED',0
    DB 'THU',0
    DB 'FRI',0
    DB 'SAT',0
    DB 'SUN',0


END