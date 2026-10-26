.text
.p2align 2
.globl _update_stride
_update_stride:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #32
    str x0, [sp, #0]
    str w1, [sp, #8]
    str w2, [sp, #12]
    str w3, [sp, #16]

# block b000 (DeclStmt)
mov w8, #0
str w8, [sp, #20]

# block b001 (ForStmt)
ldr x0, [sp, #0]
ldr w1, [sp, #8]
ldr w2, [sp, #12]
ldr w3, [sp, #16]
ldr w4, [sp, #20]
mov w5, #0
L_update_stride_b001_loop:
cmp w5, w1
b.ge L_update_stride_b001_done
mul w6, w5, w2
add x7, x0, w6, sxtw #2
ldr w8, [x7]
cmp w8, #0
b.lt L_update_stride_b001_increment
add w8, w8, w3
str w8, [x7]
add w9, w5, #1
mul w10, w8, w9
add w4, w4, w10
L_update_stride_b001_increment:
add w5, w5, #1
b L_update_stride_b001_loop
L_update_stride_b001_done:
str w4, [sp, #20]
str w5, [sp, #24]

# block b002 (ReturnStmt)
ldr w0, [sp, #20]
b L_update_stride_return
L_update_stride_return:
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    ret
