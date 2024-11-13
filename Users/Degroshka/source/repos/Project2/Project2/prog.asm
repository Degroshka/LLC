.386
.model flat, stdcall
.stack 4096

.data
errorMessage db "Error: invalid character", 0  ; Сообщение об ошибке 

.code
CompressString proc source: PTR BYTE, dest: PTR BYTE
    ; Сохраняем регистры
    push esi
    push edi
    push ecx
    push ebx

    ; Инициализация переменных
    mov esi, source              ; esi указывает на начало исходной строки
    mov edi, dest                ; edi указывает на начало выходной строки
    xor ebx, ebx                 ; Используем ebx как "битовую маску" для уникальных символов

    ; Определяем длину строки (ищем конец)
    mov edx, esi                 ; Начало строки
find_end:
    cmp byte ptr [edx], 0
    je start_compression         ; Если достигнут конец строки
    inc edx
    jmp find_end

start_compression:
    dec edx                      ; edx теперь указывает на последний символ строки

reverse_loop:
    cmp edx, esi                 ; Проверяем, достигли ли начала строки
    jb end_compression           ; Если дошли до начала, завершаем цикл

    ; Получаем текущий символ
    mov al, byte ptr [edx]

    ; Проверка на буквы 'a'-'z'
    cmp al, 'a'
    jl check_uppercase           ; Переход к проверке заглавных букв, если символ меньше 'a'
    cmp al, 'z'
    jg check_uppercase           ; Переход к проверке заглавных букв, если символ больше 'z'

    ; Преобразуем символ в диапазон 0-25 и проверяем битовую маску
    sub al, 'a'
    bt ebx, eax
    jc skip_char                 ; Пропуск, если бит установлен (символ уже был)

    bts ebx, eax                 ; Устанавливаем бит для этого символа
    add al, 'a'                  ; Возвращаем символ к исходному значению
    mov byte ptr [edi], al       ; Записываем символ в выходную строку
    inc edi                      ; Увеличиваем указатель выходной строки
    jmp skip_char

check_uppercase:
    ; Проверка на буквы 'A'-'Z'
    cmp al, 'A'
    jl check_digits              ; Переход к проверке цифр, если символ меньше 'A'
    cmp al, 'Z'
    jg check_digits              ; Переход к проверке цифр, если символ больше 'Z'

    ; Преобразуем символ в диапазон 0-25 и проверяем битовую маску
    sub al, 'A'
    bt ebx, eax
    jc skip_char                 ; Пропуск, если бит установлен (символ уже был)

    bts ebx, eax                 ; Устанавливаем бит для этого символа
    add al, 'A'                  ; Возвращаем символ к исходному значению
    mov byte ptr [edi], al       ; Записываем символ в выходную строку
    inc edi                      ; Увеличиваем указатель выходной строки
    jmp skip_char

check_digits:
    ; Проверка на цифры '0'-'9'
    cmp al, '0'
    jl invalid_character         ; Переход к ошибке, если символ меньше '0'
    cmp al, '9'
    jg invalid_character         ; Переход к ошибке, если символ больше '9'

    ; Преобразуем символ в диапазон 26-35 и проверяем битовую маску
    sub al, '0'
    add al, 26                   ; Сдвигаем в диапазон 26-35
    bt ebx, eax
    jc skip_char                 ; Пропуск, если бит установлен (символ уже был)

    bts ebx, eax                 ; Устанавливаем бит для этого символа
    sub al, 26                   ; Возвращаем символ к исходному значению
    add al, '0'
    mov byte ptr [edi], al       ; Записываем символ в выходную строку
    inc edi                      ; Увеличиваем указатель выходной строки
    jmp skip_char

invalid_character:
    ; Устанавливаем сообщение об ошибке
    lea esi, errorMessage
    mov edi, dest
    copy_error_message:
        mov al, byte ptr [esi]
        mov byte ptr [edi], al
        inc esi
        inc edi
        cmp al, 0
        jne copy_error_message
    jmp end_compression

skip_char:
    dec edx                      ; Переход к следующему символу (справа налево)
    jmp reverse_loop

end_compression:
    ; Завершаем выходную строку нулевым байтом
    mov byte ptr [edi], 0

    ; Восстанавливаем регистры
    pop ebx
    pop ecx
    pop edi
    pop esi
    ret
CompressString endp

end
