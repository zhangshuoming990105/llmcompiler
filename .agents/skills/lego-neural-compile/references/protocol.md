# Lowering protocol v2

The prepared plan is the public interface between deterministic frontend and
neural lowering. Its offsets are bytes. Bindings identify declarations, not
just names: shadowed variables have distinct names and stack slots.

Return only `{"blocks":[{"id":"b000","assembly":"..."}, ...]}`, containing
exactly the requested IDs in order. Each assembly string lowers that block's
entire `source`, including declarations, conditions, side effects, and returns.
An intact control structure may be kept, or recursively decomposed by the
controller following LEGO-Compiler Algorithm 2 and Appendix A. A retained
region can therefore be a whole loop, its body, one nested branch, or a basic
statement sequence. Follow the selected region's interface, not its original
top-level position.
An uninitialized declaration can have a comment-only fragment; do not read its
slot until C initializes it.

## State and control flow

- Use the supplied `bindings[].address`, sizes, and signed C types. Do not
  allocate another frame, rebind variables, eliminate a variable's stack slot,
  or assume a register is live on entry to a fragment.
- At every block exit/fallthrough, store all updated C variables in their slots.
  Locals declared by the block are initialized by that fragment, not entry code.
  Parameters are already stored by the scaffold.
- Define labels only under the block's `label_prefix`. Branch only to labels
  defined in that fragment, its explicit `allowed_targets`, or to
  `abi.return_label`. Lower C `return` by writing
  the correct result register and branching to that common return label.
- For `result: "boolean"`, `source` is a C condition expression, not a statement.
  Evaluate it exactly once, including short-circuiting and side effects, write
  0 or 1 to w0 (arm64) / EAX (x86), and fall through. The immediately following
  controller jump consumes that result. This is the sole temporary register
  interface across regions; other variables still use their assigned slots.
- `control_context` gives enclosing break/continue targets. A break or continue
  whose owning loop/switch is inside this region uses an internal label. A free
  break/continue targets the explicit enclosing label. For a split for-loop,
  continue targets its increment; for while/do-while it targets its condition.
  A switch owns break but does not replace an enclosing loop's continue target.
- Controller-generated C `goto` statements target only listed labels. Switch
  selection is evaluated once into a supplied temporary stack binding before
  comparisons are split; preserve case fall-through and default positioning.
- Use only `abi.scratch_registers`. No prologue/epilogue, stack adjustment,
  callee-saved register use, assembler directives, external includes, numeric
  labels, or final `ret` inside fragments. Put one instruction on each line.
- Caller-saved registers may hold temporary values *within* a block. A call
  invalidates their contents according to the ABI. Do not use additional stack
  scratch space outside the declared slots.

## Address and arithmetic facts

`address_facts` gives array element sizes and member offsets from the native C
implementation. Array indexing is `base + index * sizeof(element)`; preserve
the C index signedness when widening. Struct array stride is `sizeof(struct)`,
including tail padding. Member offsets are relative to the selected record.
Keep pointer width, integer width, signed comparison/division, and integer
promotion rules distinct. A byte load used as signed `char` may need extension;
a pointer load never uses a 32-bit register.

For arm64/macOS: use Apple AArch64 assembler syntax, `//` comments, `w0`/`x0`
for integer results and `s0`/`d0` for floating results. Stack slots are relative
to SP after the controller allocates its 16-byte-aligned frame. x18 and x19-x30
are unavailable. Use `b <return_label>` for return. No paired loads/stores in
fragments. Use ordinary loads/stores or unscaled forms as required by offsets.

For x86-64: use AT&T syntax and explicit operand widths. Slots are negative
offsets from RBP. Use EAX/RAX or XMM0 for results and `jmp <return_label>`.
The frame is allocated before fragments, and stack alignment is preserved.

If the supplied contract cannot express a function, do not manufacture a
successful-looking result. Report the limitation to the controller/operator;
a nonconforming response is a failed trial and remains visible.
