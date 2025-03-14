; filepath: /home/hzhex/AssemblyTimofey/task_5_14.asm
section .data
    prompt db "Введите 10 целых чисел (по одному):", 10, 0
    input_fmt db "%d", 0
    output_array db "Модифицированный массив: ", 0
    output_num db "%d ", 0
    newline db 10, 0
    sum_msg db "Сумма чисел из отрезка [2;9]: %d", 10, 0
    count_msg db "Количество чисел из отрезка [2;9]: %d", 10, 0
    error_msg db "Ошибка ввода! Пожалуйста, введите целое число.", 10, 0

section .bss
    array resd 10     ; массив из 10 целых чисел (4 байта каждое)

section .text
    global main
    extern printf, scanf, getchar

main:
    push ebp
    mov ebp, esp

    ; Выводим приглашение ввести числа
    push prompt
    call printf
    add esp, 4

    ; Ввод 10 чисел в массив
    xor ebx, ebx      ; ebx = 0 (индекс в массиве)

input_loop:
    cmp ebx, 10
    jge process_array ; если уже введено 10 чисел, переходим к обработке
    
    ; Читаем число
    lea eax, [array + ebx*4]
    push eax
    push input_fmt
    call scanf
    add esp, 8
    
    ; Проверяем успешность считывания
    cmp eax, 1
    je valid_input
    
    ; Обработка ошибки ввода
    push error_msg
    call printf
    add esp, 4
    
    ; Очищаем буфер ввода
clear_buffer:
    call getchar
    cmp al, 10        ; проверяем на символ новой строки
    jne clear_buffer
    
    jmp input_loop    ; повторяем ввод для того же индекса
    
valid_input:
    inc ebx
    jmp input_loop
    
process_array:
    ; Начинаем обработку массива
    push output_array
    call printf
    add esp, 4
    
    xor ebx, ebx      ; индекс в массиве
    xor esi, esi      ; сумма чисел из отрезка [2;9]
    xor edi, edi      ; количество чисел из отрезка [2;9]
    
process_loop:
    cmp ebx, 10
    jge output_results
    
    mov eax, [array + ebx*4]
    
    ; Проверяем, принадлежит ли число отрезку [2;9]
    cmp eax, 2
    jl check_replacement
    cmp eax, 9
    jg check_replacement
    
    ; Число в диапазоне [2;9]
    add esi, eax      ; добавляем к сумме
    inc edi           ; увеличиваем счетчик
    
check_replacement:
    ; Проверяем, больше ли число 2
    cmp eax, 2
    jle skip_replacement
    
    ; Заменяем число на 0
    mov dword [array + ebx*4], 0
    
skip_replacement:
    ; Выводим текущий элемент массива
    push dword [array + ebx*4]
    push output_num
    call printf
    add esp, 8
    
    inc ebx
    jmp process_loop
    
output_results:
    ; Переходим на новую строку
    push newline
    call printf
    add esp, 4
    
    ; Выводим сумму чисел из отрезка [2;9]
    push esi
    push sum_msg
    call printf
    add esp, 8
    
    ; Выводим количество чисел из отрезка [2;9]
    push edi
    push count_msg
    call printf
    add esp, 8
    
    ; Завершаем программу
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret