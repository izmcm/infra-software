;; Instructions defines
carriage_return equ 0Dh
write_service equ 0x0e
read_service equ 0x00
pixel_service equ 0x0c ; Print a pixel in coordinates [dx, cx], bh = Page Number
background_service equ 0x0b

;; BIOS color defines
green equ 0x02
blue equ 0x01
red equ 0x04
cyan equ 0x03
magenta equ 0x05
yellow equ 0x0e

;; Figures defines
square_size equ 40
square_x equ 80
square_y equ 80
triangle_size equ 40
triangle_x equ 80
triangle_y equ 80

trapezium_square_size equ 40
trapezium_square_x equ 80
trapezium_square_y equ 80
trapezium_triangle_size equ 40
trapezium_triangle_x equ 80
trapezium_triangle_y equ 80

;; Program start
org 0x7c00               ; BIOS loads at this address

bits 16                   ; 16 bits real mode

; Print a welcome message.
; We have no DOS nor Linux kernel here.
; Therefore, we will use bios int 0x10.

;; Setup the registers
setup:
	mov bp, sp
	push sp
	xor cx, cx
	

	; mov AH, 0xb ;Número da chamada
	; mov BH, 0 ;ID da paleta de cores
	; mov BL, 4 ;Cor desejada (vermelho)
	; int 10h


; Read untill the enter
read_kbd:
	call read_char
	
	;; Push to the stack the user values
	cmp cx, 3
	je not_increment
		push ax
		inc cx
	not_increment:

	;; Compare to the end of the line
	cmp ax, carriage_return
	je end_read_kbd
	call print_char
	jmp read_kbd
end_read_kbd:

start:
	retrieve_info:
		xor cx, cx
		xor bx, bx
		pop bx ;; Put the geometric form value
		pop cx ;; Trash
		pop cx ;; Put the color here

	setup_color:
		cmp cx, 'r'
		je set_red
		cmp cx, 'g'
		je set_green
		cmp cx, 'b'
		je set_blue
		cmp cx, 'y'
		je set_yellow
		cmp cx, 'm'
		je set_magenta
		cmp cx, 'c'
		je set_cyan
		
		end_setup_color:
			mov ax, cx
			call print_char

	define_figure:
		cmp bx, 'q'
		je draw_square
		cmp bx, 't'
		je draw_triangle
		cmp bx, 'T'
		je draw_Trapezium

		end_draw_figure:
			mov ax, bx
			call print_char

	jmp end_prog

end_prog:
	jmp end_prog
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Define the colors       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_red:
	mov al, red
	jmp end_setup_color
set_green:
	mov al, green
	jmp end_setup_color
set_blue:
	mov al, blue
	jmp end_setup_color
set_cyan:
	mov al, cyan
	jmp end_setup_color
set_yellow:
	mov al, yellow
	jmp end_setup_color
set_magenta:
	mov al, magenta
	jmp end_setup_color



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw the figures        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
draw_square:
	xor dx, dx
	xor cx, cx
	xor bx, bx

	push ax
	mov ax, 0x13
	int 0x10
	pop ax

	mov ah, pixel_service
	;; Size of the rectangle
	mov cx, square_size
	mov dx, square_size
	
	;; Put in the center of the screen
	add cx, square_x
	add dx, square_y

	draw_square_loop:
		dec cx
		cmp cx, square_x
		je partial_draw_square_loop
		
		int 10h
		jmp draw_square_loop
		partial_draw_square_loop:
			mov cx, square_size 
			add cx, square_x

			dec dx
			cmp dx, square_y
			je end_draw_square_loop
			jmp draw_square_loop
	end_draw_square_loop:


	jmp end_draw_figure

draw_triangle:
	xor dx, dx
	xor cx, cx
	xor bx, bx


	push ax
	mov ax, 0x13
	int 0x10
	pop ax

	mov ah, pixel_service
	;; Size of the rectangle
	mov cx, triangle_size
	mov dx, triangle_size
	
	;; Put in the center of the screen
	add cx, triangle_x
	add dx, triangle_y

	draw_triangle_loop:
		dec cx
		cmp cx, triangle_x
		je partial_draw_triangle_loop
		
		int 10h
		jmp draw_triangle_loop
		partial_draw_triangle_loop:
			mov cx, dx 
			sub cx, triangle_y
			add cx, triangle_x

			dec dx
			cmp dx, triangle_y
			je end_draw_triangle_loop
			jmp draw_triangle_loop
	end_draw_triangle_loop:

	jmp end_draw_figure

draw_Trapezium:
	xor dx, dx
	xor cx, cx
	xor bx, bx

	push ax
	mov ax, 0x13
	int 0x10
	pop ax



	mov ah, pixel_service
	;; Size of the rectangle
	mov cx, trapezium_square_size
	mov dx, trapezium_square_size
	
	;; Put in the center of the screen
	add cx, trapezium_square_x
	add dx, trapezium_square_y

	draw_trapezium_square_loop:
		dec cx
		cmp cx, trapezium_square_x
		je partial_draw_trapezium_square_loop
		
		int 10h
		jmp draw_trapezium_square_loop
		partial_draw_trapezium_square_loop:
			mov cx, trapezium_square_size 
			add cx, trapezium_square_x

			dec dx
			cmp dx, trapezium_square_y
			je end_draw_trapezium_square_loop
			jmp draw_trapezium_square_loop
	end_draw_trapezium_square_loop:




	mov ah, pixel_service
	;; Size of the rectangle
	mov cx, trapezium_triangle_size
	mov dx, trapezium_triangle_size
	
	;; Put in the center of the screen
	add cx, trapezium_triangle_x
	add cx, trapezium_square_size
	add dx, trapezium_triangle_y

	draw_trapezium_triangle_loop:
		dec cx
		cmp cx, trapezium_triangle_x
		je partial_draw_trapezium_triangle_loop
		
		int 10h
		jmp draw_trapezium_triangle_loop
		partial_draw_trapezium_triangle_loop:
			mov cx, dx 
			sub cx, trapezium_triangle_y
			add cx, trapezium_triangle_x
			add cx, trapezium_square_size

			dec dx
			cmp dx, trapezium_triangle_y
			je end_draw_trapezium_triangle_loop
			jmp draw_trapezium_triangle_loop
	end_draw_trapezium_triangle_loop:





	jmp end_draw_figure

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