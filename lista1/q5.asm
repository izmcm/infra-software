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
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx

start:
	mov cx, 1
	loop_print:
		cmp cx, 101
		je end_loop_print
		
		
		;; Divisible by 15
		divide_by_15:
			call setup_div	
			mov bx, 15
			div bx
			cmp dx, 0
			jne divide_by_5
			mov si, fizzbuzz
			call print_data_seg
			jmp after_divide
		divide_by_5:
			call setup_div	
			mov bx, 5
			div bx
			cmp dx, 0
			jne divide_by_3
			mov si, buzz
			call print_data_seg
			jmp after_divide
		divide_by_3:
			call setup_div	
			mov bx, 3
			div bx
			cmp dx, 0
			jne divide_by_none
			mov si, fizz
			call print_data_seg
			jmp after_divide
		divide_by_none:
			mov ax, cx
			mov dx, 0
			mov bx, 10
			mov si, sp
			loop_divisor: ;; Insert every char in the last byte
				div bx

				add dx, '0' ;; Convert num to char
				push dx

				cmp ax, 0
				je end_loop_divisor
				xor dx, dx
				jmp loop_divisor
			end_loop_divisor:
			loop_printer: ;; Remove every char in the stack untill si
				pop ax
				call print_char
				cmp si, sp
				je end_loop_printer
				jmp loop_printer
			end_loop_printer:
			
		after_divide:
		mov ax, 10
		call print_char
		mov ax, carriage_return
		call print_char
		inc cx
		jmp loop_print
	end_loop_print:
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

setup_div:
	xor ax, ax
	xor dx, dx
	mov ax, cx
	ret

;; We use the reg cx
print_si_to_sp:
	mov cx, si
	loop_print_si_to_sp:
		cmp si, sp
		je end_loop_print_si_to_sp
		mov ax, [si]
		call print_char
		dec si
		jmp loop_print_si_to_sp
	end_loop_print_si_to_sp:
	mov si, cx
	;; Reset the sp
	mov sp, si
	ret

;; Put the integer in cx and we use all the 4 registers
;; Must store in si the top of the stack
int_to_char:
	call setup_div
	;; Store the return value
	pop cx
	mov bx, 10
	convert_int_to_char:
		div bx
		add dx, '0'
		push dx
		je end_convert_int_to_char
		jmp convert_int_to_char
	end_convert_int_to_char:
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

msg: db "Hello, World!", 0
fizz: db "fizz", 0
buzz: db "buzz", 0
fizzbuzz: db "fizzbuzz", 0

;----------------------------------------------;
; Bootloader signature must be located
; at bytes #511 and #512.
; Fill with 0 in between.
; $  = address of the current line
; $$ = address of the 1st instruction
;----------------------------------------------;

times 510 - ($-$$) db 0
dw        0xaa55