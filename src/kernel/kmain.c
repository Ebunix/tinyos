#include <kernel/vgavideo.h>
#include <kernel/panic.h>
#include <kernel/paging.h>

void kmain() {
    // Hello C World!
    vga_clear(0x0F);
    vga_puts("Hello World, what a wonderful day it is!\n");
    page_map_init();
    panic();
}