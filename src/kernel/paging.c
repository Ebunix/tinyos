#include <kernel/memory/paging.h>
#include <kernel/vgavideo.h>

extern PageMapLevel4Entry* page_table_l4;
extern PageDirPointerTablePageDirEntry* page_table_l3;
extern PageDirPageTableEntry* page_table_l2;
extern PageTableEntry* page_table_l1;

size_t varaddr(void* p) {
    return (size_t)p;
}

void page_map_init() {
    vga_puts("Paging Setup\n");
    vga_puts("Page Table Level 4 location: ");
    vga_put_hex((uint64_t)&page_table_l4);
    vga_putc('\n');
    vga_puts("Page Table Level 3 location: ");
    vga_put_hex((uint64_t)&page_table_l3);
    vga_putc('\n');
    vga_puts("Page Table Level 2 location: ");
    vga_put_hex((uint64_t)&page_table_l2);
    vga_putc('\n');
    vga_puts("Page Table Level 1 location: ");
    vga_put_hex((uint64_t)&page_table_l1);
    vga_putc('\n');
}
