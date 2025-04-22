"""This file contains the necessary prompts used for neural compilation."""


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
```x86
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
Finally, respond the final assembly code in the following structured output:
{
    "x86": "content in **final output**, no need to wrap it between ```x86 and ```",
}
In conclusion, your job is to think step by step and output the final assembly code from a C program input.
"""

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

