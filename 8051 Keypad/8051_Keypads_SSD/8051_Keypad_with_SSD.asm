;====================================================================
; PROCESSOR: AT89C51
; COMPILER:  MPASM
;====================================================================

$NOMOD51
$INCLUDE (8051.MCU)

;====================================================================
; DEFINITIONS
;====================================================================

;====================================================================
; VARIABLES
;====================================================================

;====================================================================
; RESET AND INTERRUPT VECTORS
;====================================================================

      ; RESET VECTOR
      ORG   0000H
     


 JMP   START
;====================================================================
; CODE SEGMENT
;====================================================================


      ORG   0100H

START:	
     MOV P2,#0FFH	
MOV TH0,#0FFH
MOV TL0,#0FEH
MOV TMOD ,#01

K1:	MOV P1,#0D
		MOV A,P2
		ANL A,#00001111B
		CJNE A,#00001111B,K1
K2:	;ACALL DELAY
		MOV A,P2
		ANL A,#00001111B
		CJNE A,#00001111B,OVER 
		SJMP K2		
OVER : ;ACALL DELAY 	
		MOV A,P2
		ANL A,#00001111B
		CJNE A,#00001111B,OVER1
		SJMP K2

OVER1:  MOV P1,#11111110B
			MOV A,P2
			ANL A,#00001111B

			CJNE A,#00001111B,ROW_0
			MOV P1,#11111101B
			MOV A,P2
			ANL A,#00001111B
			CJNE A,#00001111B,ROW_1

		MOV P1,#11111011B
		MOV A,P2
		ANL A,#00001111B
		CJNE A,#00001111B,ROW_2

			MOV P1,#11110111B
			MOV A,P2
			ANL A, #00001111B
			CJNE A,#00001111B,ROW_3
LJMP K2
			
	ROW_0: MOV DPTR,#KCODE0
		SJMP FIND
	ROW_1: MOV DPTR,#KCODE1
		SJMP FIND
	ROW_2: MOV DPTR,#KCODE2
		SJMP FIND
	ROW_3: MOV DPTR,#KCODE3
		SJMP FIND

	FIND : RRC A
		JNC MATCH 
		INC DPTR 
	SJMP FIND 
	MATCH : CLR A 
	MOVC A,@A+DPTR
	MOV P0,A
LJMP K1


	ORG  300H
	
KCODE0:   DB   0B,00000001B,00000010B,00000011B
KCODE1:   DB   00000100B,00000101B,00000110B,00000111B
KCODE2:   DB   00001000B,00001001B,00001010B,00001011B
KCODE3:   DB   00001100B,00001101B,00001110B,00001111B



DELAY:
  MOV R6,0
  LP:    
  SETB TR0
    AGAIN: JNB TF0,AGAIN  
        CLR TR0
        CLR TF0
    DJNZ R6,LP
        RET


LOOP:	
      JMP LOOP

;====================================================================
      END
