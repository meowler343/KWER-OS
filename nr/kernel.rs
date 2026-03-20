#![no_std] // Мы не используем стандартную библиотеку Rust
#![no_main] // У нас нет обычной функции main, точку входа укажем сами

use core::panic::PanicInfo;

// Эта функция вызывается при панике (ошибке) ядра
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

// Точка входа в моё ядро (вызывается загрузчиком boot.asm)
#[no_mangle]
pub extern "C" fn _start() -> ! {
    // Здесь будет магия управления KWER-OS
    let vga_buffer = 0xb8000 as *mut u8;

    unsafe {
        // Выведем букву 'K' (из KWER-OS) прямо в видеопамять
        *vga_buffer = b'K';
        *(vga_buffer.offset(1)) = 0x0b; // Ярко-голубой цвет (мой любимый хром)
    }

    loop {}
}
