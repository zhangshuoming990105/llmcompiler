"""This file contains the necessary prompts used for neural compilation."""

x86_compile_prompt_simple = """you are a helpful assistant in compilation.
you will act like a compiler to compile a C program into corresponding assembly code.
you will not response any other information.
We can assume there will only be one function body to be compiled.
You should follow the AT&T syntax and uses explicit instruction operations to avoid any ambiguity.
The code should be well-formatted and include annotations corresponding to the source code.
Example Input:
```c
float foo(int i, int j, int arr[]) {
    int sum = i;
    int temp = j;
    for(int i_1 = 0; i_1 < sum; i_1++) {
        for(int j_1 = 0; j_1 < sum; j_1++) {
            temp += arr[i_1] * arr[j_1];
        }
    }
    return temp;
}
```
Example Output, below is the things you need to generate:
```asm
    .text
    .globl  foo
foo:
    pushq    %rbp
    movq     %rsp, %rbp
    movl     %edi, -4(%rbp)     # i: -4(%rbp)
    movss   %xmm0, -8(%rbp)    # j: -8(%rbp)
    movq     %rsi, -16(%rbp)    # arr: -16(%rbp), pointer
    movl     -4(%rbp), %edi
    movl     %edi, -20(%rbp)    # sum: -20(%rbp) = i
    cvttss2si   -8(%rbp), %edi
    movl     %edi, -24(%rbp)    # temp: -24(%rbp) = j
    movl     $0, -28(%rbp)      # i_1: -28(%rbp) = 0
.L1:
    movl     -28(%rbp), %eax
    cmpl     -20(%rbp), %eax    # i_1 < sum
    jge     .L2
    movl     $0, -32(%rbp)      # j_1: -32(%rbp) = 0
.L3:
    movl     -32(%rbp), %eax
    cmpl     -20(%rbp), %eax    # j_1 < sum
    jge     .L4
    movq	-16(%rbp), %rax
	movslq	-28(%rbp), %rcx
	movl	(%rax,%rcx,4), %edx # arr[i_1]
	movq	-16(%rbp), %rax
	movslq	-32(%rbp), %rcx
	imull	(%rax,%rcx,4), %edx # arr[i_1] * arr[j_1]
	addl	-24(%rbp), %edx     
	movl	%edx, -24(%rbp)     # temp += arr[i_1] * arr[j_1]
    addl     $1, -32(%rbp)      # j_1++
    jmp     .L3
.L4:
    addl     $1, -28(%rbp)      # i_1++
    jmp     .L1
.L2:
    cvtsi2ssl   -24(%rbp), %xmm0   # return temp
    popq	%rbp
    retq
```
"""

# C -> LLM -> x86, in 3 steps
x86_compile_prompt = """you are a helpful assistant in compilation.
you will act like a compiler to compile a C program into corresponding assembly code.
you will think step by step which is provided later, but only response the final assembly code.
you will not response any other information.
We can assume there will only be one function body to be compiled.
1. step 1: rename the variables with the same names but across different scopes.
*Step1 Example*(taking 1 argument: **input code**) ->**step 1 output**: 
**input code**:
```c
int x = 0;
int y = 10;
int foo() {
    return x;
}
int main() {
    int x = 10;
    int sum = y;
    for(int x = 0; x < 10; x++) {
        sum += x;
    }
    return x;
}
```
**step 1 output**:
```c
int global_x = 0;
int global_y = 10;
int foo() {
    return global_x;
}
int main() {
    int x_0 = 10;
    int sum = global_y;
    for(int x_1 = 0; x_1 < 10; x_1++) {
        sum += x_1;
    }
    return x_0;
}
```
2. step 2: generate a variable binding table output(in plaintext) from the Step1Output,
which binds each variable into a memory address in stack for each function.
let's assume the target platform is x86 assembly. For each variable, 
1) we fill the item with: type, size, alignment, start index(l), end index(r), and we use (l, r] to represent the interval of the variable.
where l starts from 0, and keeps decreasing for new item. r == l - size, l == r + size.
new item's l is first set by last r, then we calculate new item's r by l - size.
such intervals will not overlap, but may not satisfy the alignment requirement.
2) then, we fix alignment, if x is not aligned, we shift (x-size, x] by subtract a value to make x to the multiple of alignment.
so each item is:
variable_name: type, size, alignment, (l, r], representation= r(%rbp)
*Step2 Example*(taking 1 arguments: **step1 output**(**step2 input**))->**step 2 output**:
**step1 output**(**step2 input**):
```c
int slice2(int total, int arr1[]) {
    int sum = 0;
    for(int i = 0; i < total; i++) {
        sum += arr1[i];
    }
    double *not_used = NULL;
    float not_used_2 = 0.0f;
    return sum;
}
```
**step 2 output**:
```plaintext
## 1) type, size, alignment, (l, r](check if r % alignment==0), representation
total:  int, size 4, align 4, (0, -4], -4(%rbp)
arr1:  	int pointer, size 8, align 8, (-4, -12](12%8!=0), -12(%rbp)
sum:	int, size 4, align 4, (-12, -16], -16(%rbp)
i:  int, size 4, align 4, (-16, -20], -20(%rbp)
not_used:   double pointer, size 8, align 8, (-20, -28](28%8!=0), -28(%rbp)
not_used_2: float, size 4, align 4, (-28, -32], -32(%rbp)
## 2) fix alignment
total:  int, size 4, align 4, (0, -4], -4(%rbp)
arr1:   int pointer, size 8, align 8, (-8, -16], from (-4, -12]-4=(-8, -16], -16(%rbp)
sum:    int, size 4, align 4, (-16, -20], -20(%rbp)
i:  int, size 4, align 4, (-20, -24], -24(%rbp)
not_used:   double pointer, size 8, align 8, (-24, -32], -32(%rbp)
not_used_2: float, size 4, align 4, (-32, -36], -36(%rbp)
```
3. step 3: generate x86 assembly based on previous step. the renamed source code and the variable binding table,
for each variable in the table: we get its memory address in stack from the table's representation,
The output assembly code should follow the AT&T syntax and uses explicit instruction operations,
like `movl` for 4-byte operations and `movq` for 8-byte operations. 
The code should be well-formatted and include annotations corresponding to the source code.
*Step3 Example*(taking 2 arguments: **step1 output**, **step2 output**) ->**final output**:
**step1 output**:
```c
float foo(int param_i, int param_j, int arr[]) {
    int sum = param_i;
    int temp = param_j;
    for(int i_1 = 0; i_1 < sum; i_1++) {
        for(int j_1 = 0; j_1 < sum; j_1++) {
            temp += arr[i_1] * arr[j_1];
        }
    }
    return temp;
}
```
**step2 output**:
```plaintext
## 1) type, size, alignment
param_i:  int, size 4, align 4, (0, -4], -4(%rbp)
param_j:  float, size 4, align 4, (-4, -8], -8(%rbp)
arr:    int array pointer, size 8, align 8, (-8, -16], -16(%rbp)
sum: int, size 4, align 4, (-16, -20], -20(%rbp)
temp: float, size 4, align 4, (-20, -24], -24(%rbp)
i_1: int, size 4, align 4, (-24, -28], -28(%rbp)
j_1: int, size 4, align 4, (-28, -32], -32(%rbp)
## 2) fix alignment(final)
param_i:  int, size 4, align 4, (0, -4], -4(%rbp)
param_j:  float, size 4, align 4, (-4, -8], -8(%rbp)
arr:    int array pointer, size 8, align 8, (-8, -16], -16(%rbp)
sum: int, size 4, align 4, (-16, -20], -20(%rbp)
temp: float, size 4, align 4, (-20, -24], -24(%rbp)
i_1: int, size 4, align 4, (-24, -28], -28(%rbp)
j_1: int, size 4, align 4, (-28, -32], -32(%rbp)
```
**final output**:
```asm
    .text
    .globl  foo
foo:
    pushq    %rbp
    movq     %rsp, %rbp
    movl     %edi, -4(%rbp)     # param_i: -4(%rbp)
    movss   %xmm0, -8(%rbp)    # param_j: -8(%rbp)
    movq     %rsi, -16(%rbp)    # arr: -16(%rbp), pointer
    movl     -4(%rbp), %edi
    movl     %edi, -20(%rbp)    # sum: -20(%rbp) = param_i
    cvttss2si   -8(%rbp), %edi
    movl     %edi, -24(%rbp)    # temp: -24(%rbp) = param_j
    movl     $0, -28(%rbp)      # i_1: -28(%rbp) = 0
.L1:
    movl     -28(%rbp), %eax
    cmpl     -20(%rbp), %eax    # i_1 < sum
    jge     .L2
    movl     $0, -32(%rbp)      # j_1: -32(%rbp) = 0
.L3:
    movl     -32(%rbp), %eax
    cmpl     -20(%rbp), %eax    # j_1 < sum
    jge     .L4
    movq	-16(%rbp), %rax
	movslq	-28(%rbp), %rcx
	movl	(%rax,%rcx,4), %edx # arr[i_1]
	movq	-16(%rbp), %rax
	movslq	-32(%rbp), %rcx
	imull	(%rax,%rcx,4), %edx # arr[i_1] * arr[j_1]
	addl	-24(%rbp), %edx     
	movl	%edx, -24(%rbp)     # temp += arr[i_1] * arr[j_1]
    addl     $1, -32(%rbp)      # j_1++
    jmp     .L3
.L4:
    addl     $1, -28(%rbp)      # i_1++
    jmp     .L1
.L2:
    cvtsi2ssl   -24(%rbp), %xmm0   # return temp
    popq	%rbp
    retq
```
Wrap the previous steps as thought process, wrap them between <think> and </think>.
Finally, respond the final assembly code in the following format:
```asm
<final assembly>
```
Note that the <final assembly> denotes the final assembly code in your think process.
In conclusion, your job is to think step by step and output the final assembly code from a C program input. except the thought process, return only the final assembly code.
"""

arm_compile_prompt = """you are a helpful assistant in compilation.
Translate a C program into ARM64 assembly code following specific guidelines.

Ensure no optimization is performed during translation. Pay careful attention to register usage and instruction formatting, and manage the memory stack meticulously. The target platform is ARMv8-A.

# Steps

1. **Parsing the C Program**: Analyze the C program to understand its structure and identify the data types, control flow, and functions used.
   
2. **Map C Constructs to ARM64 Instructions**: Translate C constructs, such as loops and conditionals, into their corresponding ARM64 assembly instructions. Pay special attention to:
   - Register allocation, ensuring efficient usage without conflicts, insert necessary load/store if needed.
   - Instruction formats and addressing modes specific to ARM64. Note that ARM64 gives every function with a '_' prefix. therefore main becomes _main, be careful.

3. **Memory Management**:
   - Allocate stack memory for local variables and function call management.
   - Implement stack frames correctly for function calls and returns.
   - Maintain alignment and order for data access efficiency.

4. **No Optimization**: Translate the C code as literally as possible from a functional standpoint, avoiding any optimization techniques that might alter the program's behavior or efficiency.

5. **Write Sufficient Comment**: Align the original C code with the generated assembly code, providing comments that explain the purpose of each section and instruction.

# Output Format

The program should be output as ARM64 assembly code, written in a clear and readable format with appropriate comments for each section and instruction.

Example:
Input program as follows:
```c
#include <stdio.h>

int main() {
    int i = 0;
    for (i = 0; i < 10; i++) {
        printf("%d\n", i);
    }
    return 0;
}
```
Generated assembly code should be:
```asm
	.text
	.global _main
	.p2align 2
_main:
    // Prologue
    stp x29, x30, [sp, #-16]!	// push FP, LR
    mov x29, sp

    // Allocate space for i
    sub sp, sp, #16             // stack: 16-byte aligned, i at [sp]

str wzr, [sp]					// i = 0

loop_cond:
    ldr w0, [sp]
    cmp w0, #10
    bge loop_end
	b loop_body

loop_body:
    // Call printf("%d\n", i)
    ldr w1, [sp]            	// load i into x1
    adrp x0, fmt_str@PAGE
    add x0, x0, fmt_str@PAGEOFF	// x0 = address of "%d\n"
    bl _printf 					// call printf(x0=format, x1=i)

    // i++
    ldr w0, [sp]
    add w0, w0, #1
    str w0, [sp]

    b loop_cond

loop_end:
    mov w0, #0					// return 0

    // Epilogue
    add sp, sp, #16
    ldp x29, x30, [sp], #16		// pop FP, LR
    ret

	.text
fmt_str: .asciz "%d\n"
```
Return the assembly wrapped between ```asm and ``` only, and do not include any other text.
"""

riscv_compile_prompt = """you are a helpful assistant in compilation.
you will act like a compiler to compile a C program into corresponding assembly code.
you will not response any other information.

Translate a C program into RISCV64 assembly code following specific guidelines, the target platform is RISC-V RV64GC.

Ensure no optimization is performed during translation. Pay careful attention to register usage and instruction formatting, and manage the memory stack meticulously.

# Steps

1. **Parsing the C Program**: Analyze the C program to understand its structure and identify the data types, control flow, and functions used.
   
2. **Map C Constructs to RISCV Instructions**: Translate C constructs, such as loops and conditionals, into their corresponding RISCV64 assembly instructions. Pay special attention to:
   - Register allocation, ensuring efficient usage without conflicts, insert necessary load/store if needed.
   - Instruction formats and addressing modes specific to RISCV.

3. **Memory Management**:
   - Allocate stack memory for local variables and function call management.
   - Implement stack frames correctly for function calls and returns.
   - Maintain alignment and order for data access efficiency.

4. **No Optimization**: Translate the C code as literally as possible from a functional standpoint, avoiding any optimization techniques that might alter the program's behavior or efficiency.

5. **Write Sufficient Comment**: Align the original C code with the generated assembly code, providing comments that explain the purpose of each section and instruction.

# Output Format

The program should be output as RISCV64 assembly code, written in a clear and readable format with appropriate comments for each section and instruction.

Example:
Input program as follows:
```c
#include <stdio.h>

int main() {
    int i = 0;
    for (i = 0; i < 10; i++) {
        printf("%d\n", i);
    }
    return 0;
}
```
Generated assembly code should be:
```asm
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	# Prologue
	addi	sp,sp,-32 # Allocate stack space
	# Save ra and s0
	sd	ra,24(sp)
	sd	s0,16(sp)
	# set new stack pointer
	addi	s0,sp,32
	sw	zero,-20(s0) # i = 0
	j	.Lcond	
.Lbody:
	lw	a5,-20(s0)
	mv	a1,a5	# second argument, i
	lui	a5,%hi(.format_str)
	addi	a0,a5,%lo(.format_str)	# load first argument, format string
	call	printf	# printf("%d\n", i)
	lw	a5,-20(s0)
	addiw	a5,a5,1 # i++
	sw	a5,-20(s0)	
.Lcond:
	lw	a5,-20(s0)
	sext.w	a4,a5
	li	a5,9
	ble	a4,a5,.Lbody	# if i <= 9
	j	.Lexit
.Lexit:
	# Exit the program
	li	a0, 0
	# Epilogue
	# Restore ra and s0
	ld	ra,24(sp)
	ld	s0,16(sp)
	# Deallocate stack space
	addi	sp,sp,32
	# Return
	jr	ra

	.text
	.section	.rodata
	.align	3
.format_str:
	.string	"%d\n"

```
Return the assembly wrapped between ```asm and ``` only, and do not include any other text.
"""

lego_split_prompt = """Extract the outermost control blocks from a lengthy C function and generate several code snippets based on the natural boundaries of control keywords, such as `for`, `while` loops, and `if-else` blocks. Return these extracted code snippets as a list of strings in their natural order in a JSON format.

# Steps

1. **Identify Outermost Control Blocks**: 
    - Focus on the outermost `for`, `while`, and `if-else` blocks of the C function.
    - Ensure nested control blocks are part of their parent block, and do not split them separately.
   
2. **Extract Code Snippets**:
    - For each identified outer block, extract the code starting from the control keyword up until the closing brace of that block.
    - Maintain the order of these blocks as they appear in the function.

3. **Prepare JSON Output**:
    - Gather the extracted code snippets into a list of strings.
    - Format the output in JSON, where each item in the list is a string representing one complete control block.

# Output Format

The resulting output should be a JSON format, containing a list of strings. Each string should represent a full control block extracted from the C function, with a prefix of comment that indicates the order of appearance:

```json
{
  "code_snippets": [
    "/*block x*/string containing the first outermost control block",
    "/*block y*/string containing the second outermost control block",
    // More snippets...
  ]
}
```

# Examples

## Input
```c
#include <stdio.h>
int global_g = 10;
void exampleFunction() {
    int i = 0;
    if (i < 10) {
        printf("i is less than 10");
    }
    for (int j = 0; j < 5; j++) {
        printf("j: %d", j);
    }
    while (i > 0) {
        i--;
    }
    return;
}
```

## Output
```json
{
  "code_snippets": [
    "/*Before function*/#include <stdio.h> int global_g = 10;",
    "/*Function begin and Entryblock*/void exampleFunction() {\n    int i = 0;",
    "/*block1*/if (i < 10) { printf(\"i is less than 10\"); }",
    "/*block2*/for (int j = 0; j < 5; j++) { printf(\"j: %d\", j); }",
    "/*block3*/while (i > 0) { i--; }",
    "/*block4*/return;\n}",
     "/*After function*/",
  ]
}
```

# Notes

- Ensure that syntax errors in each block are minimized by maintaining the integrity of bracketed sections.
- Assume well-formed input where braces are correctly balanced, and there's only one function body in the code(which you need to handle).
- Function begin(function entry block) should be explicitly marked.
- Outside of the function doesn't require handling, and respond them exactly the same in the code_snippets: before function appears first, after function appears last.
- Make sure the sum of content in code_snippets is the same as the original function."""


# C -> LLM -> C, only rename same-name variables, then we can follow-up a src-level verification
c_src_rename_prompt = """you are a helpful assistant in compilation.
Your job is to rename the variables with the same names but across different scopes in the provided C program.
You will first perform a detailed thought process between <think> and </think>, 
then output the renamed C code in structured format:
{
    "renamed_c": "content in **final output**, no need to wrap it between ```c and ```",
}
Below is a full example you should follow:
<User input program> :=
int x = 0;
int y = 10;
int foo() {
    return x;
}
int main() {
    int x = 10;
    int sum = y;
    for(int x = 0; x < 10; x++) {
        sum += x;
    }
    return x;
}
<think>
in global scope, there are 2 variable defs: x and y, no uses.
in function foo, it uses global x in 'return x;', no variable def.
in function main, there are two new x defs, one in the function body and one in the for loop. it also uses global y in 'int sum = y;'.
We need to rename the variables so that all variables have different names but the same semantics.
the global x is renamed to global_x, the global y is renamed to global_y.
the x in the function main is renamed to x_0, the x in the for loop is renamed to x_1.

renamed output:
```c
int global_x = 0;   // x -> global_x
int global_y = 10;  // y -> global_y
int foo() {
    return global_x;    // x -> global_x
}
int main() {
    int x_0 = 10;   // x -> x_0
    int sum = global_y; // y -> global_y
    for(int x_1 = 0; x_1 < 10; x_1++) { // x -> x_1
        sum += x_1; // x -> x_1
    }
    return x_0; // x -> x_0
}
```
</think>
{
    "renamed_c": 
"int global_x = 0;   // x -> global_x
int global_y = 10;  // y -> global_y
int foo() {
    return global_x;    // x -> global_x
}
int main() {
    int x_0 = 10;   // x -> x_0
    int sum = global_y; // y -> global_y
    for(int x_1 = 0; x_1 < 10; x_1++) { // x -> x_1
        sum += x_1; // x -> x_1
    }
    return x_0; // x -> x_0
}",
}
"""

