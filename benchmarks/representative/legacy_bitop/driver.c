#include "../check.h"
int apply_binary_operation_on_byte(int, int, int);
int reference(int, int, int);
int main(void) {
    int values[] = {'0', '1', '?', 0, -1, 255};
    for (int i = 0; i < 6; ++i)
        for (int j = 0; j < 6; ++j)
            for (int op = -1; op <= 4; ++op)
                CHECK(apply_binary_operation_on_byte(values[i], values[j], op) == reference(values[i], values[j], op));
    return finish();
}
