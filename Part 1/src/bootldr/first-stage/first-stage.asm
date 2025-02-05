bits 16
org 0x7c00

%define SECOND_STAGE_BASE			0x1000
%define SECOND_STAGE_STACK_BASE		(SECOND_STAGE_BASE)
%define SECOND_STAGE_LEN_IN_SECTORS	(((SECOND_STAGE_END - SECOND_STAGE_BEGIN + 511) & ~511) / 512)
%define FIRST_STAGE_LEN_IN_SECTORS	(((SECOND_STAGE_BEGIN - FIRST_STAGE_BEGIN + 511) & ~511) / 512)

FIRST_STAGE_BEGIN:
	jmp 0:rst_cs							; reset CS to 0
rst_cs:
	mov ax, 0								; reset DS, ES, FS, GS, SS to 0
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov bp, FIRST_STAGE_BEGIN				; set BP
	mov sp, FIRST_STAGE_BEGIN				; set SP
	sti										; enable hardware interrupts
	cld										; clear DF (direction flag)

	mov ax, 3								; set video mode to 80x25 text 16 colors
	int 0x10

	mov ah, 2								; read second stage
	mov al, SECOND_STAGE_LEN_IN_SECTORS
	mov cx, 2
	mov dh, 0
	mov bx, SECOND_STAGE_BASE
	int 0x13
	jc .err									; if CF (carry flag) is set => .err

	mov bp, SECOND_STAGE_STACK_BASE			; set BP & SP
	mov sp, SECOND_STAGE_STACK_BASE
	push edx								; push BIOS disk index
	push dword 0							; push return address
	jmp word [SECOND_STAGE_BASE]			; jump to second stage

.err:										; print error and stop execution
	mov si, err_msg
	call puts
	jmp $

puts:
	mov ah, 0x0e
.putc:
	lodsb
	test al, al
	jz .fin
	int 0x10
	jmp .putc
.fin:
	ret

err_msg: db "Error: failed to load second stage bootloader!", 0

times 446 - $ + $$ db 0
mbrptbl:									; MBR partition table
.p1:
	db 0x80
	db 0, 2, 0
	db 0x7f
	db 0, 2, 0
	dd FIRST_STAGE_LEN_IN_SECTORS
	dd SECOND_STAGE_LEN_IN_SECTORS
.p2: dq 0, 0
.p3: dq 0, 0
.p4: dq 0, 0

times 510 - $ + $$ db 0xEF
dw 0xaa55									; MBR signature
SECOND_STAGE_BEGIN:
incbin "bootldr-second-stage.bin"
SECOND_STAGE_END: