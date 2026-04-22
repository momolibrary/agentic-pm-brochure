# multica/CLAUDE.md — AI 多智能体协作系统

> 父级：[../CLAUDE.md](../CLAUDE.md)

## 概述

multica 是本项目的 AI 协作系统，包含 **6 个 Agent**、**8 个 Skill** 和完整的 **TDD 写作工作流**。Agent 扮演角色，Skill 提供可复用能力，Workflow 编排协作流程。

**Agent/Skill 注册表（单一事实源）**：`agents/manifest.yaml`
**流程规范**：`../process/`（Issue 协议、Git 规范、质量门禁、工具兼容）

## 子目录

| 子目录 | 用途 | 子级 CLAUDE.md |
|--------|------|---------------|
| `agents/` | Agent 角色定义（6 个） | `agents/CLAUDE.md` |
| `skills/` | Skill 能力定义（8 个） | `skills/CLAUDE.md` |
| `workflows/` | 工作流配置与模板 | `workflows/CLAUDE.md` |

## 快速索引

### Agent 一览

> 权威来源：`agents/manifest.yaml`。以下为快速索引，如有冲突以 manifest 为准。
> **Mention 协议**：multica 使用 `[@显示名](mention://agent/<uuid>)` 路由，纯文本 `@` 不生效。

| Agent | 角色 | 绑定 Skill | mention |
|-------|------|-----------|---------|
| `editor-chief` | 主编 | review-quality, term-lookup, lint-check, feishu-publish | `[@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c)` |
| `author-draft` | 作者 | chapter-draft, term-lookup | `[@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2)` |
| `reviewer` | 审稿人 | lint-check, review-quality, term-lookup | `[@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c)` |
| `researcher` | 研究员 | research-search | `[@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c)` |
| `case-writer` | 案例撰写 | case-develop | `[@案例师](mention://agent/2eb4c3b6-d91c-4372-9245-61769ab1032b)` |
| `illustrator` | 插画师 | diagram-create | `[@插画师](mention://agent/2f0e9417-105a-4607-8ee3-9dd26527f578)` |

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
| `feishu-publish` | 飞书文章发布工作流（发布+权限+预告+目录） | lark-cli（外部工具） |

### 核心工作流

```
Issue 创建(editor-chief)    ← process/issue-protocol.md
  → 素材研究(researcher)
    → 初稿写作(author-draft)
      → Lint 检查(reviewer)
        → 图示绘制(illustrator)
          → 验收审核(reviewer)
            → 终审 + 人工确认(editor-chief)
              → Git 提交              ← process/git-convention.md
```

- 完整流程：`workflows/workflow-config.md`
- 质量门禁：`../process/quality-gate.md`
- 异常回退：`workflows/workflow-config.md`（异常回退与重试规则段）

## 修改规则

1. **新增 Agent**：`agents/manifest.yaml` 新增条目 → `agents/` 创建文件（含 frontmatter）→ 更新 `agents/CLAUDE.md` → 更新本文件索引 → 更新 `workflows/workflow-config.md`
2. **新增 Skill**：`agents/manifest.yaml` skills 段新增 → `skills/` 创建文件（含 frontmatter）→ 更新 `skills/CLAUDE.md` → 更新本文件索引 → 绑定到对应 Agent 定义
3. **修改工作流**：更新 `workflows/` → 更新 `workflows/CLAUDE.md` → 检查受影响的 Agent/Skill → 同步 `agents/manifest.yaml` transitions
4. **删除 Agent/Skill**：移除文件 → 更新 `agents/manifest.yaml` → 反向更新所有引用处 → 更新所有相关 CLAUDE.md
