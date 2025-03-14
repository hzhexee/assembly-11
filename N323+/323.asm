section .data
    intro_msg db "Программа вычисляет сумму членов ряда Ak = 3*k-1", 10, 0
    prompt_terms db "Введите количество членов ряда для вычисления: ", 0
    term_fmt db "Член A%d = %d", 10, 0
    result_msg db "Сумма первых %d членов = %d", 10, 0
    error_msg db "Ошибка: введите положительное число!", 10, 0
    format_in db "%d", 0

section .bss
    num_terms resd 1   ; Количество членов ряда
    sum resd 1         ; Сумма членов ряда

section .text
    global main
    extern printf
    extern scanf
    
main:
    ; Пролог
    push ebp
    mov ebp, esp
    sub esp, 8        ; Выделяем дополнительное пространство на стеке для локальных переменных
    
    ; Сохраняем регистры, которые будем использовать
    push ebx
    push esi
    push edi
    
    ; Вывод начального сообщения
    push intro_msg
    call printf
    add esp, 4
    
    ; Запрос количества членов
    push prompt_terms
    call printf
    add esp, 4
    
    ; Считывание количества членов
    push num_terms
    push format_in
    call scanf
    add esp, 8
    
    ; Проверка на успешность ввода
    cmp eax, 1
    jne input_error
    
    ; Проверка, что введено положительное число
    cmp dword [num_terms], 0
    jle input_error
    
    ; Ограничение максимального количества членов для безопасности
    cmp dword [num_terms], 1000
    jle valid_input
    mov dword [num_terms], 1000  ; Если больше 1000, ограничиваем до 1000
    
valid_input:
    ; Инициализация начальных значений
    mov ecx, [num_terms]  ; Счетчик цикла - заданное количество членов
    mov dword [sum], 0    ; Сумма = 0
    mov esi, 1            ; k начинается с 1
    
calculate_sum:
    ; Проверяем, что ecx > 0
    cmp ecx, 0
    jle calculation_done
    
    ; Вычисление Ak = 3*k-1
    mov eax, 3
    mul esi           ; eax = 3*esi (3*k)
    sub eax, 1        ; eax = 3*k-1
    
    ; Сохраняем результаты перед вызовом функции
    mov ebx, eax      ; Сохраняем значение члена ряда
    mov edi, ecx      ; Сохраняем счетчик цикла
    
    ; Вывод каждого члена
    push ebx          ; Значение члена
    push esi          ; Номер члена (k)
    push term_fmt
    call printf
    add esp, 12
    
    ; Восстанавливаем сохраненные значения
    mov ecx, edi      ; Восстанавливаем счетчик цикла
    mov eax, ebx      ; Восстанавливаем значение члена ряда
    
    ; Добавляем к сумме
    add [sum], eax
    
    ; Увеличиваем k и уменьшаем счетчик
    inc esi
    dec ecx
    
    ; Проверка счетчика и повторение цикла
    jnz calculate_sum
    
calculation_done:
    ; Вывод результата
    push dword [sum]
    push dword [num_terms]
    push result_msg
    call printf
    add esp, 12
    
    jmp exit_program
    
input_error:
    ; Вывод сообщения об ошибке
    push error_msg
    call printf
    add esp, 4
    
exit_program:
    ; Восстанавливаем сохраненные регистры
    pop edi
    pop esi
    pop ebx
    
    ; Эпилог
    mov esp, ebp
    pop ebp
    xor eax, eax      ; Возвращаем 0
    ret
