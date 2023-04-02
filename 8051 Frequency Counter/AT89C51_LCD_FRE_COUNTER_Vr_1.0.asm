;====================================================================
; DEFINITIONS
; EQU (equate): This is used to define a constant
; without occupying a memory location.
;====================================================================
IO_DECLERATION:
    	LCD_PORT EQU	P1
    	RS 	EQU 	P2.0 ; RS ON LCD
;    	RW 	EQU 	P2.1 ; RS ON LCD, IT IS GROUNDED
	EN 	EQU 	P2.2 ; EN ON LCD
	SW_RNG	EQU	P0.0
;====================================================================
	VAR1 	EQU 	R2
	TEMP 	EQU 	R3
	TEMP1 	EQU 	R4
	DELAY 	EQU 	R5
	TICK 	EQU 	R6
	FREQ 	EQU 	R7
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;4BYTE HEX 2 DEC CONVERSION VARIABLES
	XX0	EQU	30H
	XX1	EQU	31H
	XX2	EQU	32H
	XX3 	EQU 	33H
	YY0	EQU	34H
	YY1	EQU	35H
	YY2	EQU	36H
	YY3	EQU	37H
	YY4	EQU	38H
	ZZ0	EQU	39H
	ZZ1	EQU	3AH
	ZZ2	EQU	3BH
	ZZ3	EQU	3CH
	ZZ4	EQU	3DH
	BITS 	EQU 	3EH

	UPDATELCD EQU 	3FH
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	DIGIT_0		EQU	40H
	DIGIT_1		EQU	41H
	DIGIT_2		EQU	42H
	DIGIT_3		EQU	43H
	DIGIT_4		EQU	44H
	DIGIT_5		EQU	45H
	DIGIT_6		EQU	46H
	DIGIT_7		EQU	47H
	U_NBL		EQU	48H
	L_NBL		EQU	49H
	RNG_SEL		EQU	4AH
;====================================================================
	
;====================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ORG	00H		;RESET VECTOR ADDRESS
	LJMP	MAIN	;JUMP TO MAIN PROGRAM
    ORG	000BH		;TIMER0 VECTOR ADDRESS
	LJMP 	ISR_T0 	;jump to ISR TIMER0
    ORG 001BH 		;Timer 1 int. vector table
	LJMP 	ISR_T1 	;jump to ISR TIMER1
;    ORG	30H	
;====================================================================
;====================================================================
MAIN:	
	MOV	P0,#00000001B
	
	MOV 	SP,#50H
	MOV 	TICK, #20D
	MOV 	TMOD, #51H
	MOV 	FREQ, #00
	SETB 	ET0
	SETB 	ET1
	SETB 	EA
	CLR 	UPDATELCD

	LCALL	LCD_INIT

	MOV 	A, #80H
	ACALL 	CMND_WRT
	MOV	DPTR, #MSG1
	ACALL	PRNT_STRNG
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
MAIN_LOOP:
	MOV 	A,#0C2H
	LCALL 	CMND_WRT
;ADJ_VALU:
	MOV 	TH0,#3CH
	MOV 	TL0,#0BAH
	MOV 	TICK,#20D
;CLR_REGS:
	MOV 	FREQ,#0D
	MOV 	TH1,#0D
	MOV 	TL1,#0D
;RESRT_TMR:
	SETB 	TR0
	SETB 	TR1
	JNB 	UPDATELCD,$
	CLR 	UPDATELCD
;LOAD_RAW:
	MOV 	XX2,FREQ
	MOV 	XX1,TH1
	MOV 	XX0,TL1

	LCALL 	BIT32_TO_DEC
	LCALL	GET_8B_DEC

SEL_MODE:
	JB 	P0.0,AUTO	; Scan for RESET button press
MANU:	LCALL	MANU_RNG
	LJMP	MAIN_LOOP
AUTO:	LCALL	AUTO_RNG
	LJMP	MAIN_LOOP
;====================================================================
;====================================================================


;====================================================================
;====================================================================
AUTO_RNG:
	MOV	A,DIGIT_7
	JNZ	MHZ_1	
	MOV	A,DIGIT_6
	JNZ	MHZ_1

	MOV	A,DIGIT_5
	JNZ	KHZ_1	
	MOV	A,DIGIT_4
	JNZ	KHZ_1	
	MOV	A,DIGIT_3
	JNZ	KHZ_1

HZ__1:	LJMP	RNG_HZ
KHZ_1:	LJMP	RNG_KHZ
MHZ_1:	;LJMP	RNG_MHZ
;RNG_MHZ:
	MOV 	DPTR,#HEX_TABLE
	MOV	A,DIGIT_7
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV	A,DIGIT_6
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV	A,#'.'
	LCALL 	DATA_WRT
	MOV	A,DIGIT_5
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV	A,DIGIT_4
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV	DPTR, #STR_MHZ
	LJMP	QUIT
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
RNG_KHZ:
	MOV 	DPTR,#HEX_TABLE
	MOV	A,DIGIT_5
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV	A,DIGIT_4
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV	A,DIGIT_3
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV	A,#'.'
	LCALL 	DATA_WRT
	MOV	A,DIGIT_2
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV	DPTR, #STR_KHZ
	LJMP	QUIT
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
RNG_HZ:
	MOV 	DPTR,#HEX_TABLE
	MOV	A,DIGIT_2
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV	A,DIGIT_1
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV	A,DIGIT_0
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV	DPTR, #STR__HZ
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
QUIT:
	MOV	A,#' '
	LCALL 	DATA_WRT			;call display subroutine
	LCALL	PRNT_STRNG
	RET
;====================================================================
;====================================================================


;====================================================================
;====================================================================
MANU_RNG:
	MOV 	DPTR,#HEX_TABLE
	MOV	A,DIGIT_7
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV 	DPTR,#HEX_TABLE
	MOV	A,DIGIT_6
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV 	DPTR,#HEX_TABLE
	MOV	A,DIGIT_5
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV 	DPTR,#HEX_TABLE
	MOV	A,DIGIT_4
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV 	DPTR,#HEX_TABLE
	MOV	A,DIGIT_3
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV 	DPTR,#HEX_TABLE
	MOV	A,DIGIT_2
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV 	DPTR,#HEX_TABLE
	MOV	A,DIGIT_1
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT
	MOV 	DPTR,#HEX_TABLE
	MOV	A,DIGIT_0
	MOVC 	A,@A+DPTR
	LCALL 	DATA_WRT

	MOV	DPTR, #STR__HZ
	MOV	A,#' '
	LCALL 	DATA_WRT			;call display subroutine
	LCALL	PRNT_STRNG

	RET

;====================================================================
;====================================================================
BIT32_TO_DEC:    
	LCALL  	CLEAR_YZ	;;CLEAR ALL YY AND ZZ BYTES
 	MOV   	YY0,#1              ;;DECIMAL ADDER = 1
 	MOV   	R0,#XX3             ;;LOCATE HOW MANY BYTES WITH DATA
 	MOV   	B,#4                ;;POSSIBLE 8 BYTES W/DATA ON XX
BITS1:       
	MOV   	A,@R0               ;;GET BYTE FROM INPUT REGISTER
	CJNE  	A,#0,BITS2          ;;JUMP IF FOUND THE FIRST NON ZERO
	DEC   	R0                  ;;GO TO LOWER BYTE
	DJNZ  	B,BITS1             ;;ONE BYTE DONE, GO AGAIN
BITS2:       
	MOV   	A,#8                ;;8 BITS PER BYTE, B CONTAINS BYTE #
	MUL   	AB                  ;;A = QUANTITY OF BITS W/DATA
	MOV   	BITS,A              ;;SAVE
	CJNE  	A,#0,X2DMAIN2       ;;B = NUMBER OF DIGITS W/DATA
	RET                       ;;RETURN IF ONLY ZEROS AT XX

;====================================================================
;====================================================================
GET_8B_DEC:
	MOV 	A,ZZ3
	LCALL 	SEPERATE
	MOV	DIGIT_7,U_NBL
	MOV	DIGIT_6,L_NBL
	MOV 	A,ZZ2
	LCALL 	SEPERATE
	MOV	DIGIT_5,U_NBL
	MOV	DIGIT_4,L_NBL
	MOV 	A,ZZ1
	LCALL 	SEPERATE
	MOV	DIGIT_3,U_NBL
	MOV	DIGIT_2,L_NBL
	MOV 	A,ZZ0
	LCALL 	SEPERATE
	MOV	DIGIT_1,U_NBL
	MOV	DIGIT_0,L_NBL
	RET

SEPERATE:
	MOV 	DPTR,#HEX_TABLE
	MOV 	TEMP1,A
	ANL 	A,#0F0H
	SWAP 	A
	MOV	U_NBL,A
	MOV 	A,TEMP1
	ANL 	A,#0FH
	MOV	L_NBL,A
	RET

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
X2DMAIN1:    
	LCALL  	X2DSHIFTD           ;;SHIFT DECIMAL RESULT
X2DMAIN2:    
	LCALL  	X2DSHIFTH           ;;SHIFT HEXA
	JNC   	X2DMAIN3            ;;IF NOT CARRY, JUST SKIP IT
	LCALL  	X2DADD              ;;ADD NEW RESULT
X2DMAIN3:    
	DJNZ  	BITS,X2DMAIN1       ;;ONE BIT DONE, GO AGAIN
	RET                       ;;GENERAL EXIT FROM THIS ROUTINE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;; ZZ0 - ZZ7 CONTAINS DECIMAL RESULT
X2DSHIFTD:   
	MOV   	R0,#YY0             ;;YY * 2  (DECIMAL)
	MOV   	B,#4                ;;NUMBER OF BYTES
	CLR   	C                   ;;NEED CARRY ZERO
X2DSHIFTD1:  
	MOV   	A,@R0               ;;IGNORE LAST CARRY
	ADDC  	A,@R0               ;;ADD BYTE TO ITSELF
	DA    	A                   ;;DECIMAL ADJUST
	MOV   	@R0,A               ;;PUT IT BACK
	INC   	R0                  ;;GO TO UPPER BYTE
	DJNZ  	B,X2DSHIFTD1        ;;DO IT 8 BYTES
	RET                       ;;RETURN
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
X2DSHIFTH:   
	MOV   	R0,#XX3             ;;SHIFT XX7 --> XX0 RIGHT 1 BIT
	MOV   	B,#4                ;;NUMBER OF BYTES
SHIFTR0B:    
	CLR   	C                   ;;NEED CARRY ZERO
SHIFTR0B1:   
	MOV   	A,@R0               ;;GET BYTE
	RRC   	A                   ;;ROTATE RIGHT THROUGH CARRY BIT
	MOV   	@R0,A               ;;SAVE IT BACK
	DEC   	R0                  ;;GO TO LOWER BYTE
	DJNZ  	B,SHIFTR0B1         ;;DO IT AGAIN "B" TIMES
	RET                       ;;RETURN
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
X2DADD:      
	MOV   	R0,#ZZ0             ;; GET RESULT ZZ 8 BYTES REGISTER
	MOV   	B,#4                ;; 8 BYTES
	MOV   	R1,#YY0             ;; GET YY OPERATOR
	CLR   	C                   ;; NEED CARRY OFF
X2DADD1:     
	MOV   	A,@R0               ;; ZZ = ZZ + YY (8BYTES) W/DAA
	ADDC  	A,@R1               ;; ADD BYTE TO BYTE 8 TIMES
	DA    	A                   ;; DECIMAL ADJUST
	MOV   	@R0,A               ;; PUT IT BACK
	INC   	R0                  ;; BUMP POINTER NEXT BYTE
	INC   	R1                  ;; BUMP POINTER NEXT BYTE
	DJNZ  	B,X2DADD1         ;; ONE BYTE DONE, GO AGAIN
	MOV  	A,ZZ3             ;; LAST CARRY TO 9TH BYTE OF ZZ
	ADDC 	A,#0              ;; JUST CARRY TO ZZ8
	MOV  	ZZ3,A             ;;
	RET                       ;; RETURN
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CLEAR_YZ:
	MOV 	R1,#9
	CLR 	A
	MOV 	R0,#YY0
YET_BYTE:
	MOV 	@R0,A
	INC 	R0
	DJNZ 	R1, YET_BYTE
	RET
;====================================================================



;====================================================================
;====================================================================
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;INTERRUPT SERVICE ROUTINE________________________________
ISR_T0:
	DJNZ 	TICK, TMR0_ISR_GO
	CLR 	TR1
	CLR 	TF1
	CLR 	TR0
	CLR 	TF0
	SETB 	UPDATELCD
	RETI
TMR0_ISR_GO:
	MOV 	TH0,#3CH
	MOV 	TL0,#0BAH
	RETI
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ISR_T1:
	INC 	FREQ
	RETI
;====================================================================
;====================================================================


;====================================================================
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRNT_STRNG:	
	CLR	A
	MOVC	A, @A+DPTR
	JZ	END_STRNG
	ACALL 	DATA_WRT			;call display subroutine
	INC	DPTR
	SJMP	PRNT_STRNG
END_STRNG:
	RET
;====================================================================

;====================================================================
;====================================================================
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
LCD_INIT:
	MOV 	A,#38H
	ACALL 	CMND_WRT	;call command subroutine
	MOV 	A,#0EH
	ACALL 	CMND_WRT
	MOV 	A,#01H
	ACALL 	CMND_WRT
	MOV 	A,#06H 		;Increment cursor
	ACALL 	CMND_WRT
	MOV 	A, #80H
	ACALL 	CMND_WRT
	MOV 	A,#3CH 		;Activate second line
	ACALL 	CMND_WRT
	RET
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DATA_WRT:
	MOV 	LCD_PORT,A
	SETB 	RS
	SJMP	PUSH_ENA
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CMND_WRT:
	MOV 	LCD_PORT,A
	CLR 	RS
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PUSH_ENA:
	SETB 	EN
	MOV	DELAY,#01D
	ACALL 	DEL_MS
	CLR 	EN
;	MOV	DELAY,#10D
;	ACALL 	DEL_MS
	RET
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DEL_MS:
	MOV 	VAR1,#230
D:	NOP
	NOP
	DJNZ 	VAR1,D
	DJNZ 	DELAY,DEL_MS
	RET
;====================================================================
;====================================================================

;====================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ORG 	300H
HEX_TABLE:
	 DB '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
MSG1: 	 DB " -Freq. Counter-",0
STR__HZ: DB 'Hz       ',0
STR_KHZ: DB 'KHz   ',0
STR_MHZ: DB 'MHz   ',0

	END

;====================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

