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


; Read untill the enter
read_kbd:
	call read_char
	cmp ax, carriage_return
	je end_read_kbd
	call print_char
	jmp read_kbd
end_read_kbd:

start:
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