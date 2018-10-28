
;CORES

preto equ 0x00
azul equ 0x01
verde equ 0x02
ciano equ 0x03
vermelho equ 0x04
magenta equ 0x05
marrom equ 0x06
cinza_claro equ 0x07
cinza_escuro equ 0x08
azul_claro equ 0x09
verde_claro equ 0x0A
ciano_claro equ 0x0B
vermelho_claro equ 0x0C
magenta_claro equ 0x0D
amarelo equ 0x0E
branco equ 0x0F

;teclas

line_feed equ 0ah
o_enter equ 0dh
prox_dica equ 64h
responder equ 72h
sair equ 73h

org 0x7e00
jmp 0x0000:start

;quantidade de letras das respostas

letras_1 equ 5
letras_2 equ 5
letras_3 equ 8
letras_4 equ 4
letras_5 equ 15

start:
	xor ax, ax
	mov ds, ax
	mov es, ax

	call video_mode
	call background

	mov dh, 1
	mov dl, 8

	call pula_3linhas

	mov si, nomejogo
	mov bl, amarelo
	call printa

	call pula_3linhas

	mov si, instrucao1	
	mov bl, branco
	call printa

	call update_pos_cursor
	inc dh
	mov dl, 0
	call set_pos_cursor

	mov si, instrucao2	
	mov bl, branco	
	call printa

	mov si, instrucao3
	mov bl, branco	
	call printa

	call update_pos_cursor
	inc dh
	mov dl, 0
	call set_pos_cursor

	mov si, instrucao4
	mov bl, branco		
	call printa

	mov si, instrucao5
	mov bl, branco		
	call printa

	mov si, instrucao6
	mov bl, branco		
	call printa

	mov si, instrucao7		
	mov bl, branco
	call printa

	call update_pos_cursor
	inc dh
	mov dl, 0
	call set_pos_cursor

	mov si, instrucao9		
	mov bl, vermelho
	call printa

	call pula_3linhas

	mov si, comecar
	mov bl, vermelho		
	call printa

	mov ax,0
	call inpute_enter

	escolha_charada:
		call video_mode
		call background

		call update_pos_cursor
		mov dh, 2
		call set_pos_cursor

		mov si, instrucao10
		mov bl, amarelo
		call printa

		call update_pos_cursor
		inc dh
		call set_pos_cursor

		mov si, instrucao8
		mov bl, amarelo
		call printa

		call pula_3linhas
		call pula_3linhas
		call pula_3linhas

			
		mov si, pergunta1
		mov bl, verde_claro
		call printa

		mov si, pergunta2
		mov bl, verde
		call printa

		mov si, pergunta3
		mov bl, magenta_claro
		call printa

		mov si, pergunta4
		mov bl, magenta
		call printa
		
		mov si, pergunta5
		mov bl, vermelho
		call printa

		call update_pos_cursor
		add dh, 4
		mov dl, 17
		call set_pos_cursor

		mov si, fim_de_jogo
		mov bl, branco
		call printa

		getoption:
			xor ax, ax
			mov ah, 0x00 
			int 16h

			cmp al, '1'
			je charada_1  
			cmp al, '2'
			je charada_2
			cmp al, '3'
			je charada_3
			cmp al, '4'
			je charada_4
			cmp al, '5'
			je charada_5
			cmp al, sair
			je fim_jogo

			jmp getoption

	fim_jogo:
		call video_mode
		call background

		call pula_3linhas
		call pula_3linhas
		call pula_3linhas
		call prox_linha

		mov si, fim_de_tudo
		mov bl, amarelo
		call printa
		jmp end

charada_1:
	call video_mode
	call background

	call printa_titulo

	mov si, qtde_1
	mov bl, amarelo
	call printa
	call prox_linha

	d11:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_11
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_1
		push ax

		call getchar

		cmp al,'d'
		je d12

		mov si, resposta_1

		call compare

		xor dx, dx

	d12:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_12
		mov bl, branco
		call printa

		mov ax, letras_1
		push ax

		call getchar

		cmp al,'d'
		je d13

		mov si, resposta_1

		call compare

		xor dx, dx

	d13:		
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_13
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_1
		push ax

		call getchar

		cmp al,'d'
		je dica_final_1

		mov si, resposta_1

		call compare

		xor dx, dx

		jmp escolha_charada

	dica_final_1:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, end_dicas
		mov bl, vermelho_claro
		call printa

		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		call resposta

		mov si, resposta_1
		call compare

		jmp escolha_charada

charada_2:
	call video_mode
	call background
	call printa_titulo

	mov si, qtde_2
	mov bl, amarelo
	call printa
	call prox_linha

	d21:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_211
		mov bl, branco
		call printa
		call prox_linha

		mov si, dica_212
		mov bl, branco
		call printa
		call prox_linha

		mov si, dica_213
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_2
		push ax

		call getchar

		cmp al,'d'
		je d22

		mov si, resposta_2

		call compare

		xor dx, dx

	d22:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_22
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_2
		push ax

		call getchar

		cmp al,'d'
		je d23

		mov si, resposta_2

		call compare

		xor dx, dx

	d23:		
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_23
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_2
		push ax

		call getchar

		cmp al,'d'
		je dica_final_2

		mov si, resposta_2

		call compare

		xor dx, dx

		jmp escolha_charada

	dica_final_2:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, end_dicas
		mov bl, vermelho_claro
		call printa

		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		call resposta

		mov si, resposta_2
		call compare

		jmp escolha_charada

charada_3:
	call video_mode
	call background
	call printa_titulo

	mov si, qtde_3
	mov bl, amarelo
	call printa
	call prox_linha

	d31:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_31
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_3
		push ax

		call getchar

		cmp al,'d'
		je d32

		mov si, resposta_3

		call compare

		xor dx, dx

	d32:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_32
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_3
		push ax

		call getchar

		cmp al,'d'
		je d33

		mov si, resposta_3

		call compare

		xor dx, dx

	d33:		
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_33
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_3
		push ax

		call getchar

		cmp al,'d'
		je dica_final_3

		mov si, resposta_3

		call compare

		xor dx, dx

		jmp escolha_charada

	dica_final_3:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, end_dicas
		mov bl, vermelho_claro
		call printa

		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		call resposta

		mov si, resposta_3
		call compare

		jmp escolha_charada

charada_4:
	call video_mode
	call background
	call printa_titulo


	mov si, qtde_4
	mov bl, amarelo
	call printa
	call prox_linha

	d41:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_41
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_4
		push ax

		call getchar

		cmp al,'d'
		je d42

		mov si, resposta_4

		call compare

		xor dx, dx

	d42:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_42
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_4
		push ax

		call getchar

		cmp al,'d'
		je d43

		mov si, resposta_4

		call compare

		xor dx, dx

	d43:		
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_43
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_4
		push ax

		call getchar

		cmp al,'d'
		je dica_final_4

		mov si, resposta_4

		call compare

		xor dx, dx

		jmp escolha_charada

	dica_final_4:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, end_dicas
		mov bl, vermelho_claro
		call printa

		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		call resposta

		mov si, resposta_4
		call compare

		jmp escolha_charada

charada_5:
	call video_mode
	call background
	call printa_titulo

	mov si, qtde_5
	mov bl, amarelo
	call printa
	call prox_linha

	d51:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor


		mov si, dica_51
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_5
		push ax

		call getchar

		cmp al,'d'
		je d52

		mov si, resposta_5

		call compare

		xor dx, dx

	d52:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_52
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_5
		push ax

		call getchar

		cmp al,'d'
		je d53

		mov si, resposta_5

		call compare

		xor dx, dx

	d53:		
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, dica_53
		mov bl, branco
		call printa
		call prox_linha

		mov ax, letras_5
		push ax

		call getchar

		cmp al,'d'
		je dica_final_5

		mov si, resposta_5

		call compare

		xor dx, dx

		jmp escolha_charada

	dica_final_5:
		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		mov si, end_dicas
		mov bl, vermelho_claro
		call printa

		call update_pos_cursor
		inc dh
		mov dl, 0
		call set_pos_cursor

		call resposta

		mov si, resposta_5
		call compare

		jmp escolha_charada

printa_titulo:
	mov dh, 1
	mov dl, 8
	call set_pos_cursor
	
	mov si, title
	mov bl, vermelho
	call printa

	call update_pos_cursor
	
	add dh, 2
	mov dl, 10
	call set_pos_cursor

	ret

inpute_enter:	
	mov ah, 0
	int 16h	
	
	cmp al, 0xd
	jne inpute_enter
	ret

getchar:
	xor ax, ax
	mov ah, 0x00 ;le do teclado
	int 16h
	cmp al, responder
	je resposta  
	cmp al, prox_dica
	je end_getchar
	jmp getchar

	resposta:
		xor ax, ax
		call update_pos_cursor

		inc dh
		mov dl, 10
		call set_pos_cursor

		mov bl, azul
		mov si, responda
		call printa

		pop bx
		mov ax, '*'
		push ax
		xor ax, ax
		xor dx, dx
		
	getstr:
		xor ax, ax
		mov ah, 0x00 ;le do teclado
		int 16h

		cmp al, o_enter
		je end_getstr


		call putchar

		cmp al, ' '
		je getstr

		push ax 
		inc dx		 
		jmp getstr

		end_getstr:
			push dx
			push bx

	end_getchar:
		ret

compare:
	pop bx ;popa endereço de retorno
	pop cx ;qtde de letras digitadas

	xor dx, dx
	xor ax, ax

	comp_palavras:
		pop dx
		cmp dx, '*'
		je comp_qtdes 	;as letras foram iguais ate agora, mas podem ter colocado algo a mais
				  	  	;então compara a qtde de letras	

		lodsb 
		cmp dl, al 
		jne end_game
		jmp comp_palavras

	comp_qtdes:
		pop dx
		cmp cx, dx
		je acertou

	end_compare:
		push bx
		ret

acertou:
	call video_mode
	call background
	
	call pula_3linhas
	call pula_3linhas

	call coroa

	call pula_3linhas
	call pula_3linhas
	call pula_3linhas

	mov si, ganhou
	mov bl, azul_claro
	call printa

	call update_pos_cursor
	add dh, 7
	mov dl, 15
	call set_pos_cursor

	mov si, voltar
	mov bl, branco
	call printa

	call inpute_enter
	jmp escolha_charada

coroa:
	trofeu:
	mov cx, 125
	mov dx, 50


	mov si, t4
	mov byte[counter], 0
	call printe_imagem
	mov cx, 125
	inc dx
	mov si, t5
	mov byte[counter], 0
	call printe_imagem
	mov cx, 125
	inc dx

	mov si, t6
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx    

	mov si, t7
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx 

	mov si, t8
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx 

	mov si, t9
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx    

	mov si, t10
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx 

	mov si, t11
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx
	mov si, t12
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx    

	mov si, t13
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx 

	mov si, t14
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx

	mov si, t15
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx 

	mov si, t16
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx

	mov si, t17
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx    

	mov si, t18
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx 

	mov si, t19
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx

	mov si, t20
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx
	mov si, t21
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx    

	mov si, t22
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx 

	mov si, t23
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx

	mov si, t24
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx 

	mov si, t25
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx   
	
	mov si, t26
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx

	mov si, t27
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx 

	mov si, t28
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx 

	mov si, t29
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx    

	mov si, t30
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t31
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t32
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t33
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t34
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t35
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx   

	mov si, t36
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t37
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t38
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t39
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t40
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                


	mov si, t41
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t42
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t43
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t44
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t45
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t46
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx   

	mov si, t47
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t48
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t49
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	mov si, t50
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx      

	mov si, t51
	mov byte[counter], 0   
	call printe_imagem
	mov cx, 125
	inc dx                

	ret

printe_imagem:
	lodsb
	mov ah, 0ch ; write graphics pixel
	mov bh, 0 ; page
	mov bl, al
	int 10h
	add byte[counter], 1
	inc cx

	cmp byte[counter], 51
	jne printe_imagem
	ret
	
end_game:
	call video_mode
	call background
	
	call pula_3linhas
	call pula_3linhas
	call pula_3linhas
	call pula_3linhas

	mov dh, 15
	mov dl, 15
	mov si, perdeu
	mov bl, vermelho
	call printa
	
	call update_pos_cursor
	add dh, 7
	mov dl, 15
	call set_pos_cursor

	mov si, voltar
	mov bl, branco
	call printa

	call inpute_enter
	jmp escolha_charada

update_pos_cursor:
	mov ah, 03h
	mov bh, 0
	int 10h
	ret

set_pos_cursor:
	mov ah, 02h
	mov bh, 0
	int 10h
	ret

printa:

	print:
		lodsb ; load em al o bit apontado por si
		cmp al, 0
		je end_printa

		call putchar

		jmp print

	end_printa:
		ret
	
prox_linha:
	mov ah, 0x0e
	mov al, 0xd
	int 10h
	mov al, 0xa
	int 10h
	ret

pula_3linhas:
	mov ah, 0xe ;\n
	mov al, 0xd
	int 10h
	mov al, 0xa
	int 10h

	;mov ah, 0xe ;\n precisa chamar a funccao novamente
	mov al, 0xd
	int 10h
	mov al, 0xa
	int 10h

	;mov ah, 0xe ;\n
	mov al, 0xd
	int 10h
	mov al, 0xa
	int 10h

	ret

video_mode:
	mov ah, 0
    mov al, 13h 
    int 10h 
    ret

background:
	mov ah,0xb
	mov bh,0
	mov bl, vermelho ; color
	int 10h
	ret

putchar:		 ;printa caracter	
	mov ah, 0x0e
	int 10h
	ret


;INTERAÇÕES
nomejogo db '              <CINENIGMA>            ', 13, 10, 0
escolha db 'OLA! ESCOLHA O NUMERO DA CHARADA: (1-5)', o_enter, line_feed, 0
responda db 'RESPOSTA: ', 0
end_dicas db 'AS DICAS ACABARAM, EH AGORA OU NUNCA!!!', 0 
comecar    db '                 >PRESS ENTER TO START', 0
ganhou db 1, '   ORA, ORA, TEMOS UM XEROQUE ROMES ', 1, 0
perdeu db '       (T_T)NAO FOI DESSA VEZ (T_T)', 0
voltar db '>PRESS ENTER TO CONTINUE', 0
fim_de_tudo db '         IT IS ALL, FOLKS!!!', 0

;OPÇÕES
pergunta1  db '     1  ', 0 
pergunta2  db '   2   ', 0
pergunta3  db '   3   ', 0
pergunta4  db '   4   ', 0 
pergunta5  db '   5     ', 0 
fim_de_jogo db 'SAIR(s)', 0

;INSTRUÇÕES
instrucao1 db '             INSTRUCOES!', 13, 10, 0
instrucao2 db 'I-O jogador tera direito a 3 dicas;', 13, 10, 0
instrucao3 db 'II-Ha apenas uma chance de responder;', 13, 10, 0
instrucao4 db 'III-Pressione:', 13, 10, 0
instrucao5 db '     <D> para proxima dica', 13, 10, 0
instrucao6 db '     <R> para inserir sua resposta', 13, 10, 0
instrucao7 db '     <Enter> para confirmar resposta', 13, 10, 0
instrucao8 db '  Pressione o numero de sua preferencia:', 13,10, 0
instrucao9 db 'VAMOS VER SE VOCE EH BOM EM CHARADAS!!', 13, 10, 0
instrucao10 db '  Cada numero corresponde a uma charada', 13, 10, 0


;CHARADAS

title db 1, ' O QUE EH O QUE EH? ', 1, 0
qtde_1 db '1 palavra: 5 letras', 0, o_enter, line_feed, 0
qtde_2 db '1 palavra: 5 letras', 0, o_enter, line_feed, 0
qtde_3 db '1 palavra: 8 letras', 0, o_enter, line_feed, 0
qtde_4 db '1 palavra: 4 letras', 0, o_enter, line_feed, 0
qtde_5 db '2 palavras: 15 letras', 0, o_enter, line_feed, 0
dica_11 db '1- Cai em pe e corre deitado', 0
dica_12 db '2- Quanto mais proxima, mais escuro fica', 0 
dica_13 db '3- Nada ainda? Serio?', 0 
dica_211 db '1- tem capa mas nao eh super-homem,', 0 
dica_212 db 'tem folha mas nao eh arvore,', 0
dica_213 db 'tem orelha mas nao eh gente', 0
dica_22 db '2- sem cuidado, pode rasgar', 0
dica_23 db '3- para nao se perder, tem que marcar', 0
dica_31 db '1- tem 8 letras e tirando a metade ainda fica 8', 0
dica_32 db '2- pode ter varios formatos', 0
dica_33 db '3- nao, eh bolacha', 0
dica_41 db '1- eh grande antes de ser pequena', 0
dica_42 db '2- tem a cabeca quente', 0
dica_43 db '3- se assoprar esfria', 0
dica_51 db '1- tem bico, mas nao bica, tem asas mas nao voa', 0
dica_52 db '2- tem peh mas nao anda', 0
dica_53 db '3- nao esta vivo', 0
resposta_1 db 'avuhc', 0
resposta_2 db 'orvil', 0
resposta_3 db 'otiocsib', 0
resposta_4 db 'alev', 0
resposta_5 db 'otromohnirassap', 0

;EXTRAS
counter db 0

;GANHADOR
t4 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
t5 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
t6 db 0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0
t7 db 0,0,0,8,14,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,14,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,14,8,0,0,0,0,0,0
t8 db 0,0,0,8,14,14,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,14,14,14,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,14,14,8,0,0,0,0,0,0
t9 db 0,0,0,8,14,14,14,8,0,0,0,0,0,0,0,0,0,0,0,0,0,8,14,14,14,8,0,0,0,0,0,0,0,0,0,0,0,0,0,8,14,14,14,8,0,0,0,0,0,0
t10 db 0,0,0,8,14,14,14,14,8,0,0,0,0,0,0,0,0,0,0,0,8,14,14,14,14,14,8,0,0,0,0,0,0,0,0,0,0,0,8,14,14,14,14,8,0,0,0,0,0,0
t11 db 0,0,0,8,14,14,14,14,14,8,0,0,0,0,0,0,0,0,0,8,14,14,14,14,14,14,14,8,0,0,0,0,0,0,0,0,0,8,14,14,14,14,14,8,0,0,0,0,0,0
t12 db 0,0,0,8,14,14,14,14,14,14,8,0,0,0,0,0,0,0,8,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0,0,8,14,14,14,14,14,14,8,0,0,0,0,0,0
t13 db 0,0,0,8,14,14,14,14,14,14,14,8,0,0,0,0,0,0,8,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0,8,14,14,14,14,14,14,14,8,0,0,0,0,0,0,0
t14 db 0,0,0,8,14,14,14,14,14,14,14,14,8,0,0,0,0,0,8,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,8,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t15 db 0,0,0,8,14,14,14,14,14,14,14,14,14,8,0,0,0,0,8,14,14,14,14,14,14,14,14,14,8,0,0,0,0,8,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t16 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,8,0,0,0,8,14,14,14,14,14,14,14,14,14,8,0,0,0,8,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t17 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,8,0,8,14,14,14,14,14,14,14,14,14,14,14,8,0,8,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t18 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,8,14,14,14,14,14,14,14,14,14,14,14,14,14,8,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t19 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,8,14,14,14,14,14,8,8,8,14,14,14,14,14,8,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t20 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,8,8,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t21 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t22 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t23 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t24 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t25 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t26 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t27 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t28 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t29 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t30 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t31 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t32 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t33 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t34 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t35 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t36 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t37 db 0,0,0,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,8,0,0,0,0,0,0
t38 db 0,0,0,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,0,0,0,0,0,0
t39 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
t40 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,8,8,0,0,0,0,0,0
t41 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,8,8,0,0,0,0,0,0
t42 db 0,0,0,0,0,0,8,8,8,0,0,0,0,0,0,0,0,0,0,8,8,8,0,0,8,8,8,8,0,0,8,8,0,0,0,8,8,0,0,0,8,8,8,8,0,0,0,0,0,0
t43 db 0,0,0,0,0,0,0,8,8,8,0,0,0,0,0,0,0,0,8,8,8,0,0,0,8,8,8,8,0,0,8,8,8,0,0,8,8,0,0,0,8,8,8,8,0,0,0,0,0,0
t44 db 0,0,0,0,0,0,0,0,8,8,8,0,0,8,8,0,0,8,8,8,0,0,0,0,0,8,8,0,0,0,8,8,8,8,0,8,8,0,0,0,0,8,8,0,0,0,0,0,0,0
t45 db 0,0,0,0,0,0,0,0,0,8,8,0,0,8,8,0,0,8,8,0,0,0,0,0,0,0,0,0,0,0,8,8,0,8,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0
t46 db 0,0,0,0,0,0,0,0,0,0,8,8,0,8,8,0,8,8,0,0,0,0,0,0,8,8,8,8,0,0,8,8,0,0,8,8,8,0,0,0,0,8,8,0,0,0,0,0,0,0
t47 db 0,0,0,0,0,0,0,0,0,0,0,8,8,0,0,8,8,0,0,0,0,0,0,0,8,8,8,8,0,0,8,8,0,0,0,8,8,0,0,0,8,8,8,8,0,0,0,0,0,0
t48 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,8,8,0,0,0,0,0,0
t49 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,0,0,0,0,0,0,0
t50 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
t51 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

end:


dw 0xaa55  