;====================================================
; 8051 (AT89S52) + I2C LCD (PCF8574) INTERFACE
;----------------------------------------------------
; SDA -> P2.1
; SCL -> P2.0
; LCD controlled in 4-bit mode via PCF8574
;====================================================

ORG 0000H
AJMP START                 ; Jump to main program

;================= PIN DEFINITIONS ==================
SDA     BIT   P2.1         ; I2C Data line
SCL     BIT   P2.0         ; I2C Clock line

;================= LCD I2C ADDRESS ==================
LCD_ADDR EQU 04EH          ; PCF8574 address (try 07EH if needed)

;====================================================
;                PROGRAM START
;====================================================
START:
;    MOV SP,#70H            ; Initialize stack pointer

    ACALL I2C_INIT         ; Initialize I2C lines
    
    ACALL LCD_INIT         ; Initialize LCD
    
;====================================================
;                MAIN LOOP
;====================================================
MAIN_LOOP:
    ; Clear display
    MOV A,#01H
    ACALL CMD
    ACALL DELAY_20MS
    ; Set cursor position (1st row, 3rd column)
    MOV A,#084H
    ACALL CMD
    
    ; Display: "8051 I2C LCD"
    MOV A,#'8'   ; Each character sent one by one
    ACALL DAT
    MOV A,#'0'
    ACALL DAT
    MOV A,#'5'
    ACALL DAT
    MOV A,#'1'
    ACALL DAT
    MOV A,#' '
    ACALL DAT
    MOV A,#'I'
    ACALL DAT
    MOV A,#'2'
    ACALL DAT
    MOV A,#'C'
    ACALL DAT
 
    ; Move to second line
    MOV A,#0C2H
    ACALL CMD

    ; Display: "HELLO WORLD"
    MOV A,#'L'
    ACALL DAT
    MOV A,#'C'
    ACALL DAT
    MOV A,#'D'
    ACALL DAT
    MOV A,#' '
    ACALL DAT
    MOV A,#'I'
    ACALL DAT
    MOV A,#'N'
    ACALL DAT
    MOV A,#'T'
    ACALL DAT
    MOV A,#'E'
    ACALL DAT
    MOV A,#'R'
    ACALL DAT
    MOV A,#'F'
    ACALL DAT
    MOV A,#'A'
    ACALL DAT
    MOV A,#'C'
    ACALL DAT
    MOV A,#'E'
    ACALL DAT

    ACALL DELAY_1S         ; Wait 1 second
    LJMP  MAIN_LOOP         ; Repeat forever

;====================================================
;                LCD INITIALIZATION
;====================================================
LCD_INIT:
    ; Force LCD into 4-bit mode (special sequence)
    MOV A,#30H
    ACALL RAW
    ACALL D20

    MOV A,#30H
    ACALL RAW
    ACALL D20

    MOV A,#30H
    ACALL RAW
    ACALL D20

    MOV A,#20H             ; Switch to 4-bit mode
    ACALL RAW
    ACALL D20

    MOV A,#28H             ; 2 lines, 5x7 font
    ACALL CMD

    MOV A,#0CH             ; Display ON, cursor OFF
    ACALL CMD

    MOV A,#06H             ; Entry mode
    ACALL CMD

    MOV A,#01H             ; Clear display
    ACALL CMD
    ACALL D20
    RET

;====================================================
;         COMMAND / DATA SELECTION
;====================================================
CMD:
    CLR C                  ; RS = 0 (Command)
    ACALL BYTE
    RET

DAT:
    SETB C                 ; RS = 1 (Data)
    ACALL BYTE
    RET

;====================================================
;      SEND BYTE (SPLIT INTO 2 NIBBLES)
;====================================================
BYTE:
    MOV R7,A               ; Save original byte

    ANL A,#0F0H            ; Send high nibble
    ACALL SEND

    MOV A,R7
    SWAP A                 ; Swap nibbles
    ANL A,#0F0H            ; Send low nibble
    ACALL SEND
    RET

;====================================================
;        SEND NIBBLE TO LCD VIA PCF8574
;====================================================
SEND:
    JNC S1                 ; If data (RS=1), skip
    ORL A,#01H             ; Set RS bit

S1:
    ORL A,#08H             ; Backlight ON

    MOV R6,A               ; Store data

    ; Enable HIGH pulse
    MOV A,R6
    ORL A,#04H             ; EN = 1
    ACALL OUT1
    ACALL DLY

    ; Enable LOW pulse
    MOV A,R6
    ANL A,#0FBH            ; EN = 0
    ACALL OUT1
    ACALL DLY
    RET

;====================================================
;      RAW WRITE (USED DURING INIT ONLY)
;====================================================
RAW:
    ORL A,#08H             ; Backlight ON
    MOV R6,A

    MOV A,R6
    ORL A,#04H             ; EN = 1
    ACALL OUT1
    ACALL DLY

    MOV A,R6
    ANL A,#0FBH            ; EN = 0
    ACALL OUT1
    ACALL DLY
    RET

;====================================================
;     SEND BYTE OVER I2C TO PCF8574
;====================================================
OUT1:
    MOV R5,A               ; Save byte

    ACALL ST1              ; I2C START
    MOV A,#LCD_ADDR
    ACALL WR1              ; Send address

    MOV A,R5
    ACALL WR1              ; Send data

    ACALL SP1              ; I2C STOP
    RET

;====================================================
;          LOW-LEVEL I2C ROUTINES
;====================================================

;---- START CONDITION ----
ST1:
    SETB SDA
    SETB SCL
    CLR SDA
    CLR SCL
    RET

;---- STOP CONDITION ----
SP1:
    CLR SDA
    SETB SCL
    SETB SDA
    RET

;---- WRITE BYTE ----
WR1:
    MOV R4,#8              ; 8 bits to send
L1:
    RLC A                  ; Rotate bit into carry
    MOV SDA,C              ; Output bit
    SETB SCL               ; Clock HIGH
    CLR SCL                ; Clock LOW
    DJNZ R4,L1

    SETB SDA               ; Release SDA (ACK phase)
    SETB SCL
    CLR SCL
    RET

;====================================================
;        GENERIC I2C FUNCTIONS (OPTIONAL)
;====================================================
I2C_INIT:
    SETB SDA               ; Idle state HIGH
    SETB SCL
    RET

;====================================================
;                DELAY ROUTINES
;====================================================
DLY:
    MOV R0,#100
D0: DJNZ R0,D0
    RET

D20:
    MOV R1,#20
D21: ACALL DLY
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

END