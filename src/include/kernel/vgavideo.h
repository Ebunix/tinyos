#ifndef _KERNEL_VGA_H_
#define _KERNEL_VGA_H_

#include <kernel/stdint.h>

typedef struct {
    char fg;
    char bg;
} vga_char;

void vga_clear(char c);
void vga_putc(char c);
void vga_puts(const char* c);
void vga_pos(int x, int y);
void vga_scroll(int lines);
void vga_color(char color);
void vga_put_hex(uint64_t);

#endif