bits 16

global ttyputc
ttyputc:
	push ax
	push bx
	
	mov bx, sp
	mov ah, 0x0e	; function 0x0e (print symbol)
	mov al, [bx+8]	; symbol (read from the stack and write to al)
	int 0x10		; 0x10th BIOS service (tty)

	pop bx
	pop ax
	retd