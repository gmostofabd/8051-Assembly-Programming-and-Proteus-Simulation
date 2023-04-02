;====================================================================
; 8051 MCU INTYERFACING WITH 7 SEGMENT LED DISPLAY
; 
; Created     : Sun, Oct 30 2022
; Processor   : AT89S52 (With 11.0592MHz EXTERNAL Crystal)
; Compiler    : MIDE-51 (WINASM)
; Simulator   : PROTEUS 8.9
; Hardware    : avrPRO board developed by "melab-bd" Board.
; Result      : Found OK on Simulator and Real Hardware as Circuit
; Single Digit Com. Cathode 7 Segment Display used (As in Hardware).
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================
	PORT	EQU	P1	;
	BTN_UP	EQU	P0.0	;
	BTN_DN	EQU	P0.1	;
	BTN_CLR	EQU	P0.2	;
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
	SETB 	P0.0		; Make Port 0.0 an input
	SETB 	P0.1		; Make Port 0.0 an input
	SETB 	P0.2		; Make Port 0.0 an input
	MOV	R0,#0D

LOOP1:	
	MOV	A,R0		; Value stores in A
	LCALL	DISP		; Calling Routine to show value in A
BTN_SCAN:
	JNB 	P0.0,UP_COUNT	; Scan for RESET button press
	JNB 	P0.1,DN_COUNT	; Scan for
	JNB 	P0.2,RESET_COUNT	; Scan for

	SJMP	LOOP1

;====================================================================
UP_COUNT:
	ACALL	ONE_MILL_SEC
	JNB	BTN_UP,UP_COUNT
	INC	R0
	CJNE	R0,#10D,LOOP1	; Compare it reaches 10 count or not
	MOV	R0,#09D		; Reseting No. after reaching No. 9
	SJMP	LOOP1

DN_COUNT:
	ACALL	ONE_MILL_SEC
	JNB	BTN_DN,DN_COUNT
	MOV	A,R0
	JZ	LOOP1
	DJNZ	R0,LOOP1
	MOV	R0,#0D
	SJMP	LOOP1

RESET_COUNT:
	ACALL	ONE_MILL_SEC
	JNB	BTN_CLR,RESET_COUNT
	MOV	R0,#0D
	SJMP	LOOP1

;====================================================================
; DISP:  Subroutine to Display Decimal Numbers ( 0 to 9)
; Data Index is defined in A (Accumulator)
; Data Pattern Bytes are stored in  Program Memory as DB  
; Data Pointer Directive used to Access Addresses
;====================================================================
DISP: 	
	MOV 	DPTR,#SSD_CC	; Setting Data Bytes Start Address
	MOVC 	A,@a+DPTR	; Fixing Accurate Address Now
	MOV 	PORT,A		; Place Data Patterns on o/p Port.
	ACALL	ONE_MILL_SEC
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
; Data Patterns Stored here (Common Cathode 7 Segment Display)
;====================================================================
	ORG  	300H
SSD_CC:	
	DB 	3FH,06H,05BH,04FH,066H,06DH, 07DH,07H,07FH,06FH
;====================================================================

	END			; end of program
;====================================================================
; ---------------------END of the Assembly Program-------------------
;====================================================================
