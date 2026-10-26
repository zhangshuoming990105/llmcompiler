#include "../../representative/check.h"
int nested_flow(int, int *);
int reference(int, int *);
int main(void) {
    for (int t=0; t<500; ++t) {
        int a[16], b[16];
        for (int j=0; j<16; ++j) a[j]=(int)(next_random()%81u)-40;
        memcpy(b,a,sizeof a);
        int expected=reference(t%17,b);
        CHECK(nested_flow(t%17,a)==expected);
        CHECK(memcmp(a,b,sizeof a)==0);
    }
    return finish();
}
