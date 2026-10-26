.text
.p2align 2
.globl _apply_binary_operation_on_byte
_apply_binary_operation_on_byte:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #16
    str w0, [sp, #0]
    str w1, [sp, #4]
    str w2, [sp, #8]

# block b000 (IfStmt)
ldr w2, [sp, #8]
cmp w2, #0
b.eq L_apply_binary_operation_on_byte_b000_or
cmp w2, #1
b.eq L_apply_binary_operation_on_byte_b000_and
cmp w2, #2
b.eq L_apply_binary_operation_on_byte_b000_xor
b L_apply_binary_operation_on_byte_b000_end
L_apply_binary_operation_on_byte_b000_or:
ldr w0, [sp, #0]
ldr w1, [sp, #4]
cmp w0, #49
cset w2, eq
cmp w1, #49
cset w3, eq
orr w2, w2, w3
add w0, w2, #48
b L_apply_binary_operation_on_byte_return
L_apply_binary_operation_on_byte_b000_and:
ldr w0, [sp, #0]
ldr w1, [sp, #4]
cmp w0, #49
cset w2, eq
cmp w1, #49
cset w3, eq
and w2, w2, w3
add w0, w2, #48
b L_apply_binary_operation_on_byte_return
L_apply_binary_operation_on_byte_b000_xor:
ldr w0, [sp, #0]
ldr w1, [sp, #4]
cmp w0, #48
cset w2, eq
cmp w1, #49
cset w3, eq
and w2, w2, w3
cmp w0, #49
cset w3, eq
cmp w1, #48
cset w4, eq
and w3, w3, w4
orr w2, w2, w3
add w0, w2, #48
b L_apply_binary_operation_on_byte_return
L_apply_binary_operation_on_byte_b000_end:

# block b001 (ReturnStmt)
mov w0, #63
b L_apply_binary_operation_on_byte_return
L_apply_binary_operation_on_byte_return:
    add sp, sp, #16
    ldp x29, x30, [sp], #16
    ret
