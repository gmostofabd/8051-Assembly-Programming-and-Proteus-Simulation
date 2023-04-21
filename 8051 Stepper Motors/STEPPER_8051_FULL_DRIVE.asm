; Full Drive Mode
ORG 00H
MOV TMOD,#01H
MAIN:
MOV P3, #0CH
ACALL DELAY
MOV P3, #06H
ACALL DELAY      
MOV P3, #03H
ACALL DELAY
MOV P3, #09H
ACALL DELAY
SJMP MAIN 



; To generate a delay of 200 *1 ms
DELAY:MOV R0,#200 ;change this value to required delay in ms       
BACK: MOV TH0,#0FDH  	; #0FCH FOR 200 MS
      MOV TL0,#0FFH   ;#018H FOR 200 MS
      SETB TR0             
wait: JNB TF0,wait       
      CLR TR0              
      CLR TF0             
      DJNZ R0,BACK
      RET
END