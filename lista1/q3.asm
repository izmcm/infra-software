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

setup:
	mov bx, '*'
	push bx
	mov bp, sp


; Read untill the enter
read_kbd:
	call read_char
	cmp ax, carriage_return
	je end_read_kbd
	push ax ; Put every character in the stack No backspace allowed yet
	call print_char
	jmp read_kbd
end_read_kbd:

; jmp print_all

start:

	

	mov dx, bp
	
	mov bx, sp ;; Get the stack size
	sub dx, bx

	mov si, sp
	add si, 2

	loop1:
		cmp si, bp
		je loop2

		mov bx, [si - 2]
		mov cx, [si]
		cmp bx, cx
		jl no_swap ;; Jump outside if no need to swap
		;; Swap instruction
		mov bx, [si - 2]
		xchg bx, [si]
		mov [si - 2], bx
		no_swap:
		;; Check swap
		
		add si, 2
		jmp loop1
		loop2:
			cmp dx, 0
			je end_loop
			dec dx
			mov si, sp
			jmp loop1


		end_loop:

	jmp print_all

print_all:

	mov ax, 10
	call print_char
	mov ax, carriage_return
	call print_char

	mov si, sp
	sub bp, 2

	loop3:
		cmp si, bp
		je end_loop3
		mov ax, [si]
		call print_char
		add si, 2
		jmp loop3
	end_loop3:
	jmp end_prog

end_prog:
	jmp end_prog


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