			ORG 0000H
			JMP main
			ORG 0003H
			LJMP interrupt0 
main: 	
			MOV IE,   #085H	;enable external interrupt


;************* one-cold for matrix keyboard ************
load:		MOV A, #0FEH		; 0E -> 0FE
rotate:		MOV P2, A
			RL A
			CJNE A,#0EFH, rotate	;07 -> 0F7
			LJMP load


;***************** interrupt  ***************
interrupt0:			
			MOV R3, A	; save one-cold
			MOV A, P2	; read matrix keyboard
			
			
zero:		CJNE A,#0EBH,one
			LCALL debounce
			CJNE A, #0EBH, one
			LCALL NOTE 	
			LJMP break
						
one:		CJNE A,#77H,two
			LCALL debounce
			CJNE A,#77H,two

			
			MOV R1,#0FCH	;DO
			MOV R0,#44H	
			
			LCALL NOTE
			LJMP break

two:		CJNE A,#7BH,three
			LCALL debounce
			CJNE A,#7BH,three


			MOV R1,#0FCH	;RE
			MOV R0,#0ADH	

			LCALL NOTE
			LJMP break			
			
three:		CJNE A,#7DH,four
			LCALL debounce
			CJNE A,#7DH,four

			
			MOV R1,#0FDH	;MI
			MOV R0,#0AH	
			
			LCALL NOTE	
			LJMP break	
	
four:		CJNE A,#0B7H,five
			LCALL debounce
			CJNE A,#0B7H,five

			
			MOV R1,#0FDH	;FA
			MOV R0,#34H			
			
			LCALL NOTE
			LJMP break			
			
five:		CJNE A,#0BBH,six
			LCALL debounce
			CJNE A,#0BBH,six

			MOV R1,#0FDH	;SOL
			MOV R0,#82H			
			
			LCALL NOTE			
			LJMP break			
			
six:		CJNE A,#0BDH,seven
			LCALL debounce
			CJNE A,#0BDH,seven

			
			MOV R1,#0FDH	;LA
			MOV R0,#0C8H			
			
			LCALL NOTE				
			LJMP break			
		
seven:		CJNE A,#0D7H,eight 
			LCALL debounce
			CJNE A,#0D7H,eight 

			
			MOV R1,#0FEH	;SI
			MOV R0,#06H				
			
			LCALL NOTE				
			LJMP break			
			
eight:		CJNE A,#0DBH,nine
			LCALL debounce
			CJNE A,#0DBH,nine
							;unused

			;LCALL NOTE				
			LJMP break			
			
nine:		CJNE A,#0DDH,AH
			LCALL debounce
			CJNE A,#0DDH,AH
							;unused
			;LCALL NOTE				
			LJMP break			
			
AH:			CJNE A,#7EH,BH
			LCALL debounce
			CJNE A,#7EH,BH
							;unused
			;LCALL NOTE				
			LJMP break
		
BH:			CJNE A,#0BEH,CH
			LCALL debounce
			CJNE A,#0BEH,CH
							;unused
			;LCALL NOTE			
			LJMP break
			
CH:			CJNE A,#0DEH,DH
			LCALL debounce
			CJNE A,#0DEH,DH
							;unused
			;LCALL NOTE				
			LJMP break			
			
DH:			CJNE A,#0EEH,EH
			LCALL debounce
			CJNE A,#0EEH,EH
							;unused
			;LCALL NOTE				
			LJMP break			
			
EH:			CJNE A,#0EDH,FH
			LCALL debounce
			CJNE A,#0EDH,FH
							;unused
			;LCALL NOTE 			
			LJMP break			
			
FH:			CJNE A,#0E7H,break
			LCALL debounce
			CJNE A,#0E7H,break
							;unused
			;LCALL NOTE 	
			
break:		MOV A, R3 ; retrieve one-cold
			RETI
			
			
;*********  NOTE **********
NOTE:  		MOV TMOD,#01H
UP:			SETB P1.0
			LCALL DELAY
			CLR P1.0
			LCALL DELAY
			JNB P3.2,UP
			
DELAY:		MOV TH0,R1
			MOV TL0,R0
			CLR TF0
			SETB TR0
			JNB TF0,$
			RET


;********** debounce  ***********
debounce: 
			MOV		R7, #0FFH
loop:		DJNZ	R7,loop

			RET
END