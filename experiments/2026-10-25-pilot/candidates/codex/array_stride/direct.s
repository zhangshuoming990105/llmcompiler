.text
.p2align 2
.globl _update_stride
_update_stride:
    mov w4, wzr
    cmp w1, #0
    b.le Lupdate_stride_done
    mov w5, wzr
Lupdate_stride_loop:
    mul w6, w5, w2
    add x9, x0, w6, sxtw #2
    ldr w7, [x9]
    tbnz w7, #31, Lupdate_stride_next
    add w7, w7, w3
    str w7, [x9]
    add w8, w5, #1
    madd w4, w7, w8, w4
Lupdate_stride_next:
    add w5, w5, #1
    cmp w5, w1
    b.lt Lupdate_stride_loop
Lupdate_stride_done:
    mov w0, w4
    ret
