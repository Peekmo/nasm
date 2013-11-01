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
   	mov si, os1
	call show
	call input

input:
	mov ah, 0x02
    mov cx, 1
.wait:
	mov ah, 0x01
	int 0x16
	jz .wait
	
	mov ah, 0x00
	int 0x16
	mov [si], al
	inc si
	cmp al, 13
	je .endWait	
	
	mov ah, 0x0A
	int 0x10
	inc dl
	mov ah, 0x02
	int 0x10
	jmp .wait

.endWait:
	inc dh
	xor dl, dl
	mov ah, 0x02
	int 0x10
	mov byte [si], 0
	call show
	ret

show:
	push ax
	push bx
	push cx
	push dx

	mov ah, 0x03
	int 0x10
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
	pop dx
	pop cx
	pop bx
	pop ax

	inc dh
    ret

.newLine:
    inc dh
	inc si
	xor dl, dl
	jmp .debut

;--- NOP jusqu'a 510 ---
    times 510-($-$$) db 144
    dw 0xAA55
