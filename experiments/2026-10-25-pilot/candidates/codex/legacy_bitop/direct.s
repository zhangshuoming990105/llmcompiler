.text
.p2align 2
.globl _apply_binary_operation_on_byte
_apply_binary_operation_on_byte:
    cbz w2, L_or
    cmp w2, #1
    b.eq L_and
    cmp w2, #2
    b.eq L_xor
    mov w0, #63
    ret

L_or:
    cmp w0, #49
    cset w8, eq
    cmp w1, #49
    cset w9, eq
    orr w8, w8, w9
    add w0, w8, #48
    ret

L_and:
    cmp w0, #49
    cset w8, eq
    cmp w1, #49
    cset w9, eq
    and w8, w8, w9
    add w0, w8, #48
    ret

L_xor:
    cmp w0, #48
    cset w8, eq
    cmp w1, #49
    cset w9, eq
    and w8, w8, w9
    cmp w0, #49
    cset w9, eq
    cmp w1, #48
    cset w10, eq
    and w9, w9, w10
    orr w8, w8, w9
    add w0, w8, #48
    ret
