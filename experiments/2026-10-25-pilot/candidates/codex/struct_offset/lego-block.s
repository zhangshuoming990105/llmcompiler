.text
.p2align 2
.globl _score_items
_score_items:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #32
    str x0, [sp, #0]
    str w1, [sp, #8]

# block b000 (DeclStmt)
mov x8, #0
str x8, [sp, #16]

# block b001 (ForStmt)
ldr x0, [sp, #0]
ldr w1, [sp, #8]
ldr x2, [sp, #16]
mov w3, #0
L_score_items_b001_test:
cmp w3, w1
b.ge L_score_items_b001_done
sxtw x4, w3
add x4, x0, x4, lsl #4
ldrb w5, [x4]
cbz w5, L_score_items_b001_next
ldrsw x5, [x4, #4]
ldr x6, [x4, #8]
madd x2, x5, x6, x2
L_score_items_b001_next:
add w3, w3, #1
b L_score_items_b001_test
L_score_items_b001_done:
str x2, [sp, #16]
str w3, [sp, #24]

# block b002 (ReturnStmt)
ldr x0, [sp, #16]
b L_score_items_return
L_score_items_return:
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    ret
