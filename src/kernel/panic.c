#include <kernel/panic.h>
#include <kernel/vgavideo.h>

// both defined in main.asm
const char* panic_message_oops = "\n"
"     /$$$$$$                                /$$\n"
"    /$$__  $$                              | $$\n"
"   | $$  \\ $$  /$$$$$$   /$$$$$$   /$$$$$$$| $$\n"
"   | $$  | $$ /$$__  $$ /$$__  $$ /$$_____/| $$\n"
"   | $$  | $$| $$  \\ $$| $$  \\ $$|  $$$$$$ |__/\n"
"   | $$  | $$| $$  | $$| $$  | $$ \\____  $$    \n"
"   |  $$$$$$/|  $$$$$$/| $$$$$$$/ /$$$$$$$/ /$$\n"
"    \\______/  \\______/ | $$____/ |_______/ |__/\n"
"                       | $$                    \n"
"    Kernel Panic!      | $$                    \n"
"    System halted.     |__/                    \n"
"\n";
extern void hang();
extern void dump(uint64_t* regs);

char* reg_names[] = {
    "EAX",
    "EBX",
    "ECX",
    "EDX",
    "ESI",
    "EDI",
    "ESP",
    "EIP"
};

void panic() {
    vga_puts(panic_message_oops);
    uint64_t reg[10];
    dump(reg);

    int offset = 0;
    for(int i = 0; i < 8; i++) {
        if (i == 6) {
            offset++;
        }
        vga_pos(52, 2+i+offset);
        vga_puts(reg_names[i]);
        vga_putc(' ');
        vga_put_hex(&reg[i], 8);
    }

    hang();
}