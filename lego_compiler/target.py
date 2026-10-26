"""Native ABI contracts and deterministic entry/exit scaffolding."""

import platform
import re


def native_target():
    system, arch = platform.system(), platform.machine().lower()
    if system == "Darwin" and arch == "arm64":
        return "arm64-macos"
    if arch in ("x86_64", "amd64") and system in ("Linux", "Darwin"):
        return "x86_64-linux" if system == "Linux" else "x86_64-macos"
    raise ValueError(f"Unsupported native target: {system}/{arch}")


def symbol(name, target):
    return "_" + name if target.endswith("macos") else name


def scalar_kind(ctype):
    if "*" in ctype:
        return "integer"
    clean = re.sub(r"\b(const|volatile|restrict)\b", "", ctype).strip()
    if clean in ("float", "double"):
        return clean
    if re.fullmatch(
        r"(?:(?:unsigned|signed) )?(?:char|short|int|long|long long|short int|long int|long long int)|_Bool",
        clean,
    ):
        return "integer"
    raise ValueError(f"ABI only supports scalar parameters/returns, got {ctype}")


def contract(target, function, bindings, frame_size):
    arm = target == "arm64-macos"
    if frame_size > (4095 if arm else 32768):
        raise ValueError("Frame exceeds the supported scaffold size")
    integer, floating = 0, 0
    x86_args = ["rdi", "rsi", "rdx", "rcx", "r8", "r9"]
    for binding in bindings:
        if binding["role"] != "parameter":
            continue
        kind = scalar_kind(binding["c_type"])
        if kind in ("float", "double"):
            if floating >= 8:
                raise ValueError("Stack-passed parameters are not supported yet")
            binding["incoming"] = (
                ("s" if kind == "float" else "d") + str(floating) if arm else f"xmm{floating}"
            )
            floating += 1
        else:
            if integer >= (8 if arm else 6):
                raise ValueError("Stack-passed parameters are not supported yet")
            binding["incoming"] = (
                ("x" if binding["size"] == 8 else "w") + str(integer) if arm else x86_args[integer]
            )
            integer += 1
    return {
        "target": target,
        "symbol": symbol(function, target),
        "stack_base": "sp" if arm else "rbp",
        "frame_size": frame_size,
        "return_label": f"L_{function}_return",
        "scratch_registers": "x0-x15, v0-v7, v16-v31"
        if arm
        else "rax, rcx, rdx, rsi, rdi, r8-r11, xmm0-xmm15",
        "boundary_rule": "Every C variable lives in its assigned stack slot at boundaries. Only an explicitly declared boolean result may feed the immediately following controller branch.",
        "return_rule": "Put the C return value in the ABI result register and branch to return_label; never emit ret in a fragment.",
        "calls": "Preserve live caller-saved temporaries across calls. The scaffold keeps SP 16-byte aligned.",
    }


def x86_register(register, size):
    names = {
        "rdi": ("dil", "di", "edi", "rdi"),
        "rsi": ("sil", "si", "esi", "rsi"),
        "rdx": ("dl", "dx", "edx", "rdx"),
        "rcx": ("cl", "cx", "ecx", "rcx"),
        "r8": ("r8b", "r8w", "r8d", "r8"),
        "r9": ("r9b", "r9w", "r9d", "r9"),
    }
    return names[register][{1: 0, 2: 1, 4: 2, 8: 3}[size]]


def scaffold(plan, fragments, source_map=None):
    abi = plan["abi"]
    frame = abi["frame_size"]
    arm = abi["target"] == "arm64-macos"
    lines = [
        ".text",
        ".p2align 2" if arm else ".p2align 4",
        f".globl {abi['symbol']}",
        f"{abi['symbol']}:",
    ]
    if arm:
        lines += ["    stp x29, x30, [sp, #-16]!", "    mov x29, sp"]
        if frame:
            lines += [f"    sub sp, sp, #{frame}"]
    else:
        lines += ["    pushq %rbp", "    movq %rsp, %rbp"]
        if frame:
            lines += [f"    subq ${frame}, %rsp"]
    for binding in plan["bindings"]:
        if binding["role"] != "parameter":
            continue
        size, reg, address = binding["size"], binding["incoming"], binding["address"]
        if arm:
            op = {1: "strb", 2: "strh", 4: "str", 8: "str"}[size]
            lines += [f"    {op} {reg}, {address}"]
        else:
            kind = scalar_kind(binding["c_type"])
            op = {"float": "movss", "double": "movsd"}.get(kind)
            if not op:
                op = "mov" + {1: "b", 2: "w", 4: "l", 8: "q"}[size]
                reg = x86_register(reg, size)
            lines += [f"    {op} %{reg}, {address}"]
    generated = {block["id"]: assembly for block, assembly in zip(plan["blocks"], fragments)}
    composition = plan.get(
        "composition", [{"kind": "code", "id": block["id"]} for block in plan["blocks"]]
    )
    for step in composition:
        if step["kind"] == "code":
            if source_map is not None:
                first_line = len("\n".join(lines).splitlines()) + 3
                source_map[step["id"]] = {
                    "start": first_line,
                    "end": first_line + generated[step["id"]].rstrip().count("\n"),
                }
            lines += [f"\n# block {step['id']}", generated[step["id"]].rstrip()]
        elif step["kind"] == "label":
            lines += [step["label"] + ":"]
        elif step["kind"] == "jump":
            lines += [("    b " if arm else "    jmp ") + step["target"]]
        elif step["kind"] == "branch":
            if arm:
                lines += [f"    {'cbnz' if step['when'] else 'cbz'} w0, {step['target']}"]
            else:
                lines += [
                    "    testl %eax, %eax",
                    f"    {'jnz' if step['when'] else 'jz'} {step['target']}",
                ]
        else:
            raise ValueError(f"Unknown composition step: {step['kind']}")
    lines += [f"{abi['return_label']}:"]
    if arm:
        if frame:
            lines += [f"    add sp, sp, #{frame}"]
        lines += ["    ldp x29, x30, [sp], #16", "    ret"]
    else:
        lines += ["    leave", "    ret"]
        if abi["target"] == "x86_64-linux":
            lines += ['.section .note.GNU-stack,"",@progbits']
    return "\n".join(lines) + "\n"
