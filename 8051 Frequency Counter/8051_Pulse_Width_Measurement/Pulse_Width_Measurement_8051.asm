;GROUP-2
;190021312, 310, 318, 336 ,344

	ORG 00H     	
	LJMP MAINN  	
	
	ORG 002BH   			; Interrupt Location
	CPL P2.6    	
	CLR T2CON.7 	
	RETI	    	
	
	ORG 0030H
	MAINN:
	MOV SP, #70H  	
	MOV PSW, #00H 	
	 
	RS EQU P2.0 	
	RW EQU P2.1 	
	ENBL EQU P2.2 	
					
	T2CON EQU 0C8H  		; Had to name memory locations of  timer2 components as missing in MIDE
	T2MOD EQU 0C9H  
	TR2 EQU T2CON.2 
	RCAP2L EQU 0CAH 
	RCAP2H EQU 0CBH 
	
	DTC EQU 67H     
	FD1 EQU 51H	
	FD2 EQU 52H	
	FD3 EQU 53H	
	FD4 EQU 54H	
	FD5 EQU 55H	
	
	CAR_TOFF EQU 61H
	TOFF1 EQU 58H	
	TOFF2 EQU 59H	
	CAR_TON EQU 62H 
	TONE1 EQU 5AH    
	TONE2 EQU 5BH   
	
	TOT0 EQU 66H    
	TOT1 EQU 65H    
	TOT2 EQU 64H	
	
	REM  EQU 63H    
	
	HIH EQU 6EH	
	LWO EQU 6FH	
	
	CLR P3.0 	
 	CLR P3.1 	
 	CLR P3.2 	
 	
 	SETB P3.3
 	SETB P2.7 	
 	CLR P2.3 	
 	CLR P2.4 	
 	CLR P2.5 	
	MOV A,#0d 	
	MOV CAR_TOFF,A  
	MOV CAR_TON,A   
		
	LCALL LCD_SET_UP 	
	LCALL 	DELAY    	
	
 	MOV DPTR, #MSG_1 	
	LCALL STR_DISP	
	
	MOV DPTR, #MSG_2  
	MOV A, #0C0H
	LCALL COMMAND
	LCALL DELAY
	LCALL STR_DISP
 	
 	SETB P3.4			;set the port to input mode (F1) COUNTER 0 as EXTERNAL INPUT
 	SETB P3.5			;set the port to input mode (F2) COUNTER 1 as EXTERNAL INPUT
;---------------------------------------------------------------------------------------------------------------------TASK 1  
;--------------------------------------------------------------------------FREQUENCY MEASUREMENT of 1st Input Signal 
AT_START:	
	CLR P3.2 			; task 2 light off
	SETB P3.1 			; task 1 light on
	
	MOV TMOD, #15H 			; Timer 1 as timer and Timer 0 as counter
	MOV TCON, #00H
						
	MOV TL0,#00H
	MOV TH0,#00H
	F1_low1: JNB P3.4,F1_low1 	; Dropping two cycle to sync with the 1st signal input					
	F1_high1: JB P3.4,F1_high1 						
	SETB TR0 
	
	MOV R0,#15 			; Make 1 SECOND 
AGN:  	MOV TL1, #0FBH
	MOV TH1, #0FH
	SETB TR1 
BACK:   JNB TF1, BACK
	CLR TF1
	CLR TR1
	DJNZ R0, AGN
	CLR TR0	
;---------------------------------------------------------------------------DISPLAY FREQUENCY 1
	LCALL LCD_SET_UP
	MOV DPTR, #MSG_3
	LCALL STR_DISP
	
	MOV A, #0C0H	
	LCALL COMMAND
	LCALL DELAY
	
	CLR A
	MOV R1,A 
	MOV R0,A
	MOV R2,A
	MOV R3,A
	MOV R5,A
	
	MOV R3, TH0	
	MOV R2, TL0	
	
	PUSH 03				; keep TH0 of F1 in stack pointer 
	PUSH 02				; keep TL0 of F1 in stack pointer
	
	LCALL PRINT_DIGIT_16

	MOV DPTR, #HZ
	LCALL STR_DISP
	
;-------------------------------------------------------------------------Buzzer Alarm
	MOV A,TH0
	JNZ NALRM
	MOV A,TL0
	MOV B,#50d
	CJNE A,B,ALRM 			; if TL0 < 50hz
ALRM:	JNC NALRM
	SETB P3.0 
	LJMP OKK
NALRM:  CLR P3.0  
OKK:		
;--------------------------------------------------------------------------Display difference from 50Hz

LCALL LCD_SET_UP
MOV DPTR, #MSG_4
LCALL STR_DISP

MOV A, #0C0H
LCALL COMMAND
LCALL DELAY

CLR A
CLR C
MOV A , TL0
SUBB A, #50d
MOV R2, A
MOV A, TH0
SUBB A, #0
MOV R3, A

JNC NEEE                         ; if carry not found F1>50hz , go to NEEE

NEE: 
MOV A, #50d
SUBB A, TL0
MOV R2, A
MOV R3, #0

NEEE:
MOV R5,#0d
LCALL PRINT_DIGIT_16 		; show difference
MOV DPTR, #HZ
LCALL STR_DISP	
;-------------------------------------------------------------------------------TOFF CALCULATION
MOV TL1, #00H 							
MOV TH1, #00H 							
TOFF_low1: JNB P3.4,TOFF_low1 		; Dropping two cycle to sync with the signal input
TOFF_high1: JB P3.4,TOFF_high1 						 						
SETB TR1 				; start timer when pulse is low.
TOFFL_1: JNB P3.4 , TOFFL_2 ;
	SJMP TOFFL_3 
TOFFL_2: JNB TF1  , TOFFL_1 ;
	INC CAR_TOFF			; increment MSB of TOFF
	CLR TF1         
	SJMP TOFFL_1       					
TOFFL_3: CLR TR1		  					
	MOV TOFF1, TH1						
	MOV TOFF2, TL1						
;------------------------------------------------------------------------------TON CALCULATION
MOV TL1, #00H 						
MOV TH1, #00H 						
TON_low1:  JB P3.4 ,TON_low1		; Dropping two cycle to sync with the signal input
TON_high1: JNB P3.4,TON_high1				 				
SETB TR1 				; start timer when pulse is high.
TONL_1: JB P3.4 , TONL_2 ;
	SJMP TONL_3 
TONL_2: JNB TF1  , TONL_1 ;
	INC CAR_TON			; increment MSB of TONE
	CLR TF1         
	SJMP TONL_1     				
TONL_3: CLR TR1				   
	MOV TONE1, TH1				   
	MOV TONE2, TL1				   
;-------------------------------------------------------------------------------FIND DUTY CYCLE
;--------------------------------------------------------------------MAKE Ttotal
;CAR_TON
MOV R6,TONE1 				
MOV R7,TONE2
;CAR_TOFF
MOV R4,TOFF1 				
MOV R5,TOFF2

LCALL ADD_24bit				; output stored in TOT0(highest) TOT1(high byte) TOT2
MOV TOT0, R1
MOV TOT1, R2
MOV TOT2, R3

;--------------------------------------------------------------------------------Two Ttotal secnario
CLR C
MOV A, TOT2
SUBB A,#10001010b
MOV A, TOT1
SUBB A,#00000010b
MOV A, TOT0
SUBB A, #0d				; whether Total < 650 or note
JC SEC_CASEE  			
;--------------------------------------------------------------------------------First case where Ttotal>100
FIR_CASEE:
					;1st part
	MOV R2, TOT2
	MOV R3, TOT1
	MOV R4, TOT0
	MOV R0, #100d
	MOV R1, #0d
	MOV A,#0d   			;clear
	MOV R6,A 
	MOV R7,A
	MOV R5,A
	LCALL DIV_24bit
	MOV TOT2, R6
	MOV TOT1, R7
					;2nd part
	MOV R2, TONE2
	MOV R3, TONE1
	MOV R4, CAR_TON;
	MOV R0, TOT2
	MOV R1, TOT1
	MOV A,#0d   			;clear
	MOV R6,A
	MOV R7,A
	MOV R5,A;
	LCALL DIV_24bit

	LJMP EXITTT
;---------------------------------------------------------------------------------Second case where Ttotal<=100
SEC_CASEE:
	CLR C			;1st part ,output will be Ton*100
; First number in R6(H) and R7 
; Second number in R4(H) and R5. 
; Result oin R0(MSB), R1, R2 and R3(LSB).
	MOV R6, TONE1
	MOV R7, TONE2
	
	MOV R4,#0d
	MOV R5,#100d
	
	LCALL MUL16_bit
	
	MOV TONE2 , R3
	MOV TONE1 , R2
					;2nd part
	MOV R2, TONE2 	
	MOV R3, TONE1
	MOV R4, #0d   			;msb as TON can't be more than 16 bit 
	MOV R0, TOT2  	
	MOV R1, TOT1  	
	MOV A,#0d 			;clear
	MOV R6,A 
	MOV R7,A
	MOV R5,A
	LCALL DIV_24bit

EXITTT:
	MOV LWO, R6
	MOV HIH, R7
;------------------------------------------------------------------------------------Display duty cycle
MOV DTC, LWO

MOV A, LWO;-------redundency
SUBB A, #01100100b
JC RED

MOV DTC, #01011111b
CLR C
RED:
	LCALL LCD_SET_UP
	MOV DPTR, #MSG_7
	LCALL STR_DISP
	
	MOV A, #0C0H	
	LCALL COMMAND
	LCALL DELAY
	
	CLR A
	MOV A,DTC			; TL0 CONTAINS Duty cycle COUNT
	LCALL PRINT_DIGIT

 	CLR P3.1
 	SETB P3.2
;------------------------------------------------------------------------------------------------------------TASK2
;-------------------------------------------------------------------FREQUENCY MEASUREMENT of 2nt Input Signal
MOV TMOD, #51H 				; Timer 1 as counter and Timer 0 as timer
MOV TCON, #00H
			
MOV TL1,#00H
MOV TH1,#00H
F2_low1: JNB P3.5,F2_low1 						
F2_high1: JB P3.5,F2_high1 						
			 		; done to sync with the 2nd Input signal from start
SETB TR1 
	
MOV R0,#15 				; MAKE 1 SECOND  
AGN1:  	MOV TL0, #0FBH
	MOV TH0, #0FH
	SETB TR0 
BACK1:   JNB TF0, BACK1
	CLR TF0
	CLR TR0
	DJNZ R0, AGN1
	CLR TR1	
;--------------------------------------------------------------------DISPLAY FREQUENCY 2
	LCALL LCD_SET_UP
	MOV DPTR, #MSG_8 
	LCALL STR_DISP
	
	MOV A, #0C0H	
	LCALL COMMAND
	LCALL DELAY
	
	CLR A				;Clear
	MOV R1,A 
	MOV R0,A 
	MOV R2,A
	MOV R3,A
	MOV R5,A
	MOV R3, TH1	
	MOV R2, TL1	
	
	PUSH 03         		; Push TH1
	PUSH 02				; Push TL1
	LCALL PRINT_DIGIT_16

	MOV DPTR, #HZ
	LCALL STR_DISP

	CLR P2.3 ;clear LED's
	CLR P2.4
	CLR P2.5
;--------------------------------------------------------------------------------Compare 2 input frequencies
	CLR C
	POP 00	 			; pop TL1
	POP 01   			; pop TH1
	POP 02   			; Pop TL0
	POP 03   			; pop TH0
	MOV A, R1  			; freq 2
	MOV B, R3  			; freq 1
	CJNE A,B , STG1  
	MOV A,R0   			; since TH0 = TH1
	MOV B,R2
	CJNE A,B,  STG2
	SETB P2.4  			; F2 = F1
	LJMP STG0
STG1:   JC p23
	SETB P2.5  			; freq1 < freq2
	LJMP STG0		
p23: 	SETB P2.3  			; freq1 > freq2
	LJMP STG0
STG2:	JC p23
	SETB P2.5			; freq1 < freq2
	LJMP STG0
STG0:
;-----------------------------------------------------------------------Sum of 2 input signals' frequencies
	MOV A, R0
	ADD A, R2 
	MOV R0, A 			; R0=R0+R2 (TL0 of 2 freqs)
	MOV A, R1
	ADDC A, R3
	MOV R1,A  			; R1=R1+R3 (TH0 of 2 freqs)
	
	PUSH 00
	PUSH 01
	LCALL LCD_SET_UP
	MOV DPTR, #MSG_9 
	LCALL STR_DISP
	
	MOV A, #0C0H	
	LCALL COMMAND
	LCALL DELAY
	
	POP 03 ;H
	POP 02 
	PUSH 02
	PUSH 03
	LCALL PRINT_DIGIT_16

	MOV DPTR, #HZ
	LCALL STR_DISP
	POP 01
	POP 00
;-----------------------------------------------------------------------Find the time period of the summed frequency
	MOV R2, #00111010B 		;LSB dividend
	MOV R3, #00010000B
	MOV R4, #00001110B 		;MSB dividend 921658 
	MOV R5, #0B 
	MOV R6, #0B 			;LSB loop counter== quotient
	MOV R7,	#0B 			;MSB loop counter==quotient
	LCALL DIV_24bit 		;Final output to be stored in LWO (R6 also) and HIH (R7 also)
;----------------------------------------------------------------------Make the output half (for each half cycle)
	CLR C
	MOV R2, LWO
	MOV R3, HIH
	MOV R4, #0d
	MOV R5, #0d
	MOV R6, #0d
	MOV R7, #0d
	MOV R0, #2d
	MOV R1, #0d
	LCALL DIV_24bit
	;INC R6
	;MOV LWO, R6
	;MOV HIH, R7
	
	
	
;----------------------------------------------------------------------Start Timer2
	CLR C
	CLR TR0
	MOV T2CON , #00000000B
	MOV T2MOD , #00000000B
	MOV A, #0FFH
	SUBB A, LWO
	MOV LWO,A
	MOV RCAP2L, LWO 		;Timer initial value = FF- quotient
	CLR C
	
	MOV A,#0FFH
	SUBB A, HIH
	MOV HIH, A
	MOV RCAP2H, HIH
	CLR C
	
	MOV IE, #10100000B
	SETB TR2
;---------------------------------------------------------------------------HALT
HLT:	JNB P3.3 ,HLTT ; halt input if grounded
LJMP LAST    		
HLTT:   JB P2.7 ,HLT  ; halt generation if grounded
	CLR TR2
LJMP HLT	  				
;---------------------------------------------------------------------------RESET
LAST:	MOV TL1,#00H
	MOV TH1,#00H
	MOV TL0,#00H
	MOV TH0,#00H
	CLR TR1
	CLR TR0

	LJMP AT_START 			; RETURN TO THE Beginning
;---------------------------------------------------------------------------SUBROUTINES
;---------------------------------------------------------------------------PRINT_DIGIT_16 Sub-Routine
PRINT_DIGIT_16:
	;Clearing memory space
	MOV FD1, #0H	;MSD
	MOV FD2, #0H
	MOV FD3, #0H
	MOV FD4, #0H
	MOV FD5, #0H  	;LSD
	; Taking out each digit
	;1
	;DIVISOR = 10
	MOV R1, #00H
	MOV R0, #0AH
	MOV R4,#0d
	LCALL DIV_24BIT
	MOV FD5, 63H	; LOW BYTE OF REMAINDER -- LSD 63H
	;2
	MOV R3,07H	; QOUTIENT HIGH TO DIVIDEND
	MOV R2,06H	; QOUTIENT LOW  TO DIVIDEND
	;DIVISOR = 10
	MOV R1, #00H
	MOV R0, #0AH
	MOV R4,#0d
	LCALL DIV_24BIT
	MOV FD4, 63H	; LOW BYTE OF REMAINDER
	;3
	MOV R3,07H	; QOUTIENT HIGH TO DIVIDEND
	MOV R2,06H	; QOUTIENT LOW  TO DIVIDEND
	;DIVISOR = 10
	MOV R1, #00H
	MOV R0, #0AH
	MOV R4,#0d
	LCALL DIV_24BIT
	MOV FD3, 63H	; LOW BYTE OF REMAINDER
	;4
	MOV R3,07H	; QOUTIENT HIGH TO DIVIDEND
	MOV R2,06H	; QOUTIENT LOW  TO DIVIDEND
	;DIVISOR = 10
	MOV R1, #00H
	MOV R0, #0AH
	MOV R4,#0d
	MOV R5,#0d
	LCALL DIV_24BIT
	MOV FD2, 63H	; LOW BYTE OF REMAINDER
	;5
	MOV FD1, 06H	; LOW BYTE OF QUOTIENT -- MSD
	; printing
	;ASCII
	CLR A
	MOV A, FD1
	ORL A, #30H
	LCALL DISPLAY
	;ASCII
	CLR A
	MOV A, FD2
	ORL A, #30H
	LCALL DISPLAY
	;ASCII
	CLR A
	MOV A, FD3
	ORL A, #30H
	LCALL DISPLAY
	;ASCII
	CLR A
	MOV A, FD4
	ORL A, #30H
	LCALL DISPLAY
	;ASCII
	CLR A
	MOV A, FD5
	ORL A, #30H
	LCALL DISPLAY
	RET
;-------------------------------------------------------------------------PRINT_DIGIT Sub-Routine
PRINT_DIGIT: 
	MOV FD1, #0H	;MSD
	MOV FD2, #0H
	MOV FD3, #0H  	;LSD
	MOV FD4, #0H
	MOV FD5, #0H
	
	MOV B,#10
	DIV AB
	MOV FD3, B	; LSD
	MOV B,#10
	DIV AB
	MOV FD2, B
	MOV FD1, A	; MSD
	
	MOV A, FD1
	ORL A, #30H
	LCALL DISPLAY

	MOV A, FD2
	ORL A, #30H
	LCALL DISPLAY

	MOV A, FD3
	ORL A, #30H
	LCALL DISPLAY
	RET
;-------------------------------------------------------------------------STR_DISP Sub-Routine	
STR_DISP:	
 	CLR A
	MOVC A,@A+DPTR
	JZ FINISH_1
	LCALL DISPLAY
	LCALL DELAY
	INC DPTR
	LJMP STR_DISP
FINISH_1: RET
;-------------------------------------------------------------------------LCD SETUP Sub-Routine
LCD_SET_UP: 

	; DISPLAY COMMANDS
	MOV 	A, #38H 
	LCALL 	COMMAND 
	LCALL 	DELAY 	
	MOV 	A, #0EH ;display on, cursor on
	LCALL 	COMMAND 
	LCALL 	DELAY 	
	MOV 	A, #01 	;clear LCD
	LCALL 	COMMAND 
	LCALL 	DELAY 	
	MOV 	A, #06H ;shift cursor right
	LCALL 	COMMAND 
	LCALL 	DELAY 	
	MOV 	A, #80H ;cursor at line 1 postion 1
	LCALL 	COMMAND 
	LCALL 	DELAY 	
	RET

COMMAND:LCALL READY
	MOV P1, A
	CLR RS
	CLR RW
	SETB ENBL
	LCALL DELAY
	CLR ENBL
	RET
		
DISPLAY: LCALL READY
	MOV P1, A
	SETB RS
	CLR RW
	SETB ENBL
	LCALL DELAY
	CLR ENBL
	RET
	
READY: 	SETB P1.7
	CLR RS
 	SETB RW
WAIT: 	CLR ENBL
	LCALL DELAY
 	SETB ENBL
	JB P1.7, WAIT
	RET
	
;-------------------------------------------------------------------------DELAY Sub-Routine (Large)	
DELAY: 	MOV R3, #50
AGAIN_2:MOV R4, #255
AGAIN: 	DJNZ R4, AGAIN
	DJNZ R3, AGAIN_2
	RET
;-------------------------------------------------------------------------DELAY2 Sub-Routine (Small)
DELAY_2:MOV R5, #100
AGAIN_3:LCALL DELAY
	DJNZ R5, AGAIN_3
	RET
;-------------------------------------------------------------------------ADD_24bit Sub-Routine
ADD_24bit:
    MOV A,R7     
    ADD A,R5     
    MOV R3,A     
    
    MOV A,R6     
    ADDC A,R4    
    MOV R2,A     

    MOV A,CAR_TON   
    ADDC A,CAR_TOFF  
    MOV  R1,A 		;OUTPUT in R1(MSB) , R2, and R3.
    RET
;--------------------------------------------------------------------------DIV_24bit Sub-Routine    
DIV_24bit:
	;R0= LSB divisor
	;R1 =2nd MSB divisor
	;R5 =MSB divisor
	;R2 =LSB dividend
	;R3 =2nd MSB dividend
	;R4 =MSB dividend 921658  
	
	;R6 =LSB quotient = LWO
	;R7 =MSB quotient = HIH
	
	;REM =Remainder lower byte
	
	CLR A    ;clear
	CLR C
	MOV R6,A 
	MOV R7,A
	MOV REM,A

LOOP_SUB:
	
	CLR C             ;updates
	MOV A,R2	
	MOV B,#10d
	CJNE A,B,LSST
LSST:	JNC LSSST
	MOV A,R2
	MOV REM,A 
LSSST:
	
	CLR C
	MOV A,R2
	SUBB A,R0	;R2=R2-R0-C
	MOV R2, A
	
	MOV A,R3
	SUBB A,R1	;R3=R3-R1-C
	MOV R3,A
		
	MOV A,R4
	SUBB A,R5	;R4=R4-0-C
	MOV R4,A


	MOV B,#0FEH     ;carry overflow to msb of dividend ends program
	CJNE A,B,LL
	LJMP EXITT

LL:
	JNC EXITT
	INC R6
	MOV A,R6
	MOV B,#0B
	CJNE A,B,FNNN   ;if R6 resets itself , r7 increases
	INC R7

	

FNNN:
	CLR C
	LJMP LOOP_SUB
EXITT:
	MOV LWO, R6
	MOV HIH, R7
RET

MUL16_bit: 
; First number in R6(H) and R7 
; Second number in R4(H) and R5. 
; Result oin R0(MSB), R1, R2 and R3(LSB).


 ;Multiply R5 by R7
 MOV A,R5 
 MOV B,R7 
 MUL AB   
 MOV R2,B 
 MOV R3,A 

 ;Multiply R5 by R6
 MOV A,R5    
 MOV B,R6    
 MUL AB      
 ADD A,R2    
 MOV R2,A    
 MOV A,B     
 ADDC A,#00h 
 MOV R1,A    
 MOV A,#00h  
 ADDC A,#00h 
 MOV R0,A    

 ;Multiply R4 by R7
 MOV A,R4  
 MOV B,R7   
 MUL AB     
 ADD A,R2   
 MOV R2,A   
 MOV A,B    
 ADDC A,R1  
 MOV R1,A   
 MOV A,#00h 
 ADDC A,R0  
 MOV R0,A   

 ;Multiply R4 by R6
 MOV A,R4  
 MOV B,R6  
 MUL AB    
 ADD A,R1  
 MOV R1,A  
 MOV A,B   
 ADDC A,R0 
 MOV R0,A  

 ;Return - answer is now in R0, R1, R2, and R3
 RET

;-------------------------------------------------------------------------------------Messages		
MSG_1: 	DB "     GROUP-2    ",0 ; Messages that were shown 
MSG_2: 	DB "312,10,18,36,44",0
MSG_3: 	DB "FREQ-1:",0
HZ: 	DB "HZ",0
MSG_4:	DB "DIFF:",0
MSG_7:	DB "DC:",0
MSG_8: 	DB "FREQ-2:",0
MSG_9:  DB "NEW FREQ:",0
	END	