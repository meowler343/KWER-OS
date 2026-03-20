[bits 16]
[org 0x7c00]

start:
    mov si, msg
    call print

    ; Инициализация мыши
    xor ax, ax
    int 0x33
    test ax, ax
    jz .no_mouse

    ; Сохраняем начальные координаты (пусть будут 0, 0)
    xor bx, bx ; BX будет хранить прошлую позицию (BH - строка, BL - колонка)

.mouse_loop:
    ; 1. Стираем старый '$' (рисуем пробел в старой позиции)
    mov ah, 0x02
    int 0x10       ; Ставим курсор туда, где был $
    mov ah, 0x0e
    mov al, ' '    ; Рисуем пробел поверх старого $
    int 0x10

    ; 2. Получаем НОВЫЕ координаты
    mov ax, 3
    int 0x33       ; CX = X, DX = Y
    shr cx, 3      ; Пиксели -> Колонки
    shr dx, 3      ; Пиксели -> Строки

    ; 3. Сохраняем новую позицию в BX для следующего цикла
    mov bh, dl     ; Строка
    mov bl, cl     ; Колонка

    ; 4. Рисуем '$' в новой позиции
    mov ah, 0x02
    mov dh, bh
    mov dl, bl
    int 0x10
    mov ah, 0x0e
    mov al, '$'
    int 0x10

    ; Небольшая пауза, чтобы не мерцало
    mov ah, 0x86
    mov cx, 0x00
    mov dx, 0x4000 ; Уменьшил задержку для плавности
    int 0x15

    jmp .mouse_loop

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

msg db 'KWER-OS: Mouse Active ($)', 13, 10, 0

times 510-($-$$) db 0
dw 0xaa55
