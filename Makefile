DIR_BUILD := build
DIR_DIST := dist
LD := x86_64-elf-ld
CC := x86_64-elf-gcc
ARCH := x86_64


ISO := $(DIR_DIST)/$(ARCH)/build.iso
KERNEL := $(DIR_DIST)/$(ARCH)/kernel.bin
TARGETS := targets/$(ARCH)
CCFLAGS := -g -Isrc/include -nostartfiles -nostdlib -ffreestanding

asm_src := $(shell find src/impl/$(ARCH) -name *.asm)
asm_obj := $(patsubst src/impl/$(ARCH)/%.asm, $(DIR_BUILD)/$(ARCH)/%.o, $(asm_src))

c_src := $(shell find src -name *.c)
c_obj := $(patsubst src/%.c, $(DIR_BUILD)/$(ARCH)/%.o, $(c_src))

build: $(asm_obj) $(c_obj)
	mkdir -p $(DIR_DIST)/$(ARCH)
	$(LD) -n -o $(KERNEL) -T $(TARGETS)/linker.ld $(asm_obj) $(c_obj)

iso: $(ISO)

$(asm_obj): $(DIR_BUILD)/$(ARCH)/%.o : src/impl/$(ARCH)/%.asm
	mkdir -p $(dir $@)
	nasm -f elf64 $(patsubst $(DIR_BUILD)/$(ARCH)/%.o, src/impl/$(ARCH)/%.asm, $@) -o $@

$(c_obj): $(DIR_BUILD)/$(ARCH)/%.o : src/%.c
	mkdir -p $(dir $@)
	$(CC) $(CCFLAGS) -o $@ -c $<

$(ISO): build
	cp $(KERNEL) $(TARGETS)/iso/boot/kernel.bin
	grub-mkrescue /usr/lib/grub/i386-pc -o $(ISO) $(TARGETS)/iso

.PHONY: run debug clean $(ISO)

run: $(ISO)
	qemu-system-x86_64 -cdrom $(ISO)

debug: $(ISO)
	qemu-system-x86_64 -S -s -cdrom dist/x86_64/build.iso

clean:
	rm -rf $(DIR_BUILD)
	rm -rf $(DIR_DIST)
	rm -rf $(TARGETS)/iso/boot/kernel.bin