DIR_BUILD := build
DIR_DIST := dist

LD := x86_64-elf-ld
ARCH := x86_64
ISO := $(DIR_DIST)/$(ARCH)/build.iso
KERNEL := $(DIR_DIST)/$(ARCH)/kernel.bin

asm_src := $(shell find src/impl/$(ARCH) -name *.asm)
asm_obj := $(patsubst src/impl/$(ARCH)/%.asm, $(DIR_BUILD)/$(ARCH)/%.o, $(asm_src))

build: $(asm_obj)
	mkdir -p $(DIR_DIST)/$(ARCH)
	$(LD) -n -o $(KERNEL) -T targets/$(ARCH)/linker.ld $(asm_obj)

iso: $(ISO)

$(asm_obj): $(DIR_BUILD)/$(ARCH)/%.o : src/impl/$(ARCH)/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst $(DIR_BUILD)/$(ARCH)/%.o, src/impl/$(ARCH)/%.asm, $@) -o $@

$(ISO): build
	cp $(KERNEL) targets/$(ARCH)/iso/boot/kernel.bin
	grub-mkrescue /usr/lib/grub/i386-pc -o $(ISO) targets/$(ARCH)/iso

.PHONY: run clean

run: $(ISO)
	qemu-system-x86_64 -cdrom $(ISO)

clean:
	rm -rf $(DIR_BUILD)
	rm -rf $(DIR_DIST)