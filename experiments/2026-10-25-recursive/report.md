# 递归 LEGO 编译：可运行版本与实验记录

整理于 2026-10-26（Asia/Shanghai）。原始实验目录沿用 `20261025` 标识。

当前版本已经能执行完整流程：声明绑定与布局分析、递归选择控制块、独立神经翻译、
组合汇编、汇编器诊断、局部细化或修复、差分验证。重点是长函数的可分解性和局部
迭代能力；小函数准确率作为基础链路检查。

拆分遵循 [LEGO-Compiler Algorithm 2 与附录 A](https://arxiv.org/html/2505.20356v1#A4)：
从队列头取当前块，决定保留或拆分，将子块逆序放回队列头，保持原程序顺序。
循环和分支会显式展开条件、块体、更新、标签和跳转；子块可以继续拆分。
实现不使用固定行数作为拆分算法。Clang 提供语法绑定及布局验证，模型负责汇编生成。

| 实验 | 已执行结果 |
|---|---|
| 嵌套 for/while/do/switch、break/continue | 30 个独立翻译块，分解深度 8，1,000 项检查通过 |
| 修改嵌套 switch 中一条计算语句 | 仅重新生成 1 块，复用 29 块，1,000 项检查通过 |
| 2,155 行单函数，完全拆细后的 C 重组对照 | 2,089 个叶块，分解深度 11，200 项检查通过 |
| 同一长函数的 Pi 神经编译 | 最终 123 个块，最大块约 34 行，200 项检查通过 |

“分解深度”包含顺序块细化层级，不等同于源程序的循环嵌套深度。
检查同时比较返回值和完整数组缓冲区。长函数是确定性生成的压力用例，包含嵌套
循环、32 个数据相关分支及大量无符号运算；它不是生产项目中的真实长函数。

长函数不是一次生成即成功。初始 keep/split 选择得到 122 块，其中一个 16 语句块
把 C 文本混入汇编。将该块继续拆成两个子块后，得到 123 块，其他已完成产物复用。
汇编器随后定位到 21 个块的指令错误，主要是 ARM 立即数范围，另有残缺指令和
不合法的地址缩放。仅向这 21 块提供其源代码、既定接口和局部汇编诊断，进行一轮
修复；另外 102 块复用。最终汇编成功，并通过 200 项差分检查。

没有手工改写候选汇编，也没有将参考汇编交给模型。模型调用禁用工具；测试由
控制器执行。规划过程中调整过保留粒度的提示，并保留已有决策续跑；还遇到过
CLI 响应包裹格式和请求超时。JSON 包裹由适配器提取，原始响应保留，超时后复用
已完成产物续跑。因此，这是一轮工程验证，不是统一提示下的严格统计基准。

执行平台为 arm64/macOS、Apple Clang 21.0.0、Pi 1.2.0；CLI 报告的模型标识是
`mco-6`，沿用用户已有配置。小样本还验证过 Codex CLI，见
[基础链路记录](../2026-10-25-pilot/report.md)。x86 脚手架尚未在本轮实机验证。

主要产物：

- [长函数汇总](long_nested/summary.json)、[最终差分结果](long_nested/result.json)
- [选定块和控制流接口](long_nested/plan.json)、[最终汇编](long_nested/candidate.s)
- [修复前的汇编错误](long_nested/assembler-errors-before-repair.json)、[局部反馈](long_nested/feedback.json)
- [嵌套用例结果](nested_control/result.json)、[局部修改结果](incremental/result.json)

无需再次调用模型即可重验已保存的长函数汇编：

```sh
python3 -m lego_compiler verify benchmarks/recursive/long_nested/source.c \
  benchmarks/recursive/long_nested/driver.c \
  experiments/2026-10-25-recursive/long_nested/candidate.s \
  --function long_kernel --output runs/long-replay-01
```

重新运行 agent 流程：

```sh
python3 -m lego_compiler run --agent pi --modes lego-adaptive --jobs 4 \
  --manifest benchmarks/recursive/manifest.json --cases nested_control \
  --output runs/nested-demo-01
```

当前支持范围是明确的 C 子集；预处理宏、头文件、全局存储、VLA、任意 goto 等
尚未接入。原始任意 goto 与控制器生成的结构化跳转区分处理。当前可精确定位汇编
错误，整函数行为不一致还需要进一步定位，不能据此直接认定某个块有错。
完整入口、限制和细化/修复命令见 [仓库说明](../../README.md)。
