section .text
    global _start       ; must be declared for using gcc
_start:
    call display
    mov eax, 1          ; system call number (sys_exit)
    int 0x80            ; call kernel

display:
    mov ecx, 256

next:
    push ecx
    mov eax, 4          ; system call number (sys_write)
    mov ebx, 1          ; file descriptor (stdout)
    mov ecx, achar
    mov edx, 1
    int 0x80            ; call kernel
    pop ecx
    mov dx, [achar]
    cmp byte [achar], 0Dh
    inc byte [achar]
    loop next
    ret

section .data
achar db '0'
