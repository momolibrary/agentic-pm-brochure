# manuscript/CLAUDE.md — 书稿写作区

> 父级：[../CLAUDE.md](../CLAUDE.md)

## 概述

书稿本体存放区，包含章节正文、配套案例和图示素材。所有内容须通过 TDD 验收流程。

## 子目录

| 子目录 | 存放内容 | 命名规则 |
|--------|---------|---------|
| `chapters/` | 章节正文 Markdown | `ch-XX-章节名.md` |
| `cases/` | 章节配套案例 | `case-XX-案例名.md` |
| `diagrams/` | 图示素材 | `diag-XX-图示名.md`（Mermaid）或图片文件 |

## 写作约束

1. **TDD 先行**：先在 Issue 中定义验收标准（模板：`../multica/workflows/tdd-template.md`），再写内容
2. **10 要素结构**：每章必须包含完整 10 要素（见 `../standards/style-guide.md`）
3. **术语一致**：使用 `../standards/term-glossary.md` 中的标准术语，禁止自造
4. **文风合规**：满足 `../standards/style-guide.md` 全部要求（句长 ≤30 字、幽默 ≤3 级、无空话词）
5. **Lint 通过**：提交前须通过 `../standards/lint-rules.yaml` 全部检查项
6. **角色一致**：老李和小想的人设不可偏离（定义见 `../standards/term-glossary.md`）

## 章节目录

> 随章节开发逐步填充，每新增章节须更新此表。

| 编号 | 章节文件 | 状态 | TDD Issue |
|------|---------|------|-----------|
| — | （暂无） | — | — |

## 修改规则

- **新增章节**：创建文件 → 更新本文件「章节目录」表 → 更新根 `../README.md` 进度
- **修改已审核章节**：须重新走 review-quality 流程（`../multica/skills/review-quality.md`）
- **图示变更**：须检查并更新引用该图示的章节
- **案例变更**：须检查并更新引用该案例的章节及 `../assets/cases/`
