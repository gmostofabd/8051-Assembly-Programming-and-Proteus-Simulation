
	ROW	EQU	P2
	COL	EQU 	P3
	
	ORG 00H
	MOV 	P3,#00000000B	; initializes port 3 as output port
	MOV 	ROW,#00000000B	; initializes port 1 as output port

MAIN: 	
	LCALL	LET_A
      	SJMP 	MAIN         	; jumps back to the main loop

LET_A:
	MOV 	P3,#01111110B 
      	MOV 	ROW,#11111110B  
      	ACALL 	DELAY        
      	MOV 	P3,#00010001B  
      	MOV 	ROW,#11111101B  
      	ACALL 	DELAY
      	MOV 	P3,#00010001B  
      	MOV 	ROW,#11111011B  
      	ACALL 	DELAY
      	MOV 	P3,#00010001B
      	MOV 	ROW,#11110111B
      	ACALL 	DELAY
      	MOV 	P3,#01111110B
      	MOV 	ROW,#11101111B
      	ACALL 	DELAY
	RET

DELAY: 	MOV 	R6,#255D     ; 1ms delay subroutine
HERE: 	DJNZ 	R6,HERE
      	RET
	
	END