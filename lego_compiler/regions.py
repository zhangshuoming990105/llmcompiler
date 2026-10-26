"""Recursive control-block decomposition from LEGO-Compiler, Algorithms 1/2.

Selection is a deque of keep/split decisions. Splitting a control structure
exposes its constituent expressions/bodies and explicit labels/jumps. Children
can be split again; no loop or branch is an indivisible translation unit.
"""

import copy
import re
from collections import deque

from .frontend import bounds, ctype, walk

CONTROLS = {"ForStmt", "WhileStmt", "DoStmt", "IfStmt", "SwitchStmt", "CompoundStmt"}
LOOPS = {"ForStmt", "WhileStmt", "DoStmt"}


def region_step(identifier):
    return {"kind": "region", "id": identifier}


class RegionBuilder:
    def __init__(self, source, function, plan, layout):
        self.source = source
        self.function = function
        self.plan = plan
        self.layout = layout
        self.nodes = {}
        self.switches = {
            binding["switch_offset"]: binding
            for binding in plan["bindings"]
            if "switch_offset" in binding
        }

    def span(self, node, expression=False):
        begin, end = bounds(node)
        if not expression:
            cursor = end
            while cursor < len(self.source) and self.source[cursor : cursor + 1] in b" \t\r\n":
                cursor += 1
            if self.source[cursor : cursor + 1] == b";":
                end = cursor + 1
        return begin, end

    def text(self, node, expression=False):
        begin, end = self.span(node, expression)
        return self.source[begin:end].decode()

    def label(self, identifier, suffix):
        return f"L_{self.plan['function']}_{identifier}_{suffix}"

    def free_jumps(self, nodes, context):
        edits = []

        def visit(node, own_break=False, own_continue=False):
            kind = node.get("kind")
            if kind in LOOPS:
                own_break = own_continue = True
            elif kind == "SwitchStmt":
                own_break = True
            if kind == "BreakStmt" and not own_break:
                edits.append((*bounds(node), context["break"]))
            if kind == "ContinueStmt" and not own_continue:
                edits.append((*bounds(node), context["continue"]))
            for child in node.get("inner", []):
                visit(child, own_break, own_continue)

        for node in nodes:
            visit(node)
        return edits

    def facts(self, nodes):
        facts = []
        for root in nodes:
            for node in walk(root):
                kind = node.get("kind")
                if kind not in ("ArraySubscriptExpr", "MemberExpr"):
                    continue
                fact = {
                    "expression": self.text(node, True),
                    "result_type": ctype(node),
                    "size": self.layout["types"][ctype(node)]["size"],
                }
                if kind == "ArraySubscriptExpr":
                    fact["operation"] = "base + index * size; preserve C index signedness"
                else:
                    record = re.sub(
                        r"\b(const|volatile|restrict)\b|\*", "", ctype(node["inner"][0])
                    ).strip()
                    fact["field_offset"] = self.layout["records"][record][node["name"]]
                facts.append(fact)
        return facts

    def add(
        self,
        identifier,
        kind,
        source,
        *,
        begin=None,
        end=None,
        nodes=(),
        context=None,
        expansion=None,
        result=None,
        allowed=(),
        verification_source=None,
    ):
        context = context or {"break": None, "continue": None}
        edits = self.free_jumps(nodes, context)
        if verification_source is None:
            verification_source = source
            if begin is not None:
                content = source.encode()
                for left, right, target in sorted(edits, reverse=True):
                    if not target:
                        raise ValueError("Unbound break/continue in region")
                    content = (
                        content[: left - begin]
                        + f"goto {target}".encode()
                        + content[right - begin :]
                    )
                verification_source = content.decode()
        targets = set(allowed) | {target for _, _, target in edits}
        names = [
            b["name"]
            for b in self.plan["bindings"]
            if re.search(r"\b" + re.escape(b["name"]) + r"\b", source)
        ]
        node = {
            "id": identifier,
            "kind": kind,
            "source": source,
            "verification_source": verification_source,
            "begin": begin,
            "end": end,
            "label_prefix": self.label(identifier, "local_"),
            "symbol_names": names,
            "address_facts": self.facts(nodes),
            "allowed_targets": sorted(targets),
            "control_context": context,
            "result": result,
            "expansion": expansion or [],
        }
        self.nodes[identifier] = node
        return identifier

    def sequence(self, identifier, children, context, *, begin=None, end=None):
        source = (
            self.source[begin:end].decode()
            if begin is not None
            else "\n".join(self.nodes[x]["source"] for x in children)
        )
        verification = "\n".join(self.nodes[x]["verification_source"] for x in children)
        if not children:
            expansion = []
        elif any(self.nodes[x]["kind"] in CONTROLS for x in children):
            groups, straight = [], []

            def flush():
                if straight:
                    if len(straight) == 1:
                        groups.append(straight[0])
                    else:
                        group = identifier + f"_g{len(groups)}"
                        self.sequence(group, list(straight), context)
                        groups.append(group)
                    straight.clear()

            for child in children:
                if self.nodes[child]["kind"] in CONTROLS:
                    flush()
                    groups.append(child)
                else:
                    straight.append(child)
            flush()
            expansion = [region_step(x) for x in groups]
        elif len(children) > 2:
            midpoint = len(children) // 2
            left, right = identifier + "_left", identifier + "_right"
            self.sequence(left, children[:midpoint], context)
            self.sequence(right, children[midpoint:], context)
            expansion = [region_step(left), region_step(right)]
        else:
            expansion = [region_step(x) for x in children]
        self.add(
            identifier,
            "Sequence",
            source,
            begin=begin,
            end=end,
            context=context,
            expansion=expansion,
            verification_source=verification,
            allowed={target for x in children for target in self.nodes[x]["allowed_targets"]},
        )
        self.nodes[identifier]["address_facts"] = [
            fact for x in children for fact in self.nodes[x]["address_facts"]
        ]
        return identifier

    def condition(self, node, identifier, context):
        left, right = self.span(node, True)
        return self.add(
            identifier,
            "Condition",
            self.text(node, True),
            begin=left,
            end=right,
            nodes=[node],
            context=context,
            result="boolean",
        )

    def build(self, node, identifier, context):
        kind = node["kind"]
        begin, end = self.span(node)
        children = node.get("inner", [])
        if kind == "CompoundStmt":
            nested = [
                self.build(child, f"{identifier}_s{i:03}", context)
                for i, child in enumerate(children)
            ]
            return self.sequence(
                identifier, nested, context, begin=bounds(node)[0] + 1, end=bounds(node)[1] - 1
            )
        expansion = []
        if kind in LOOPS:
            cond_label, body_label = self.label(identifier, "cond"), self.label(identifier, "body")
            increment_label, end_label = (
                self.label(identifier, "increment"),
                self.label(identifier, "end"),
            )
            inside = {
                "break": end_label,
                "continue": increment_label if kind == "ForStmt" else cond_label,
            }
            if kind == "ForStmt":
                init, condition_variable, condition, increment, body = children
                if condition_variable:
                    raise ValueError("C++ condition declarations are unsupported")
                if init:
                    expansion.append(region_step(self.build(init, identifier + "_init", context)))
                expansion.append({"kind": "label", "label": cond_label})
                if condition:
                    expansion += [
                        region_step(self.condition(condition, identifier + "_condition", context)),
                        {"kind": "branch", "when": False, "target": end_label},
                    ]
                expansion.append(region_step(self.build(body, identifier + "_body", inside)))
                expansion.append({"kind": "label", "label": increment_label})
                if increment:
                    expansion.append(
                        region_step(self.build(increment, identifier + "_increment", context))
                    )
                expansion += [
                    {"kind": "jump", "target": cond_label},
                    {"kind": "label", "label": end_label},
                ]
            elif kind == "WhileStmt":
                condition, body = children
                expansion = [
                    {"kind": "label", "label": cond_label},
                    region_step(self.condition(condition, identifier + "_condition", context)),
                    {"kind": "branch", "when": False, "target": end_label},
                    region_step(self.build(body, identifier + "_body", inside)),
                    {"kind": "jump", "target": cond_label},
                    {"kind": "label", "label": end_label},
                ]
            else:
                body, condition = children
                expansion = [
                    {"kind": "label", "label": body_label},
                    region_step(self.build(body, identifier + "_body", inside)),
                    {"kind": "label", "label": cond_label},
                    region_step(self.condition(condition, identifier + "_condition", context)),
                    {"kind": "branch", "when": True, "target": body_label},
                    {"kind": "label", "label": end_label},
                ]
        elif kind == "IfStmt":
            condition, then = children[:2]
            otherwise = children[2] if node.get("hasElse") else None
            else_label, end_label = self.label(identifier, "else"), self.label(identifier, "end")
            expansion = [
                region_step(self.condition(condition, identifier + "_condition", context)),
                {"kind": "branch", "when": False, "target": else_label if otherwise else end_label},
                region_step(self.build(then, identifier + "_then", context)),
            ]
            if otherwise:
                expansion += [
                    {"kind": "jump", "target": end_label},
                    {"kind": "label", "label": else_label},
                    region_step(self.build(otherwise, identifier + "_else", context)),
                ]
            expansion.append({"kind": "label", "label": end_label})
        elif kind == "SwitchStmt":
            expansion = self.split_switch(node, identifier, context)
        elif kind in ("CaseStmt", "DefaultStmt"):
            raise ValueError("Case labels must be decomposed by their owning switch")
        return self.add(
            identifier,
            kind,
            self.source[begin:end].decode(),
            begin=begin,
            end=end,
            nodes=[node],
            context=context,
            expansion=expansion,
        )

    def split_switch(self, node, identifier, context):
        expression, body = node["inner"]
        if body["kind"] != "CompoundStmt":
            raise ValueError("Switch decomposition currently requires a compound body")
        end_label = self.label(identifier, "end")
        inside = {"break": end_label, "continue": context["continue"]}
        cases, body_steps = [], []
        default = end_label
        counter = 0

        def statement(item):
            nonlocal counter, default
            if item["kind"] in ("CaseStmt", "DefaultStmt"):
                label = self.label(identifier, f"case{len(cases)}")
                if item["kind"] == "DefaultStmt":
                    label = self.label(identifier, "default")
                    default = label
                else:
                    if len(item["inner"]) != 2:
                        raise ValueError("GNU case ranges are unsupported")
                    cases.append((self.text(item["inner"][0], True), label))
                body_steps.append({"kind": "label", "label": label})
                statement(item["inner"][-1])
            else:
                # Nested switches are handled recursively by build, not this switch.
                body_steps.append(
                    region_step(self.build(item, f"{identifier}_casebody{counter}", inside))
                )
                counter += 1

        for item in body.get("inner", []):
            statement(item)
        temporary = self.switches[bounds(node)[0]]["name"]
        evaluate = identifier + "_value"
        self.add(
            evaluate,
            "Expression",
            f"{temporary} = ({self.text(expression, True)});",
            nodes=[expression],
            context=context,
        )
        dispatch_parts = [evaluate]
        for index, (constant, target) in enumerate(cases):
            condition = identifier + f"_casecmp{index}_condition"
            comparison = f"{temporary} == ({ctype(expression)})({constant})"
            self.add(condition, "Condition", comparison, context=context, result="boolean")
            compare = identifier + f"_casecmp{index}"
            self.add(
                compare,
                "IfStmt",
                f"if ({comparison}) goto {target};",
                context=context,
                allowed=[target],
                expansion=[
                    region_step(condition),
                    {"kind": "branch", "when": True, "target": target},
                ],
            )
            dispatch_parts.append(compare)
        dispatch = identifier + "_dispatch"
        self.sequence(dispatch, dispatch_parts, context)
        return [
            region_step(dispatch),
            {"kind": "jump", "target": default},
            *body_steps,
            {"kind": "label", "label": end_label},
        ]

    def finish(self):
        body = next(node for node in self.function["inner"] if node.get("kind") == "CompoundStmt")
        root = self.build(body, "r", {"break": None, "continue": None})
        begin, end = bounds(body)
        return {
            "schema_version": 1,
            "algorithm": "arXiv:2505.20356v1 Algorithm 2 + Appendix A constructions",
            "root": root,
            "nodes": self.nodes,
            "c_prefix": self.source[: begin + 1].decode(),
            "c_suffix": self.source[end - 1 :].decode(),
        }


def select_regions(plan, tree, decide, *, max_decisions=10000):
    """Algorithm 2: pop front; on split, push children to front in reverse order."""
    queue = deque([(region_step(tree["root"]), 0)])
    blocks, composition, decisions = [], [], []
    while queue:
        step, depth = queue.popleft()
        if step["kind"] != "region":
            composition.append(step)
            continue
        node = tree["nodes"][step["id"]]
        if len(decisions) >= max_decisions:
            raise ValueError("Partition decision budget exceeded")
        decision = (
            decide(node) if node["expansion"] else {"decision": "keep", "reason": "atomic region"}
        )
        if isinstance(decision, str):
            decision = {"decision": decision, "reason": "explicit policy"}
        if decision.get("decision") not in ("keep", "split"):
            raise ValueError(f"Invalid split decision for {node['id']}")
        decisions.append({"id": node["id"], "depth": depth, **decision})
        if decision["decision"] == "split":
            if not node["expansion"]:
                raise ValueError("Cannot split an atomic region")
            queue.extendleft((child, depth + 1) for child in reversed(node["expansion"]))
        else:
            blocks.append({key: value for key, value in node.items() if key != "expansion"})
            composition.append({"kind": "code", "id": node["id"]})
    selected = copy.deepcopy(plan)
    selected.update(
        partition="recursive-control",
        blocks=blocks,
        composition=composition,
        split_decisions=decisions,
    )
    validate_composition(selected)
    return selected


def validate_composition(plan):
    labels = [step["label"] for step in plan["composition"] if step["kind"] == "label"]
    if len(labels) != len(set(labels)):
        raise ValueError("Duplicate control label")
    defined = set(labels) | {plan["abi"]["return_label"]}
    for step in plan["composition"]:
        if step["kind"] in ("branch", "jump") and step["target"] not in defined:
            raise ValueError("Unbound control target")
    for block in plan["blocks"]:
        if not set(block["allowed_targets"]) <= defined:
            raise ValueError(f"Region {block['id']} escapes the selected control skeleton")
    codes = [step["id"] for step in plan["composition"] if step["kind"] == "code"]
    if codes != [block["id"] for block in plan["blocks"]]:
        raise ValueError("Every selected region must occur exactly once in composition order")
    blocks = {block["id"]: block for block in plan["blocks"]}
    for index, step in enumerate(plan["composition"]):
        if step["kind"] == "branch":
            previous = plan["composition"][index - 1] if index else {}
            if previous.get("kind") != "code" or blocks[previous["id"]].get("result") != "boolean":
                raise ValueError("A conditional jump must immediately consume a predicate region")


def recompose_c(plan, tree):
    """Independent executable structural check before any neural translation."""
    predicate = plan.get("generated_prefix", "lego") + "_predicate"
    lines = [tree["c_prefix"], f"int {predicate};"]
    for binding in plan["bindings"]:
        if binding["role"] == "temporary":
            lines.append(f"{binding['c_type']} {binding['name']};")
    by_id = {block["id"]: block for block in plan["blocks"]}
    for step in plan["composition"]:
        if step["kind"] == "code":
            block = by_id[step["id"]]
            source = block["verification_source"].strip()
            if block.get("result") == "boolean":
                source = f"{predicate} = !!({source});"
            elif source and not source.endswith((";", "}")):
                source += ";"
            lines.append(source)
        elif step["kind"] == "label":
            lines.append(step["label"] + ": ;")
        elif step["kind"] == "jump":
            lines.append("goto " + step["target"] + ";")
        else:
            condition = predicate if step["when"] else "!" + predicate
            lines.append(f"if ({condition}) goto {step['target']};")
    lines.append(tree["c_suffix"])
    return "\n".join(lines).rstrip() + "\n"
