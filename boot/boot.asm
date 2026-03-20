[bits 16]
[org 0x7c00]

start:
    ; 1. Приветствие
    mov si, msg
    call print

    ; 2. Инициализация мыши (Windows 1.0 Style)
    xor ax, ax          ; Функция 0: Сброс мыши
    int 0x33
    
    ; 3. Показать курсор принудительно
    mov ax, 1           ; Функция 1: Показать курсор
    int 0x33

    ; 4. Бесконечный цикл (пока не настроим прыжок на ядро nr)
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

msg db 'Welcome to KWER-OS! Mouse Ready...', 0

times 510-($-$$) db 0
dw 0xaa55
