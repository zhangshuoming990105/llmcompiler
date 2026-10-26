.text
.p2align 2
.globl _color_char_to_attr
_color_char_to_attr:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #16
    strb w0, [sp, #0]

# block b000 (SwitchStmt)
ldrsb w1, [sp, #0]
cmp w1, #100
b.eq L_color_char_to_attr_b000_case_d
cmp w1, #119
b.eq L_color_char_to_attr_b000_case_w
cmp w1, #115
b.eq L_color_char_to_attr_b000_case_s
cmp w1, #111
b.eq L_color_char_to_attr_b000_case_o
cmp w1, #114
b.eq L_color_char_to_attr_b000_case_r
cmp w1, #103
b.eq L_color_char_to_attr_b000_case_g
cmp w1, #98
b.eq L_color_char_to_attr_b000_case_b
cmp w1, #117
b.eq L_color_char_to_attr_b000_case_u
cmp w1, #68
b.eq L_color_char_to_attr_b000_case_upper_d
cmp w1, #87
b.eq L_color_char_to_attr_b000_case_upper_w
cmp w1, #118
b.eq L_color_char_to_attr_b000_case_v
cmp w1, #121
b.eq L_color_char_to_attr_b000_case_y
cmp w1, #82
b.eq L_color_char_to_attr_b000_case_upper_r
cmp w1, #71
b.eq L_color_char_to_attr_b000_case_upper_g
cmp w1, #66
b.eq L_color_char_to_attr_b000_case_upper_b
cmp w1, #85
b.eq L_color_char_to_attr_b000_case_upper_u
b L_color_char_to_attr_b000_end
L_color_char_to_attr_b000_case_d:
mov w0, #0
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_w:
mov w0, #1
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_s:
mov w0, #2
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_o:
mov w0, #3
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_r:
mov w0, #4
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_g:
mov w0, #5
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_b:
mov w0, #6
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_u:
mov w0, #7
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_upper_d:
mov w0, #8
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_upper_w:
mov w0, #9
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_v:
mov w0, #10
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_y:
mov w0, #11
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_upper_r:
mov w0, #12
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_upper_g:
mov w0, #13
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_upper_b:
mov w0, #14
b L_color_char_to_attr_return
L_color_char_to_attr_b000_case_upper_u:
mov w0, #15
b L_color_char_to_attr_return
L_color_char_to_attr_b000_end:

# block b001 (ReturnStmt)
mov w0, #-1
b L_color_char_to_attr_return
L_color_char_to_attr_return:
    add sp, sp, #16
    ldp x29, x30, [sp], #16
    ret
