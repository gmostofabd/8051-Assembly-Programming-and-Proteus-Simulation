;***********************************************************************************************
;	  	Program for testing SMS sending through GSM network using 
;		SIM900D and AT89C51
;***********************************************************************************************
;		Author : Malik Umair Latif
;		Company: ElektroSoft Solutions
;		Website: www.essol.com.pk
;		Date   : 24 April 2013
;***********************************************************************************************
		ORG 0000H
		
	; GSM COMMUNICATION SOFTWARE SIMULTION	
		
		MOV TMOD,#20H	   		
		MOV TH1,#0FDH			
		MOV SCON,#50H			
		SETB TR1
		
 		MOV P0, #00000111B
START:	MOV A, P0
		CJNE A, #00000001B, NEXT
		SJMP ONE
NEXT:	CJNE A, #00000010B, NEXT_2
		SJMP TWO
NEXT_2:	CJNE A, #00000100B, START
		SJMP THREE
 
ONE:	MOV DPTR,#MSG1
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG2
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG3
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG4
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG5
		ACALL H1
		ACALL DELAY
		LJMP START
		
TWO:	MOV DPTR,#MSG1
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG2
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG3
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG4
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG6
		ACALL H1
		ACALL DELAY
		LJMP START
		
THREE:	MOV DPTR,#MSG1
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG2
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG3
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG4
		ACALL H1
		ACALL DELAY
		MOV DPTR,#MSG7
		ACALL H1
		ACALL DELAY
		LJMP START				
		
H1:  	CLR A
		MOVC A,@A+DPTR
		JZ B1
		ACALL SEND
		INC DPTR
		SJMP H1
B1:
		RET
SEND: 	MOV SBUF,A
H2: 	JNB TI,H2
		CLR TI
		RET
DELAY:  MOV R3,#50H
HERE2:  MOV R4,#50H
HERE:	DJNZ R4,HERE
		DJNZ R3,HERE2
		RET
 
 
ORG 300H
MSG1: DB "AT",0DH
	  DB 0H
MSG2: DB "AT+CMGF=1",0DH
	  DB 0H
MSG3: DB "ATE=0",0DH
      DB 0H
MSG4: DB "AT+CMGS=",'"8149111111"',0DH
	  DB 0H
MSG5: DB "ANALOG INPUT 1 ACTIVATED",0X1A
	  DB 0H
MSG6: DB "ANALOG INPUT 2 ACTIVATED",0X1A
	  DB 0H
MSG7: DB "ANALOG INPUT 3 ACTIVATED",0X1A
	  DB 0H	  	  
 
	  END
