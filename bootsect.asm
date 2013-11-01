[BITS 16]  ; indique a nasm que l'on travaille en 16 bits
[ORG 0x0]

; initialisation des segments en 0x07C00
    mov ax, 0x07C0
    mov ds, ax
    mov es, ax
    mov ax, 0x8000
    mov ss, ax
    mov sp, 0xf000    ; stack de 0x8F000 -> 0x80000

	call start

end:
	jmp end

;--- Variables ---
	os1: db "================================", 13
	os2: db "============ MoonOS ============", 13
	os3: db "================================", 13, 13
    init: db "Initialization", 13
    loading: db "Loading....", 13
    login: db "Login", 13, 0
;-----------------

start:
    push ax
	push bx
	mov si, os1
	mov ah, 0x02
	mov dh, 0x08
    mov cx, 1
.debut:
    mov al, [si] 
    cmp al, 0     ; fin chaine ?
    jz .fin

	cmp al, 13    ; retour à la ligne ?
    je .newLine

.line:
    mov ah, 0x02  
    int 0x10
    mov ah, 0x0A
    int 0x10
	inc si
	inc dl
    jmp .debut

.fin:
	pop bx
    pop ax
    ret

.newLine:
    inc dh
	inc si
	xor dl, dl
	jmp .debut

;--- NOP jusqu'a 510 ---
    times 510-($-$$) db 144
    dw 0xAA55
