section .data
    ; ANSI escape codes for colors
    color_add db 0x1b, '[33m', 0  ; color yellow
    color_reset db 0x1b, '[0m', 0    ; Reset to default color

    prompt db '==== AREA CALCULATOR ====', 10
    prompt_len equ $ - prompt
    
    ;nagpalit 1 and 3
    menu db '[1] Square', 10
          db '[2] Triangle', 10
          db '[3] Rectangle', 10
          db 'Choose an Option: ', 0, 0
    menu_len equ $ - menu

    ; square variable print
    width_square db 'Enter side: ', 0
    width_square_len equ $ - width_square

    square_result db 'Square Area = ', 0
    square_result_len equ $ - square_result

    ; triangle variables print
    width_triangle db 'Enter base: ', 0
    width_triangle_len equ $ - width_triangle

    height_triangle db 'Enter height: ', 0
    height_triangle_len equ $ - height_triangle

    triangle_result db 'Right Triangle Area = ', 0
    triangle_result_len equ $ - triangle_result

    ; rectangle variables print
    width_rectangle db 'Enter width: ', 0
    width_rectangle_len equ $ - width_rectangle

    height_rectangle db 'Enter length: ', 0
    height_rectangle_len equ $ - height_rectangle

    rectangle_result db 'Rectangle Area = ', 0
    rectangle_result_len equ $ - rectangle_result

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
    ; display the menu
    PRINT color_add, 5    
    PRINT prompt, prompt_len
    PRINT color_reset, 4 
    PRINT menu, menu_len

    ; read the inputs from menu
    READ input, 3
    call ascii_to_int

    ; if 
    cmp al, 4
    je exit

    ; Validate choice
    cmp al, 1
    jl invalid_input
    cmp al, 3
    jg invalid_input

    ; choose which to calculate
    cmp al, 1
    je square_area
    cmp al, 2
    je triangle_area
    cmp al, 3
    je rectangle_area

square_area:
    ; Get width/side
    PRINT width_square, width_square_len
    READ input, 3
    call ascii_to_int
    mov byte [width], al

    ; Compute
    movzx eax, al
    mul eax
    jmp display_square

triangle_area:
    ; get width/base
    PRINT width_triangle, width_triangle_len
    READ input, 3
    call ascii_to_int
    mov byte [width], al

    ; get height
    PRINT height_triangle, height_triangle_len
    READ input, 3
    call ascii_to_int
    mov byte [height], al

    ; compute ([base * height]/2)
    movzx eax, byte [width]
    movzx ebx, byte [height]
    mul ebx
    shr eax, 1  ; Divide by 2
    jmp display_triangle

rectangle_area:
    ; Get length/height
    PRINT height_rectangle, height_rectangle_len
    READ input, 3
    call ascii_to_int
    mov byte [height], al

    ; Get width
    PRINT width_rectangle, width_rectangle_len
    READ input, 3
    call ascii_to_int
    mov byte [width], al

    ; compute (length x width)
    movzx eax, byte [width]
    movzx ebx, byte [height]
    mul ebx
    jmp display_rectangle


ascii_to_int:
    ; Convert ASCII input to integer
    xor eax, eax
    mov al, [input]
    sub al, '0'
    cmp byte [input + 1], 10
    je if_single_digit

    ; Two-digit number handling
    mov bl, 10
    mul bl
    mov bl, [input + 1]
    sub bl, '0'
    add al, bl

if_single_digit:
    ret

display_square:
call int_to_str
    PRINT square_result, square_result_len
    PRINT result, 4
    PRINT newline, 1
    call exit

display_triangle:
    call int_to_str
    PRINT triangle_result, triangle_result_len
    PRINT result, 4
    PRINT newline, 1
    call exit

display_rectangle:
    call int_to_str
    PRINT rectangle_result, rectangle_result_len
    PRINT result, 4
    PRINT newline, 1
    call exit

invalid_input:
    PRINT error_msg, 14
    call exit

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