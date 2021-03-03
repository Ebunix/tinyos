add-symbol-file dist/x86_64/kernel.bin
set disassembly-flavor intel
target remote :1234
b load_idt
c