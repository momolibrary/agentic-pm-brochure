# multica/skills/CLAUDE.md — Skill 能力定义

> 父级：[../CLAUDE.md](../CLAUDE.md) → [../../CLAUDE.md](../../CLAUDE.md)

## 概述

本目录定义了 7 个可复用的 Skill，每个 Skill 是一个独立能力模块，被 Agent 调用执行具体任务。

## Skill 清单

| 文件 | 功能 | 调用者 Agent |
|------|------|-------------|
| `chapter-draft.md` | TDD 章节初稿写作 | author-draft |
| `review-quality.md` | TDD 验收审核 | reviewer, editor-chief |
| `lint-check.md` | 自动文风/术语/结构检查 | reviewer |
| `term-lookup.md` | 术语查询与一致性管理 | author-draft, reviewer |
| `case-develop.md` | 正面/反面案例场景开发 | case-writer |
| `diagram-create.md` | 图示可视化创建 | illustrator |
| `research-search.md` | 素材搜索与类比生成 | researcher |

## Skill 定义文件规范

每个 Skill 文件必须包含以下段落：

1. **功能** — 做什么
2. **输入** — 接收什么参数
3. **输出** — 产出什么结果
4. **执行流程** — 步骤说明
5. **质量标准** — 输出质量要求
6. **依赖** — 依赖其他 Skill 或标准文件
7. **调用语法** — mention 格式

## 依赖关系图

```
chapter-draft ──→ term-lookup
              ──→ case-develop

review-quality ──→ lint-check
               ──→ term-lookup

lint-check ──→ standards/lint-rules.yaml
           ──→ standards/term-glossary.md
           ──→ standards/style-guide.md

term-lookup ──→ standards/term-glossary.md

case-develop ──→ standards/term-glossary.md（角色定义）

diagram-create     （无外部依赖）
research-search    （无外部依赖）
```

## 修改规则

- 修改 Skill 输入/输出契约时，须通知所有调用方 Agent（见上表「调用者」列）
- 修改依赖的 `standards/` 文件后，须检查依赖该标准的 Skill 是否需调整
- 新增 Skill 后：更新本文件清单 → 更新 `../CLAUDE.md` 索引 → 绑定到对应 Agent 定义
- 删除 Skill 时：检查所有 Agent 的能力绑定 → 反向清理引用
