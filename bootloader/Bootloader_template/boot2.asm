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

jmp start
start: 
	mov si, msg1
	call print_data_seg
	mov si, msg2
	call print_data_seg
	mov si, msg3
	call print_data_seg
	mov si, msg4
	call print_data_seg

end:
	jmp 0x7e00


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



;; Messages
msg1: db 'Loading structures for the kernel...', carriage_return, endl, 0
msg2: db 'Setting up protected mode...', carriage_return, endl, 0
msg3: db 'Loading kernel in memory...', carriage_return, endl, 0
msg4: db 'Running kernel...', carriage_return, endl, 0

	
exit:
	times 510-($-$$) db 0 ;512 bytes
	dw 0xaa55             ;assinatura