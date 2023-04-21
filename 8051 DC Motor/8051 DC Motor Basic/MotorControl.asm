// PWM Motor Control

ORG 0000H

MAIN:
    MOV P3,#00H   ;LCD data pin
	MOV P2,#00FH  ;column as input, p2.4 p2.5 p2.6 lcd pins output
    MOV P1,#00H	  ;Lower nibble -Row as output, higher nibble motor
	SETB P1.4
	CLR  P1.5
	
	
	SETB PSW.4 
	CLR  PSW.3  ;SELECT BANK 2
	MOV R6,#01
	MOV R7,#128
	CLR PSW.4
    CLR PSW.3   ;SELECT BANK 0

	MOV P0,#00H 
	MOV P0,#0FH 


//--------- *lCD* --------------
MOV DPTR,#MYCOM
initLCD:
   	  CLR A
      MOVC A,@A+DPTR
      ACALL COMNWRT
      ACALL DELAY
      JZ SEND_DAT
      INC DPTR
      SJMP initLCD 

SEND_DAT:  MOV DPTR,#MYDATA
		   MOV A,#01H
           ACALL COMNWRT
	       ACALL DELAY
D1:   CLR A
      MOVC A,@A+DPTR
      ACALL DATAWRT
      ACALL DELAY
      INC DPTR
      JZ SEND_DAT1
      SJMP D1

SEND_DAT1:  MOV DPTR,#MYDATA1
	  MOV A,#0C0H
	  ACALL COMNWRT
	  ACALL DELAY

D2:   CLR A
      MOVC A,@A+DPTR
      ACALL DATAWRT
      ACALL DELAY
      INC DPTR
      JZ ENTER
      SJMP D2

COMNWRT:
       ACALL READY
       MOV P3,A
       CLR P2.4
       CLR P2.5
       SETB P2.6
       ACALL DELAY
       CLR P2.6
       RET
      
DATAWRT:
       ACALL READY
	   MOV P3,A
       SETB P2.4
       CLR P2.5
       SETB P2.6
       ACALL DELAY
       CLR P2.6
       RET

DELAY:
      //MOV R3,#00
HERE2: MOV R4,#255
HERE:  DJNZ R4,HERE
       //DJNZ R3,HERE2
       RET

READY:   SETB P3.7
         CLR  P2.4
         SETB P2.5
;read command reg and check busy flag
BACK:    CLR P2.6
         ACALL DELAY
         SETB P2.6
         JB   P3.7,BACK
         RET 
 //-------------E-Enter------------

ENTER:SETB PSW.4 
	  CLR  PSW.3  ;SELECT BANK 2
      MOV P1,#11110111B
      SETB P1.4		 ;SETB P1.4
   	  CLR  P1.5      ;CLR  P1.5 
   	                              
AGAIN:JNB P2.3,K0
	  
	  ; MOTOR
	  SETB P1.6                 ;MOV P1,#00000001B // motor runs clockwise
      MOV A,R7
	  MOV R5,A
	      MOV P0,R5
	  ACALL DELAYON             // calls the 1S DELAY
	  
	  JNB P2.3,K0
      CLR P1.6                   ; MOV P1,#00000010B       // motor runs anti clockwis
      //MOV A,R6
	  MOV R5,10
	  ACALL DELAYOFF            // calls the 1S DELAY
      SJMP AGAIN
      
DELAYON:
      
//WAIT1: MOV R3,#00H
//WAIT2: MOV R2,#00H
WAIT3: DJNZ R5,WAIT3	 ;R2
       //DJNZ R3,WAIT2 
       //DJNZ R5,WAIT1		  ;R7 T -ON
       RET

DELAYOFF:
       //MOV R6,#05H 
//WAIT4: MOV R3,#00H
//WAIT5: MOV R2,#00H
WAIT6: DJNZ R5,WAIT6
       //DJNZ R3,WAIT5 
       //DJNZ R5,WAIT4     ;R6 T-OFF
       RET

       

 //-----------HEX KEYPAD--------------
K0:
   CLR PSW.4
   CLR PSW.3   ;SELECT BANK 0 

   MOV R1,#03H    ;INIT COUNTER
   MOV R7,#0H     ;MAKE PWM ZERO
   
   CLR P1.6 ;making EN 0 
   
   MOV A,#01H	   ; cmnd -to clr display
   ACALL COMNWRT
   ACALL DELAY
   MOV DPTR,#MYDATA2

D3:   CLR A
      MOVC A,@A+DPTR
      ACALL DATAWRT
      ACALL DELAY
      INC DPTR
      JZ K1
      SJMP D3


K1: MOV P1,#0
    MOV A,P2
	ANL  A,#00001111B				 
	CJNE A,#00001111B,K1

K2: ACALL DELAY1
    MOV A,P2
	ANL  A,#00001111B
	CJNE A,#00001111B,OVER
	SJMP K2

OVER:ACALL DELAY1
     MOV A,P2
	 ANL  A,#00001111B
	 CJNE A,#00001111B,OVER1
     SJMP K2

OVER1:MOV P1,#11111110B
      CLR P1.6 ;making EN 0 
      MOV A,P2
	  ANL A,#00001111B
	  CJNE A,#00001111B,ROW_0

	  MOV P1,#11111101B
	  CLR P1.6 ;making EN 0 
      MOV A,P2
	  ANL A,#00001111B
	  CJNE A,#00001111B,ROW_1

	  MOV P1,#11111011B
	  CLR P1.6 ;making EN 0 
      MOV A,P2
	  ANL A,#00001111B
	  CJNE A,#00001111B,ROW_2

	  MOV P1,#11110111B
	  CLR P1.6 ;making EN 0 
      MOV A,P2
	  ANL A,#00001111B
	  CJNE A,#00001111B,ROW_3
	  LJMP K2


ROW_0:MOV DPTR,#KCODE0
      SJMP FIND 
ROW_1:MOV DPTR,#KCODE1
      SJMP FIND 	 
ROW_2:MOV DPTR,#KCODE2
      SJMP FIND 
ROW_3:MOV DPTR,#KCODE3
      SJMP FIND
	  
FIND: RRC A
      JNC MATCH
	  INC DPTR
	  SJMP FIND
MATCH:CLR A
      MOVC A,@A+DPTR
	  MOV P3,A	            // output at 3
	  ACALL DATAWRT
	  
	  ANL A,#0FH            // MASK HIGHER NIBBLE
	  DJNZ R1,CON
	  ADD A,R7
      
		  SETB PSW.4
		  CLR PSW.3    ;SELECT BANK 2
	      MOV R7,A
		      
		  CLR PSW.4
	      CLR PSW.3   ;SELECT BANK 0
			  	
	  MOV  A,#0AH
	  SUBB A,R7

		  SETB PSW.4
		  CLR PSW.3    ;SELECT BANK 2
		  MOV  R6,A
	      CLR PSW.4
	      CLR PSW.3   ;SELECT BANK 0
	    
	  LJMP 	SEND_DAT

  CON:ACALL CONVERT
      //ACALL DELAY
 	  LJMP K1

  //---------CONVERT MOTOR--------------
CONVERT:MOV R3,A	  ; SAVE NUMBER IN R3
        MOV A,R1	  ;
        MOV	R2,A	  ;Put counter in R2
		MOV A,R3	  ;PUT THE NUMBER BACK TO A
		

   MUX: MOV B,#10
        MUL AB		  ; MULTIPLY 10
        DJNZ R2,MUX	   ;depending on position
	
		ADD A,R7
		MOV R7,A
	
        RET
        

	  


DELAY1: 
WAIT7: MOV R3,#20H
WAIT8: MOV R2,#20H
WAIT9: DJNZ R2,WAIT9
       DJNZ R3,WAIT8 
       RET

 ;ACII LOOK-UP TABLE FOR EACH ROW
  
  ORG 300H
  KCODE0: DB '1', '2','3','0'
  KCODE1: DB '4', '5','6','0'
  KCODE2: DB '7', '8','9','0'
  KCODE3: DB '0', '0','0','E'

  MYCOM:   DB 38H,0EH,01,0
  MYDATA:  DB "press E-enter ",0
  MYDATA1: DB "to change PWM",0 
  MYDATA2: DB "Enter PWM-",0
  END