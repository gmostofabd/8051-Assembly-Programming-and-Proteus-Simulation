;***********************************************************************************************
;	  	Program for Sending SMS through GSM network using 
;		SIM900D and AT89C51
;***********************************************************************************************
;		Author : Malik Umair Latif
;		Company: ElektroSoft Solutions
;		Website: www.essol.com.pk
;		Date   : 24 May 2013
;***********************************************************************************************

            ORG 00H
			ACALL SERIAL
		 	ACALL DELAY1
            ACALL DELAY1 
            ACALL DELAY1 
            ACALL DELAY1    
  			ACALL CMGF
 			ACALL DELAY1
            ACALL DELAY1 
            ACALL DELAY1 
            ACALL DELAY1    
			ACALL CNMI
 			ACALL DELAY1
            ACALL DELAY1 
            ACALL DELAY1 
            ACALL DELAY1    
			ACALL CMGS
 			ACALL DELAY1
            ACALL DELAY1 
            ACALL DELAY1 
            ACALL DELAY1    
			ACALL SALAM
			ACALL THIEF		   
 			ACALL DELAY1
            ACALL DELAY1 
            ACALL DELAY1 
            ACALL DELAY1      
      AGAIN:SJMP AGAIN
;***********************************************************************************************
;	Subroutine for Sending one byte out of serial port
;***********************************************************************************************
  TRAIN:    MOV SBUF,A
  HERE:     JNB TI,HERE
            CLR TI
            RET
;***********************************************************************************************
;	Subroutine for initializing the serial port with 9600BPS
;***********************************************************************************************
	SERIAL:	MOV TMOD,#20H
            MOV TH1,#-3
            MOV SCON,#50H
            SETB TR1
			RET
;***********************************************************************************************
;	Subroutine for CMGF
;***********************************************************************************************
	CMGF:	MOV DPTR,#TABLE1
            MOV R7,#10
    LOOP1:  MOV A,#0
            MOVC A,@A+DPTR
            INC DPTR 
            ACALL TRAIN
		;	ACALL DELAY
            DJNZ R7,LOOP1 
			RET
;***********************************************************************************************
;	Subroutine for CNMI
;***********************************************************************************************
	CNMI:	MOV DPTR,#TABLE2
            MOV R7,#18
    LOOP2:  MOV A,#0
            MOVC A,@A+DPTR
            INC DPTR
            ACALL TRAIN
		;	ACALL DELAY
            DJNZ R7,LOOP2 
			RET
;***********************************************************************************************
;	Subroutine for CMGS
;***********************************************************************************************
	CMGS:	MOV DPTR,#TABLE3
            MOV R7,#22
    LOOP3:  MOV A,#0
            MOVC A,@A+DPTR
            INC DPTR
            ACALL TRAIN
		;	ACALL DELAY
            DJNZ R7,LOOP3 
			RET
;***********************************************************************************************
;	Subroutine for SALAM
;***********************************************************************************************
	SALAM:	MOV DPTR,#TABLE4
            MOV R7,#18
    LOOP4:  MOV A,#0
            MOVC A,@A+DPTR
            INC DPTR
            ACALL TRAIN
		;	ACALL DELAY
            DJNZ R7,LOOP4 
			RET
;***********************************************************************************************
;	Subroutine for THIEF
;***********************************************************************************************
	THIEF:	MOV DPTR,#TABLE5
            MOV R7,#31
    LOOP5:  MOV A,#0
            MOVC A,@A+DPTR
            INC DPTR
            ACALL TRAIN
		;	ACALL DELAY
            DJNZ R7,LOOP5 
			RET
;***********************************************************************************************
;	Subroutine for delay
;***********************************************************************************************
  DELAY:	MOV R0,#50
  RELOAD:	MOV R1,#50
  WAIT:		DJNZ R1,WAIT
  			DJNZ R0,RELOAD
			RET
;***********************************************************************************************
;	Subroutine for LARGE delay
;***********************************************************************************************
  DELAY1:	MOV R0,#255
  RELOAD1:	MOV R1,#255
  WAIT1:    DJNZ R1,WAIT1
  			DJNZ R0,RELOAD1
			RET  
;***********************************************************************************************
;	Lookup Tables
;***********************************************************************************************
  TABLE1:   DB "AT+CMGF=1",0Dh
  TABLE2: 	DB "AT+CNMI=2,2,0,0,0",0Dh
  TABLE3: 	DB 'AT+CMGS="03301234567"',0Dh
  TABLE4: 	DB "ASSALAM-O-ALAIKUM",0Dh
  TABLE5: 	DB "GSM is working",1Ah
  
  			END