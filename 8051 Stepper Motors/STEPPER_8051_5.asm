A1 EQU P3.0
A2 EQU P3.1
A3 EQU P3.2
A4 EQU P3.3
ORG 00H
MOV TMOD,#00000001B

MAIN:
CLR A1
ACALL DELAY
SETB A1

CLR A2
ACALL DELAY
SETB A2

CLR A3
ACALL DELAY
SETB A3 

CLR A4
ACALL DELAY
SETB A4
SJMP MAIN
      

DELAY:MOV R6,#1D       
BACK: MOV TH0,#00000000B   
      MOV TL0,#00000000B   
      SETB TR0             
HERE2: JNB TF0,HERE2        
      CLR TR0              
      CLR TF0             
      DJNZ R6,BACK
      RET
END