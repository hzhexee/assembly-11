section .data
    intro_msg db "Программа для обработки трех чисел x, y, z по условию:", 10,
              db "Если x + y + z < 1, то z = 2 * (x - y)", 10,
              db "Иначе, наименьшее из x и y заменяется на 2 * (сумма двух других)", 10, 0
    
    prompt_x db "Введите x: ", 0
    prompt_y db "Введите y: ", 0
    prompt_z db "Введите z: ", 0
    
    result_case1 db "Сумма меньше 1. Новое значение z = %d", 10, 0
    result_case2_x db "Сумма больше или равна 1. x было наименьшим. Новое значение x = %d", 10, 0
    result_case2_y db "Сумма больше или равна 1. y было наименьшим. Новое значение y = %d", 10, 0
    
    final_values db "Итоговые значения: x = %d, y = %d, z = %d", 10, 0
    
    format_in db "%d", 0
    error_msg db "Ошибка: введено не число! Перезапустите программу.", 10, 0

section .bss
    x resd 1    ; Переменная x
    y resd 1    ; Переменная y
    z resd 1    ; Переменная z

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
    
    ; Запрос и чтение y
    push prompt_y
    call printf
    add esp, 4
    
    push y
    push format_in
    call scanf
    add esp, 8
    
    ; Проверка успешности ввода
    cmp eax, 1
    jne input_error
    
    ; Запрос и чтение z
    push prompt_z
    call printf
    add esp, 4
    
    push z
    push format_in
    call scanf
    add esp, 8
    
    ; Проверка успешности ввода
    cmp eax, 1
    jne input_error
    
    ; Вычисляем сумму x + y + z
    mov eax, [x]
    add eax, [y]
    add eax, [z]
    
    ; Сравниваем с 1
    cmp eax, 1
    jge sum_not_less_than_one
    
    ; Если сумма меньше 1, то z = 2 * (x - y)
    mov eax, [x]
    sub eax, [y]    ; eax = x - y
    add eax, eax    ; eax = 2 * (x - y)
    mov [z], eax    ; z = 2 * (x - y)
    
    ; Выводим результат
    push dword [z]
    push result_case1
    call printf
    add esp, 8
    
    jmp print_final_values
    
sum_not_less_than_one:
    ; Если сумма >= 1, то нужно заменить меньшее из x и y
    mov eax, [x]
    cmp eax, [y]
    jle x_is_smaller
    
    ; y меньше x, заменяем y на 2 * (x + z)
    mov eax, [x]
    add eax, [z]    ; eax = x + z
    add eax, eax    ; eax = 2 * (x + z)
    mov [y], eax    ; y = 2 * (x + z)
    
    ; Выводим результат
    push dword [y]
    push result_case2_y
    call printf
    add esp, 8
    
    jmp print_final_values
    
x_is_smaller:
    ; x меньше или равно y, заменяем x на 2 * (y + z)
    mov eax, [y]
    add eax, [z]    ; eax = y + z
    add eax, eax    ; eax = 2 * (y + z)
    mov [x], eax    ; x = 2 * (y + z)
    
    ; Выводим результат
    push dword [x]
    push result_case2_x
    call printf
    add esp, 8
    
print_final_values:
    ; Выводим итоговые значения x, y, z
    push dword [z]
    push dword [y]
    push dword [x]
    push final_values
    call printf
    add esp, 16
    
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
