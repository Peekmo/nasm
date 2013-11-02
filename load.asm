load_disk:
	push dx

	mov ah, 0x02  ; BIOS read sector function
	mov al, dh
	mov ch, 0x00  ; 1st cylinder
	mov dh, 0x00  ; 1st head
	mov cl, 0x02  ; From 2nd sector
	int 0x13      ; Interruption

	jc error_disk ; If carry flag

	pop dx
	cmp dh, al    ; If !read all sector expected
	jne error_disk
	ret

error_disk:
	mov bx, ERROR_DISK_MSG
	call print
	jmp $

ERROR_DISK_MSG db "Error to read the disk.", 13, 10, 0
