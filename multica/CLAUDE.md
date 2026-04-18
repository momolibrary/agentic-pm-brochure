# multica/CLAUDE.md — AI 多智能体协作系统

> 父级：[../CLAUDE.md](../CLAUDE.md)

## 概述

multica 是本项目的 AI 协作系统，包含 **6 个 Agent**、**7 个 Skill** 和完整的 **TDD 写作工作流**。Agent 扮演角色，Skill 提供可复用能力，Workflow 编排协作流程。

## 子目录

| 子目录 | 用途 | 子级 CLAUDE.md |
|--------|------|---------------|
| `agents/` | Agent 角色定义（6 个） | `agents/CLAUDE.md` |
| `skills/` | Skill 能力定义（7 个） | `skills/CLAUDE.md` |
| `workflows/` | 工作流配置与模板 | `workflows/CLAUDE.md` |

## 快速索引

### Agent 一览

| Agent | 角色 | 绑定 Skill | 调用示例 |
|-------|------|-----------|---------|
| `editor-chief` | 主编 | review-quality, term-lookup, lint-check | `@editor-chief 创建章节任务 [章节名]` |
| `author-draft` | 作者 | chapter-draft, term-lookup | `@author-draft 写作 [章节名] 初稿` |
| `reviewer` | 审稿人 | lint-check, review-quality, term-lookup | `@reviewer 审核 [章节名]` |
| `researcher` | 研究员 | research-search | `@researcher 搜索 [关键词]` |
| `case-writer` | 案例撰写 | case-develop | `@case-writer 案例请求 [主题]` |
| `illustrator` | 插画师 | diagram-create | `@illustrator 绘制 [图表类型] [主题]` |

### Skill 一览

| Skill | 功能 | 依赖标准文件 |
|-------|------|-------------|
| `chapter-draft` | TDD 章节初稿写作 | style-guide, term-glossary |
| `review-quality` | TDD 验收审核 | lint-rules, style-guide |
| `lint-check` | 自动文风/术语/结构检查 | lint-rules.yaml, term-glossary.md, style-guide.md |
| `term-lookup` | 术语查询与一致性管理 | term-glossary.md |
| `case-develop` | 正面/反面案例场景开发 | term-glossary.md（角色定义） |
| `diagram-create` | 图示可视化创建 | — |
| `research-search` | 素材搜索与类比生成 | — |

### 核心工作流

```
Issue 创建(editor-chief)
  → 素材研究(researcher)
    → 初稿写作(author-draft)
      → Lint 检查(reviewer)
        → 图示绘制(illustrator)
          → 验收审核(reviewer)
            → 终审 + 人工确认(editor-chief)
              → Git 提交
```

完整流程：`workflows/workflow-config.md`

## 修改规则

1. **新增 Agent**：`agents/` 创建文件 → 更新 `agents/CLAUDE.md` → 更新本文件索引 → 更新 `workflows/workflow-config.md`
2. **新增 Skill**：`skills/` 创建文件 → 更新 `skills/CLAUDE.md` → 更新本文件索引 → 绑定到对应 Agent 定义
3. **修改工作流**：更新 `workflows/` → 更新 `workflows/CLAUDE.md` → 检查受影响的 Agent/Skill
4. **删除 Agent/Skill**：移除文件 → 反向更新所有引用处 → 更新所有相关 CLAUDE.md
