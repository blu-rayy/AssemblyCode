section .bss
    num resb 5   

section .data
    prompt db "Enter a number (1-digit): ", 0xA
    lenPrompt equ $ - prompt
    even_msg db "The number is even.", 0xA
    lenEven equ $ - even_msg
    odd_msg db "The number is odd.", 0xA
    lenOdd equ $ - odd_msg

section .text
    global _start

_start:
    ; prints "Enter a number: "
    mov eax, 4                   
    mov ebx, 1                  
    mov ecx, prompt             
    mov edx, lenPrompt                 
    int 0x80

    ; accepts input from user
    mov eax, 3                  
    mov ebx, 0                   
    mov ecx, num                 
    mov edx, 4                
    int 0x80

    ; convert ASCII to integer
    mov eax, [num]               
    sub eax, '0'                 

    and eax, 1                   ; checks for last digit of binary / least significant-bit
    jz even                      ; Jump if Zero -- Last digit is 0, so it's even
    jmp odd                      ; otherwise, it's odd

even:
    ; prints "The number is even."
    mov eax, 4                   
    mov ebx, 1                  
    mov ecx, even_msg            
    mov edx, lenEven             
    int 0x80                     
    jmp exit                     

odd:
    ; prints "The number is odd."
    mov eax, 4                   
    mov ebx, 1                   
    mov ecx, odd_msg             
    mov edx, lenOdd              
    int 0x80                     

exit:
    mov eax, 1                   
    xor ebx, ebx                 
    int 0x80                     
