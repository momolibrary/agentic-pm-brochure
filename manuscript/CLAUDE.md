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
| CH-03 | `chapters/CH-03-数据建模与本体.md` | drafting | — |
| CH-04 | `chapters/CH-04-接口基础.md` | drafting | [PMB-10](mention://issue/4c7e34e3-4b4d-489f-bcde-6f2bfb2706da) |
| CH-05 | `chapters/CH-05-系统集成与边界.md` | drafting | — |
| CH-06 | `chapters/CH-06-API设计原则与常见问题.md` | drafting | [PMB-12](mention://issue/2d617b72-67ff-4d9d-af1f-678aae6e05ec) |
| CH-07 | `chapters/CH-07-流程基础.md` | committed | [PMB-13](mention://issue/7c9e28bc-8ca2-4759-9712-54317c057d7e) |
| CH-08 | `chapters/CH-08-异常流程与编排.md` | drafting | — |
| CH-09 | `chapters/CH-09-活动定义与流程架构.md` | drafting | [PMB-15](mention://issue/5f0daa79-819d-4583-ab69-6c757af1c826) |
| CH-10 | `chapters/CH-10-流程遵从性与挖掘困难.md` | drafting | — |
| CH-11 | `chapters/CH-11-流程治理与行业标准.md` | revision | [PMB-17](mention://issue/96d382df-42d5-487a-829d-cfcce1a6a597) |
| CH-12 | `chapters/CH-12-权限基础.md` | drafting | [PMB-18](mention://issue/4b9071f4-605c-4ac1-92fe-a17633dcda89) |
| CH-13 | `chapters/CH-13-数据权限与继承.md` | approved | [PMB-19](mention://issue/ab0f35c4-9a34-471e-a60c-e8600abf11f1) |
| CH-14 | `chapters/CH-14-权限框架与认证体系.md` | drafting | — |
| CH-15 | `chapters/CH-15-状态基础与约束.md` | approved | [PMB-21](mention://issue/fea4afe8-f5cd-4e0e-96f2-7e55fc4ab1e0) |
| CH-16 | `chapters/CH-16-状态冲突与状态机.md` | drafting | — |
| CH-17 | `chapters/CH-17-验收与测试.md` | approved | [PMB-23](mention://issue/ce802795-2c31-4127-bf4b-2e8b5c9b1175) |
| CH-18 | `chapters/CH-18-回归测试与监控.md` | drafting | — |
| CH-19 | `chapters/CH-19-DDD与TDD.md` | approved | [PMB-25](mention://issue/4fe430cd-8311-4f7d-a4a7-6cfa43cb2a51) |
| CH-20 | `chapters/CH-20-TOGAF企业架构与DevOps.md` | drafting | — |
| CH-21 | `chapters/CH-21-MVC架构模式与CQRS.md` | approved | [PMB-27](mention://issue/512b4cdd-8f13-4fa3-8f5d-81c2d75ef6b3) |
| CH-22 | `chapters/CH-22-IDE开发工具认知.md` | drafting | — |
| CH-23 | `chapters/CH-23-Git认知与版本控制基础.md` | drafting | [PMB-35](mention://issue/13376fa5-fd0b-4e0f-907b-8077c97ac110) |
| CH-24 | `chapters/CH-24-SSH服务器连接基础.md` | drafting | — |
| CH-25 | `chapters/CH-25-域名DNS证书与CDN.md` | drafting | — |
| CH-26 | `chapters/CH-26-云服务前后端与数据库缓存.md` | drafting | — |
| CH-27 | `chapters/CH-27-消息队列日志监控与API网关.md` | drafting | — |
| CH-28 | `chapters/CH-28-系统成本与切换代价.md` | drafting | [PMB-32](mention://issue/634a2e1b-3658-4f56-858d-317dc6c72795) |
| CH-29 | `chapters/CH-29-人力弹性与组织耦合.md` | drafting | — |
| CH-30 | `chapters/CH-30-需求结构化.md` | drafting | — |
| CH-31 | `chapters/CH-31-方案预演.md` | drafting | — |
| CH-32 | `chapters/CH-32-AI能力边界.md` | drafting | — |
| CH-33 | `chapters/CH-33-AI辅助实践.md` | drafting | — |
| CH-34 | `chapters/CH-34-质量把控.md` | drafting | [PMB-38](mention://issue/cc8e75b6-5233-490d-97f2-4b4b4216ca95) |
| CH-35 | `chapters/CH-35-协作沟通基础.md` | drafting | — |
| CH-36 | `chapters/CH-36-排期评审与Git-like协作.md` | drafting | — |
| CH-37 | `chapters/CH-37-Human-Agent协作模型.md` | drafting | — |
| CH-38 | `chapters/CH-38-价值主张画布与用户旅程图.md` | drafting | [PMB-41](mention://issue/7a318451-e1a0-4d69-86cf-b20e3a53cac0) |
| CH-39 | `chapters/CH-39-服务蓝图与商业模式画布.md` | drafting | [PMB-44](mention://issue/c232138d-076c-4aab-b060-af5e721c5547) |
| CH-40 | `chapters/CH-40-设计系统.md` | drafting | — |
| CH-41 | `chapters/CH-41-Git协作实操.md` | drafting | — |
| CH-42 | `chapters/CH-42-Agentic-Design基础.md` | drafting | — |
| CH-43 | `chapters/CH-43-AI上下文管理与审查重构.md` | drafting | — |
| CH-44 | `chapters/CH-44-综合案例从需求到交付.md` | drafting | [PMB-51](mention://issue/cf9d1aca-1f12-4e01-a831-b95e947a8340) |
| CH-45 | `chapters/CH-45-审批与权限实战.md` | drafting | [PMB-52](mention://issue/b5a14c1e-7fce-4446-884a-323c46da8560) |
| CH-46 | `chapters/CH-46-报表与状态实战.md` | drafting | [PMB-53](mention://issue/5259d27c-53b3-4959-b061-1398035d3233) |
| CH-47 | `chapters/CH-47-多系统集成实战.md` | drafting | — |
| CH-48 | `chapters/CH-48-案例复盘.md` | drafting | [PMB-55](mention://issue/a77ce704-9add-4d31-890c-e737f430b99c) |

## 章节状态定义

| 状态 | 含义 | 任 Agent | 对应 Issue 状态 |
|------|------|-----------|----------------|
| `planned` | 已规划，未创建 Issue | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | — |
| `issue-created` | Issue 已创建，含验收标准 | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | open |
| `skeleton` | 主编大纲骨架，待研究员补充 | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | in_progress |
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
