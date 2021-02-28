#include <kernel/memory.h>

void* memset(void* dst, int val, unsigned long long size) {
    char* cp = (char*)dst;
    for(unsigned long long i = 0; i < size; i++) {
        cp[i] = (char)val;
    }
    return dst;
}