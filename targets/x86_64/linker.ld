ENTRY(start)

SECTIONS 
{
    . = 1M;

    _text = .;
    .text :
    {  
        . = ALIGN(8);
        KEEP(*(.multiboot))
        *(.text)
    }
    
}