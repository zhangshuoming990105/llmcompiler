.text
.p2align 2
.globl _scoped_sum
_scoped_sum:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #32
    str w0, [sp, #0]

# block b000 (DeclStmt)
mov w8, #0
str w8, [sp, #4]

# block b001 (ForStmt)
mov w8, #0
str w8, [sp, #8]
L_scoped_sum_b001_outer_test:
ldr w8, [sp, #8]
ldr w9, [sp, #0]
cmp w8, w9
b.ge L_scoped_sum_b001_done
add w10, w8, #2
str w10, [sp, #12]
mov w11, #0
str w11, [sp, #16]
L_scoped_sum_b001_inner_test:
ldr w11, [sp, #16]
ldr w10, [sp, #12]
cmp w11, w10
b.ge L_scoped_sum_b001_inner_done
ldr w12, [sp, #4]
add w12, w12, w11
str w12, [sp, #4]
add w11, w11, #1
str w11, [sp, #16]
b L_scoped_sum_b001_inner_test
L_scoped_sum_b001_inner_done:
ldr w8, [sp, #8]
add w8, w8, #1
str w8, [sp, #8]
b L_scoped_sum_b001_outer_test
L_scoped_sum_b001_done:

# block b002 (ReturnStmt)
ldr w0, [sp, #4]
ldr w1, [sp, #0]
add w0, w0, w1
b L_scoped_sum_return
L_scoped_sum_return:
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    ret
