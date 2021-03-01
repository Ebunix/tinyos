add-symbol-file dist/x86_64/kernel.bin
set disassembly-flavor intel
target remote :1234
b enable_paging
c
p (char*)page_table_l4
p (char*)page_table_l3
p (char*)page_table_l2
p (char*)page_table_l1
dump memory memdump 0 0x1fffff

b page_map_init
c