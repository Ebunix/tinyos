#include <kernel/vgavideo.h>
#include <kernel/panic.h>

void kmain() {
    // Hello C World!
    vga_clear(0x0F);
    vga_puts("Hello, 64-bit C kernel world!\n");

    for(int i = 0; i < 100000000; i++) {
    }
    
    panic();
}