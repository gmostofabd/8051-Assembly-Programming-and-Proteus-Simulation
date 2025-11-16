;====================================================================
; 8051 MCU INTYERFACING WITH 7 SEGMENT LED DISPLAY
; 
; CREATED     : SUN, OCT 30 2022
; PROCESSOR   : AT89S52 (WITH 11.0592 CRYSTAL OSCILLATOR)
; COMPILER    : MIDE-51 (WINASM)
; SIMULATOR   : PROTEUS 8.9
; HARDWARE    : AVRPRO (VER.22.0) DEVELOPMENT BOARD AND  TESTED OK
; SINGLE DIGIT COMMON CATHODE 7 SEGMENT DISPLAY USED (AS IN HARDWARE)
; LOOK UP TABLE USED.
;====================================================================

;====================================================================
;====================================================================
      	ORG   0000H		; RESET VECTOR ADDRESS

	MOV	P2,#11111110B	; 

MAIN_LOOP:
	MOV	R5,#0D
	MOV	R6,#09D

REPEAT:
	MOV	A,R5
	MOV 	DPTR,#SSD_CC
	MOVC 	A,@A+DPTR
	MOV 	P3,A
	LCALL	ONE_SEC
	INC	R5
	MOV	A,R5
	SUBB	A,R6
	JZ	MAIN_LOOP
	LJMP	REPEAT
;====================================================================
;====================================================================

;====================================================================
; ONE_SEC: (Subroutine to Delay ONE Second)
; Uses Register R7 but Preserves this Register 
;====================================================================
ONE_SEC: 
 	PUSH	07H		; Save R7 to Stack 
 	MOV	R7, #250D	; LOAD R7 to Count 250 Loops
LOOP_SEC:	; Calls 4 One Millisec. Delays, 250 times 
 	LCALL	ONE_MILL_SEC	; Call 1 MilliSecond Delay
 	LCALL	ONE_MILL_SEC	; Call 1 MilliSecond Delay
 	LCALL	ONE_MILL_SEC	; Call 1 MilliSecond Delay
 	LCALL	ONE_MILL_SEC	; Call 1 MilliSecond Delay
 	DJNZ 	R7, LOOP_SEC 	; Decrement R7, if not Zero loop back 
 	POP 	07H		; Restore R7 to Original value 
	RET
;====================================================================
; ONE_MILL_SEC: (Subroutine to Delay ONE Milli Second)
; Uses Register R7 but Preserves this Register 
;====================================================================
ONE_MILL_SEC: 
	PUSH	07H		; Save R7 to Stack   
	MOV 	R7, #250D	; LOAD R7 to Count 250 Loops
LOOP_1_MS:			; Loops 250 times 
	NOP			; Inserted NOPs to cause Delay 
 	NOP			; 
 	DJNZ 	R7, LOOP_1_MS	; Decrement R7, if not Zero loop back 
	POP	07H		; Restore R7 to Sriginal value 
	RET			; Return from Subroutine
;====================================================================






;====================================================================
ORG  300H
SSD_CC:	DB 3FH,06H,05BH,04FH,066H,06DH, 07DH,07H,07FH,06FH
;====================================================================
      END
;====================================================================
; END of the Assembly Program
;====================================================================

