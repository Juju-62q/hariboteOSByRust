#![feature(lang_items)]
#![feature(start)]
#![no_std]
#![feature(asm)]


#[no_mangle]
#[start]
pub fn hari_main() {
    loop {}
}

#[lang = "eh_personality"]
extern fn eh_personality() {}

#[lang = "panic_fmt"]
extern fn panic_fmt() -> ! { loop {} }
