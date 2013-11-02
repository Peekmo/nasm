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

print_hex:
	pusha	
	mov ebx, 0         ; Increment
	mov si, HEX_OUT	   ; Met la chaine dans si
	add si, HEX_LEN    ; Place le pointeur à la fin de la chaine
	mov byte [si], 13
	inc si
	mov byte [si], 10
	inc si
	mov byte [si], 0   ; Rajoute le caractère null à la fin de la chaine
	dec si
	dec si

.nexthex:
	mov cx, dx         ; Enregistre la valeur hexa dans une variable
	add ebx, 1         ; Incremente + 1
	cmp ebx, 4         ; Tant que pas plus grand que 4
	jg .endhex
	
	and cl, 0x000F     ; Masque en ET sur les 4 derniers bit
	cmp al,70		   ; Probleme quand F est lettre précédente on a un chiffre en plus
	je .deccl

	.backdec:
	cmp cl,10          ; Si plus petit que 10 -> offset de 48 sinon 55
	jl .offsetNumber
	jmp .offsetLetter	

	.nextOpe:
	dec si              ; On recule le pointeur d'un octet
	mov [si], cl        ; On met la valeur du caractère à cette position
	shr dx, 4           ; Décalage de bit de 4 vers la droite
	jmp .nexthex        

.deccl:
	dec cl
	jmp .backdec

.offsetNumber:
	add cl,48
	jmp .nextOpe

.offsetLetter:
	add cl,55
	jmp .nextOpe

.endhex:
	sub si, 2           ; Retour du pointeur au début de la chaine (Ox)
	mov bx, si			; Assigne la valeur de la chaine à bx pour print
	call print
	popa
	ret

