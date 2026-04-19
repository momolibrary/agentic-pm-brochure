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
| CH-01 | `chapters/CH-01-数据基础.md` | approved | — |
| CH-02 | `chapters/CH-02-数据流转与约束.md` | lint-review | [PMB-8](mention://issue/a23565b6-2524-4a70-b954-bf43e402973a) |
| CH-06 | `chapters/CH-06-API设计原则与常见问题.md` | drafting | [PMB-12](mention://issue/2d617b72-67ff-4d9d-af1f-678aae6e05ec) |
| CH-09 | `chapters/CH-09-活动定义与流程架构.md` | drafting | [PMB-15](mention://issue/5f0daa79-819d-4583-ab69-6c757af1c826) |
| CH-12 | `chapters/CH-12-权限基础.md` | drafting | [PMB-18](mention://issue/4b9071f4-605c-4ac1-92fe-a17633dcda89) |

## 章节状态定义

| 状态 | 含义 | 责任 Agent | 对应 Issue 状态 |
|------|------|-----------|----------------|
| `planned` | 已规划，未创建 Issue | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | — |
| `issue-created` | Issue 已创建，含验收标准 | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | open |
| `researching` | 素材搜索中 | [@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c) | researching |
| `drafting` | 初稿写作中 | [@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2) | drafting |
| `lint-review` | Lint 检查中 | [@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c) | reviewing |
| `content-review` | 内容验收中 | [@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c) | reviewing |
| `revision` | 修订中（审核未通过） | [@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2) | drafting |
| `approved` | 终审通过 | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | approved |
| `committed` | 已提交 Git | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | committed |
| `published` | 已发布/已关闭 | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | closed |

> 状态流转规则详见 `process/issue-protocol.md` 和 `multica/agents/manifest.yaml`

## 修改规则

- **新增章节**：创建文件 → 更新本文件「章节目录」表 → 更新根 `../README.md` 进度
- **修改已审核章节**：须重新走 review-quality 流程（`../multica/skills/review-quality.md`）
- **图示变更**：须检查并更新引用该图示的章节
- **案例变更**：须检查并更新引用该案例的章节及 `../assets/cases/`
