[BITS 16]      ; 16 bit code generation
[ORG 0x7C00]   ; Origin location

mov bx, HELLO_MSG
call print

mov bx, GOODBYE_MSG
call print

mov dx, 0x1fb6
call print_hex

jmp $

%include "functions.asm"

; Data
HEX_OUT: db "0x000", 0
HEX_LEN equ $-HEX_OUT
HELLO_MSG: db "Hello World !", 13, 10, 0
GOODBYE_MSG: db "Goodbye World !", 13, 10, 0

; End Matter
times 510-($-$$) db 0	; Fill the rest with zeros
dw 0xAA55		; Boot loader signature
