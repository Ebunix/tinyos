add-symbol-file dist/x86_64/kernel.bin
set disassembly-flavor intel
target remote :1234
b build_descriptor
c
n
n
n
n
n
n
n
n
n
