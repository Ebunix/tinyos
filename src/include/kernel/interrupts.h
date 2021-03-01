#ifndef _KERNEL_INTERRUPTS_H_
#define _KERNEL_INTERRUPTS_H_
#include <kernel/stdint.h>

typedef struct {
    uint16_t stack_table_id : 3;
    uint16_t reserved : 5;
    uint16_t gate : 1;
    uint16_t one : 3;
    uint16_t zero : 1;
    uint16_t dpl : 2;
    uint16_t present : 1;
} __attribute__((__packed__)) InterruptOptions;

typedef struct {
    uint16_t func_ptr1;
    uint16_t gdt_selector;
    InterruptOptions options;
    uint16_t func_ptr2;
    uint32_t func_ptr3;
    uint32_t reserved;
} InterruptDescriptor;

void interrupts_initialize();

#endif
