LD := x86_64-elf-ld
ARCH := x86_64

asm_src := $(shell find src/impl/$(ARCH) -name *.asm)
asm_obj := $(patsubst src/impl/$(ARCH)/%.asm, build/$(ARCH)/%.o, $(asm_src))

build: $(asm_obj)
	mkdir -p dist/$(ARCH)
	$(LD) -n -o dist/$(ARCH)/kernel.bin -T targets/$(ARCH)/linker.ld $(asm_obj)
	cp dist/$(ARCH)/kernel.bin targets/$(ARCH)/iso/boot/kernel.bin
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/$(ARCH)/kernel.iso targets/$(ARCH)/iso

$(asm_obj): build/$(ARCH)/%.o : src/impl/$(ARCH)/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/$(ARCH)/%.o, src/impl/$(ARCH)/%.asm, $@) -o $@
