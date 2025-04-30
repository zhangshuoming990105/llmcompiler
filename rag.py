# put rag knowledge in this file
# to assist the neural compilation process

knowledge = {
    "global_variable": """When accessing global variables in x86-64 assembly, always use RIP-relative addressing (e.g., symbol(%rip) or load the address with leaq symbol(%rip), %reg) instead of direct symbol-based addressing. This ensures compatibility with position-independent executables and avoids relocation errors during linking.
Example below:
Declare first:

.data
    .align 4
x:
    .zero   8
Incorrect access:

movl    $0, x(,%rcx,4)    # Error: not RIP-relative
Correct access:

leaq    x(%rip), %rdx
movl    $0, (%rdx,%rcx,4)       # Proper RIP-relative access
Additional warning, be careful about register usage, do not clobber the register used to load the address of the global variable.""",
    "float_double": """Always place floating-point constants in the data section and load them using their labels and the appropriate addressing mode—never use literals (like -1.0 or 100.0) directly as operands in x86-64 floating-point instructions.

Example Correction:
Incorrect:

movsd   -1.0, %xmm0         # Invalid!
Correct:

.data
.LC_neg_one:
    .double -1.0

.text
movsd   .LC_neg_one(%rip), %xmm0   # Valid way to load -1.0""",
    "operand_num": """Be careful of the number of operands in the instruction, some instructions doesn't allow all operands being memory operands, for example, cmp instruction doesn't allow two memory operands or immediate operands, consider using a register to hold one of the operands first.""",
    "base_index_expression": """invalid base/index expression, Example like `-8(%rbp,%eax)', the base and index register should be the same size, otherwise, use simpler separate instructions to achieve the same effect.""",
    "jump_table": """When implementing switch-case jump tables, always place the table (array of label addresses or offsets) in the .rodata or .data section and reference its address using RIP-relative addressing (e.g., leaq switch_table(%rip), %reg). Before performing an indirect jump, load the table's address into a register and then index into the table via this register (e.g., jmp *(%reg, %index, 8)). Never jump directly to an absolute label (e.g., jmp *table(,%rax,8)) as this is not safe for position-independent executables (PIE) and will cause relocation errors.
Hint:
Name your jump table with a clear and descriptive label, such as .L_JT0, to improve code readability and maintainability. Example usage:

leaq    .L_JT0(%rip), %rdx
jmp     *(%rdx,%rax,8)
.section .rodata # jump table, in rodata section
.align 4
.L_JT0:
    .long .Lxx-.Lxx # specific entry
    ...
.text   # after the jump table, back to instructions, in text section
""",

}