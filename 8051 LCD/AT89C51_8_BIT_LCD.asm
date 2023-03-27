;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORG	00H

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PORT_INIT:
MOV P2, #00H
MOV P3, #00H

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
REG_INIT:
MOV R0, #00H
MOV R1, #00H
MOV R2, #00H


IO_DECLERATION:
RS EQU P2.1 ; RS ON LCD
EN EQU P2.2 ; EN ON LCD


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_INIT:
MOV R0, #38H
ACALL COMMAND	;call command subroutine
MOV R0, #0EH
ACALL COMMAND
MOV R0, #80H
ACALL COMMAND
MOV R0, #01H
ACALL COMMAND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
L1:
MOV R0, #'H'
ACALL DISPLAY	;call display subroutine
MOV R0, #'E'
ACALL DISPLAY
MOV R0, #'L'
ACALL DISPLAY
MOV R0, #'L'
ACALL DISPLAY
MOV R0, #'O'
ACALL DISPLAY
MOV R0, #' '
ACALL DISPLAY
MOV R0, #'W'
ACALL DISPLAY
MOV R0, #'O'
ACALL DISPLAY
MOV R0, #'R'
ACALL DISPLAY
MOV R0, #'L'
ACALL DISPLAY
MOV R0, #'D'
ACALL DISPLAY
;LJMP L1
sjmp	$

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAY:
MOV P1, R0
SETB RS
SETB EN
CLR EN
ACALL DELAY
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
COMMAND:
MOV P1, R0
CLR RS
SETB EN
CLR EN
ACALL DELAY
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DELAY:	MOV	R1, #50	;APPROX 50 mS		;50 or higher for fast CPUs
HERE2:	MOV	R2, #255		;R4=255
HERE:	DJNZ	R2, HERE		;stay untill R4 becomes 0
	DJNZ 	R1, HERE2
	RET


END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

















