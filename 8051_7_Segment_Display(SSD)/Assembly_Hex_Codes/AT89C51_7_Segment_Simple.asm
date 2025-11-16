;====================================================================
; 8051 MCU INTYERFACING WITH 7 SEGMENT LED DISPLAY
; 
; Created     : Sun, Oct 30 2022
; Processor   : AT89S52 (wITH 11.0592 Crystal Oscillator)
; Compiler    : MIDE-51 (WINASM)
; Simulator   : PROTEUS 8.9
; Hardware    : avrPRO (Ver.22.0) Development Board and  Tested OK
; Single Digit Common Cathode 7 Segment Display used (As IN Hardware)
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================
	PORT	EQU	P1

;====================================================================
; VARIABLES
;====================================================================

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================
      ORG	00H		; Reset Vector Address
      AJMP	START		; Jump TO Main Program
;====================================================================
; CODE SEGMENT
;====================================================================
	ORG	030H
START:
	MOV	PORT,#00H	; CLEARING 7 SEG DATA PORT
LOOP1:
	MOV 	PORT,#00111111B	; Data Pattern for No. "0"
	LCALL	ONE_SEC		; One Second Delay
	MOV 	PORT,#00000110B	; Data Pattern for No. "1"
	LCALL	ONE_SEC		; One Second Delay
	MOV 	PORT,#01011011B	; Data Pattern for No. "2"
	LCALL	ONE_SEC		; One Second Delay
	MOV 	PORT,#01001111B	; Data Pattern for No. "3"
	LCALL	ONE_SEC		; One Second Delay
	MOV 	PORT,#01100110B	; Data Pattern for No. "4"
	LCALL	ONE_SEC		; One Second Delay
	MOV 	PORT,#01101101B	; Data Pattern for No. "5"
	LCALL	ONE_SEC		; One Second Delay
	MOV 	PORT,#01111101B	; Data Pattern for No. "6"
	LCALL	ONE_SEC		; One Second Delay
	MOV 	PORT,#00000111B	; Data Pattern for No. "7"
	LCALL	ONE_SEC		; One Second Delay
	MOV 	PORT,#01111111B	; Data Pattern for No. "8"
	LCALL	ONE_SEC		; One Second Delay
	MOV 	PORT,#01101111B	; Data Pattern for No. "9"
	LCALL	ONE_SEC		; One Second Delay

	LJMP	LOOP1

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

      END			; end of program
;====================================================================
; END of the Assembly Program
;====================================================================
