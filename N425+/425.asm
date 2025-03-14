section .data
    intro_msg db "Программа для вычисления функции f(x):", 10,
              db "Если -5 < x < 5, то y = x²", 10,
              db "В остальных случаях y = 7-x", 10, 0
    
    prompt_x db "Введите x: ", 0
    
    result_case1 db "x находится в интервале (-5, 5). y = x² = %d", 10, 0
    result_case2 db "x не находится в интервале (-5, 5). y = 7-x = %d", 10, 0
    
    format_in db "%d", 0
    error_msg db "Ошибка: введено не число! Перезапустите программу.", 10, 0

section .bss
    x resd 1    ; Переменная x
    y resd 1    ; Результат вычисления

section .text
    global main
    extern printf
    extern scanf
    
main:
    ; Пролог
    push ebp
    mov ebp, esp
    
    ; Вывод объяснения программы
    push intro_msg
    call printf
    add esp, 4
    
    ; Запрос и чтение x
    push prompt_x
    call printf
    add esp, 4
    
    push x
    push format_in
    call scanf
    add esp, 8
    
    ; Проверка успешности ввода
    cmp eax, 1
    jne input_error
    
    ; Проверяем условие -5 < x < 5
    mov eax, [x]
    cmp eax, -5
    jle not_in_range  ; Если x <= -5, переход к not_in_range
    
    cmp eax, 5
    jge not_in_range  ; Если x >= 5, переход к not_in_range
    
    ; Если -5 < x < 5, вычисляем y = x²
    mov eax, [x]
    imul eax, eax     ; eax = x * x
    mov [y], eax      ; y = x²
    
    ; Выводим результат
    push dword [y]
    push result_case1
    call printf
    add esp, 8
    
    jmp end_program
    
not_in_range:
    ; Если x <= -5 или x >= 5, вычисляем y = 7-x
    mov eax, 7
    sub eax, [x]      ; eax = 7 - x
    mov [y], eax      ; y = 7 - x
    
    ; Выводим результат
    push dword [y]
    push result_case2
    call printf
    add esp, 8
    
end_program:
    ; Эпилог
    mov esp, ebp
    pop ebp
    xor eax, eax    ; Возвращаем 0
    ret

input_error:
    ; Вывод сообщения об ошибке
    push error_msg
    call printf
    add esp, 4
    
    ; Эпилог
    mov esp, ebp
    pop ebp
    mov eax, 1      ; Возвращаем код ошибки 1
    ret
