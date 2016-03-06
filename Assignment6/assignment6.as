sys_exit	equ 1
sys_read	equ 3
sys_write	equ 4
stdin		equ 0
stdout		equ 1

extern getnum
extern showsum

section .data
about	db	"This program takes 2 numbers and adds them.", 0Ah
about_len 	equ $-about

insrt1	db	"Please insert your first number: "
insrt1_len	equ $-insrt1

insrt2 	db	"Please insert your second number: "
insrt2_len	equ $-insrt2

ans	db	"The answer is: "
ans_len		equ $-ans

section .bss
	in1_buf resb 1
	buf1_len equ $-in1_buf
	
	in2_buf resb 1
	buf2_len equ $-in2_buf
	
	input1 resb 1
	input2 resb 1
	sum    resb 1

section .text
global main

main:
	mov ecx, about
	mov edx, about_len
	
	call _display
	
	mov ecx, insrt1
	mov edx, insrt1_len
	call _display
	
	call getnum
	test:
	mov [input1], eax
	
	mov ecx, insrt2
	mov edx, insrt2_len
	call _display
	
	call getnum
	test1:
	mov  [input2], eax
	
	test2:
	xor eax, eax	
	xor ebx, ebx	

	mov al, [input1]
	mov bl, [input2]
	add al, bl
	mov [sum], al	
	push DWORD[sum]
	call showsum
	
	jmp _exit

_display:
	mov eax, sys_write
	mov ebx, stdout
	int 80h
	ret

_read:
	mov eax, sys_read
	mov ebx, stdin
	int 80h
	ret

_exit:
	mov eax, sys_exit
	mov ebx, stdin
	int 80h
