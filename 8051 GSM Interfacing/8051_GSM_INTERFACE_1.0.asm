ORG 000H
MOV TMOD,#00100001B        
MOV TH1,#253D           
MOV SCON,#50H          
SETB TR1

RS EQU P2.7
RW EQU P2.6
E  EQU P2.5
        
MAIN: ACALL DINT 

MOV A,#"A"
ACALL SEND
MOV A,#"T"
ACALL SEND
MOV A,#0DH
ACALL SEND
ACALL DELAY1


MOV A,#"A"
ACALL SEND
MOV A,#"T"
ACALL SEND
MOV A,#"+"
ACALL SEND
MOV A,#"C"
ACALL SEND
MOV A,#"M"
ACALL SEND
MOV A,#"G"
ACALL SEND
MOV A,#"F"
ACALL SEND
MOV A,#"="
ACALL SEND
MOV A,#"1"
ACALL SEND
MOV A,#0DH
ACALL SEND
ACALL DELAY1


MOV A,#"A"
ACALL SEND
MOV A,#"T"
ACALL SEND
MOV A,#"+"
ACALL SEND
MOV A,#"C"
ACALL SEND
MOV A,#"M"
ACALL SEND
MOV A,#"G"
ACALL SEND
MOV A,#"S"
ACALL SEND
MOV A,#"="
ACALL SEND
MOV A,#34D
ACALL SEND
MOV A,#"+"
ACALL SEND
MOV A,#"9"
ACALL SEND
MOV A,#"1"
ACALL SEND
MOV A,#"9"
ACALL SEND
MOV A,#"5"
ACALL SEND
MOV A,#"4"
ACALL SEND
MOV A,#"4"
ACALL SEND
MOV A,#"3"
ACALL SEND
MOV A,#"4"
ACALL SEND
MOV A,#"0"
ACALL SEND
MOV A,#"0"
ACALL SEND
MOV A,#"7"
ACALL SEND
MOV A,#"7"
ACALL SEND
MOV A,#34D
ACALL SEND
MOV A,#0DH
ACALL SEND
ACALL DELAY1


MOV A,#"H"
ACALL SEND
MOV A,#"E"
ACALL SEND
MOV A,#"L"
ACALL SEND
MOV A,#"L"
ACALL SEND
MOV A,#"O"
ACALL SEND
ACALL DELAY1

MOV A,#1AH
ACALL SEND


ACALL DELAY1


ACALL DINT     
ACALL TEXT1
ACALL DELAY1
HERE1:SJMP HERE1


SEND:CLR TI
     MOV SBUF,A
WAIT:JNB TI,WAIT
     RET


DELAY1:MOV R6,#15D       
BACK: MOV TH0,#00000000B   
      MOV TL0,#00000000B   
      SETB TR0             
HERE: JNB TF0,HERE        
      CLR TR0              
      CLR TF0             
      DJNZ R6,BACK
      RET
      
DELAY: CLR E
    CLR RS
    SETB RW
    MOV P0,#0FFh
    SETB E
    MOV A,P0
    JB ACC.7,DELAY
    CLR E
    CLR RW
    RET      
      
 DISPLAY:MOV P0,A
    SETB RS
    CLR RW
    SETB E
    CLR E
    ACALL DELAY
    RET     
      
LCD_CMD:      
CMD: MOV P0,A
    CLR RS
    CLR RW
    SETB E
    CLR E
    ACALL DELAY
    RET

  DINT:MOV A,#0FH 
    ACALL CMD
    MOV A,#01H 
    ACALL CMD
    MOV A,#0CH 
    ACALL CMD
    MOV A,#06H 
    ACALL CMD
    MOV A,#81H 
    ACALL CMD
    MOV A,#3CH 
    ACALL CMD
    RET 

 ;====================================================
; LCD
;====================================================
;==================== LCD (delay based) ===============================
LCD_INIT:
    MOV A, #038H
    ACALL LCD_CMD
    ACALL DELAY

    MOV A, #00EH
   ACALL LCD_CMD
    ACALL DELAY

    MOV A, #001H
    ACALL LCD_CMD
    ACALL DELAY

    MOV A, #006H
    ACALL LCD_CMD
    ACALL DELAY

    MOV A, #080H
    ACALL LCD_CMD
    ACALL DELAY
RET

 
 
 
 TEXT1: MOV A,#"S"
    ACALL DISPLAY
    MOV A,#"E"
    ACALL DISPLAY
    MOV A,#"N"
    ACALL DISPLAY
    MOV A,#"T"
    ACALL DISPLAY
    MOV A,#" "
    ACALL DISPLAY
    MOV A,#" "
    ACALL DISPLAY
    MOV A,#" "
    ACALL DISPLAY
    RET 
             
 END