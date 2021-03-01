#include <kernel/vgavideo.h>
#include <kernel/memory/paging.h>
#include <kernel/interrupts.h>

extern void hang();
extern void divide_zero();

void kmain() {
    // Hello C World!
    vga_clear(0x0F);
    vga_puts("Hello World, what a wonderful day it is!\n");
    page_map_init();
    interrupts_initialize();
    divide_zero();

    vga_puts("End of kmain, we'll hang now");
    hang();
}