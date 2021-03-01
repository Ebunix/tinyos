#include <kernel/interrupts.h>
#include <kernel/panic.h>

extern InterruptDescriptor* __idt_ptr;
extern void load_idt(); // see main64.asm
const int interrupt_table_count = 0xFF;

InterruptDescriptor build_descriptor(void* func) {
    uint64_t addr = (uint64_t)func;

    InterruptDescriptor desc;

    desc.func_ptr1 = addr & 0xFFFF;
    desc.func_ptr2 = (addr >> 16) & 0xFFFF;
    desc.func_ptr3 = addr >> 32;
    desc.options.present = 1;
    desc.options.one = 0b111;
    desc.gdt_selector = 8;
    desc.reserved = 0;

    return desc;
}

void interrupt_handler() {
    panic();
}

void interrupts_initialize() {
    for(int i = 0; i < interrupt_table_count; i++) {
        __idt_ptr[i] = build_descriptor(interrupt_handler);
    }
    load_idt();
}