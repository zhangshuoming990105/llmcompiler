#include "../../representative/check.h"
unsigned int long_kernel(unsigned int *, int, unsigned int);
unsigned int reference(unsigned int *, int, unsigned int);
int main(void) {
    for (int trial=0; trial<100; ++trial) {
        unsigned int a[16], b[16];
        for (int j=0; j<16; ++j) a[j]=next_random();
        memcpy(b,a,sizeof a);
        unsigned int seed=next_random();
        int n=trial%9;
        unsigned int expected=reference(b+2,n,seed);
        CHECK(long_kernel(a+2,n,seed)==expected);
        CHECK(memcmp(a,b,sizeof a)==0);
    }
    return finish();
}
