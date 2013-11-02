[bits 32]

VIDEO_MEMORY equ 0xb8500

print_pm:
	pusha	
	mov ecx, edx ; STRING
	mov ebx, ebx ; COULEUR
	mov edx, VIDEO_MEMORY	

print_loop:
	mov al, [ecx] ; caractère
	mov ah, bl   ; couleur dans le bit de poid faible
	; ax = caractère + couleur
	
	cmp al, 0
	je done

	mov [edx], ax ; Affichage du caractère à l'adresse mémoire
	add edx,2     ; +2 mémoire vidéo
	add ecx,1     ; caractère suivant
	jmp print_loop

done:
	popa
	ret
