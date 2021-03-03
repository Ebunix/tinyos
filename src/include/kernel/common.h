#ifndef _KERNEL_COMMON_H_
#define _KERNEL_COMMON_H_
#include <kernel/stdint.h>

#define PAGE_SIZE 4096
#define ALIGN(x) __attribute__((__aligned__(x)))
#define ALIGN_PAGE ALIGN(PAGE_SIZE)

extern void* _text;

typedef struct {
	uint16_t size;
	uint64_t address;
} TableDescriptor;

static inline void* pointer_fixup(void* ptr) {
    return (void*)(ptr - _text);
}

#endif