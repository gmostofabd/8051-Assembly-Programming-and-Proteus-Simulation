; =============================================================================================
; ================================  ETEC Aristóteles Ferreira  ================================
; ================================  Prof.: Silvio C. da Silva  ================================
; ===============  Aluno/Autor: John Kennedy Loria Segundo - N# 14 - Turma 3A3  ===============
; ===================  Semaforos.asm - ver. 1.0 - Initial Date: 22/05/2015  ===================
; =============================================================================================


; Programa para comandar 3 semaforos, 2 para veiculos automotores e 1 pedestre

; 	Semaforos para veiculos são chamados de via 0 e via 2, enquanto o de
;	de pedestre é o via 1 que não foi mencionado nos comentarios abaixo.

;	A idéia é uma rotina onde os semaforos das vias 0 e 2 ficam alternando
;	entre si, o semaforo de pedestre só se manifestará quando o botão (P3.2)
;	for precionado, então fica vermelho para ambos os sentidos e libera a
;	a passagem para pedestras, e então volta para onde parou.



				ORG	0000H	; Inicio do programa


;				---- Rotina Principal ----


		MOV	P0,	#00H				; Limpa Port0, paga tudo
		
		MOV	P0,	#29H				; Vermelho para todos (iniciando programa)
		LCALL	TEMPO				; Chama rotina de tempo 3s
ALT0:		MOV	P0,	#2CH			; Verde via 0, Vermelho via 2
		JNB	P3.2,	AUX0			; Pula para AUX0 se o botão for precionado
		LCALL	TEMPO				; Chama rotina de tempo 3s
		JNB	P3.2,	AUX1			; Pula para AUX1 se o botão for precionado
		MOV	P0,	#2AH				; Amarelo via 0, Vermelho via 2
		JNB	P3.2,	AUX2			; Pula para AUX2 se o botão for precionado
		LCALL	TEMPO				; Chama rotina de tempo 3s
		JNB	P3.2,	AUX3			; Pula para AUX3 se o botão for precionado
ALT1:		MOV	P0,	#89H			; Vermelho via 0, Verde via 2
		JNB	P3.2,	AUX4			; Pula para AUX4 se o botão for precionado
		LCALL	TEMPO				; Chama rotina de tempo 3s
		JNB	P3.2,	AUX5			; Pula para AUX5 se o botão for precionado
		MOV	P0,	#49H				; Vermelho via 0, Amarelo via 2
		JNB	P3.2,	AUX6			; Pula para AUX6 se o botão for precionado
		LCALL	TEMPO				; Chama rotina de tempo 3s
		JNB	P3.2,	AUX7			; Pula para AUX7 se o botão for precionado

		SJMP	ALT0				; Volta para ALT0 inicio da rotina principal


;			---- Auxiliares de Roteamento ----


	AUX0:	SJMP	PEDESTRE0		; Pula para PEDESTRE0
	AUX1:	SJMP	PEDESTRE1		; Pula para PEDESTRE1
	AUX2:	LJMP	PEDESTRE2		; Pula para PEDESTRE2
	AUX3:	LJMP	PEDESTRE3		; Pula para PEDESTRE3
	AUX4:	LJMP	PEDESTRE4		; Pula para PEDESTRE4
	AUX5:	LJMP	PEDESTRE5		; Pula para PEDESTRE5
	AUX6:	LJMP	PEDESTRE6		; Pula para PEDESTRE6
	AUX7:	LJMP	PEDESTRE7		; Pula para PEDESTRE7

;			---- Rotina para passagem de pedestres ---- 


PEDESTRE0:	LCALL	TEMPO			; Chama rotina de tempo 3s
		MOV	P0,	#2AH				; Amarelo via 0, vermelho via 2
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#31H				; Libera pedestres
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPO				; Chama rotina de tempo 3s
		LJMP	ALT1				; Volta para ALT1 da rotina principal

PEDESTRE1:	MOV	P0,	#2AH			; Amarelo via 0, vermelho via 2
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#31H				; Libera pedestres
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPO				; Chama rotina de tempo 3s
		LJMP	ALT1				; Volta para ALT1 da rotina principal

PEDESTRE2:	LCALL	TEMPO			; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#31H				; Libera pedestres
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPO				; Chama rotina de tempo 3s
		LJMP	ALT1				; Volta para ALT1 da rotina principal

PEDESTRE3:	MOV	P0,	#89H			; Vermelho via 0, verde via 2
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#49H				; Vermelho via 0, Amarelo via 2
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#31H				; Libera pedestres
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPO				; Chama rotina de tempo 3s
		LJMP	ALT0				; Volta para ALT0 da rotina principal

PEDESTRE4:	LCALL	TEMPO			; Chama rotina de tempo 3s
		MOV	P0,	#49H				; Vermelho via 0, Amarelo via 2
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#31H				; Libera pedestres
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPO				; Chama rotina de tempo 3s
		LJMP	ALT0				; Volta para ALT0 da rotina principal

PEDESTRE5:	MOV	P0,	#49H			; Vermelho via 0, Amarelo via 2
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#31H				; Libera pedestres
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPO				; Chama rotina de tempo 3s
		LJMP	ALT0				; Volta para ALT0 da rotina principal

PEDESTRE6:	LCALL	TEMPO			; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#31H				; Libera pedestres
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP		
		LCALL	TEMPO				; Chama rotina de tempo 3s
		LJMP	ALT0				; Volta para ALT0 da rotina principal

PEDESTRE7:	MOV	P0,	#2CH			; Verde via 0, vermelho via 2
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#2AH				; Amarelo via 0, vermelho via 2
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#31H				; Libera pedestres
		LCALL	TEMPO				; Chama rotina de tempo 3s
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H				; Vermelho para todos
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPOP
		MOV	P0,	#21H
		LCALL	TEMPOP
		MOV	P0,	#29H
		LCALL	TEMPO				; Chama rotina de tempo 3s
		LJMP	ALT1				; Volta para ALT1 da rotina principal


; 			-----------   Rotina de tempo   -----------


		TEMPO:	MOV	R0,	#016D
		VOLTA2:	MOV	R1,	#250D		; A idéia é ficar decrementando R0, R1 e R2
		VOLTA1:	MOV	R2,	#250D		; repetidas vezes até chegar a 0 (zero)
									; 250 x 250 x 16 x 2  =  2.000.000 uS  =  2 S
			DJNZ	R2,	$			; Ao final dessa rotina terá se passado 2 segundo.
			DJNZ	R1,	VOLTA1
			DJNZ	R0,	VOLTA2
		RET


; 			--------   Rotina de tempo pisca   --------


		TEMPOP:	MOV	R0,	#004D
		VOLTA4:	MOV	R1,	#250D		; A idéia é ficar decrementando R0, R1 e R2
		VOLTA3:	MOV	R2,	#250D		; repetidas vezes até chegar a 0 (zero)
									; 250 x 250 x 4 x 2  =  500.000 uS  =  0,5 S
			DJNZ	R2,	$			; Ao final dessa rotina terá se passado 2 segundo.
			DJNZ	R1,	VOLTA3
			DJNZ	R0,	VOLTA4
		RET


; 			-------   Rotina de Debounce   -------


		DEBOUNCE:	MOV	R7,	#004D
		DELAY0:		MOV	R6,	#250D
		DELAY1:		MOV	R5,	#250D

				DJNZ	R5,	$
				DJNZ	R6,	DELAY1
				DJNZ	R7,	DELAY0
		RET


				END					; Fim do programa