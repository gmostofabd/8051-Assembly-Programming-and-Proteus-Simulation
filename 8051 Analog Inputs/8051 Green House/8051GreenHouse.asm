;Projeto de uma estufa agrícola inteligente
;Autores: Múria e Rauney
;conversor AD0804 de 8 bits (0 a 255) com vcc no 5 V
;sensor de temperatura LM35 ligado a vcc de 5 V (2ºC a 150ºC) pelo modo simples
;X*10mV = X*1ºC -> 20 mV = 2ºC
;valor de referência do ADC = 2,55 V -> (2550 mV/255) = 10 mV --> temperatura medida de 1 em ;1 ºC
;Obs: pino de referencia do AD0804 da temperatura = referencia/2 = 1,275 V
;Exemplo: 	leitura analógica(através do ADC) de 127
;		127 = 1*127 = 127 ºC
;Liga o cooler se a temperatura for maior ou igual a 30 ºC e desliga quando a temperatura for menor que 28 ºC
;Liga a bomba de água caso o pino de leitura Soil esteja em nivel alto(seco) e desliga caso esteja em nível baixo(úmido)
;Liga o LED caso o pino de leitura Light esteja em nível alto(baixa iluminação) e desliga caso esteja
;em nível baixo(alta iluminação)
;----------Reset---------------------------------
	org	0000h
	ajmp	config
;----------Timer0--------------------------------
Timer0:
	org 	0Bh
	djnz	overT0,endT0
	ajmp	tratamento0
EndTimer0:
	reti
;----------Rotina de tratamento do Timer0-----
tratamento0:
	clr	TR0
	clr	Water		;desliga a bomba de água
	MOV	overT0,#80h	;128 x o estouro do timer0
endT0:
	MOV	TH0,#0Bh	;carrega TH0|TL0 com o valor 3036 decimal para atingir a contagem de 62500us a cada estouro
	MOV	TL0,#0DCh
	ajmp	EndTimer0
;--------------------------------------------
config:
	overT0	EQU	066h	;define a quantidade de estouros do timer0 para atingir 8 segundos
	clr	TR0		;desliga a contagem
	MOV	TMOD,#00000001b	;programa o timer0 para modo 16 bits
	MOV	IE,#10000010b	;habilita interrupção do timer0
	MOV	TH0,#0Bh	;carrega TH0|TL0 com o valor 3036 decimal para atingir a contagem de 62500us a cada estouro  
	MOV	TL0,#0DCh
	MOV	OVERT0,#80h	;128 x o estouro do timer0

	mov	P0,#0FFh	;entrada conversor AD
	mov	P1,#00000010b	;saídas de configurações e entrada do intr
	mov	P2,#00h		;saída para o LCD
	mov	P3,#11000000b	;saídas de acionamento e leitura binária da umidade do solo e iluminação
	
	cWR	equ	P1.0	;pino write do AD (ativo em 0)
	cINTR	equ	P1.1	;pino de intr do AD (ativo em 0)
	cRD	equ	P1.2	;pino rd do AD (ativo em 0)
	cCS	equ	P1.3	;pino cs do AD (ativo em 0)
	setb	cRD
	setb	cWR
	RS	equ	P1.5	;pino RS do LCD
	RW	equ	P1.6	;pino RW do LCD
	E	equ	P1.7	;pino E do LCD
	LCD	equ	P2	;pinos de dados do LCD
	Cooler  equ	P3.0	;pino acionador do cooler
	Water	equ	P3.1	;pino acionador da bomba de água
	LED	equ	P3.2	;pino acionador da iluminação
	Light	equ	P3.6	;pino de leitura binária da iluminação (baixa = 1 ou alta = 0)
	Soil	equ	P3.7	;pino de leitura binária da umidade do solo (seco = 1 ou úmido = 0)
	
	clr	Water		;inicia com a bomba de água desligada
	clr	Cooler		;inicia com o cooler desligado	
	clr	LED		;inicia com a luz desligada	
	setb	cCS		;desabilita o AD

	clr	E		;desabilita o enable do LCD
	acall	Lcd_Init	;inicializa o LCD
	mov	b,#01h		
	acall	position	;posiciona o cursor em 1x1
	mov	a,#00h
	acall	writetable	;escreve 'Tp:' na linha 1
	
	mov	b,#0Ah		
	acall	position	;posiciona o cursor em 1x10
	mov	a,#04h
	acall	writetable	;escreve 'I:' na linha 1

	mov	b,#81h		
	acall	position	;posiciona o cursor em 2x1
	mov	a,#07h
	acall	writetable	;escreve 'Umidade:' na linha 2
	
	acall	Delay150us

;----------Rotina principal-------------------------------------
main:
	acall	ReadTemp	;faz a leitura da temperatura e escreve no LCD
	acall	Temp		;toma a decisão em relação a temperatura 
	acall	Soil		;faz a leitura da umidade, envia pro LCD e toma decisões
	acall	Light		;faz a leitura da iluminação, envia pro LCD e toma decisões
	ajmp	main
;----------Analisa a temperatura e toma decisões-----------------
Temp:
	cjne	R6,#30d,TempAux	;compara a temperatura lida com o valor 30
TempAux:
	jnc	TempHigh	;verifica se o carry = 0 (temperatura maior ou igual a 30)
				;e pula para TempHigh se for verdadeiro

	cjne	R6,#28d,TempAux2;compara a temperatura lida com o valor 28
TempAux2:
	jc	TempLow		;verifica se o carry = 1 (temperatura menor que 28)
				;e pula para TempLow se for verdadeiro
	ret
TempLow:
	clr	Cooler		;desliga o cooler
	ret
TempHigh:
	setb	Cooler		;liga o cooler
	ret
;----------Analisa a iluminação e toma decisões--------
Light:
	mov	b,#00001100b
	acall	position	;posiciona o cursor em 1x12
	jb	Light,LowLight	;Verifica se bit Light = 1 (iluminação baixa e pula para LowLight se for verdadeiro
HighLight:
	clr	LED		;desliga a iluminação
	mov	a,#19h
	acall	writetable	;escreve ALTA no LCD
	ret
LowLight:
	setb	LED		;liga a iluminação
	mov	a,#13h
	acall	writetable	;escreve BAIXA no LCD
	ret
;----------Lê a temperatura--------------------------------
ReadTemp:
	clr	cCS		;liga o Ad da temperatura
	acall	ReadAnalog	;lê o valor entre 0 e 255 do conversor
	acall	SendLCDTemp	;envia para o LCD
	setb	cCS		;libera a linha de comunicação
	ret
;----------Leitura analógica-------------------------------
ReadAnalog:
	clr	cWR		;ativa o modo escrita
	nop
	setb	cWR		;inicia a conversão
	jb	cINTR,$		;aguarda até INTR ser 0
	clr	cRD		;ativa modo leitura
	nop
	mov	a,P0		;lê o valor do ADC para o acc
	setb	cRD		;completa o ciclo de leitura
	mov	R6,a		;salva o valor lido de AD no registrador R6
	ret
;----------Envia pro LCD o valor da Temperatura-------------
SendLCDTemp:			;OBS: converter dígito binário para ascii -> soma o dígito binário com 30h  
	mov	b,#00000100b
	acall	position	;posiciona cursor em 1x4
	mov	b,#100d
	div	ab		;a = centenas
	cjne	a,#00h,NoFirst0	;verifica se é zero o dígito das centenas, se for escreve ' '
First0:
	mov	a,#' '
	acall	Send_Data	;envia caractere " " para o LCD
	ajmp	NextValue	;pula para encontrar o valor correspondente as dezenas
NoFirst0:
	acall	FindBit		;se o digito das centenas não for zero chama a funçao FindBit para encontrar o digito da centena
NextValue:
	mov	a,b		
	mov	b,#10d
	div	ab		;a = dezena
	acall	FindBit		;chama a funçao FindBit para encontrar o digito da dezena

	mov	a,b		;a = unidade
	acall	FindBit		;chama a funçao FindBit para encontrar o digito da unidade

	mov	a,#10h	
	acall	writetable	;escreve 'ºC' no LCD
	ret
FindBit:	
	add	a,#30h		;encontra o correspondente ascii
	acall	Send_Data	;e envia para o LCD
	ret
;----------Analisa a umidade do solo e toma decisões--------
Soil:
	jb	TR0,EndSoil	;verifica se a contagem está ativa e pula para o final se estiver
	mov	b,#10001001b
	acall	position	;posiciona o cursor em 2x9
	jnb	Soil,WetSoil	;Verifica se bit Soil = 0 (solo úmido) e pula para WetSoil se for verdadeiro
DrySoil:	
	setb	TR0		;inicia a contagem de 8 segundos
	setb	Water		;liga a bomba de água
	mov	a,#13h
	acall	writetable	;escreve BAIXA no LCD
	ajmp	EndSoil
WetSoil:
	clr	Water		;desliga a bomba de água
	mov	a,#19h
	acall	writetable	;escreve ALTA no LCD
EndSoil:
	ret
;------------------------------------------------------
lcd_init:
	mov	a,#38h		;0011 1000b	;func
	acall	send_inst
	acall	delay15ms
	acall	send_inst
	acall	delay15ms
	mov	a,#06h		;0000 0111b
				;Estabelece o sentido de deslocamento do cursor 
				;(X=0 p/ esquerda, X=1 p/ direita) -> X = acc.1
				;Estabelece se a mensagem deve ou não ser deslocada com a entrada 									;de um novo caracter S=1 SIM, S=0 NÃO. Exemplo: X=1 e S=1 => 										;mensagem desloca p/ direita. -> S = acc.0
	acall	Send_Inst
	acall	DisplayON
	acall	Cleardisplay
	ret
;------------------------------------------------------
Send_Data:
	push	acc
	acall	busy_check
	pop	acc
	clr	RW
	setb	RS
	mov	LCD,a
	setb	E
	nop
	clr	E
	ret
;------------------------------------------------------
Send_Inst:
	push	acc
	acall	busy_check
	pop	acc
	clr	RW
	clr	RS
	mov	LCD,a
	setb	E
	nop
	clr	E
	ret
;------------------------------------------------------
Busy_Check:
	mov	LCD,#0FFh
	setb	RW
	clr	RS
	setb	E
	nop
	mov	a,LCD
	clr	E
	jb	acc.7,Busy_check
	ret
;------------------------------------------------------
ClearDisplay:
	acall	busy_check
	mov	a,#00000001b	;instrução para limpar display e voltar o cursor para 1x1
	acall	Send_Inst
	ret
;------------------------------------------------------
Position:
	push	acc
	mov	a,b
	jnb	a.7,Line1
Line2:
	clr	acc.7
	add	a,#3Fh		;soma o valor da coluna com o ultimo valor da linha 1
	setb	acc.7
	ajmp	column
Line1:
	clr	c
	subb	a,#00000001b
	setb	acc.7
Column:
	acall	Send_Inst
	pop	acc
	ret
;------------------------------------------------------
DisplayON:
	acall	busy_check
	mov	a,#00001100b	
				;0000 1DCBb
				;Liga (D=1) ou desliga display (D=0)
				;-Liga(C=1) ou desliga cursor (C=0)
				;-Cursor Piscante(B=1) se C=1
	acall	Send_Inst
	ret
;------------------------------------------------------
WriteTable:
	mov 	dptr,#words
auxt:
	push	acc
	acall	busy_check
	pop	ACC
	push	acc
	MOVC	A,@A+dptr
	Cjne	A,#00h,Send
	pop	acc
	jmp 	Final
Send:
	acall	send_data
	inc	dptr
	pop	acc
	jmp	auxt
Final:
	ret
;----------Delay 150 us-------------------------
Delay150us:		;2 us
	mov	R7,#75	;1 us
	djnz	R7,$	;2 us * 73
	ret		;2 us
			; delay = 151 us
;-----------------------------------------------
delay1ms:		;2
	push	acc
	mov	a,#0F8h	;1
	djnz	acc,$	;248*2
	mov	a,#0F9h ;1
	djnz	acc,$	;249*2
	pop	acc
	ret		;2
			;1000 us = 1 ms
;-----------------------------------------------
delay15ms:		;2
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	acall	delay1ms
	ret
;-----------Dados memória de programa------------------------------------
WORDS:
one:	db	'TP:'		;00h;"TP:100ºC "
	db	'\0'
two:	db	'I:'		;04h;"I:BAIXA"
	db	'\0'
three:	db	'UMIDADE:'	;07h;"UMIDADE:BAIXA"
	db	'\0'
four:	db	11011111b	;10h ;representação de 'º' de acordo com o LCD usado
	db	'C'		;aqui montamos "ºC"	
	db	'\0'
five:	db	'BAIXA'		;13h
	db	'\0'
six:	db	'ALTA '		;19h
	db	'\0'
;---------Fim------------------------------------------
end		

	
