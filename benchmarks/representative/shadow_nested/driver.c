#include "../check.h"
int scoped_sum(int);
int reference(int);
int main(void) {
    for (int n = -8; n <= 64; ++n)
        CHECK(scoped_sum(n) == reference(n));
    return finish();
}
