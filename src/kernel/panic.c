#include <kernel/panic.h>
#include <kernel/vgavideo.h>

// both defined in main.asm
extern char* panic_message_oops;
extern void hang();

void panic() {
    vga_clear(0x4F);
    vga_puts(panic_message_oops);
    //hang();
    while(1);
}