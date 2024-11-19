section .data
    array dd 25, 5, 8, 15, 20    
    array_len equ 5              
    probno db "Problem No.1", 0xa
    probno_len equ $ - probno
    msg1 db "ArrayN[5] = ["
    msg1_len equ $ - msg1
    msg2 db "]", 10, "Sum = "    
    msg2_len equ $ - msg2
    msg3 db 10, "Largest = "     
    msg3_len equ $ - msg3
    msg4 db 10, "Smallest = "
    msg4_len equ $ - msg4
    comma db ", "
    comma_len equ $ - comma
    newline db 10
    sum dd 0                    
    largest dd 0                 
    
section .bss
    digit_buffer resb 12         

; implemented macros for printing, accepts parameters string and length
%macro print_string 2           
    push eax
    push ebx
    push ecx
    push edx
    
    mov eax, 4                 ; sys_write
    mov ebx, 1                 ; stdout
    mov ecx, %1                ; parameter 1: string to print
    mov edx, %2                ; parameter 2: length of string
    int 0x80
    
    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro

%macro print_number_from_mem 1  ;
    push ecx
    mov ecx, [%1]
    call print_number
    pop ecx
%endmacro

%macro print_newline 0   
    print_string newline, 1
%endmacro

%macro print_comma 0
    print_string comma, comma_len
%endmacro

section .text
    global _start

_start:
    print_string probno, probno_len
    print_string msg1, msg1_len ; Print initial message

    ; Initialize variables
    mov esi, 0                  
    mov ecx, array_len          
    mov eax, [array]            
    mov dword [largest], eax    
    mov edi, eax                

process_array:
    mov eax, [array + esi * 4]  
    
    ; Add to sum
    add dword [sum], eax
    
    ; Check if largest
    cmp eax, dword [largest]
    jle not_larger
    mov dword [largest], eax    
not_larger:

    ; Check if smallest
    cmp eax, edi
    jge not_smaller
    mov edi, eax                
not_smaller:

    ; Print current number
    push ecx                    
    mov ecx, eax
    call print_number
    pop ecx                     

    ; Print comma if not last number
    dec ecx
    cmp ecx, 0
    je print_results
    
    print_comma                 ; Using macro to print comma

    inc esi                     
    jmp process_array

print_results:
    ; Print remaining messages and values using macros
    print_string msg2, msg2_len
    print_number_from_mem sum
    print_string msg3, msg3_len
    print_number_from_mem largest
    print_string msg4, msg4_len
    
    ; Print smallest (still in edi)
    push ecx
    mov ecx, edi
    call print_number
    pop ecx

    print_newline              ; Final newline

    ; Exit program
    mov eax, 1                  
    xor ebx, ebx                
    int 0x80

; Function to print a number
; Input: ECX = number to print
print_number:
    push eax
    push ebx
    push edx
    push esi
    push edi
    
    mov esi, digit_buffer
    add esi, 11                 
    mov byte [esi], 0           
    
    mov eax, ecx
    mov ebx, 10
    
convert_loop:
    dec esi
    xor edx, edx                
    div ebx                     
    add dl, '0'                 
    mov [esi], dl               
    test eax, eax               
    jnz convert_loop
    
    ; Print the converted number using our print_string macro
    mov ecx, esi                ; Calculate string length
    mov edx, digit_buffer
    add edx, 11
    sub edx, esi
    print_string esi, edx       
    
    pop edi
    pop esi
    pop edx
    pop ebx
    pop eax
    ret