section .data
    probno db "Problem No.2", 0xa
    prompt_base db "Input base: ", 0
    prompt_exponent db "Input exponent: ", 0
    result_msg db "Power of number = ", 0
    newline db 10

section .bss
    base resb 4
    exponent resb 4
    result resd 1
    buffer resb 12

section .text
    global _start

; uses MACROS for printing that accepts two parameters
%macro print_msg 2
    mov eax, 4              
    mov ebx, 1              
    mov ecx, %1             
    mov edx, %2             
    int 0x80                
%endmacro

; uses macro for reading an input that accepts two parameters
%macro read_input 2
    ; %1 = buffer to store input
    ; %2 = length of input to read
    mov eax, 3              
    mov ebx, 0             
    mov ecx, %1             ; buffer to store input
    mov edx, %2             ; number of bytes to read
    int 0x80                ; call kernel
    call str_to_int         ; convert input string to integer in eax
    mov [%1], eax           ;
%endmacro

_start:
    ; Prompt for base and read input
    print_msg probno, 13
    print_msg prompt_base, 12
    read_input base, 4

    ; Prompt for exponent and read input
    print_msg prompt_exponent, 16
    read_input exponent, 4

    ; Calculate power using recursion
    mov eax, [base]
    mov ebx, [exponent]
    call power              ; calculates it
    mov [result], eax       ; stores result

    ; Print result message
    print_msg result_msg, 18

    ; convert result to string and print it
    mov eax, [result]
    call int_to_str
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 12
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

power:
    cmp ebx, 0               ; if exponent == 0
    jne .recurse
    mov eax, 1               ; base ^ 0 = 1
    ret

.recurse:
    dec ebx                  ; decrement exponent by 1
    push eax                 ; save current base
    push ebx                 ; save current exponent
    call power               ; recursively call power(base, exponent - 1)
    pop ebx                  ; restore exponent
    pop ecx                  ; retrieve the saved base
    imul eax, ecx            ; multiply result by base
    ret

; Convert integer in eax to string in buffer
int_to_str:
    mov edi, buffer
    add edi, 11              ; start filling buffer from the end
    mov byte [edi], 0        
    dec edi

    mov ebx, 10
.convert_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .convert_loop
    inc edi                  
    ret

; Convert string in ecx to integer in eax
str_to_int:
    xor eax, eax
    xor ebx, ebx
    mov ebx, 10              ; decimal base
.next_digit:
    movzx edx, byte [ecx]
    cmp dl, '0'
    jb .done
    cmp dl, '9'
    ja .done
    sub dl, '0'
    imul eax, ebx
    add eax, edx
    inc ecx
    jmp .next_digit
.done:
    ret
