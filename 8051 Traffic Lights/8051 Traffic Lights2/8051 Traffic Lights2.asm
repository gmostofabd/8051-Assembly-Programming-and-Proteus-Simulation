$NOMOD51	 ;to suppress the pre-defined addresses by keil
$include (C8051F020.INC)		; to declare the device peripherals	with it's addresses

ORG 0H					   ; to start writing the code from the base 0 in flash
DB 0FFH,3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
;addresses from 1 -> 10  (7-segment 1) adresses from 11 -> 13 for max value on 7-seg

COUNTER EQU 14H
MOV COUNTER, #10

MAX EQU 18H 
MOV MAX, #4
VAR EQU 30H
MOV VAR, #150

;diable the watch dog
MOV WDTCN,#11011110B ;0DEH
MOV WDTCN,#10101101B ;0ADH

; config of clock
MOV OSCICN , #14H ; 2MH clock
;config cross bar
MOV XBR0 , #00H
;MOV XBR1 , #00H
MOV XBR2 , #040H  ; Cross bar enabled , weak Pull-up enabled 
MOV XBR1, #00000100        ; enable interrupt0 as input pin  INT0E

MOV P0MDOUT,#00h 
MOV A, #0FFH  ; set all pins as input pull-up
;MOV P0, A
MOV P1MDOUT,#0FFh ; port1 -> output
MOV P2MDOUT,#0FFh ; port2 -> output
MOV P74OUT,#00001100B  ; port5 -> [0:3 output,4:7 output]
; BUTTONS---------------
SWTCH BIT 25H   ; p0.2
DELAY_BUTTON BIT 26H ; p0.3
CLR SWTCH
CLR DELAY_BUTTON
;--------------------------------

; set p5.4 (LED)---------------
MOV P5,A
ORL A, #00010000B ; set P5.4
ANL A, #11011111B ; reset P5.5
MOV P5, A
;-----------------------

INC_MAX_FLAG BIT 22H      ; 20H to 2FH 
CLR INC_MAX_FLAG
DELAY_FLAG BIT 23H      ; 20H to 2FH 
CLR DELAY_FLAG

;TAKE CARE!!!!!!! R1,R2,R3 is used by the seven segment function
MAIN: 
	ACALL INIT
    ACALL SEVEN_SEG2
    ACALL SEVEN_SEG1
    ACALL DELAY 
    INF_LOOP:
        ACALL INCREMENT         ; update variables
        ACALL LED
        ACALL SEVEN_SEG1
        MOV COUNTER, #10
        LOOP_TEN_TIMES:
            ACALL SWITCH    ; 
            ACALL SEVEN_SEG2
            ACALL DELAY
            DJNZ COUNTER, LOOP_TEN_TIMES
    JMP	INF_LOOP		;#!return and start the program on

;NEW UPDATE-------------------------------
GET_SWTCH:  ; P0.2
    JB INC_MAX_FLAG, FLAG_ALREDY_ONE
    MOV A, P0
    ANL A, #04h
    JNZ CLR_SWTCH
    SETB SWTCH
    FLAG_ALREDY_ONE:
    RET
    CLR_SWTCH:
    CLR SWTCH
    RET
GET_DELAY_BUTTON: ;p0.3
    JB DELAY_FLAG, ALREADY_SET
    MOV A, P0
    ANL A, #08h
    JNZ CLR_DELAY_BUTTON
    SETB DELAY_BUTTON
    ALREADY_SET:
    RET
    CLR_DELAY_BUTTON:
    CLR DELAY_BUTTON
    RET

;-------------------------------------------------------
LED:
    MOV A, R1  ; R1=04
    ADD A, R2  ; R2=0A
    SUBB A, MAX
    SUBB A, #10
    JZ TOG_LEDS
    RET
;-------------------------
; toggle leds
TOG_LEDS:
    MOV A, P5
    XRL A, #30H 
    MOV P5, A
    RET
;------------------------

INIT:           ; set the initial values for 7-seg1 and 2
    MOV R1, #05H    ; start value (4) for 7-seg1 
    MOV R2, #01H    ; start value (0) for 7-seg2 
    MOV DPTR, #00H	
    RET
INCREMENT:
    JB INC_MAX_FLAG, UPDATE_MAX
    JB DELAY_FLAG, INC_DELAY_VAR
    RET

INC_DELAY_VAR:
    MOV A, VAR
    ADD A, #50
    JC DEFLT
    MOV VAR, A
    CLR DELAY_FLAG
    RET
DEFLT:
MOV VAR, #150
CLR DELAY_FLAG
RET

SWITCH: ; if button isn't pressed, pin value equals one
    ACALL GET_SWTCH
    JB SWTCH, SET_FLAG
    ACALL GET_DELAY_BUTTON
    JB DELAY_BUTTON, SET_FLAG_BUTTON
    RET

SET_FLAG:
    SETB INC_MAX_FLAG
    RET

SET_FLAG_BUTTON:
    SETB DELAY_FLAG
    RET
UPDATE_MAX:
    CLR INC_MAX_FLAG
    INC MAX
    MOV A, MAX
    ANL A, #11111001b
    JZ DEFUALT
    RET

DEFUALT:
    MOV MAX, #4
    RET

SEVEN_SEG1:
    ACALL UPDATE_DPTR
    ACALL GET_PTR1_VAL  ; get saved value of A
    MOVC A,@A+DPTR
    MOV P1,A
    ACALL GET_PTR1_VAL
    DEC A
    ACALL SAV_PTR1_VAL
	JZ RELOAD
    RET
RELOAD:
    MOV R1, MAX;#04H    ; start value for 7-seg1 pointer 3
    RET
SAV_PTR1_VAL:
    MOV R1, A
    RET
GET_PTR1_VAL:
    MOV A, R1
    RET
UPDATE_DPTR:        
    MOV DPTR, #00
    RET

SEVEN_SEG2:
    ACALL UPDATE_DPTR
    ACALL GET_PTR2_VAL
    MOVC A,@A+DPTR
    MOV P2,A
    ACALL GET_PTR2_VAL
    DEC A
    ACALL SAV_PTR2_VAL
    jz RESET
    RET
SAV_PTR2_VAL:
    MOV R2, A
    RET
GET_PTR2_VAL:
    MOV A, R2
    RET
RESET:
    MOV R2, #10
    RET 

DELAY :
	MOV R4, VAR
	LOOP3:MOV R5,#255
	LOOP2:MOV R7,#1
	LOOP1:DJNZ R7,LOOP1
	DJNZ R5,LOOP2
	DJNZ R4,LOOP3
	RET

END