#ifndef _KERNEL_PAGING_H_
#define _KERNEL_PAGING_H_
#include <kernel/stdint.h>

#define PAGE_PRESENT (1 << 0)
#define PAGE_WRITEABLE (1 << 1)
#define PAGE_USER_ACCESIBLE (1 << 2)
#define PAGE_WRITE_THROUGH (1 << 3)
#define PAGE_DISALE_CACHE (1 << 4)
#define PAGE_ACCESSED (1 << 5)
#define PAGE_DIRTY (1 << 6)
#define PAGE_HUGE (1 << 7)
#define PAGE_GLOBAL (1 << 8)
#define PAGE_USER_1 (0xE00)
#define PAGE_PHYS_ADDRESS (0xFFFFFFFFFF000)
#define PAGE_USER_2 (0x7FF0000000000000)
#define PAGE_NO_EXECUTE (1 << 63)

#define PAGE_GET_PHYS_ADDR(p) ((p & PAGE_PHYS_ADDRESS) >> 12)

typedef uint64_t page_table_entry; 

void page_map_init();

#endif