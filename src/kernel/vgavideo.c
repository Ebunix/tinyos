#include <kernel/vgavideo.h>
#include <kernel/memory.h>
#include <kernel/string.h>

vga_char* vga_memory = (vga_char*)0xb8000;
int vga_x = 0;
int vga_y = 0;
char vga_bg = 0x0F;

void vga_clear(char c) {
    vga_pos(0, 0);
    char prev = vga_bg;
    vga_bg = c;
    for(int i = 0; i < 25*80; i++) {
        vga_putc(' ');
    }
    vga_bg = prev;
    vga_pos(0, 0);
}

void vga_pos(int x, int y) {
    vga_x = x;
    vga_y = y;
    if (vga_x >= 80) {
        vga_x = 79;
    }
    if (vga_y >= 25) {
        vga_y = 24;
    }
}

void vga_scroll(int lines) {
    vga_y -= lines;
}

void __vga_advance() {
    vga_x++;
    if (vga_x >= 80) {
        vga_x = 0;
        vga_y++;
    }
    if (vga_y >= 25) {
        vga_scroll(1);
    }
}

int __vga_current_pos() {
    return (vga_x + vga_y * 80);
}

void __vga_putc(vga_char c) {
    vga_memory[__vga_current_pos()] = c;
    __vga_advance();
}

void vga_putc(char c) {
    if (c == '\n') {
        vga_pos(0, vga_y + 1);
        return;
    }
    else if (c == '\r') {
        vga_pos(0, vga_y);
        return;
    }
    vga_char vc;
    vc.bg = vga_bg;
    vc.fg = c;
    __vga_putc(vc);
}

void vga_puts(const char* str) {
    for(size_t i = 0; i < strlen(str); i++) {
        vga_putc(str[i]);
    }
}