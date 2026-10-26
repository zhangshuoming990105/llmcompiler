#include "../check.h"
struct Item { char tag; int value; long weight; };
long score_items(const struct Item *, int);
long reference(const struct Item *, int);
int main(void) {
    for (int trial = 0; trial < 500; ++trial) {
        struct Item items[32], before[32];
        memset(items, 0, sizeof items);
        for (int i = 0; i < 32; ++i) {
            items[i].tag = (char)(next_random() % 3u);
            items[i].value = (int)(next_random() % 2001u) - 1000;
            items[i].weight = (long)(next_random() % 200001u) - 100000;
        }
        memcpy(before, items, sizeof items);
        int n = trial % 33;
        long expected = reference(items, n);
        CHECK(score_items(items, n) == expected);
        CHECK(memcmp(items, before, sizeof items) == 0);
    }
    return finish();
}
