org 0x7c00

jmp start
msg: db 'Hello World!', 0

start: 
	mov ax, 0
	mov ds,ax
	mov si, msg
	mov cl,0
	loop:
		lodsb
		cmp cl,al
		je exit
		mov ah, 0xE
		mov bh,0
		int 0x10
		jmp loop
exit:
	times 510-($-$$) db 0
	dw 0AA55h ; some BIOSes require this signature 