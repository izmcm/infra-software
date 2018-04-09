;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;; Copyright (c) 2018 Caio Gomes and Izabella Melo.                       ;;
;; source: https://github.com/minimarvin/infra-software)                  ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;; This file is part of a open educatio politics to allow everyone learn  ;;
;; how to build a bootloader. It's hardly inspired by a template          ;;
;; published by the monitors of the discipline of software infrastructure ;;
;; in Federal University of Pernambuco in the course of Computers         ;;
;; Engineering.                                                           ;;
;;                                                                        ;;
;; This program is free software: you can redistribute it and/or modify   ;;
;; it under the terms of the GNU General Public License as published by   ;;
;; the Free Software Foundation, version 3.                               ;;
;;                                                                        ;;
;; This program is distributed in the hope that it will be useful, but    ;;
;; WITHOUT ANY WARRANTY; without even the implied warranty of             ;;
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU       ;;
;; General Public License for more details.                               ;;
;;                                                                        ;;
;; You should have received a copy of the GNU General Public License      ;;
;; along with this program. If not, see <http://www.gnu.org/licenses/>.   ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Defines                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
write_service equ 0x0e
read_service equ 0x00
pixel_service equ 0x0c ; Print a pixel in coordinates [dx, cx], bh = Page Number
background_service equ 0x0b
maxHeight equ 198
maxWidth equ 320

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Interruptions           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
write_int equ 0x10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Characters              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
space equ 0x20
endl equ 0x0A
carriage_return equ 0x0D


;; Figures defines
square_size equ 40
square_x equ 280
square_y equ 40


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BIOS color defines      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
black           equ   0x00
blue            equ   0x01
green           equ   0x02
cyan            equ   0x03
red             equ   0x04
magenta         equ   0x05
brown           equ   0x06
light_gray      equ   0x07
dark_gray       equ   0x08
light_blue      equ   0x09
light_green     equ   0x0A
light_cyan      equ   0x0B
light_red       equ   0x0C
light_magenta   equ   0x0D
yellow          equ   0x0E
white           equ   0x0F

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start Program           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
org 0x7e00

bits 16

jmp setup

setup:
	push bp
	mov bp, sp
	call clean_all
	jmp start

start:
	xor ax, ax
	mov ds, ax
	mov es, ax

	call set_video_mode
	
	
	mov [barY1], word 50
	mov [barY2], word 50

	mov al, white
	;; Draw the first bar
	mov dx, word [barX1]
	mov [objectX], dx
	mov dx, word [barY1]
	mov [objectY], dx
	mov dx, word [barHeight]
	mov [objectHeight], dx
	mov dx, word [barWidth]
	mov [objectWidth], dx
	call draw_rectangle

	;; Draw the second bar
	mov dx, word [barX2]
	mov [objectX], dx
	mov dx, word [barY2]
	mov [objectY], dx
	mov dx, word [barHeight]
	mov [objectHeight], dx
	mov dx, word [barWidth]
	mov [objectWidth], dx
	call draw_rectangle

	;; Draw the ball
	mov dx, word [ballX]
	mov [objectX], dx
	mov dx, word [ballY]
	mov [objectY], dx
	mov dx, word [ballSize]
	mov [objectHeight], dx
	mov dx, word [ballSize]
	mov [objectWidth], dx
	call draw_rectangle

	;; Setup the color and the page
	; mov bh, 0
	; mov bl, light_green

	; mov si, hello
	; call print_data_seg


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Subrountines            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_loop:
	;; Must draw every rectangle in the screen
	;; pass the function params in the stack and use a register to store the 
	;; return addres

	

done:
	jmp $



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Subrountines            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_char:
	mov ah, read_service ;Número da chamada.
	int 16h ; Put the char in AL
	xor ah, ah
	ret

print_char:
	;; In video mode, move to bh the number of the page
	;; and to bl the value of the color
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

set_video_mode:
	mov ax, 0x13
	int 0x10
	ret

clean_all:
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw the figures        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
draw_rectangle:
	
	;; Uses all the four registers
	;; Move to the global variables objectX, objectY, objectHeight, objectWidth
	;; The dimensions of the rectangle wanted
	xor dx, dx
	xor cx, cx
	xor bx, bx

	mov ah, pixel_service
	;; Size of the rectangle
	mov cx, word [objectX]
	mov dx, word [objectY]
	
	;; Put in the center of the screen
	add cx, word [objectWidth]
	add dx, word [objectHeight]

	draw_rectangle_loop:
		dec cx
		cmp cx, word [objectX]

		je partial_draw_rectangle_loop
		
		int 10h
		jmp draw_rectangle_loop
		partial_draw_rectangle_loop:
			;; Reposition the cursor of X
			mov cx, word [objectX]
			add cx, word [objectWidth]

			mov si, dx
			; call print_num

			dec dx
			cmp dx, word [objectY]
			jle end_draw_rectangle_loop
			jmp draw_rectangle_loop
	end_draw_rectangle_loop:
	ret

;; Store at si the value to print
print_num:
	push ax
	push bx
	push cx
	push dx
	mov bp, sp

	mov ax, si
	mov si, sp
	call int_to_char
	call print_si_to_sp

	mov sp, bp
	pop dx
	pop cx
	pop bx
	pop ax
	ret

;; Put the integer in cx and we use all the 4 registers
;; Must store in si the top of the stack
;; mov to ax the value you want to store
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

setup_div:
	xor ax, ax
	xor dx, dx
	mov ax, cx
	ret

;; We use the reg cx and bx
print_si_to_sp:
	;; Setup the color and the page
	mov bh, 0
	mov bl, light_green
	
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Messages                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
msg1: dw 'Testing the kernel...', carriage_return, endl, 0
hello: dw 'Hello Izabella I am trying to print in the video mode!', carriage_return, endl, 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global Variables        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
objectWidth: dw 0
objectHeight: dw 0
objectX: dw 0
objectY: dw 0

barY1: dw 0
barX1: dw 0
barY2: dw 0
barX2: dw 300
barHeight: dw 60
barWidth: dw 10

ballX: dw 150
ballY: dw 94
ballSize: dw 10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Boot Signature          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exit:
	times 510-($-$$) dw 0 ;512 bytes
	dw 0xaa55             ;assinatura