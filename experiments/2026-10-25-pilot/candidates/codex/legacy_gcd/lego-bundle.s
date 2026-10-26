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
// lego_v2_r is uninitialized.

# block b001 (IfStmt)
ldr w0, [sp, #0]
cmp w0, #0
b.ge L_gcd_b001_done
neg w0, w0
str w0, [sp, #0]
L_gcd_b001_done:

# block b002 (IfStmt)
ldr w0, [sp, #4]
cmp w0, #0
b.ge L_gcd_b002_done
neg w0, w0
str w0, [sp, #4]
L_gcd_b002_done:

# block b003 (IfStmt)
ldr w0, [sp, #0]
ldr w1, [sp, #4]
cmp w1, w0
b.le L_gcd_b003_done
str w0, [sp, #12]
str w1, [sp, #0]
str w0, [sp, #4]
L_gcd_b003_done:

# block b004 (WhileStmt)
L_gcd_b004_loop:
ldr w1, [sp, #4]
cbz w1, L_gcd_b004_done
ldr w0, [sp, #0]
sdiv w2, w0, w1
msub w3, w2, w1, w0
str w3, [sp, #8]
str w1, [sp, #0]
str w3, [sp, #4]
b L_gcd_b004_loop
L_gcd_b004_done:

# block b005 (ReturnStmt)
ldr w0, [sp, #0]
b L_gcd_return
L_gcd_return:
    add sp, sp, #16
    ldp x29, x30, [sp], #16
    ret
