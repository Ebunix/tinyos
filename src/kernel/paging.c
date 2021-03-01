#include <kernel/paging.h>
#include <kernel/vgavideo.h>

const int page_table_entry_count = 512;
extern page_table_entry* page_table_l4;
extern page_table_entry* page_table_l3;
extern page_table_entry* page_table_l2;
extern page_table_entry* page_table_l1;

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
