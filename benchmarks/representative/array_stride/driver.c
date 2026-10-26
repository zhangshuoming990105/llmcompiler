#include "../check.h"
int update_stride(int *, int, int, int);
int reference(int *, int, int, int);
int main(void) {
    for (int trial = 0; trial < 500; ++trial) {
        int a[80], b[80];
        for (int i = 0; i < 80; ++i) a[i] = (int)(next_random() % 81u) - 40;
        memcpy(b, a, sizeof a);
        int n = trial % 18;
        int stride = 1 + trial % 4;
        int bias = trial % 21 - 10;
        int expected = reference(b + 4, n, stride, bias);
        CHECK(update_stride(a + 4, n, stride, bias) == expected);
        CHECK(memcmp(a, b, sizeof a) == 0);
    }
    return finish();
}
