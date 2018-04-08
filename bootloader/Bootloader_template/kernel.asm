org 0x500
jmp 0x0000:start

start:
	xor ax, ax
	mov ds, ax
	mov es, ax

done:
	jmp $