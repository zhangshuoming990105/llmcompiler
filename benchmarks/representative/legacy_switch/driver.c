#include "../check.h"
int color_char_to_attr(char);
int reference(char);
int main(void) {
    for (int i = 0; i < 128; ++i)
        CHECK(color_char_to_attr((char)i) == reference((char)i));
    return finish();
}
