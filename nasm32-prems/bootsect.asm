[BITS 16]      ; 16 bit code generation
[ORG 0x7C00]   ; Origin location

cli             ; Plus interrupt
lgdt [gdt_descriptor] ; Load GDT

mov eax, cr0  ; set cr0 to 1 
or eax, 0x1   ; Ne peut pas être fait directement
mov cr0, eax  ; Nécessite de passer par un registre

jmp CODE_SEG:init_pmod

%include "gdt.asm"
%include "print32.asm"

[bits 32]

; init protected mod
init_pmod:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; Stack
	mov ebp, 0x90000
	mov esp, ebp
	
	mov edx, ANGELE
	mov ebx, ROUGE
	call print_pm

end:
	jmp end

ANGELE db "Je boot !!", 0
JAUNE equ 00001110b
BLEU  equ 00001001b
VERT  equ 00001010b
CYAN  equ 00001011b
ROUGE equ 00001100b
ROSE  equ 00001101b
BLANC equ 00001111b

	
; End Matter
times 510-($-$$) db 0	; Fill the rest with zeros
dw 0xAA55		; Boot loader signature


