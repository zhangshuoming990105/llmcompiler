.text
.globl _gcd
.p2align 2
_gcd:
    cmp w0, #0
    cneg w0, w0, lt
    cmp w1, #0
    cneg w1, w1, lt
    cmp w1, w0
    b.le Lgcd_loop
    mov w2, w0
    mov w0, w1
    mov w1, w2
Lgcd_loop:
    cbz w1, Lgcd_done
    sdiv w2, w0, w1
    msub w2, w2, w1, w0
    mov w0, w1
    mov w1, w2
    b Lgcd_loop
Lgcd_done:
    ret
