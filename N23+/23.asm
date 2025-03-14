section .data
    prompt_a db "Введите a: ", 0
    prompt_b db "Введите b: ", 0
    prompt_c db "Введите c: ", 0
    prompt_d db "Введите d: ", 0
    prompt_e db "Введите e: ", 0
    result_msg db "Результат (a+b+c)+(d-e) = ", 0
    error_msg db "Ошибка: введите число, а не текст!", 10, 0
    format_in db "%d", 0
    format_out db "%d", 10, 0  ; %d followed by newline

section .bss
    a resd 1
    b resd 1
    c resd 1
    d resd 1
    e resd 1
    result resd 1

section .text
    global main
    extern printf
    extern scanf
    
main:
    ; Prologue
    push ebp
    mov ebp, esp
    
    ; Ask for and read a
    push prompt_a
    call printf
    add esp, 4
    
    push a
    push format_in
    call scanf
    add esp, 8
    
    ; Check if scanf was successful
    cmp eax, 1
    jne input_error
    
    ; Ask for and read b
    push prompt_b
    call printf
    add esp, 4
    
    push b
    push format_in
    call scanf
    add esp, 8
    
    ; Check if scanf was successful
    cmp eax, 1
    jne input_error
    
    ; Ask for and read c
    push prompt_c
    call printf
    add esp, 4
    
    push c
    push format_in
    call scanf
    add esp, 8
    
    ; Check if scanf was successful
    cmp eax, 1
    jne input_error
    
    ; Ask for and read d
    push prompt_d
    call printf
    add esp, 4
    
    push d
    push format_in
    call scanf
    add esp, 8
    
    ; Check if scanf was successful
    cmp eax, 1
    jne input_error
    
    ; Ask for and read e
    push prompt_e
    call printf
    add esp, 4
    
    push e
    push format_in
    call scanf
    add esp, 8
    
    ; Check if scanf was successful
    cmp eax, 1
    jne input_error
    
    ; Calculate (a+b+c)+(d-e) using registers
    mov eax, [a]      ; eax = a
    add eax, [b]      ; eax = a + b
    add eax, [c]      ; eax = a + b + c
    mov ebx, [d]      ; ebx = d
    sub ebx, [e]      ; ebx = d - e
    add eax, ebx      ; eax = (a + b + c) + (d - e)
    mov [result], eax ; store result
    
    ; Print result message
    push result_msg
    call printf
    add esp, 4
    
    ; Print the calculated result
    push dword [result]
    push format_out
    call printf
    add esp, 8
    
    jmp exit_program
    
input_error:
    ; Display error message
    push error_msg
    call printf
    add esp, 4
    
exit_program:
    ; Epilogue
    mov esp, ebp
    pop ebp
    xor eax, eax      ; Return 0
    ret
