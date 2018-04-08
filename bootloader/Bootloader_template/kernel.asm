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

jmp start

start:
	xor ax, ax
	mov ds, ax
	mov es, ax

	call set_video_mode
	
	mov ax, green
	mov si, objectX
	mov [si], 0
	mov si, objectY
	mov [si], 0
	mov si, objectHeight
	mov [si], 100
	mov si, objectWidth
	mov [si], 200
	call draw_square

	;; Setup the color and the page
	mov bh, 0
	mov bl, light_green

	mov si, hello
	call print_data_seg


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
	mov si, objectWidth
	mov cx, [si]
	mov si, objectHeight
	mov dx, [si]
	
	;; Put in the center of the screen
	mov si, objectX
	add cx, [si]
	mov si, objectY
	add dx, [si]

	draw_rectangle_loop:
		dec cx
		mov si, objectX
		cmp cx, [si]
		je partial_draw_rectangle_loop
		
		int 10h
		jmp draw_rectangle_loop
		partial_draw_rectangle_loop:
			mov cx, square_size 
			add cx, square_x

			dec dx
			mov si, objectY
			cmp dx, [si]
			je end_draw_rectangle_loop
			jmp draw_rectangle_loop
	end_draw_rectangle_loop:
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Messages                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
msg1: db 'Testing the kernel...', carriage_return, endl, 0
hello: db 'Hello Izabella I am trying to print in the video mode!', carriage_return, endl, 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global Variables        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
objectWidth: db 0
objectHeight: db 0
objectX: db 0
objectY: db 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Boot Signature          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exit:
	times 510-($-$$) db 0 ;512 bytes
	dw 0xaa55             ;assinatura