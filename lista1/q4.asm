;; TODO: put the characters in a memory region and put the 
;; numbers in the stack
;; TODO: Make the sequence stop when the user types a number
;; lower than 1000 or bigger than 9999


;; Defines
carriage_return equ 0Dh
write_service equ 0x0e
read_service equ 0x00

;; Characters
space equ 0x20

;; Program start
org 0x7c00               ; BIOS loads at this address

bits 16                   ; 16 bits real mode

; Print a welcome message.
; We have no DOS nor Linux kernel here.
; Therefore, we will use bios int 0x10.

setup:
	mov ax, '*'
	push ax
	mov bp, sp
	mov si, number_word
	
	;; Clean all regs
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx,dx


; Read untill the enter
read_kbd:
	call read_char
	cmp ax, carriage_return
	je end_read_kbd
	
	convert_in_int:
		call verify_if_num
		cmp ah, 0
		je next_num

		;; Convert from char to int
		mov ah, 0
		mov [si], ax
		add si, 2

		;; Multiply the number by 10
		mov cx, 9
		mov dx, bx
		loop_convert_in_int:
			cmp cx, 0
			je end_loop_convert_in_int

			add bx, dx
			dec cx
			jmp loop_convert_in_int
			end_loop_convert_in_int:

		;; Put the new value to be used
		mov cx, ax
		sub cx, '0'

		add bx, cx
		jmp end_convert_in_int

		;; In a non decimal character, store the actual number in the stack
		next_num:
			push bx
			xor bx, bx
			jmp end_convert_in_int
	end_convert_in_int:

	call print_char
	jmp read_kbd
end_read_kbd:
	push bx
	xor bx, bx


start:
	
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

	jmp end_prog


	;; TODO: Debug this algorithm
	; next_print_all:
	; 	mov ax, 10
	; 	call print_char
	; 	mov ax, carriage_return
	; 	call print_char

	; 	mov si, number_word

	; 	loop4:
	; 		lodsb
	; 		cmp al, 0
	; 		je end_loop4
	; 		; mov ax, [si]
	; 		call print_char
	; 		; add si, 2
	; 		jmp loop4
	; 	end_loop4:
	; 	jmp end_prog

	; jmp end_prog

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

;; Must put the data seg in SI and finish with 0
print_data_seg:
	loop_print_data_seg:
		lodsb
		cmp al, 0
		je end_print_data_seg
		
		call print_char
		jmp loop_print_data_seg
	end_print_data_seg:
		ret

verify_if_num:
	mov dx, 0
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Data segment            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
property: db "Propriedade do 3025!", 0
non_property: db "Numero comum", 0

number_word: times 100 db 0

;----------------------------------------------;
; Bootloader signature must be located
; at bytes #511 and #512.
; Fill with 0 in between.
; $  = address of the current line
; $$ = address of the 1st instruction
;----------------------------------------------;

times 510 - ($-$$) db 0
dw        0xaa55