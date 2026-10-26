.text
.p2align 2
.globl _score_items
_score_items:
    mov x2, #0
    cmp w1, #0
    b.le Lscore_done
Lscore_loop:
    ldrb w3, [x0]
    cbz w3, Lscore_next
    ldrsw x3, [x0, #4]
    ldr x4, [x0, #8]
    madd x2, x3, x4, x2
Lscore_next:
    add x0, x0, #16
    subs w1, w1, #1
    b.ne Lscore_loop
Lscore_done:
    mov x0, x2
    ret
