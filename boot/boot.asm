[bits 16]
[org 0x7c00]

start:
    mov si, msg
    call print

    ; 1. Инициализация мыши
    xor ax, ax
    int 0x33
    test ax, ax
    jz .no_mouse

.mouse_loop:
    ; 2. Получаем координаты мыши
    mov ax, 3          ; Функция 3: Получить позицию и статус кнопок
    int 0x33           ; CX = X, DX = Y

    ; 3. Пересчитываем координаты из пикселей в текстовые колонки (делим на 8)
    shr cx, 3          ; CX / 8 (колонки)
    shr dx, 3          ; DX / 8 (строки)

    ; 4. Устанавливаем курсор BIOS в эту позицию
    mov ah, 0x02
    mov bh, 0
    int 0x10

    ; 5. Рисуем наш символ курсора '$'
    mov ah, 0x0e
    mov al, '$'
    int 0x10

    ; 6. Небольшая задержка, чтобы не мерцало слишком сильно
    mov cx, 0x01
    mov dx, 0x86a0     ; Примерно 0.1 сек
    mov ah, 0x86
    int 0x15

    jmp .mouse_loop    ; Повторяем бесконечно

.no_mouse:
    jmp $

print:
    mov ah, 0x0e
.loop:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

msg db 'Welcome to KWER-OS! Mouse: $', 0

times 510-($-$$) db 0
dw 0xaa55
