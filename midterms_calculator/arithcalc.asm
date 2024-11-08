section .data
    msg db 'Result: ', 0
    msg_len equ $- msg
    prompt1 db 'Enter first number: ', 0
    prompt1_len equ $- prompt1
    prompt2 db 'Enter second number: ', 0
    prompt2_len equ $- prompt2
    prompt3 db 'Choose operation (1-Addition, 2-Subtraction, 3-Multiplication, 4-Division): ', 0
    prompt3_len equ $- prompt3
    num1 dd 0
    num2 dd 0
    result dd 0

section .bss
    input resb 3
    operation resb 1

section .text
    global _start

_start:
    ; Prompt for first number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, prompt1_len
    int 0x80

    ; Read first number
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 3
    int 0x80
    movzx eax, byte [input]
    sub eax, '0'
    movzx ebx, byte [input+1]
    sub ebx, '0'
    imul eax, eax, 10
    add eax, ebx
    mov [num1], eax

    ; Prompt for second number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, prompt2_len
    int 0x80

    ; Read second number
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 3
    int 0x80
    movzx eax, byte [input]
    sub eax, '0'
    movzx ebx, byte [input+1]
    sub ebx, '0'
    imul eax, eax, 10
    add eax, ebx
    mov [num2], eax

    ; Prompt for operation
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt3
    mov edx, prompt3_len
    int 0x80

    ; Read operation
    mov eax, 3
    mov ebx, 0
    mov ecx, operation
    mov edx, 1
    int 0x80
    movzx eax, byte [operation]
    sub eax, '0'

    ; Perform operation
    cmp eax, 1
    je addition
    cmp eax, 2
    je subtraction
    cmp eax, 3
    je multiplication
    cmp eax, 4
    je division

addition:
    mov eax, [num1]
    add eax, [num2]
    jmp print_result

subtraction:
    mov eax, [num1]
    sub eax, [num2]
    jmp print_result

multiplication:
    mov eax, [num1]
    mov ebx, [num2]
    imul eax, ebx
    jmp print_result

division:
    mov eax, [num1]
    xor edx, edx
    div dword [num2]
    jmp print_result

print_result:
    mov [result], eax

    ; Convert result to ASCII
    mov eax, [result]
    mov ecx, 10
    xor edx, edx
    div ecx
    add dl, '0'
    mov [input+1], dl
    mov eax, eax
    add al, '0'
    mov [input], al

    ; Print result
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, input
    mov edx, 2
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80