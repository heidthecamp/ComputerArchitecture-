; Linux 32-bit assembly

;predefined

sys_exit	equ	1;
sys_read	  equ	3;
sys_write	equ	4
stdin	equ	0
stdout	equ	1
stderr	equ	3


SECTION .data
string: db "This program incrypts and decrypts a string"
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

	call _flip
	call _encode

	mov ecx, string
	mov edx, string_len
	call _display
	mov ecx, newline
	mov edx, newline_len
	call _display

	call _encode
	call _flip

	mov ecx, string
	mov edx, string_len
	call _display
	mov ecx, newline
	mov edx, newline_len
	call _display

	jp _exit

_display:
	mov eax, sys_write
	mov ebx, stdout
	int	80h
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
	mov eax, [i]                ;move the vlaue in i to
	mov edx, 1    ;move the size of a dword to edx
	mul edx                     ;multiply the value in eax (i) by the size of a dword

	;move edx and ebx to swap locations in array
	mov dx, ax                            ;move the value of eax to edx
	mov bx, string_len - 1    ;move the location of the last element in the array to ebx
	sub bx, ax                            ;subtract eax from ebx

	;swap array locations
	mov ax, [string + edx]  ;move the value of the array (start location + edx) to eax
	xchg ax, [string + ebx] ;swap the vlaue of the array (start location + ebx) with eax
	xchg ax, [string + edx] ;swap the vlaue of the array (start location + edx) with eax

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
