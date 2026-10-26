.text
.p2align 2
.globl _color_char_to_attr
_color_char_to_attr:
    and w8, w0, #0xff
    cmp w8, #100
    b.eq Lcolor_0
    cmp w8, #119
    b.eq Lcolor_1
    cmp w8, #115
    b.eq Lcolor_2
    cmp w8, #111
    b.eq Lcolor_3
    cmp w8, #114
    b.eq Lcolor_4
    cmp w8, #103
    b.eq Lcolor_5
    cmp w8, #98
    b.eq Lcolor_6
    cmp w8, #117
    b.eq Lcolor_7
    cmp w8, #68
    b.eq Lcolor_8
    cmp w8, #87
    b.eq Lcolor_9
    cmp w8, #118
    b.eq Lcolor_10
    cmp w8, #121
    b.eq Lcolor_11
    cmp w8, #82
    b.eq Lcolor_12
    cmp w8, #71
    b.eq Lcolor_13
    cmp w8, #66
    b.eq Lcolor_14
    cmp w8, #85
    b.eq Lcolor_15
    movn w0, #0
    ret
Lcolor_0:
    mov w0, #0
    ret
Lcolor_1:
    mov w0, #1
    ret
Lcolor_2:
    mov w0, #2
    ret
Lcolor_3:
    mov w0, #3
    ret
Lcolor_4:
    mov w0, #4
    ret
Lcolor_5:
    mov w0, #5
    ret
Lcolor_6:
    mov w0, #6
    ret
Lcolor_7:
    mov w0, #7
    ret
Lcolor_8:
    mov w0, #8
    ret
Lcolor_9:
    mov w0, #9
    ret
Lcolor_10:
    mov w0, #10
    ret
Lcolor_11:
    mov w0, #11
    ret
Lcolor_12:
    mov w0, #12
    ret
Lcolor_13:
    mov w0, #13
    ret
Lcolor_14:
    mov w0, #14
    ret
Lcolor_15:
    mov w0, #15
    ret
