;***********************************************************************************************
;       Program for Sending SMS through GSM network using
;       SIM900D and AT89C51
;***********************************************************************************************
;		Author : Malik Umair Latif
;		Company: ElektroSoft Solutions
;		Website: www.essol.com.pk
;		Date   : 15 July 2013
;***********************************************************************************************
;       Upon wake-up goto MAIN, avoid using memory space, allocated
;       to interrupt vector table
;***********************************************************************************************
            ORG 0H
             LJMP MAIN

  ;**********************************************************************************************
  ;       ISR for External Interrupt 0 to send Message for
  ;       particular activated input
  ;**********************************************************************************************
             ORG 03H
             LJMP CHECK
;***********************************************************************************************
;         ISR FOR TIMER 0 INTERRUPT
;***********************************************************************************************
            ORG 000BH  ; TIMER 0 INTERRUPT

                                                         ;This is your ISR where you will count
                                                        ;60 interrupts and set timer flag
         INC R6 ;increment counter
         CJNE R6, #60H,OUT  ;3 seconds
         CALL TIMEDOUT
OUT:
         
         MOV TH0,#03cH ;Reload timer again for 50ms
         MOV TL0,#0b0H
         
         RETI
 TIMEDOUT:
         ; Timeout occured
         CLR TR0 ;stop timer now
        SETB TIMEOUT_FLAG
         RET
;***********************************************************************************************
;         The MAIN program for initilization
;***********************************************************************************************
      ;       ORG 80H
      ; to define TIMEOUT_FLAG you can use
         ; bit addressable area
         TIMEOUT_FLAG equ 0H ;0H means Address:20H[bit0]
         MSG EQU 50H
         CONTACT EQU 30H

 MAIN:       MOV P1,#00H
             MOV P2,#00H
             ACALL DELAY1
            
             SETB P1.0
  START:     MOV IE, #83H  
             ACALL SERIAL
             ACALL DELAY1

             LCALL CMGF
             ACALL DELAY4
             
             LCALL CSMS   ; SET t PHASE 1
             ACALL DELAY4

             LCALL CNMI_READ
             ACALL DELAY4

             LCALL CPMS   ; SET THE READ & WRITE STORAGE TO SIM
             ACALL DELAY4
             
             LCALL CMGL   ; LIST SMS FROM LOCATION (CURRENTLY SET TO "ALL")
             ACALL DELAY4
             

 READ_AGAIN:              
            LCALL INIT_TIMEOUT
            LCALL CMGR   ; READ THE STORED MESSAGE
            
;**********************************************************************************************
 WaitForStar:
         JB RI, CHECK_BYTE
         JB TIMEOUT_FLAG, READ_AGAIN ;TIMEOUT_FLAG is a bit variable that is set
                                     ; In ISR of timer that your initialized earlier
         SJMP WaitForStar            ;if no timeout is not received
                                     ;go back and check data received
 CHECK_BYTE:
         MOV A, SBUF
         CLR RI
         CJNE A,#'#', NEXT
         SJMP NUMBER
 NEXT:   CJNE A, #'*', WaitForStar

 WaitForCode:
            MOV R7,#15               ;read upto 15 characters
            MOV R0,#MSG              ;LOAD POINTER
 READMSG:
         LCALL READBYTE
         CJNE A, #'#', STOREMSG
         SJMP MSGREADDONE

STOREMSG:
        MOV @R0, A
        INC R0 ;next location
        DJNZ R7, READMSG

MSGREADDONE:
        MOV R0,#MSG
        ;INC R0
        MOV A,@R0
        CJNE A,#'0',START    ;either you received # or
        INC R0
        MOV A,@R0
        CJNE A,#'1',GONEXT   ;15 character read, discard everything else
        SETB P2.1            ;process your msg here
        CALL DELAY1
        CALL DELAY1
        CALL DELAY1
        CALL DELAY1
        CLR P2.1
        LCALL CMGD
        LJMP START
GONEXT:
        CJNE A,#'2',START
        SETB P2.2
        CALL DELAY1
        CALL DELAY1
        CALL DELAY1
        CALL DELAY1
        CLR P2.2
        LCALL CMGD
        LCALL DELAY4
        LJMP START

        ;Read Byte routine
READBYTE:
        JNB RI, READBYTE
        MOV A, SBUF
        CLR RI
        RET
;***********************************************************************************************
;       STORING NEW NUMBER
;***********************************************************************************************
NUMBER:
        MOV R7, #15          ;read only upto 15 bytes
        MOV R1, #CONTACT     ;load pointer
READMSG1:
        LCALL READBYTE1
        CJNE A, #'*', STOREMSG1
        SJMP MSGREADDONE1

STOREMSG1:
        MOV @R1, A
        INC R1 ;next location
        DJNZ R7, READMSG1

MSGREADDONE1:
        SETB P2.1
        CALL DELAY1
        CLR P2.1
        CALL DELAY1
        SETB P2.1
        CALL DELAY1
        CLR P2.1
        CALL DELAY1
        SETB P2.1
        CALL DELAY1
        CLR P2.1

        LCALL CMGD
        LCALL DELAY4

        LJMP START           ;either you received # or
                             ;15 character read, discard everything else
                             ;process your msg here


READBYTE1:                   ;Read Byte routine
        JNB RI, READBYTE1
        MOV A, SBUF
        CLR RI
        RET
;***********************************************************************************************
   ;DELETE:   LCALL CMGD    ; DELETE THE SMS STORED IN SIM
    ;         LCALL DELAY1
    ;         LCALL DELAY1
    ;         LCALL DELAY1
    ;         LCALL DELAY1
    ;         LJMP START
  ;**********************************************************************************************
  ; ERROR:    SETB P2.2
  ;           LCALL DELAY1
  ;           LCALL DELAY1
  ;           LCALL DELAY1
  ;           LCALL DELAY1
  ;           CLR P2.2
  ;           LJMP START
;***********************************************************************************************
;   Sending ISR
;***********************************************************************************************
             ORG 200H
 CHECK:     JNB P1.0, CHECK
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
             RETI
;***********************************************************************************************
;   Subroutine for Sending one byte out of serial port
;***********************************************************************************************
   TRAIN:    MOV SBUF,A
   HERE:     JNB TI,HERE
             CLR TI
             RET
;***********************************************************************************************
;   Subroutine for initializing the serial port with 9600BPS
;***********************************************************************************************
     SERIAL: MOV TMOD,#20H
             MOV TH1,#0FDH
             MOV SCON,#50H
             SETB TR1
             RET
  ;**********************************************************************************************
  ;  Subroutine for CSMS
  ;**********************************************************************************************
    CSMS:   MOV DPTR,#TABLE6
            MOV R7,#10
    LOOP6:  MOV A,#0
            MOVC A,@A+DPTR
            INC DPTR
            LCALL TRAIN
            DJNZ R7,LOOP6
            RET
  ;**********************************************************************************************
  ;  Subroutine for CPMS
  ;**********************************************************************************************
    CPMS:   MOV DPTR,#TABLE8
            MOV R7,#13
    LOOOOP: MOV A,#0
            MOVC A,@A+DPTR
            INC DPTR
            LCALL TRAIN
            DJNZ R7,LOOOOP
            RET
  ;**********************************************************************************************
  ;  Subroutine for CMGL
  ;**********************************************************************************************
    CMGL:   MOV DPTR,#TABLE7
            MOV R7,#14
    LOOP7: MOV A,#0
            MOVC A,@A+DPTR
            INC DPTR
            LCALL TRAIN
            DJNZ R7,LOOP7
            RET
;***********************************************************************************************
; Subroutine for CMGR
;***********************************************************************************************
     CMGR:   MOV DPTR,#TABLE9
             MOV R7,#10
     BACK:  MOV A,#0
             MOVC A,@A+DPTR
             INC DPTR
             ACALL TRAIN
             DJNZ R7,BACK
             RET
;***********************************************************************************************
;   Subroutine for CMGD
;***********************************************************************************************
    CMGD:   MOV DPTR,#TABLE10
            MOV R7,#10
    BACK1:  MOV A,#0
            MOVC A,@A+DPTR
            INC DPTR
            ACALL TRAIN
            DJNZ R7,BACK1
            RET
;***********************************************************************************************
;   Subroutine for CNMI_READ
;***********************************************************************************************
  CNMI_READ: MOV DPTR,#TABLE11
             MOV R7,#18
     BACK2:  MOV A,#0
             MOVC A,@A+DPTR
             INC DPTR
             ACALL TRAIN
             DJNZ R7,BACK2
             RET
;***********************************************************************************************
;   Subroutine for CMGF
;***********************************************************************************************
     CMGF:   MOV DPTR,#TABLE1
             MOV R7,#10
     LOOP1:  MOV A,#0
             MOVC A,@A+DPTR
             INC DPTR
             ACALL TRAIN
         ;   ACALL DELAY
             DJNZ R7,LOOP1
             RET
;***********************************************************************************************
;   Subroutine for CNMI
;***********************************************************************************************
     CNMI:   MOV DPTR,#TABLE2
             MOV R7,#18
     LOOP2:  MOV A,#0
             MOVC A,@A+DPTR
             INC DPTR
             ACALL TRAIN
         ;   ACALL DELAY
             DJNZ R7,LOOP2
             RET
;***********************************************************************************************
;   Subroutine for CMGS
;***********************************************************************************************
     CMGS:   MOV DPTR,#TABLE3
             MOV R7,#9
     LOOP3:  MOV A,#0
             MOVC A,@A+DPTR
             INC DPTR
             ACALL TRAIN
         ;   ACALL DELAY
             DJNZ R7,LOOP3
             CALL CHANGE
             RET
;***********************************************************************************************
;   Subroutine to Send message to number/add a new number (destructive override)
;***********************************************************************************************
     CHANGE: MOV R1,#CONTACT
             MOV R7,#13
      FEED:  ;INC R1
             MOV A,@R1
             ACALL TRAIN
             INC R1
             DJNZ R7, FEED
             ;INC R1
             MOV A,#'"'
             ACALL TRAIN
             MOV A,#'''
             ACALL TRAIN
             ;MOV A,#','
             ;ACALL TRAIN
             MOV A,#0DH
             ACALL TRAIN
             RET

;***********************************************************************************************
;   Subroutine for SALAM
;***********************************************************************************************
     SALAM:  MOV DPTR,#TABLE4
             MOV R7,#18
     LOOP4:  MOV A,#0
             MOVC A,@A+DPTR
             INC DPTR
             ACALL TRAIN
         ;   ACALL DELAY
             DJNZ R7,LOOP4
             RET
;***********************************************************************************************
;   Subroutine for THIEF
;***********************************************************************************************
     THIEF:  MOV DPTR,#TABLE5
             MOV R7,#31
     LOOP5:  MOV A,#0
             MOVC A,@A+DPTR
             INC DPTR
             ACALL TRAIN
         ;   ACALL DELAY
             DJNZ R7,LOOP5
             RET
;***********************************************************************************************
;   Subroutine for delay
;***********************************************************************************************
   DELAY:    MOV R0,#50
   RELOAD:   MOV R1,#50
   WAIT:     DJNZ R1,WAIT
             DJNZ R0,RELOAD
             RET
;***********************************************************************************************
;   Subroutine for LARGE delay
;***********************************************************************************************
   DELAY1:   MOV R0,#255
   RELOAD1:  MOV R1,#255
   WAIT1:    DJNZ R1,WAIT1
             DJNZ R0,RELOAD1
             RET
;***********************************************************************************************
;   Subroutine for INIT_TIMEOUT
;***********************************************************************************************
 INIT_TIMEOUT:
         CLR TR0 ;make sure timer is stopped
         CLR TIMEOUT_FLAG
         MOV R6, #0 ;assuming r6 is used for counting interrupts
         ;INIT timer for 50ms approx. time period

      ;   MOV TMOD,#00000001B  ; TIMER 0, MODE 1
         MOV TMOD,#21H  ;set timer 0 and 1 at same time
         MOV TL0,#0b0H
         MOV TH0,#0c3H
         
         SETB TR0 ;start timer
         RET

DELAY4:

         LCALL DELAY1
         LCALL DELAY1
         LCALL DELAY1
         LCALL DELAY1
         LCALL DELAY1
         LCALL DELAY1
         LCALL DELAY1
         LCALL DELAY1
         LCALL DELAY1
         LCALL DELAY1
         
         RET
         
;***********************************************************************************************
;   Lookup Tables
;***********************************************************************************************
   ORG 400H
   TABLE1:   DB "AT+CMGF=1",0Dh
   TABLE2:   DB "AT+CNMI=2,2,0,0,0",0Dh
   TABLE3:   DB 'AT+CMGS="'
   TABLE4:   DB "ASSALAM-O-ALAIKUM",0Dh
   TABLE5:   DB "GSM is working",1Ah
   TABLE6:   DB "AT+CSMS=0",0Dh
   TABLE7:   DB 'AT+CMGL="ALL"',0Dh
   TABLE8:   DB 'AT+CPMS="SM"',0Dh
   TABLE9:   DB "AT+CMGR=1",0Dh
   TABLE10:  DB "AT+CMGD=1",0Dh
   TABLE11:  DB "AT+CNMI=2,2,0,0,0",0Dh

             END
