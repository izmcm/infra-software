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
carriage_return equ 0Dh
write_service equ 0x0e
read_service equ 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Characters              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
space equ 0x20
endl equ 0x0A


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start Program           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
org 0x500

bits 16                   ; 16 bits real mode

jmp 0x0000:start
start:
	xor ax, ax
	mov ds, ax
	mov es, ax

	mov ax, 0x7e0 ;0x50<<1 = 0x7e00 (início de kernel.asm)
    mov es, ax
    xor bx, bx   ;posição = es<<1+bx

	mov si, msg1
	call print_data_seg
	mov dx, 2000
	call delay

	mov si, msg2
	call print_data_seg
	mov dx, 2000
	call delay

	mov si, msg3
	call print_data_seg
	mov dx, 2000
	call delay

	mov si, msg4
	call print_data_seg
	mov dx, 3000
	call delay

	jmp load_kernel

load_kernel:
    mov ah, 02h ;lê um setor do disco
    mov al, 20  ;quantidade de setores ocupados pelo boot2
    mov ch, 0   ;track 0
    mov cl, 3   ;sector 2
    mov dh, 0   ;head 0
    mov dl, 0   ;drive 0
    int 13h

    jc load_kernel     ;se o acesso falhar, tenta novamente

    jmp 0x7e00   ;pula para o setor de endereco 0x500 (start do boot2)

end:
	jmp $


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

delay:
	mov bp, dx
	back:
		dec bp
		cmp bp, 0
		jnz back

		dec dx
		cmp dx,0
		jnz back
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Messages                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
msg1: db 'Loading structures for the kernel...', carriage_return, endl, 0
msg2: db 'Setting up protected mode...', carriage_return, endl, 0
msg3: db 'Loading kernel in memory...', carriage_return, endl, 0
msg4: db 'Running kernel...', carriage_return, endl, 0


exit:
	times 510-($-$$) db 0 ;512 bytes
	dw 0xaa55             ;assinatura
