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
read_service_unblocking equ 0x01
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
up equ 38
down equ 40

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
	jmp game_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Subrountines            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_loop:
	;; Must draw every rectangle in the screen
	;; pass the function params in the stack and use a register to store the
	;; return addres
	call print_board

	;; Read keyboard unblocking
	call read_char_unblocking
	jnz processchar

	mov dx, word [timer]
	inc dx
	mov word [timer], dx
	cmp word [timer], 50
	je time_out

	jmp game_loop

	time_out:
		call update_ball

	;;
	compare_x_with_bar1:
	 	mov dx, [barX1]
	 	add dx, [barWidth]
	 	cmp [ballX], dx
	 	jle compare_y1_with_bar1
		jg compare_x_with_bar2

	compare_y1_with_bar1:
		mov dx, [barY1]
	 	cmp [ballY], dx
	 	jge compare_y2_with_bar1
		jl compare_x_with_bar2

	compare_y2_with_bar1:
	 	mov dx, [barY1]
		add dx, [barHeight]
	 	cmp [ballY], dx
	 	jle update_flag_x_for_right
		jg compare_x_with_bar2

	update_flag_x_for_right:
	 	mov word [flag_ball_x], 5

	;;
	compare_x_with_bar2:
	 	mov dx, [barX2]
		sub dx, [barWidth]
	 	cmp [ballX], dx
	 	jge compare_y1_with_bar2
		jl processchar

	compare_y1_with_bar2:
		mov dx, [barY2]
	 	cmp [ballY], dx
	 	jge compare_y2_with_bar2
		jl processchar

	compare_y2_with_bar2:
	 	mov dx, [barY2]
		add dx, [barHeight]
	 	cmp [ballY], dx
	 	jle update_flag_x_for_left
		jg processchar

	update_flag_x_for_left:
	 	mov word [flag_ball_x], -5

	processchar:
		cmp al, 's'
		je down_bar_1

		cmp al, 'w'
		je up_bar_1

		cmp al, 'i'
		je up_bar_2

		cmp al, 'k'
		je down_bar_2

	jmp game_loop

	down_bar_1:
		mov dx, maxHeight
		sub dx, [barHeight]
		cmp [barY1], dx
		jge game_loop

		call delete_board
		mov dx, [barY1]
		add dx, 10
		mov [barY1], dx
		jmp game_loop

	up_bar_1:
		mov dx, [barY1]
		cmp dx, 0
		je game_loop

		call delete_board
		mov dx, [barY1]
		sub dx, 10
		mov [barY1], dx
		jmp game_loop

	up_bar_2:
		mov dx, [barY2]
		cmp dx, 0
		je game_loop

		call delete_board
		mov dx, [barY2]
		sub dx, 10
		mov [barY2], dx
		jmp game_loop

	down_bar_2:
		mov dx, maxHeight
		sub dx, [barHeight]
		cmp [barY2], dx
		jge game_loop

		call delete_board
		mov dx, [barY2]
		add dx, 10
		mov [barY2], dx
		jmp game_loop

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

read_char_unblocking:
	;; If something in the buffer them read the char
	;; otherwise, there is no data to read
	mov ah, read_service_unblocking ;Número da chamada.
	int 16h ; Put the char in AL
	jz read_char_unblocking_done
	mov ah, read_service
	int 16h
	read_char_unblocking_done:
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

update_ball:
	mov al, black
	call print_ball

	mov word [timer], 0

	mov dx, [ballX]
	add dx, [flag_ball_x]
	mov [ballX], dx

	mov dx, [ballY]
	add dx, [flag_ball_y]
	mov [ballY], dx

	mov al, white
	call print_ball
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

print_board:
	mov al, white
	call print_game_elements
	ret

delete_board:
	mov al, black
	call print_game_elements
	ret

print_game_elements:
	call print_bar_1
	call print_bar_2
	call print_ball
	ret

print_bar_1:
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
	ret

print_bar_2:
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
	ret

print_ball:
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
	ret

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

timer: dw 0

flag_ball_x: dw -5
flag_ball_y: dw 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Boot Signature          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exit:
	;times 510-($-$$) dw 0 ;512 bytes
	dw 0xaa55             ;assinatura
