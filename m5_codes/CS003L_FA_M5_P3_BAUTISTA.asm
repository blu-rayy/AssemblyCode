section .text
    global _start       ; must be declared for using gcc
_start:
    mov bl, 3           ; for calculating factorial 3
    call proc_fact
    add ax, 30h
    mov [fact], ax

    mov edx, len        ; message length
    mov ecx, msg        ; message to write
    mov ebx, 1          ; file descriptor (stdout)
    mov eax, 4          ; system call number (sys_write)
    int 0x80            ; call kernel

    mov edx, 1          ; message length
    mov ecx, fact       ; message to write
    mov ebx, 1          ; file descriptor (stdout)
    mov eax, 4          ; system call number (sys_write)
    int 0x80            ; call kernel

    mov eax, 1          ; system call number (sys_exit)
    int 0x80            ; call kernel

proc_fact:
    cmp bl, 1
    je do_calculation
    mov ax, 1
    ret

do_calculation:
    dec bl
    call proc_fact
    mul bl              ; ax = ax * bl
    ret

section .data
msg db "Factorial is:", 0xA
len equ $ - msg

section .bss
fact resb 1