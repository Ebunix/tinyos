global long_mode_start
global hang 
global dump
global load_idt
global divide_zero

extern kmain
extern idt

section .text
bits 64
long_mode_start:
    ; load 0 into all data segment registers
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call kmain

hang:
    cli
    hlt
    jmp $

load_idt:
    lidt [idt]
    ret

divide_zero:
    mov eax, 0xFFFF
    mov ebx, 0
    div ebx
    ret

dump:
    mov [eax], eax
    mov [eax+8], ebx
    mov [eax+16], ecx
    mov [eax+24], edx
    mov [eax+32], esi
    mov [eax+40], edi
    
    mov [eax+48], esp
    ret
