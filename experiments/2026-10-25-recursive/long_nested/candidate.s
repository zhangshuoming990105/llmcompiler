.text
.p2align 2
.globl _long_kernel
_long_kernel:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #32
    str x0, [sp, #0]
    str w1, [sp, #8]
    str w2, [sp, #12]

# block r_s000
ldr w0, [sp, #12]
str w0, [sp, #16]

# block r_s001_init
mov w0, #0
str w0, [sp, #20]
L_long_kernel_r_s001_cond:

# block r_s001_condition
ldr w8, [sp, #20]
ldr w9, [sp, #8]
cmp w8, w9
cset w0, lt
    cbz w0, L_long_kernel_r_s001_end

# block r_s001_body_s000
mov w0, #0
str w0, [sp, #24]
L_long_kernel_r_s001_body_s001_cond:

# block r_s001_body_s001_condition
ldr w0, [sp, #24]
cmp w0, #2
cset w0, lt
    cbz w0, L_long_kernel_r_s001_body_s001_end

# block r_s001_body_s001_body_s000
ldr w0, [sp, #24]
add w0, w0, #1
str w0, [sp, #24]

# block r_s001_body_s001_body_s001_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #1
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s001_else

# block r_s001_body_s001_body_s001_then_left
// state = (state ^ a[(i+3)%n]) * 27799u + 1u
ldr w8, [sp, #20]
add w8, w8, #3
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
sxtw x8, w8
ldr w12, [x11, x8, lsl #2]
ldr w13, [sp, #16]
eor w13, w13, w12
mov w14, #27799
mul w13, w13, w14
add w13, w13, #1
str w13, [sp, #16]
// state = (state << 11) | (state >> 21)
ldr w13, [sp, #16]
ror w13, w13, #21
str w13, [sp, #16]
// state ^= (state >> 14) + 4723u
ldr w13, [sp, #16]
lsr w12, w13, #14
mov w14, #4723
add w12, w12, w14
eor w13, w13, w12
str w13, [sp, #16]
// state += (unsigned)(i + round) * 23826u
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w14, #23826
mul w8, w8, w14
ldr w13, [sp, #16]
add w13, w13, w8
str w13, [sp, #16]
// state = (state ^ a[(i+7)%n]) * 3367u + 5u
ldr w8, [sp, #20]
add w8, w8, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
sxtw x8, w8
ldr w12, [x11, x8, lsl #2]
ldr w13, [sp, #16]
eor w13, w13, w12
mov w14, #3367
mul w13, w13, w14
add w13, w13, #5
str w13, [sp, #16]
// state = (state << 11) | (state >> 21)
ldr w13, [sp, #16]
ror w13, w13, #21
str w13, [sp, #16]
// state ^= (state >> 6) + 59541u
ldr w13, [sp, #16]
lsr w12, w13, #6
mov w14, #59541
add w12, w12, w14
eor w13, w13, w12
str w13, [sp, #16]
// state += (unsigned)(i + round) * 45518u
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w14, #45518
mul w8, w8, w14
ldr w13, [sp, #16]
add w13, w13, w8
str w13, [sp, #16]
// state = (state ^ a[(i+0)%n]) * 38983u + 9u
ldr w8, [sp, #20]
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
sxtw x8, w8
ldr w12, [x11, x8, lsl #2]
ldr w13, [sp, #16]
eor w13, w13, w12
mov w14, #38983
mul w13, w13, w14
add w13, w13, #9
str w13, [sp, #16]
// state = (state << 1) | (state >> 31)
ldr w13, [sp, #16]
ror w13, w13, #31
str w13, [sp, #16]
// state ^= (state >> 8) + 27403u
ldr w13, [sp, #16]
lsr w12, w13, #8
mov w14, #27403
add w12, w12, w14
eor w13, w13, w12
str w13, [sp, #16]
// state += (unsigned)(i + round) * 32301u
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w14, #32301
mul w8, w8, w14
ldr w13, [sp, #16]
add w13, w13, w8
str w13, [sp, #16]
// state = (state ^ a[(i+3)%n]) * 44883u + 13u
ldr w8, [sp, #20]
add w8, w8, #3
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
sxtw x8, w8
ldr w12, [x11, x8, lsl #2]
ldr w13, [sp, #16]
eor w13, w13, w12
mov w14, #44883
mul w13, w13, w14
add w13, w13, #13
str w13, [sp, #16]
// state = (state << 9) | (state >> 23)
ldr w13, [sp, #16]
ror w13, w13, #23
str w13, [sp, #16]
// state ^= (state >> 10) + 17885u
ldr w13, [sp, #16]
lsr w12, w13, #10
mov w14, #17885
add w12, w12, w14
eor w13, w13, w12
str w13, [sp, #16]
// state += (unsigned)(i + round) * 14768u
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w14, #14768
mul w8, w8, w14
ldr w13, [sp, #16]
add w13, w13, w8
str w13, [sp, #16]

# block r_s001_body_s001_body_s001_then_right
// state ^= a[(i+0)%n]; *29941 + 17
ldr w1, [sp, #20]
ldr w2, [sp, #8]
add w3, w1, #0
sdiv w4, w3, w2
msub w4, w4, w2, w3
ldr x5, [sp, #0]
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
ldr w8, [sp, #16]
eor w8, w8, w7
mov w9, #29941
mul w8, w8, w9
add w8, w8, #17
// rotate left 5
lsl w10, w8, #5
lsr w11, w8, #27
orr w8, w10, w11
// state ^= (state >> 11) + 40774
lsr w10, w8, #11
mov w9, #40774
add w10, w10, w9
eor w8, w8, w10
// state += (i+round) * 60195
ldr w12, [sp, #24]
add w13, w1, w12
mov w9, #60195
mul w13, w13, w9
add w8, w8, w13
// state ^= a[(i+5)%n]; *63015 + 21
add w3, w1, #5
sdiv w4, w3, w2
msub w4, w4, w2, w3
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
eor w8, w8, w7
mov w9, #63015
mul w8, w8, w9
add w8, w8, #21
// rotate left 9
lsl w10, w8, #9
lsr w11, w8, #23
orr w8, w10, w11
// state ^= (state >> 6) + 26190
lsr w10, w8, #6
mov w9, #26190
add w10, w10, w9
eor w8, w8, w10
// state += (i+round) * 56656
add w13, w1, w12
mov w9, #56656
mul w13, w13, w9
add w8, w8, w13
// state ^= a[(i+0)%n]; *3807 + 25
add w3, w1, #0
sdiv w4, w3, w2
msub w4, w4, w2, w3
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
eor w8, w8, w7
mov w9, #3807
mul w8, w8, w9
add w8, w8, #25
// rotate left 2
lsl w10, w8, #2
lsr w11, w8, #30
orr w8, w10, w11
// state ^= (state >> 7) + 9887
lsr w10, w8, #7
mov w9, #9887
add w10, w10, w9
eor w8, w8, w10
// state += (i+round) * 52458
add w13, w1, w12
mov w9, #52458
mul w13, w13, w9
add w8, w8, w13
// state ^= a[(i+6)%n]; *33717 + 29
add w3, w1, #6
sdiv w4, w3, w2
msub w4, w4, w2, w3
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
eor w8, w8, w7
mov w9, #33717
mul w8, w8, w9
add w8, w8, #29
// rotate left 4
lsl w10, w8, #4
lsr w11, w8, #28
orr w8, w10, w11
// state ^= (state >> 5) + 43313
lsr w10, w8, #5
mov w9, #43313
add w10, w10, w9
eor w8, w8, w10
// state += (i+round) * 45435
add w13, w1, w12
mov w9, #45435
mul w13, w13, w9
add w8, w8, w13
// store state
str w8, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s001_end
L_long_kernel_r_s001_body_s001_body_s001_else:

# block r_s001_body_s001_body_s001_else_left_left
// lego_v3_state = (lego_v3_state << 1) | (lego_v3_state >> 31);
ldr w0, [sp, #16]
ror w0, w0, #31
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 47453u;
ldr w0, [sp, #16]
lsr w1, w0, #13
mov w2, #47453
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 44300u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #44300
mul w3, w3, w5
ldr w0, [sp, #16]
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 7) % lego_v1_n]) * 55335u + 4u;
ldr w3, [sp, #20]
add w3, w3, #7
ldr w4, [sp, #8]
sdiv w5, w3, w4
mul w5, w5, w4
sub w3, w3, w5
ldr x6, [sp, #0]
sxtw x3, w3
ldr w7, [x6, x3, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w7
mov w5, #55335
mul w0, w0, w5
add w0, w0, #4
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 4) | (lego_v3_state >> 28);
ldr w0, [sp, #16]
ror w0, w0, #28
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 10) + 49525u;
ldr w0, [sp, #16]
lsr w1, w0, #10
mov w2, #49525
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 30180u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #30180
mul w3, w3, w5
ldr w0, [sp, #16]
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 7) % lego_v1_n]) * 51381u + 8u;
ldr w3, [sp, #20]
add w3, w3, #7
ldr w4, [sp, #8]
sdiv w5, w3, w4
mul w5, w5, w4
sub w3, w3, w5
ldr x6, [sp, #0]
sxtw x3, w3
ldr w7, [x6, x3, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w7
mov w5, #51381
mul w0, w0, w5
add w0, w0, #8
str w0, [sp, #16]

# block r_s001_body_s001_body_s001_else_left_right
ldr w0, [sp, #16]
lsl w1, w0, #15
lsr w2, w0, #17
orr w0, w1, w2
// state = rotl(state,15)
lsr w1, w0, #15
mov w2, #16031
add w1, w1, w2
eor w0, w0, w1
// state ^= (state>>15)+16031
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #22437
mul w3, w3, w5
add w0, w0, w3
// state += (i+round)*22437
str w0, [sp, #16]
// index = (i+3)%n
ldr w3, [sp, #20]
add w3, w3, #3
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
// w5 = (i+3)%n
ldr x6, [sp, #0]
sxtw x7, w5
ldr w6, [x6, x7, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w6
mov w8, #64363
mul w0, w0, w8
add w0, w0, #12
// state = (state^a[..])*64363+12
lsl w1, w0, #1
lsr w2, w0, #31
orr w0, w1, w2
// state = rotl(state,1)
lsr w1, w0, #8
mov w2, #10398
add w1, w1, w2
eor w0, w0, w1
// state ^= (state>>8)+10398
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #48815
mul w3, w3, w5
add w0, w0, w3
// state += (i+round)*48815
str w0, [sp, #16]
// index = (i+7)%n
ldr w3, [sp, #20]
add w3, w3, #7
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x7, w5
ldr w6, [x6, x7, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w6
mov w8, #29473
mul w0, w0, w8
add w0, w0, #16
// state = (state^a[..])*29473+16
str w0, [sp, #16]

# block r_s001_body_s001_body_s001_else_right
// lego_v3_state = (state << 4) | (state >> 28)
ldr w8, [sp, #16]
lsl w9, w8, #4
lsr w10, w8, #28
orr w8, w9, w10
str w8, [sp, #16]
// state ^= (state >> 4) + 58907u
lsr w9, w8, #4
mov w10, #58907
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]
// state += (unsigned)(i + round) * 12977u
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w13, #12977
mul w11, w11, w13
add w8, w8, w11
str w8, [sp, #16]
// state = (state ^ a[(i+5) % n]) * 34845u + 20u
ldr x0, [sp, #0]
ldr w1, [sp, #8]
ldr w11, [sp, #20]
add w11, w11, #5
sdiv w12, w11, w1
msub w12, w12, w1, w11
sxtw x12, w12
ldr w14, [x0, x12, lsl #2]
eor w8, w8, w14
mov w13, #34845
mul w8, w8, w13
add w8, w8, #20
str w8, [sp, #16]
// state = (state << 3) | (state >> 29)
lsl w9, w8, #3
lsr w10, w8, #29
orr w8, w9, w10
str w8, [sp, #16]
// state ^= (state >> 15) + 12572u
lsr w9, w8, #15
mov w10, #12572
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]
// state += (unsigned)(i + round) * 38188u
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w13, #38188
mul w11, w11, w13
add w8, w8, w11
str w8, [sp, #16]
// state = (state ^ a[(i+5) % n]) * 17409u + 24u
ldr x0, [sp, #0]
ldr w1, [sp, #8]
ldr w11, [sp, #20]
add w11, w11, #5
sdiv w12, w11, w1
msub w12, w12, w1, w11
sxtw x12, w12
ldr w14, [x0, x12, lsl #2]
eor w8, w8, w14
mov w13, #17409
mul w8, w8, w13
add w8, w8, #24
str w8, [sp, #16]
// state = (state << 15) | (state >> 17)
lsl w9, w8, #15
lsr w10, w8, #17
orr w8, w9, w10
str w8, [sp, #16]
// state ^= (state >> 5) + 44491u
lsr w9, w8, #5
mov w10, #44491
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]
// state += (unsigned)(i + round) * 26779u
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w13, #26779
mul w11, w11, w13
add w8, w8, w11
str w8, [sp, #16]
// state = (state ^ a[(i+6) % n]) * 5183u + 28u
ldr x0, [sp, #0]
ldr w1, [sp, #8]
ldr w11, [sp, #20]
add w11, w11, #6
sdiv w12, w11, w1
msub w12, w12, w1, w11
sxtw x12, w12
ldr w14, [x0, x12, lsl #2]
eor w8, w8, w14
mov w13, #5183
mul w8, w8, w13
add w8, w8, #28
str w8, [sp, #16]
// state = (state << 13) | (state >> 19)
lsl w9, w8, #13
lsr w10, w8, #19
orr w8, w9, w10
str w8, [sp, #16]
// state ^= (state >> 2) + 635u
lsr w9, w8, #2
mov w10, #635
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]
// state += (unsigned)(i + round) * 37219u
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w13, #37219
mul w11, w11, w13
add w8, w8, w11
str w8, [sp, #16]
// state = (state ^ a[(i+4) % n]) * 48955u + 32u
ldr x0, [sp, #0]
ldr w1, [sp, #8]
ldr w11, [sp, #20]
add w11, w11, #4
sdiv w12, w11, w1
msub w12, w12, w1, w11
sxtw x12, w12
ldr w14, [x0, x12, lsl #2]
eor w8, w8, w14
mov w13, #48955
mul w8, w8, w13
add w8, w8, #32
str w8, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s001_end:

# block r_s001_body_s001_body_s002_condition
ldr w8, [sp, #16]
ldr w9, [sp, #12]
eor w8, w8, w9
and w8, w8, #2
cmp w8, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s002_else

# block r_s001_body_s001_body_s002_then_left
// load state
ldr w2, [sp, #16]
// state = (state << 13) | (state >> 19)
lsl w3, w2, #13
lsr w4, w2, #19
orr w2, w3, w4
// state ^= (state >> 12) + 39085u
lsr w3, w2, #12
mov w4, #39085
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned int)(i + round) * 48841u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #48841
mul w5, w5, w7
add w2, w2, w5
// idx0 = (i + 0) % n
ldr w5, [sp, #20]
add w5, w5, #0
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
// load a[idx0]
ldr x8, [sp, #0]
sxtw x9, w7
ldr w10, [x8, x9, lsl #2]
// state = (state ^ a[idx0]) * 63571u + 5u
eor w2, w2, w10
mov w11, #63571
mul w2, w2, w11
add w2, w2, #5
// state = (state << 15) | (state >> 17)
lsl w3, w2, #15
lsr w4, w2, #17
orr w2, w3, w4
// state ^= (state >> 4) + 24939u
lsr w3, w2, #4
mov w4, #24939
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned int)(i + round) * 64167u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #64167
mul w5, w5, w7
add w2, w2, w5
// idx1 = (i + 1) % n
ldr w5, [sp, #20]
add w5, w5, #1
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
// load a[idx1]
ldr x8, [sp, #0]
sxtw x9, w7
ldr w10, [x8, x9, lsl #2]
// state = (state ^ a[idx1]) * 7603u + 9u
eor w2, w2, w10
mov w11, #7603
mul w2, w2, w11
add w2, w2, #9
// state = (state << 5) | (state >> 27)
lsl w3, w2, #5
lsr w4, w2, #27
orr w2, w3, w4
// state ^= (state >> 13) + 44355u
lsr w3, w2, #13
mov w4, #44355
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned int)(i + round) * 44057u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #44057
mul w5, w5, w7
add w2, w2, w5
// idx1b = (i + 1) % n
ldr w5, [sp, #20]
add w5, w5, #1
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
// load a[idx1b]
ldr x8, [sp, #0]
sxtw x9, w7
ldr w10, [x8, x9, lsl #2]
// state = (state ^ a[idx1b]) * 4717u + 13u
eor w2, w2, w10
mov w11, #4717
mul w2, w2, w11
add w2, w2, #13
// state = (state << 9) | (state >> 23)
lsl w3, w2, #9
lsr w4, w2, #23
orr w2, w3, w4
// state ^= (state >> 3) + 59739u
lsr w3, w2, #3
mov w4, #59739
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned int)(i + round) * 5805u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #5805
mul w5, w5, w7
add w2, w2, w5
// idx6 = (i + 6) % n
ldr w5, [sp, #20]
add w5, w5, #6
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
// load a[idx6]
ldr x8, [sp, #0]
sxtw x9, w7
ldr w10, [x8, x9, lsl #2]
// state = (state ^ a[idx6]) * 64309u + 17u
eor w2, w2, w10
mov w11, #64309
mul w2, w2, w11
add w2, w2, #17
// store state
str w2, [sp, #16]

# block r_s001_body_s001_body_s002_then_right
// lego_v3_state = (lego_v3_state << 9) | (lego_v3_state >> 23);
ldr w0, [sp, #16]
lsl w1, w0, #9
lsr w2, w0, #23
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 9) + 11782u;
ldr w0, [sp, #16]
lsr w1, w0, #9
mov w2, #11782
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 31047u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #31047
mul w1, w1, w2
ldr w0, [sp, #16]
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 64645u + 21u;
ldr w3, [sp, #20]
add w3, w3, #0
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w5, [x6, x5, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w5
mov w2, #64645
mul w0, w0, w2
add w0, w0, #21
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 1) | (lego_v3_state >> 31);
ldr w0, [sp, #16]
lsl w1, w0, #1
lsr w2, w0, #31
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 14) + 47250u;
ldr w0, [sp, #16]
lsr w1, w0, #14
mov w2, #47250
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 60506u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #60506
mul w1, w1, w2
ldr w0, [sp, #16]
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 6) % lego_v1_n]) * 10069u + 25u;
ldr w3, [sp, #20]
add w3, w3, #6
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w5, [x6, x5, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w5
mov w2, #10069
mul w0, w0, w2
add w0, w0, #25
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 3) | (lego_v3_state >> 29);
ldr w0, [sp, #16]
lsl w1, w0, #3
lsr w2, w0, #29
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 12) + 21913u;
ldr w0, [sp, #16]
lsr w1, w0, #12
mov w2, #21913
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 17682u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #17682
mul w1, w1, w2
ldr w0, [sp, #16]
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 4) % lego_v1_n]) * 27775u + 29u;
ldr w3, [sp, #20]
add w3, w3, #4
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w5, [x6, x5, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w5
mov w2, #27775
mul w0, w0, w2
add w0, w0, #29
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 12) | (lego_v3_state >> 20);
ldr w0, [sp, #16]
lsl w1, w0, #12
lsr w2, w0, #20
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 12) + 31182u;
ldr w0, [sp, #16]
lsr w1, w0, #12
mov w2, #31182
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 63716u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #63716
mul w1, w1, w2
ldr w0, [sp, #16]
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 6) % lego_v1_n]) * 60357u + 33u;
ldr w3, [sp, #20]
add w3, w3, #6
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w5, [x6, x5, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w5
mov w2, #60357
mul w0, w0, w2
add w0, w0, #33
str w0, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s002_end
L_long_kernel_r_s001_body_s001_body_s002_else:

# block r_s001_body_s001_body_s002_else_left
// lego_v3_state ^= (lego_v3_state >> 11) + 59509u;
ldr w0, [sp, #16]
lsr w1, w0, #11
mov w2, #59509
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 52030u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #52030
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 51217u + 4u;
ldr w6, [sp, #20]
add w6, w6, #0
ldr w7, [sp, #8]
sdiv w8, w6, w7
mul w8, w8, w7
sub w6, w6, w8
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #51217
mul w0, w0, w5
add w0, w0, #4
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 3) | (lego_v3_state >> 29);
lsl w1, w0, #3
lsr w2, w0, #29
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 14) + 7837u;
lsr w1, w0, #14
mov w2, #7837
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 42094u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #42094
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 4) % lego_v1_n]) * 21553u + 8u;
ldr w6, [sp, #20]
add w6, w6, #4
ldr w7, [sp, #8]
sdiv w8, w6, w7
mul w8, w8, w7
sub w6, w6, w8
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #21553
mul w0, w0, w5
add w0, w0, #8
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 14) | (lego_v3_state >> 18);
lsl w1, w0, #14
lsr w2, w0, #18
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 41942u;
lsr w1, w0, #13
mov w2, #41942
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 15869u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #15869
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 5) % lego_v1_n]) * 19799u + 12u;
ldr w6, [sp, #20]
add w6, w6, #5
ldr w7, [sp, #8]
sdiv w8, w6, w7
mul w8, w8, w7
sub w6, w6, w8
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #19799
mul w0, w0, w5
add w0, w0, #12
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 5) | (lego_v3_state >> 27);
lsl w1, w0, #5
lsr w2, w0, #27
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 7) + 1691u;
lsr w1, w0, #7
mov w2, #1691
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 57670u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #57670
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 6) % lego_v1_n]) * 1571u + 16u;
ldr w6, [sp, #20]
add w6, w6, #6
ldr w7, [sp, #8]
sdiv w8, w6, w7
mul w8, w8, w7
sub w6, w6, w8
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #1571
mul w0, w0, w5
add w0, w0, #16
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 6) | (lego_v3_state >> 26);
lsl w1, w0, #6
lsr w2, w0, #26
orr w0, w1, w2
str w0, [sp, #16]

# block r_s001_body_s001_body_s002_else_right
// lego_v3_state ^= (lego_v3_state >> 7) + 51142u;
ldr w0, [sp, #16]
lsr w1, w0, #7
mov w2, #51142
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 9109u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #9109
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 1) % lego_v1_n]) * 9727u + 20u;
ldr w1, [sp, #20]
add w1, w1, #1
ldr w2, [sp, #8]
sdiv w3, w1, w2
mul w3, w3, w2
sub w1, w1, w3
ldr x4, [sp, #0]
ldr w5, [x4, w1, sxtw #2]
eor w0, w0, w5
mov w6, #9727
mul w0, w0, w6
add w0, w0, #20
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 14) | (lego_v3_state >> 18);
ror w0, w0, #18
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 10) + 55050u;
lsr w1, w0, #10
mov w2, #55050
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 17793u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #17793
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 22527u + 24u;
ldr w1, [sp, #20]
ldr w2, [sp, #8]
sdiv w3, w1, w2
mul w3, w3, w2
sub w1, w1, w3
ldr x4, [sp, #0]
ldr w5, [x4, w1, sxtw #2]
eor w0, w0, w5
mov w6, #22527
mul w0, w0, w6
add w0, w0, #24
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 9) | (lego_v3_state >> 23);
ror w0, w0, #23
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 4) + 9736u;
lsr w1, w0, #4
mov w2, #9736
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 19221u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #19221
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 5) % lego_v1_n]) * 19879u + 28u;
ldr w1, [sp, #20]
add w1, w1, #5
ldr w2, [sp, #8]
sdiv w3, w1, w2
mul w3, w3, w2
sub w1, w1, w3
ldr x4, [sp, #0]
ldr w5, [x4, w1, sxtw #2]
eor w0, w0, w5
mov w6, #19879
mul w0, w0, w6
add w0, w0, #28
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 1) | (lego_v3_state >> 31);
ror w0, w0, #31
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 2) + 24805u;
lsr w1, w0, #2
mov w2, #24805
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 29494u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #29494
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 3) % lego_v1_n]) * 23173u + 32u;
ldr w1, [sp, #20]
add w1, w1, #3
ldr w2, [sp, #8]
sdiv w3, w1, w2
mul w3, w3, w2
sub w1, w1, w3
ldr x4, [sp, #0]
ldr w5, [x4, w1, sxtw #2]
eor w0, w0, w5
mov w6, #23173
mul w0, w0, w6
add w0, w0, #32
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 1) | (lego_v3_state >> 31);
ror w0, w0, #31
str w0, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s002_end:

# block r_s001_body_s001_body_s003_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #4
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s003_else

# block r_s001_body_s001_body_s003_then_left
// state ^= (state >> 4) + 51511u
ldr w8, [sp, #16]
lsr w9, w8, #4
mov w10, #51511
add w9, w9, w10
eor w8, w8, w9
// state += (unsigned int)(i + round) * 33330u
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w13, #33330
mul w11, w11, w13
add w8, w8, w11
str w8, [sp, #16]
// state = (state ^ a[(i + 4) % n]) * 20173u + 5u
ldr w11, [sp, #20]
add w11, w11, #4
ldr w12, [sp, #8]
sdiv w13, w11, w12
msub w13, w13, w12, w11
ldr x14, [sp, #0]
ldr w15, [x14, w13, sxtw #2]
eor w8, w8, w15
mov w13, #20173
mul w8, w8, w13
add w8, w8, #5
// state = (state << 3) | (state >> 29)
lsl w9, w8, #3
lsr w10, w8, #29
orr w8, w9, w10
str w8, [sp, #16]
// state ^= (state >> 11) + 43404u
lsr w9, w8, #11
mov w10, #43404
add w9, w9, w10
eor w8, w8, w9
// state += (unsigned int)(i + round) * 5461u
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w13, #5461
mul w11, w11, w13
add w8, w8, w11
str w8, [sp, #16]
// state = (state ^ a[(i + 2) % n]) * 55883u + 9u
ldr w11, [sp, #20]
add w11, w11, #2
ldr w12, [sp, #8]
sdiv w13, w11, w12
msub w13, w13, w12, w11
ldr x14, [sp, #0]
ldr w15, [x14, w13, sxtw #2]
eor w8, w8, w15
mov w13, #55883
mul w8, w8, w13
add w8, w8, #9
// state = (state << 10) | (state >> 22)
lsl w9, w8, #10
lsr w10, w8, #22
orr w8, w9, w10
str w8, [sp, #16]
// state ^= (state >> 15) + 49507u
lsr w9, w8, #15
mov w10, #49507
add w9, w9, w10
eor w8, w8, w9
// state += (unsigned int)(i + round) * 30796u
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w13, #30796
mul w11, w11, w13
add w8, w8, w11
str w8, [sp, #16]
// state = (state ^ a[(i + 7) % n]) * 63115u + 13u
ldr w11, [sp, #20]
add w11, w11, #7
ldr w12, [sp, #8]
sdiv w13, w11, w12
msub w13, w13, w12, w11
ldr x14, [sp, #0]
ldr w15, [x14, w13, sxtw #2]
eor w8, w8, w15
mov w13, #63115
mul w8, w8, w13
add w8, w8, #13
// state = (state << 14) | (state >> 18)
lsl w9, w8, #14
lsr w10, w8, #18
orr w8, w9, w10
str w8, [sp, #16]
// state ^= (state >> 3) + 30142u
lsr w9, w8, #3
mov w10, #30142
add w9, w9, w10
eor w8, w8, w9
// state += (unsigned int)(i + round) * 26307u
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w13, #26307
mul w11, w11, w13
add w8, w8, w11
str w8, [sp, #16]
// state = (state ^ a[(i + 1) % n]) * 56807u + 17u
ldr w11, [sp, #20]
add w11, w11, #1
ldr w12, [sp, #8]
sdiv w13, w11, w12
msub w13, w13, w12, w11
ldr x14, [sp, #0]
ldr w15, [x14, w13, sxtw #2]
eor w8, w8, w15
mov w13, #56807
mul w8, w8, w13
add w8, w8, #17
// state = (state << 9) | (state >> 23)
lsl w9, w8, #9
lsr w10, w8, #23
orr w8, w9, w10
str w8, [sp, #16]

# block r_s001_body_s001_body_s003_then_right
// lego_v3_state ^= (lego_v3_state >> 7) + 21052u;
ldr w0, [sp, #16]
lsr w1, w0, #7
mov w2, #21052
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 62527u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #62527
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 1) % lego_v1_n]) * 25113u + 21u;
ldr w3, [sp, #20]
add w3, w3, #1
ldr w4, [sp, #8]
sdiv w5, w3, w4
mul w5, w5, w4
sub w3, w3, w5
ldr x6, [sp, #0]
ldr w7, [x6, w3, sxtw #2]
eor w0, w0, w7
mov w8, #25113
mul w0, w0, w8
add w0, w0, #21
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 13) | (lego_v3_state >> 19);
ror w0, w0, #19
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 9) + 5986u;
lsr w1, w0, #9
mov w2, #5986
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 50416u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #50416
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 4) % lego_v1_n]) * 3439u + 25u;
ldr w3, [sp, #20]
add w3, w3, #4
ldr w4, [sp, #8]
sdiv w5, w3, w4
mul w5, w5, w4
sub w3, w3, w5
ldr x6, [sp, #0]
ldr w7, [x6, w3, sxtw #2]
eor w0, w0, w7
mov w8, #3439
mul w0, w0, w8
add w0, w0, #25
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 13) | (lego_v3_state >> 19);
ror w0, w0, #19
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 14) + 35256u;
lsr w1, w0, #14
mov w2, #35256
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 19382u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #19382
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 5) % lego_v1_n]) * 29349u + 29u;
ldr w3, [sp, #20]
add w3, w3, #5
ldr w4, [sp, #8]
sdiv w5, w3, w4
mul w5, w5, w4
sub w3, w3, w5
ldr x6, [sp, #0]
ldr w7, [x6, w3, sxtw #2]
eor w0, w0, w7
mov w8, #29349
mul w0, w0, w8
add w0, w0, #29
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 9) | (lego_v3_state >> 23);
ror w0, w0, #23
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 15) + 25521u;
lsr w1, w0, #15
mov w2, #25521
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 37514u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #37514
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 1) % lego_v1_n]) * 33691u + 33u;
ldr w3, [sp, #20]
add w3, w3, #1
ldr w4, [sp, #8]
sdiv w5, w3, w4
mul w5, w5, w4
sub w3, w3, w5
ldr x6, [sp, #0]
ldr w7, [x6, w3, sxtw #2]
eor w0, w0, w7
mov w8, #33691
mul w0, w0, w8
add w0, w0, #33
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 8) | (lego_v3_state >> 24);
ror w0, w0, #24
str w0, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s003_end
L_long_kernel_r_s001_body_s001_body_s003_else:

# block r_s001_body_s001_body_s003_else_left
// load i, round, compute (i+round)
ldr w0, [sp, #20]
ldr w1, [sp, #24]
add w2, w0, w1
// state += (unsigned)(i+round) * 33003u
mov w3, #33003
mul w3, w2, w3
ldr w4, [sp, #16]
add w4, w4, w3
str w4, [sp, #16]
// index (i+1) % n
ldr w5, [sp, #20]
add w5, w5, #1
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
// load a[(i+1)%n]
ldr x8, [sp, #0]
sxtw x9, w7
ldr w10, [x8, x9, lsl #2]
// state = (state ^ elem) * 5569u + 4u
eor w4, w4, w10
mov w11, #5569
mul w4, w4, w11
add w4, w4, #4
// rotate left 5
ror w4, w4, #27
// state ^= (state >> 4) + 54678u
lsr w12, w4, #4
mov w13, #54678
add w12, w12, w13
eor w4, w4, w12
str w4, [sp, #16]
// state += (unsigned)(i+round) * 40290u
mov w3, #40290
mul w3, w2, w3
add w4, w4, w3
str w4, [sp, #16]
// index (i+7) % n
ldr w5, [sp, #20]
add w5, w5, #7
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
sxtw x9, w7
ldr w10, [x8, x9, lsl #2]
// state = (state ^ elem) * 34955u + 8u
eor w4, w4, w10
mov w11, #34955
mul w4, w4, w11
add w4, w4, #8
// rotate left 9
ror w4, w4, #23
// state ^= (state >> 7) + 32635u
lsr w12, w4, #7
mov w13, #32635
add w12, w12, w13
eor w4, w4, w12
str w4, [sp, #16]
// state += (unsigned)(i+round) * 22938u
mov w3, #22938
mul w3, w2, w3
add w4, w4, w3
str w4, [sp, #16]
// index (i+0) % n
ldr w5, [sp, #20]
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
sxtw x9, w7
ldr w10, [x8, x9, lsl #2]
// state = (state ^ elem) * 44909u + 12u
eor w4, w4, w10
mov w11, #44909
mul w4, w4, w11
add w4, w4, #12
// rotate left 2
ror w4, w4, #30
// state ^= (state >> 3) + 11968u
lsr w12, w4, #3
mov w13, #11968
add w12, w12, w13
eor w4, w4, w12
str w4, [sp, #16]
// state += (unsigned)(i+round) * 63416u
mov w3, #63416
mul w3, w2, w3
add w4, w4, w3
str w4, [sp, #16]
// index (i+0) % n
ldr w5, [sp, #20]
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
sxtw x9, w7
ldr w10, [x8, x9, lsl #2]
// state = (state ^ elem) * 17909u + 16u
eor w4, w4, w10
mov w11, #17909
mul w4, w4, w11
add w4, w4, #16
// rotate left 9
ror w4, w4, #23
// state ^= (state >> 4) + 44027u
lsr w12, w4, #4
mov w13, #44027
add w12, w12, w13
eor w4, w4, w12
str w4, [sp, #16]

# block r_s001_body_s001_body_s003_else_right
ldr w2, [sp, #20]
ldr w3, [sp, #24]
ldr w4, [sp, #16]
// group 1
add w5, w2, w3
mov w6, #28648
mul w5, w5, w6
add w4, w4, w5
// index (i+3)%n
add w7, w2, #3
ldr w8, [sp, #8]
sdiv w9, w7, w8
mul w9, w9, w8
sub w9, w7, w9
ldr x10, [sp, #0]
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w4, w4, w11
mov w6, #11659
mul w4, w4, w6
add w4, w4, #20
lsl w5, w4, #5
lsr w6, w4, #27
orr w4, w5, w6
lsr w5, w4, #12
mov w6, #64057
add w5, w5, w6
eor w4, w4, w5
// group 2
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w5, w2, w3
mov w6, #555
mul w5, w5, w6
add w4, w4, w5
add w7, w2, #5
ldr w8, [sp, #8]
sdiv w9, w7, w8
mul w9, w9, w8
sub w9, w7, w9
ldr x10, [sp, #0]
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w4, w4, w11
mov w6, #22075
mul w4, w4, w6
add w4, w4, #24
lsl w5, w4, #8
lsr w6, w4, #24
orr w4, w5, w6
lsr w5, w4, #11
mov w6, #56450
add w5, w5, w6
eor w4, w4, w5
// group 3
add w5, w2, w3
mov w6, #10491
mul w5, w5, w6
add w4, w4, w5
add w7, w2, #7
sdiv w9, w7, w8
mul w9, w9, w8
sub w9, w7, w9
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w4, w4, w11
mov w6, #47015
mul w4, w4, w6
add w4, w4, #28
lsl w5, w4, #9
lsr w6, w4, #23
orr w4, w5, w6
lsr w5, w4, #9
mov w6, #52556
add w5, w5, w6
eor w4, w4, w5
// group 4
add w5, w2, w3
mov w6, #24750
mul w5, w5, w6
add w4, w4, w5
add w7, w2, #4
sdiv w9, w7, w8
mul w9, w9, w8
sub w9, w7, w9
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w4, w4, w11
mov w6, #52829
mul w4, w4, w6
add w4, w4, #32
lsl w5, w4, #1
lsr w6, w4, #31
orr w4, w5, w6
lsr w5, w4, #6
mov w6, #25297
add w5, w5, w6
eor w4, w4, w5
str w4, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s003_end:

# block r_s001_body_s001_body_s004_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #8
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s004_else

# block r_s001_body_s001_body_s004_then_left_left
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 39269u;
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #39269
mul w8, w8, w10
ldr w11, [sp, #16]
add w11, w11, w8
str w11, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 3) % lego_v1_n]) * 33463u + 5u;
ldr w8, [sp, #20]
add w8, w8, #3
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x12, [sp, #0]
sxtw x10, w10
ldr w13, [x12, x10, lsl #2]
ldr w11, [sp, #16]
eor w11, w11, w13
mov w14, #33463
mul w11, w11, w14
add w11, w11, #5
str w11, [sp, #16]
// lego_v3_state = (lego_v3_state << 2) | (lego_v3_state >> 30);
ldr w11, [sp, #16]
ror w11, w11, #30
str w11, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 4) + 39445u;
ldr w11, [sp, #16]
lsr w8, w11, #4
mov w9, #39445
add w8, w8, w9
eor w11, w11, w8
str w11, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 7519u;
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #7519
mul w8, w8, w10
ldr w11, [sp, #16]
add w11, w11, w8
str w11, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 1) % lego_v1_n]) * 39339u + 9u;
ldr w8, [sp, #20]
add w8, w8, #1
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x12, [sp, #0]
sxtw x10, w10
ldr w13, [x12, x10, lsl #2]
ldr w11, [sp, #16]
eor w11, w11, w13
mov w14, #39339
mul w11, w11, w14
add w11, w11, #9
str w11, [sp, #16]
// lego_v3_state = (lego_v3_state << 3) | (lego_v3_state >> 29);
ldr w11, [sp, #16]
ror w11, w11, #29
str w11, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 3) + 26603u;
ldr w11, [sp, #16]
lsr w8, w11, #3
mov w9, #26603
add w8, w8, w9
eor w11, w11, w8
str w11, [sp, #16]

# block r_s001_body_s001_body_s004_then_left_right
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 49030u;
ldr w8, [sp, #16]
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #49030
mul w9, w9, w11
add w8, w8, w9
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 5) % lego_v1_n]) * 27745u + 13u;
ldr w9, [sp, #20]
add w9, w9, #5
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
sxtw x9, w9
ldr w9, [x12, x9, lsl #2]
eor w8, w8, w9
mov w11, #27745
mul w8, w8, w11
add w8, w8, #13
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state << 5) | (lego_v3_state >> 27);
lsl w9, w8, #5
lsr w10, w8, #27
orr w8, w9, w10
str w8, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 15) + 19179u;
lsr w9, w8, #15
mov w10, #19179
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 37643u;
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #37643
mul w9, w9, w11
add w8, w8, w9
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 3) % lego_v1_n]) * 36123u + 17u;
ldr w9, [sp, #20]
add w9, w9, #3
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
sxtw x9, w9
ldr w9, [x12, x9, lsl #2]
eor w8, w8, w9
mov w11, #36123
mul w8, w8, w11
add w8, w8, #17
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state << 3) | (lego_v3_state >> 29);
lsl w9, w8, #3
lsr w10, w8, #29
orr w8, w9, w10
str w8, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 52811u;
lsr w9, w8, #13
mov w10, #52811
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]

# block r_s001_body_s001_body_s004_then_right_left
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 28303u;
ldr w0, [sp, #16]
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #28303
mul w1, w1, w3
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 5) % lego_v1_n]) * 51829u + 21u;
ldr w1, [sp, #20]
add w1, w1, #5
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
ldr x4, [sp, #0]
sxtw x1, w1
ldr w1, [x4, x1, lsl #2]
eor w0, w0, w1
mov w3, #51829
mul w0, w0, w3
add w0, w0, #21
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 15) | (lego_v3_state >> 17);
ror w0, w0, #17
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 7) + 17206u;
lsr w1, w0, #7
mov w2, #17206
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 46073u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #46073
mul w1, w1, w3
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 6) % lego_v1_n]) * 36547u + 25u;
ldr w1, [sp, #20]
add w1, w1, #6
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
ldr x4, [sp, #0]
sxtw x1, w1
ldr w1, [x4, x1, lsl #2]
eor w0, w0, w1
mov w3, #36547
mul w0, w0, w3
add w0, w0, #25
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 14) | (lego_v3_state >> 18);
ror w0, w0, #18
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 15) + 2378u;
lsr w1, w0, #15
mov w2, #2378
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]

# block r_s001_body_s001_body_s004_then_right_right
// state += (unsigned int)(i + round) * 35378u;
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #35378
mul w8, w8, w10
ldr w9, [sp, #16]
add w9, w9, w8
str w9, [sp, #16]
// state = (state ^ a[(i + 2) % n]) * 52977u + 29u;
ldr w8, [sp, #20]
add w8, w8, #2
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
ldr w8, [x11, w8, sxtw #2]
ldr w9, [sp, #16]
eor w8, w9, w8
mov w10, #52977
mul w8, w8, w10
add w8, w8, #29
str w8, [sp, #16]
// state = (state << 13) | (state >> 19);
ldr w8, [sp, #16]
lsl w9, w8, #13
lsr w10, w8, #19
orr w8, w9, w10
str w8, [sp, #16]
// state ^= (state >> 5) + 25356u;
ldr w8, [sp, #16]
lsr w9, w8, #5
mov w10, #25356
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]
// state += (unsigned int)(i + round) * 16345u;
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #16345
mul w8, w8, w10
ldr w9, [sp, #16]
add w9, w9, w8
str w9, [sp, #16]
// state = (state ^ a[(i + 7) % n]) * 30043u + 33u;
ldr w8, [sp, #20]
add w8, w8, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
ldr w8, [x11, w8, sxtw #2]
ldr w9, [sp, #16]
eor w8, w9, w8
mov w10, #30043
mul w8, w8, w10
add w8, w8, #33
str w8, [sp, #16]
// state = (state << 14) | (state >> 18);
ldr w8, [sp, #16]
lsl w9, w8, #14
lsr w10, w8, #18
orr w8, w9, w10
str w8, [sp, #16]
// state ^= (state >> 15) + 21015u;
ldr w8, [sp, #16]
lsr w9, w8, #15
mov w10, #21015
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s004_end
L_long_kernel_r_s001_body_s001_body_s004_else:

# block r_s001_body_s001_body_s004_else_left
// state = (state ^ a[(i+0)%n]) * 60803u + 4u
ldr w2, [sp, #16]
ldr w3, [sp, #20]
ldr w4, [sp, #8]
sdiv w5, w3, w4
mul w5, w5, w4
sub w5, w3, w5
ldr x6, [sp, #0]
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w2, w2, w7
mov w8, #60803
mul w2, w2, w8
add w2, w2, #4
// state = (state << 10) | (state >> 22)
ror w2, w2, #22
// state ^= (state >> 4) + 16640u
lsr w9, w2, #4
mov w8, #16640
add w9, w9, w8
eor w2, w2, w9
// state += (unsigned)(i+round)*46120u
ldr w10, [sp, #24]
add w11, w3, w10
mov w8, #46120
mul w11, w11, w8
add w2, w2, w11
// state = (state ^ a[(i+0)%n]) * 26869u + 8u
sdiv w5, w3, w4
mul w5, w5, w4
sub w5, w3, w5
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w2, w2, w7
mov w8, #26869
mul w2, w2, w8
add w2, w2, #8
// state = (state << 7) | (state >> 25)
ror w2, w2, #25
// state ^= (state >> 13) + 5862u
lsr w9, w2, #13
mov w8, #5862
add w9, w9, w8
eor w2, w2, w9
// state += (unsigned)(i+round)*25870u
add w11, w3, w10
mov w8, #25870
mul w11, w11, w8
add w2, w2, w11
// state = (state ^ a[(i+7)%n]) * 43765u + 12u
add w12, w3, #7
sdiv w5, w12, w4
mul w5, w5, w4
sub w5, w12, w5
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w2, w2, w7
mov w8, #43765
mul w2, w2, w8
add w2, w2, #12
// state = (state << 2) | (state >> 30)
ror w2, w2, #30
// state ^= (state >> 10) + 51668u
lsr w9, w2, #10
mov w8, #51668
add w9, w9, w8
eor w2, w2, w9
// state += (unsigned)(i+round)*26323u
add w11, w3, w10
mov w8, #26323
mul w11, w11, w8
add w2, w2, w11
// state = (state ^ a[(i+3)%n]) * 33481u + 16u
add w12, w3, #3
sdiv w5, w12, w4
mul w5, w5, w4
sub w5, w12, w5
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w2, w2, w7
mov w8, #33481
mul w2, w2, w8
add w2, w2, #16
// state = (state << 15) | (state >> 17)
ror w2, w2, #17
// state ^= (state >> 8) + 10271u
lsr w9, w2, #8
mov w8, #10271
add w9, w9, w8
eor w2, w2, w9
// state += (unsigned)(i+round)*59651u
add w11, w3, w10
mov w8, #59651
mul w11, w11, w8
add w2, w2, w11
// store state
str w2, [sp, #16]

# block r_s001_body_s001_body_s004_else_right
// index = (i + 0) % n
ldr w1, [sp, #20]
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
// load a[index]
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
// state = (state ^ a[idx]) * 50265 + 20
ldr w6, [sp, #16]
eor w6, w6, w5
mov w7, #50265
mul w6, w6, w7
add w6, w6, #20
// state = (state<<2) | (state>>30)
lsl w7, w6, #2
lsr w8, w6, #30
orr w6, w7, w8
// state ^= (state>>9) + 30891
lsr w7, w6, #9
mov w8, #30891
add w7, w7, w8
eor w6, w6, w7
// state += (unsigned)(i + round) * 14136
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #14136
mul w9, w9, w11
add w6, w6, w9
str w6, [sp, #16]
// second: state = (state ^ a[(i+0)%n]) * 11281 + 24
ldr w1, [sp, #20]
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w6, w6, w5
mov w7, #11281
mul w6, w6, w7
add w6, w6, #24
lsl w7, w6, #2
lsr w8, w6, #30
orr w6, w7, w8
lsr w7, w6, #1
mov w8, #56277
add w7, w7, w8
eor w6, w6, w7
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #1576
mul w9, w9, w11
add w6, w6, w9
str w6, [sp, #16]
// third: state = (state ^ a[(i+1)%n]) * 9765 + 28
ldr w1, [sp, #20]
add w1, w1, #1
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w6, w6, w5
mov w7, #9765
mul w6, w6, w7
add w6, w6, #28
lsl w7, w6, #7
lsr w8, w6, #25
orr w6, w7, w8
lsr w7, w6, #13
mov w8, #64745
add w7, w7, w8
eor w6, w6, w7
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #27172
mul w9, w9, w11
add w6, w6, w9
str w6, [sp, #16]
// fourth: state = (state ^ a[(i+5)%n]) * 4955 + 32
ldr w1, [sp, #20]
add w1, w1, #5
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w6, w6, w5
mov w7, #4955
mul w6, w6, w7
add w6, w6, #32
lsl w7, w6, #12
lsr w8, w6, #20
orr w6, w7, w8
lsr w7, w6, #15
mov w8, #24200
add w7, w7, w8
eor w6, w6, w7
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #65437
mul w9, w9, w11
add w6, w6, w9
str w6, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s004_end:

# block r_s001_body_s001_body_s005_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #16
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s005_else

# block r_s001_body_s001_body_s005_then_left
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 5) % lego_v1_n]) * 23949u + 5u;
ldr w8, [sp, #16]
ldr w9, [sp, #20]
add w9, w9, #5
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w8, w8, w13
mov w14, #23949
mul w8, w8, w14
add w8, w8, #5
// lego_v3_state = (lego_v3_state << 12) | (lego_v3_state >> 20);
lsl w9, w8, #12
lsr w10, w8, #20
orr w8, w9, w10
// lego_v3_state ^= (lego_v3_state >> 7) + 34942u;
lsr w9, w8, #7
mov w10, #34942
add w9, w9, w10
eor w8, w8, w9
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 46179u;
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #46179
mul w9, w9, w11
add w8, w8, w9
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 6407u + 9u;
ldr w9, [sp, #20]
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w8, w8, w13
mov w14, #6407
mul w8, w8, w14
add w8, w8, #9
// lego_v3_state = (lego_v3_state << 5) | (lego_v3_state >> 27);
lsl w9, w8, #5
lsr w10, w8, #27
orr w8, w9, w10
// lego_v3_state ^= (lego_v3_state >> 15) + 27045u;
lsr w9, w8, #15
mov w10, #27045
add w9, w9, w10
eor w8, w8, w9
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 4104u;
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #4104
mul w9, w9, w11
add w8, w8, w9
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 2) % lego_v1_n]) * 29269u + 13u;
ldr w9, [sp, #20]
add w9, w9, #2
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w8, w8, w13
mov w14, #29269
mul w8, w8, w14
add w8, w8, #13
// lego_v3_state = (lego_v3_state << 11) | (lego_v3_state >> 21);
lsl w9, w8, #11
lsr w10, w8, #21
orr w8, w9, w10
// lego_v3_state ^= (lego_v3_state >> 15) + 39184u;
lsr w9, w8, #15
mov w10, #39184
add w9, w9, w10
eor w8, w8, w9
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 28800u;
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #28800
mul w9, w9, w11
add w8, w8, w9
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 7) % lego_v1_n]) * 65315u + 17u;
ldr w9, [sp, #20]
add w9, w9, #7
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w8, w8, w13
mov w14, #65315
mul w8, w8, w14
add w8, w8, #17
// lego_v3_state = (lego_v3_state << 14) | (lego_v3_state >> 18);
lsl w9, w8, #14
lsr w10, w8, #18
orr w8, w9, w10
// lego_v3_state ^= (lego_v3_state >> 7) + 35877u;
lsr w9, w8, #7
mov w10, #35877
add w9, w9, w10
eor w8, w8, w9
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 44608u;
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #44608
mul w9, w9, w11
add w8, w8, w9
// store lego_v3_state
str w8, [sp, #16]

# block r_s001_body_s001_body_s005_then_right
ldr w2, [sp, #16]
ldr w3, [sp, #20]
add w4, w3, #3
ldr w5, [sp, #8]
sdiv w6, w4, w5
mul w6, w6, w5
sub w4, w4, w6
sxtw x4, w4
ldr x7, [sp, #0]
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #26959
mul w2, w2, w9
add w2, w2, #21
lsl w10, w2, #2
lsr w11, w2, #30
orr w2, w10, w11
lsr w10, w2, #8
mov w11, #31184
add w10, w10, w11
eor w2, w2, w10
ldr w3, [sp, #20]
ldr w12, [sp, #24]
add w10, w3, w12
mov w11, #38917
mul w10, w10, w11
add w2, w2, w10
add w4, w3, #6
sdiv w6, w4, w5
mul w6, w6, w5
sub w4, w4, w6
sxtw x4, w4
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #57881
mul w2, w2, w9
add w2, w2, #25
lsl w10, w2, #8
lsr w11, w2, #24
orr w2, w10, w11
lsr w10, w2, #6
mov w11, #12851
add w10, w10, w11
eor w2, w2, w10
add w10, w3, w12
mov w11, #64017
mul w10, w10, w11
add w2, w2, w10
add w4, w3, #4
sdiv w6, w4, w5
mul w6, w6, w5
sub w4, w4, w6
sxtw x4, w4
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #1985
mul w2, w2, w9
add w2, w2, #29
lsl w10, w2, #15
lsr w11, w2, #17
orr w2, w10, w11
lsr w10, w2, #4
mov w11, #9283
add w10, w10, w11
eor w2, w2, w10
add w10, w3, w12
mov w11, #50538
mul w10, w10, w11
add w2, w2, w10
add w4, w3, #6
sdiv w6, w4, w5
mul w6, w6, w5
sub w4, w4, w6
sxtw x4, w4
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #5513
mul w2, w2, w9
add w2, w2, #33
lsl w10, w2, #2
lsr w11, w2, #30
orr w2, w10, w11
lsr w10, w2, #7
mov w11, #27093
add w10, w10, w11
eor w2, w2, w10
add w10, w3, w12
mov w11, #30588
mul w10, w10, w11
add w2, w2, w10
str w2, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s005_end
L_long_kernel_r_s001_body_s001_body_s005_else:

# block r_s001_body_s001_body_s005_else_left
// state = (state<<5)|(state>>27)
ldr w0, [sp, #16]
lsl w1, w0, #5
lsr w2, w0, #27
orr w0, w1, w2
// state ^= (state>>8)+59330u
lsr w1, w0, #8
mov w2, #59330
add w1, w1, w2
eor w0, w0, w1
// state += (i+round)*33474u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #33474
mul w3, w3, w5
add w0, w0, w3
// state = (state ^ a[(i+4)%n])*14673u + 8u
ldr w3, [sp, #20]
add w3, w3, #4
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
sxtw x5, w5
ldr x6, [sp, #0]
ldr w6, [x6, x5, lsl #2]
eor w0, w0, w6
mov w7, #14673
mul w0, w0, w7
add w0, w0, #8
// state = (state<<11)|(state>>21)
lsl w1, w0, #11
lsr w2, w0, #21
orr w0, w1, w2
// state ^= (state>>6)+10238u
lsr w1, w0, #6
mov w2, #10238
add w1, w1, w2
eor w0, w0, w1
// state += (i+round)*63197u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #63197
mul w3, w3, w5
add w0, w0, w3
// state = (state ^ a[(i+1)%n])*45199u + 12u
ldr w3, [sp, #20]
add w3, w3, #1
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
sxtw x5, w5
ldr x6, [sp, #0]
ldr w6, [x6, x5, lsl #2]
eor w0, w0, w6
mov w7, #45199
mul w0, w0, w7
add w0, w0, #12
// state = (state<<4)|(state>>28)
lsl w1, w0, #4
lsr w2, w0, #28
orr w0, w1, w2
// state ^= (state>>12)+39507u
lsr w1, w0, #12
mov w2, #39507
add w1, w1, w2
eor w0, w0, w1
// state += (i+round)*59917u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #59917
mul w3, w3, w5
add w0, w0, w3
// state = (state ^ a[(i+5)%n])*14787u + 16u
ldr w3, [sp, #20]
add w3, w3, #5
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
sxtw x5, w5
ldr x6, [sp, #0]
ldr w6, [x6, x5, lsl #2]
eor w0, w0, w6
mov w7, #14787
mul w0, w0, w7
add w0, w0, #16
// state = (state<<12)|(state>>20)
lsl w1, w0, #12
lsr w2, w0, #20
orr w0, w1, w2
// state ^= (state>>12)+45339u
lsr w1, w0, #12
mov w2, #45339
add w1, w1, w2
eor w0, w0, w1
// state += (i+round)*58956u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #58956
mul w3, w3, w5
add w0, w0, w3
// state = (state ^ a[(i+1)%n])*44033u + 20u
ldr w3, [sp, #20]
add w3, w3, #1
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
sxtw x5, w5
ldr x6, [sp, #0]
ldr w6, [x6, x5, lsl #2]
eor w0, w0, w6
mov w7, #44033
mul w0, w0, w7
add w0, w0, #20
str w0, [sp, #16]

# block r_s001_body_s001_body_s005_else_right
ldr w0, [sp, #16]
lsl w1, w0, #14
lsr w2, w0, #18
orr w0, w1, w2
str w0, [sp, #16]
lsr w1, w0, #11
mov w10, #43539
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #62442
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
ldr w3, [sp, #20]
add w3, w3, #6
ldr w4, [sp, #8]
sdiv w6, w3, w4
msub w3, w6, w4, w3
ldr x7, [sp, #0]
sxtw x3, w3
ldr w8, [x7, x3, lsl #2]
eor w0, w0, w8
mov w9, #15927
mul w0, w0, w9
add w0, w0, #24
str w0, [sp, #16]
lsl w1, w0, #9
lsr w2, w0, #23
orr w0, w1, w2
str w0, [sp, #16]
lsr w1, w0, #4
mov w10, #25316
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #44705
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
ldr w3, [sp, #20]
add w3, w3, #6
ldr w4, [sp, #8]
sdiv w6, w3, w4
msub w3, w6, w4, w3
ldr x7, [sp, #0]
sxtw x3, w3
ldr w8, [x7, x3, lsl #2]
eor w0, w0, w8
mov w9, #47989
mul w0, w0, w9
add w0, w0, #28
str w0, [sp, #16]
lsl w1, w0, #12
lsr w2, w0, #20
orr w0, w1, w2
str w0, [sp, #16]
lsr w1, w0, #8
mov w10, #47865
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #9969
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
ldr w3, [sp, #20]
add w3, w3, #3
ldr w4, [sp, #8]
sdiv w6, w3, w4
msub w3, w6, w4, w3
ldr x7, [sp, #0]
sxtw x3, w3
ldr w8, [x7, x3, lsl #2]
eor w0, w0, w8
mov w9, #5123
mul w0, w0, w9
add w0, w0, #32
str w0, [sp, #16]
lsl w1, w0, #1
lsr w2, w0, #31
orr w0, w1, w2
str w0, [sp, #16]
lsr w1, w0, #10
mov w10, #24469
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #22531
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
ldr w3, [sp, #20]
add w3, w3, #4
ldr w4, [sp, #8]
sdiv w6, w3, w4
msub w3, w6, w4, w3
ldr x7, [sp, #0]
sxtw x3, w3
ldr w8, [x7, x3, lsl #2]
eor w0, w0, w8
mov w9, #38017
mul w0, w0, w9
add w0, w0, #36
str w0, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s005_end:

# block r_s001_body_s001_body_s006_condition
ldr w8, [sp, #16]
ldr w9, [sp, #12]
eor w8, w8, w9
and w8, w8, #32
cmp w8, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s006_else

# block r_s001_body_s001_body_s006_then_left
// lego_v3_state = (lego_v3_state << 1) | (lego_v3_state >> 31)
ldr w0, [sp, #16]
ror w0, w0, #31
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 5) + 30587u
lsr w1, w0, #5
mov w2, #30587
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 36071u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #36071
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 7) % lego_v1_n]) * 37887u + 9u
ldr w6, [sp, #20]
add w6, w6, #7
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
ldr x9, [sp, #0]
sxtw x8, w8
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w11, #37887
mul w0, w0, w11
add w0, w0, #9
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 13) | (lego_v3_state >> 19)
ror w0, w0, #19
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 64948u
lsr w1, w0, #13
mov w2, #64948
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 20025u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #20025
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 35301u + 13u
ldr w6, [sp, #20]
add w6, w6, #0
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
ldr x9, [sp, #0]
sxtw x8, w8
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w11, #35301
mul w0, w0, w11
add w0, w0, #13
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 2) | (lego_v3_state >> 30)
ror w0, w0, #30
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 1) + 63410u
lsr w1, w0, #1
mov w2, #63410
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 50884u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #50884
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 4) % lego_v1_n]) * 13821u + 17u
ldr w6, [sp, #20]
add w6, w6, #4
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
ldr x9, [sp, #0]
sxtw x8, w8
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w11, #13821
mul w0, w0, w11
add w0, w0, #17
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 2) | (lego_v3_state >> 30)
ror w0, w0, #30
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 12) + 56683u
lsr w1, w0, #12
mov w2, #56683
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 32775u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #32775
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 7) % lego_v1_n]) * 15149u + 21u
ldr w6, [sp, #20]
add w6, w6, #7
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
ldr x9, [sp, #0]
sxtw x8, w8
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w11, #15149
mul w0, w0, w11
add w0, w0, #21
str w0, [sp, #16]

# block r_s001_body_s001_body_s006_then_right
ldr w0, [sp, #16]
lsl w1, w0, #9
lsr w2, w0, #23
orr w0, w1, w2
// state ^= (state >> 5) + 27933u
lsr w1, w0, #5
mov w2, #27933
add w1, w1, w2
eor w0, w0, w1
// state += (unsigned)(i + round) * 33897u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #33897
mul w3, w3, w5
add w0, w0, w3
// index = (i + 4) % n
ldr w3, [sp, #20]
add w3, w3, #4
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
// load a[index]
ldr x6, [sp, #0]
sxtw x7, w5
ldr w8, [x6, x7, lsl #2]
eor w0, w0, w8
mov w9, #53009
mul w0, w0, w9
add w0, w0, #25
// state = (state << 2) | (state >> 30)
lsl w1, w0, #2
lsr w2, w0, #30
orr w0, w1, w2
// state ^= (state >> 1) + 8607u
lsr w1, w0, #1
mov w2, #8607
add w1, w1, w2
eor w0, w0, w1
// state += (unsigned)(i + round) * 34715u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #34715
mul w3, w3, w5
add w0, w0, w3
// index = (i + 7) % n
ldr w3, [sp, #20]
add w3, w3, #7
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x7, w5
ldr w8, [x6, x7, lsl #2]
eor w0, w0, w8
mov w9, #33129
mul w0, w0, w9
add w0, w0, #29
// state = (state << 9) | (state >> 23)
lsl w1, w0, #9
lsr w2, w0, #23
orr w0, w1, w2
// state ^= (state >> 14) + 44911u
lsr w1, w0, #14
mov w2, #44911
add w1, w1, w2
eor w0, w0, w1
// state += (unsigned)(i + round) * 60404u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #60404
mul w3, w3, w5
add w0, w0, w3
// index = (i + 4) % n
ldr w3, [sp, #20]
add w3, w3, #4
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x7, w5
ldr w8, [x6, x7, lsl #2]
eor w0, w0, w8
mov w9, #33627
mul w0, w0, w9
add w0, w0, #33
// state = (state << 5) | (state >> 27)
lsl w1, w0, #5
lsr w2, w0, #27
orr w0, w1, w2
// state ^= (state >> 3) + 62417u
lsr w1, w0, #3
mov w2, #62417
add w1, w1, w2
eor w0, w0, w1
// state += (unsigned)(i + round) * 7854u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #7854
mul w3, w3, w5
add w0, w0, w3
// index = (i + 5) % n
ldr w3, [sp, #20]
add w3, w3, #5
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x7, w5
ldr w8, [x6, x7, lsl #2]
eor w0, w0, w8
mov w9, #35351
mul w0, w0, w9
add w0, w0, #37
str w0, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s006_end
L_long_kernel_r_s001_body_s001_body_s006_else:

# block r_s001_body_s001_body_s006_else_left
// lego_v3_state ^= (lego_v3_state >> 6) + 30166u;
ldr w8, [sp, #16]
lsr w9, w8, #6
mov w10, #30166
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 64091u;
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w10, #64091
mul w9, w9, w10
add w8, w8, w9
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 1) % lego_v1_n]) * 39113u + 8u;
ldr w9, [sp, #20]
add w9, w9, #1
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x10, [sp, #0]
sxtw x9, w9
ldr w9, [x10, x9, lsl #2]
eor w8, w8, w9
mov w9, #39113
mul w8, w8, w9
add w8, w8, #8
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state << 7) | (lego_v3_state >> 25);
lsl w9, w8, #7
lsr w10, w8, #25
orr w8, w9, w10
str w8, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 46725u;
lsr w9, w8, #13
mov w10, #46725
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 9995u;
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w10, #9995
mul w9, w9, w10
add w8, w8, w9
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 6) % lego_v1_n]) * 46875u + 12u;
ldr w9, [sp, #20]
add w9, w9, #6
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x10, [sp, #0]
sxtw x9, w9
ldr w9, [x10, x9, lsl #2]
eor w8, w8, w9
mov w9, #46875
mul w8, w8, w9
add w8, w8, #12
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state << 7) | (lego_v3_state >> 25);
lsl w9, w8, #7
lsr w10, w8, #25
orr w8, w9, w10
str w8, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 2) + 44781u;
lsr w9, w8, #2
mov w10, #44781
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 50304u;
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w10, #50304
mul w9, w9, w10
add w8, w8, w9
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 49807u + 16u;
ldr w9, [sp, #20]
add w9, w9, #0
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x10, [sp, #0]
sxtw x9, w9
ldr w9, [x10, x9, lsl #2]
eor w8, w8, w9
mov w9, #49807
mul w8, w8, w9
add w8, w8, #16
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state << 6) | (lego_v3_state >> 26);
lsl w9, w8, #6
lsr w10, w8, #26
orr w8, w9, w10
str w8, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 38847u;
lsr w9, w8, #13
mov w10, #38847
add w9, w9, w10
eor w8, w8, w9
str w8, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 12560u;
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w10, #12560
mul w9, w9, w10
add w8, w8, w9
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 5) % lego_v1_n]) * 48849u + 20u;
ldr w9, [sp, #20]
add w9, w9, #5
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x10, [sp, #0]
sxtw x9, w9
ldr w9, [x10, x9, lsl #2]
eor w8, w8, w9
mov w9, #48849
mul w8, w8, w9
add w8, w8, #20
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state << 14) | (lego_v3_state >> 18);
lsl w9, w8, #14
lsr w10, w8, #18
orr w8, w9, w10
str w8, [sp, #16]

# block r_s001_body_s001_body_s006_else_right
ldr w8, [sp, #16]
lsr w9, w8, #10
mov w1, #49014
add w9, w9, w1
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #55480
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #5
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w15, w15, w14, w13
ldr x0, [sp, #0]
sxtw x15, w15
ldr w10, [x0, x15, lsl #2]
eor w8, w8, w10
mov w12, #36703
mul w8, w8, w12
add w8, w8, #24
lsl w9, w8, #7
lsr w10, w8, #25
orr w8, w9, w10
lsr w9, w8, #14
mov w1, #33614
add w9, w9, w1
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #18522
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #3
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w15, w15, w14, w13
ldr x0, [sp, #0]
sxtw x15, w15
ldr w10, [x0, x15, lsl #2]
eor w8, w8, w10
mov w12, #40469
mul w8, w8, w12
add w8, w8, #28
lsl w9, w8, #11
lsr w10, w8, #21
orr w8, w9, w10
lsr w9, w8, #9
mov w1, #17176
add w9, w9, w1
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #16576
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #4
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w15, w15, w14, w13
ldr x0, [sp, #0]
sxtw x15, w15
ldr w10, [x0, x15, lsl #2]
eor w8, w8, w10
mov w12, #12445
mul w8, w8, w12
add w8, w8, #32
lsl w9, w8, #7
lsr w10, w8, #25
orr w8, w9, w10
lsr w9, w8, #7
mov w1, #23777
add w9, w9, w1
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #56427
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #6
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w15, w15, w14, w13
ldr x0, [sp, #0]
sxtw x15, w15
ldr w10, [x0, x15, lsl #2]
eor w8, w8, w10
mov w12, #52095
mul w8, w8, w12
add w8, w8, #36
lsl w9, w8, #10
lsr w10, w8, #22
orr w8, w9, w10
str w8, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s006_end:

# block r_s001_body_s001_body_s007_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #64
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s007_else

# block r_s001_body_s001_body_s007_then_left
// lego_v3_state ^= (lego_v3_state >> 3) + 5422u;
ldr w0, [sp, #16]
lsr w1, w0, #3
mov w11, #5422
add w1, w1, w11
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 29607u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #29607
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 17261u + 9u;
ldr w5, [sp, #20]
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w10, #17261
mul w0, w0, w10
add w0, w0, #9
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 9) | (lego_v3_state >> 23);
lsl w1, w0, #9
lsr w2, w0, #23
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 4) + 50261u;
lsr w1, w0, #4
mov w3, #50261
add w1, w1, w3
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 29323u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #29323
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 3) % lego_v1_n]) * 6789u + 13u;
ldr w5, [sp, #20]
add w5, w5, #3
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w10, #6789
mul w0, w0, w10
add w0, w0, #13
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 3) | (lego_v3_state >> 29);
lsl w1, w0, #3
lsr w2, w0, #29
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 6) + 65074u;
lsr w1, w0, #6
mov w3, #65074
add w1, w1, w3
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 53518u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #53518
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 56793u + 17u;
ldr w5, [sp, #20]
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w10, #56793
mul w0, w0, w10
add w0, w0, #17
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 15) | (lego_v3_state >> 17);
lsl w1, w0, #15
lsr w2, w0, #17
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 7) + 58828u;
lsr w1, w0, #7
mov w3, #58828
add w1, w1, w3
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 61001u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #61001
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 3) % lego_v1_n]) * 60633u + 21u;
ldr w5, [sp, #20]
add w5, w5, #3
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w10, #60633
mul w0, w0, w10
add w0, w0, #21
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 5) | (lego_v3_state >> 27);
lsl w1, w0, #5
lsr w2, w0, #27
orr w0, w1, w2
str w0, [sp, #16]

# block r_s001_body_s001_body_s007_then_right
// lego_v3_state ^= (lego_v3_state >> 2) + 51583u;
ldr w0, [sp, #16]
lsr w1, w0, #2
mov w2, #51583
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 49006u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #49006
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 2) % lego_v1_n]) * 4015u + 25u;
ldr w1, [sp, #20]
add w1, w1, #2
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
ldr x3, [sp, #0]
sxtw x1, w1
ldr w1, [x3, x1, lsl #2]
eor w0, w0, w1
mov w1, #4015
mul w0, w0, w1
add w0, w0, #25
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 1) | (lego_v3_state >> 31);
ror w0, w0, #31
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 6) + 37008u;
lsr w1, w0, #6
mov w2, #37008
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 46951u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #46951
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 2) % lego_v1_n]) * 62191u + 29u;
ldr w1, [sp, #20]
add w1, w1, #2
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
ldr x3, [sp, #0]
sxtw x1, w1
ldr w1, [x3, x1, lsl #2]
eor w0, w0, w1
mov w1, #62191
mul w0, w0, w1
add w0, w0, #29
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 1) | (lego_v3_state >> 31);
ror w0, w0, #31
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 7) + 60787u;
lsr w1, w0, #7
mov w2, #60787
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 56106u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #56106
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 6) % lego_v1_n]) * 61199u + 33u;
ldr w1, [sp, #20]
add w1, w1, #6
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
ldr x3, [sp, #0]
sxtw x1, w1
ldr w1, [x3, x1, lsl #2]
eor w0, w0, w1
mov w1, #61199
mul w0, w0, w1
add w0, w0, #33
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 8) | (lego_v3_state >> 24);
ror w0, w0, #24
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 14) + 24816u;
lsr w1, w0, #14
mov w2, #24816
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 60964u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #60964
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 53611u + 37u;
ldr w1, [sp, #20]
add w1, w1, #0
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
ldr x3, [sp, #0]
sxtw x1, w1
ldr w1, [x3, x1, lsl #2]
eor w0, w0, w1
mov w1, #53611
mul w0, w0, w1
add w0, w0, #37
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 11) | (lego_v3_state >> 21);
ror w0, w0, #21
str w0, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s007_end
L_long_kernel_r_s001_body_s001_body_s007_else:

# block r_s001_body_s001_body_s007_else_left
// state += (unsigned)(i+round)*29838u
ldr w2, [sp, #16]
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w5, w3, w4
mov w6, #29838
mul w5, w5, w6
add w2, w2, w5
// idx = (i+4) % n ; load a[idx]
add w7, w3, #4
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
ldr x10, [sp, #0]
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #26941
mul w2, w2, w6
add w2, w2, #8
// rotate left 5 = (x<<5)|(x>>27)
ror w2, w2, #27
// state ^= (state>>9) + 11784u
lsr w13, w2, #9
mov w6, #11784
add w13, w13, w6
eor w2, w2, w13
// state += (unsigned)(i+round)*62056u
add w5, w3, w4
mov w6, #62056
mul w5, w5, w6
add w2, w2, w5
// idx = (i+2) % n ; load a[idx]
add w7, w3, #2
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #61909
mul w2, w2, w6
add w2, w2, #12
// rotate left 12 = (x<<12)|(x>>20)
ror w2, w2, #20
// state ^= (state>>9) + 17661u
lsr w13, w2, #9
mov w6, #17661
add w13, w13, w6
eor w2, w2, w13
// state += (unsigned)(i+round)*10954u
add w5, w3, w4
mov w6, #10954
mul w5, w5, w6
add w2, w2, w5
// idx = (i+6) % n ; load a[idx]
add w7, w3, #6
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #56377
mul w2, w2, w6
add w2, w2, #16
// rotate left 14 = (x<<14)|(x>>18)
ror w2, w2, #18
// state ^= (state>>15) + 62346u
lsr w13, w2, #15
mov w6, #62346
add w13, w13, w6
eor w2, w2, w13
// state += (unsigned)(i+round)*47080u
add w5, w3, w4
mov w6, #47080
mul w5, w5, w6
add w2, w2, w5
// idx = (i+2) % n ; load a[idx]
add w7, w3, #2
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #59563
mul w2, w2, w6
add w2, w2, #20
// rotate left 1 = (x<<1)|(x>>31)
ror w2, w2, #31
// state ^= (state>>14) + 20110u
lsr w13, w2, #14
mov w6, #20110
add w13, w13, w6
eor w2, w2, w13
// store state
str w2, [sp, #16]

# block r_s001_body_s001_body_s007_else_right
// state += (unsigned)(i + round) * 21281u
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #21281
mul w8, w8, w10
ldr w11, [sp, #16]
add w11, w11, w8
str w11, [sp, #16]
// idx = (i + 3) % n
ldr w8, [sp, #20]
add w8, w8, #3
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
// a[idx]
ldr x12, [sp, #0]
sxtw x10, w10
ldr w13, [x12, x10, lsl #2]
// state = (state ^ a[..]) * 29051u + 24u
ldr w11, [sp, #16]
eor w11, w11, w13
mov w14, #29051
mul w11, w11, w14
add w11, w11, #24
str w11, [sp, #16]
// state = (state << 7) | (state >> 25)
ror w11, w11, #25
str w11, [sp, #16]
// state ^= (state >> 5) + 43558u
lsr w8, w11, #5
mov w14, #43558
add w8, w8, w14
eor w11, w11, w8
str w11, [sp, #16]
// state += (unsigned)(i + round) * 41809u
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #41809
mul w8, w8, w10
add w11, w11, w8
str w11, [sp, #16]
// idx = (i + 0) % n
ldr w8, [sp, #20]
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x12, [sp, #0]
sxtw x10, w10
ldr w13, [x12, x10, lsl #2]
// state = (state ^ a[..]) * 36799u + 28u
ldr w11, [sp, #16]
eor w11, w11, w13
mov w14, #36799
mul w11, w11, w14
add w11, w11, #28
str w11, [sp, #16]
// state = (state << 10) | (state >> 22)
ror w11, w11, #22
str w11, [sp, #16]
// state ^= (state >> 4) + 3955u
lsr w8, w11, #4
mov w14, #3955
add w8, w8, w14
eor w11, w11, w8
str w11, [sp, #16]
// state += (unsigned)(i + round) * 34236u
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #34236
mul w8, w8, w10
add w11, w11, w8
str w11, [sp, #16]
// idx = (i + 5) % n
ldr w8, [sp, #20]
add w8, w8, #5
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x12, [sp, #0]
sxtw x10, w10
ldr w13, [x12, x10, lsl #2]
// state = (state ^ a[..]) * 48007u + 32u
ldr w11, [sp, #16]
eor w11, w11, w13
mov w14, #48007
mul w11, w11, w14
add w11, w11, #32
str w11, [sp, #16]
// state = (state << 11) | (state >> 21)
ror w11, w11, #21
str w11, [sp, #16]
// state ^= (state >> 3) + 33959u
lsr w8, w11, #3
mov w14, #33959
add w8, w8, w14
eor w11, w11, w8
str w11, [sp, #16]
// state += (unsigned)(i + round) * 40152u
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #40152
mul w8, w8, w10
add w11, w11, w8
str w11, [sp, #16]
// idx = (i + 7) % n
ldr w8, [sp, #20]
add w8, w8, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x12, [sp, #0]
sxtw x10, w10
ldr w13, [x12, x10, lsl #2]
// state = (state ^ a[..]) * 48441u + 36u
ldr w11, [sp, #16]
eor w11, w11, w13
mov w14, #48441
mul w11, w11, w14
add w11, w11, #36
str w11, [sp, #16]
// state = (state << 4) | (state >> 28)
ror w11, w11, #28
str w11, [sp, #16]
// state ^= (state >> 3) + 45262u
lsr w8, w11, #3
mov w14, #45262
add w8, w8, w14
eor w11, w11, w8
str w11, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s007_end:

# block r_s001_body_s001_body_s008_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #128
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s008_else

# block r_s001_body_s001_body_s008_then
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #37016
mul w9, w9, w11
ldr w8, [sp, #16]
add w8, w8, w9
ldr w10, [sp, #20]
add w10, w10, #4
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w10, w12, w11, w10
ldr x13, [sp, #0]
ldr w14, [x13, w10, sxtw #2]
eor w8, w8, w14
mov w15, #26863
mul w8, w8, w15
add w8, w8, #9
lsl w9, w8, #3
lsr w10, w8, #29
orr w8, w9, w10
lsr w9, w8, #15
mov w12, #11318
add w9, w9, w12
eor w8, w8, w9
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #61080
mul w9, w9, w11
add w8, w8, w9
ldr w10, [sp, #20]
add w10, w10, #2
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w10, w12, w11, w10
ldr x13, [sp, #0]
ldr w14, [x13, w10, sxtw #2]
eor w8, w8, w14
mov w15, #15177
mul w8, w8, w15
add w8, w8, #13
lsl w9, w8, #9
lsr w10, w8, #23
orr w8, w9, w10
lsr w9, w8, #5
mov w12, #23661
add w9, w9, w12
eor w8, w8, w9
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #23810
mul w9, w9, w11
add w8, w8, w9
ldr w10, [sp, #20]
add w10, w10, #2
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w10, w12, w11, w10
ldr x13, [sp, #0]
ldr w14, [x13, w10, sxtw #2]
eor w8, w8, w14
mov w15, #26413
mul w8, w8, w15
add w8, w8, #17
lsl w9, w8, #10
lsr w10, w8, #22
orr w8, w9, w10
lsr w9, w8, #11
mov w12, #3557
add w9, w9, w12
eor w8, w8, w9
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #33945
mul w9, w9, w11
add w8, w8, w9
ldr w10, [sp, #20]
add w10, w10, #4
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w10, w12, w11, w10
ldr x13, [sp, #0]
ldr w14, [x13, w10, sxtw #2]
eor w8, w8, w14
mov w15, #54499
mul w8, w8, w15
add w8, w8, #21
lsl w9, w8, #3
lsr w10, w8, #29
orr w8, w9, w10
lsr w9, w8, #8
mov w12, #46280
add w9, w9, w12
eor w8, w8, w9
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #30900
mul w9, w9, w11
add w8, w8, w9
ldr w10, [sp, #20]
add w10, w10, #4
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w10, w12, w11, w10
ldr x13, [sp, #0]
ldr w14, [x13, w10, sxtw #2]
eor w8, w8, w14
mov w15, #42367
mul w8, w8, w15
add w8, w8, #25
lsl w9, w8, #5
lsr w10, w8, #27
orr w8, w9, w10
lsr w9, w8, #12
add w9, w9, #833
eor w8, w8, w9
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #1665
mul w9, w9, w11
add w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w10, w12, w11, w10
ldr x13, [sp, #0]
ldr w14, [x13, w10, sxtw #2]
eor w8, w8, w14
mov w15, #45741
mul w8, w8, w15
add w8, w8, #29
lsl w9, w8, #6
lsr w10, w8, #26
orr w8, w9, w10
lsr w9, w8, #6
mov w12, #38152
add w9, w9, w12
eor w8, w8, w9
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #3217
mul w9, w9, w11
add w8, w8, w9
ldr w10, [sp, #20]
add w10, w10, #6
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w10, w12, w11, w10
ldr x13, [sp, #0]
ldr w14, [x13, w10, sxtw #2]
eor w8, w8, w14
mov w15, #63117
mul w8, w8, w15
add w8, w8, #33
lsl w9, w8, #9
lsr w10, w8, #23
orr w8, w9, w10
lsr w9, w8, #2
mov w12, #54480
add w9, w9, w12
eor w8, w8, w9
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #44080
mul w9, w9, w11
add w8, w8, w9
ldr w10, [sp, #20]
add w10, w10, #1
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w10, w12, w11, w10
ldr x13, [sp, #0]
ldr w14, [x13, w10, sxtw #2]
eor w8, w8, w14
mov w15, #44503
mul w8, w8, w15
add w8, w8, #37
lsl w9, w8, #12
lsr w10, w8, #20
orr w8, w9, w10
lsr w9, w8, #10
mov w12, #64707
add w9, w9, w12
eor w8, w8, w9
str w8, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s008_end
L_long_kernel_r_s001_body_s001_body_s008_else:

# block r_s001_body_s001_body_s008_else
// state = (state ^ a[(i+5)%n]) * 43745 + 8
ldr w9, [sp, #20]
add w9, w9, #5
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
ldr w8, [sp, #16]
eor w8, w8, w13
mov w14, #43745
mul w8, w8, w14
add w8, w8, #8
str w8, [sp, #16]
// state = (state << 8) | (state >> 24)
ror w8, w8, #24
str w8, [sp, #16]
// state ^= (state >> 8) + 46427
lsr w13, w8, #8
mov w14, #46427
add w13, w13, w14
eor w8, w8, w13
str w8, [sp, #16]
// state += (unsigned)(i+round) * 47510
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #47510
mul w9, w9, w14
add w8, w8, w9
str w8, [sp, #16]
// state = (state ^ a[(i+6)%n]) * 28517 + 12
ldr w9, [sp, #20]
add w9, w9, #6
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w8, w8, w13
mov w14, #28517
mul w8, w8, w14
add w8, w8, #12
str w8, [sp, #16]
// state = (state << 2) | (state >> 30)
ror w8, w8, #30
str w8, [sp, #16]
// state ^= (state >> 2) + 28268
lsr w13, w8, #2
mov w14, #28268
add w13, w13, w14
eor w8, w8, w13
str w8, [sp, #16]
// state += (unsigned)(i+round) * 62406
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #62406
mul w9, w9, w14
add w8, w8, w9
str w8, [sp, #16]
// state = (state ^ a[(i+4)%n]) * 1843 + 16
ldr w9, [sp, #20]
add w9, w9, #4
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w8, w8, w13
mov w14, #1843
mul w8, w8, w14
add w8, w8, #16
str w8, [sp, #16]
// state = (state << 2) | (state >> 30)
ror w8, w8, #30
str w8, [sp, #16]
// state ^= (state >> 6) + 54618
lsr w13, w8, #6
mov w14, #54618
add w13, w13, w14
eor w8, w8, w13
str w8, [sp, #16]
// state += (unsigned)(i+round) * 47623
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #47623
mul w9, w9, w14
add w8, w8, w9
str w8, [sp, #16]
// state = (state ^ a[(i+3)%n]) * 22005 + 20
ldr w9, [sp, #20]
add w9, w9, #3
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w8, w8, w13
mov w14, #22005
mul w8, w8, w14
add w8, w8, #20
str w8, [sp, #16]
// state = (state << 7) | (state >> 25)
ror w8, w8, #25
str w8, [sp, #16]
// state ^= (state >> 13) + 13256
lsr w13, w8, #13
mov w14, #13256
add w13, w13, w14
eor w8, w8, w13
str w8, [sp, #16]
// state += (unsigned)(i+round) * 51501
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #51501
mul w9, w9, w14
add w8, w8, w9
str w8, [sp, #16]
// state = (state ^ a[(i+3)%n]) * 24573 + 24
ldr w9, [sp, #20]
add w9, w9, #3
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w8, w8, w13
mov w14, #24573
mul w8, w8, w14
add w8, w8, #24
str w8, [sp, #16]
// state = (state << 4) | (state >> 28)
ror w8, w8, #28
str w8, [sp, #16]
// state ^= (state >> 13) + 48601
lsr w13, w8, #13
mov w14, #48601
add w13, w13, w14
eor w8, w8, w13
str w8, [sp, #16]
// state += (unsigned)(i+round) * 47980
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #47980
mul w9, w9, w14
add w8, w8, w9
str w8, [sp, #16]
// state = (state ^ a[(i+6)%n]) * 44355 + 28
ldr w9, [sp, #20]
add w9, w9, #6
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w8, w8, w13
mov w14, #44355
mul w8, w8, w14
add w8, w8, #28
str w8, [sp, #16]
// state = (state << 2) | (state >> 30)
ror w8, w8, #30
str w8, [sp, #16]
// state ^= (state >> 10) + 51357
lsr w13, w8, #10
mov w14, #51357
add w13, w13, w14
eor w8, w8, w13
str w8, [sp, #16]
// state += (unsigned)(i+round) * 10394
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #10394
mul w9, w9, w14
add w8, w8, w9
str w8, [sp, #16]
// state = (state ^ a[(i+0)%n]) * 48513 + 32
ldr w9, [sp, #20]
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w8, w8, w13
mov w14, #48513
mul w8, w8, w14
add w8, w8, #32
str w8, [sp, #16]
// state = (state << 14) | (state >> 18)
ror w8, w8, #18
str w8, [sp, #16]
// state ^= (state >> 11) + 4556
lsr w13, w8, #11
mov w14, #4556
add w13, w13, w14
eor w8, w8, w13
str w8, [sp, #16]
// state += (unsigned)(i+round) * 62209
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #62209
mul w9, w9, w14
add w8, w8, w9
str w8, [sp, #16]
// state = (state ^ a[(i+7)%n]) * 45609 + 36
ldr w9, [sp, #20]
add w9, w9, #7
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w8, w8, w13
mov w14, #45609
mul w8, w8, w14
add w8, w8, #36
str w8, [sp, #16]
// state = (state << 2) | (state >> 30)
ror w8, w8, #30
str w8, [sp, #16]
// state ^= (state >> 8) + 26732
lsr w13, w8, #8
mov w14, #26732
add w13, w13, w14
eor w8, w8, w13
str w8, [sp, #16]
// state += (unsigned)(i+round) * 9127
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #9127
mul w9, w9, w14
add w8, w8, w9
str w8, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s008_end:

# block r_s001_body_s001_body_s009_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #256
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s009_else

# block r_s001_body_s001_body_s009_then
// group 1: offset +3, mult 41851, add 9
ldr w8, [sp, #20]
add w8, w8, #3
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
ldr w13, [sp, #16]
eor w13, w13, w12
mov w14, #41851
mul w13, w13, w14
add w13, w13, #9
// rotate left 15
lsl w8, w13, #15
lsr w9, w13, #17
orr w13, w8, w9
// xor (state>>2)+58243
lsr w8, w13, #2
mov w9, #58243
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*56528
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #56528
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// group 2: offset +6, mult 11571, add 13
ldr w8, [sp, #20]
add w8, w8, #6
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #11571
mul w13, w13, w14
add w13, w13, #13
// rotate left 3
lsl w8, w13, #3
lsr w9, w13, #29
orr w13, w8, w9
// xor (state>>14)+27232
lsr w8, w13, #14
mov w9, #27232
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*2207
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #2207
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// group 3: offset +7, mult 3783, add 17
ldr w8, [sp, #20]
add w8, w8, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #3783
mul w13, w13, w14
add w13, w13, #17
// rotate left 11
lsl w8, w13, #11
lsr w9, w13, #21
orr w13, w8, w9
// xor (state>>3)+51364
lsr w8, w13, #3
mov w9, #51364
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*46904
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #46904
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// group 4: offset +0, mult 15009, add 21
ldr w8, [sp, #20]
add w8, w8, #0
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #15009
mul w13, w13, w14
add w13, w13, #21
// rotate left 2
lsl w8, w13, #2
lsr w9, w13, #30
orr w13, w8, w9
// xor (state>>10)+10283
lsr w8, w13, #10
mov w9, #10283
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*30879
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #30879
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// group 5: offset +0, mult 23029, add 25
ldr w8, [sp, #20]
add w8, w8, #0
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #23029
mul w13, w13, w14
add w13, w13, #25
// rotate left 1
lsl w8, w13, #1
lsr w9, w13, #31
orr w13, w8, w9
// xor (state>>11)+1054
lsr w8, w13, #11
mov w9, #1054
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*32722
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #32722
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// group 6: offset +2, mult 43341, add 29
ldr w8, [sp, #20]
add w8, w8, #2
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #43341
mul w13, w13, w14
add w13, w13, #29
// rotate left 3
lsl w8, w13, #3
lsr w9, w13, #29
orr w13, w8, w9
// xor (state>>13)+31469
lsr w8, w13, #13
mov w9, #31469
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*58202
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #58202
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// group 7: offset +0, mult 58053, add 33
ldr w8, [sp, #20]
add w8, w8, #0
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #58053
mul w13, w13, w14
add w13, w13, #33
// rotate left 8
lsl w8, w13, #8
lsr w9, w13, #24
orr w13, w8, w9
// xor (state>>15)+35479
lsr w8, w13, #15
mov w9, #35479
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*63379
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #63379
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// group 8: offset +7, mult 31841, add 37
ldr w8, [sp, #20]
add w8, w8, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w8, w10, w9, w8
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #31841
mul w13, w13, w14
add w13, w13, #37
// rotate left 10
lsl w8, w13, #10
lsr w9, w13, #22
orr w13, w8, w9
// xor (state>>5)+17457
lsr w8, w13, #5
mov w9, #17457
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*30759
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #30759
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s009_end
L_long_kernel_r_s001_body_s001_body_s009_else:

# block r_s001_body_s001_body_s009_else
ldr w9, [sp, #16]
// state = (state<<7)|(state>>25)
ror w9, w9, #25
// state ^= (state>>15) + 40426
lsr w10, w9, #15
mov w11, #40426
add w10, w10, w11
eor w9, w9, w10
// state += (i+round)*50384
ldr w12, [sp, #20]
ldr w13, [sp, #24]
add w12, w12, w13
mov w14, #50384
mul w12, w12, w14
add w9, w9, w12
// state = (state ^ a[(i+6)%n])*49899 + 12
ldr w12, [sp, #20]
add w12, w12, #6
ldr w13, [sp, #8]
sdiv w14, w12, w13
msub w14, w14, w13, w12
ldr x0, [sp, #0]
ldr w15, [x0, w14, sxtw #2]
eor w9, w9, w15
mov w14, #49899
mul w9, w9, w14
add w9, w9, #12
// state = (state<<8)|(state>>24)
ror w9, w9, #24
// state ^= (state>>9) + 52973
lsr w10, w9, #9
mov w11, #52973
add w10, w10, w11
eor w9, w9, w10
// state += (i+round)*20159
ldr w12, [sp, #20]
ldr w13, [sp, #24]
add w12, w12, w13
mov w14, #20159
mul w12, w12, w14
add w9, w9, w12
// state = (state ^ a[(i+6)%n])*177 + 16
ldr w12, [sp, #20]
add w12, w12, #6
ldr w13, [sp, #8]
sdiv w14, w12, w13
msub w14, w14, w13, w12
ldr x0, [sp, #0]
ldr w15, [x0, w14, sxtw #2]
eor w9, w9, w15
mov w14, #177
mul w9, w9, w14
add w9, w9, #16
// state = (state<<12)|(state>>20)
ror w9, w9, #20
// state ^= (state>>15) + 64673
lsr w10, w9, #15
mov w11, #64673
add w10, w10, w11
eor w9, w9, w10
// state += (i+round)*24953
ldr w12, [sp, #20]
ldr w13, [sp, #24]
add w12, w12, w13
mov w14, #24953
mul w12, w12, w14
add w9, w9, w12
// state = (state ^ a[(i+4)%n])*4189 + 20
ldr w12, [sp, #20]
add w12, w12, #4
ldr w13, [sp, #8]
sdiv w14, w12, w13
msub w14, w14, w13, w12
ldr x0, [sp, #0]
ldr w15, [x0, w14, sxtw #2]
eor w9, w9, w15
mov w14, #4189
mul w9, w9, w14
add w9, w9, #20
// state = (state<<15)|(state>>17)
ror w9, w9, #17
// state ^= (state>>13) + 49764
lsr w10, w9, #13
mov w11, #49764
add w10, w10, w11
eor w9, w9, w10
// state += (i+round)*42211
ldr w12, [sp, #20]
ldr w13, [sp, #24]
add w12, w12, w13
mov w14, #42211
mul w12, w12, w14
add w9, w9, w12
// state = (state ^ a[(i+2)%n])*18533 + 24
ldr w12, [sp, #20]
add w12, w12, #2
ldr w13, [sp, #8]
sdiv w14, w12, w13
msub w14, w14, w13, w12
ldr x0, [sp, #0]
ldr w15, [x0, w14, sxtw #2]
eor w9, w9, w15
mov w14, #18533
mul w9, w9, w14
add w9, w9, #24
// state = (state<<4)|(state>>28)
ror w9, w9, #28
// state ^= (state>>7) + 24953
lsr w10, w9, #7
mov w11, #24953
add w10, w10, w11
eor w9, w9, w10
// state += (i+round)*62326
ldr w12, [sp, #20]
ldr w13, [sp, #24]
add w12, w12, w13
mov w14, #62326
mul w12, w12, w14
add w9, w9, w12
// state = (state ^ a[(i+2)%n])*58735 + 28
ldr w12, [sp, #20]
add w12, w12, #2
ldr w13, [sp, #8]
sdiv w14, w12, w13
msub w14, w14, w13, w12
ldr x0, [sp, #0]
ldr w15, [x0, w14, sxtw #2]
eor w9, w9, w15
mov w14, #58735
mul w9, w9, w14
add w9, w9, #28
// state = (state<<10)|(state>>22)
ror w9, w9, #22
// state ^= (state>>2) + 29189
lsr w10, w9, #2
mov w11, #29189
add w10, w10, w11
eor w9, w9, w10
// state += (i+round)*13777
ldr w12, [sp, #20]
ldr w13, [sp, #24]
add w12, w12, w13
mov w14, #13777
mul w12, w12, w14
add w9, w9, w12
// state = (state ^ a[(i+6)%n])*37495 + 32
ldr w12, [sp, #20]
add w12, w12, #6
ldr w13, [sp, #8]
sdiv w14, w12, w13
msub w14, w14, w13, w12
ldr x0, [sp, #0]
ldr w15, [x0, w14, sxtw #2]
eor w9, w9, w15
mov w14, #37495
mul w9, w9, w14
add w9, w9, #32
// state = (state<<6)|(state>>26)
ror w9, w9, #26
// state ^= (state>>4) + 6573
lsr w10, w9, #4
mov w11, #6573
add w10, w10, w11
eor w9, w9, w10
// state += (i+round)*49200
ldr w12, [sp, #20]
ldr w13, [sp, #24]
add w12, w12, w13
mov w14, #49200
mul w12, w12, w14
add w9, w9, w12
// state = (state ^ a[(i+4)%n])*43803 + 36
ldr w12, [sp, #20]
add w12, w12, #4
ldr w13, [sp, #8]
sdiv w14, w12, w13
msub w14, w14, w13, w12
ldr x0, [sp, #0]
ldr w15, [x0, w14, sxtw #2]
eor w9, w9, w15
mov w14, #43803
mul w9, w9, w14
add w9, w9, #36
// state = (state<<8)|(state>>24)
ror w9, w9, #24
// state ^= (state>>1) + 12716
lsr w10, w9, #1
mov w11, #12716
add w10, w10, w11
eor w9, w9, w10
// state += (i+round)*52228
ldr w12, [sp, #20]
ldr w13, [sp, #24]
add w12, w12, w13
mov w14, #52228
mul w12, w12, w14
add w9, w9, w12
// state = (state ^ a[(i+2)%n])*28557 + 40
ldr w12, [sp, #20]
add w12, w12, #2
ldr w13, [sp, #8]
sdiv w14, w12, w13
msub w14, w14, w13, w12
ldr x0, [sp, #0]
ldr w15, [x0, w14, sxtw #2]
eor w9, w9, w15
mov w14, #28557
mul w9, w9, w14
add w9, w9, #40
str w9, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s009_end:

# block r_s001_body_s001_body_s010_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #512
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s010_else

# block r_s001_body_s001_body_s010_then
ldr w2, [sp, #16]
lsl w3, w2, #14
lsr w4, w2, #18
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #5
mov w14, #48343
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #37844
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
ldr w5, [sp, #20]
add w9, w5, #7
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w2, w2, w13
mov w8, #21377
mul w2, w2, w8
add w2, w2, #13
str w2, [sp, #16]
lsl w3, w2, #8
lsr w4, w2, #24
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #6
mov w14, #13155
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #1831
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
ldr w5, [sp, #20]
add w9, w5, #2
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w2, w2, w13
mov w8, #60167
mul w2, w2, w8
add w2, w2, #17
str w2, [sp, #16]
lsl w3, w2, #7
lsr w4, w2, #25
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #2
mov w14, #59729
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #47331
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
ldr w5, [sp, #20]
add w9, w5, #1
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w2, w2, w13
mov w8, #19005
mul w2, w2, w8
add w2, w2, #21
str w2, [sp, #16]
lsl w3, w2, #11
lsr w4, w2, #21
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #2
mov w14, #28479
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #21497
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
ldr w5, [sp, #20]
add w9, w5, #3
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w2, w2, w13
mov w8, #10433
mul w2, w2, w8
add w2, w2, #25
str w2, [sp, #16]
lsl w3, w2, #14
lsr w4, w2, #18
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #4
mov w14, #47143
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #37173
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
ldr w5, [sp, #20]
add w9, w5, #1
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w2, w2, w13
mov w8, #21999
mul w2, w2, w8
add w2, w2, #29
str w2, [sp, #16]
lsl w3, w2, #15
lsr w4, w2, #17
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #3
mov w14, #34347
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #30528
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
ldr w5, [sp, #20]
add w9, w5, #6
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w2, w2, w13
mov w8, #40903
mul w2, w2, w8
add w2, w2, #33
str w2, [sp, #16]
lsl w3, w2, #15
lsr w4, w2, #17
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #10
mov w14, #39244
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #2669
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
ldr w5, [sp, #20]
add w9, w5, #4
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w2, w2, w13
mov w8, #31595
mul w2, w2, w8
add w2, w2, #37
str w2, [sp, #16]
lsl w3, w2, #7
lsr w4, w2, #25
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #12
mov w14, #50743
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #53125
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
ldr w5, [sp, #20]
add w9, w5, #3
ldr w10, [sp, #8]
sdiv w11, w9, w10
mul w11, w11, w10
sub w9, w9, w11
ldr x12, [sp, #0]
ldr w13, [x12, w9, sxtw #2]
eor w2, w2, w13
mov w8, #18821
mul w2, w2, w8
add w2, w2, #41
str w2, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s010_end
L_long_kernel_r_s001_body_s001_body_s010_else:

# block r_s001_body_s001_body_s010_else
// lego_v3_state ^= (lego_v3_state >> 14) + 59837u;
ldr w0, [sp, #16]
lsr w1, w0, #14
mov w2, #59837
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i + round) * 38835u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #38835
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ a[(i + 3) % n]) * 14827u + 12u;
ldr w1, [sp, #20]
add w1, w1, #3
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
sxtw x1, w1
ldr x3, [sp, #0]
ldr w3, [x3, x1, lsl #2]
eor w0, w0, w3
mov w2, #14827
mul w0, w0, w2
add w0, w0, #12
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 10) | (lego_v3_state >> 22);
ror w0, w0, #22
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 2) + 28005u;
lsr w1, w0, #2
mov w2, #28005
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i + round) * 44370u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #44370
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ a[(i + 5) % n]) * 7299u + 16u;
ldr w1, [sp, #20]
add w1, w1, #5
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
sxtw x1, w1
ldr x3, [sp, #0]
ldr w3, [x3, x1, lsl #2]
eor w0, w0, w3
mov w2, #7299
mul w0, w0, w2
add w0, w0, #16
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 7) | (lego_v3_state >> 25);
ror w0, w0, #25
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 8) + 21338u;
lsr w1, w0, #8
mov w2, #21338
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i + round) * 64048u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #64048
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ a[(i + 1) % n]) * 48351u + 20u;
ldr w1, [sp, #20]
add w1, w1, #1
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
sxtw x1, w1
ldr x3, [sp, #0]
ldr w3, [x3, x1, lsl #2]
eor w0, w0, w3
mov w2, #48351
mul w0, w0, w2
add w0, w0, #20
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 5) | (lego_v3_state >> 27);
ror w0, w0, #27
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 8) + 25871u;
lsr w1, w0, #8
mov w2, #25871
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i + round) * 19088u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #19088
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ a[(i + 0) % n]) * 40743u + 24u;
ldr w1, [sp, #20]
add w1, w1, #0
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
sxtw x1, w1
ldr x3, [sp, #0]
ldr w3, [x3, x1, lsl #2]
eor w0, w0, w3
mov w2, #40743
mul w0, w0, w2
add w0, w0, #24
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 9) | (lego_v3_state >> 23);
ror w0, w0, #23
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 53324u;
lsr w1, w0, #13
mov w2, #53324
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i + round) * 52136u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #52136
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ a[(i + 3) % n]) * 20343u + 28u;
ldr w1, [sp, #20]
add w1, w1, #3
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
sxtw x1, w1
ldr x3, [sp, #0]
ldr w3, [x3, x1, lsl #2]
eor w0, w0, w3
mov w2, #20343
mul w0, w0, w2
add w0, w0, #28
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 14) | (lego_v3_state >> 18);
ror w0, w0, #18
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 7) + 6399u;
lsr w1, w0, #7
mov w2, #6399
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i + round) * 62385u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #62385
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ a[(i + 2) % n]) * 309u + 32u;
ldr w1, [sp, #20]
add w1, w1, #2
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
sxtw x1, w1
ldr x3, [sp, #0]
ldr w3, [x3, x1, lsl #2]
eor w0, w0, w3
mov w2, #309
mul w0, w0, w2
add w0, w0, #32
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 7) | (lego_v3_state >> 25);
ror w0, w0, #25
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 15) + 39458u;
lsr w1, w0, #15
mov w2, #39458
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i + round) * 46336u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #46336
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ a[(i + 7) % n]) * 44411u + 36u;
ldr w1, [sp, #20]
add w1, w1, #7
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
sxtw x1, w1
ldr x3, [sp, #0]
ldr w3, [x3, x1, lsl #2]
eor w0, w0, w3
mov w2, #44411
mul w0, w0, w2
add w0, w0, #36
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 15) | (lego_v3_state >> 17);
ror w0, w0, #17
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 9) + 16947u;
lsr w1, w0, #9
mov w2, #16947
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i + round) * 64271u;
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w2, #64271
mul w1, w1, w2
add w0, w0, w1
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ a[(i + 4) % n]) * 25103u + 40u;
ldr w1, [sp, #20]
add w1, w1, #4
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w1, w3, w2, w1
sxtw x1, w1
ldr x3, [sp, #0]
ldr w3, [x3, x1, lsl #2]
eor w0, w0, w3
mov w2, #25103
mul w0, w0, w2
add w0, w0, #40
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 3) | (lego_v3_state >> 29);
ror w0, w0, #29
str w0, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s010_end:

# block r_s001_body_s001_body_s011_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #1024
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s011_else

# block r_s001_body_s001_body_s011_then
// load state
ldr w2, [sp, #16]
// state ^= (state >> 7) + 59600
lsr w3, w2, #7
mov w4, #59600
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i + round) * 61072
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #61072
mul w7, w5, w7
add w2, w2, w7
// index = (i + 2) % n ; a[index]
ldr w8, [sp, #20]
add w8, w8, #2
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #40355
mul w2, w2, w13
add w2, w2, #13
// rotate left 3
lsl w3, w2, #3
lsr w4, w2, #29
orr w2, w3, w4
// state ^= (state >> 3) + 30636
lsr w3, w2, #3
mov w4, #30636
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i + round) * 42114
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #42114
mul w7, w5, w7
add w2, w2, w7
// index = (i + 3) % n
ldr w8, [sp, #20]
add w8, w8, #3
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #58695
mul w2, w2, w13
add w2, w2, #17
// rotate left 13
lsl w3, w2, #13
lsr w4, w2, #19
orr w2, w3, w4
// state ^= (state >> 4) + 2376
lsr w3, w2, #4
mov w4, #2376
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i + round) * 40770
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #40770
mul w7, w5, w7
add w2, w2, w7
// index = (i + 5) % n
ldr w8, [sp, #20]
add w8, w8, #5
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #45687
mul w2, w2, w13
add w2, w2, #21
// rotate left 2
lsl w3, w2, #2
lsr w4, w2, #30
orr w2, w3, w4
// state ^= (state >> 11) + 49176
lsr w3, w2, #11
mov w4, #49176
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i + round) * 42912
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #42912
mul w7, w5, w7
add w2, w2, w7
// index = (i + 3) % n
ldr w8, [sp, #20]
add w8, w8, #3
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #19863
mul w2, w2, w13
add w2, w2, #25
// rotate left 13
lsl w3, w2, #13
lsr w4, w2, #19
orr w2, w3, w4
// state ^= (state >> 8) + 6295
lsr w3, w2, #8
mov w4, #6295
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i + round) * 43849
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #43849
mul w7, w5, w7
add w2, w2, w7
// index = (i + 6) % n
ldr w8, [sp, #20]
add w8, w8, #6
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #23111
mul w2, w2, w13
add w2, w2, #29
// rotate left 11
lsl w3, w2, #11
lsr w4, w2, #21
orr w2, w3, w4
// state ^= (state >> 3) + 40979
lsr w3, w2, #3
mov w4, #40979
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i + round) * 36808
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #36808
mul w7, w5, w7
add w2, w2, w7
// index = (i + 7) % n
ldr w8, [sp, #20]
add w8, w8, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #11069
mul w2, w2, w13
add w2, w2, #33
// rotate left 9
lsl w3, w2, #9
lsr w4, w2, #23
orr w2, w3, w4
// state ^= (state >> 7) + 56323
lsr w3, w2, #7
mov w4, #56323
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i + round) * 25029
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #25029
mul w7, w5, w7
add w2, w2, w7
// index = (i + 0) % n
ldr w8, [sp, #20]
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #4291
mul w2, w2, w13
add w2, w2, #37
// rotate left 10
lsl w3, w2, #10
lsr w4, w2, #22
orr w2, w3, w4
// state ^= (state >> 5) + 46600
lsr w3, w2, #5
mov w4, #46600
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i + round) * 20130
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #20130
mul w7, w5, w7
add w2, w2, w7
// index = (i + 1) % n
ldr w8, [sp, #20]
add w8, w8, #1
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #58221
mul w2, w2, w13
add w2, w2, #41
// rotate left 1
lsl w3, w2, #1
lsr w4, w2, #31
orr w2, w3, w4
// store state
str w2, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s011_end
L_long_kernel_r_s001_body_s001_body_s011_else:

# block r_s001_body_s001_body_s011_else
ldr x0, [sp, #0]
ldr w1, [sp, #8]
ldr w2, [sp, #16]
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w5, w3, w4
// group1
mov w6, #56983
mul w6, w5, w6
add w2, w2, w6
add w6, w3, #1
sdiv w7, w6, w1
msub w6, w7, w1, w6
ldr w7, [x0, w6, sxtw #2]
eor w2, w2, w7
mov w8, #1535
mul w2, w2, w8
add w2, w2, #12
lsl w8, w2, #15
lsr w9, w2, #17
orr w2, w8, w9
lsr w8, w2, #15
mov w9, #40446
add w8, w8, w9
eor w2, w2, w8
// group2
mov w6, #45233
mul w6, w5, w6
add w2, w2, w6
add w6, w3, #6
sdiv w7, w6, w1
msub w6, w7, w1, w6
ldr w7, [x0, w6, sxtw #2]
eor w2, w2, w7
mov w8, #57555
mul w2, w2, w8
add w2, w2, #16
lsl w8, w2, #10
lsr w9, w2, #22
orr w2, w8, w9
lsr w8, w2, #12
mov w9, #38534
add w8, w8, w9
eor w2, w2, w8
// group3
mov w6, #5710
mul w6, w5, w6
add w2, w2, w6
add w6, w3, #7
sdiv w7, w6, w1
msub w6, w7, w1, w6
ldr w7, [x0, w6, sxtw #2]
eor w2, w2, w7
mov w8, #51369
mul w2, w2, w8
add w2, w2, #20
lsl w8, w2, #10
lsr w9, w2, #22
orr w2, w8, w9
lsr w8, w2, #10
mov w9, #39244
add w8, w8, w9
eor w2, w2, w8
// group4
mov w6, #8204
mul w6, w5, w6
add w2, w2, w6
add w6, w3, #7
sdiv w7, w6, w1
msub w6, w7, w1, w6
ldr w7, [x0, w6, sxtw #2]
eor w2, w2, w7
mov w8, #39601
mul w2, w2, w8
add w2, w2, #24
lsl w8, w2, #10
lsr w9, w2, #22
orr w2, w8, w9
lsr w8, w2, #6
mov w9, #52086
add w8, w8, w9
eor w2, w2, w8
// group5
mov w6, #60854
mul w6, w5, w6
add w2, w2, w6
sdiv w7, w3, w1
msub w6, w7, w1, w3
ldr w7, [x0, w6, sxtw #2]
eor w2, w2, w7
mov w8, #8269
mul w2, w2, w8
add w2, w2, #28
lsl w8, w2, #9
lsr w9, w2, #23
orr w2, w8, w9
lsr w8, w2, #5
mov w9, #17086
add w8, w8, w9
eor w2, w2, w8
// group6
mov w6, #13488
mul w6, w5, w6
add w2, w2, w6
add w6, w3, #2
sdiv w7, w6, w1
msub w6, w7, w1, w6
ldr w7, [x0, w6, sxtw #2]
eor w2, w2, w7
mov w8, #52139
mul w2, w2, w8
add w2, w2, #32
lsl w8, w2, #14
lsr w9, w2, #18
orr w2, w8, w9
lsr w8, w2, #1
mov w9, #48995
add w8, w8, w9
eor w2, w2, w8
// group7
mov w6, #56974
mul w6, w5, w6
add w2, w2, w6
add w6, w3, #5
sdiv w7, w6, w1
msub w6, w7, w1, w6
ldr w7, [x0, w6, sxtw #2]
eor w2, w2, w7
mov w8, #60129
mul w2, w2, w8
add w2, w2, #36
lsl w8, w2, #8
lsr w9, w2, #24
orr w2, w8, w9
lsr w8, w2, #4
mov w9, #45854
add w8, w8, w9
eor w2, w2, w8
// group8
mov w6, #2155
mul w6, w5, w6
add w2, w2, w6
add w6, w3, #6
sdiv w7, w6, w1
msub w6, w7, w1, w6
ldr w7, [x0, w6, sxtw #2]
eor w2, w2, w7
mov w8, #5149
mul w2, w2, w8
add w2, w2, #40
lsl w8, w2, #11
lsr w9, w2, #21
orr w2, w8, w9
lsr w8, w2, #7
mov w9, #852
add w8, w8, w9
eor w2, w2, w8
str w2, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s011_end:

# block r_s001_body_s001_body_s012_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #0x800
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s012_else

# block r_s001_body_s001_body_s012_then
// state += (unsigned)(i+round)*10343
ldr w0, [sp, #16]
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w3, w1, w2
mov w4, #10343
mul w3, w3, w4
add w0, w0, w3
// state = (state ^ a[(i+4)%n]) * 33297 + 13
ldr w1, [sp, #20]
add w1, w1, #4
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #33297
mul w0, w0, w6
add w0, w0, #13
// state = (state<<8)|(state>>24)
ror w0, w0, #24
// state ^= (state>>2)+51323
lsr w1, w0, #2
mov w2, #51323
add w1, w1, w2
eor w0, w0, w1
// state += (unsigned)(i+round)*28250
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #28250
mul w1, w1, w3
add w0, w0, w1
// state = (state ^ a[(i+5)%n]) * 43303 + 17
ldr w1, [sp, #20]
add w1, w1, #5
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #43303
mul w0, w0, w6
add w0, w0, #17
// state = (state<<12)|(state>>20)
ror w0, w0, #20
// state ^= (state>>8)+18097
lsr w1, w0, #8
mov w2, #18097
add w1, w1, w2
eor w0, w0, w1
// state += (unsigned)(i+round)*50556
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #50556
mul w1, w1, w3
add w0, w0, w1
// state = (state ^ a[(i+2)%n]) * 2093 + 21
ldr w1, [sp, #20]
add w1, w1, #2
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #2093
mul w0, w0, w6
add w0, w0, #21
// state = (state<<6)|(state>>26)
ror w0, w0, #26
// state ^= (state>>6)+30418
lsr w1, w0, #6
mov w2, #30418
add w1, w1, w2
eor w0, w0, w1
// state += (unsigned)(i+round)*38948
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #38948
mul w1, w1, w3
add w0, w0, w1
// state = (state ^ a[(i+5)%n]) * 54517 + 25
ldr w1, [sp, #20]
add w1, w1, #5
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #54517
mul w0, w0, w6
add w0, w0, #25
// state = (state<<12)|(state>>20)
ror w0, w0, #20
// state ^= (state>>12)+23808
lsr w1, w0, #12
mov w2, #23808
add w1, w1, w2
eor w0, w0, w1
// state += (unsigned)(i+round)*43851
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #43851
mul w1, w1, w3
add w0, w0, w1
// state = (state ^ a[(i+5)%n]) * 23519 + 29
ldr w1, [sp, #20]
add w1, w1, #5
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #23519
mul w0, w0, w6
add w0, w0, #29
// state = (state<<8)|(state>>24)
ror w0, w0, #24
// state ^= (state>>6)+48304
lsr w1, w0, #6
mov w2, #48304
add w1, w1, w2
eor w0, w0, w1
// state += (unsigned)(i+round)*9715
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #9715
mul w1, w1, w3
add w0, w0, w1
// state = (state ^ a[(i+7)%n]) * 1265 + 33
ldr w1, [sp, #20]
add w1, w1, #7
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #1265
mul w0, w0, w6
add w0, w0, #33
// state = (state<<8)|(state>>24)
ror w0, w0, #24
// state ^= (state>>5)+6156
lsr w1, w0, #5
mov w2, #6156
add w1, w1, w2
eor w0, w0, w1
// state += (unsigned)(i+round)*8598
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #8598
mul w1, w1, w3
add w0, w0, w1
// state = (state ^ a[(i+4)%n]) * 52925 + 37
ldr w1, [sp, #20]
add w1, w1, #4
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #52925
mul w0, w0, w6
add w0, w0, #37
// state = (state<<4)|(state>>28)
ror w0, w0, #28
// state ^= (state>>6)+7744
lsr w1, w0, #6
mov w2, #7744
add w1, w1, w2
eor w0, w0, w1
// state += (unsigned)(i+round)*45116
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #45116
mul w1, w1, w3
add w0, w0, w1
// state = (state ^ a[(i+0)%n]) * 45067 + 41
ldr w1, [sp, #20]
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
ldr x4, [sp, #0]
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #45067
mul w0, w0, w6
add w0, w0, #41
// state = (state<<8)|(state>>24)
ror w0, w0, #24
// state ^= (state>>8)+38050
lsr w1, w0, #8
mov w2, #38050
add w1, w1, w2
eor w0, w0, w1
// store state
str w0, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s012_end
L_long_kernel_r_s001_body_s001_body_s012_else:

# block r_s001_body_s001_body_s012_else
// --- group 1: k=1, mul=2405, add=12, rotl14, >>2 add32060, step*10015
ldr w3, [sp, #20]
add w3, w3, #1
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w3, w5, w4, w3
sxtw x3, w3
ldr x2, [sp, #0]
ldr w6, [x2, x3, lsl #2]
ldr w7, [sp, #16]
eor w7, w7, w6
mov w8, #2405
mul w7, w7, w8
add w7, w7, #12
lsl w9, w7, #14
lsr w10, w7, #18
orr w7, w9, w10
lsr w9, w7, #2
mov w8, #32060
add w9, w9, w8
eor w7, w7, w9
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w8, #10015
mul w11, w11, w8
add w7, w7, w11
str w7, [sp, #16]
// --- group 2: k=6, mul=49245, add=16, rotl13, >>4 add18119, step*426
ldr w3, [sp, #20]
add w3, w3, #6
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w3, w5, w4, w3
sxtw x3, w3
ldr x2, [sp, #0]
ldr w6, [x2, x3, lsl #2]
ldr w7, [sp, #16]
eor w7, w7, w6
mov w8, #49245
mul w7, w7, w8
add w7, w7, #16
lsl w9, w7, #13
lsr w10, w7, #19
orr w7, w9, w10
lsr w9, w7, #4
mov w8, #18119
add w9, w9, w8
eor w7, w7, w9
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w8, #426
mul w11, w11, w8
add w7, w7, w11
str w7, [sp, #16]
// --- group 3: k=1, mul=9547, add=20, rotl8, >>12 add1471, step*3743
ldr w3, [sp, #20]
add w3, w3, #1
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w3, w5, w4, w3
sxtw x3, w3
ldr x2, [sp, #0]
ldr w6, [x2, x3, lsl #2]
ldr w7, [sp, #16]
eor w7, w7, w6
mov w8, #9547
mul w7, w7, w8
add w7, w7, #20
lsl w9, w7, #8
lsr w10, w7, #24
orr w7, w9, w10
lsr w9, w7, #12
mov w8, #1471
add w9, w9, w8
eor w7, w7, w9
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w8, #3743
mul w11, w11, w8
add w7, w7, w11
str w7, [sp, #16]
// --- group 4: k=4, mul=57031, add=24, rotl8, >>9 add46937, step*50639
ldr w3, [sp, #20]
add w3, w3, #4
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w3, w5, w4, w3
sxtw x3, w3
ldr x2, [sp, #0]
ldr w6, [x2, x3, lsl #2]
ldr w7, [sp, #16]
eor w7, w7, w6
mov w8, #57031
mul w7, w7, w8
add w7, w7, #24
lsl w9, w7, #8
lsr w10, w7, #24
orr w7, w9, w10
lsr w9, w7, #9
mov w8, #46937
add w9, w9, w8
eor w7, w7, w9
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w8, #50639
mul w11, w11, w8
add w7, w7, w11
str w7, [sp, #16]
// --- group 5: k=0, mul=34009, add=28, rotl1, >>8 add34429, step*18909
ldr w3, [sp, #20]
add w3, w3, #0
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w3, w5, w4, w3
sxtw x3, w3
ldr x2, [sp, #0]
ldr w6, [x2, x3, lsl #2]
ldr w7, [sp, #16]
eor w7, w7, w6
mov w8, #34009
mul w7, w7, w8
add w7, w7, #28
lsl w9, w7, #1
lsr w10, w7, #31
orr w7, w9, w10
lsr w9, w7, #8
mov w8, #34429
add w9, w9, w8
eor w7, w7, w9
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w8, #18909
mul w11, w11, w8
add w7, w7, w11
str w7, [sp, #16]
// --- group 6: k=2, mul=62231, add=32, rotl3, >>9 add23882, step*22503
ldr w3, [sp, #20]
add w3, w3, #2
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w3, w5, w4, w3
sxtw x3, w3
ldr x2, [sp, #0]
ldr w6, [x2, x3, lsl #2]
ldr w7, [sp, #16]
eor w7, w7, w6
mov w8, #62231
mul w7, w7, w8
add w7, w7, #32
lsl w9, w7, #3
lsr w10, w7, #29
orr w7, w9, w10
lsr w9, w7, #9
mov w8, #23882
add w9, w9, w8
eor w7, w7, w9
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w8, #22503
mul w11, w11, w8
add w7, w7, w11
str w7, [sp, #16]
// --- group 7: k=0, mul=2567, add=36, rotl6, >>11 add30853, step*44532
ldr w3, [sp, #20]
add w3, w3, #0
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w3, w5, w4, w3
sxtw x3, w3
ldr x2, [sp, #0]
ldr w6, [x2, x3, lsl #2]
ldr w7, [sp, #16]
eor w7, w7, w6
mov w8, #2567
mul w7, w7, w8
add w7, w7, #36
lsl w9, w7, #6
lsr w10, w7, #26
orr w7, w9, w10
lsr w9, w7, #11
mov w8, #30853
add w9, w9, w8
eor w7, w7, w9
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w8, #44532
mul w11, w11, w8
add w7, w7, w11
str w7, [sp, #16]
// --- group 8: k=3, mul=34137, add=40, rotl6, >>5 add29666, step*12295
ldr w3, [sp, #20]
add w3, w3, #3
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w3, w5, w4, w3
sxtw x3, w3
ldr x2, [sp, #0]
ldr w6, [x2, x3, lsl #2]
ldr w7, [sp, #16]
eor w7, w7, w6
mov w8, #34137
mul w7, w7, w8
add w7, w7, #40
lsl w9, w7, #6
lsr w10, w7, #26
orr w7, w9, w10
lsr w9, w7, #5
mov w8, #29666
add w9, w9, w8
eor w7, w7, w9
ldr w11, [sp, #20]
ldr w12, [sp, #24]
add w11, w11, w12
mov w8, #12295
mul w11, w11, w8
add w7, w7, w11
str w7, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s012_end:

# block r_s001_body_s001_body_s013_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #4096
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s013_else

# block r_s001_body_s001_body_s013_then
ldr w2, [sp, #16]
ldr w3, [sp, #20]
ldr w5, [sp, #24]
ldr w6, [sp, #8]
ldr x7, [sp, #0]
// state = (state ^ a[(i+1)%n]) * 32625 + 13
add w8, w3, #1
sdiv w9, w8, w6
msub w9, w9, w6, w8
sxtw x9, w9
ldr w10, [x7, x9, lsl #2]
eor w2, w2, w10
mov w11, #32625
mul w2, w2, w11
add w2, w2, #13
// rotl 10
ror w2, w2, #22
// state ^= (state>>11)+1125
lsr w10, w2, #11
add w10, w10, #1125
eor w2, w2, w10
// state += (i+round)*53321
add w10, w3, w5
mov w11, #53321
mul w10, w10, w11
add w2, w2, w10
// state = (state ^ a[(i+2)%n]) * 18685 + 17
add w8, w3, #2
sdiv w9, w8, w6
msub w9, w9, w6, w8
sxtw x9, w9
ldr w10, [x7, x9, lsl #2]
eor w2, w2, w10
mov w11, #18685
mul w2, w2, w11
add w2, w2, #17
// rotl 12
ror w2, w2, #20
// state ^= (state>>15)+49798
lsr w10, w2, #15
mov w11, #49798
add w10, w10, w11
eor w2, w2, w10
// state += (i+round)*62576
add w10, w3, w5
mov w11, #62576
mul w10, w10, w11
add w2, w2, w10
// state = (state ^ a[(i+0)%n]) * 22891 + 21
mov w8, w3
sdiv w9, w8, w6
msub w9, w9, w6, w8
sxtw x9, w9
ldr w10, [x7, x9, lsl #2]
eor w2, w2, w10
mov w11, #22891
mul w2, w2, w11
add w2, w2, #21
// rotl 14
ror w2, w2, #18
// state ^= (state>>6)+35501
lsr w10, w2, #6
mov w11, #35501
add w10, w10, w11
eor w2, w2, w10
// state += (i+round)*7413
add w10, w3, w5
mov w11, #7413
mul w10, w10, w11
add w2, w2, w10
// state = (state ^ a[(i+6)%n]) * 30981 + 25
add w8, w3, #6
sdiv w9, w8, w6
msub w9, w9, w6, w8
sxtw x9, w9
ldr w10, [x7, x9, lsl #2]
eor w2, w2, w10
mov w11, #30981
mul w2, w2, w11
add w2, w2, #25
// rotl 5
ror w2, w2, #27
// state ^= (state>>15)+50505
lsr w10, w2, #15
mov w11, #50505
add w10, w10, w11
eor w2, w2, w10
// state += (i+round)*61203
add w10, w3, w5
mov w11, #61203
mul w10, w10, w11
add w2, w2, w10
// state = (state ^ a[(i+4)%n]) * 37851 + 29
add w8, w3, #4
sdiv w9, w8, w6
msub w9, w9, w6, w8
sxtw x9, w9
ldr w10, [x7, x9, lsl #2]
eor w2, w2, w10
mov w11, #37851
mul w2, w2, w11
add w2, w2, #29
// rotl 3
ror w2, w2, #29
// state ^= (state>>1)+14460
lsr w10, w2, #1
mov w11, #14460
add w10, w10, w11
eor w2, w2, w10
// state += (i+round)*11211
add w10, w3, w5
mov w11, #11211
mul w10, w10, w11
add w2, w2, w10
// state = (state ^ a[(i+1)%n]) * 45295 + 33
add w8, w3, #1
sdiv w9, w8, w6
msub w9, w9, w6, w8
sxtw x9, w9
ldr w10, [x7, x9, lsl #2]
eor w2, w2, w10
mov w11, #45295
mul w2, w2, w11
add w2, w2, #33
// rotl 14
ror w2, w2, #18
// state ^= (state>>5)+13226
lsr w10, w2, #5
mov w11, #13226
add w10, w10, w11
eor w2, w2, w10
// state += (i+round)*59448
add w10, w3, w5
mov w11, #59448
mul w10, w10, w11
add w2, w2, w10
// state = (state ^ a[(i+0)%n]) * 2585 + 37
mov w8, w3
sdiv w9, w8, w6
msub w9, w9, w6, w8
sxtw x9, w9
ldr w10, [x7, x9, lsl #2]
eor w2, w2, w10
mov w11, #2585
mul w2, w2, w11
add w2, w2, #37
// rotl 8
ror w2, w2, #24
// state ^= (state>>9)+55549
lsr w10, w2, #9
mov w11, #55549
add w10, w10, w11
eor w2, w2, w10
// state += (i+round)*63673
add w10, w3, w5
mov w11, #63673
mul w10, w10, w11
add w2, w2, w10
// state = (state ^ a[(i+7)%n]) * 65007 + 41
add w8, w3, #7
sdiv w9, w8, w6
msub w9, w9, w6, w8
sxtw x9, w9
ldr w10, [x7, x9, lsl #2]
eor w2, w2, w10
mov w11, #65007
mul w2, w2, w11
add w2, w2, #41
// rotl 1
ror w2, w2, #31
// state ^= (state>>12)+8825
lsr w10, w2, #12
mov w11, #8825
add w10, w10, w11
eor w2, w2, w10
// state += (i+round)*4807
add w10, w3, w5
mov w11, #4807
mul w10, w10, w11
add w2, w2, w10
str w2, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s013_end
L_long_kernel_r_s001_body_s001_body_s013_else:

# block r_s001_body_s001_body_s013_else
ldr w2, [sp, #16]
lsl w3, w2, #1
lsr w4, w2, #31
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #4
mov w13, #10131
add w3, w3, w13
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #38152
mul w6, w6, w7
add w2, w2, w6
str w2, [sp, #16]
ldr w4, [sp, #20]
add w8, w4, #5
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w7, #34915
mul w2, w2, w7
add w2, w2, #16
str w2, [sp, #16]
lsl w3, w2, #1
lsr w4, w2, #31
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #5
mov w13, #49199
add w3, w3, w13
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #39986
mul w6, w6, w7
add w2, w2, w6
str w2, [sp, #16]
ldr w4, [sp, #20]
add w8, w4, #3
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w7, #47041
mul w2, w2, w7
add w2, w2, #20
str w2, [sp, #16]
lsl w3, w2, #10
lsr w4, w2, #22
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #9
mov w13, #36518
add w3, w3, w13
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #36006
mul w6, w6, w7
add w2, w2, w6
str w2, [sp, #16]
ldr w4, [sp, #20]
add w8, w4, #1
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w7, #42823
mul w2, w2, w7
add w2, w2, #24
str w2, [sp, #16]
lsl w3, w2, #12
lsr w4, w2, #20
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #12
mov w13, #61643
add w3, w3, w13
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #35077
mul w6, w6, w7
add w2, w2, w6
str w2, [sp, #16]
ldr w4, [sp, #20]
add w8, w4, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w7, #14339
mul w2, w2, w7
add w2, w2, #28
str w2, [sp, #16]
lsl w3, w2, #15
lsr w4, w2, #17
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #2
mov w13, #30353
add w3, w3, w13
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #48555
mul w6, w6, w7
add w2, w2, w6
str w2, [sp, #16]
ldr w4, [sp, #20]
add w8, w4, #5
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w7, #8445
mul w2, w2, w7
add w2, w2, #32
str w2, [sp, #16]
lsl w3, w2, #9
lsr w4, w2, #23
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #10
mov w13, #49638
add w3, w3, w13
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #10022
mul w6, w6, w7
add w2, w2, w6
str w2, [sp, #16]
ldr w4, [sp, #20]
add w8, w4, #1
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w7, #14895
mul w2, w2, w7
add w2, w2, #36
str w2, [sp, #16]
lsl w3, w2, #4
lsr w4, w2, #28
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #15
mov w13, #25570
add w3, w3, w13
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #38475
mul w6, w6, w7
add w2, w2, w6
str w2, [sp, #16]
ldr w4, [sp, #20]
add w8, w4, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w7, #35373
mul w2, w2, w7
add w2, w2, #40
str w2, [sp, #16]
lsl w3, w2, #11
lsr w4, w2, #21
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #15
mov w13, #50923
add w3, w3, w13
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #4667
mul w6, w6, w7
add w2, w2, w6
str w2, [sp, #16]
ldr w4, [sp, #20]
add w8, w4, #0
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w7, #3853
mul w2, w2, w7
add w2, w2, #44
str w2, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s013_end:

# block r_s001_body_s001_body_s014_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #8192
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s014_else

# block r_s001_body_s001_body_s014_then
ldr w9, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
ldr w6, [sp, #8]
ldr x7, [sp, #0]
add w10, w4, w5
lsl w11, w9, #14
lsr w12, w9, #18
orr w9, w11, w12
lsr w11, w9, #9
mov w8, #52114
add w11, w11, w8
eor w9, w9, w11
mov w13, #13108
mul w11, w10, w13
add w9, w9, w11
add w14, w4, #3
sdiv w15, w14, w6
msub w14, w15, w6, w14
sxtw x14, w14
ldr w11, [x7, x14, lsl #2]
eor w9, w9, w11
mov w13, #5091
mul w9, w9, w13
add w9, w9, #17
lsl w11, w9, #11
lsr w12, w9, #21
orr w9, w11, w12
lsr w11, w9, #14
mov w8, #54495
add w11, w11, w8
eor w9, w9, w11
mov w13, #64746
mul w11, w10, w13
add w9, w9, w11
add w14, w4, #1
sdiv w15, w14, w6
msub w14, w15, w6, w14
sxtw x14, w14
ldr w11, [x7, x14, lsl #2]
eor w9, w9, w11
mov w13, #11837
mul w9, w9, w13
add w9, w9, #21
lsl w11, w9, #15
lsr w12, w9, #17
orr w9, w11, w12
lsr w11, w9, #9
mov w8, #9206
add w11, w11, w8
eor w9, w9, w11
mov w13, #57752
mul w11, w10, w13
add w9, w9, w11
add w14, w4, #2
sdiv w15, w14, w6
msub w14, w15, w6, w14
sxtw x14, w14
ldr w11, [x7, x14, lsl #2]
eor w9, w9, w11
mov w13, #47277
mul w9, w9, w13
add w9, w9, #25
lsl w11, w9, #12
lsr w12, w9, #20
orr w9, w11, w12
lsr w11, w9, #1
mov w8, #63468
add w11, w11, w8
eor w9, w9, w11
mov w13, #25643
mul w11, w10, w13
add w9, w9, w11
sdiv w15, w4, w6
msub w14, w15, w6, w4
sxtw x14, w14
ldr w11, [x7, x14, lsl #2]
eor w9, w9, w11
mov w13, #31819
mul w9, w9, w13
add w9, w9, #29
lsl w11, w9, #1
lsr w12, w9, #31
orr w9, w11, w12
lsr w11, w9, #3
mov w8, #62257
add w11, w11, w8
eor w9, w9, w11
mov w13, #36047
mul w11, w10, w13
add w9, w9, w11
add w14, w4, #6
sdiv w15, w14, w6
msub w14, w15, w6, w14
sxtw x14, w14
ldr w11, [x7, x14, lsl #2]
eor w9, w9, w11
mov w13, #57195
mul w9, w9, w13
add w9, w9, #33
lsl w11, w9, #15
lsr w12, w9, #17
orr w9, w11, w12
lsr w11, w9, #12
mov w8, #54645
add w11, w11, w8
eor w9, w9, w11
mov w13, #49072
mul w11, w10, w13
add w9, w9, w11
add w14, w4, #7
sdiv w15, w14, w6
msub w14, w15, w6, w14
sxtw x14, w14
ldr w11, [x7, x14, lsl #2]
eor w9, w9, w11
mov w13, #53909
mul w9, w9, w13
add w9, w9, #37
lsl w11, w9, #14
lsr w12, w9, #18
orr w9, w11, w12
lsr w11, w9, #14
mov w8, #63608
add w11, w11, w8
eor w9, w9, w11
mov w13, #14825
mul w11, w10, w13
add w9, w9, w11
sdiv w15, w4, w6
msub w14, w15, w6, w4
sxtw x14, w14
ldr w11, [x7, x14, lsl #2]
eor w9, w9, w11
mov w13, #19519
mul w9, w9, w13
add w9, w9, #41
lsl w11, w9, #11
lsr w12, w9, #21
orr w9, w11, w12
lsr w11, w9, #15
mov w8, #30023
add w11, w11, w8
eor w9, w9, w11
mov w13, #25657
mul w11, w10, w13
add w9, w9, w11
add w14, w4, #3
sdiv w15, w14, w6
msub w14, w15, w6, w14
sxtw x14, w14
ldr w11, [x7, x14, lsl #2]
eor w9, w9, w11
mov w13, #51145
mul w9, w9, w13
add w9, w9, #45
str w9, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s014_end
L_long_kernel_r_s001_body_s001_body_s014_else:

# block r_s001_body_s001_body_s014_else
// state ^= (state>>7)+4608
ldr w0, [sp, #16]
lsr w1, w0, #7
mov w10, #4608
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round)*28070
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #28070
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// state = (state ^ a[(i+5)%n]) * 29879 + 16
ldr w5, [sp, #20]
add w5, w5, #5
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
sxtw x7, w7
ldr x8, [sp, #0]
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w4, #29879
mul w0, w0, w4
add w0, w0, #16
str w0, [sp, #16]
// state = (state<<2)|(state>>30)
ror w0, w0, #30
str w0, [sp, #16]
// state ^= (state>>3)+53031
lsr w1, w0, #3
mov w10, #53031
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round)*2502
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #2502
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// state = (state ^ a[(i+6)%n]) * 45679 + 20
ldr w5, [sp, #20]
add w5, w5, #6
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
sxtw x7, w7
ldr x8, [sp, #0]
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w4, #45679
mul w0, w0, w4
add w0, w0, #20
str w0, [sp, #16]
// state = (state<<2)|(state>>30)
ror w0, w0, #30
str w0, [sp, #16]
// state ^= (state>>12)+62274
lsr w1, w0, #12
mov w10, #62274
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round)*43830
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #43830
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// state = (state ^ a[(i+3)%n]) * 14803 + 24
ldr w5, [sp, #20]
add w5, w5, #3
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
sxtw x7, w7
ldr x8, [sp, #0]
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w4, #14803
mul w0, w0, w4
add w0, w0, #24
str w0, [sp, #16]
// state = (state<<6)|(state>>26)
ror w0, w0, #26
str w0, [sp, #16]
// state ^= (state>>15)+4800
lsr w1, w0, #15
mov w10, #4800
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round)*16770
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #16770
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// state = (state ^ a[(i+4)%n]) * 25085 + 28
ldr w5, [sp, #20]
add w5, w5, #4
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
sxtw x7, w7
ldr x8, [sp, #0]
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w4, #25085
mul w0, w0, w4
add w0, w0, #28
str w0, [sp, #16]
// state = (state<<13)|(state>>19)
ror w0, w0, #19
str w0, [sp, #16]
// state ^= (state>>2)+29688
lsr w1, w0, #2
mov w10, #29688
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round)*23075
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #23075
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// state = (state ^ a[(i+4)%n]) * 2481 + 32
ldr w5, [sp, #20]
add w5, w5, #4
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
sxtw x7, w7
ldr x8, [sp, #0]
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w4, #2481
mul w0, w0, w4
add w0, w0, #32
str w0, [sp, #16]
// state = (state<<8)|(state>>24)
ror w0, w0, #24
str w0, [sp, #16]
// state ^= (state>>6)+14830
lsr w1, w0, #6
mov w10, #14830
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round)*27187
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #27187
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// state = (state ^ a[(i+6)%n]) * 15605 + 36
ldr w5, [sp, #20]
add w5, w5, #6
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
sxtw x7, w7
ldr x8, [sp, #0]
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w4, #15605
mul w0, w0, w4
add w0, w0, #36
str w0, [sp, #16]
// state = (state<<4)|(state>>28)
ror w0, w0, #28
str w0, [sp, #16]
// state ^= (state>>2)+36792
lsr w1, w0, #2
mov w10, #36792
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round)*58604
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #58604
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// state = (state ^ a[(i+5)%n]) * 35913 + 40
ldr w5, [sp, #20]
add w5, w5, #5
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
sxtw x7, w7
ldr x8, [sp, #0]
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w4, #35913
mul w0, w0, w4
add w0, w0, #40
str w0, [sp, #16]
// state = (state<<10)|(state>>22)
ror w0, w0, #22
str w0, [sp, #16]
// state ^= (state>>9)+9938
lsr w1, w0, #9
mov w10, #9938
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round)*48212
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #48212
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// state = (state ^ a[(i+3)%n]) * 59685 + 44
ldr w5, [sp, #20]
add w5, w5, #3
ldr w6, [sp, #8]
sdiv w7, w5, w6
mul w7, w7, w6
sub w7, w5, w7
sxtw x7, w7
ldr x8, [sp, #0]
ldr w9, [x8, x7, lsl #2]
eor w0, w0, w9
mov w4, #59685
mul w0, w0, w4
add w0, w0, #44
str w0, [sp, #16]
// state = (state<<3)|(state>>29)
ror w0, w0, #29
str w0, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s014_end:

# block r_s001_body_s001_body_s015_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #0x4000
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s015_else

# block r_s001_body_s001_body_s015_then
// lego_v3_state ^= (lego_v3_state >> 5) + 58318u;
ldr w0, [sp, #16]
lsr w1, w0, #5
mov w2, #58318
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 5292u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #5292
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ a[(i+4)%n]) * 2009u + 17u;
ldr w6, [sp, #20]
add w6, w6, #4
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
sxtw x8, w8
ldr x9, [sp, #0]
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w5, #2009
mul w0, w0, w5
add w0, w0, #17
str w0, [sp, #16]
// lego_v3_state = (state<<7)|(state>>25);
lsl w1, w0, #7
lsr w2, w0, #25
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (state>>1) + 804u;
lsr w1, w0, #1
mov w2, #804
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i+round) * 54521u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #54521
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (state ^ a[(i+4)%n]) * 21637u + 21u;
ldr w6, [sp, #20]
add w6, w6, #4
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
sxtw x8, w8
ldr x9, [sp, #0]
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w5, #21637
mul w0, w0, w5
add w0, w0, #21
str w0, [sp, #16]
// lego_v3_state = (state<<4)|(state>>28);
lsl w1, w0, #4
lsr w2, w0, #28
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (state>>5) + 56956u;
lsr w1, w0, #5
mov w2, #56956
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i+round) * 48882u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #48882
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (state ^ a[(i+1)%n]) * 30947u + 25u;
ldr w6, [sp, #20]
add w6, w6, #1
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
sxtw x8, w8
ldr x9, [sp, #0]
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w5, #30947
mul w0, w0, w5
add w0, w0, #25
str w0, [sp, #16]
// lego_v3_state = (state<<1)|(state>>31);
lsl w1, w0, #1
lsr w2, w0, #31
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (state>>12) + 63504u;
lsr w1, w0, #12
mov w2, #63504
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i+round) * 52490u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #52490
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (state ^ a[(i+0)%n]) * 10265u + 29u;
ldr w6, [sp, #20]
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
sxtw x8, w8
ldr x9, [sp, #0]
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w5, #10265
mul w0, w0, w5
add w0, w0, #29
str w0, [sp, #16]
// lego_v3_state = (state<<6)|(state>>26);
lsl w1, w0, #6
lsr w2, w0, #26
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (state>>13) + 9564u;
lsr w1, w0, #13
mov w2, #9564
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i+round) * 29345u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #29345
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (state ^ a[(i+0)%n]) * 41449u + 33u;
ldr w6, [sp, #20]
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
sxtw x8, w8
ldr x9, [sp, #0]
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w5, #41449
mul w0, w0, w5
add w0, w0, #33
str w0, [sp, #16]
// lego_v3_state = (state<<11)|(state>>21);
lsl w1, w0, #11
lsr w2, w0, #21
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (state>>2) + 35313u;
lsr w1, w0, #2
mov w2, #35313
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i+round) * 10632u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #10632
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (state ^ a[(i+3)%n]) * 48207u + 37u;
ldr w6, [sp, #20]
add w6, w6, #3
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
sxtw x8, w8
ldr x9, [sp, #0]
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w5, #48207
mul w0, w0, w5
add w0, w0, #37
str w0, [sp, #16]
// lego_v3_state = (state<<11)|(state>>21);
lsl w1, w0, #11
lsr w2, w0, #21
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (state>>12) + 52154u;
lsr w1, w0, #12
mov w2, #52154
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i+round) * 27773u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #27773
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (state ^ a[(i+0)%n]) * 42151u + 41u;
ldr w6, [sp, #20]
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
sxtw x8, w8
ldr x9, [sp, #0]
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w5, #42151
mul w0, w0, w5
add w0, w0, #41
str w0, [sp, #16]
// lego_v3_state = (state<<10)|(state>>22);
lsl w1, w0, #10
lsr w2, w0, #22
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (state>>15) + 17202u;
lsr w1, w0, #15
mov w2, #17202
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(i+round) * 15270u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #15270
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (state ^ a[(i+1)%n]) * 28357u + 45u;
ldr w6, [sp, #20]
add w6, w6, #1
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
sxtw x8, w8
ldr x9, [sp, #0]
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w5, #28357
mul w0, w0, w5
add w0, w0, #45
str w0, [sp, #16]
// lego_v3_state = (state<<3)|(state>>29);
lsl w1, w0, #3
lsr w2, w0, #29
orr w0, w1, w2
str w0, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s015_end
L_long_kernel_r_s001_body_s001_body_s015_else:

# block r_s001_body_s001_body_s015_else
// state += (unsigned)(i+round)*63966u
ldr w0, [sp, #16]
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #63966
mul w1, w1, w3
add w0, w0, w1
str w0, [sp, #16]
// index block for a[(i+7)%n]
ldr w4, [sp, #20]
add w4, w4, #7
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w6, w6, w5, w4
// state = (state ^ a[idx]) * 64739u + 16u
ldr x7, [sp, #0]
sxtw x6, w6
ldr w8, [x7, x6, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w8
mov w3, #64739
mul w0, w0, w3
add w0, w0, #16
// state = (state<<6)|(state>>26)
ror w0, w0, #26
// state ^= (state>>11)+34153u
lsr w9, w0, #11
mov w3, #34153
add w9, w9, w3
eor w0, w0, w9
str w0, [sp, #16]
// state += (unsigned)(i+round)*40024u
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #40024
mul w1, w1, w3
add w0, w0, w1
str w0, [sp, #16]
// a[(i+5)%n]
ldr w4, [sp, #20]
add w4, w4, #5
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w6, w6, w5, w4
ldr x7, [sp, #0]
sxtw x6, w6
ldr w8, [x7, x6, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w8
mov w3, #47129
mul w0, w0, w3
add w0, w0, #20
// state = (state<<12)|(state>>20)
ror w0, w0, #20
// state ^= (state>>1)+24534u
lsr w9, w0, #1
mov w3, #24534
add w9, w9, w3
eor w0, w0, w9
str w0, [sp, #16]
// state += (unsigned)(i+round)*39479u
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #39479
mul w1, w1, w3
add w0, w0, w1
str w0, [sp, #16]
// a[(i+6)%n]
ldr w4, [sp, #20]
add w4, w4, #6
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w6, w6, w5, w4
ldr x7, [sp, #0]
sxtw x6, w6
ldr w8, [x7, x6, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w8
mov w3, #24323
mul w0, w0, w3
add w0, w0, #24
// state = (state<<7)|(state>>25)
ror w0, w0, #25
// state ^= (state>>2)+24745u
lsr w9, w0, #2
mov w3, #24745
add w9, w9, w3
eor w0, w0, w9
str w0, [sp, #16]
// state += (unsigned)(i+round)*444u
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #444
mul w1, w1, w3
add w0, w0, w1
str w0, [sp, #16]
// a[(i+2)%n]
ldr w4, [sp, #20]
add w4, w4, #2
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w6, w6, w5, w4
ldr x7, [sp, #0]
sxtw x6, w6
ldr w8, [x7, x6, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w8
mov w3, #52063
mul w0, w0, w3
add w0, w0, #28
// state = (state<<7)|(state>>25)
ror w0, w0, #25
// state ^= (state>>9)+35285u
lsr w9, w0, #9
mov w3, #35285
add w9, w9, w3
eor w0, w0, w9
str w0, [sp, #16]
// state += (unsigned)(i+round)*11624u
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #11624
mul w1, w1, w3
add w0, w0, w1
str w0, [sp, #16]
// a[(i+5)%n]
ldr w4, [sp, #20]
add w4, w4, #5
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w6, w6, w5, w4
ldr x7, [sp, #0]
sxtw x6, w6
ldr w8, [x7, x6, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w8
mov w3, #54861
mul w0, w0, w3
add w0, w0, #32
// state = (state<<10)|(state>>22)
ror w0, w0, #22
// state ^= (state>>2)+40595u
lsr w9, w0, #2
mov w3, #40595
add w9, w9, w3
eor w0, w0, w9
str w0, [sp, #16]
// state += (unsigned)(i+round)*8468u
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #8468
mul w1, w1, w3
add w0, w0, w1
str w0, [sp, #16]
// a[(i+2)%n]
ldr w4, [sp, #20]
add w4, w4, #2
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w6, w6, w5, w4
ldr x7, [sp, #0]
sxtw x6, w6
ldr w8, [x7, x6, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w8
mov w3, #54369
mul w0, w0, w3
add w0, w0, #36
// state = (state<<4)|(state>>28)
ror w0, w0, #28
// state ^= (state>>8)+9272u
lsr w9, w0, #8
mov w3, #9272
add w9, w9, w3
eor w0, w0, w9
str w0, [sp, #16]
// state += (unsigned)(i+round)*35790u
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #35790
mul w1, w1, w3
add w0, w0, w1
str w0, [sp, #16]
// a[(i+3)%n]
ldr w4, [sp, #20]
add w4, w4, #3
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w6, w6, w5, w4
ldr x7, [sp, #0]
sxtw x6, w6
ldr w8, [x7, x6, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w8
mov w3, #7467
mul w0, w0, w3
add w0, w0, #40
// state = (state<<14)|(state>>18)
ror w0, w0, #18
// state ^= (state>>13)+48377u
lsr w9, w0, #13
mov w3, #48377
add w9, w9, w3
eor w0, w0, w9
str w0, [sp, #16]
// state += (unsigned)(i+round)*59669u
ldr w1, [sp, #20]
ldr w2, [sp, #24]
add w1, w1, w2
mov w3, #59669
mul w1, w1, w3
add w0, w0, w1
str w0, [sp, #16]
// a[(i+2)%n]
ldr w4, [sp, #20]
add w4, w4, #2
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w6, w6, w5, w4
ldr x7, [sp, #0]
sxtw x6, w6
ldr w8, [x7, x6, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w8
mov w3, #12623
mul w0, w0, w3
add w0, w0, #44
// state = (state<<14)|(state>>18)
ror w0, w0, #18
// state ^= (state>>4)+49337u
lsr w9, w0, #4
mov w3, #49337
add w9, w9, w3
eor w0, w0, w9
str w0, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s015_end:

# block r_s001_body_s001_body_s016_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #0x8000
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s016_else

# block r_s001_body_s001_body_s016_then
ldr x0, [sp, #0]
ldr w1, [sp, #8]
ldr w2, [sp, #16]
ldr w3, [sp, #20]
ldr w4, [sp, #24]
// state += (unsigned)(i+round)*12742
add w5, w3, w4
mov w6, #12742
mul w5, w5, w6
add w2, w2, w5
// idx = (i+0) % n ; load a[idx]
add w7, w3, #0
sdiv w8, w7, w1
msub w7, w8, w1, w7
sxtw x7, w7
ldr w9, [x0, x7, lsl #2]
eor w2, w2, w9
mov w6, #57019
mul w2, w2, w6
add w2, w2, #17
// rotate left 8
ror w2, w2, #24
// state ^= (state>>14)+32001
lsr w10, w2, #14
mov w6, #32001
add w10, w10, w6
eor w2, w2, w10
// block 2
add w5, w3, w4
mov w6, #29986
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #1
sdiv w8, w7, w1
msub w7, w8, w1, w7
sxtw x7, w7
ldr w9, [x0, x7, lsl #2]
eor w2, w2, w9
mov w6, #48821
mul w2, w2, w6
add w2, w2, #21
ror w2, w2, #30
lsr w10, w2, #1
mov w6, #30195
add w10, w10, w6
eor w2, w2, w10
// block 3
add w5, w3, w4
mov w6, #24786
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #6
sdiv w8, w7, w1
msub w7, w8, w1, w7
sxtw x7, w7
ldr w9, [x0, x7, lsl #2]
eor w2, w2, w9
mov w6, #24523
mul w2, w2, w6
add w2, w2, #25
ror w2, w2, #21
lsr w10, w2, #15
mov w6, #4406
add w10, w10, w6
eor w2, w2, w10
// block 4
add w5, w3, w4
mov w6, #51000
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #3
sdiv w8, w7, w1
msub w7, w8, w1, w7
sxtw x7, w7
ldr w9, [x0, x7, lsl #2]
eor w2, w2, w9
mov w6, #27461
mul w2, w2, w6
add w2, w2, #29
ror w2, w2, #21
lsr w10, w2, #9
mov w6, #49251
add w10, w10, w6
eor w2, w2, w10
// block 5
add w5, w3, w4
mov w6, #61107
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #4
sdiv w8, w7, w1
msub w7, w8, w1, w7
sxtw x7, w7
ldr w9, [x0, x7, lsl #2]
eor w2, w2, w9
mov w6, #40127
mul w2, w2, w6
add w2, w2, #33
ror w2, w2, #28
lsr w10, w2, #3
mov w6, #54416
add w10, w10, w6
eor w2, w2, w10
// block 6
add w5, w3, w4
mov w6, #58812
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #7
sdiv w8, w7, w1
msub w7, w8, w1, w7
sxtw x7, w7
ldr w9, [x0, x7, lsl #2]
eor w2, w2, w9
mov w6, #53751
mul w2, w2, w6
add w2, w2, #37
ror w2, w2, #19
lsr w10, w2, #14
mov w6, #42600
add w10, w10, w6
eor w2, w2, w10
// block 7
add w5, w3, w4
mov w6, #3369
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #4
sdiv w8, w7, w1
msub w7, w8, w1, w7
sxtw x7, w7
ldr w9, [x0, x7, lsl #2]
eor w2, w2, w9
mov w6, #52081
mul w2, w2, w6
add w2, w2, #41
ror w2, w2, #23
lsr w10, w2, #6
mov w6, #4827
add w10, w10, w6
eor w2, w2, w10
// block 8
add w5, w3, w4
mov w6, #34548
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #0
sdiv w8, w7, w1
msub w7, w8, w1, w7
sxtw x7, w7
ldr w9, [x0, x7, lsl #2]
eor w2, w2, w9
mov w6, #1485
mul w2, w2, w6
add w2, w2, #45
ror w2, w2, #21
lsr w10, w2, #9
mov w6, #61116
add w10, w10, w6
eor w2, w2, w10
// store state
str w2, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s016_end
L_long_kernel_r_s001_body_s001_body_s016_else:

# block r_s001_body_s001_body_s016_else
// block 1: index (i+5)%n
ldr w8, [sp, #20]
add w8, w8, #5
ldr w9, [sp, #8]
sdiv w10, w8, w9
mul w10, w10, w9
sub w8, w8, w10
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
ldr w13, [sp, #16]
eor w13, w13, w12
mov w14, #28319
mul w13, w13, w14
add w13, w13, #16
// rotate left 6
lsl w8, w13, #6
lsr w9, w13, #26
orr w13, w8, w9
// state ^= (state>>11)+46950
lsr w8, w13, #11
mov w9, #46950
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*419
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #419
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// index (i+2)%n
ldr w8, [sp, #20]
add w8, w8, #2
ldr w9, [sp, #8]
sdiv w10, w8, w9
mul w10, w10, w9
sub w8, w8, w10
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #33125
mul w13, w13, w14
add w13, w13, #20
// rotate left 9
lsl w8, w13, #9
lsr w9, w13, #23
orr w13, w8, w9
// state ^= (state>>9)+64134
lsr w8, w13, #9
mov w9, #64134
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*26291
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #26291
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// index (i+7)%n
ldr w8, [sp, #20]
add w8, w8, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
mul w10, w10, w9
sub w8, w8, w10
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #4199
mul w13, w13, w14
add w13, w13, #24
// rotate left 8
lsl w8, w13, #8
lsr w9, w13, #24
orr w13, w8, w9
// state ^= (state>>8)+27728
lsr w8, w13, #8
mov w9, #27728
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*34828
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #34828
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// index (i+7)%n
ldr w8, [sp, #20]
add w8, w8, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
mul w10, w10, w9
sub w8, w8, w10
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #29611
mul w13, w13, w14
add w13, w13, #28
// rotate left 6
lsl w8, w13, #6
lsr w9, w13, #26
orr w13, w8, w9
// state ^= (state>>1)+16987
lsr w8, w13, #1
mov w9, #16987
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*31658
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #31658
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// index (i+5)%n
ldr w8, [sp, #20]
add w8, w8, #5
ldr w9, [sp, #8]
sdiv w10, w8, w9
mul w10, w10, w9
sub w8, w8, w10
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #18807
mul w13, w13, w14
add w13, w13, #32
// rotate left 12
lsl w8, w13, #12
lsr w9, w13, #20
orr w13, w8, w9
// state ^= (state>>3)+36789
lsr w8, w13, #3
mov w9, #36789
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*3037
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #3037
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// index (i+5)%n
ldr w8, [sp, #20]
add w8, w8, #5
ldr w9, [sp, #8]
sdiv w10, w8, w9
mul w10, w10, w9
sub w8, w8, w10
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #52681
mul w13, w13, w14
add w13, w13, #36
// rotate left 13
lsl w8, w13, #13
lsr w9, w13, #19
orr w13, w8, w9
// state ^= (state>>1)+21185
lsr w8, w13, #1
mov w9, #21185
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*30651
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #30651
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// index (i+4)%n
ldr w8, [sp, #20]
add w8, w8, #4
ldr w9, [sp, #8]
sdiv w10, w8, w9
mul w10, w10, w9
sub w8, w8, w10
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #50769
mul w13, w13, w14
add w13, w13, #40
// rotate left 2
lsl w8, w13, #2
lsr w9, w13, #30
orr w13, w8, w9
// state ^= (state>>5)+7181
lsr w8, w13, #5
mov w9, #7181
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*31453
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #31453
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
// index (i+1)%n
ldr w8, [sp, #20]
add w8, w8, #1
ldr w9, [sp, #8]
sdiv w10, w8, w9
mul w10, w10, w9
sub w8, w8, w10
ldr x11, [sp, #0]
ldr w12, [x11, w8, sxtw #2]
eor w13, w13, w12
mov w14, #11325
mul w13, w13, w14
add w13, w13, #44
// rotate left 13
lsl w8, w13, #13
lsr w9, w13, #19
orr w13, w8, w9
// state ^= (state>>12)+2476
lsr w8, w13, #12
mov w9, #2476
add w8, w8, w9
eor w13, w13, w8
// state += (i+round)*13301
ldr w8, [sp, #20]
ldr w9, [sp, #24]
add w8, w8, w9
mov w10, #13301
mul w8, w8, w10
add w13, w13, w8
str w13, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s016_end:

# block r_s001_body_s001_body_s017_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #0x10000
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s017_else

# block r_s001_body_s001_body_s017_then
// block 1: state = (state ^ a[(i+5)%n]) * 10489 + 17
ldr w9, [sp, #20]
add w9, w9, #5
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
sxtw x9, w9
ldr w13, [x12, x9, lsl #2]
ldr w8, [sp, #16]
eor w8, w8, w13
mov w14, #10489
mul w8, w8, w14
add w8, w8, #17
// state = (state<<8)|(state>>24)
ror w8, w8, #24
// state ^= (state>>5) + 35486
lsr w9, w8, #5
mov w14, #35486
add w9, w9, w14
eor w8, w8, w9
// state += (i+round)*18422
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #18422
mul w9, w9, w14
add w8, w8, w9
// block 2: state = (state ^ a[(i+1)%n]) * 2089 + 21
ldr w9, [sp, #20]
add w9, w9, #1
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
sxtw x9, w9
ldr w13, [x12, x9, lsl #2]
eor w8, w8, w13
mov w14, #2089
mul w8, w8, w14
add w8, w8, #21
// state = (state<<6)|(state>>26)
ror w8, w8, #26
// state ^= (state>>6) + 49943
lsr w9, w8, #6
mov w14, #49943
add w9, w9, w14
eor w8, w8, w9
// state += (i+round)*7272
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #7272
mul w9, w9, w14
add w8, w8, w9
// block 3: state = (state ^ a[(i+3)%n]) * 5947 + 25
ldr w9, [sp, #20]
add w9, w9, #3
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
sxtw x9, w9
ldr w13, [x12, x9, lsl #2]
eor w8, w8, w13
mov w14, #5947
mul w8, w8, w14
add w8, w8, #25
// state = (state<<13)|(state>>19)
ror w8, w8, #19
// state ^= (state>>4) + 54348
lsr w9, w8, #4
mov w14, #54348
add w9, w9, w14
eor w8, w8, w9
// state += (i+round)*44351
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #44351
mul w9, w9, w14
add w8, w8, w9
// block 4: state = (state ^ a[(i+3)%n]) * 12543 + 29
ldr w9, [sp, #20]
add w9, w9, #3
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
sxtw x9, w9
ldr w13, [x12, x9, lsl #2]
eor w8, w8, w13
mov w14, #12543
mul w8, w8, w14
add w8, w8, #29
// state = (state<<1)|(state>>31)
ror w8, w8, #31
// state ^= (state>>8) + 18503
lsr w9, w8, #8
mov w14, #18503
add w9, w9, w14
eor w8, w8, w9
// state += (i+round)*8493
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #8493
mul w9, w9, w14
add w8, w8, w9
// block 5: state = (state ^ a[(i+0)%n]) * 53735 + 33
ldr w9, [sp, #20]
add w9, w9, #0
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
sxtw x9, w9
ldr w13, [x12, x9, lsl #2]
eor w8, w8, w13
mov w14, #53735
mul w8, w8, w14
add w8, w8, #33
// state = (state<<11)|(state>>21)
ror w8, w8, #21
// state ^= (state>>3) + 53601
lsr w9, w8, #3
mov w14, #53601
add w9, w9, w14
eor w8, w8, w9
// state += (i+round)*46722
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #46722
mul w9, w9, w14
add w8, w8, w9
// block 6: state = (state ^ a[(i+5)%n]) * 34577 + 37
ldr w9, [sp, #20]
add w9, w9, #5
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
sxtw x9, w9
ldr w13, [x12, x9, lsl #2]
eor w8, w8, w13
mov w14, #34577
mul w8, w8, w14
add w8, w8, #37
// state = (state<<12)|(state>>20)
ror w8, w8, #20
// state ^= (state>>3) + 5775
lsr w9, w8, #3
mov w14, #5775
add w9, w9, w14
eor w8, w8, w9
// state += (i+round)*13818
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #13818
mul w9, w9, w14
add w8, w8, w9
// block 7: state = (state ^ a[(i+6)%n]) * 15599 + 41
ldr w9, [sp, #20]
add w9, w9, #6
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
sxtw x9, w9
ldr w13, [x12, x9, lsl #2]
eor w8, w8, w13
mov w14, #15599
mul w8, w8, w14
add w8, w8, #41
// state = (state<<14)|(state>>18)
ror w8, w8, #18
// state ^= (state>>12) + 33492
lsr w9, w8, #12
mov w14, #33492
add w9, w9, w14
eor w8, w8, w9
// state += (i+round)*35314
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #35314
mul w9, w9, w14
add w8, w8, w9
// block 8: state = (state ^ a[(i+1)%n]) * 24839 + 45
ldr w9, [sp, #20]
add w9, w9, #1
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w9, w11, w10, w9
ldr x12, [sp, #0]
sxtw x9, w9
ldr w13, [x12, x9, lsl #2]
eor w8, w8, w13
mov w14, #24839
mul w8, w8, w14
add w8, w8, #45
// state = (state<<7)|(state>>25)
ror w8, w8, #25
// state ^= (state>>12) + 27919
lsr w9, w8, #12
mov w14, #27919
add w9, w9, w14
eor w8, w8, w9
// state += (i+round)*34493
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w14, #34493
mul w9, w9, w14
add w8, w8, w9
// store state
str w8, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s017_end
L_long_kernel_r_s001_body_s001_body_s017_else:

# block r_s001_body_s001_body_s017_else
ldr w2, [sp, #16]
lsl w3, w2, #8
lsr w4, w2, #24
orr w2, w3, w4
lsr w3, w2, #12
mov w4, #42545
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w3, w5, w6
mov w4, #30913
mul w3, w3, w4
add w2, w2, w3
ldr w7, [sp, #20]
add w7, w7, #6
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
ldr x10, [sp, #0]
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w2, w2, w11
mov w4, #11883
mul w2, w2, w4
add w2, w2, #20
lsl w3, w2, #5
lsr w4, w2, #27
orr w2, w3, w4
lsr w3, w2, #14
mov w4, #18143
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w3, w5, w6
mov w4, #29159
mul w3, w3, w4
add w2, w2, w3
ldr w7, [sp, #20]
add w7, w7, #3
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
ldr x10, [sp, #0]
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w2, w2, w11
mov w4, #57705
mul w2, w2, w4
add w2, w2, #24
lsl w3, w2, #2
lsr w4, w2, #30
orr w2, w3, w4
lsr w3, w2, #10
mov w4, #23635
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w3, w5, w6
mov w4, #31785
mul w3, w3, w4
add w2, w2, w3
ldr w7, [sp, #20]
add w7, w7, #2
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
ldr x10, [sp, #0]
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w2, w2, w11
mov w4, #14401
mul w2, w2, w4
add w2, w2, #28
lsl w3, w2, #5
lsr w4, w2, #27
orr w2, w3, w4
lsr w3, w2, #10
mov w4, #29752
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w3, w5, w6
mov w4, #38570
mul w3, w3, w4
add w2, w2, w3
ldr w7, [sp, #20]
add w7, w7, #1
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
ldr x10, [sp, #0]
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w2, w2, w11
mov w4, #16977
mul w2, w2, w4
add w2, w2, #32
lsl w3, w2, #2
lsr w4, w2, #30
orr w2, w3, w4
lsr w3, w2, #4
mov w4, #5369
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w3, w5, w6
mov w4, #43660
mul w3, w3, w4
add w2, w2, w3
ldr w7, [sp, #20]
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
ldr x10, [sp, #0]
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w2, w2, w11
mov w4, #41035
mul w2, w2, w4
add w2, w2, #36
lsl w3, w2, #6
lsr w4, w2, #26
orr w2, w3, w4
lsr w3, w2, #12
mov w4, #34639
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w3, w5, w6
mov w4, #59509
mul w3, w3, w4
add w2, w2, w3
ldr w7, [sp, #20]
add w7, w7, #4
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
ldr x10, [sp, #0]
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w2, w2, w11
mov w4, #39175
mul w2, w2, w4
add w2, w2, #40
lsl w3, w2, #6
lsr w4, w2, #26
orr w2, w3, w4
lsr w3, w2, #15
mov w4, #37517
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w3, w5, w6
mov w4, #43581
mul w3, w3, w4
add w2, w2, w3
ldr w7, [sp, #20]
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
ldr x10, [sp, #0]
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w2, w2, w11
mov w4, #36393
mul w2, w2, w4
add w2, w2, #44
lsl w3, w2, #5
lsr w4, w2, #27
orr w2, w3, w4
lsr w3, w2, #14
mov w4, #55998
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w3, w5, w6
mov w4, #57524
mul w3, w3, w4
add w2, w2, w3
ldr w7, [sp, #20]
add w7, w7, #4
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
ldr x10, [sp, #0]
sxtw x9, w9
ldr w11, [x10, x9, lsl #2]
eor w2, w2, w11
mov w4, #61585
mul w2, w2, w4
add w2, w2, #48
str w2, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s017_end:

# block r_s001_body_s001_body_s018_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #0x20000
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s018_else

# block r_s001_body_s001_body_s018_then
// load state
ldr w0, [sp, #16]
// rotate left by 1
lsl w1, w0, #1
lsr w2, w0, #31
orr w0, w1, w2
// state ^= (state>>9)+23376
lsr w1, w0, #9
mov w12, #23376
add w1, w1, w12
eor w0, w0, w1
// state += (i+round)*38407
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w5, w3, w4
mov w6, #38407
mul w5, w5, w6
add w0, w0, w5
// state = (state ^ a[(i+2)%n]) * 12215 + 21
ldr w3, [sp, #20]
add w7, w3, #2
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x9, w9
ldr x10, [sp, #0]
ldr w11, [x10, x9, lsl #2]
eor w0, w0, w11
mov w6, #12215
mul w0, w0, w6
add w0, w0, #21
// rotate left by 4
lsl w1, w0, #4
lsr w2, w0, #28
orr w0, w1, w2
// state ^= (state>>7)+3944
lsr w1, w0, #7
add w1, w1, #3944
eor w0, w0, w1
// state += (i+round)*18371
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w5, w3, w4
mov w6, #18371
mul w5, w5, w6
add w0, w0, w5
// state = (state ^ a[(i+0)%n]) * 9553 + 25
ldr w3, [sp, #20]
add w7, w3, #0
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x9, w9
ldr x10, [sp, #0]
ldr w11, [x10, x9, lsl #2]
eor w0, w0, w11
mov w6, #9553
mul w0, w0, w6
add w0, w0, #25
// rotate left by 7
lsl w1, w0, #7
lsr w2, w0, #25
orr w0, w1, w2
// state ^= (state>>1)+34031
lsr w1, w0, #1
mov w12, #34031
add w1, w1, w12
eor w0, w0, w1
// state += (i+round)*5205
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w5, w3, w4
mov w6, #5205
mul w5, w5, w6
add w0, w0, w5
// state = (state ^ a[(i+5)%n]) * 31287 + 29
ldr w3, [sp, #20]
add w7, w3, #5
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x9, w9
ldr x10, [sp, #0]
ldr w11, [x10, x9, lsl #2]
eor w0, w0, w11
mov w6, #31287
mul w0, w0, w6
add w0, w0, #29
// rotate left by 7
lsl w1, w0, #7
lsr w2, w0, #25
orr w0, w1, w2
// state ^= (state>>10)+60946
lsr w1, w0, #10
mov w12, #60946
add w1, w1, w12
eor w0, w0, w1
// state += (i+round)*59407
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w5, w3, w4
mov w6, #59407
mul w5, w5, w6
add w0, w0, w5
// state = (state ^ a[(i+7)%n]) * 22537 + 33
ldr w3, [sp, #20]
add w7, w3, #7
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x9, w9
ldr x10, [sp, #0]
ldr w11, [x10, x9, lsl #2]
eor w0, w0, w11
mov w6, #22537
mul w0, w0, w6
add w0, w0, #33
// rotate left by 5
lsl w1, w0, #5
lsr w2, w0, #27
orr w0, w1, w2
// state ^= (state>>12)+36170
lsr w1, w0, #12
mov w12, #36170
add w1, w1, w12
eor w0, w0, w1
// state += (i+round)*5983
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w5, w3, w4
mov w6, #5983
mul w5, w5, w6
add w0, w0, w5
// state = (state ^ a[(i+0)%n]) * 5381 + 37
ldr w3, [sp, #20]
add w7, w3, #0
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x9, w9
ldr x10, [sp, #0]
ldr w11, [x10, x9, lsl #2]
eor w0, w0, w11
mov w6, #5381
mul w0, w0, w6
add w0, w0, #37
// rotate left by 1
lsl w1, w0, #1
lsr w2, w0, #31
orr w0, w1, w2
// state ^= (state>>6)+34637
lsr w1, w0, #6
mov w12, #34637
add w1, w1, w12
eor w0, w0, w1
// state += (i+round)*26203
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w5, w3, w4
mov w6, #26203
mul w5, w5, w6
add w0, w0, w5
// state = (state ^ a[(i+3)%n]) * 44501 + 41
ldr w3, [sp, #20]
add w7, w3, #3
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x9, w9
ldr x10, [sp, #0]
ldr w11, [x10, x9, lsl #2]
eor w0, w0, w11
mov w6, #44501
mul w0, w0, w6
add w0, w0, #41
// rotate left by 6
lsl w1, w0, #6
lsr w2, w0, #26
orr w0, w1, w2
// state ^= (state>>5)+19225
lsr w1, w0, #5
mov w12, #19225
add w1, w1, w12
eor w0, w0, w1
// state += (i+round)*17267
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w5, w3, w4
mov w6, #17267
mul w5, w5, w6
add w0, w0, w5
// state = (state ^ a[(i+3)%n]) * 44989 + 45
ldr w3, [sp, #20]
add w7, w3, #3
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x9, w9
ldr x10, [sp, #0]
ldr w11, [x10, x9, lsl #2]
eor w0, w0, w11
mov w6, #44989
mul w0, w0, w6
add w0, w0, #45
// rotate left by 12
lsl w1, w0, #12
lsr w2, w0, #20
orr w0, w1, w2
// state ^= (state>>4)+53547
lsr w1, w0, #4
mov w12, #53547
add w1, w1, w12
eor w0, w0, w1
// state += (i+round)*690
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w5, w3, w4
mov w6, #690
mul w5, w5, w6
add w0, w0, w5
// state = (state ^ a[(i+0)%n]) * 59559 + 49
ldr w3, [sp, #20]
add w7, w3, #0
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x9, w9
ldr x10, [sp, #0]
ldr w11, [x10, x9, lsl #2]
eor w0, w0, w11
mov w6, #59559
mul w0, w0, w6
add w0, w0, #49
// store state
str w0, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s018_end
L_long_kernel_r_s001_body_s001_body_s018_else:

# block r_s001_body_s001_body_s018_else
ldr w8, [sp, #16]
lsr w9, w8, #5
mov w10, #59317
add w9, w9, w10
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #16075
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #1
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w13, w15, w14, w13
ldr x9, [sp, #0]
sxtw x13, w13
ldr w10, [x9, x13, lsl #2]
eor w8, w8, w10
mov w12, #26383
mul w8, w8, w12
add w8, w8, #20
lsl w10, w8, #12
lsr w11, w8, #20
orr w8, w10, w11
lsr w9, w8, #13
mov w10, #56857
add w9, w9, w10
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #762
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #7
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w13, w15, w14, w13
ldr x9, [sp, #0]
sxtw x13, w13
ldr w10, [x9, x13, lsl #2]
eor w8, w8, w10
mov w12, #15999
mul w8, w8, w12
add w8, w8, #24
lsl w10, w8, #3
lsr w11, w8, #29
orr w8, w10, w11
lsr w9, w8, #13
mov w10, #54080
add w9, w9, w10
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #64402
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #7
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w13, w15, w14, w13
ldr x9, [sp, #0]
sxtw x13, w13
ldr w10, [x9, x13, lsl #2]
eor w8, w8, w10
mov w12, #3221
mul w8, w8, w12
add w8, w8, #28
lsl w10, w8, #10
lsr w11, w8, #22
orr w8, w10, w11
lsr w9, w8, #14
mov w10, #43879
add w9, w9, w10
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #14467
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #1
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w13, w15, w14, w13
ldr x9, [sp, #0]
sxtw x13, w13
ldr w10, [x9, x13, lsl #2]
eor w8, w8, w10
mov w12, #31129
mul w8, w8, w12
add w8, w8, #32
lsl w10, w8, #4
lsr w11, w8, #28
orr w8, w10, w11
lsr w9, w8, #7
mov w10, #13602
add w9, w9, w10
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #28348
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #6
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w13, w15, w14, w13
ldr x9, [sp, #0]
sxtw x13, w13
ldr w10, [x9, x13, lsl #2]
eor w8, w8, w10
mov w12, #31755
mul w8, w8, w12
add w8, w8, #36
lsl w10, w8, #11
lsr w11, w8, #21
orr w8, w10, w11
lsr w9, w8, #8
mov w10, #22109
add w9, w9, w10
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #31612
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #2
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w13, w15, w14, w13
ldr x9, [sp, #0]
sxtw x13, w13
ldr w10, [x9, x13, lsl #2]
eor w8, w8, w10
mov w12, #16077
mul w8, w8, w12
add w8, w8, #40
lsl w10, w8, #7
lsr w11, w8, #25
orr w8, w10, w11
lsr w9, w8, #4
mov w10, #37881
add w9, w9, w10
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #58972
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #1
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w13, w15, w14, w13
ldr x9, [sp, #0]
sxtw x13, w13
ldr w10, [x9, x13, lsl #2]
eor w8, w8, w10
mov w12, #27323
mul w8, w8, w12
add w8, w8, #44
lsl w10, w8, #3
lsr w11, w8, #29
orr w8, w10, w11
lsr w9, w8, #14
mov w10, #11971
add w9, w9, w10
eor w8, w8, w9
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #508
mul w10, w10, w12
add w8, w8, w10
ldr w13, [sp, #20]
add w13, w13, #2
ldr w14, [sp, #8]
sdiv w15, w13, w14
msub w13, w15, w14, w13
ldr x9, [sp, #0]
sxtw x13, w13
ldr w10, [x9, x13, lsl #2]
eor w8, w8, w10
mov w12, #54387
mul w8, w8, w12
add w8, w8, #48
lsl w10, w8, #7
lsr w11, w8, #25
orr w8, w10, w11
str w8, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s018_end:

# block r_s001_body_s001_body_s019_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #0x40000
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s019_else

# block r_s001_body_s001_body_s019_then
// lego_v3_state ^= (lego_v3_state >> 10) + 26739u;
ldr w0, [sp, #16]
lsr w1, w0, #10
mov w10, #26739
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 27867u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #27867
mul w2, w2, w4
ldr w0, [sp, #16]
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 11653u + 21u;
ldr w5, [sp, #20]
add w5, w5, #0
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w9
mov w4, #11653
mul w0, w0, w4
add w0, w0, #21
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 12) | (lego_v3_state >> 20);
ldr w0, [sp, #16]
ror w0, w0, #20
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 9) + 6851u;
ldr w0, [sp, #16]
lsr w1, w0, #9
mov w10, #6851
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 27146u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #27146
mul w2, w2, w4
ldr w0, [sp, #16]
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 7) % lego_v1_n]) * 7625u + 25u;
ldr w5, [sp, #20]
add w5, w5, #7
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w9
mov w4, #7625
mul w0, w0, w4
add w0, w0, #25
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 10) | (lego_v3_state >> 22);
ldr w0, [sp, #16]
ror w0, w0, #22
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 48889u;
ldr w0, [sp, #16]
lsr w1, w0, #13
mov w10, #48889
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 26186u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #26186
mul w2, w2, w4
ldr w0, [sp, #16]
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 5) % lego_v1_n]) * 59125u + 29u;
ldr w5, [sp, #20]
add w5, w5, #5
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w9
mov w4, #59125
mul w0, w0, w4
add w0, w0, #29
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 6) | (lego_v3_state >> 26);
ldr w0, [sp, #16]
ror w0, w0, #26
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 4734u;
ldr w0, [sp, #16]
lsr w1, w0, #13
mov w10, #4734
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 13073u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #13073
mul w2, w2, w4
ldr w0, [sp, #16]
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 2) % lego_v1_n]) * 40473u + 33u;
ldr w5, [sp, #20]
add w5, w5, #2
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w9
mov w4, #40473
mul w0, w0, w4
add w0, w0, #33
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 12) | (lego_v3_state >> 20);
ldr w0, [sp, #16]
ror w0, w0, #20
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 6) + 46728u;
ldr w0, [sp, #16]
lsr w1, w0, #6
mov w10, #46728
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 33588u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #33588
mul w2, w2, w4
ldr w0, [sp, #16]
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 5) % lego_v1_n]) * 64665u + 37u;
ldr w5, [sp, #20]
add w5, w5, #5
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w9
mov w4, #64665
mul w0, w0, w4
add w0, w0, #37
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 4) | (lego_v3_state >> 28);
ldr w0, [sp, #16]
ror w0, w0, #28
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 33163u;
ldr w0, [sp, #16]
lsr w1, w0, #13
mov w10, #33163
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 46617u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #46617
mul w2, w2, w4
ldr w0, [sp, #16]
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 3) % lego_v1_n]) * 64101u + 41u;
ldr w5, [sp, #20]
add w5, w5, #3
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w9
mov w4, #64101
mul w0, w0, w4
add w0, w0, #41
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 14) | (lego_v3_state >> 18);
ldr w0, [sp, #16]
ror w0, w0, #18
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 8) + 51274u;
ldr w0, [sp, #16]
lsr w1, w0, #8
mov w10, #51274
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 5570u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #5570
mul w2, w2, w4
ldr w0, [sp, #16]
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 1) % lego_v1_n]) * 18615u + 45u;
ldr w5, [sp, #20]
add w5, w5, #1
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w9
mov w4, #18615
mul w0, w0, w4
add w0, w0, #45
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 4) | (lego_v3_state >> 28);
ldr w0, [sp, #16]
ror w0, w0, #28
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 4) + 33759u;
ldr w0, [sp, #16]
lsr w1, w0, #4
mov w10, #33759
add w1, w1, w10
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 61131u;
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #61131
mul w2, w2, w4
ldr w0, [sp, #16]
add w0, w0, w2
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 2) % lego_v1_n]) * 55509u + 49u;
ldr w5, [sp, #20]
add w5, w5, #2
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr x8, [sp, #0]
sxtw x7, w7
ldr w9, [x8, x7, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w9
mov w4, #55509
mul w0, w0, w4
add w0, w0, #49
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 1) | (lego_v3_state >> 31);
ldr w0, [sp, #16]
ror w0, w0, #31
str w0, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s019_end
L_long_kernel_r_s001_body_s001_body_s019_else:

# block r_s001_body_s001_body_s019_else
// load i and round, compute (i+round)
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w4, w2, w3
// state += (i+round)*26276
mov w5, #26276
mul w6, w4, w5
ldr w7, [sp, #16]
add w7, w7, w6
// index = (i+2) % n
add w8, w2, #2
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
ldr w12, [x11, w10, sxtw #2]
eor w7, w7, w12
mov w5, #57031
mul w7, w7, w5
add w7, w7, #20
// rotate left 5
lsl w13, w7, #5
lsr w14, w7, #27
orr w7, w13, w14
// state ^= (state>>6)+24314
lsr w13, w7, #6
mov w5, #24314
add w13, w13, w5
eor w7, w7, w13
// state += (i+round)*47394
mov w5, #47394
mul w6, w4, w5
add w7, w7, w6
// index = (i+1)%n
add w8, w2, #1
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr w12, [x11, w10, sxtw #2]
eor w7, w7, w12
mov w5, #11787
mul w7, w7, w5
add w7, w7, #24
// rotate left 4
lsl w13, w7, #4
lsr w14, w7, #28
orr w7, w13, w14
// state ^= (state>>1)+5773
lsr w13, w7, #1
mov w5, #5773
add w13, w13, w5
eor w7, w7, w13
// state += (i+round)*60801
mov w5, #60801
mul w6, w4, w5
add w7, w7, w6
// index = (i+2)%n
add w8, w2, #2
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr w12, [x11, w10, sxtw #2]
eor w7, w7, w12
mov w5, #17915
mul w7, w7, w5
add w7, w7, #28
// rotate left 13
lsl w13, w7, #13
lsr w14, w7, #19
orr w7, w13, w14
// state ^= (state>>4)+54062
lsr w13, w7, #4
mov w5, #54062
add w13, w13, w5
eor w7, w7, w13
// state += (i+round)*7046
mov w5, #7046
mul w6, w4, w5
add w7, w7, w6
// index = (i+5)%n
add w8, w2, #5
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr w12, [x11, w10, sxtw #2]
eor w7, w7, w12
mov w5, #54541
mul w7, w7, w5
add w7, w7, #32
// rotate left 13
lsl w13, w7, #13
lsr w14, w7, #19
orr w7, w13, w14
// state ^= (state>>3)+37371
lsr w13, w7, #3
mov w5, #37371
add w13, w13, w5
eor w7, w7, w13
// state += (i+round)*49953
mov w5, #49953
mul w6, w4, w5
add w7, w7, w6
// index = (i+2)%n
add w8, w2, #2
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr w12, [x11, w10, sxtw #2]
eor w7, w7, w12
mov w5, #44027
mul w7, w7, w5
add w7, w7, #36
// rotate left 11
lsl w13, w7, #11
lsr w14, w7, #21
orr w7, w13, w14
// state ^= (state>>5)+2569
lsr w13, w7, #5
mov w5, #2569
add w13, w13, w5
eor w7, w7, w13
// state += (i+round)*18143
mov w5, #18143
mul w6, w4, w5
add w7, w7, w6
// index = (i+2)%n
add w8, w2, #2
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr w12, [x11, w10, sxtw #2]
eor w7, w7, w12
mov w5, #40785
mul w7, w7, w5
add w7, w7, #40
// rotate left 10
lsl w13, w7, #10
lsr w14, w7, #22
orr w7, w13, w14
// state ^= (state>>14)+14624
lsr w13, w7, #14
mov w5, #14624
add w13, w13, w5
eor w7, w7, w13
// state += (i+round)*64781
mov w5, #64781
mul w6, w4, w5
add w7, w7, w6
// index = (i+5)%n
add w8, w2, #5
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr w12, [x11, w10, sxtw #2]
eor w7, w7, w12
mov w5, #4487
mul w7, w7, w5
add w7, w7, #44
// rotate left 12
lsl w13, w7, #12
lsr w14, w7, #20
orr w7, w13, w14
// state ^= (state>>3)+35300
lsr w13, w7, #3
mov w5, #35300
add w13, w13, w5
eor w7, w7, w13
// state += (i+round)*52224
mov w5, #52224
mul w6, w4, w5
add w7, w7, w6
// index = (i+2)%n
add w8, w2, #2
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr w12, [x11, w10, sxtw #2]
eor w7, w7, w12
mov w5, #39375
mul w7, w7, w5
add w7, w7, #48
// rotate left 10
lsl w13, w7, #10
lsr w14, w7, #22
orr w7, w13, w14
// state ^= (state>>3)+35181
lsr w13, w7, #3
mov w5, #35181
add w13, w13, w5
eor w7, w7, w13
// store state
str w7, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s019_end:

# block r_s001_body_s001_body_s020_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
mov w2, #524288
and w0, w0, w2
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s020_else

# block r_s001_body_s001_body_s020_then
ldr w3, [sp, #16]
// state += (i+round)*33413
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #33413
mul w6, w6, w7
add w3, w3, w6
// a[(i+2)%n]
ldr x8, [sp, #0]
ldr w9, [sp, #8]
add w10, w4, #2
sdiv w11, w10, w9
msub w11, w11, w9, w10
sxtw x11, w11
ldr w12, [x8, x11, lsl #2]
eor w3, w3, w12
mov w7, #22023
mul w3, w3, w7
add w3, w3, #21
// rotate left 14
lsl w13, w3, #14
lsr w14, w3, #18
orr w3, w13, w14
// state ^= (state>>10)+52962
lsr w13, w3, #10
mov w7, #52962
add w13, w13, w7
eor w3, w3, w13
// state += (i+round)*62134
add w6, w4, w5
mov w7, #62134
mul w6, w6, w7
add w3, w3, w6
// a[(i+6)%n]
add w10, w4, #6
sdiv w11, w10, w9
msub w11, w11, w9, w10
sxtw x11, w11
ldr w12, [x8, x11, lsl #2]
eor w3, w3, w12
mov w7, #4557
mul w3, w3, w7
add w3, w3, #25
// rotate left 8
lsl w13, w3, #8
lsr w14, w3, #24
orr w3, w13, w14
// state ^= (state>>6)+61588
lsr w13, w3, #6
mov w7, #61588
add w13, w13, w7
eor w3, w3, w13
// state += (i+round)*41952
add w6, w4, w5
mov w7, #41952
mul w6, w6, w7
add w3, w3, w6
// a[(i+1)%n]
add w10, w4, #1
sdiv w11, w10, w9
msub w11, w11, w9, w10
sxtw x11, w11
ldr w12, [x8, x11, lsl #2]
eor w3, w3, w12
mov w7, #1147
mul w3, w3, w7
add w3, w3, #29
// rotate left 9
lsl w13, w3, #9
lsr w14, w3, #23
orr w3, w13, w14
// state ^= (state>>12)+1730
lsr w13, w3, #12
mov w7, #1730
add w13, w13, w7
eor w3, w3, w13
// state += (i+round)*49757
add w6, w4, w5
mov w7, #49757
mul w6, w6, w7
add w3, w3, w6
// a[(i+0)%n]
mov w10, w4
sdiv w11, w10, w9
msub w11, w11, w9, w10
sxtw x11, w11
ldr w12, [x8, x11, lsl #2]
eor w3, w3, w12
mov w7, #16517
mul w3, w3, w7
add w3, w3, #33
// rotate left 8
lsl w13, w3, #8
lsr w14, w3, #24
orr w3, w13, w14
// state ^= (state>>12)+21087
lsr w13, w3, #12
mov w7, #21087
add w13, w13, w7
eor w3, w3, w13
// state += (i+round)*34143
add w6, w4, w5
mov w7, #34143
mul w6, w6, w7
add w3, w3, w6
// a[(i+1)%n]
add w10, w4, #1
sdiv w11, w10, w9
msub w11, w11, w9, w10
sxtw x11, w11
ldr w12, [x8, x11, lsl #2]
eor w3, w3, w12
mov w7, #18729
mul w3, w3, w7
add w3, w3, #37
// rotate left 10
lsl w13, w3, #10
lsr w14, w3, #22
orr w3, w13, w14
// state ^= (state>>13)+64002
lsr w13, w3, #13
mov w7, #64002
add w13, w13, w7
eor w3, w3, w13
// state += (i+round)*16424
add w6, w4, w5
mov w7, #16424
mul w6, w6, w7
add w3, w3, w6
// a[(i+6)%n]
add w10, w4, #6
sdiv w11, w10, w9
msub w11, w11, w9, w10
sxtw x11, w11
ldr w12, [x8, x11, lsl #2]
eor w3, w3, w12
mov w7, #48451
mul w3, w3, w7
add w3, w3, #41
// rotate left 2
lsl w13, w3, #2
lsr w14, w3, #30
orr w3, w13, w14
// state ^= (state>>12)+24582
lsr w13, w3, #12
mov w7, #24582
add w13, w13, w7
eor w3, w3, w13
// state += (i+round)*24904
add w6, w4, w5
mov w7, #24904
mul w6, w6, w7
add w3, w3, w6
// a[(i+4)%n]
add w10, w4, #4
sdiv w11, w10, w9
msub w11, w11, w9, w10
sxtw x11, w11
ldr w12, [x8, x11, lsl #2]
eor w3, w3, w12
mov w7, #28657
mul w3, w3, w7
add w3, w3, #45
// rotate left 6
lsl w13, w3, #6
lsr w14, w3, #26
orr w3, w13, w14
// state ^= (state>>14)+38907
lsr w13, w3, #14
mov w7, #38907
add w13, w13, w7
eor w3, w3, w13
// state += (i+round)*47390
add w6, w4, w5
mov w7, #47390
mul w6, w6, w7
add w3, w3, w6
// a[(i+4)%n]
add w10, w4, #4
sdiv w11, w10, w9
msub w11, w11, w9, w10
sxtw x11, w11
ldr w12, [x8, x11, lsl #2]
eor w3, w3, w12
mov w7, #341
mul w3, w3, w7
add w3, w3, #49
// rotate left 5
lsl w13, w3, #5
lsr w14, w3, #27
orr w3, w13, w14
// state ^= (state>>13)+56110
lsr w13, w3, #13
mov w7, #56110
add w13, w13, w7
eor w3, w3, w13
str w3, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s020_end
L_long_kernel_r_s001_body_s001_body_s020_else:

# block r_s001_body_s001_body_s020_else
// state = (state ^ a[(i+2)%n]) * 11841 + 20
ldr x0, [sp, #0]
ldr w1, [sp, #20]
add w2, w1, #2
ldr w3, [sp, #8]
sdiv w4, w2, w3
msub w5, w4, w3, w2
sxtw x5, w5
ldr w6, [x0, x5, lsl #2]
ldr w7, [sp, #16]
eor w7, w7, w6
mov w8, #11841
mul w7, w7, w8
add w7, w7, #20
// state = (state<<10)|(state>>22)
ror w7, w7, #22
// state ^= (state>>12)+45625
lsr w9, w7, #12
mov w10, #45625
add w9, w9, w10
eor w7, w7, w9
// state += (i+round)*20685
ldr w11, [sp, #24]
add w12, w1, w11
mov w13, #20685
mul w12, w12, w13
add w7, w7, w12
// state = (state ^ a[(i+0)%n]) * 14799 + 24
sdiv w4, w1, w3
msub w5, w4, w3, w1
sxtw x5, w5
ldr w6, [x0, x5, lsl #2]
eor w7, w7, w6
mov w8, #14799
mul w7, w7, w8
add w7, w7, #24
// state = (state<<5)|(state>>27)
ror w7, w7, #27
// state ^= (state>>13)+48172
lsr w9, w7, #13
mov w10, #48172
add w9, w9, w10
eor w7, w7, w9
// state += (i+round)*649
add w12, w1, w11
mov w13, #649
mul w12, w12, w13
add w7, w7, w12
// state = (state ^ a[(i+7)%n]) * 15453 + 28
add w2, w1, #7
sdiv w4, w2, w3
msub w5, w4, w3, w2
sxtw x5, w5
ldr w6, [x0, x5, lsl #2]
eor w7, w7, w6
mov w8, #15453
mul w7, w7, w8
add w7, w7, #28
// state = (state<<6)|(state>>26)
ror w7, w7, #26
// state ^= (state>>8)+64369
lsr w9, w7, #8
mov w10, #64369
add w9, w9, w10
eor w7, w7, w9
// state += (i+round)*15711
add w12, w1, w11
mov w13, #15711
mul w12, w12, w13
add w7, w7, w12
// state = (state ^ a[(i+2)%n]) * 57309 + 32
add w2, w1, #2
sdiv w4, w2, w3
msub w5, w4, w3, w2
sxtw x5, w5
ldr w6, [x0, x5, lsl #2]
eor w7, w7, w6
mov w8, #57309
mul w7, w7, w8
add w7, w7, #32
// state = (state<<12)|(state>>20)
ror w7, w7, #20
// state ^= (state>>14)+32092
lsr w9, w7, #14
mov w10, #32092
add w9, w9, w10
eor w7, w7, w9
// state += (i+round)*22513
add w12, w1, w11
mov w13, #22513
mul w12, w12, w13
add w7, w7, w12
// state = (state ^ a[(i+5)%n]) * 44111 + 36
add w2, w1, #5
sdiv w4, w2, w3
msub w5, w4, w3, w2
sxtw x5, w5
ldr w6, [x0, x5, lsl #2]
eor w7, w7, w6
mov w8, #44111
mul w7, w7, w8
add w7, w7, #36
// state = (state<<2)|(state>>30)
ror w7, w7, #30
// state ^= (state>>11)+17113
lsr w9, w7, #11
mov w10, #17113
add w9, w9, w10
eor w7, w7, w9
// state += (i+round)*59281
add w12, w1, w11
mov w13, #59281
mul w12, w12, w13
add w7, w7, w12
// state = (state ^ a[(i+7)%n]) * 38305 + 40
add w2, w1, #7
sdiv w4, w2, w3
msub w5, w4, w3, w2
sxtw x5, w5
ldr w6, [x0, x5, lsl #2]
eor w7, w7, w6
mov w8, #38305
mul w7, w7, w8
add w7, w7, #40
// state = (state<<11)|(state>>21)
ror w7, w7, #21
// state ^= (state>>4)+46909
lsr w9, w7, #4
mov w10, #46909
add w9, w9, w10
eor w7, w7, w9
// state += (i+round)*52594
add w12, w1, w11
mov w13, #52594
mul w12, w12, w13
add w7, w7, w12
// state = (state ^ a[(i+5)%n]) * 55373 + 44
add w2, w1, #5
sdiv w4, w2, w3
msub w5, w4, w3, w2
sxtw x5, w5
ldr w6, [x0, x5, lsl #2]
eor w7, w7, w6
mov w8, #55373
mul w7, w7, w8
add w7, w7, #44
// state = (state<<6)|(state>>26)
ror w7, w7, #26
// state ^= (state>>4)+13953
lsr w9, w7, #4
mov w10, #13953
add w9, w9, w10
eor w7, w7, w9
// state += (i+round)*627
add w12, w1, w11
mov w13, #627
mul w12, w12, w13
add w7, w7, w12
// state = (state ^ a[(i+3)%n]) * 60031 + 48
add w2, w1, #3
sdiv w4, w2, w3
msub w5, w4, w3, w2
sxtw x5, w5
ldr w6, [x0, x5, lsl #2]
eor w7, w7, w6
mov w8, #60031
mul w7, w7, w8
add w7, w7, #48
// state = (state<<11)|(state>>21)
ror w7, w7, #21
// state ^= (state>>5)+52263
lsr w9, w7, #5
mov w10, #52263
add w9, w9, w10
eor w7, w7, w9
// state += (i+round)*49336
add w12, w1, w11
mov w13, #49336
mul w12, w12, w13
add w7, w7, w12
// store state
str w7, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s020_end:

# block r_s001_body_s001_body_s021_condition
ldr w8, [sp, #16]
ldr w9, [sp, #12]
eor w8, w8, w9
mov w10, #0x100000
and w8, w8, w10
cmp w8, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s021_else

# block r_s001_body_s001_body_s021_then
ldr x0, [sp, #0]
ldr w9, [sp, #16]
ldr w13, [sp, #20]
ldr w14, [sp, #24]
// group1: index (i+6)%n, mult 36659 add 21
ldr w11, [sp, #8]
add w10, w13, #6
sdiv w12, w10, w11
msub w10, w12, w11, w10
sxtw x10, w10
ldr w10, [x0, x10, lsl #2]
eor w9, w9, w10
mov w15, #36659
mul w9, w9, w15
add w9, w9, #21
// rotate left 11
ror w9, w9, #21
// xor (state>>2)+23562
lsr w10, w9, #2
mov w15, #23562
add w10, w10, w15
eor w9, w9, w10
// += (i+round)*35586
add w10, w13, w14
mov w15, #35586
mul w10, w10, w15
add w9, w9, w10
// group2: index (i+4)%n, mult 43651 add 25
ldr w11, [sp, #8]
add w10, w13, #4
sdiv w12, w10, w11
msub w10, w12, w11, w10
sxtw x10, w10
ldr w10, [x0, x10, lsl #2]
eor w9, w9, w10
mov w15, #43651
mul w9, w9, w15
add w9, w9, #25
// rotate left 1
ror w9, w9, #31
// xor (state>>4)+9897
lsr w10, w9, #4
mov w15, #9897
add w10, w10, w15
eor w9, w9, w10
// += (i+round)*59109
add w10, w13, w14
mov w15, #59109
mul w10, w10, w15
add w9, w9, w10
// group3: index (i+4)%n, mult 39581 add 29
ldr w11, [sp, #8]
add w10, w13, #4
sdiv w12, w10, w11
msub w10, w12, w11, w10
sxtw x10, w10
ldr w10, [x0, x10, lsl #2]
eor w9, w9, w10
mov w15, #39581
mul w9, w9, w15
add w9, w9, #29
// rotate left 3
ror w9, w9, #29
// xor (state>>9)+20540
lsr w10, w9, #9
mov w15, #20540
add w10, w10, w15
eor w9, w9, w10
// += (i+round)*19999
add w10, w13, w14
mov w15, #19999
mul w10, w10, w15
add w9, w9, w10
// group4: index (i+2)%n, mult 18327 add 33
ldr w11, [sp, #8]
add w10, w13, #2
sdiv w12, w10, w11
msub w10, w12, w11, w10
sxtw x10, w10
ldr w10, [x0, x10, lsl #2]
eor w9, w9, w10
mov w15, #18327
mul w9, w9, w15
add w9, w9, #33
// rotate left 6
ror w9, w9, #26
// xor (state>>11)+25709
lsr w10, w9, #11
mov w15, #25709
add w10, w10, w15
eor w9, w9, w10
// += (i+round)*34269
add w10, w13, w14
mov w15, #34269
mul w10, w10, w15
add w9, w9, w10
// group5: index (i+3)%n, mult 10331 add 37
ldr w11, [sp, #8]
add w10, w13, #3
sdiv w12, w10, w11
msub w10, w12, w11, w10
sxtw x10, w10
ldr w10, [x0, x10, lsl #2]
eor w9, w9, w10
mov w15, #10331
mul w9, w9, w15
add w9, w9, #37
// rotate left 2
ror w9, w9, #30
// xor (state>>13)+18309
lsr w10, w9, #13
mov w15, #18309
add w10, w10, w15
eor w9, w9, w10
// += (i+round)*53775
add w10, w13, w14
mov w15, #53775
mul w10, w10, w15
add w9, w9, w10
// group6: index (i+5)%n, mult 44261 add 41
ldr w11, [sp, #8]
add w10, w13, #5
sdiv w12, w10, w11
msub w10, w12, w11, w10
sxtw x10, w10
ldr w10, [x0, x10, lsl #2]
eor w9, w9, w10
mov w15, #44261
mul w9, w9, w15
add w9, w9, #41
// rotate left 15
ror w9, w9, #17
// xor (state>>14)+52222
lsr w10, w9, #14
mov w15, #52222
add w10, w10, w15
eor w9, w9, w10
// += (i+round)*37320
add w10, w13, w14
mov w15, #37320
mul w10, w10, w15
add w9, w9, w10
// group7: index (i+7)%n, mult 10107 add 45
ldr w11, [sp, #8]
add w10, w13, #7
sdiv w12, w10, w11
msub w10, w12, w11, w10
sxtw x10, w10
ldr w10, [x0, x10, lsl #2]
eor w9, w9, w10
mov w15, #10107
mul w9, w9, w15
add w9, w9, #45
// rotate left 8
ror w9, w9, #24
// xor (state>>10)+53388
lsr w10, w9, #10
mov w15, #53388
add w10, w10, w15
eor w9, w9, w10
// += (i+round)*35775
add w10, w13, w14
mov w15, #35775
mul w10, w10, w15
add w9, w9, w10
// group8: index (i+3)%n, mult 51471 add 49
ldr w11, [sp, #8]
add w10, w13, #3
sdiv w12, w10, w11
msub w10, w12, w11, w10
sxtw x10, w10
ldr w10, [x0, x10, lsl #2]
eor w9, w9, w10
mov w15, #51471
mul w9, w9, w15
add w9, w9, #49
// rotate left 6
ror w9, w9, #26
// xor (state>>3)+4257
lsr w10, w9, #3
mov w15, #4257
add w10, w10, w15
eor w9, w9, w10
// += (i+round)*54197
add w10, w13, w14
mov w15, #54197
mul w10, w10, w15
add w9, w9, w10
str w9, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s021_end
L_long_kernel_r_s001_body_s001_body_s021_else:

# block r_s001_body_s001_body_s021_else
ldr w2, [sp, #16]
lsl w3, w2, #10
lsr w4, w2, #22
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #15
mov w8, #7610
add w3, w3, w8
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #65129
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
add w9, w5, #4
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w11, w11, w10, w9
ldr x12, [sp, #0]
sxtw x13, w11
ldr w14, [x12, x13, lsl #2]
eor w2, w2, w14
mov w8, #49855
mul w2, w2, w8
add w2, w2, #24
str w2, [sp, #16]
lsl w3, w2, #2
lsr w4, w2, #30
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #13
mov w8, #52707
add w3, w3, w8
eor w2, w2, w3
str w2, [sp, #16]
add w7, w5, w6
mov w8, #38035
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
add w9, w5, #6
sdiv w11, w9, w10
msub w11, w11, w10, w9
sxtw x13, w11
ldr w14, [x12, x13, lsl #2]
eor w2, w2, w14
mov w8, #38817
mul w2, w2, w8
add w2, w2, #28
str w2, [sp, #16]
lsl w3, w2, #7
lsr w4, w2, #25
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #3
mov w8, #27103
add w3, w3, w8
eor w2, w2, w3
str w2, [sp, #16]
add w7, w5, w6
mov w8, #525
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
add w9, w5, #3
sdiv w11, w9, w10
msub w11, w11, w10, w9
sxtw x13, w11
ldr w14, [x12, x13, lsl #2]
eor w2, w2, w14
mov w8, #27433
mul w2, w2, w8
add w2, w2, #32
str w2, [sp, #16]
lsl w3, w2, #1
lsr w4, w2, #31
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #7
mov w8, #39129
add w3, w3, w8
eor w2, w2, w3
str w2, [sp, #16]
add w7, w5, w6
mov w8, #50758
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
add w9, w5, #2
sdiv w11, w9, w10
msub w11, w11, w10, w9
sxtw x13, w11
ldr w14, [x12, x13, lsl #2]
eor w2, w2, w14
mov w8, #43817
mul w2, w2, w8
add w2, w2, #36
str w2, [sp, #16]
lsl w3, w2, #15
lsr w4, w2, #17
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #2
mov w8, #49116
add w3, w3, w8
eor w2, w2, w3
str w2, [sp, #16]
add w7, w5, w6
mov w8, #39877
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
mov w9, w5
sdiv w11, w9, w10
msub w11, w11, w10, w9
sxtw x13, w11
ldr w14, [x12, x13, lsl #2]
eor w2, w2, w14
mov w8, #51733
mul w2, w2, w8
add w2, w2, #40
str w2, [sp, #16]
lsl w3, w2, #7
lsr w4, w2, #25
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #12
mov w8, #27968
add w3, w3, w8
eor w2, w2, w3
str w2, [sp, #16]
add w7, w5, w6
mov w8, #52552
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
add w9, w5, #5
sdiv w11, w9, w10
msub w11, w11, w10, w9
sxtw x13, w11
ldr w14, [x12, x13, lsl #2]
eor w2, w2, w14
mov w8, #34221
mul w2, w2, w8
add w2, w2, #44
str w2, [sp, #16]
lsl w3, w2, #8
lsr w4, w2, #24
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #13
mov w8, #50231
add w3, w3, w8
eor w2, w2, w3
str w2, [sp, #16]
add w7, w5, w6
mov w8, #21603
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
add w9, w5, #3
sdiv w11, w9, w10
msub w11, w11, w10, w9
sxtw x13, w11
ldr w14, [x12, x13, lsl #2]
eor w2, w2, w14
mov w8, #1071
mul w2, w2, w8
add w2, w2, #48
str w2, [sp, #16]
lsl w3, w2, #9
lsr w4, w2, #23
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #13
mov w8, #42284
add w3, w3, w8
eor w2, w2, w3
str w2, [sp, #16]
add w7, w5, w6
mov w8, #56161
mul w7, w7, w8
add w2, w2, w7
str w2, [sp, #16]
add w9, w5, #4
sdiv w11, w9, w10
msub w11, w11, w10, w9
sxtw x13, w11
ldr w14, [x12, x13, lsl #2]
eor w2, w2, w14
mov w8, #35233
mul w2, w2, w8
add w2, w2, #52
str w2, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s021_end:

# block r_s001_body_s001_body_s022_condition
ldr w8, [sp, #16]
ldr w9, [sp, #12]
eor w8, w8, w9
mov w10, #2097152
and w8, w8, w10
cmp w8, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s022_else

# block r_s001_body_s001_body_s022_then
ldr w2, [sp, #16]
lsl w3, w2, #5
lsr w4, w2, #27
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #13
mov w10, #33635
add w3, w3, w10
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #2673
mul w4, w4, w6
add w2, w2, w4
str w2, [sp, #16]
ldr w4, [sp, #20]
add w4, w4, #7
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #51697
mul w2, w2, w9
add w2, w2, #25
str w2, [sp, #16]
lsl w3, w2, #12
lsr w4, w2, #20
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #10
mov w10, #45297
add w3, w3, w10
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #29669
mul w4, w4, w6
add w2, w2, w4
str w2, [sp, #16]
ldr w4, [sp, #20]
add w4, w4, #1
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #6731
mul w2, w2, w9
add w2, w2, #29
str w2, [sp, #16]
lsl w3, w2, #7
lsr w4, w2, #25
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #11
mov w10, #25115
add w3, w3, w10
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #53746
mul w4, w4, w6
add w2, w2, w4
str w2, [sp, #16]
ldr w4, [sp, #20]
add w4, w4, #3
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #38203
mul w2, w2, w9
add w2, w2, #33
str w2, [sp, #16]
lsl w3, w2, #13
lsr w4, w2, #19
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #12
mov w10, #6324
add w3, w3, w10
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #57880
mul w4, w4, w6
add w2, w2, w4
str w2, [sp, #16]
ldr w4, [sp, #20]
add w4, w4, #0
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #27183
mul w2, w2, w9
add w2, w2, #37
str w2, [sp, #16]
lsl w3, w2, #4
lsr w4, w2, #28
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #12
mov w10, #33427
add w3, w3, w10
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #26984
mul w4, w4, w6
add w2, w2, w4
str w2, [sp, #16]
ldr w4, [sp, #20]
add w4, w4, #0
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #64535
mul w2, w2, w9
add w2, w2, #41
str w2, [sp, #16]
lsl w3, w2, #10
lsr w4, w2, #22
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #12
mov w10, #63633
add w3, w3, w10
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #47988
mul w4, w4, w6
add w2, w2, w4
str w2, [sp, #16]
ldr w4, [sp, #20]
add w4, w4, #5
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #5179
mul w2, w2, w9
add w2, w2, #45
str w2, [sp, #16]
lsl w3, w2, #11
lsr w4, w2, #21
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #14
mov w10, #65487
add w3, w3, w10
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #19443
mul w4, w4, w6
add w2, w2, w4
str w2, [sp, #16]
ldr w4, [sp, #20]
add w4, w4, #0
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #35951
mul w2, w2, w9
add w2, w2, #49
str w2, [sp, #16]
lsl w3, w2, #4
lsr w4, w2, #28
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #12
mov w10, #24296
add w3, w3, w10
eor w2, w2, w3
str w2, [sp, #16]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #33469
mul w4, w4, w6
add w2, w2, w4
str w2, [sp, #16]
ldr w4, [sp, #20]
add w4, w4, #6
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w8, [x7, x4, lsl #2]
eor w2, w2, w8
mov w9, #45339
mul w2, w2, w9
add w2, w2, #53
str w2, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s022_end
L_long_kernel_r_s001_body_s001_body_s022_else:

# block r_s001_body_s001_body_s022_else
// state ^= (state >> 3) + 61773u
ldr w0, [sp, #16]
lsr w1, w0, #3
mov w2, #61773
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round) * 35131u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #35131
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+5)%n]) * 39039u + 24u
ldr w6, [sp, #20]
add w6, w6, #5
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #39039
mul w0, w0, w11
add w0, w0, #24
str w0, [sp, #16]
// state = (state << 2) | (state >> 30)
ror w0, w0, #30
str w0, [sp, #16]
// state ^= (state >> 5) + 27921u
lsr w1, w0, #5
mov w2, #27921
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round) * 4850u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #4850
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+6)%n]) * 28169u + 28u
ldr w6, [sp, #20]
add w6, w6, #6
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #28169
mul w0, w0, w11
add w0, w0, #28
str w0, [sp, #16]
// state = (state << 12) | (state >> 20)
ror w0, w0, #20
str w0, [sp, #16]
// state ^= (state >> 11) + 46252u
lsr w1, w0, #11
mov w2, #46252
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round) * 54018u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #54018
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+7)%n]) * 34401u + 32u
ldr w6, [sp, #20]
add w6, w6, #7
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #34401
mul w0, w0, w11
add w0, w0, #32
str w0, [sp, #16]
// state = (state << 2) | (state >> 30)
ror w0, w0, #30
str w0, [sp, #16]
// state ^= (state >> 10) + 19057u
lsr w1, w0, #10
mov w2, #19057
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round) * 9679u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #9679
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+1)%n]) * 55337u + 36u
ldr w6, [sp, #20]
add w6, w6, #1
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #55337
mul w0, w0, w11
add w0, w0, #36
str w0, [sp, #16]
// state = (state << 12) | (state >> 20)
ror w0, w0, #20
str w0, [sp, #16]
// state ^= (state >> 11) + 53627u
lsr w1, w0, #11
mov w2, #53627
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round) * 34844u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #34844
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+4)%n]) * 20379u + 40u
ldr w6, [sp, #20]
add w6, w6, #4
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #20379
mul w0, w0, w11
add w0, w0, #40
str w0, [sp, #16]
// state = (state << 10) | (state >> 22)
ror w0, w0, #22
str w0, [sp, #16]
// state ^= (state >> 15) + 29408u
lsr w1, w0, #15
mov w2, #29408
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round) * 1454u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #1454
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+1)%n]) * 16879u + 44u
ldr w6, [sp, #20]
add w6, w6, #1
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #16879
mul w0, w0, w11
add w0, w0, #44
str w0, [sp, #16]
// state = (state << 15) | (state >> 17)
ror w0, w0, #17
str w0, [sp, #16]
// state ^= (state >> 14) + 31258u
lsr w1, w0, #14
mov w2, #31258
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round) * 5768u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #5768
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+0)%n]) * 32221u + 48u
ldr w6, [sp, #20]
add w6, w6, #0
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #32221
mul w0, w0, w11
add w0, w0, #48
str w0, [sp, #16]
// state = (state << 10) | (state >> 22)
ror w0, w0, #22
str w0, [sp, #16]
// state ^= (state >> 7) + 1137u
lsr w1, w0, #7
mov w2, #1137
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (unsigned)(i+round) * 31720u
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #31720
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+1)%n]) * 29699u + 52u
ldr w6, [sp, #20]
add w6, w6, #1
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #29699
mul w0, w0, w11
add w0, w0, #52
str w0, [sp, #16]
// state = (state << 1) | (state >> 31)
ror w0, w0, #31
str w0, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s022_end:

# block r_s001_body_s001_body_s023_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #0x400000
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s023_else

# block r_s001_body_s001_body_s023_then
// load state
ldr w2, [sp, #16]
// state ^= (state >> 8) + 54529u
lsr w3, w2, #8
mov w4, #54529
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i+round) * 9434u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #9434
mul w7, w7, w8
add w2, w2, w7
// state = (state ^ a[(i+2)%n]) * 52691u + 25u
ldr w5, [sp, #20]
add w9, w5, #2
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w11, w11, w10, w9
ldr x12, [sp, #0]
sxtw x11, w11
ldr w13, [x12, x11, lsl #2]
eor w2, w2, w13
mov w8, #52691
mul w2, w2, w8
add w2, w2, #25
// state = (state << 6) | (state >> 26)
ror w2, w2, #26
// state ^= (state >> 7) + 39258u
lsr w3, w2, #7
mov w4, #39258
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i+round) * 61292u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #61292
mul w7, w7, w8
add w2, w2, w7
// state = (state ^ a[(i+1)%n]) * 2325u + 29u
ldr w5, [sp, #20]
add w9, w5, #1
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w11, w11, w10, w9
ldr x12, [sp, #0]
sxtw x11, w11
ldr w13, [x12, x11, lsl #2]
eor w2, w2, w13
mov w8, #2325
mul w2, w2, w8
add w2, w2, #29
// state = (state << 8) | (state >> 24)
ror w2, w2, #24
// state ^= (state >> 14) + 7752u
lsr w3, w2, #14
mov w4, #7752
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i+round) * 1307u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #1307
mul w7, w7, w8
add w2, w2, w7
// state = (state ^ a[(i+2)%n]) * 62125u + 33u
ldr w5, [sp, #20]
add w9, w5, #2
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w11, w11, w10, w9
ldr x12, [sp, #0]
sxtw x11, w11
ldr w13, [x12, x11, lsl #2]
eor w2, w2, w13
mov w8, #62125
mul w2, w2, w8
add w2, w2, #33
// state = (state << 6) | (state >> 26)
ror w2, w2, #26
// state ^= (state >> 6) + 9659u
lsr w3, w2, #6
mov w4, #9659
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i+round) * 53295u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #53295
mul w7, w7, w8
add w2, w2, w7
// state = (state ^ a[(i+3)%n]) * 3949u + 37u
ldr w5, [sp, #20]
add w9, w5, #3
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w11, w11, w10, w9
ldr x12, [sp, #0]
sxtw x11, w11
ldr w13, [x12, x11, lsl #2]
eor w2, w2, w13
mov w8, #3949
mul w2, w2, w8
add w2, w2, #37
// state = (state << 5) | (state >> 27)
ror w2, w2, #27
// state ^= (state >> 12) + 1640u
lsr w3, w2, #12
mov w4, #1640
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i+round) * 50u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #50
mul w7, w7, w8
add w2, w2, w7
// state = (state ^ a[(i+0)%n]) * 50977u + 41u
ldr w5, [sp, #20]
add w9, w5, #0
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w11, w11, w10, w9
ldr x12, [sp, #0]
sxtw x11, w11
ldr w13, [x12, x11, lsl #2]
eor w2, w2, w13
mov w8, #50977
mul w2, w2, w8
add w2, w2, #41
// state = (state << 11) | (state >> 21)
ror w2, w2, #21
// state ^= (state >> 13) + 642u
lsr w3, w2, #13
mov w4, #642
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i+round) * 48153u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #48153
mul w7, w7, w8
add w2, w2, w7
// state = (state ^ a[(i+7)%n]) * 14877u + 45u
ldr w5, [sp, #20]
add w9, w5, #7
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w11, w11, w10, w9
ldr x12, [sp, #0]
sxtw x11, w11
ldr w13, [x12, x11, lsl #2]
eor w2, w2, w13
mov w8, #14877
mul w2, w2, w8
add w2, w2, #45
// state = (state << 1) | (state >> 31)
ror w2, w2, #31
// state ^= (state >> 10) + 44319u
lsr w3, w2, #10
mov w4, #44319
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i+round) * 28490u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #28490
mul w7, w7, w8
add w2, w2, w7
// state = (state ^ a[(i+1)%n]) * 55331u + 49u
ldr w5, [sp, #20]
add w9, w5, #1
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w11, w11, w10, w9
ldr x12, [sp, #0]
sxtw x11, w11
ldr w13, [x12, x11, lsl #2]
eor w2, w2, w13
mov w8, #55331
mul w2, w2, w8
add w2, w2, #49
// state = (state << 12) | (state >> 20)
ror w2, w2, #20
// state ^= (state >> 7) + 59276u
lsr w3, w2, #7
mov w4, #59276
add w3, w3, w4
eor w2, w2, w3
// state += (unsigned)(i+round) * 28490u
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #28490
mul w7, w7, w8
add w2, w2, w7
// state = (state ^ a[(i+0)%n]) * 16703u + 53u
ldr w5, [sp, #20]
add w9, w5, #0
ldr w10, [sp, #8]
sdiv w11, w9, w10
msub w11, w11, w10, w9
ldr x12, [sp, #0]
sxtw x11, w11
ldr w13, [x12, x11, lsl #2]
eor w2, w2, w13
mov w8, #16703
mul w2, w2, w8
add w2, w2, #53
// state = (state << 9) | (state >> 23)
ror w2, w2, #23
// store state
str w2, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s023_end
L_long_kernel_r_s001_body_s001_body_s023_else:

# block r_s001_body_s001_body_s023_else
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w4, w2, w3
// state += (i+round)*47442
mov w5, #47442
mul w5, w4, w5
ldr w6, [sp, #16]
add w6, w6, w5
str w6, [sp, #16]
// idx = (i+0) % n ; load a[idx]
ldr w2, [sp, #20]
add w2, w2, #0
ldr w7, [sp, #8]
sdiv w8, w2, w7
msub w2, w8, w7, w2
ldr x9, [sp, #0]
sxtw x2, w2
ldr w10, [x9, x2, lsl #2]
ldr w6, [sp, #16]
eor w6, w6, w10
mov w5, #57465
mul w6, w6, w5
add w6, w6, #24
str w6, [sp, #16]
// rotate left 8
ldr w6, [sp, #16]
ror w6, w6, #24
str w6, [sp, #16]
// state ^= (state>>1)+50251
ldr w6, [sp, #16]
lsr w11, w6, #1
mov w5, #50251
add w11, w11, w5
eor w6, w6, w11
str w6, [sp, #16]
// state += (i+round)*8196
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w4, w2, w3
mov w5, #8196
mul w5, w4, w5
ldr w6, [sp, #16]
add w6, w6, w5
str w6, [sp, #16]
// idx = (i+4)%n ; a[idx]
ldr w2, [sp, #20]
add w2, w2, #4
ldr w7, [sp, #8]
sdiv w8, w2, w7
msub w2, w8, w7, w2
ldr x9, [sp, #0]
sxtw x2, w2
ldr w10, [x9, x2, lsl #2]
ldr w6, [sp, #16]
eor w6, w6, w10
mov w5, #5763
mul w6, w6, w5
add w6, w6, #28
str w6, [sp, #16]
// rotate left 4
ldr w6, [sp, #16]
ror w6, w6, #28
str w6, [sp, #16]
// state ^= (state>>12)+12587
ldr w6, [sp, #16]
lsr w11, w6, #12
mov w5, #12587
add w11, w11, w5
eor w6, w6, w11
str w6, [sp, #16]
// state += (i+round)*43361
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w4, w2, w3
mov w5, #43361
mul w5, w4, w5
ldr w6, [sp, #16]
add w6, w6, w5
str w6, [sp, #16]
// idx = (i+1)%n ; a[idx]
ldr w2, [sp, #20]
add w2, w2, #1
ldr w7, [sp, #8]
sdiv w8, w2, w7
msub w2, w8, w7, w2
ldr x9, [sp, #0]
sxtw x2, w2
ldr w10, [x9, x2, lsl #2]
ldr w6, [sp, #16]
eor w6, w6, w10
mov w5, #10329
mul w6, w6, w5
add w6, w6, #32
str w6, [sp, #16]
// rotate left 4
ldr w6, [sp, #16]
ror w6, w6, #28
str w6, [sp, #16]
// state ^= (state>>8)+24410
ldr w6, [sp, #16]
lsr w11, w6, #8
mov w5, #24410
add w11, w11, w5
eor w6, w6, w11
str w6, [sp, #16]
// state += (i+round)*32245
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w4, w2, w3
mov w5, #32245
mul w5, w4, w5
ldr w6, [sp, #16]
add w6, w6, w5
str w6, [sp, #16]
// idx = (i+4)%n ; a[idx]
ldr w2, [sp, #20]
add w2, w2, #4
ldr w7, [sp, #8]
sdiv w8, w2, w7
msub w2, w8, w7, w2
ldr x9, [sp, #0]
sxtw x2, w2
ldr w10, [x9, x2, lsl #2]
ldr w6, [sp, #16]
eor w6, w6, w10
mov w5, #53577
mul w6, w6, w5
add w6, w6, #36
str w6, [sp, #16]
// rotate left 3
ldr w6, [sp, #16]
ror w6, w6, #29
str w6, [sp, #16]
// state ^= (state>>3)+53002
ldr w6, [sp, #16]
lsr w11, w6, #3
mov w5, #53002
add w11, w11, w5
eor w6, w6, w11
str w6, [sp, #16]
// state += (i+round)*54367
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w4, w2, w3
mov w5, #54367
mul w5, w4, w5
ldr w6, [sp, #16]
add w6, w6, w5
str w6, [sp, #16]
// idx = (i+5)%n ; a[idx]
ldr w2, [sp, #20]
add w2, w2, #5
ldr w7, [sp, #8]
sdiv w8, w2, w7
msub w2, w8, w7, w2
ldr x9, [sp, #0]
sxtw x2, w2
ldr w10, [x9, x2, lsl #2]
ldr w6, [sp, #16]
eor w6, w6, w10
mov w5, #43079
mul w6, w6, w5
add w6, w6, #40
str w6, [sp, #16]
// rotate left 2
ldr w6, [sp, #16]
ror w6, w6, #30
str w6, [sp, #16]
// state ^= (state>>5)+5878
ldr w6, [sp, #16]
lsr w11, w6, #5
mov w5, #5878
add w11, w11, w5
eor w6, w6, w11
str w6, [sp, #16]
// state += (i+round)*17814
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w4, w2, w3
mov w5, #17814
mul w5, w4, w5
ldr w6, [sp, #16]
add w6, w6, w5
str w6, [sp, #16]
// idx = (i+4)%n ; a[idx]
ldr w2, [sp, #20]
add w2, w2, #4
ldr w7, [sp, #8]
sdiv w8, w2, w7
msub w2, w8, w7, w2
ldr x9, [sp, #0]
sxtw x2, w2
ldr w10, [x9, x2, lsl #2]
ldr w6, [sp, #16]
eor w6, w6, w10
mov w5, #7429
mul w6, w6, w5
add w6, w6, #44
str w6, [sp, #16]
// rotate left 1
ldr w6, [sp, #16]
ror w6, w6, #31
str w6, [sp, #16]
// state ^= (state>>5)+49155
ldr w6, [sp, #16]
lsr w11, w6, #5
mov w5, #49155
add w11, w11, w5
eor w6, w6, w11
str w6, [sp, #16]
// state += (i+round)*46024
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w4, w2, w3
mov w5, #46024
mul w5, w4, w5
ldr w6, [sp, #16]
add w6, w6, w5
str w6, [sp, #16]
// idx = (i+6)%n ; a[idx]
ldr w2, [sp, #20]
add w2, w2, #6
ldr w7, [sp, #8]
sdiv w8, w2, w7
msub w2, w8, w7, w2
ldr x9, [sp, #0]
sxtw x2, w2
ldr w10, [x9, x2, lsl #2]
ldr w6, [sp, #16]
eor w6, w6, w10
mov w5, #10583
mul w6, w6, w5
add w6, w6, #48
str w6, [sp, #16]
// rotate left 3
ldr w6, [sp, #16]
ror w6, w6, #29
str w6, [sp, #16]
// state ^= (state>>14)+57631
ldr w6, [sp, #16]
lsr w11, w6, #14
mov w5, #57631
add w11, w11, w5
eor w6, w6, w11
str w6, [sp, #16]
// state += (i+round)*58177
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w4, w2, w3
mov w5, #58177
mul w5, w4, w5
ldr w6, [sp, #16]
add w6, w6, w5
str w6, [sp, #16]
// idx = (i+4)%n ; a[idx]
ldr w2, [sp, #20]
add w2, w2, #4
ldr w7, [sp, #8]
sdiv w8, w2, w7
msub w2, w8, w7, w2
ldr x9, [sp, #0]
sxtw x2, w2
ldr w10, [x9, x2, lsl #2]
ldr w6, [sp, #16]
eor w6, w6, w10
mov w5, #12837
mul w6, w6, w5
add w6, w6, #52
str w6, [sp, #16]
// rotate left 12
ldr w6, [sp, #16]
ror w6, w6, #20
str w6, [sp, #16]
// state ^= (state>>9)+63032
ldr w6, [sp, #16]
lsr w11, w6, #9
mov w5, #63032
add w11, w11, w5
eor w6, w6, w11
str w6, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s023_end:

# block r_s001_body_s001_body_s024_condition
ldr w8, [sp, #16]
ldr w9, [sp, #12]
eor w8, w8, w9
and w8, w8, #0x800000
cmp w8, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s024_else

# block r_s001_body_s001_body_s024_then
ldr w2, [sp, #16]
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w5, w3, w4
mov w6, #12139
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #2
ldr w8, [sp, #8]
sdiv w9, w7, w8
msub w9, w9, w8, w7
ldr x10, [sp, #0]
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #29853
mul w2, w2, w6
add w2, w2, #25
lsr w13, w2, #24
lsl w2, w2, #8
orr w2, w2, w13
lsr w13, w2, #7
mov w14, #43213
add w13, w13, w14
eor w2, w2, w13
add w5, w3, w4
mov w6, #8969
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #2
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #29659
mul w2, w2, w6
add w2, w2, #29
lsr w13, w2, #28
lsl w2, w2, #4
orr w2, w2, w13
lsr w13, w2, #5
mov w14, #16641
add w13, w13, w14
eor w2, w2, w13
add w5, w3, w4
mov w6, #52412
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #3
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #27129
mul w2, w2, w6
add w2, w2, #33
lsr w13, w2, #27
lsl w2, w2, #5
orr w2, w2, w13
lsr w13, w2, #6
mov w14, #47026
add w13, w13, w14
eor w2, w2, w13
add w5, w3, w4
mov w6, #15256
mul w5, w5, w6
add w2, w2, w5
mov w7, w3
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #53511
mul w2, w2, w6
add w2, w2, #37
lsr w13, w2, #27
lsl w2, w2, #5
orr w2, w2, w13
lsr w13, w2, #1
mov w14, #47339
add w13, w13, w14
eor w2, w2, w13
add w5, w3, w4
mov w6, #38093
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #1
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #56165
mul w2, w2, w6
add w2, w2, #41
lsr w13, w2, #29
lsl w2, w2, #3
orr w2, w2, w13
lsr w13, w2, #1
mov w14, #58765
add w13, w13, w14
eor w2, w2, w13
add w5, w3, w4
mov w6, #63687
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #1
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #20685
mul w2, w2, w6
add w2, w2, #45
lsr w13, w2, #23
lsl w2, w2, #9
orr w2, w2, w13
lsr w13, w2, #10
mov w14, #50365
add w13, w13, w14
eor w2, w2, w13
add w5, w3, w4
mov w6, #22496
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #2
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #57897
mul w2, w2, w6
add w2, w2, #49
lsr w13, w2, #21
lsl w2, w2, #11
orr w2, w2, w13
lsr w13, w2, #3
mov w14, #2263
add w13, w13, w14
eor w2, w2, w13
add w5, w3, w4
mov w6, #17387
mul w5, w5, w6
add w2, w2, w5
add w7, w3, #2
sdiv w9, w7, w8
msub w9, w9, w8, w7
sxtw x11, w9
ldr w12, [x10, x11, lsl #2]
eor w2, w2, w12
mov w6, #57973
mul w2, w2, w6
add w2, w2, #53
lsr w13, w2, #25
lsl w2, w2, #7
orr w2, w2, w13
lsr w13, w2, #11
mov w14, #22943
add w13, w13, w14
eor w2, w2, w13
str w2, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s024_end
L_long_kernel_r_s001_body_s001_body_s024_else:

# block r_s001_body_s001_body_s024_else
// group 1: index (i+1)%n, mult 17777, add 24
ldr w2, [sp, #20]
add w2, w2, #1
ldr w3, [sp, #8]
sdiv w4, w2, w3
msub w2, w4, w3, w2
ldr x5, [sp, #0]
ldr w6, [x5, w2, sxtw #2]
ldr w0, [sp, #16]
eor w0, w0, w6
mov w7, #17777
mul w0, w0, w7
add w0, w0, #24
str w0, [sp, #16]
// rotate left 9
lsl w2, w0, #9
lsr w3, w0, #23
orr w0, w2, w3
str w0, [sp, #16]
// xor (state>>11)+45653
lsr w2, w0, #11
mov w3, #45653
add w2, w2, w3
eor w0, w0, w2
str w0, [sp, #16]
// += (i+round)*62758
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #62758
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// group 2: index (i+4)%n, mult 45551, add 28
ldr w2, [sp, #20]
add w2, w2, #4
ldr w3, [sp, #8]
sdiv w4, w2, w3
msub w2, w4, w3, w2
ldr x5, [sp, #0]
ldr w6, [x5, w2, sxtw #2]
eor w0, w0, w6
mov w7, #45551
mul w0, w0, w7
add w0, w0, #28
str w0, [sp, #16]
// rotate left 9
lsl w2, w0, #9
lsr w3, w0, #23
orr w0, w2, w3
str w0, [sp, #16]
// xor (state>>6)+16620
lsr w2, w0, #6
mov w3, #16620
add w2, w2, w3
eor w0, w0, w2
str w0, [sp, #16]
// += (i+round)*41918
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #41918
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// group 3: index (i+4)%n, mult 63403, add 32
ldr w2, [sp, #20]
add w2, w2, #4
ldr w3, [sp, #8]
sdiv w4, w2, w3
msub w2, w4, w3, w2
ldr x5, [sp, #0]
ldr w6, [x5, w2, sxtw #2]
eor w0, w0, w6
mov w7, #63403
mul w0, w0, w7
add w0, w0, #32
str w0, [sp, #16]
// rotate left 10
lsl w2, w0, #10
lsr w3, w0, #22
orr w0, w2, w3
str w0, [sp, #16]
// xor (state>>11)+47407
lsr w2, w0, #11
mov w3, #47407
add w2, w2, w3
eor w0, w0, w2
str w0, [sp, #16]
// += (i+round)*54104
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #54104
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// group 4: index (i+0)%n, mult 51131, add 36
ldr w2, [sp, #20]
add w2, w2, #0
ldr w3, [sp, #8]
sdiv w4, w2, w3
msub w2, w4, w3, w2
ldr x5, [sp, #0]
ldr w6, [x5, w2, sxtw #2]
eor w0, w0, w6
mov w7, #51131
mul w0, w0, w7
add w0, w0, #36
str w0, [sp, #16]
// rotate left 9
lsl w2, w0, #9
lsr w3, w0, #23
orr w0, w2, w3
str w0, [sp, #16]
// xor (state>>15)+51768
lsr w2, w0, #15
mov w3, #51768
add w2, w2, w3
eor w0, w0, w2
str w0, [sp, #16]
// += (i+round)*60310
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #60310
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// group 5: index (i+5)%n, mult 20197, add 40
ldr w2, [sp, #20]
add w2, w2, #5
ldr w3, [sp, #8]
sdiv w4, w2, w3
msub w2, w4, w3, w2
ldr x5, [sp, #0]
ldr w6, [x5, w2, sxtw #2]
eor w0, w0, w6
mov w7, #20197
mul w0, w0, w7
add w0, w0, #40
str w0, [sp, #16]
// rotate left 6
lsl w2, w0, #6
lsr w3, w0, #26
orr w0, w2, w3
str w0, [sp, #16]
// xor (state>>9)+49134
lsr w2, w0, #9
mov w3, #49134
add w2, w2, w3
eor w0, w0, w2
str w0, [sp, #16]
// += (i+round)*37223
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #37223
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// group 6: index (i+6)%n, mult 10309, add 44
ldr w2, [sp, #20]
add w2, w2, #6
ldr w3, [sp, #8]
sdiv w4, w2, w3
msub w2, w4, w3, w2
ldr x5, [sp, #0]
ldr w6, [x5, w2, sxtw #2]
eor w0, w0, w6
mov w7, #10309
mul w0, w0, w7
add w0, w0, #44
str w0, [sp, #16]
// rotate left 7
lsl w2, w0, #7
lsr w3, w0, #25
orr w0, w2, w3
str w0, [sp, #16]
// xor (state>>4)+53023
lsr w2, w0, #4
mov w3, #53023
add w2, w2, w3
eor w0, w0, w2
str w0, [sp, #16]
// += (i+round)*31651
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #31651
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// group 7: index (i+7)%n, mult 45697, add 48
ldr w2, [sp, #20]
add w2, w2, #7
ldr w3, [sp, #8]
sdiv w4, w2, w3
msub w2, w4, w3, w2
ldr x5, [sp, #0]
ldr w6, [x5, w2, sxtw #2]
eor w0, w0, w6
mov w7, #45697
mul w0, w0, w7
add w0, w0, #48
str w0, [sp, #16]
// rotate left 3
lsl w2, w0, #3
lsr w3, w0, #29
orr w0, w2, w3
str w0, [sp, #16]
// xor (state>>8)+41042
lsr w2, w0, #8
mov w3, #41042
add w2, w2, w3
eor w0, w0, w2
str w0, [sp, #16]
// += (i+round)*34522
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #34522
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
// group 8: index (i+5)%n, mult 59401, add 52
ldr w2, [sp, #20]
add w2, w2, #5
ldr w3, [sp, #8]
sdiv w4, w2, w3
msub w2, w4, w3, w2
ldr x5, [sp, #0]
ldr w6, [x5, w2, sxtw #2]
eor w0, w0, w6
mov w7, #59401
mul w0, w0, w7
add w0, w0, #52
str w0, [sp, #16]
// rotate left 6
lsl w2, w0, #6
lsr w3, w0, #26
orr w0, w2, w3
str w0, [sp, #16]
// xor (state>>8)+63690
lsr w2, w0, #8
mov w3, #63690
add w2, w2, w3
eor w0, w0, w2
str w0, [sp, #16]
// += (i+round)*21966
ldr w2, [sp, #20]
ldr w3, [sp, #24]
add w2, w2, w3
mov w4, #21966
mul w2, w2, w4
add w0, w0, w2
str w0, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s024_end:

# block r_s001_body_s001_body_s025_condition
ldr w8, [sp, #16]
ldr w9, [sp, #12]
eor w8, w8, w9
mov w10, #16777216
and w8, w8, w10
cmp w8, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s025_else

# block r_s001_body_s001_body_s025_then
ldr x0, [sp, #0]
ldr w1, [sp, #8]
ldr w4, [sp, #20]
ldr w5, [sp, #24]
ldr w3, [sp, #16]
add w6, w4, #6
sdiv w7, w6, w1
msub w7, w7, w1, w6
sxtw x7, w7
ldr w8, [x0, x7, lsl #2]
eor w3, w3, w8
mov w9, #50843
mul w3, w3, w9
add w3, w3, #25
ror w3, w3, #22
lsr w10, w3, #7
movz w13, #8221
add w10, w10, w13
eor w3, w3, w10
add w11, w4, w5
mov w12, #22208
mul w11, w11, w12
add w3, w3, w11
add w6, w4, #4
sdiv w7, w6, w1
msub w7, w7, w1, w6
sxtw x7, w7
ldr w8, [x0, x7, lsl #2]
eor w3, w3, w8
mov w9, #17505
mul w3, w3, w9
add w3, w3, #29
ror w3, w3, #28
lsr w10, w3, #5
movz w13, #43118
add w10, w10, w13
eor w3, w3, w10
add w11, w4, w5
mov w12, #17638
mul w11, w11, w12
add w3, w3, w11
add w6, w4, #3
sdiv w7, w6, w1
msub w7, w7, w1, w6
sxtw x7, w7
ldr w8, [x0, x7, lsl #2]
eor w3, w3, w8
mov w9, #34381
mul w3, w3, w9
add w3, w3, #33
ror w3, w3, #25
lsr w10, w3, #12
movz w13, #3122
add w10, w10, w13
eor w3, w3, w10
add w11, w4, w5
mov w12, #41510
mul w11, w11, w12
add w3, w3, w11
sdiv w7, w4, w1
msub w7, w7, w1, w4
sxtw x7, w7
ldr w8, [x0, x7, lsl #2]
eor w3, w3, w8
mov w9, #34575
mul w3, w3, w9
add w3, w3, #37
ror w3, w3, #24
lsr w10, w3, #6
movz w13, #41429
add w10, w10, w13
eor w3, w3, w10
add w11, w4, w5
mov w12, #10520
mul w11, w11, w12
add w3, w3, w11
add w6, w4, #7
sdiv w7, w6, w1
msub w7, w7, w1, w6
sxtw x7, w7
ldr w8, [x0, x7, lsl #2]
eor w3, w3, w8
movz w9, #62787
mul w3, w3, w9
add w3, w3, #41
ror w3, w3, #29
lsr w10, w3, #1
movz w13, #42290
add w10, w10, w13
eor w3, w3, w10
add w11, w4, w5
movz w12, #61165
mul w11, w11, w12
add w3, w3, w11
add w6, w4, #4
sdiv w7, w6, w1
msub w7, w7, w1, w6
sxtw x7, w7
ldr w8, [x0, x7, lsl #2]
eor w3, w3, w8
mov w9, #23485
mul w3, w3, w9
add w3, w3, #45
ror w3, w3, #25
lsr w10, w3, #6
movz w13, #56149
add w10, w10, w13
eor w3, w3, w10
add w11, w4, w5
mov w12, #11717
mul w11, w11, w12
add w3, w3, w11
add w6, w4, #1
sdiv w7, w6, w1
msub w7, w7, w1, w6
sxtw x7, w7
ldr w8, [x0, x7, lsl #2]
eor w3, w3, w8
mov w9, #39221
mul w3, w3, w9
add w3, w3, #49
ror w3, w3, #24
lsr w10, w3, #5
movz w13, #39529
add w10, w10, w13
eor w3, w3, w10
add w11, w4, w5
movz w12, #62826
mul w11, w11, w12
add w3, w3, w11
add w6, w4, #2
sdiv w7, w6, w1
msub w7, w7, w1, w6
sxtw x7, w7
ldr w8, [x0, x7, lsl #2]
eor w3, w3, w8
mov w9, #29043
mul w3, w3, w9
add w3, w3, #53
ror w3, w3, #28
lsr w10, w3, #1
movz w13, #54841
add w10, w10, w13
eor w3, w3, w10
add w11, w4, w5
movz w12, #58716
mul w11, w11, w12
add w3, w3, w11
str w3, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s025_end
L_long_kernel_r_s001_body_s001_body_s025_else:

# block r_s001_body_s001_body_s025_else
ldr w2, [sp, #16]
lsl w3, w2, #3
lsr w4, w2, #29
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #5
mov w14, #36843
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #58075
mul w5, w5, w7
add w2, w2, w5
str w2, [sp, #16]
ldr w8, [sp, #20]
add w8, w8, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #103
mul w2, w2, w13
add w2, w2, #28
str w2, [sp, #16]
lsl w3, w2, #4
lsr w4, w2, #28
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #13
mov w14, #8315
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #18386
mul w5, w5, w7
add w2, w2, w5
str w2, [sp, #16]
ldr w8, [sp, #20]
add w8, w8, #3
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #35711
mul w2, w2, w13
add w2, w2, #32
str w2, [sp, #16]
lsl w3, w2, #10
lsr w4, w2, #22
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #6
mov w14, #13468
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #4501
mul w5, w5, w7
add w2, w2, w5
str w2, [sp, #16]
ldr w8, [sp, #20]
add w8, w8, #1
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #4585
mul w2, w2, w13
add w2, w2, #36
str w2, [sp, #16]
lsl w3, w2, #10
lsr w4, w2, #22
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #1
mov w14, #8096
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #3481
mul w5, w5, w7
add w2, w2, w5
str w2, [sp, #16]
ldr w8, [sp, #20]
add w8, w8, #2
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #24639
mul w2, w2, w13
add w2, w2, #40
str w2, [sp, #16]
lsl w3, w2, #8
lsr w4, w2, #24
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #10
mov w14, #60653
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #58575
mul w5, w5, w7
add w2, w2, w5
str w2, [sp, #16]
ldr w8, [sp, #20]
add w8, w8, #6
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #31555
mul w2, w2, w13
add w2, w2, #44
str w2, [sp, #16]
lsl w3, w2, #2
lsr w4, w2, #30
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #8
add w3, w3, #464
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #60575
mul w5, w5, w7
add w2, w2, w5
str w2, [sp, #16]
ldr w8, [sp, #20]
add w8, w8, #3
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #56267
mul w2, w2, w13
add w2, w2, #48
str w2, [sp, #16]
lsl w3, w2, #2
lsr w4, w2, #30
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #11
mov w14, #5054
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #50286
mul w5, w5, w7
add w2, w2, w5
str w2, [sp, #16]
ldr w8, [sp, #20]
add w8, w8, #5
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #55815
mul w2, w2, w13
add w2, w2, #52
str w2, [sp, #16]
lsl w3, w2, #15
lsr w4, w2, #17
orr w2, w3, w4
str w2, [sp, #16]
lsr w3, w2, #7
mov w14, #11476
add w3, w3, w14
eor w2, w2, w3
str w2, [sp, #16]
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w5, w5, w6
mov w7, #2014
mul w5, w5, w7
add w2, w2, w5
str w2, [sp, #16]
ldr w8, [sp, #20]
add w8, w8, #0
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #63935
mul w2, w2, w13
add w2, w2, #56
str w2, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s025_end:

# block r_s001_body_s001_body_s026_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #0x2000000
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s026_else

# block r_s001_body_s001_body_s026_then
ldr w2, [sp, #16]
lsl w3, w2, #7
lsr w4, w2, #25
orr w2, w3, w4
lsr w3, w2, #9
add w3, w3, #391
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #60509
mul w6, w6, w7
add w2, w2, w6
add w8, w4, #3
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #93
mul w2, w2, w13
add w2, w2, #29
lsl w3, w2, #5
lsr w4, w2, #27
orr w2, w3, w4
lsr w3, w2, #10
mov w14, #21008
add w3, w3, w14
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #39857
mul w6, w6, w7
add w2, w2, w6
add w8, w4, #5
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #39555
mul w2, w2, w13
add w2, w2, #33
lsl w3, w2, #2
lsr w4, w2, #30
orr w2, w3, w4
lsr w3, w2, #4
mov w14, #34412
add w3, w3, w14
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #53996
mul w6, w6, w7
add w2, w2, w6
add w8, w4, #6
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #31685
mul w2, w2, w13
add w2, w2, #37
lsl w3, w2, #1
lsr w4, w2, #31
orr w2, w3, w4
lsr w3, w2, #10
mov w14, #35265
add w3, w3, w14
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #33675
mul w6, w6, w7
add w2, w2, w6
add w8, w4, #5
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #33317
mul w2, w2, w13
add w2, w2, #41
lsl w3, w2, #13
lsr w4, w2, #19
orr w2, w3, w4
lsr w3, w2, #14
mov w14, #15221
add w3, w3, w14
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #51644
mul w6, w6, w7
add w2, w2, w6
add w8, w4, #5
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #12871
mul w2, w2, w13
add w2, w2, #45
lsl w3, w2, #14
lsr w4, w2, #18
orr w2, w3, w4
lsr w3, w2, #2
mov w14, #28984
add w3, w3, w14
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #63115
mul w6, w6, w7
add w2, w2, w6
add w8, w4, #6
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #13009
mul w2, w2, w13
add w2, w2, #49
lsl w3, w2, #3
lsr w4, w2, #29
orr w2, w3, w4
lsr w3, w2, #13
mov w14, #52887
add w3, w3, w14
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #58128
mul w6, w6, w7
add w2, w2, w6
add w8, w4, #1
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #14481
mul w2, w2, w13
add w2, w2, #53
lsl w3, w2, #5
lsr w4, w2, #27
orr w2, w3, w4
lsr w3, w2, #9
mov w14, #60109
add w3, w3, w14
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w6, w4, w5
mov w7, #25949
mul w6, w6, w7
add w2, w2, w6
add w8, w4, #7
ldr w9, [sp, #8]
sdiv w10, w8, w9
msub w10, w10, w9, w8
ldr x11, [sp, #0]
sxtw x10, w10
ldr w12, [x11, x10, lsl #2]
eor w2, w2, w12
mov w13, #55923
mul w2, w2, w13
add w2, w2, #57
str w2, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s026_end
L_long_kernel_r_s001_body_s001_body_s026_else:

# block r_s001_body_s001_body_s026_else
// lego_v3_state ^= (lego_v3_state >> 3) + 41041u;
ldr w0, [sp, #16]
lsr w1, w0, #3
mov w2, #41041
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 51247u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #51247
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 4) % lego_v1_n]) * 64999u + 28u;
ldr w3, [sp, #20]
add w3, w3, #4
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w0, w0, w7
mov w8, #64999
mul w0, w0, w8
add w0, w0, #28
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 4) | (lego_v3_state >> 28);
lsl w1, w0, #4
lsr w2, w0, #28
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 5) + 36939u;
lsr w1, w0, #5
mov w2, #36939
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 36154u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #36154
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 6) % lego_v1_n]) * 5261u + 32u;
ldr w3, [sp, #20]
add w3, w3, #6
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w0, w0, w7
mov w8, #5261
mul w0, w0, w8
add w0, w0, #32
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 3) | (lego_v3_state >> 29);
lsl w1, w0, #3
lsr w2, w0, #29
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 5) + 33618u;
lsr w1, w0, #5
mov w2, #33618
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 22264u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #22264
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 5) % lego_v1_n]) * 47545u + 36u;
ldr w3, [sp, #20]
add w3, w3, #5
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w0, w0, w7
mov w8, #47545
mul w0, w0, w8
add w0, w0, #36
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 3) | (lego_v3_state >> 29);
lsl w1, w0, #3
lsr w2, w0, #29
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 10) + 6097u;
lsr w1, w0, #10
mov w2, #6097
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 52505u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #52505
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 1) % lego_v1_n]) * 18307u + 40u;
ldr w3, [sp, #20]
add w3, w3, #1
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w0, w0, w7
mov w8, #18307
mul w0, w0, w8
add w0, w0, #40
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 9) | (lego_v3_state >> 23);
lsl w1, w0, #9
lsr w2, w0, #23
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 4) + 63002u;
lsr w1, w0, #4
mov w2, #63002
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 23372u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #23372
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 3) % lego_v1_n]) * 6311u + 44u;
ldr w3, [sp, #20]
add w3, w3, #3
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w0, w0, w7
mov w8, #6311
mul w0, w0, w8
add w0, w0, #44
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 14) | (lego_v3_state >> 18);
lsl w1, w0, #14
lsr w2, w0, #18
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 51743u;
lsr w1, w0, #13
mov w2, #51743
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 16430u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #16430
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 3) % lego_v1_n]) * 50347u + 48u;
ldr w3, [sp, #20]
add w3, w3, #3
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w0, w0, w7
mov w8, #50347
mul w0, w0, w8
add w0, w0, #48
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 7) | (lego_v3_state >> 25);
lsl w1, w0, #7
lsr w2, w0, #25
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 12) + 10341u;
lsr w1, w0, #12
mov w2, #10341
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 64354u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #64354
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 2) % lego_v1_n]) * 4195u + 52u;
ldr w3, [sp, #20]
add w3, w3, #2
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w0, w0, w7
mov w8, #4195
mul w0, w0, w8
add w0, w0, #52
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 11) | (lego_v3_state >> 21);
lsl w1, w0, #11
lsr w2, w0, #21
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 11) + 41068u;
lsr w1, w0, #11
mov w2, #41068
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 61260u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #61260
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 2) % lego_v1_n]) * 41783u + 56u;
ldr w3, [sp, #20]
add w3, w3, #2
ldr w4, [sp, #8]
sdiv w5, w3, w4
msub w5, w5, w4, w3
ldr x6, [sp, #0]
sxtw x5, w5
ldr w7, [x6, x5, lsl #2]
eor w0, w0, w7
mov w8, #41783
mul w0, w0, w8
add w0, w0, #56
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 5) | (lego_v3_state >> 27);
lsl w1, w0, #5
lsr w2, w0, #27
orr w0, w1, w2
str w0, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s026_end:

# block r_s001_body_s001_body_s027_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #0x4000000
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s027_else

# block r_s001_body_s001_body_s027_then
ldr w2, [sp, #16]
lsr w3, w2, #7
mov w9, #61232
add w3, w3, w9
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #46439
mul w4, w4, w6
add w2, w2, w4
ldr w4, [sp, #20]
ldr w5, [sp, #8]
add w4, w4, #2
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w4, [x7, x4, lsl #2]
eor w2, w2, w4
mov w6, #31719
mul w2, w2, w6
add w2, w2, #29
lsl w3, w2, #13
lsr w4, w2, #19
orr w2, w3, w4
lsr w3, w2, #15
mov w9, #38180
add w3, w3, w9
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #61391
mul w4, w4, w6
add w2, w2, w4
ldr w4, [sp, #20]
ldr w5, [sp, #8]
add w4, w4, #3
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w4, [x7, x4, lsl #2]
eor w2, w2, w4
mov w6, #20205
mul w2, w2, w6
add w2, w2, #33
lsl w3, w2, #4
lsr w4, w2, #28
orr w2, w3, w4
lsr w3, w2, #2
mov w9, #15162
add w3, w3, w9
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #15302
mul w4, w4, w6
add w2, w2, w4
ldr w4, [sp, #20]
ldr w5, [sp, #8]
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w4, [x7, x4, lsl #2]
eor w2, w2, w4
mov w6, #37119
mul w2, w2, w6
add w2, w2, #37
lsl w3, w2, #14
lsr w4, w2, #18
orr w2, w3, w4
lsr w3, w2, #4
mov w8, #64402
add w3, w3, w8
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #52198
mul w4, w4, w6
add w2, w2, w4
ldr w4, [sp, #20]
ldr w5, [sp, #8]
add w4, w4, #1
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w4, [x7, x4, lsl #2]
eor w2, w2, w4
mov w6, #14717
mul w2, w2, w6
add w2, w2, #41
lsl w3, w2, #3
lsr w4, w2, #29
orr w2, w3, w4
lsr w3, w2, #12
mov w9, #32110
add w3, w3, w9
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #21339
mul w4, w4, w6
add w2, w2, w4
ldr w4, [sp, #20]
ldr w5, [sp, #8]
add w4, w4, #1
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w4, [x7, x4, lsl #2]
eor w2, w2, w4
mov w6, #51489
mul w2, w2, w6
add w2, w2, #45
lsl w3, w2, #5
lsr w4, w2, #27
orr w2, w3, w4
lsr w3, w2, #12
mov w8, #46683
add w3, w3, w8
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #11436
mul w4, w4, w6
add w2, w2, w4
ldr w4, [sp, #20]
ldr w5, [sp, #8]
add w4, w4, #2
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w4, [x7, x4, lsl #2]
eor w2, w2, w4
mov w6, #43867
mul w2, w2, w6
add w2, w2, #49
lsl w3, w2, #2
lsr w4, w2, #30
orr w2, w3, w4
lsr w3, w2, #14
mov w8, #57056
add w3, w3, w8
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #25246
mul w4, w4, w6
add w2, w2, w4
ldr w4, [sp, #20]
ldr w5, [sp, #8]
add w4, w4, #1
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w4, [x7, x4, lsl #2]
eor w2, w2, w4
mov w6, #55129
mul w2, w2, w6
add w2, w2, #53
lsl w3, w2, #10
lsr w4, w2, #22
orr w2, w3, w4
lsr w3, w2, #7
mov w8, #11153
add w3, w3, w8
eor w2, w2, w3
ldr w4, [sp, #20]
ldr w5, [sp, #24]
add w4, w4, w5
mov w6, #18672
mul w4, w4, w6
add w2, w2, w4
ldr w4, [sp, #20]
ldr w5, [sp, #8]
add w4, w4, #3
sdiv w6, w4, w5
msub w4, w6, w5, w4
ldr x7, [sp, #0]
sxtw x4, w4
ldr w4, [x7, x4, lsl #2]
eor w2, w2, w4
mov w6, #13413
mul w2, w2, w6
add w2, w2, #57
lsl w3, w2, #1
lsr w4, w2, #31
orr w2, w3, w4
str w2, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s027_end
L_long_kernel_r_s001_body_s001_body_s027_else:

# block r_s001_body_s001_body_s027_else
// load i and round
ldr w1, [sp, #20]
ldr w2, [sp, #24]
// state += (unsigned)(i+round)*10981
add w3, w1, w2
mov w4, #10981
mul w3, w3, w4
ldr w0, [sp, #16]
add w0, w0, w3
// index (i+5) % n
add w5, w1, #5
ldr w6, [sp, #8]
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr x8, [sp, #0]
ldr w9, [x8, w7, sxtw #2]
eor w0, w0, w9
mov w4, #12503
mul w0, w0, w4
add w0, w0, #28
// rotate left 1
ror w0, w0, #31
// state ^= (state>>9)+54032
lsr w10, w0, #9
mov w4, #54032
add w10, w10, w4
eor w0, w0, w10
// state += (i+round)*25486
add w3, w1, w2
mov w4, #25486
mul w3, w3, w4
add w0, w0, w3
// index (i+1)%n
add w5, w1, #1
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr w9, [x8, w7, sxtw #2]
eor w0, w0, w9
mov w4, #18785
mul w0, w0, w4
add w0, w0, #32
// rotate left 14
ror w0, w0, #18
// state ^= (state>>8)+20519
lsr w10, w0, #8
mov w4, #20519
add w10, w10, w4
eor w0, w0, w10
// state += (i+round)*63432
add w3, w1, w2
mov w4, #63432
mul w3, w3, w4
add w0, w0, w3
// index (i+2)%n
add w5, w1, #2
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr w9, [x8, w7, sxtw #2]
eor w0, w0, w9
mov w4, #10649
mul w0, w0, w4
add w0, w0, #36
// rotate left 2
ror w0, w0, #30
// state ^= (state>>14)+33334
lsr w10, w0, #14
mov w4, #33334
add w10, w10, w4
eor w0, w0, w10
// state += (i+round)*47883
add w3, w1, w2
mov w4, #47883
mul w3, w3, w4
add w0, w0, w3
// index (i+3)%n
add w5, w1, #3
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr w9, [x8, w7, sxtw #2]
eor w0, w0, w9
mov w4, #55843
mul w0, w0, w4
add w0, w0, #40
// rotate left 10
ror w0, w0, #22
// state ^= (state>>3)+33283
lsr w10, w0, #3
mov w4, #33283
add w10, w10, w4
eor w0, w0, w10
// state += (i+round)*38210
add w3, w1, w2
mov w4, #38210
mul w3, w3, w4
add w0, w0, w3
// index (i+4)%n
add w5, w1, #4
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr w9, [x8, w7, sxtw #2]
eor w0, w0, w9
mov w4, #62519
mul w0, w0, w4
add w0, w0, #44
// rotate left 1
ror w0, w0, #31
// state ^= (state>>6)+52337
lsr w10, w0, #6
mov w4, #52337
add w10, w10, w4
eor w0, w0, w10
// state += (i+round)*53821
add w3, w1, w2
mov w4, #53821
mul w3, w3, w4
add w0, w0, w3
// index (i+3)%n
add w5, w1, #3
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr w9, [x8, w7, sxtw #2]
eor w0, w0, w9
mov w4, #24701
mul w0, w0, w4
add w0, w0, #48
// rotate left 3
ror w0, w0, #29
// state ^= (state>>8)+6633
lsr w10, w0, #8
mov w4, #6633
add w10, w10, w4
eor w0, w0, w10
// state += (i+round)*50876
add w3, w1, w2
mov w4, #50876
mul w3, w3, w4
add w0, w0, w3
// index (i+3)%n
add w5, w1, #3
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr w9, [x8, w7, sxtw #2]
eor w0, w0, w9
mov w4, #63689
mul w0, w0, w4
add w0, w0, #52
// rotate left 9
ror w0, w0, #23
// state ^= (state>>7)+39703
lsr w10, w0, #7
mov w4, #39703
add w10, w10, w4
eor w0, w0, w10
// state += (i+round)*12921
add w3, w1, w2
mov w4, #12921
mul w3, w3, w4
add w0, w0, w3
// index (i+2)%n
add w5, w1, #2
sdiv w7, w5, w6
msub w7, w7, w6, w5
ldr w9, [x8, w7, sxtw #2]
eor w0, w0, w9
mov w4, #19445
mul w0, w0, w4
add w0, w0, #56
// rotate left 9
ror w0, w0, #23
// state ^= (state>>8)+47883
lsr w10, w0, #8
mov w4, #47883
add w10, w10, w4
eor w0, w0, w10
// store state
str w0, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s027_end:

# block r_s001_body_s001_body_s028_condition
ldr w8, [sp, #16]
ldr w9, [sp, #12]
eor w8, w8, w9
mov w10, #0x8000000
ands w8, w8, w10
cmp w8, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s028_else

# block r_s001_body_s001_body_s028_then
// load state, i, round
ldr w9, [sp, #16]
ldr w10, [sp, #20]
ldr w11, [sp, #24]
ldr x12, [sp, #0]
ldr w13, [sp, #8]
// group 1: state += (i+round)*13637
add w14, w10, w11
mov w15, #13637
mul w14, w14, w15
add w9, w9, w14
// idx = (i+2)%n
add w14, w10, #2
sdiv w15, w14, w13
msub w14, w15, w13, w14
ldr w15, [x12, w14, sxtw #2]
eor w9, w9, w15
mov w15, #23053
mul w9, w9, w15
add w9, w9, #29
// rotate left 15
ror w9, w9, #17
// state ^= (state>>2)+21228
lsr w14, w9, #2
mov w15, #21228
add w14, w14, w15
eor w9, w9, w14
// group 2: state += (i+round)*22755
add w14, w10, w11
mov w15, #22755
mul w14, w14, w15
add w9, w9, w14
// idx=(i+1)%n
add w14, w10, #1
sdiv w15, w14, w13
msub w14, w15, w13, w14
ldr w15, [x12, w14, sxtw #2]
eor w9, w9, w15
mov w15, #60899
mul w9, w9, w15
add w9, w9, #33
// rotate left 5
ror w9, w9, #27
// state ^= (state>>8)+33310
lsr w14, w9, #8
mov w15, #33310
add w14, w14, w15
eor w9, w9, w14
// group 3: state += (i+round)*10652
add w14, w10, w11
mov w15, #10652
mul w14, w14, w15
add w9, w9, w14
// idx=(i+4)%n
add w14, w10, #4
sdiv w15, w14, w13
msub w14, w15, w13, w14
ldr w15, [x12, w14, sxtw #2]
eor w9, w9, w15
mov w15, #55597
mul w9, w9, w15
add w9, w9, #37
// rotate left 11
ror w9, w9, #21
// state ^= (state>>8)+5146
lsr w14, w9, #8
mov w15, #5146
add w14, w14, w15
eor w9, w9, w14
// group 4: state += (i+round)*31753
add w14, w10, w11
mov w15, #31753
mul w14, w14, w15
add w9, w9, w14
// idx=(i+1)%n
add w14, w10, #1
sdiv w15, w14, w13
msub w14, w15, w13, w14
ldr w15, [x12, w14, sxtw #2]
eor w9, w9, w15
mov w15, #47597
mul w9, w9, w15
add w9, w9, #41
// rotate left 13
ror w9, w9, #19
// state ^= (state>>4)+15729
lsr w14, w9, #4
mov w15, #15729
add w14, w14, w15
eor w9, w9, w14
// group 5: state += (i+round)*63290
add w14, w10, w11
mov w15, #63290
mul w14, w14, w15
add w9, w9, w14
// idx=(i+2)%n
add w14, w10, #2
sdiv w15, w14, w13
msub w14, w15, w13, w14
ldr w15, [x12, w14, sxtw #2]
eor w9, w9, w15
mov w15, #3669
mul w9, w9, w15
add w9, w9, #45
// rotate left 10
ror w9, w9, #22
// state ^= (state>>11)+43202
lsr w14, w9, #11
mov w15, #43202
add w14, w14, w15
eor w9, w9, w14
// group 6: state += (i+round)*370
add w14, w10, w11
mov w15, #370
mul w14, w14, w15
add w9, w9, w14
// idx=(i+3)%n
add w14, w10, #3
sdiv w15, w14, w13
msub w14, w15, w13, w14
ldr w15, [x12, w14, sxtw #2]
eor w9, w9, w15
mov w15, #54035
mul w9, w9, w15
add w9, w9, #49
// rotate left 4
ror w9, w9, #28
// state ^= (state>>1)+2476
lsr w14, w9, #1
mov w15, #2476
add w14, w14, w15
eor w9, w9, w14
// group 7: state += (i+round)*2389
add w14, w10, w11
mov w15, #2389
mul w14, w14, w15
add w9, w9, w14
// idx=(i+3)%n
add w14, w10, #3
sdiv w15, w14, w13
msub w14, w15, w13, w14
ldr w15, [x12, w14, sxtw #2]
eor w9, w9, w15
mov w15, #40393
mul w9, w9, w15
add w9, w9, #53
// rotate left 2
ror w9, w9, #30
// state ^= (state>>12)+29966
lsr w14, w9, #12
mov w15, #29966
add w14, w14, w15
eor w9, w9, w14
// group 8: state += (i+round)*44785
add w14, w10, w11
mov w15, #44785
mul w14, w14, w15
add w9, w9, w14
// idx=(i+6)%n
add w14, w10, #6
sdiv w15, w14, w13
msub w14, w15, w13, w14
ldr w15, [x12, w14, sxtw #2]
eor w9, w9, w15
mov w15, #33437
mul w9, w9, w15
add w9, w9, #57
// rotate left 9
ror w9, w9, #23
// state ^= (state>>11)+44945
lsr w14, w9, #11
mov w15, #44945
add w14, w14, w15
eor w9, w9, w14
// store state
str w9, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s028_end
L_long_kernel_r_s001_body_s001_body_s028_else:

# block r_s001_body_s001_body_s028_else
// load persistent values
ldr x10, [sp, #0]
ldr w11, [sp, #8]
ldr w9, [sp, #16]
ldr w12, [sp, #20]
ldr w13, [sp, #24]
// --- block 1: k=6, mul 62975, add 28 ---
add w0, w12, #6
sdiv w1, w0, w11
msub w0, w1, w11, w0
ldr w2, [x10, w0, sxtw #2]
eor w9, w9, w2
mov w3, #62975
mul w9, w9, w3
add w9, w9, #28
// rotate left 9
lsl w4, w9, #9
lsr w5, w9, #23
orr w9, w4, w5
// xor (state>>12)+6588
lsr w4, w9, #12
mov w5, #6588
add w4, w4, w5
eor w9, w9, w4
// state += (i+round)*55888
add w4, w12, w13
mov w5, #55888
mul w4, w4, w5
add w9, w9, w4
// --- block 2: k=3, mul 51825, add 32 ---
add w0, w12, #3
sdiv w1, w0, w11
msub w0, w1, w11, w0
ldr w2, [x10, w0, sxtw #2]
eor w9, w9, w2
mov w3, #51825
mul w9, w9, w3
add w9, w9, #32
lsl w4, w9, #9
lsr w5, w9, #23
orr w9, w4, w5
lsr w4, w9, #14
mov w5, #56044
add w4, w4, w5
eor w9, w9, w4
add w4, w12, w13
mov w5, #20322
mul w4, w4, w5
add w9, w9, w4
// --- block 3: k=4, mul 62249, add 36 ---
add w0, w12, #4
sdiv w1, w0, w11
msub w0, w1, w11, w0
ldr w2, [x10, w0, sxtw #2]
eor w9, w9, w2
mov w3, #62249
mul w9, w9, w3
add w9, w9, #36
lsl w4, w9, #9
lsr w5, w9, #23
orr w9, w4, w5
lsr w4, w9, #7
mov w5, #5265
add w4, w4, w5
eor w9, w9, w4
add w4, w12, w13
mov w5, #41106
mul w4, w4, w5
add w9, w9, w4
// --- block 4: k=4, mul 9581, add 40, rot 11, shift 13, c 15217 ---
add w0, w12, #4
sdiv w1, w0, w11
msub w0, w1, w11, w0
ldr w2, [x10, w0, sxtw #2]
eor w9, w9, w2
mov w3, #9581
mul w9, w9, w3
add w9, w9, #40
lsl w4, w9, #11
lsr w5, w9, #21
orr w9, w4, w5
lsr w4, w9, #13
mov w5, #15217
add w4, w4, w5
eor w9, w9, w4
add w4, w12, w13
mov w5, #27775
mul w4, w4, w5
add w9, w9, w4
// --- block 5: k=5, mul 14567, add 44, rot 13, shift 4, c 65381 ---
add w0, w12, #5
sdiv w1, w0, w11
msub w0, w1, w11, w0
ldr w2, [x10, w0, sxtw #2]
eor w9, w9, w2
mov w3, #14567
mul w9, w9, w3
add w9, w9, #44
lsl w4, w9, #13
lsr w5, w9, #19
orr w9, w4, w5
lsr w4, w9, #4
mov w5, #65381
add w4, w4, w5
eor w9, w9, w4
add w4, w12, w13
mov w5, #51099
mul w4, w4, w5
add w9, w9, w4
// --- block 6: k=6, mul 22041, add 48, rot 2, shift 2, c 10444 ---
add w0, w12, #6
sdiv w1, w0, w11
msub w0, w1, w11, w0
ldr w2, [x10, w0, sxtw #2]
eor w9, w9, w2
mov w3, #22041
mul w9, w9, w3
add w9, w9, #48
lsl w4, w9, #2
lsr w5, w9, #30
orr w9, w4, w5
lsr w4, w9, #2
mov w5, #10444
add w4, w4, w5
eor w9, w9, w4
add w4, w12, w13
mov w5, #35011
mul w4, w4, w5
add w9, w9, w4
// --- block 7: k=3, mul 10429, add 52, rot 4, shift 10, c 60636 ---
add w0, w12, #3
sdiv w1, w0, w11
msub w0, w1, w11, w0
ldr w2, [x10, w0, sxtw #2]
eor w9, w9, w2
mov w3, #10429
mul w9, w9, w3
add w9, w9, #52
lsl w4, w9, #4
lsr w5, w9, #28
orr w9, w4, w5
lsr w4, w9, #10
mov w5, #60636
add w4, w4, w5
eor w9, w9, w4
add w4, w12, w13
mov w5, #11888
mul w4, w4, w5
add w9, w9, w4
// --- block 8: k=5, mul 37425, add 56, rot 10, shift 11, c 18066 ---
add w0, w12, #5
sdiv w1, w0, w11
msub w0, w1, w11, w0
ldr w2, [x10, w0, sxtw #2]
eor w9, w9, w2
mov w3, #37425
mul w9, w9, w3
add w9, w9, #56
lsl w4, w9, #10
lsr w5, w9, #22
orr w9, w4, w5
lsr w4, w9, #11
mov w5, #18066
add w4, w4, w5
eor w9, w9, w4
add w4, w12, w13
mov w5, #65098
mul w4, w4, w5
add w9, w9, w4
// store state
str w9, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s028_end:

# block r_s001_body_s001_body_s029_condition
ldr w8, [sp, #16]
ldr w9, [sp, #12]
eor w8, w8, w9
and w8, w8, #0x10000000
cmp w8, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s029_else

# block r_s001_body_s001_body_s029_then
// i+3 index
ldr w1, [sp, #8]
ldr w2, [sp, #20]
add w3, w2, #3
sdiv w4, w3, w1
mul w4, w4, w1
sub w4, w3, w4
ldr x5, [sp, #0]
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
ldr w8, [sp, #16]
eor w8, w8, w7
mov w9, #9349
mul w8, w8, w9
add w8, w8, #29
// rotate left 5
lsl w10, w8, #5
lsr w11, w8, #27
orr w8, w10, w11
// xor (state>>5)+6991
lsr w10, w8, #5
mov w11, #6991
add w10, w10, w11
eor w8, w8, w10
// += (i+round)*48662
ldr w12, [sp, #24]
add w13, w2, w12
mov w14, #48662
mul w13, w13, w14
add w8, w8, w13
// i+6
add w3, w2, #6
sdiv w4, w3, w1
mul w4, w4, w1
sub w4, w3, w4
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
eor w8, w8, w7
mov w9, #56859
mul w8, w8, w9
add w8, w8, #33
// rotate left 10
lsl w10, w8, #10
lsr w11, w8, #22
orr w8, w10, w11
// xor (state>>11)+40866
lsr w10, w8, #11
mov w11, #40866
add w10, w10, w11
eor w8, w8, w10
// += (i+round)*62369
add w13, w2, w12
mov w14, #62369
mul w13, w13, w14
add w8, w8, w13
// i+6
add w3, w2, #6
sdiv w4, w3, w1
mul w4, w4, w1
sub w4, w3, w4
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
eor w8, w8, w7
mov w9, #45977
mul w8, w8, w9
add w8, w8, #37
// rotate left 1
lsl w10, w8, #1
lsr w11, w8, #31
orr w8, w10, w11
// xor (state>>5)+4270
lsr w10, w8, #5
mov w11, #4270
add w10, w10, w11
eor w8, w8, w10
// += (i+round)*60079
add w13, w2, w12
mov w14, #60079
mul w13, w13, w14
add w8, w8, w13
// i+1
add w3, w2, #1
sdiv w4, w3, w1
mul w4, w4, w1
sub w4, w3, w4
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
eor w8, w8, w7
mov w9, #19099
mul w8, w8, w9
add w8, w8, #41
// rotate left 6
lsl w10, w8, #6
lsr w11, w8, #26
orr w8, w10, w11
// xor (state>>11)+22082
lsr w10, w8, #11
mov w11, #22082
add w10, w10, w11
eor w8, w8, w10
// += (i+round)*20680
add w13, w2, w12
mov w14, #20680
mul w13, w13, w14
add w8, w8, w13
// i+6
add w3, w2, #6
sdiv w4, w3, w1
mul w4, w4, w1
sub w4, w3, w4
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
eor w8, w8, w7
mov w9, #35307
mul w8, w8, w9
add w8, w8, #45
// rotate left 3
lsl w10, w8, #3
lsr w11, w8, #29
orr w8, w10, w11
// xor (state>>15)+32289
lsr w10, w8, #15
mov w11, #32289
add w10, w10, w11
eor w8, w8, w10
// += (i+round)*4809
add w13, w2, w12
mov w14, #4809
mul w13, w13, w14
add w8, w8, w13
// i+5
add w3, w2, #5
sdiv w4, w3, w1
mul w4, w4, w1
sub w4, w3, w4
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
eor w8, w8, w7
mov w9, #38243
mul w8, w8, w9
add w8, w8, #49
// rotate left 10
lsl w10, w8, #10
lsr w11, w8, #22
orr w8, w10, w11
// xor (state>>7)+14442
lsr w10, w8, #7
mov w11, #14442
add w10, w10, w11
eor w8, w8, w10
// += (i+round)*30716
add w13, w2, w12
mov w14, #30716
mul w13, w13, w14
add w8, w8, w13
// i+2
add w3, w2, #2
sdiv w4, w3, w1
mul w4, w4, w1
sub w4, w3, w4
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
eor w8, w8, w7
mov w9, #16819
mul w8, w8, w9
add w8, w8, #53
// rotate left 15
lsl w10, w8, #15
lsr w11, w8, #17
orr w8, w10, w11
// xor (state>>6)+1435
lsr w10, w8, #6
mov w11, #1435
add w10, w10, w11
eor w8, w8, w10
// += (i+round)*4960
add w13, w2, w12
mov w14, #4960
mul w13, w13, w14
add w8, w8, w13
// i+4
add w3, w2, #4
sdiv w4, w3, w1
mul w4, w4, w1
sub w4, w3, w4
sxtw x6, w4
ldr w7, [x5, x6, lsl #2]
eor w8, w8, w7
mov w9, #36159
mul w8, w8, w9
add w8, w8, #57
// rotate left 1
lsl w10, w8, #1
lsr w11, w8, #31
orr w8, w10, w11
// xor (state>>7)+49178
lsr w10, w8, #7
mov w11, #49178
add w10, w10, w11
eor w8, w8, w10
// += (i+round)*54552
add w13, w2, w12
mov w14, #54552
mul w13, w13, w14
add w8, w8, w13
// store state
str w8, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s029_end
L_long_kernel_r_s001_body_s001_body_s029_else:

# block r_s001_body_s001_body_s029_else
ldr w2, [sp, #16]
ror w2, w2, #20
lsr w3, w2, #2
mov w4, #55862
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #56545
mul w7, w7, w8
add w2, w2, w7
ldr w5, [sp, #20]
ldr w9, [sp, #8]
add w10, w5, #1
sdiv w11, w10, w9
msub w10, w11, w9, w10
sxtw x10, w10
ldr x12, [sp, #0]
ldr w13, [x12, x10, lsl #2]
eor w2, w2, w13
mov w8, #43763
mul w2, w2, w8
add w2, w2, #32
ror w2, w2, #17
lsr w3, w2, #3
mov w4, #12001
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #64209
mul w7, w7, w8
add w2, w2, w7
ldr w5, [sp, #20]
ldr w9, [sp, #8]
add w10, w5, #7
sdiv w11, w10, w9
msub w10, w11, w9, w10
sxtw x10, w10
ldr x12, [sp, #0]
ldr w13, [x12, x10, lsl #2]
eor w2, w2, w13
mov w8, #54183
mul w2, w2, w8
add w2, w2, #36
ror w2, w2, #19
lsr w3, w2, #9
mov w4, #63953
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #32575
mul w7, w7, w8
add w2, w2, w7
ldr w5, [sp, #20]
ldr w9, [sp, #8]
add w10, w5, #2
sdiv w11, w10, w9
msub w10, w11, w9, w10
sxtw x10, w10
ldr x12, [sp, #0]
ldr w13, [x12, x10, lsl #2]
eor w2, w2, w13
mov w8, #16075
mul w2, w2, w8
add w2, w2, #40
ror w2, w2, #25
lsr w3, w2, #7
mov w4, #6502
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #8731
mul w7, w7, w8
add w2, w2, w7
ldr w5, [sp, #20]
ldr w9, [sp, #8]
add w10, w5, #0
sdiv w11, w10, w9
msub w10, w11, w9, w10
sxtw x10, w10
ldr x12, [sp, #0]
ldr w13, [x12, x10, lsl #2]
eor w2, w2, w13
mov w8, #43993
mul w2, w2, w8
add w2, w2, #44
ror w2, w2, #21
lsr w3, w2, #5
mov w4, #53290
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #14910
mul w7, w7, w8
add w2, w2, w7
ldr w5, [sp, #20]
ldr w9, [sp, #8]
add w10, w5, #6
sdiv w11, w10, w9
msub w10, w11, w9, w10
sxtw x10, w10
ldr x12, [sp, #0]
ldr w13, [x12, x10, lsl #2]
eor w2, w2, w13
mov w8, #32165
mul w2, w2, w8
add w2, w2, #48
ror w2, w2, #24
lsr w3, w2, #1
mov w4, #18478
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #62415
mul w7, w7, w8
add w2, w2, w7
ldr w5, [sp, #20]
ldr w9, [sp, #8]
add w10, w5, #3
sdiv w11, w10, w9
msub w10, w11, w9, w10
sxtw x10, w10
ldr x12, [sp, #0]
ldr w13, [x12, x10, lsl #2]
eor w2, w2, w13
mov w8, #24215
mul w2, w2, w8
add w2, w2, #52
ror w2, w2, #20
lsr w3, w2, #11
mov w4, #7265
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #51732
mul w7, w7, w8
add w2, w2, w7
ldr w5, [sp, #20]
ldr w9, [sp, #8]
add w10, w5, #6
sdiv w11, w10, w9
msub w10, w11, w9, w10
sxtw x10, w10
ldr x12, [sp, #0]
ldr w13, [x12, x10, lsl #2]
eor w2, w2, w13
mov w8, #41651
mul w2, w2, w8
add w2, w2, #56
ror w2, w2, #18
lsr w3, w2, #11
mov w4, #50251
add w3, w3, w4
eor w2, w2, w3
ldr w5, [sp, #20]
ldr w6, [sp, #24]
add w7, w5, w6
mov w8, #17786
mul w7, w7, w8
add w2, w2, w7
ldr w5, [sp, #20]
ldr w9, [sp, #8]
add w10, w5, #3
sdiv w11, w10, w9
msub w10, w11, w9, w10
sxtw x10, w10
ldr x12, [sp, #0]
ldr w13, [x12, x10, lsl #2]
eor w2, w2, w13
mov w8, #27585
mul w2, w2, w8
add w2, w2, #60
str w2, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s029_end:

# block r_s001_body_s001_body_s030_condition
ldr w8, [sp, #16]
ldr w9, [sp, #12]
eor w8, w8, w9
and w8, w8, #0x20000000
cmp w8, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s030_else

# block r_s001_body_s001_body_s030_then
// block 1: rotate left 4
ldr w0, [sp, #16]
lsl w1, w0, #4
lsr w2, w0, #28
orr w0, w1, w2
str w0, [sp, #16]
// state ^= (state>>3)+45679
lsr w1, w0, #3
mov w2, #45679
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (uint)(i+round)*25404
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #25404
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+2)%n])*15295 + 33
ldr w6, [sp, #20]
add w6, w6, #2
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #15295
mul w0, w0, w5
add w0, w0, #33
str w0, [sp, #16]
// rotate left 15
lsl w1, w0, #15
lsr w2, w0, #17
orr w0, w1, w2
str w0, [sp, #16]
// state ^= (state>>8)+42914
lsr w1, w0, #8
mov w2, #42914
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (uint)(i+round)*23557
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #23557
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+1)%n])*14613 + 37
ldr w6, [sp, #20]
add w6, w6, #1
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #14613
mul w0, w0, w5
add w0, w0, #37
str w0, [sp, #16]
// rotate left 2
lsl w1, w0, #2
lsr w2, w0, #30
orr w0, w1, w2
str w0, [sp, #16]
// state ^= (state>>5)+29963
lsr w1, w0, #5
mov w2, #29963
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (uint)(i+round)*60366
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #60366
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+5)%n])*17241 + 41
ldr w6, [sp, #20]
add w6, w6, #5
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #17241
mul w0, w0, w5
add w0, w0, #41
str w0, [sp, #16]
// rotate left 4
lsl w1, w0, #4
lsr w2, w0, #28
orr w0, w1, w2
str w0, [sp, #16]
// state ^= (state>>9)+35486
lsr w1, w0, #9
mov w2, #35486
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (uint)(i+round)*51743
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #51743
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+3)%n])*2637 + 45
ldr w6, [sp, #20]
add w6, w6, #3
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #2637
mul w0, w0, w5
add w0, w0, #45
str w0, [sp, #16]
// rotate left 8
lsl w1, w0, #8
lsr w2, w0, #24
orr w0, w1, w2
str w0, [sp, #16]
// state ^= (state>>14)+2370
lsr w1, w0, #14
mov w2, #2370
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (uint)(i+round)*6496
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #6496
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+5)%n])*29355 + 49
ldr w6, [sp, #20]
add w6, w6, #5
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #29355
mul w0, w0, w5
add w0, w0, #49
str w0, [sp, #16]
// rotate left 1
lsl w1, w0, #1
lsr w2, w0, #31
orr w0, w1, w2
str w0, [sp, #16]
// state ^= (state>>13)+14062
lsr w1, w0, #13
mov w2, #14062
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (uint)(i+round)*21601
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #21601
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+2)%n])*12403 + 53
ldr w6, [sp, #20]
add w6, w6, #2
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #12403
mul w0, w0, w5
add w0, w0, #53
str w0, [sp, #16]
// rotate left 2
lsl w1, w0, #2
lsr w2, w0, #30
orr w0, w1, w2
str w0, [sp, #16]
// state ^= (state>>7)+46358
lsr w1, w0, #7
mov w2, #46358
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (uint)(i+round)*4003
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #4003
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+0)%n])*30835 + 57
ldr w6, [sp, #20]
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #30835
mul w0, w0, w5
add w0, w0, #57
str w0, [sp, #16]
// rotate left 11
lsl w1, w0, #11
lsr w2, w0, #21
orr w0, w1, w2
str w0, [sp, #16]
// state ^= (state>>3)+17723
lsr w1, w0, #3
mov w2, #17723
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// state += (uint)(i+round)*51638
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #51638
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// state = (state ^ a[(i+5)%n])*42391 + 61
ldr w6, [sp, #20]
add w6, w6, #5
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
sxtw x6, w6
ldr x9, [sp, #0]
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w5, #42391
mul w0, w0, w5
add w0, w0, #61
str w0, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s030_end
L_long_kernel_r_s001_body_s001_body_s030_else:

# block r_s001_body_s001_body_s030_else
// lego_v3_state ^= (lego_v3_state >> 14) + 32041u;
ldr w0, [sp, #16]
lsr w1, w0, #14
mov w2, #32041
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 19645u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #19645
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 1) % lego_v1_n]) * 5895u + 32u;
ldr w6, [sp, #20]
add w6, w6, #1
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
ldr x9, [sp, #0]
sxtw x6, w6
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #5895
mul w0, w0, w11
add w0, w0, #32
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 3) | (lego_v3_state >> 29);
lsl w1, w0, #3
lsr w2, w0, #29
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 7) + 35435u;
lsr w1, w0, #7
mov w2, #35435
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 15510u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #15510
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 1) % lego_v1_n]) * 44275u + 36u;
ldr w6, [sp, #20]
add w6, w6, #1
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
ldr x9, [sp, #0]
sxtw x6, w6
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #44275
mul w0, w0, w11
add w0, w0, #36
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 6) | (lego_v3_state >> 26);
lsl w1, w0, #6
lsr w2, w0, #26
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 15) + 12571u;
lsr w1, w0, #15
mov w2, #12571
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 37015u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #37015
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 20785u + 40u;
ldr w6, [sp, #20]
add w6, w6, #0
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
ldr x9, [sp, #0]
sxtw x6, w6
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #20785
mul w0, w0, w11
add w0, w0, #40
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 9) | (lego_v3_state >> 23);
lsl w1, w0, #9
lsr w2, w0, #23
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 13) + 36346u;
lsr w1, w0, #13
mov w2, #36346
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 37123u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #37123
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 1) % lego_v1_n]) * 41197u + 44u;
ldr w6, [sp, #20]
add w6, w6, #1
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
ldr x9, [sp, #0]
sxtw x6, w6
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #41197
mul w0, w0, w11
add w0, w0, #44
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 7) | (lego_v3_state >> 25);
lsl w1, w0, #7
lsr w2, w0, #25
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 6) + 64790u;
lsr w1, w0, #6
mov w2, #64790
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 64302u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #64302
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 6) % lego_v1_n]) * 42297u + 48u;
ldr w6, [sp, #20]
add w6, w6, #6
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
ldr x9, [sp, #0]
sxtw x6, w6
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #42297
mul w0, w0, w11
add w0, w0, #48
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 14) | (lego_v3_state >> 18);
lsl w1, w0, #14
lsr w2, w0, #18
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 6) + 32803u;
lsr w1, w0, #6
mov w2, #32803
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 6899u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #6899
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 7) % lego_v1_n]) * 42805u + 52u;
ldr w6, [sp, #20]
add w6, w6, #7
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
ldr x9, [sp, #0]
sxtw x6, w6
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #42805
mul w0, w0, w11
add w0, w0, #52
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 7) | (lego_v3_state >> 25);
lsl w1, w0, #7
lsr w2, w0, #25
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 6) + 35827u;
lsr w1, w0, #6
mov w2, #35827
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 39914u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #39914
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 3) % lego_v1_n]) * 55559u + 56u;
ldr w6, [sp, #20]
add w6, w6, #3
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
ldr x9, [sp, #0]
sxtw x6, w6
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #55559
mul w0, w0, w11
add w0, w0, #56
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 6) | (lego_v3_state >> 26);
lsl w1, w0, #6
lsr w2, w0, #26
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 1) + 33994u;
lsr w1, w0, #1
mov w2, #33994
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 19899u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #19899
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 7) % lego_v1_n]) * 44533u + 60u;
ldr w6, [sp, #20]
add w6, w6, #7
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w6, w8, w7, w6
ldr x9, [sp, #0]
sxtw x6, w6
ldr w10, [x9, x6, lsl #2]
eor w0, w0, w10
mov w11, #44533
mul w0, w0, w11
add w0, w0, #60
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 9) | (lego_v3_state >> 23);
lsl w1, w0, #9
lsr w2, w0, #23
orr w0, w1, w2
str w0, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s030_end:

# block r_s001_body_s001_body_s031_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
mov w2, #0x40000000
and w0, w0, w2
cmp w0, #0
cset w0, ne
    cbz w0, L_long_kernel_r_s001_body_s001_body_s031_else

# block r_s001_body_s001_body_s031_then_left
// lego_v3_state ^= (lego_v3_state >> 8) + 42846u;
ldr w8, [sp, #16]
lsr w9, w8, #8
mov w13, #42846
add w9, w9, w13
eor w8, w8, w9
str w8, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 33002u;
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #33002
mul w10, w10, w12
add w8, w8, w10
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 6) % lego_v1_n]) * 25565u + 33u;
ldr w10, [sp, #20]
add w10, w10, #6
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w12, w12, w11, w10
ldr x13, [sp, #0]
sxtw x12, w12
ldr w14, [x13, x12, lsl #2]
eor w8, w8, w14
mov w12, #25565
mul w8, w8, w12
add w8, w8, #33
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state << 8) | (lego_v3_state >> 24);
lsl w9, w8, #8
lsr w10, w8, #24
orr w8, w9, w10
str w8, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 4) + 3734u;
lsr w9, w8, #4
add w9, w9, #3734
eor w8, w8, w9
str w8, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 20318u;
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #20318
mul w10, w10, w12
add w8, w8, w10
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 3) % lego_v1_n]) * 58545u + 37u;
ldr w10, [sp, #20]
add w10, w10, #3
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w12, w12, w11, w10
ldr x13, [sp, #0]
sxtw x12, w12
ldr w14, [x13, x12, lsl #2]
eor w8, w8, w14
mov w12, #58545
mul w8, w8, w12
add w8, w8, #37
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state << 7) | (lego_v3_state >> 25);
lsl w9, w8, #7
lsr w10, w8, #25
orr w8, w9, w10
str w8, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 14) + 55012u;
lsr w9, w8, #14
mov w13, #55012
add w9, w9, w13
eor w8, w8, w9
str w8, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 15062u;
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #15062
mul w10, w10, w12
add w8, w8, w10
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 7) % lego_v1_n]) * 125u + 41u;
ldr w10, [sp, #20]
add w10, w10, #7
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w12, w12, w11, w10
ldr x13, [sp, #0]
sxtw x12, w12
ldr w14, [x13, x12, lsl #2]
eor w8, w8, w14
mov w12, #125
mul w8, w8, w12
add w8, w8, #41
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state << 8) | (lego_v3_state >> 24);
lsl w9, w8, #8
lsr w10, w8, #24
orr w8, w9, w10
str w8, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 14) + 48713u;
lsr w9, w8, #14
mov w13, #48713
add w9, w9, w13
eor w8, w8, w9
str w8, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 31002u;
ldr w10, [sp, #20]
ldr w11, [sp, #24]
add w10, w10, w11
mov w12, #31002
mul w10, w10, w12
add w8, w8, w10
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 1) % lego_v1_n]) * 2655u + 45u;
ldr w10, [sp, #20]
add w10, w10, #1
ldr w11, [sp, #8]
sdiv w12, w10, w11
msub w12, w12, w11, w10
ldr x13, [sp, #0]
sxtw x12, w12
ldr w14, [x13, x12, lsl #2]
eor w8, w8, w14
mov w12, #2655
mul w8, w8, w12
add w8, w8, #45
str w8, [sp, #16]
// lego_v3_state = (lego_v3_state << 11) | (lego_v3_state >> 21);
lsl w9, w8, #11
lsr w10, w8, #21
orr w8, w9, w10
str w8, [sp, #16]

# block r_s001_body_s001_body_s031_then_right
// lego_v3_state ^= (lego_v3_state >> 10) + 53043u;
ldr w0, [sp, #16]
lsr w1, w0, #10
mov w2, #53043
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 62346u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #62346
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 2) % lego_v1_n]) * 29435u + 49u;
ldr w6, [sp, #20]
add w6, w6, #2
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
ldr x9, [sp, #0]
sxtw x8, w8
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w11, #29435
mul w0, w0, w11
add w0, w0, #49
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 1) | (lego_v3_state >> 31);
lsl w1, w0, #1
lsr w2, w0, #31
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 12) + 24870u;
lsr w1, w0, #12
mov w2, #24870
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 64530u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #64530
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 2) % lego_v1_n]) * 28821u + 53u;
ldr w6, [sp, #20]
add w6, w6, #2
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
ldr x9, [sp, #0]
sxtw x8, w8
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w11, #28821
mul w0, w0, w11
add w0, w0, #53
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 6) | (lego_v3_state >> 26);
lsl w1, w0, #6
lsr w2, w0, #26
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 15) + 1520u;
lsr w1, w0, #15
mov w2, #1520
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 18224u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #18224
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 5) % lego_v1_n]) * 40567u + 57u;
ldr w6, [sp, #20]
add w6, w6, #5
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
ldr x9, [sp, #0]
sxtw x8, w8
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w11, #40567
mul w0, w0, w11
add w0, w0, #57
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 2) | (lego_v3_state >> 30);
lsl w1, w0, #2
lsr w2, w0, #30
orr w0, w1, w2
str w0, [sp, #16]
// lego_v3_state ^= (lego_v3_state >> 9) + 7449u;
lsr w1, w0, #9
mov w2, #7449
add w1, w1, w2
eor w0, w0, w1
str w0, [sp, #16]
// lego_v3_state += (unsigned int)(lego_v4_i + lego_v5_round) * 41883u;
ldr w3, [sp, #20]
ldr w4, [sp, #24]
add w3, w3, w4
mov w5, #41883
mul w3, w3, w5
add w0, w0, w3
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state ^ lego_v0_a[(lego_v4_i + 0) % lego_v1_n]) * 5483u + 61u;
ldr w6, [sp, #20]
ldr w7, [sp, #8]
sdiv w8, w6, w7
msub w8, w8, w7, w6
ldr x9, [sp, #0]
sxtw x8, w8
ldr w10, [x9, x8, lsl #2]
eor w0, w0, w10
mov w11, #5483
mul w0, w0, w11
add w0, w0, #61
str w0, [sp, #16]
// lego_v3_state = (lego_v3_state << 10) | (lego_v3_state >> 22);
lsl w1, w0, #10
lsr w2, w0, #22
orr w0, w1, w2
str w0, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s031_end
L_long_kernel_r_s001_body_s001_body_s031_else:

# block r_s001_body_s001_body_s031_else
ldr w8, [sp, #16]
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w11, w9, w10
mov w12, #28305
mul w11, w11, w12
add w8, w8, w11
ldr x0, [sp, #0]
ldr w1, [sp, #8]
add w13, w9, #2
sdiv w14, w13, w1
msub w14, w14, w1, w13
sxtw x14, w14
ldr w15, [x0, x14, lsl #2]
eor w8, w8, w15
mov w12, #43925
mul w8, w8, w12
add w8, w8, #32
lsl w11, w8, #9
lsr w13, w8, #23
orr w8, w11, w13
lsr w11, w8, #12
mov w12, #24174
add w11, w11, w12
eor w8, w8, w11
add w11, w9, w10
mov w12, #11310
mul w11, w11, w12
add w8, w8, w11
add w13, w9, #7
sdiv w14, w13, w1
msub w14, w14, w1, w13
sxtw x14, w14
ldr w15, [x0, x14, lsl #2]
eor w8, w8, w15
mov w12, #1415
mul w8, w8, w12
add w8, w8, #36
lsl w11, w8, #3
lsr w13, w8, #29
orr w8, w11, w13
lsr w11, w8, #9
mov w12, #13993
add w11, w11, w12
eor w8, w8, w11
add w11, w9, w10
mov w12, #46587
mul w11, w11, w12
add w8, w8, w11
add w13, w9, #2
sdiv w14, w13, w1
msub w14, w14, w1, w13
sxtw x14, w14
ldr w15, [x0, x14, lsl #2]
eor w8, w8, w15
mov w12, #63499
mul w8, w8, w12
add w8, w8, #40
lsl w11, w8, #1
lsr w13, w8, #31
orr w8, w11, w13
lsr w11, w8, #10
mov w12, #60027
add w11, w11, w12
eor w8, w8, w11
add w11, w9, w10
mov w12, #4485
mul w11, w11, w12
add w8, w8, w11
add w13, w9, #1
sdiv w14, w13, w1
msub w14, w14, w1, w13
sxtw x14, w14
ldr w15, [x0, x14, lsl #2]
eor w8, w8, w15
mov w12, #51419
mul w8, w8, w12
add w8, w8, #44
lsl w11, w8, #6
lsr w13, w8, #26
orr w8, w11, w13
lsr w11, w8, #15
mov w12, #31839
add w11, w11, w12
eor w8, w8, w11
add w11, w9, w10
mov w12, #26484
mul w11, w11, w12
add w8, w8, w11
add w13, w9, #5
sdiv w14, w13, w1
msub w14, w14, w1, w13
sxtw x14, w14
ldr w15, [x0, x14, lsl #2]
eor w8, w8, w15
mov w12, #27755
mul w8, w8, w12
add w8, w8, #48
lsl w11, w8, #15
lsr w13, w8, #17
orr w8, w11, w13
lsr w11, w8, #3
mov w12, #2014
add w11, w11, w12
eor w8, w8, w11
add w11, w9, w10
mov w12, #3748
mul w11, w11, w12
add w8, w8, w11
add w13, w9, #4
sdiv w14, w13, w1
msub w14, w14, w1, w13
sxtw x14, w14
ldr w15, [x0, x14, lsl #2]
eor w8, w8, w15
mov w12, #35609
mul w8, w8, w12
add w8, w8, #52
lsl w11, w8, #11
lsr w13, w8, #21
orr w8, w11, w13
lsr w11, w8, #5
mov w12, #29579
add w11, w11, w12
eor w8, w8, w11
add w11, w9, w10
mov w12, #2277
mul w11, w11, w12
add w8, w8, w11
add w13, w9, #2
sdiv w14, w13, w1
msub w14, w14, w1, w13
sxtw x14, w14
ldr w15, [x0, x14, lsl #2]
eor w8, w8, w15
mov w12, #27301
mul w8, w8, w12
add w8, w8, #56
lsl w11, w8, #11
lsr w13, w8, #21
orr w8, w11, w13
lsr w11, w8, #15
mov w12, #34843
add w11, w11, w12
eor w8, w8, w11
add w11, w9, w10
mov w12, #18157
mul w11, w11, w12
add w8, w8, w11
add w13, w9, #3
sdiv w14, w13, w1
msub w14, w14, w1, w13
sxtw x14, w14
ldr w15, [x0, x14, lsl #2]
eor w8, w8, w15
mov w12, #9585
mul w8, w8, w12
add w8, w8, #60
lsl w11, w8, #6
lsr w13, w8, #26
orr w8, w11, w13
lsr w11, w8, #14
mov w12, #63774
add w11, w11, w12
eor w8, w8, w11
str w8, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s031_end:

# block r_s001_body_s001_body_s032_condition
ldr w0, [sp, #16]
ldr w1, [sp, #12]
eor w0, w0, w1
and w0, w0, #1
    cbz w0, L_long_kernel_r_s001_body_s001_body_s032_else

# block r_s001_body_s001_body_s032_then
// load i, round, state
ldr w8, [sp, #20]
ldr w9, [sp, #24]
ldr w10, [sp, #16]
// (i+round) as unsigned
add w11, w8, w9
// --- block 1: offset +5, mult 4168, 59173? no: 4551u+33u ---
mov w12, #4168
mul w13, w11, w12
add w10, w10, w13
// index (i+5)%n
add w14, w8, #5
ldr w15, [sp, #8]
sdiv w0, w14, w15
mul w0, w0, w15
sub w0, w14, w0
ldr x1, [sp, #0]
ldr w2, [x1, w0, sxtw #2]
eor w10, w10, w2
mov w12, #4551
mul w10, w10, w12
add w10, w10, #33
// rotate left 8
ror w10, w10, #24
// state ^= (state>>9)+59915
lsr w2, w10, #9
mov w12, #59915
add w2, w2, w12
eor w10, w10, w2
// --- block 2: mult 37852, offset +0, 59173u+37u, rot14 (ror18), >>10 +52955 ---
mov w12, #37852
mul w13, w11, w12
add w10, w10, w13
add w14, w8, #0
ldr w15, [sp, #8]
sdiv w0, w14, w15
mul w0, w0, w15
sub w0, w14, w0
ldr x1, [sp, #0]
ldr w2, [x1, w0, sxtw #2]
eor w10, w10, w2
mov w12, #59173
mul w10, w10, w12
add w10, w10, #37
ror w10, w10, #18
lsr w2, w10, #10
mov w12, #52955
add w2, w2, w12
eor w10, w10, w2
// --- block 3: mult 48407, offset +4, 25845u+41u, rot13 (ror19), >>14 +48032 ---
mov w12, #48407
mul w13, w11, w12
add w10, w10, w13
add w14, w8, #4
ldr w15, [sp, #8]
sdiv w0, w14, w15
mul w0, w0, w15
sub w0, w14, w0
ldr x1, [sp, #0]
ldr w2, [x1, w0, sxtw #2]
eor w10, w10, w2
mov w12, #25845
mul w10, w10, w12
add w10, w10, #41
ror w10, w10, #19
lsr w2, w10, #14
mov w12, #48032
add w2, w2, w12
eor w10, w10, w2
// --- block 4: mult 9408, offset +3, 37847u+45u, rot9 (ror23), >>11 +9209 ---
mov w12, #9408
mul w13, w11, w12
add w10, w10, w13
add w14, w8, #3
ldr w15, [sp, #8]
sdiv w0, w14, w15
mul w0, w0, w15
sub w0, w14, w0
ldr x1, [sp, #0]
ldr w2, [x1, w0, sxtw #2]
eor w10, w10, w2
mov w12, #37847
mul w10, w10, w12
add w10, w10, #45
ror w10, w10, #23
lsr w2, w10, #11
mov w12, #9209
add w2, w2, w12
eor w10, w10, w2
// --- block 5: mult 63903, offset +1, 27013u+49u, rot1 (ror31), >>4 +14901 ---
mov w12, #63903
mul w13, w11, w12
add w10, w10, w13
add w14, w8, #1
ldr w15, [sp, #8]
sdiv w0, w14, w15
mul w0, w0, w15
sub w0, w14, w0
ldr x1, [sp, #0]
ldr w2, [x1, w0, sxtw #2]
eor w10, w10, w2
mov w12, #27013
mul w10, w10, w12
add w10, w10, #49
ror w10, w10, #31
lsr w2, w10, #4
mov w12, #14901
add w2, w2, w12
eor w10, w10, w2
// --- block 6: mult 46923, offset +2, 44905u+53u, rot5 (ror27), >>15 +37711 ---
mov w12, #46923
mul w13, w11, w12
add w10, w10, w13
add w14, w8, #2
ldr w15, [sp, #8]
sdiv w0, w14, w15
mul w0, w0, w15
sub w0, w14, w0
ldr x1, [sp, #0]
ldr w2, [x1, w0, sxtw #2]
eor w10, w10, w2
mov w12, #44905
mul w10, w10, w12
add w10, w10, #53
ror w10, w10, #27
lsr w2, w10, #15
mov w12, #37711
add w2, w2, w12
eor w10, w10, w2
// --- block 7: mult 40649, offset +7, 14413u+57u, rot2 (ror30), >>12 +22994 ---
mov w12, #40649
mul w13, w11, w12
add w10, w10, w13
add w14, w8, #7
ldr w15, [sp, #8]
sdiv w0, w14, w15
mul w0, w0, w15
sub w0, w14, w0
ldr x1, [sp, #0]
ldr w2, [x1, w0, sxtw #2]
eor w10, w10, w2
mov w12, #14413
mul w10, w10, w12
add w10, w10, #57
ror w10, w10, #30
lsr w2, w10, #12
mov w12, #22994
add w2, w2, w12
eor w10, w10, w2
// --- block 8: mult 36178, offset +6, 31679u+61u, rot4 (ror28), >>14 +29713 ---
mov w12, #36178
mul w13, w11, w12
add w10, w10, w13
add w14, w8, #6
ldr w15, [sp, #8]
sdiv w0, w14, w15
mul w0, w0, w15
sub w0, w14, w0
ldr x1, [sp, #0]
ldr w2, [x1, w0, sxtw #2]
eor w10, w10, w2
mov w12, #31679
mul w10, w10, w12
add w10, w10, #61
ror w10, w10, #28
lsr w2, w10, #14
mov w12, #29713
add w2, w2, w12
eor w10, w10, w2
// store state
str w10, [sp, #16]
    b L_long_kernel_r_s001_body_s001_body_s032_end
L_long_kernel_r_s001_body_s001_body_s032_else:

# block r_s001_body_s001_body_s032_else
// stage 1: index (i+1)%n
ldr w1, [sp, #20]
add w1, w1, #1
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
sxtw x3, w3
ldr x4, [sp, #0]
ldr w5, [x4, x3, lsl #2]
ldr w0, [sp, #16]
eor w0, w0, w5
mov w6, #30951
mul w0, w0, w6
add w0, w0, #32
ror w0, w0, #18
lsr w7, w0, #3
mov w8, #62050
add w7, w7, w8
eor w0, w0, w7
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #29928
mul w9, w9, w11
add w0, w0, w9
// stage 2: index (i+3)%n
ldr w1, [sp, #20]
add w1, w1, #3
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #18289
mul w0, w0, w6
add w0, w0, #36
ror w0, w0, #30
lsr w7, w0, #4
mov w8, #12664
add w7, w7, w8
eor w0, w0, w7
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #16954
mul w9, w9, w11
add w0, w0, w9
// stage 3: index (i+1)%n
ldr w1, [sp, #20]
add w1, w1, #1
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #49937
mul w0, w0, w6
add w0, w0, #40
ror w0, w0, #22
lsr w7, w0, #14
mov w8, #63782
add w7, w7, w8
eor w0, w0, w7
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #7522
mul w9, w9, w11
add w0, w0, w9
// stage 4: index (i+7)%n
ldr w1, [sp, #20]
add w1, w1, #7
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #26895
mul w0, w0, w6
add w0, w0, #44
ror w0, w0, #24
lsr w7, w0, #1
mov w8, #51470
add w7, w7, w8
eor w0, w0, w7
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #27675
mul w9, w9, w11
add w0, w0, w9
// stage 5: index (i+6)%n
ldr w1, [sp, #20]
add w1, w1, #6
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #17711
mul w0, w0, w6
add w0, w0, #48
ror w0, w0, #30
lsr w7, w0, #4
mov w8, #1693
add w7, w7, w8
eor w0, w0, w7
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #4853
mul w9, w9, w11
add w0, w0, w9
// stage 6: index (i+7)%n
ldr w1, [sp, #20]
add w1, w1, #7
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #7711
mul w0, w0, w6
add w0, w0, #52
ror w0, w0, #25
lsr w7, w0, #12
mov w8, #48343
add w7, w7, w8
eor w0, w0, w7
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #42287
mul w9, w9, w11
add w0, w0, w9
// stage 7: index (i+5)%n
ldr w1, [sp, #20]
add w1, w1, #5
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #505
mul w0, w0, w6
add w0, w0, #56
ror w0, w0, #28
lsr w7, w0, #3
mov w8, #40499
add w7, w7, w8
eor w0, w0, w7
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #37193
mul w9, w9, w11
add w0, w0, w9
// stage 8: index (i+2)%n
ldr w1, [sp, #20]
add w1, w1, #2
ldr w2, [sp, #8]
sdiv w3, w1, w2
msub w3, w3, w2, w1
sxtw x3, w3
ldr w5, [x4, x3, lsl #2]
eor w0, w0, w5
mov w6, #53761
mul w0, w0, w6
add w0, w0, #60
ror w0, w0, #25
lsr w7, w0, #6
mov w8, #55930
add w7, w7, w8
eor w0, w0, w7
ldr w9, [sp, #20]
ldr w10, [sp, #24]
add w9, w9, w10
mov w11, #63105
mul w9, w9, w11
add w0, w0, w9
// store state
str w0, [sp, #16]
L_long_kernel_r_s001_body_s001_body_s032_end:
    b L_long_kernel_r_s001_body_s001_cond
L_long_kernel_r_s001_body_s001_end:

# block r_s001_body_s002
ldr x0, [sp, #0]
ldrsw x1, [sp, #20]
ldr w2, [x0, x1, lsl #2]
ldr w3, [sp, #16]
eor w2, w2, w3
str w2, [x0, x1, lsl #2]
L_long_kernel_r_s001_increment:

# block r_s001_increment
ldr w0, [sp, #20]
add w0, w0, #1
str w0, [sp, #20]
    b L_long_kernel_r_s001_cond
L_long_kernel_r_s001_end:

# block r_s002
ldr w0, [sp, #16]
b L_long_kernel_return
L_long_kernel_return:
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    ret
