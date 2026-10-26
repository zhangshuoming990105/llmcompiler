#include "../check.h"
int gcd(int, int);
int reference(int, int);
int main(void) {
    for (int a = -32; a <= 32; ++a)
        for (int b = -32; b <= 32; ++b)
            CHECK(gcd(a, b) == reference(a, b));
    for (int i = 0; i < 1000; ++i) {
        int a = (int)(next_random() % 200001u) - 100000;
        int b = (int)(next_random() % 200001u) - 100000;
        CHECK(gcd(a, b) == reference(a, b));
    }
    return finish();
}
