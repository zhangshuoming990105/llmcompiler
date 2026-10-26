"""Clang handles C syntax/binding; small native probes expose actual ABI sizes.

No source-to-assembly compilation occurs here. Neural lowering remains a distinct
stage; this frontend intentionally supports only a bounded, self-contained C subset.
"""

import json
import re
from pathlib import Path

from .common import checked, digest, save_json
from .target import contract, native_target, scalar_kind


def walk(node):
    yield node
    for child in node.get("inner", []):
        yield from walk(child)


def ctype(node):
    types = node["type"]
    return types.get("desugaredQualType", types["qualType"])


def bounds(node):
    start, end = node["range"]["begin"], node["range"]["end"]
    if "offset" not in start or "offset" not in end:
        raise ValueError("Macro-expanded source ranges are unsupported")
    return start["offset"], end["offset"] + end["tokLen"]


def ast(path, compiler):
    return json.loads(
        checked(
            [compiler, "-std=c11", "-Werror", "-Xclang", "-ast-dump=json", "-fsyntax-only", path]
        )
    )


def function_node(tree):
    definitions = [
        node
        for node in tree.get("inner", [])
        if node.get("kind") == "FunctionDecl"
        and any(child.get("kind") == "CompoundStmt" for child in node.get("inner", []))
    ]
    if len(definitions) != 1:
        raise ValueError("Expected exactly one function definition")
    return definitions[0]


def validate_subset(tree, source):
    if re.search(rb"^\s*#", source, re.M):
        raise ValueError("Preprocessor directives/includes are not supported in the pilot frontend")
    if any(n.get("kind") == "VarDecl" for n in tree.get("inner", [])):
        raise ValueError("Global variables are not supported yet")
    forbidden = {
        "GotoStmt",
        "IndirectGotoStmt",
        "LabelStmt",
        "GCCAsmStmt",
        "MSAsmStmt",
        "StmtExpr",
        "VAArgExpr",
    }
    for node in walk(tree):
        if node.get("kind") in forbidden:
            raise ValueError(f"Unsupported C construct: {node['kind']}")
        if node.get("kind") in ("CleanupAttr", "ReturnsTwiceAttr"):
            raise ValueError(
                "Scope cleanup and non-local control-transfer attributes are unsupported"
            )
        if node.get("storageClass") in ("static", "extern") and node.get("kind") == "VarDecl":
            raise ValueError("Static/extern local variables are not supported")
        if node.get("kind") == "FunctionDecl" and node.get("variadic"):
            raise ValueError("Variadic functions are not supported")
        if node.get("kind") in ("ParmVarDecl", "VarDecl"):
            if any(child.get("kind") == "AlignedAttr" for child in node.get("inner", [])):
                raise ValueError("Variable-specific alignment is unsupported")
            typename = ctype(node)
            if "[" in typename and not re.fullmatch(r"[^\[\]]+(?:\[\d+\])+", typename):
                raise ValueError("Variable-length arrays are unsupported")


def layout_probe(prefix, types, records, output, compiler):
    """Ask the native C implementation for sizeof/alignof/offsetof, not guesses."""
    expressions = []
    keys = []
    for name in sorted(types):
        for kind, expr in (("size", f"sizeof({name})"), ("alignment", f"_Alignof({name})")):
            keys.append(("types", name, kind))
            expressions.append(expr)
    for record, fields in records.items():
        for field in fields:
            keys.append(("records", record, field))
            expressions.append(f"offsetof({record}, {field})")
    code = "#include <stdio.h>\n#include <stddef.h>\n" + prefix + "\nint main(void) {\n"
    for expr in expressions:
        code += f'    printf("%zu\\n", (size_t)({expr}));\n'
    code += "    return 0;\n}\n"
    probe = output / "layout_probe.c"
    probe.write_text(code)
    exe = output / "layout_probe"
    checked([compiler, "-std=c11", probe, "-o", exe])
    values = checked([exe]).splitlines()
    if len(values) != len(keys):
        raise ValueError("Incomplete ABI layout probe")
    result = {"types": {}, "records": {}}
    for (category, name, key), value in zip(keys, values):
        result[category].setdefault(name, {})[key] = int(value)
    save_json(output / "layout.json", result)
    return result


def prepare(source_path, output, compiler):
    output = Path(output).resolve()
    output.mkdir(parents=True, exist_ok=True)
    source_path = Path(source_path).resolve()
    original = source_path.read_bytes()
    (output / "source.c").write_bytes(original)
    tree = ast(output / "source.c", compiler)
    validate_subset(tree, original)
    function = function_node(tree)
    return_type = ctype(function).split("(")[0].strip()
    if return_type != "void":
        scalar_kind(return_type)
    declarations = [n for n in walk(function) if n.get("kind") in ("ParmVarDecl", "VarDecl")]
    if any(not n.get("name") for n in declarations):
        raise ValueError("Anonymous parameters are not supported")
    replacements = {}
    bindings = []
    by_id = {}
    stem = "lego"
    names = {n.get("name", "") for n in walk(tree)}
    while any(name.startswith(stem + "_") for name in names):
        stem += "_"
    for index, node in enumerate(declarations):
        name = f"{stem}_v{index}_{node['name']}"
        position = node["loc"]
        if "offset" not in position:
            raise ValueError("Macro-generated declarations are unsupported")
        begin, end = position["offset"], position["offset"] + position["tokLen"]
        replacements[(begin, end)] = name.encode()
        binding = {
            "id": f"v{index}",
            "original_name": node["name"],
            "name": name,
            "c_type": ctype(node),
            "role": "parameter" if node["kind"] == "ParmVarDecl" else "local",
            "declaration_offset": begin,
            "use_offsets": [],
        }
        bindings.append(binding)
        by_id[node["id"]] = binding
    for node in walk(function):
        if node.get("kind") == "DeclRefExpr" and node["referencedDecl"]["id"] in by_id:
            binding = by_id[node["referencedDecl"]["id"]]
            begin, end = bounds(node)
            replacements[(begin, end)] = binding["name"].encode()
            binding["use_offsets"].append(begin)
    renamed = original
    for (begin, end), name in sorted(replacements.items(), reverse=True):
        renamed = renamed[:begin] + name + renamed[end:]
    renamed_path = output / "renamed.c"
    renamed_path.write_bytes(renamed)
    renamed_tree = ast(renamed_path, compiler)
    function = function_node(renamed_tree)
    prefix = renamed[: bounds(function)[0]].decode()
    records = {}
    for node in renamed_tree.get("inner", []):
        if node.get("kind") == "RecordDecl" and node.get("completeDefinition"):
            if node.get("tagUsed") != "struct" or not node.get("name"):
                raise ValueError("Only named structs are supported")
            fields = [n for n in node.get("inner", []) if n.get("kind") == "FieldDecl"]
            if any(n.get("isBitfield") or not n.get("name") for n in fields):
                raise ValueError("Bitfields and anonymous fields are unsupported")
            records["struct " + node["name"]] = [n["name"] for n in fields]
    # Recursive switch decomposition evaluates its selector exactly once, then
    # reuses this explicit slot across independently translated comparisons.
    for index, node in enumerate(n for n in walk(function) if n.get("kind") == "SwitchStmt"):
        bindings.append(
            {
                "id": f"t{index}",
                "original_name": None,
                "name": f"{stem}_switch{index}",
                "c_type": ctype(node["inner"][0]),
                "role": "temporary",
                "switch_offset": bounds(node)[0],
            }
        )
    types = {b["c_type"] for b in bindings} | set(records)
    for node in walk(function):
        if node.get("kind") in ("ArraySubscriptExpr", "MemberExpr"):
            types.add(ctype(node))
    for typename in types:
        if "[" in typename and not re.fullmatch(r"[^\[\]]+(?:\[\d+\])+", typename):
            raise ValueError("Variable-length arrays are unsupported")
    layout = layout_probe(prefix, types, records, output, compiler)
    target = native_target()
    cursor = 0
    for binding in bindings:
        facts = layout["types"][binding["c_type"]]
        size, alignment = facts["size"], facts["alignment"]
        if alignment > 16:
            raise ValueError("Over-aligned locals are unsupported")
        cursor = (cursor + alignment - 1) // alignment * alignment
        if target == "arm64-macos":
            binding.update(facts, offset=cursor, address=f"[sp, #{cursor}]")
        else:
            # sizeof(T) is a multiple of alignof(T); negative slot bases remain aligned.
            binding.update(facts, offset=-(cursor + size), address=f"-{cursor + size}(%rbp)")
        cursor += size
    frame_size = (cursor + 15) // 16 * 16
    abi = contract(target, function["name"], bindings, frame_size)
    abi["return_type"] = return_type
    body = next(n for n in function["inner"] if n.get("kind") == "CompoundStmt")
    statements = body.get("inner", [])
    if not statements:
        raise ValueError("Empty function bodies are unsupported")
    begin, end = bounds(body)
    starts = [begin + 1] + [bounds(n)[0] for n in statements[1:]]
    ends = starts[1:] + [end - 1]
    blocks = []
    for index, (statement, left, right) in enumerate(zip(statements, starts, ends)):
        addresses = []
        for node in walk(statement):
            kind = node.get("kind")
            if kind not in ("ArraySubscriptExpr", "MemberExpr"):
                continue
            lo, hi = bounds(node)
            fact = {
                "expression": renamed[lo:hi].decode(),
                "result_type": ctype(node),
                "size": layout["types"][ctype(node)]["size"],
            }
            if kind == "ArraySubscriptExpr":
                fact["operation"] = "base + signed_or_unsigned_index * size (preserve C index type)"
            else:
                base_type = ctype(node["inner"][0])
                record = re.sub(r"\b(const|volatile|restrict)\b|\*", "", base_type).strip()
                if record not in layout["records"]:
                    raise ValueError(f"Unknown member base type: {record}")
                fact["field_offset"] = layout["records"][record][node["name"]]
            addresses.append(fact)
        block_id = f"b{index:03}"
        blocks.append(
            {
                "id": block_id,
                "kind": statement["kind"],
                "begin": left,
                "end": right,
                "label_prefix": f"L_{function['name']}_{block_id}_",
                "source": renamed[left:right].decode(),
                "address_facts": addresses,
            }
        )
    assert b"".join(b["source"].encode() for b in blocks) == renamed[begin + 1 : end - 1]
    plan = {
        "schema_version": 1,
        "source_sha256": digest(output / "source.c"),
        "renamed_sha256": digest(renamed_path),
        "compiler": checked([compiler, "--version"]).splitlines()[0],
        "function": function["name"],
        "abi": abi,
        "bindings": bindings,
        "record_layouts": layout["records"],
        "blocks": blocks,
        "generated_prefix": stem,
    }
    from .regions import RegionBuilder

    save_json(output / "regions.json", RegionBuilder(renamed, function, plan, layout).finish())
    save_json(output / "plan.json", plan)
    return plan
