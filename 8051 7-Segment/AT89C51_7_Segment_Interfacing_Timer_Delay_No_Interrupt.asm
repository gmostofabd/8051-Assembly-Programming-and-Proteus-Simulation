;====================================================================
; 8051 MCU INTYERFACING WITH 7 SEGMENT LED DISPLAY
; 
; Created     : Sun, Oct 30 2022
; Processor   : AT89S52 (With 11.0592MHz EXTERNAL Crystal Oscillator)
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
	MOV	R0,#0D
	MOV 	TMOD, #01H
LOOP1:
	MOV	A,R0
	ACALL	DISP
	INC	R0
	CJNE	R0,#10D,LOOP1
	MOV	R0,#0D

	LJMP	LOOP1

;====================================================================
; DISP:  Subroutine to Display Decimal Numbers ( 0 to 9)
; Data Index is defined in A (Accumulator)
; Data Pattern Bytes are stored in  Program Memory as DB  
; Data Pointer Directive used to Access Addresses
;====================================================================
DISP: 	
	MOV 	DPTR,#SSD_CC
	MOVC 	A,@a+DPTR
	MOV 	PORT,A
	LCALL	DELAY		; One Second Delay
	RET

;====================================================================
; DELAY: Subroutine for Delay (Approx. 1 Second is to loop for 14 -  
; complete 16-Bit Timer Cycles of TIMER0. Register R1 is used.					
;====================================================================					
DELAY:
	MOV 	R1,#14
	MOV 	TL0,#00H
	MOV 	TH0,#00H
	SETB 	TR0
TIMER_LOOP:
	JNB 	TF0,TIMER_LOOP
	CLR 	TF0
	DJNZ 	R1,TIMER_LOOP
	CLR 	TR0
	RET

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
