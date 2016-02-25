; Linux 32-bit assembly

;predefined

sys_exit	equ	1;
sys_read	  equ	3;
sys_write	equ	4
stdin	equ	0
stdout	equ	1
stderr	equ	3


SECTION .data
string: db "This program incrypts and decrypts a string."
string_len equ	$-string

newline: db 0Ah
newline_len equ $-newline

key: db "R@ndOm<EY!SrAnD#m!XxVQrzHl,l;"
key_len:	equ	$-key



i: dd 0

SECTION .bss

SECTION .text

global _main

_main:


	mov ecx, string
	mov edx, string_len
	call _display
	mov ecx, newline
	mov edx, newline_len
	call _display

	call _addto
	call _flip
	call _encode
	call _redshift

	mov ecx, string
	mov edx, string_len
	call _display
	mov ecx, newline
	mov edx, newline_len
	call _display

	call _blueshift
	call _encode
	call _flip
	call _subfrom

	mov ecx, string
	mov edx, string_len
	call _display
	mov ecx, newline
	mov edx, newline_len
	call _display

	jmp _exit

_display:
	mov eax, sys_write
	mov ebx, stdout
	int	80h
	ret

_addto:
	xor ecx, ecx
	mov ecx, string_len
	xor eax, eax
	mov [i], eax

	adderloop:
	mov ebx, [i]
	mov al, [string + ebx]

	add al, bl

	mov [string + ebx], al

	mov edx, [i]    ;move the value of i to edx
	inc edx         ;increment the value in edx by 1
	mov [i], edx

	dec ecx
	jne adderloop
	ret

_subfrom:
	xor ecx, ecx
	mov ecx, string_len
	xor eax, eax
	mov [i], eax

	subloop:
	mov ebx, [i]
	mov al, [string + ebx]

	sub al, bl

	mov [string + ebx], al

	mov edx, [i]    ;move the value of i to edx
	inc edx         ;increment the value in edx by 1
	mov [i], edx

	dec ecx
	jne subloop
	ret


_redshift:
	xor ecx, ecx
	mov ecx, string_len
	xor eax, eax
	mov [i], eax

	redloop:
	push ecx
	mov ebx, [i]
	mov al, [string + ebx]
	mov cl, [i]
	ror al, cl
	mov [string + ebx], al

	mov edx, [i]    ;move the value of i to edx
	inc edx         ;increment the value in edx by 1
	mov [i], edx

	pop ecx
	dec ecx
	jne redloop
	ret


_blueshift:
	xor ecx, ecx
	mov ecx, string_len
	xor eax, eax
	mov [i], eax

	blueloop:
	push ecx
	mov ebx, [i]
	mov al, [string + ebx]
	mov cl, [i]
	rol al, cl
	mov [string + ebx], al

	mov edx, [i]    ;move the value of i to edx
	inc edx         ;increment the value in edx by 1
	mov [i], edx

	pop ecx
	dec ecx
	jne blueloop
	ret

_encode:
	mov ecx, string_len
	mov eax, 0
	mov [i], eax

	encode_loop:

	mov eax, key_len
	mov ebx, [i]
	xor edx, edx
	add ebx, key_len
	div ebx

	mov ebx, [key + edx]
	mov edx, [i]
	mov eax, [string + edx]

	xor eax, ebx

	mov [string + edx], eax

	mov edx, [i]    ;move the value of i to edx
	inc edx         ;increment the value in edx by 1
	mov [i], edx

	dec ecx
	jne encode_loop
	ret

_flip:       ;set destination for loop

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	mov eax, string_len
	mov ebx, 2
	div ebx
	mov ecx, eax
	mov eax, 0
	mov [i], eax

	flip_loop:
	;calculate the location in the array to move too.
	mov al, [i]                ;move the vlaue in i to
	mov edx, 1    ;move the size of a dword to edx
	mul edx                     ;multiply the value in eax (i) by the size of a dword

	;move edx and ebx to swap locations in array
	mov dl, al                            ;move the value of eax to edx
	mov bl, string_len - 1    ;move the location of the last element in the array to ebx
	sub bl, al                            ;subtract eax from ebx

	;swap array locations
	mov al, [string + edx]  ;move the value of the array (start location + edx) to eax
	xchg al, [string + ebx] ;swap the vlaue of the array (start location + ebx) with eax
	xchg al, [string + edx] ;swap the vlaue of the array (start location + edx) with eax

	;increment i by 1
	mov edx, [i]    ;move the value of i to edx
	inc edx         ;increment the value in edx by 1
	mov [i], edx    ;move the value in edx to i

	;decrement loop counter and continue
	dec ecx     ;decrement the value in ecx by 1
	jne flip_loop    ;compare ecx to 0 and jump to loop if true continue if false
	ret


_exit:
	mov eax, 1
	mov ebx, 0
	int	80h
