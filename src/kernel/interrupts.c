#include <kernel/interrupts.h>
#include <kernel/panic.h>
#include <kernel/common.h>
#include <kernel/vgavideo.h>
#include <kernel/memory/memory.h>

InterruptDescriptor global_idt[NUM_IDT_ENTRIES] ALIGN_PAGE;
TableDescriptor global_idt_desc = {
    .size = (NUM_IDT_ENTRIES * sizeof(InterruptDescriptor)) - 1,
    .address = 0xabacabac
};

extern void load_idt(void* addr);

void interrupt_handler() {
    panic();
}

InterruptDescriptor build_descriptor(void* func) {
    uint64_t addr = (uint64_t)func;

    vga_put_hex((uint64_t)&interrupt_handler);
    vga_putc('\n');
    vga_put_hex((uint64_t)func);
    vga_putc('\n');
    vga_put_hex((uint64_t)_text);
    vga_putc('\n');
    vga_put_hex((uint64_t)pointer_fixup(func));
    vga_putc('\n');

    InterruptDescriptor desc;
    memset(&desc, 0, sizeof(InterruptDescriptor));

    desc.func_ptr1 = addr & 0xFFFF;
    desc.func_ptr2 = (addr >> 16) & 0xFFFF;
    desc.func_ptr3 = addr >> 32;
    desc.options.present = 1;
    desc.options.one = 0b111;
    desc.gdt_selector = 8;
    desc.reserved = 0;

    return desc;
}

void interrupts_initialize() {
    for(int i = 0; i < NUM_IDT_ENTRIES; i++) {
        global_idt[i] = build_descriptor(interrupt_handler);
    }
    load_idt(&global_idt_desc);
}