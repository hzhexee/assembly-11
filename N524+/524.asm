section .data
    prompt_n db "Введите размер массивов N (1-100): ", 0
    prompt_a db "Введите элементы массива A (по одному):", 10, 0
    prompt_b db "Введите элементы массива B (по одному):", 10, 0
    input_fmt db "%d", 0
    output_yes db "Да", 10, 0
    output_no db "Нет", 10, 0
    error_msg db "Ошибка ввода! Пожалуйста, введите целое число.", 10, 0

section .bss
    array_a resd 100   ; массив A (до 100 элементов)
    array_b resd 100   ; массив B (до 100 элементов)
    visited resd 100   ; массив для отметки посещенных элементов в B
    n resd 1           ; размер массивов

section .text
    global main
    extern printf, scanf, getchar

main:
    push ebp
    mov ebp, esp

    ; Запрашиваем размер массивов
    push prompt_n
    call printf
    add esp, 4

    ; Считываем N
    push n
    push input_fmt
    call scanf
    add esp, 8

    ; Проверяем корректность N (1 <= N <= 100)
    mov eax, [n]
    cmp eax, 1
    jl invalid_n
    cmp eax, 100
    jg invalid_n
    jmp input_array_a

invalid_n:
    ; Если N некорректно, повторяем запрос
    push error_msg
    call printf
    add esp, 4
    
    ; Очищаем буфер ввода
clear_buffer_n:
    call getchar
    cmp al, 10
    jne clear_buffer_n
    
    jmp main

input_array_a:
    ; Выводим приглашение для ввода массива A
    push prompt_a
    call printf
    add esp, 4

    ; Ввод элементов массива A
    xor ebx, ebx      ; ebx = 0 (индекс в массиве)

input_loop_a:
    mov eax, [n]
    cmp ebx, eax
    jge input_array_b  ; если ввели все элементы, переходим к вводу B
    
    ; Считываем элемент
    lea eax, [array_a + ebx*4]
    push eax
    push input_fmt
    call scanf
    add esp, 8
    
    ; Проверяем успешность считывания
    cmp eax, 1
    je valid_input_a
    
    ; Обработка ошибки ввода
    push error_msg
    call printf
    add esp, 4
    
    ; Очищаем буфер ввода
clear_buffer_a:
    call getchar
    cmp al, 10
    jne clear_buffer_a
    
    jmp input_loop_a
    
valid_input_a:
    inc ebx
    jmp input_loop_a

input_array_b:
    ; Выводим приглашение для ввода массива B
    push prompt_b
    call printf
    add esp, 4

    ; Ввод элементов массива B
    xor ebx, ebx      ; ebx = 0 (индекс в массиве)

input_loop_b:
    mov eax, [n]
    cmp ebx, eax
    jge compare_arrays  ; если ввели все элементы, переходим к сравнению
    
    ; Считываем элемент
    lea eax, [array_b + ebx*4]
    push eax
    push input_fmt
    call scanf
    add esp, 8
    
    ; Проверяем успешность считывания
    cmp eax, 1
    je valid_input_b
    
    ; Обработка ошибки ввода
    push error_msg
    call printf
    add esp, 4
    
    ; Очищаем буфер ввода
clear_buffer_b:
    call getchar
    cmp al, 10
    jne clear_buffer_b
    
    jmp input_loop_b
    
valid_input_b:
    inc ebx
    jmp input_loop_b

compare_arrays:
    ; Инициализируем массив visited нулями
    mov ecx, [n]
    xor ebx, ebx
init_visited:
    mov dword [visited + ebx*4], 0
    inc ebx
    cmp ebx, ecx
    jl init_visited

    ; Для каждого элемента в A ищем соответствие в B
    xor esi, esi  ; индекс в A
outer_loop:
    mov ecx, [n]
    cmp esi, ecx
    jge arrays_equal  ; если прошли весь A, то массивы равны

    mov eax, [array_a + esi*4]  ; текущий элемент из A
    
    ; Ищем элемент в B
    xor edi, edi  ; индекс в B
inner_loop:
    cmp edi, ecx
    jge arrays_not_equal  ; если не нашли соответствие в B
    
    ; Проверяем, был ли элемент уже использован
    cmp dword [visited + edi*4], 1
    je next_b  ; если да, проверяем следующий элемент B
    
    ; Сравниваем элементы
    cmp eax, [array_b + edi*4]
    jne next_b  ; если не равны, проверяем следующий элемент B
    
    ; Нашли соответствие, отмечаем элемент B как использованный
    mov dword [visited + edi*4], 1
    jmp next_a  ; переходим к следующему элементу A
    
next_b:
    inc edi
    jmp inner_loop
    
next_a:
    inc esi
    jmp outer_loop
    
arrays_equal:
    ; Проверяем, что все элементы массива B были использованы
    xor ebx, ebx
    mov ecx, [n]
check_all_visited:
    cmp ebx, ecx
    jge print_yes  ; если все элементы отмечены, то массивы равны
    
    cmp dword [visited + ebx*4], 0
    je arrays_not_equal  ; если нашли неиспользованный элемент, то массивы не равны
    
    inc ebx
    jmp check_all_visited
    
print_yes:
    ; Выводим "Да"
    push output_yes
    call printf
    add esp, 4
    jmp exit
    
arrays_not_equal:
    ; Выводим "Нет"
    push output_no
    call printf
    add esp, 4
    
exit:
    ; Завершаем программу
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret
