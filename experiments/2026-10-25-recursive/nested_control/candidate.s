.text
.p2align 2
.globl _nested_flow
_nested_flow:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #32
    str w0, [sp, #0]
    str x1, [sp, #8]

# block r_s000
mov w8, #0
str w8, [sp, #16]

# block r_s001_init
mov w0, #0
str w0, [sp, #20]
L_nested_flow_r_s001_cond:

# block r_s001_condition
ldr w1, [sp, #20]
ldr w2, [sp, #0]
cmp w1, w2
cset w0, lt
    cbz w0, L_nested_flow_r_s001_end

# block r_s001_body_s000_condition
ldr w8, [sp, #20]
mov w9, #3
sdiv w10, w8, w9
mul w10, w10, w9
sub w8, w8, w10
cmp w8, #0
cset w0, eq
    cbz w0, L_nested_flow_r_s001_body_s000_end

# block r_s001_body_s000_then
b L_nested_flow_r_s001_increment
L_nested_flow_r_s001_body_s000_end:

# block r_s001_body_s001
mov w0, #0
str w0, [sp, #24]
L_nested_flow_r_s001_body_s002_cond:

# block r_s001_body_s002_condition
ldr w0, [sp, #24]
cmp w0, #4
cset w0, lt
    cbz w0, L_nested_flow_r_s001_body_s002_end

# block r_s001_body_s002_body_s000
ldr w0, [sp, #24]
add w0, w0, #1
str w0, [sp, #24]

# block r_s001_body_s002_body_s001_value
ldr x0, [sp, #8]
ldr w1, [sp, #20]
sxtw x1, w1
ldr w2, [x0, x1, lsl #2]
ldr w3, [sp, #24]
add w2, w2, w3
and w2, w2, #3
str w2, [sp, #28]

# block r_s001_body_s002_body_s001_casecmp0_condition
ldr w8, [sp, #28]
cmp w8, #0
cset w0, eq
    cbnz w0, L_nested_flow_r_s001_body_s002_body_s001_case0

# block r_s001_body_s002_body_s001_casecmp1_condition
ldr w0, [sp, #28]
cmp w0, #1
cset w0, eq
    cbnz w0, L_nested_flow_r_s001_body_s002_body_s001_case1

# block r_s001_body_s002_body_s001_casecmp2_condition
ldr w8, [sp, #28]
cmp w8, #2
cset w0, eq
    cbnz w0, L_nested_flow_r_s001_body_s002_body_s001_case2
    b L_nested_flow_r_s001_body_s002_body_s001_default
L_nested_flow_r_s001_body_s002_body_s001_case0:

# block r_s001_body_s002_body_s001_casebody0
ldr w0, [sp, #16]
ldr w1, [sp, #24]
add w0, w0, w1
str w0, [sp, #16]

# block r_s001_body_s002_body_s001_casebody1
b L_nested_flow_r_s001_body_s002_body_s001_end
L_nested_flow_r_s001_body_s002_body_s001_case1:

# block r_s001_body_s002_body_s001_casebody2_condition
ldr w0, [sp, #24]
cmp w0, #2
cset w0, eq
    cbz w0, L_nested_flow_r_s001_body_s002_body_s001_casebody2_end

# block r_s001_body_s002_body_s001_casebody2_then
b L_nested_flow_r_s001_body_s002_cond
L_nested_flow_r_s001_body_s002_body_s001_casebody2_end:

# block r_s001_body_s002_body_s001_casebody3
ldr w0, [sp, #16]
ldr w1, [sp, #20]
sub w0, w0, w1
str w0, [sp, #16]
L_nested_flow_r_s001_body_s002_body_s001_case2:

# block r_s001_body_s002_body_s001_casebody4
ldr w0, [sp, #16]
add w0, w0, #3
str w0, [sp, #16]

# block r_s001_body_s002_body_s001_casebody5
b L_nested_flow_r_s001_body_s002_body_s001_end
L_nested_flow_r_s001_body_s002_body_s001_default:

# block r_s001_body_s002_body_s001_casebody6
ldr x0, [sp, #8]
ldr w1, [sp, #20]
sxtw x1, w1
ldr w2, [x0, x1, lsl #2]
ldr w3, [sp, #16]
add w3, w3, w2
str w3, [sp, #16]
L_nested_flow_r_s001_body_s002_body_s001_end:

# block r_s001_body_s002_body_s002_condition
ldr w0, [sp, #16]
cmp w0, #200
cset w0, gt
    cbz w0, L_nested_flow_r_s001_body_s002_body_s002_end

# block r_s001_body_s002_body_s002_then
b L_nested_flow_r_s001_body_s002_end
L_nested_flow_r_s001_body_s002_body_s002_end:
    b L_nested_flow_r_s001_body_s002_cond
L_nested_flow_r_s001_body_s002_end:
L_nested_flow_r_s001_body_s003_body:

# block r_s001_body_s003_body_s000
ldr w0, [sp, #16]
sub w0, w0, #1
str w0, [sp, #16]

# block r_s001_body_s003_body_s001_condition
ldr w8, [sp, #16]
mov w9, #5
sdiv w10, w8, w9
mul w10, w10, w9
sub w8, w8, w10
cmp w8, #0
cset w0, eq
    cbz w0, L_nested_flow_r_s001_body_s003_body_s001_end

# block r_s001_body_s003_body_s001_then
b L_nested_flow_r_s001_body_s003_end
L_nested_flow_r_s001_body_s003_body_s001_end:
L_nested_flow_r_s001_body_s003_cond:

# block r_s001_body_s003_condition
ldr w0, [sp, #16]
cmp w0, #100
cset w0, gt
    cbnz w0, L_nested_flow_r_s001_body_s003_body
L_nested_flow_r_s001_body_s003_end:

# block r_s001_body_s004_condition
ldr w8, [sp, #16]
cmn w8, #100
cset w0, lt
    cbz w0, L_nested_flow_r_s001_body_s004_end

# block r_s001_body_s004_then
ldr w0, [sp, #16]
b L_nested_flow_return
L_nested_flow_r_s001_body_s004_end:
L_nested_flow_r_s001_increment:

# block r_s001_increment
ldr w0, [sp, #20]
add w0, w0, #1
str w0, [sp, #20]
    b L_nested_flow_r_s001_cond
L_nested_flow_r_s001_end:

# block r_s002
ldr w0, [sp, #16]
b L_nested_flow_return
L_nested_flow_return:
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    ret
