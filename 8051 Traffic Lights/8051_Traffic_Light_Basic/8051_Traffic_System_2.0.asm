ORG 0000H 
START:  MOV R0, #04H 
  MOV TMOD, #01H 
  MOV DPTR, #1000H 
   LOOP: MOV A, #00H 
      MOVC A, @A+DPTR 
   MOV P0, A 
   INC DPTR 
   MOV A, #00H 
   MOVC A, @A+DPTR 
   MOV P1, A 
   LCALL DELAY1 
   INC DPTR 
    
   MOV A, #00H 
   MOVC A, @A+DPTR 
   MOV P0, A 
   INC DPTR 
   MOV A, #00H 
   MOVC A, @A+DPTR 
   MOV P1, A 
   LCALL DELAY2 
   INC DPTR 
   DJNZ R0, LOOP 
   SJMP START 
 
DELAY1: MOV R1, #099H 
  HERE: MOV TH0, #00H 
  MOV TL0, #00H 
  SETB TR0 
  WAIT: JNB TF0, WAIT 
  CLR TR0 
   
 
                             CLR TF0 
  DJNZ R1, HERE 
  RET 
 
DELAY2: MOV R1, #03DH 
  HERE1: MOV TH0, #00H 
  MOV TL0, #00H 
  SETB TR0 
  WAIT1: JNB TF0, WAIT1 
  CLR TR0 
  CLR TF0 
  DJNZ R1, HERE1 
  RET 
 
ORG 1000H 
DB 33H, 36H, 2BH, 36H, 1EH, 36H, 1EH, 35H, 36H, 33H, 36H, 2BH, 36H, 1EH, 35H, 1EH 
  
END 