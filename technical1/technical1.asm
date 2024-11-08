section .data
    firstNum db 'Input first number: ', 0xa
    firstNum_len equ $- firstNum
    secondNum db 'Input second number: ', 0xa
    secondNum_len equ $- secondNum

    additionResult db 'The sum is: ', 0
    additionResult_len equ $- additionResult
    differenceResult db 'The difference is: ', 0xa
    differenceResult_len equ $- differenceResult

    ; prompts for sum
    greaterAdd_prompt db 'The sum is greater than 10', 0xa
    greaterAdd_prompt_len equ $- greaterAdd_prompt
    lesserAdd_prompt db 'The sum is less than 10', 0xa
    lesserAdd_prompt_len equ $- lesserAdd_prompt

    ; prompts for difference
    greaterDiff_prompt db 'The difference is greater than 0', 0xa
    greaterDiff_prompt_len equ $- greaterDiff_prompt
    lesserDiff_prompt db 'The difference is less than 0', 0xa
    lesserDiff_prompt_len equ $- lesserDiff_prompt

section .bss
    num1 resb 4
    num2 resb 4
    result resb 4
    result_str resb 4

section .text
    global _start

_start:
; prompt for the first number
mov eax, 4
mov ebx, 1
mov ecx, firstNum
mov edx, firstNum_len
int 0x80

; reads the first number
mov eax, 3
mov ebx, 0
mov ecx, num1
mov edx, 4
int 0x80

;instruction to convert it to ASCII
sub byte [num1], 48

; prompt for the second number
mov eax, 4
mov ebx, 1
mov ecx, secondNum
mov edx, secondNum_len
int 0x80

; reads the second number
mov eax, 3
mov ebx, 0
mov ecx, num2
mov edx, 4
int 0x80
sub byte [num2], 48

; adds the two numbers
add_num:
mov al, [num1]
add al, [num2]
mov [result], al

cmp al, 10
jg sum_greater ;compares value, if greater than, go to sum_greater, otherwise proceed down

sum_less:
mov eax, 4
mov ebx, 1
mov ecx, lesserAdd_prompt
mov edx, lesserAdd_prompt_len
int 0x80
jmp sub_num ; now jumps to subtraction of numbers

sum_greater:
mov eax, 4
mov ebx, 1
mov ecx, greaterAdd_prompt
mov edx, greaterAdd_prompt_len
int 0x80
;does not need to jump since it is followed below

; subtracts the two numbers
sub_num:
mov al, [num1]
sub al, [num2]
mov [result], al

; Check if it is less than 0
cmp al, 0
jl diff_less

; prompt if difference is greater than 0
diff_greater:
mov eax, 4
mov ebx, 1
mov ecx, greaterDiff_prompt
mov edx, greaterDiff_prompt_len
int 0x80
jmp display

; prompt if difference is a negative number
diff_less:
mov eax, 4
mov ebx, 1
mov ecx, lesserDiff_prompt
mov edx, lesserDiff_prompt_len
int 0x80

display:
; Display the sum
mov eax, 4
mov ebx, 1
mov ecx, additionResult
mov edx, additionResult_len
int 0x80

; Convert sum to ASCII and display
mov al, [result]
add al, 48
mov [result_str], al
mov eax, 4
mov ebx, 1
mov ecx, result_str
mov edx, 1
int 0x80

; Display the difference
mov eax, 4
mov ebx, 1
mov ecx, differenceResult
mov edx, differenceResult_len
int 0x80

; Convert difference to ASCII and display
add byte [result], 48
mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, 1
int 0x80

exit_program:
mov eax, 1
xor ebx, ebx
int 0x80
