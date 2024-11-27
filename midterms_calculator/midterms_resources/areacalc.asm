section .data
    ; ANSI escape codes for colors
    color_add db 0x1b, '[33m', 0  ; Yellow text
    color_reset db 0x1b, '[0m', 0    ; Reset to default color
    prompt db '==== AREA CALCULATOR ====', 10
    prompt_len equ $ - prompt
    
    menu db '[1] Rectangle', 10
          db '[2] Triangle', 10
          db '[3] Square', 10
          db '[4] Exit', 10, 10
          db 'Choose an Option: ', 0, 0
    menu_len equ $ - menu

    ; rectangle variables print
    width_rectangle db 'Enter width of Rectangle: ', 0
    width_rectangle_len equ $ - width_rectangle

    height_rectangle db 'Enter height of Rectangle: ', 0
    height_rectangle_len equ $ - height_rectangle

    ; triangle variables print
    width_triangle db 'Enter base of Triangle: ', 0
    width_triangle_len equ $ - width_triangle

    height_triangle db 'Enter height of Triangle: ', 0
    height_triangle_len equ $ - height_triangle

    ; square variable print
    width_square db 'Enter side of Square: ', 0
    width_square_len equ $ - width_square

    result_msg db 'The Area of the Shape is... ', 0
    result_msg_len equ $ - result_msg

    newline db 10
    error_msg db 'Invalid input!', 10

section .bss
    input resb 3
    width resb 1
    height resb 1
    result resb 4

section .text
    global _start

%macro PRINT 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro READ 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

_start:
main_loop:
    ; Display menu
    PRINT newline, 1

    PRINT color_add, 5               ; Set color to red
    PRINT prompt, prompt_len         ; Print the header
    PRINT color_reset, 4             ; Reset to default color

    PRINT menu, menu_len

    ; Read menu choice
    READ input, 3
    call convert_input

    ; Exit condition
    cmp al, 4
    je exit

    ; Validate choice
    cmp al, 1
    jl invalid_input
    cmp al, 3
    jg invalid_input

    ; Branch based on choice
    cmp al, 1
    je rectangle_area
    cmp al, 2
    je triangle_area
    cmp al, 3
    je square_area

rectangle_area:
    ; Get width
    PRINT width_rectangle, width_rectangle_len
    READ input, 3
    call convert_input
    mov byte [width], al

    ; Get height
    PRINT height_rectangle, height_rectangle_len
    READ input, 3
    call convert_input
    mov byte [height], al

    ; Compute
    movzx eax, byte [width]
    movzx ebx, byte [height]
    mul ebx
    jmp display_result

triangle_area:
    ; Get width/base
    PRINT width_triangle, width_triangle_len
    READ input, 3
    call convert_input
    mov byte [width], al

    ; Get height
    PRINT height_triangle, height_triangle_len
    READ input, 3
    call convert_input
    mov byte [height], al

    ; Compute
    movzx eax, byte [width]
    movzx ebx, byte [height]
    mul ebx
    shr eax, 1  ; Divide by 2
    jmp display_result

square_area:
    ; Get width/side
    PRINT width_square, width_square_len
    READ input, 3
    call convert_input
    mov byte [width], al

    ; Compute
    movzx eax, al
    mul eax
    jmp display_result

convert_input:
    ; Convert ASCII input to integer
    xor eax, eax
    mov al, [input]
    sub al, '0'
    cmp byte [input + 1], 10
    je single_digit

    ; Two-digit number handling
    mov bl, 10
    mul bl
    mov bl, [input + 1]
    sub bl, '0'
    add al, bl

single_digit:
    ret

display_result:
    ; Convert result to string
    call int_to_str
    PRINT result_msg, result_msg_len
    PRINT result, 4
    PRINT newline, 1
    jmp main_loop  ; Return to main menu

invalid_input:
    PRINT error_msg, 14
    jmp main_loop  ; Return to main menu

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

int_to_str:
    ; Convert integer in EAX to string
    mov ebx, 10
    mov ecx, result + 3
    mov byte [ecx + 1], 10  ; newline

digit_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    dec ecx
    test eax, eax
    jnz digit_loop
    ret