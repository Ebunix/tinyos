#ifndef _KERNEL_VGA_H_
#define _KERNEL_VGA_H_

typedef struct {
    char fg;
    char bg;
} vga_char;

void vga_clear(char c);
void vga_putc(char c);
void vga_puts(const char* c);
void vga_pos(int x, int y);
void vga_scroll(int lines);

#endif