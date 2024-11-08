section .data;
	insNum db 'Please enter a number: '
	len_insNum equ $ - insNum
	
	dispMsg db 'You have entered: ',
	lenDispMsg equ $ - dispMsg

section .bss
	num resb 10
section .text
	global _start
_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, insNum
	mov edx, len_insNum
	int 0x80

	mov eax, 3
	mov ebx, 2
	mov ecx, num
	mov edx, 10
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, dispMsg
	mov edx, lenDispMsg
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, num
	mov edx, 10
	int 0x80

	mov eax, 1
	mov ebx, 0
	int 0x80

