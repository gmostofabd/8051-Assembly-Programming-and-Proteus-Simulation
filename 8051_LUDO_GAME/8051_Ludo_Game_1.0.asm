;====================================================
; 8051 LUDO KING GAME - ULTRA STABLE V5 (MIDE READY)
;====================================================

; ================= BIT FLAGS =================
FLAG0_DICE  BIT 20H.0   ; dice = 6
FLAG1  BIT 20H.1   ; valid move
FLAG2  BIT 20H.2   ; timer flag
FLAG3  BIT 20H.3   ; validity global
FLAG4  BIT 20H.4   ; reset flag

; ================= PINS =================
RS      BIT P2.4
EN      BIT P2.5
DAT     BIT P2.0
CLK_R   BIT P2.1
CLK_G   BIT P2.2
STR     BIT P2.3


; ================= MEMORY MAP =================
; 5C–7F : board
; 31–34 : red tokens
; 35–38 : green tokens
; 39    : dice
; 3A    : next pos
; 3B    : temp
; 3C    : RNG seed


ORG 0000H
   SJMP START

ORG 001BH
TIMER_ISR:
    DJNZ R2, TMR_EXIT
    SETB FLAG2
TMR_EXIT:
    RETI


; ================= MAIN =================
;ORG 0100H
START:

;MOV DPTR,#WELCOME_TXT
;ACALL PRNT_STRNG

; ---- LCD INIT ----
    ACALL DELAY

    MOV A,#033H
    ACALL LCD_CMD
    ACALL DELAY

    MOV A,#032H
    ACALL LCD_CMD
    ACALL DELAY

    MOV A,#028H
    ACALL LCD_CMD

    MOV A,#00CH
    ACALL LCD_CMD

    MOV A,#06H
    ACALL LCD_CMD

    MOV A,#01H
    ACALL LCD_CMD
    ACALL DELAY


; ---- WELCOME ----
MOV DPTR,#WELCOME_TXT
ACALL PRNT_STRNG
    MOV A,#001H
    ACALL LCD_CMD




MOV A,#0D0H
ACALL LCD_CMD

MOV A,#04CH
ACALL LCD_DATA
MOV A,#055H
ACALL LCD_DATA
MOV A,#044H
ACALL LCD_DATA
MOV A,#04FH
ACALL LCD_DATA

; ---- TIMER ----
MOV TMOD,#12H
MOV TH0,#0FAH
MOV TL0,#0FAH
SETB TR0
SETB EA
SETB ET1

; INIT RNG
MOV 3CH,#55H

; ================= RESET GAME =================
RESET_GAME:
           MOV P0, #00FH; INIT THE MATRIX KEYBOARD

;INIT ALL THE GAME REGISTERS HERE
;FIRST CLEAR ALL THE REGISTERS FROM 0x5C TO 0x7F. IMP TO DO THIS AFTER THE GAME IS RESET
	MOV R0, 5CH
REPEAT_PATH_CLR:
	MOV @R0, #00
	INC R0
	CJNE R0, #080H, REPEAT_PATH_CLR


;RESET ALL THE TOKEN REGISTER TO HOME LOCATION (HOME ADDRESS IS 0x00)
	MOV R0, 31H
REPEAT_TOKEN_CLR:
	MOV @R0, #0
	INC R0
	CJNE R0, #39H, REPEAT_TOKEN_CLR
;CLEAR COMPLETE



; GAME STARTS HERE
	
	;-------------- PLAYER ---------------
	REPEAT_DIE_PLAYER:
	LCALL PLAYER_LCD
	LCALL PLAYER_DIE;
	
	;CHECK IF RESET CLICKED
	JNB FLAG4, NOT_RESET
	;RESET CLICKED. GO TO RESET ROUTINE
	;LJMP FORCE_RESET



NOT_RESET:
	;IF 0x39 HAS 6, THEN SET 0x20.0. IN TOKEN SELECT, IF TOKEN IN HOME IT CAN BE ADDED TO THE GAME
	MOV A, 39H
	CJNE A, #006H, NOT_PREV_PLAYER
	SETB    FLAG0_DICE; 6 WAS SCORED


NOT_PREV_PLAYER:
	;HERE WE ALSO NEED TO CHECK IF THE PLAYER HAS ANY VALID MOVES.
	;IF 6 WAS SCORED THEN SKIP THIS CHECK.
	;VALIDITY CHECK IF AS FOLLOWS:
	;	FIRST CHECK IF ANY TOKEN IS IN THE GAME, IF NOT THEN INVALID
	;	CHECK IF THE TOKENS ARE MOVED DIE VALUE POSITIONS, IS IT WITHIN THE VIRTUAL PATH BOUND (7F)
	;---------------- VALIDITY STARTS HERE --------------------
	MOV R0, 30H
	MOV R6, #01; PLAYER TOKEN MASK






MAIN_LOOP:

; ================= PLAYER TURN =================
PLAYER_TURN:
        ACALL PLAYER_LCD
        ACALL RNG_DICE

        MOV A,39H
        MOV R7,#06H



        MOV A, R7
        CJNE A, #00H, NO_SIX

        SETB FLAG0_DICE
NO_SIX:

       ACALL TOKEN_SELECT
       ACALL MOVE_ENGINE
       ACALL UPDATE_RED_RGB
       ACALL UPDATE_GREEN_RGB

       ACALL CHECK_WIN
       JNB FLAG0_DICE, COMP_TURN
       CLR FLAG0_DICE
       SJMP PLAYER_TURN


; ================= COMPUTER TURN =================
COMP_TURN:
       ACALL COMPUTER_LCD
       ACALL RNG_DICE

       MOV A,39H
       MOV R7,#06H

       MOV A, R7
       CJNE A, #00H, NO_SIX_C

       SETB FLAG0_DICE
NO_SIX_C:

       ACALL AI_SELECT
       ACALL MOVE_ENGINE
       ACALL UPDATE_RED_RGB
       ACALL UPDATE_GREEN_RGB

       ACALL CHECK_WIN
       JNB FLAG0_DICE, MAIN_LOOP
       CLR FLAG0_DICE
       SJMP COMP_TURN





















; ================= MOVE ENGINE =================
MOVE_ENGINE:

            MOV A,@R0
            JZ FROM_HOME

; ---- normal move ----
  MOV A,@R0
  ADD A,39H
      MOV 3AH,A

      ACALL VALIDATE_MOVE
      JNB FLAG1, EXIT_MOVE

      MOV @R0,3AH
      RET

FROM_HOME:
          JB FLAG0_DICE, ALLOW_HOME
          RET

ALLOW_HOME:
           MOV @R0,5CH
           RET

EXIT_MOVE:
          RET






; ================= VALIDATION =================
VALIDATE_MOVE:
CLR C
MOV A,3AH
SUBB A,#80H

JC OK
CLR FLAG1
RET

OK:
SETB FLAG1
RET


; ================= RNG DICE =================
RNG_DICE:
MOV A,3CH
RL A
XRL A,3AH
MOV 3CH,A

ANL A,#07H
JZ RNG_DICE

MOV 39H,A
RET


; ================= LCD =================
LCD_CMD:
MOV P1,A
CLR RS
ACALL LCD_PULSE

SWAP A
MOV P1,A
CLR RS
ACALL LCD_PULSE
RET


LCD_DATA:
MOV P1,A
SETB RS
ACALL LCD_PULSE

SWAP A
MOV P1,A
SETB RS
ACALL LCD_PULSE
RET


LCD_PULSE:
SETB EN
NOP
CLR EN
ACALL LCD_DELAY
RET


LCD_DELAY:
MOV R6,#255
D1: DJNZ R6,D1
RET


; ================= PLAYER LCD =================
PLAYER_LCD:
MOV A,#0C0H
ACALL LCD_CMD
MOV A,#050H
ACALL LCD_DATA
MOV A,#04CH
ACALL LCD_DATA
MOV A,#041H
ACALL LCD_DATA
MOV A,#059H
ACALL LCD_DATA
MOV A,#045H
ACALL LCD_DATA
MOV A,#052H
ACALL LCD_DATA
RET


; ================= COMPUTER LCD =================
COMPUTER_LCD:
MOV A,#0C0H
ACALL LCD_CMD
MOV A,#43H
ACALL LCD_DATA
MOV A,#4FH
ACALL LCD_DATA
MOV A,#4DH
ACALL LCD_DATA
MOV A,#50H
ACALL LCD_DATA
MOV A,#55H
ACALL LCD_DATA
MOV A,#54H
ACALL LCD_DATA
RET


; ================= TOKEN SELECT (PLAYER) =================
TOKEN_SELECT:
MOV P0,#0FH

WAIT_KEY:
         JB P0.1,CHK2
         MOV R0,31H
         SJMP DONE

CHK2:
     JB       P0.2,WAIT_KEY
     MOV      R0,32H

DONE:
     RET


; ================= SIMPLE AI =================
AI_SELECT:
MOV R0,35H
RET


; ================= WIN CHECK =================
CHECK_WIN:
MOV R0,7BH
MOV A,#00H

W1:
INC R0

MOV A, @R0
MOV R7, A

MOV A, R7
ANL A, #01H
MOV R7, A
ADD A,R7
CJNE R0,#7FH,W1
RET


; ================= RGB UPDATE (SIMPLIFIED) =================
UPDATE_RED_RGB:
CLR STR
RET

UPDATE_GREEN_RGB:
CLR STR
RET



;====================================================================
;====================================================================
PRNT_STRNG:	
	CLR	A
	MOVC	A, @A+DPTR
	JZ	END_STRNG
	ACALL 	LCD_DATA			;call display subroutine
	INC	DPTR
	LJMP	PRNT_STRNG
END_STRNG:
	RET
;====================================================================
 
;==================== DELAYS ===========================================
DELAY:
    MOV R3, #50
DLY2:
    MOV R4, #255
DLY1:
    DJNZ R4, DLY1
    DJNZ R3, DLY2
RET

DELAY_1:
    MOV R5, #45
DLY3N:
    ACALL DELAY
    DJNZ R5, DLY3N
RET


    
PLAYER_DIE:
	;HERE THE PLAYER'S DIE VALUE IS RETURNED. 0x20.4 IS SET IF RESET BUTTON IS CLICKED
	CLR FLAG4; CLEAR RESET INDICATOR
	;0x39 CONTAINS DIE VALUE. A HAS ASCII VALUE OF DIE
	;POLL P0.3
WAIT_FOR_PLAYER_ROLL: 
	ACALL         QUICK_DIE
	JNB P0.0, RESET_CLICKED
	JB P0.3, WAIT_FOR_PLAYER_ROLL
	
	;BUTTON CLICKED. SHOW DIE VALIE
	MOV A, #085H;CURSOR LOCATION
	ACALL LCD_CMD
	MOV A, TL0; DIE
	CLR C
	SUBB A, #0F9H
	MOV 39H, A; BACKUP A DIE VALUE
	ADD A, 30H
	
	;WAIT FOR PLAYER TO RELEASE THE ROLL BUTTON
WAIT_FOR_PLAYER_RELEASE:
	JNB P0.3, WAIT_FOR_PLAYER_RELEASE
	
;;	;--------TEST--------
;	;ALWAYS GIVE 6 DIE VALUE AFTER ROLL
;	MOV A, 31
;	MOV 0x39, #0x01
;;	
	ACALL LCD_DATA
	RET
	
	
RESET_CLICKED:
	SETB FLAG4; RESET OCCURRED
	RET


QUICK_DIE:
	;SHOW DIE ROLL ON LCD
	MOV A, #085H;CURSOR LOCATION
	ACALL LCD_CMD
	MOV A, TL0; DIE
	ACALL LCD_DATA
	RET





WELCOME_TXT:
	DB "WELCOME TO LUDO",00H

PLAYER_TXT:
	DB "PLAYER TURN",00H

COMP_TXT:
	DB "COMPUTER THINK",00H

WIN_TXT:
	DB "YOU WIN!",00H

SEL_TXT:
DB "SELECT TOKEN",00H









END