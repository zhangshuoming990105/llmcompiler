#include <stdio.h>
#include <stdint.h>
#include <string.h>

static unsigned checks, failures;
static uint32_t state = 20261025u;
static uint32_t next_random(void) {
    state = state * 1664525u + 1013904223u;
    return state;
}
#define CHECK(condition) do { \
    ++checks; \
    if (!(condition)) { \
        if (failures++ == 0) fprintf(stderr, "First mismatch at %s:%d, check %u\n", __FILE__, __LINE__, checks); \
    } \
} while (0)
static int finish(void) {
    printf("{\"checks\":%u,\"failures\":%u}\n", checks, failures);
    return failures != 0;
}
