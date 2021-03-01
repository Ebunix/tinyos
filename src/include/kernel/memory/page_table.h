#ifndef _KERNEL_PAGE_TABLE_H_
#define _KERNEL_PAGE_TABLE_H_
#include <kernel/stdint.h>

typedef struct
{
  uint64_t present                   :1;
  uint64_t writeable                 :1;
  uint64_t user_access               :1;
  uint64_t write_through             :1;
  uint64_t cache_disabled            :1;
  uint64_t accessed                  :1;
  uint64_t ignored_3                 :1;
  uint64_t size                      :1; // must be 0
  uint64_t ignored_2                 :4;
  uint64_t phys_addr                 :28;
  uint64_t reserved_1                :12; // must be 0
  uint64_t ignored_1                 :11;
  uint64_t execution_disabled        :1;
} __attribute__((__packed__)) PageMapLevel4Entry;

typedef struct 
{
  uint64_t present                   :1;
  uint64_t writeable                 :1;
  uint64_t user_access               :1;
  uint64_t write_through             :1;
  uint64_t cache_disabled            :1;
  uint64_t accessed                  :1;
  uint64_t ignored_3                 :1;
  uint64_t size                      :1; // 0 means page directory mapped
  uint64_t ignored_2                 :4;
  uint64_t phys_addr                 :28;
  uint64_t reserved_1                :12; // must be 0
  uint64_t ignored_1                 :11;
  uint64_t execution_disabled        :1;
} __attribute__((__packed__)) PageDirPointerTablePageDirEntry;

typedef struct 
{
  uint64_t present                   :1;
  uint64_t writeable                 :1;
  uint64_t user_access               :1;
  uint64_t write_through             :1;
  uint64_t cache_disabled            :1;
  uint64_t accessed                  :1;
  uint64_t ignored_3                 :1;
  uint64_t size                      :1; // 0 means page table mapped
  uint64_t ignored_2                 :4;
  uint64_t phys_addr                 :28;
  uint64_t reserved_1                :12; // must be 0
  uint64_t ignored_1                 :11;
  uint64_t execution_disabled        :1;
} __attribute__((__packed__)) PageDirPageTableEntry;

typedef struct
{
  uint64_t present                   :1;
  uint64_t writeable                 :1;
  uint64_t user_access               :1;
  uint64_t write_through             :1;
  uint64_t cache_disabled            :1;
  uint64_t accessed                  :1;
  uint64_t dirty                     :1;
  uint64_t size                      :1;
  uint64_t global                    :1;
  uint64_t ignored_2                 :3;
  uint64_t phys_addr                 :28;
  uint64_t reserved_1                :12; // must be 0
  uint64_t ignored_1                 :11;
  uint64_t execution_disabled        :1;
} __attribute__((__packed__)) PageTableEntry;

#define PAGE_TABLE_ENTRY_COUNT 512

#endif