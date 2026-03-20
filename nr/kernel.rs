#![no_std]
#![no_main]

use core::panic::PanicInfo;

// Если ядро nr встретит критическую ошибку
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

// Точка входа для загрузчика (boot.asm)
#[no_mangle]
pub extern "C" fn _start() -> ! {
    let vga_buffer = 0xb8000 as *mut u8;

    unsafe {
        // Выводим символ 'n' из твоего ядра nr
        *vga_buffer = b'n';
        // Цвет: 0x0b (мой любимый яркий синий/голубой хром)
        *vga_buffer.offset(1) = 0x0b;
    }

    loop {}
}
