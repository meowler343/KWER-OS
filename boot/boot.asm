[bits 16]
[org 0x7c00]

start:
    ; 1. Приветствие (твой прошлый код)
    mov si, msg
    call print

    ; 2. Инициализация мыши (Windows 1.0 Style)
    mov ax, 0           ; Функция 0: Сброс/Проверка мыши
    int 0x33
    cmp ax, 0           ; Если AX = 0, мыши нет
    je no_mouse

    ; 3. Показать курсор
    mov ax, 1           ; Функция 1: Показать курсор на экране
    int 0x33

no_mouse:
    ; 4. Переход к ядру Rust (nr)
    ; В будущем здесь будет код загрузки секторов с диска
    jmp $               ; Пока просто висим и смотрим на курсор

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

msg db 'Welcome to KWER-OS! Mouse Initialized...', 0

times 510-($-$$) db 0
dw 0xaa55
