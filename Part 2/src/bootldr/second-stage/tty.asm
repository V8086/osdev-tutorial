bits 16

global ttyputc
ttyputc:
	push ax
	push bx
	
	mov bx, sp
	mov ah, 0x0e	; функция 0x0e (вывод символа)
	mov al, [bx+8]	; символ (читаем из стека и записываем в al)
	int 0x10		; 0x10-ый сервис BIOS (tty)

	pop bx
	pop ax
	retd