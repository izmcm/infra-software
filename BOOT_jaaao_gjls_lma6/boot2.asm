org 0x500
jmp 0x0000:start

gajeluBIOS db 'Starting GajeluBios (version pro 0.5.2-116_060709-nani)',0

loading db 'Loading struct for the kernel...', 0
setting db 'Setting up protected mode...', 0
lmemory db 'Loading kernel in memory...', 0
running db 'Running kernel...', 0

bits 16                   ; 16 bits real mode

start:
    xor ax, ax
    mov ds, ax
    mov es, ax


    ;ativando modo grafico
    mov ah, 0
    mov al, 12h 
    int 10h 

   	;background
	mov ah,0
	mov bh,0
	mov bl, 0 ; color
	int 10h
    

 	mov si, gajeluBIOS
	call print_BIOS_name
    call pula_2linhas

	mov si, loading
	call print

	mov si, setting
	call print

	mov si, lmemory
	call print

	mov si, running
	call print

	call pula_2linhas
	call pula_2linhas

    jmp reset


; ---------------------------------------------
reset:

    mov ax, 0x7e0 ;0x7e0<<1 = 0x7e00 (início de kernel.asm)
    mov es, ax
    xor bx, bx    ;posição es<<1+bx

    mov ah, 00h ;reseta o controlador de disco
    mov dl, 0   ;floppy disk
    int 13h

    jc reset    ;se o acesso falhar, tenta novamente


load_kernel:
    mov ah, 02h ;lê um setor do disco
    mov al, 20  ;quantidade de setores ocupados pelo kernel
    mov ch, 0   ;track 0
    mov cl, 3   ;sector 3
    mov dh, 0   ;head 0
    mov dl, 0   ;drive 0
    int 13h

    jc load_kernel     ;se o acesso falhar, tenta novamente

    jmp 0x7e00  ;pula para o setor de endereco 0x7e00 (start do boot2)

; -------------------------------------------------

print_BIOS_name:
	lodsb
	cmp al,0
	je fim

	mov ah, 0eh
	mov bl, 14 ; define a cor como verde de acordo com o Bios color attributes
	int 10h
	
	jmp print_BIOS_name

	fim:
		mov ah, 0eh
		mov al, 0xd
		int 10h
		mov al, 0xa
		int 10h
		ret

print:
	lodsb
	cmp al,0
	je done

	mov ah, 0eh
	mov bl, 14 ; define a cor como verde de acordo com o Bios color attributes
	int 10h

	mov dx, 0
	.delei: ;delay
	inc dx
	mov cx, 0
		.time:	;background
			inc cx
			cmp cx, 10000
			jne .time

	cmp dx, 1000
	jne .delei

	jmp print

	done:
		mov ah, 0eh
		mov al, 0xd
		int 10h
		mov al, 0xa
		int 10h
		
		ret

pula_2linhas:
	mov ah, 0eh
	mov al, 0xd
	int 10h
	mov al, 0xa
	int 10h
	mov ah, 0eh
	mov al, 0xd
	int 10h
	mov al, 0xa
	int 10h
	ret