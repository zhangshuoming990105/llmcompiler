.text
.p2align 2
.globl _gcd
_gcd:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #16
    str w0, [sp, #0]
    str w1, [sp, #4]

# block b000 (DeclStmt)
// int lego_v2_r; uninitialized declaration

# block b001 (IfStmt)
ldr w0, [sp, #0]
cmp w0, #0
b.ge L_gcd_b001_end
ldr w0, [sp, #0]
neg w0, w0
str w0, [sp, #0]
L_gcd_b001_end:

# block b002 (IfStmt)
ldr w1, [sp, #4]
cmp w1, #0
b.ge L_gcd_b002_end
ldr w1, [sp, #4]
neg w1, w1
str w1, [sp, #4]
L_gcd_b002_end:

# block b003 (IfStmt)
ldr w1, [sp, #4]
ldr w0, [sp, #0]
cmp w1, w0
b.le L_gcd_b003_end
ldr w0, [sp, #0]
str w0, [sp, #12]
ldr w1, [sp, #4]
str w1, [sp, #0]
ldr w2, [sp, #12]
str w2, [sp, #4]
L_gcd_b003_end:

# block b004 (WhileStmt)
L_gcd_b004_cond:
ldr w1, [sp, #4]
cmp w1, #0
b.eq L_gcd_b004_end
ldr w0, [sp, #0]
ldr w1, [sp, #4]
sdiv w2, w0, w1
msub w2, w2, w1, w0
str w2, [sp, #8]
ldr w1, [sp, #4]
str w1, [sp, #0]
ldr w2, [sp, #8]
str w2, [sp, #4]
b L_gcd_b004_cond
L_gcd_b004_end:

# block b005 (ReturnStmt)
ldr w0, [sp, #0]
b L_gcd_return
L_gcd_return:
    add sp, sp, #16
    ldp x29, x30, [sp], #16
    ret
