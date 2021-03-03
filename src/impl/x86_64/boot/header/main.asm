global start
global page_table_l4
global page_table_l3
global page_table_l2
global page_table_l1

extern long_mode_start

section .text
bits 32

start: 
    ; Initialize kernel stack
    mov esp, stack_top

    call check_multiboot
    call check_cpuid
    call check_long_mode

    call setup_page_tables
    call enable_paging

    lgdt [gdt64.pointer]
    jmp gdt64.code_segment:long_mode_start

check_multiboot:
    cmp eax, 0x36D76289
    jne err_no_multiboot
    ret

; If we can flip the ID bit of the flags register
; then cpuid is supported on this processor. 
; Since this is needed for 64-bit support, this check has to pass,
; otherwise we can't boot :D
check_cpuid:
    ; Move flags register into eax
    pushfd
    pop eax
    mov ecx, eax ; copy for later comparison
    xor eax, 1 << 21 ; set ID bit (bit 21)

    ; set flags register and read it back
    push eax
    popfd
    pushfd
    pop eax

    ; Restore original flags from ecx 
    push ecx
    popfd

    ; did the register change? If yes, bail
    cmp eax, ecx
    je err_no_cpuid
    ret

check_long_mode:
    ; check for extended processor info functionality
    mov eax, 0x80000000 ; magic
    cpuid ; returns a value greater than 0x80000000 if EPI is supported
    cmp eax, 0x80000000
    jng err_no_long_mode

    ; check if long mode is available
    mov eax, 0x80000001 ; magic
    cpuid
    test edx, 1 << 29 ; cpuid returns value in edx, bit 29 indicates whether long mode is available
    jz err_no_long_mode
    ret

setup_page_tables:
    ; Identity mapping so we can continue executing
    mov eax, page_table_l3
    or eax, 0b11 ; present, writeable
    mov [page_table_l4], eax

    mov eax, page_table_l2
    or eax, 0b11 ; present, writeable
    mov [page_table_l3], eax

    mov eax, page_table_l1
    or eax, 0b11 ; present, writeable
    mov [page_table_l2], eax
    
    ; identity map first 2 MiB
    mov ecx, 0
.loop:
    mov eax, 0x1000
    mul ecx
    or eax, 0b11
    mov [page_table_l1 + ecx * 8], eax
    inc ecx
    cmp ecx, 512
    jne .loop    
    ret

enable_paging:
    ; Store page table location in controll register
    mov eax, page_table_l4
    mov cr3, eax

    ; following code sets up the CPU to use 4-level paging
    ; CR4.PAE = 1
    ; CR4.LA57 = 0
    ; IA_32_EFER.LME = 1

    ; enable PAE
    mov eax, cr4
    or eax, 1 << 5 ; PAE bit (CR4.PAE)
    mov cr4, eax

    ; enable long mode
    mov ecx, 0xC0000080 ; magic
    rdmsr
    or eax, 1 << 8 ; long mode enable bit (IA32_EFER.LME)
    wrmsr

    ; enable paging
    mov eax, cr0
    or eax, 1 << 31 ; paging bit
    mov cr0, eax

    ret

err_no_multiboot:
    mov edx, msg_no_multiboot
    jmp error

err_no_cpuid:
    mov edx, msg_no_cpuid
    jmp error

err_no_long_mode:
    mov edx, msg_no_long_mode
    jmp error

error:
    xor eax, eax
.cls:
    mov word [0xb8000 + eax * 2], 0x4F00
    inc eax
    cmp eax, 25*80
    jl error.cls

    xor ebx, ebx
    lea esi, [panic_message_oops]
    call print
    add ebx, 3
    lea esi, [edx]
    call print
    jmp hang

print:
    xor eax, eax
.loop:
    lodsb
    cmp ax, 0
    jz print.done

    mov cx, word [0xb8000 + ebx * 2]
    or cx, ax
    mov word [0xb8000 + ebx * 2], cx
    inc ebx

    jmp print.loop

.done:
    ret

hang:
    hlt
    jmp $ ; In case hlt doesn't do its job



section .bss

align 4096
page_table_l4:
    resb 4096
page_table_l3:
    resb 4096
page_table_l2:
    resb 4096
page_table_l1:
    resb 4096
    
stack_bottom:
    resb 4096 * 4 ; reserve 16k of stack space for now
stack_top:

section .rodata

gdt64:
    dq 0
.code_segment: equ $ - gdt64
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53) ; code segment (Executable, code, present, 64 bit)
.pointer: 
    dw $ - gdt64 - 1
    dq gdt64

msg_no_long_mode: db "This processor does not support long mode (64-bit operation)!", 0
msg_no_cpuid: db "This processor does not support the cpuid instruction!", 0
msg_no_multiboot: db "Not loaded by a multiboot2 bootloader! How did we even get here?", 0 ; Good question
panic_message_oops: db \
"                                                                                ", \
"   ",219,219,219,219,219,219,187,"  ",219,219,219,219,219,219,187," ",219,219,219,219,219,219,187," ",219,219,219,219,219,219,219,187,219,219,187,"                                         ", \
"  ",219,219,201,205,205,205,219,219,187,219,219,201,205,205,205,219,219,187,219,219,201,205,205,219,219,187,219,219,201,205,205,205,205,188,219,219,186,"                                         ", \
"  ",219,219,186,"   ",219,219,186,219,219,186,"   ",219,219,186,219,219,219,219,219,219,201,188,219,219,219,219,219,219,219,187,219,219,186,"                                         ", \
"  ",219,219,186,"   ",219,219,186,219,219,186,"   ",219,219,186,219,219,201,205,205,205,188," ",200,205,205,205,205,219,219,186,200,205,188,"                                         ", \
"  ",200,219,219,219,219,219,219,201,188,200,219,219,219,219,219,219,201,188,219,219,186,"     ",219,219,219,219,219,219,219,186,219,219,187,"                                         ", \
"   ",200,205,205,205,205,205,188,"  ",200,205,205,205,205,205,188," ",200,205,188,"     ",200,205,205,205,205,205,205,188,200,205,188,"                                         ", \
"                                                                                ", 0