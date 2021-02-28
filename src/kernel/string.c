#include <kernel/string.h>

size_t strlen(const char* str) {
    size_t ln = 0;
    while(str[ln]) ln++;
    return ln;
}