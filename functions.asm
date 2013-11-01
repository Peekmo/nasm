[BITS 16]      ; 16 bit code generation
[ORG 0x7C00]   ; Origin location

mov bx, HELLO_MSG
call print

mov bx, GOODBYE_MSG
call print

jmp $

print:
	pusha
	mov si, bx 

.line:
	mov al, [si]
	inc si
	cmp al, 0
	je .end
	mov ah, 0x0E
	int 0x10
	inc dl 
	jmp .line

.end:
	popa
	ret

; Data
HELLO_MSG: db "Hello World !", 13, 10, 0
GOODBYE_MSG: db "Goodbye World !", 13, 10, 0

; End Matter
times 510-($-$$) db 0	; Fill the rest with zeros
dw 0xAA55		; Boot loader signature
