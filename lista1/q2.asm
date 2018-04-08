;; Defines
carriage_return equ 0Dh
write_service equ 0x0e
read_service equ 0x00

;; Program start
org 0x7c00               ; BIOS loads at this address

bits 16                   ; 16 bits real mode

; Print a welcome message.
; We have no DOS nor Linux kernel here.
; Therefore, we will use bios int 0x10.

xor dx, dx

start:
	jmp read_kbd
end_prog:
	jmp end_prog

; Read untill the enter
read_kbd:
	call read_char
	cmp ax, carriage_return
	je printa_enter
	push ax
	inc dx
	call print_char
	jmp read_kbd

printa_enter:
	mov ax, 0x0A ; enter
	call print_char
	mov ax, carriage_return
	call print_char
	jmp end_read_kbd

end_read_kbd:
	pop ax
	call print_char
	sub dx, 1
	cmp dx, 0
	je end_prog
	jmp end_read_kbd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Subrountines            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_char:
	mov AH, read_service ;Número da chamada.
	int 16h ; Put the char in AL
	xor ah, ah
	ret

print_char:
	mov ah, write_service
	int 10h ; Write interruption
	xor ah, ah
	ret

msg: db "Hello, World!", 0

;----------------------------------------------;
; Bootloader signature must be located
; at bytes #511 and #512.
; Fill with 0 in between.
; $  = address of the current line
; $$ = address of the 1st instruction
;----------------------------------------------;

times 510 - ($-$$) db 0
dw        0xaa55