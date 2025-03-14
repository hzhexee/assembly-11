section .data
    prompt db "Введите предложение: ", 0
    prompt_len equ $ - prompt
    result_msg db "Количество слов: ", 0
    result_len equ $ - result_msg
    newline db 10, 0

section .bss
    buffer resb 1024       ; Буфер для ввода
    result resb 20         ; Для хранения количества слов в виде строки

section .text
    global _start

_start:
    ; Вывод приглашения
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, prompt         ; сообщение для вывода
    mov edx, prompt_len     ; длина сообщения
    int 0x80

    ; Чтение ввода
    mov eax, 3              ; sys_read
    mov ebx, 0              ; stdin
    mov ecx, buffer         ; буфер для ввода
    mov edx, 1024           ; размер буфера
    int 0x80

    ; Сохранение количества прочитанных байт
    mov esi, eax            ; сохраняем в esi (эквивалент r10 в 64-бит)

    ; Инициализация переменных
    xor edi, edi            ; edi = 0 (текущая позиция)
    xor ebp, ebp            ; ebp = 0 (счетчик слов)
    mov edx, 0              ; edx = 0 (флаг: 0=вне слова, 1=внутри слова)

count_loop:
    cmp edi, esi            ; Сравниваем текущую позицию с общим количеством байт
    jge end_count           ; Если достигли конца, завершаем подсчет

    movzx eax, byte [buffer + edi]  ; Получаем текущий символ
    
    ; Проверяем, является ли символ пробелом или переводом строки
    cmp al, ' '
    je is_delimiter
    cmp al, 10              ; перевод строки
    je is_delimiter
    cmp al, 9               ; табуляция
    je is_delimiter
    
    ; Не разделитель, это часть слова
    cmp edx, 0              ; Проверяем, находимся ли вне слова
    jne continue_word       ; Если уже в слове, продолжаем
    
    ; Входим в новое слово
    inc ebp                 ; Увеличиваем счетчик слов
    mov edx, 1              ; Устанавливаем флаг, что мы внутри слова
    jmp next_char

is_delimiter:
    ; Текущий символ - разделитель
    mov edx, 0              ; Устанавливаем флаг, что мы вне слова
    jmp next_char

continue_word:
    ; Продолжаем в текущем слове

next_char:
    inc edi                 ; Переходим к следующему символу
    jmp count_loop          ; Продолжаем цикл

end_count:
    ; Конвертация количества слов в ASCII цифры
    mov eax, ebp            ; Число для конвертации
    mov edi, result         ; Буфер назначения
    mov ecx, 0              ; Счетчик цифр

    ; Обработка случая 0
    cmp eax, 0
    jne convert_loop
    mov byte [result], '0'
    mov byte [result+1], 0
    jmp show_result

convert_loop:
    ; Сначала получаем все цифры в обратном порядке
    mov edx, 0              ; Очищаем edx для деления
    mov ebx, 10             ; Делитель
    div ebx                 ; Делим eax на 10, остаток в edx

    add dl, '0'             ; Конвертируем цифру в ASCII
    push edx                ; Сохраняем цифру в стеке
    inc ecx                 ; Увеличиваем счетчик цифр
    
    test eax, eax           ; Проверяем, равен ли частное нулю
    jnz convert_loop        ; Если нет, продолжаем

    ; Теперь выталкиваем цифры в правильном порядке
    mov edi, result         ; Сбрасываем указатель назначения

digit_to_string:
    pop eax                 ; Получаем цифру
    mov [edi], al           ; Сохраняем цифру в буфере
    inc edi                 ; Следующая позиция
    dec ecx                 ; Уменьшаем счетчик
    jnz digit_to_string     ; Если еще есть цифры, продолжаем

    mov byte [edi], 0       ; Добавляем нулевой символ

show_result:
    ; Выводим сообщение с результатом
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, result_msg     ; сообщение
    mov edx, result_len     ; длина
    int 0x80

    ; Вычисляем длину строки результата
    mov edx, 0              ; Счетчик длины
length_loop:
    cmp byte [result + edx], 0  ; Проверяем на нулевой символ
    je length_done
    inc edx                     ; Увеличиваем длину
    jmp length_loop

length_done:
    ; Выводим количество слов
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, result         ; строка с числом
    ; edx уже содержит длину
    int 0x80

    ; Выводим перевод строки
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, newline        ; символ перевода строки
    mov edx, 1              ; длина
    int 0x80

    ; Выход
    mov eax, 1              ; sys_exit
    xor ebx, ebx            ; статус 0
    int 0x80

; Добавление для предотвращения предупреждения о исполняемом стеке
section .note.GNU-stack noalloc noexec nowrite progbits
