; Descriptor CONFIG
gdt_start:

gdt_null: 		; Initialization null
	dd 0x0
	dd 0x0

gdt_cs:
	dw 0xFFFF    ; Limit
	dw 0x0000    ; Base
	db 0x0000	 ; Base 23:16
	db 10011011b
	db 11011111b
	db 0x0000

gdt_ds:
	dw 0xFFFF    ; Limit
	dw 0x0000    ; Base
	db 0x0000	 ; Base 23:16
	db 10010011b
	db 11011111b
	db 0x0000

gdt_end:         ; Pour avoir la taille du GDT

gdt_descriptor:
	dw gdt_end - gdt_start - 1 ; GDT size
	dd gdt_start

; Constants to get address of gdt
CODE_SEG equ gdt_cs - gdt_start
DATA_SEG equ gdt_ds - gdt_start

