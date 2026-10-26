.text
.p2align 2
.globl _scoped_sum
_scoped_sum:
    mov w1, wzr
    mov w2, wzr
Lscoped_sum_outer_check:
    cmp w2, w0
    b.ge Lscoped_sum_done
    add w3, w2, #2
    mov w4, wzr
Lscoped_sum_inner_check:
    cmp w4, w3
    b.ge Lscoped_sum_inner_done
    add w1, w1, w4
    add w4, w4, #1
    b Lscoped_sum_inner_check
Lscoped_sum_inner_done:
    add w2, w2, #1
    b Lscoped_sum_outer_check
Lscoped_sum_done:
    add w0, w1, w0
    ret
