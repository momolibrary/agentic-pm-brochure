# CLAUDE.md — 产品经理的软件工程认知书

## 项目概要

一本帮助产品经理获得"最小必要软件工程素养"的认知书。采用 TDD（测试驱动开发）方法论管理写作质量，配有完整的 AI 多智能体协作系统（multica）。

- 项目定义：`docs/project-definition.md`
- 许可证：AGPL-3.0
- 启动日期：2026-04-18

## 目录导航

| 目录 | 用途 | 子级 CLAUDE.md |
|------|------|---------------|
| `standards/` | 质量标准体系（文风指南、术语表、lint 规则） | `standards/CLAUDE.md` |
| `multica/` | AI 多智能体系统（agents / skills / workflows） | `multica/CLAUDE.md` |
| `manuscript/` | 书稿本体（章节 / 案例 / 图示） | `manuscript/CLAUDE.md` |
| `docs/` | 项目文档（项目定义） | — |
| `assets/` | 素材库（案例 / 类比 / 反例） | — |
| `extensions/` | 延展资产（课程 / 工作坊 / 诊断） | — |
| `process/` | 写作与审核流程（Issue协议、Git规范、质量门禁、工具兼容） | — |

## 渐进式加载协议

AI 进入本项目时，**按需逐层加载**，避免一次性加载全部上下文：

1. **总是先读本文件** — 获取全局视图、协作规约、修改协议
2. **按任务加载子级 CLAUDE.md** — 只加载与当前任务相关的目录说明
3. **按需加载具体文件** — 由子级 CLAUDE.md 指引到具体标准/定义文件

### 任务 → 加载路径速查

| 任务类型 | 加载路径 |
|---------|---------|
| 写章节 | `CLAUDE.md` → `standards/CLAUDE.md` → `multica/CLAUDE.md` → `manuscript/CLAUDE.md` |
| 审稿 | `CLAUDE.md` → `standards/CLAUDE.md` → `multica/skills/CLAUDE.md`（lint-check, review-quality） |
| 查术语 | `CLAUDE.md` → `standards/CLAUDE.md` → `standards/term-glossary.md` |
| 做图示 | `CLAUDE.md` → `multica/skills/CLAUDE.md` → `diagram-create.md` |
| 搜素材 | `CLAUDE.md` → `multica/skills/CLAUDE.md` → `research-search.md` |
| 开发案例 | `CLAUDE.md` → `standards/CLAUDE.md` → `multica/skills/CLAUDE.md` → `case-develop.md` |
| 了解流程 | `CLAUDE.md` → `multica/workflows/CLAUDE.md` → `workflow-config.md` |
| 修改 Agent | `CLAUDE.md` → `multica/CLAUDE.md` → `multica/agents/CLAUDE.md` → `manifest.yaml` → 具体 Agent 文件 |
| 创建 Issue | `CLAUDE.md` → `process/issue-protocol.md` → `multica/workflows/tdd-template.md` |
| Git 操作 | `CLAUDE.md` → `process/git-convention.md` |
| 质量检查 | `CLAUDE.md` → `process/quality-gate.md` → `standards/CLAUDE.md` |
| 换工具 | `CLAUDE.md` → `process/tool-compatibility.md` |
| multica 操作 | `CLAUDE.md` → `process/multica-cli.md`（双写规则、workspace ID、命令速查） |
| 审核远程 Agent 产物 | `CLAUDE.md` → `process/artifact-handoff.md` → `scripts/multica-review.sh` |

## 分形文件修改协议（Fractal Modification Protocol）

本项目采用**分形追溯机制**管理文件变更。每个目录的 CLAUDE.md 形成层级链，确保变更可追溯、规则可继承。

### 核心规则

1. **修改任何文件前**，读取同目录 CLAUDE.md（若存在）
2. **沿目录树向上**，逐级读取所有祖先 CLAUDE.md 至本文件
3. **规则继承**：子级规则细化父级规则，子级不得违反父级约束
4. **变更影响评估**：修改文件时，评估是否需要同步更新同级或子级 CLAUDE.md

### 追溯链示例

```
修改 multica/skills/chapter-draft.md 时：
  ① 读 multica/skills/CLAUDE.md   → 了解 Skill 定义规范
  ② 读 multica/CLAUDE.md           → 了解 Agent 系统全貌
  ③ 读 CLAUDE.md（本文件）          → 了解项目约束和协议
```

### 变更传播规则

| 变更类型 | 影响范围 | 必须更新 |
|---------|---------|---------|
| 新增文件 | 同级目录 | 同目录 CLAUDE.md（更新清单） |
| 修改标准文件 | 全项目 | 检查所有引用该标准的 CLAUDE.md |
| 新增 Agent/Skill | multica 体系 | `multica/agents/manifest.yaml` + `multica/CLAUDE.md` + 对应子目录 CLAUDE.md |
| 修改术语 | 全项目 | `standards/CLAUDE.md`（记录变更）+ 术语表 Changelog |
| 新增章节 | manuscript | `manuscript/CLAUDE.md`（更新目录） |
| 修改工作流 | multica 体系 | `multica/workflows/CLAUDE.md` + 受影响 Agent + `manifest.yaml` transitions |
| 修改流程规范 | process 体系 | `process/` 对应文件 + 检查 CLAUDE.md 摘要一致性 |

### CLAUDE.md 文件自身规范

每个子级 CLAUDE.md 应包含：
- `> 父级：` 行 — 指向父目录的 CLAUDE.md（形成追溯链）
- `## 文件清单` — 本目录下的文件及用途
- `## 修改规则` — 本目录特有的变更约束

## 全局约束

- **文风**：遵循 `standards/style-guide.md`
- **术语**：遵循 `standards/term-glossary.md`，禁止自造术语
- **质量**：所有书稿内容须通过 `standards/lint-rules.yaml` 检查
- **结构**：章节遵循 10 要素结构（详见 `standards/style-guide.md`）
- **角色**：老李（40+岁产品总监，经验丰富不写代码）和小想（22岁实习生，AI原生代），角色设定不可改动（权威定义见 `docs/project-definition.md`）
- **TDD**：写作采用测试驱动 — 先定义验收标准，再写内容
- **multica CLI**：`multica` 是本地命令行工具，不是文件夹。修改 Agent/Skill 后必须同时更新服务端（详见 `process/multica-cli.md`）

## 协作入口速查

```
写章节  → multica/workflows/workflow-config.md（完整流程）
查术语  → standards/term-glossary.md
审质量  → multica/skills/lint-check.md + review-quality.md
做图示  → multica/skills/diagram-create.md
找素材  → multica/skills/research-search.md
写案例  → multica/skills/case-develop.md
Issue管理 → process/issue-protocol.md
Git规范  → process/git-convention.md
质量门禁 → process/quality-gate.md
工具兼容 → process/tool-compatibility.md
multica CLI → process/multica-cli.md（命令行操作手册，双写规则，workspace 隔离）
Agent注册 → multica/agents/manifest.yaml
```
