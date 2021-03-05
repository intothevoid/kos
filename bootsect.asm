BITS 16

start:
	mov ax, 0x07C0		; Set up 4k stack space
	add ax, 288
	mov ss, ax
	mov sp, 4096

	mov ax, 0x7C0		; Set data segment to point where we're loaded
	mov ds, ax

	mov si, text_string
	call print_string
	
	jmp $			; Infinite jump, we don't want to execute line text_string...

	text_string db 'Hello, world of kos!', 0

print_string:
	mov ah, 0x0e		; BIOS teletype routine location

.repeat:
	lodsb			; Load string byte, get char from string, incremement si each time
	cmp al, 0
	je .done
	int 0x10		; Interrupt execution and jump to location 0x10 which contains print char routine
	jmp .repeat

.done:
	ret			; Return to call site, pop address off stack and place into IP

	times 510-($-$$) db 0	; 512 KB, nop out remaining bytes
	dw 0xaa55		; Boot marker
