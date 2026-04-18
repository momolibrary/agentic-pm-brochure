# multica/agents/CLAUDE.md — Agent 角色定义

> 父级：[../CLAUDE.md](../CLAUDE.md) → [../../CLAUDE.md](../../CLAUDE.md)

## 概述

本目录定义了 6 个 AI 协作 Agent，每个 Agent 是一个角色定义文件，描述职责、能力、工作流程和输出标准。

**注册表（单一事实源）**：`manifest.yaml` — multica CLI 通过此文件解析 mention 路由。
**Mention 协议**：`[@显示名](mention://agent/<uuid>)`，纯文本 `@agent-name` 不会被 multica 路由。

## Agent 清单

> 如有冲突，以 `manifest.yaml` 中的定义为准。

| 文件 | 角色 | 核心职责 | 绑定 Skill | UUID |
|------|------|---------|-----------|------|
| `editor-chief.md` | 主编 | 任务分配、质量把控、终审、人机接口 | review-quality, term-lookup, lint-check | `7ba899bd-...` |
| `author-draft.md` | 作者 | 章节初稿写作、内容修订 | chapter-draft, term-lookup | `a054c330-...` |
| `reviewer.md` | 审稿人 | Lint 执行、术语一致性、文风检查 | lint-check, review-quality, term-lookup | `6586d624-...` |
| `researcher.md` | 研究员 | 素材搜索、资产建设、类比挖掘 | research-search | `4828ea52-...` |
| `case-writer.md` | 案例撰写 | 案例开发、反例整理、资产管理 | case-develop | `2eb4c3b6-...` |
| `illustrator.md` | 插画师 | 图示绘制、流程图、架构图 | diagram-create | `2f0e9417-...` |

## Agent 定义文件规范

每个 Agent 文件必须包含以下段落：

1. **职责** — 该角色负责什么
2. **能力** — 绑定哪些 Skill（须存在于 `../skills/`）
3. **工作流程** — 标准执行步骤
4. **输出标准** — 交付质量要求
5. **协作语法** — `@agent-name` 调用格式与示例

## 协作关系

```
editor-chief ──分配任务──→ author-draft / researcher / case-writer / illustrator
                         ↓ 产出
reviewer ──────审核────→ 初稿 / 案例 / 图示
                         ↓ 通过
editor-chief ──终审────→ 人工确认 → 提交
```

## 修改规则

- 修改 Agent 绑定的 Skill 时，须确认对应 Skill 存在于 `../skills/` **且同步更新 `manifest.yaml`**
- 修改 Agent 工作流时，须检查 `../workflows/workflow-config.md` 一致性
- 新增 Agent 后：`manifest.yaml` 新增条目 → 创建 Agent 文件（含 frontmatter）→ 更新本文件清单 → 更新 `../CLAUDE.md` 索引 → 更新 `../workflows/workflow-config.md`
- 删除 Agent 时：反向检查所有引用 → 更新 `manifest.yaml` → 更新所有相关 CLAUDE.md
