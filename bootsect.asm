[BITS 16]      ; 16 bit code generation
[ORG 0x7C00]   ; Origin location

; Le boot ne fonctionne pas si ces instructions le précède
;mov bx, HELLO_MSG
;call print
;
;mov bx, GOODBYE_MSG
;call print
;
;mov dx, 0x1fb6
;call print_hex
;
;mov dx, 0x1ab0
;call print_hex

mov [BOOT_DRIVE], dl ; Storing default BIOS Boot_drive

mov bp, 0x8000
mov sp, bp

mov bx, 0x9000
mov dh, 5
mov dl, [BOOT_DRIVE]
call load_disk

mov dx, [0x9000]
call print_hex

mov dx, [0x9000 + 512]
call print_hex

jmp $

%include "functions.asm"
%include "load.asm"

; Data
BOOT_DRIVE: db 0
HELLO_MSG: db "Hello World !", 13, 10, 0
GOODBYE_MSG: db "Goodbye World !", 13, 10, 0

; End Matter
times 510-($-$$) db 0	; Fill the rest with zeros
dw 0xAA55		; Boot loader signature

; Adding data to other sectors
times 256 dw 0xAAAA ; sector 2
times 256 dw 0x4444 ; sector 3
