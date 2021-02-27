ENTRY(start)

SECTIONS 
{
    . = 1M;

    .text :
    {  
        . = ALIGN(8);
        KEEP(*(.multiboot))
        *(.text)
    }
}