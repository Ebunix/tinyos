add-symbol-file dist/x86_64/kernel.bin 0x10000000
target remote | qemu-system-x86_64 -S -s -cdrom dist/x86_64/build.iso