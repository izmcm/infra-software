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
	call clean_all
	push ax ;; Generate a reserved memory region for anything may occurr
	mov bp, sp

; Read untill the enter
read_kbd:
	call read_char
	cmp ax, carriage_return
	je end_read_kbd

	;; Add element to stack
	push ax

	call verify_if_num
	cmp ah, 1
	je convert_in_int
	jmp end_convert_in_int


	convert_in_int:
		mov ah, 0
		;; Concat the numbers
		push ax ;; Save the char for writeing it
		mov ax, bx
		imul ax, ax, 10
		pop bx
		sub bx, '0' ;; Convert char in int
		add bx, ax
	end_convert_in_int:

	pop ax ;; Retrieve to print
	call print_char
	jmp read_kbd
end_read_kbd:
	call new_line

	push bx ;; Record the data in the stack
	cmp cx, 2
	je finish_read_kbd
	inc cx
	jmp read_kbd
finish_read_kbd:

start:
	call clean_all
	pop ax
	call print_char
	pop ax
	call print_char
	pop ax
	call print_char
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

clean_all:
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	ret

verify_if_num:
	cmp al, '9'
	jle next_step_verify_if_num
	
	mov ah, 0
	jmp end_verify_if_num
	
	next_step_verify_if_num:
		cmp al, '0'
		jge true_verify_if_num
		
		mov ah, 0
		jmp end_verify_if_num

		true_verify_if_num:
			mov ah, 1
			jmp end_verify_if_num


	end_verify_if_num:
		ret

new_line:
	mov ax, 10
	call print_char
	mov ax, carriage_return
	call print_char
	ret

msg: db "Hello, World!", 0
isoceles db "isoceles", 0
equilatero db "equilatero", 0
escaleno db "escaleno", 0
nonTriangle db "Não forma triangulo", 0


;----------------------------------------------;
; Bootloader signature must be located
; at bytes #511 and #512.
; Fill with 0 in between.
; $  = address of the current line
; $$ = address of the 1st instruction
;----------------------------------------------;

times 510 - ($-$$) db 0
dw        0xaa55