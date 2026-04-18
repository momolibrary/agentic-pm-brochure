# Multica 工作流一致性改进方案

> 基于全仓库审计，识别出 14 项问题，按严重程度分级，附修复方案

---

## 审计摘要

| 严重程度 | 数量 | 说明 |
|---------|------|------|
| 🔴 Critical | 4 | 阻断工作流执行 |
| 🟠 High | 5 | 工作流会逐步退化 |
| 🟡 Medium | 3 | 质量会随时间腐蚀 |
| 🔵 Low | 2 | 有则更好 |

---

## 🔴 Critical — 阻断工作流执行

### C1. Agent/Skill 无 mention ID，multica 无法路由

**现状**：所有配置文件中 mention 语法均为纯文本 `@editor-chief`、`@reviewer` 等。multica CLI 要求 mention 使用注册 ID，纯文本 `@` 无法被解析和路由。

**影响**：multica 执行任何跨 Agent 流转都会失败。

**问题文件**：
- `multica/agents/*.md`（6 个 Agent 文件的「协作语法」段）
- `multica/skills/*.md`（7 个 Skill 文件的「Mention 语法」段）
- `multica/workflows/workflow-config.md`（Agent 协作语法段）
- `multica/CLAUDE.md`（快速索引表「调用示例」列）

**修复方案**：

新建 `multica/agents/manifest.yaml` 作为 Agent 注册表（单一事实源）：

```yaml
# multica/agents/manifest.yaml — Agent 注册表
# multica CLI 通过此文件解析 mention 路由

workspace:
  name: pm-brochure
  id: "38f948e7-3827-40d0-b3ea-519c39440bf7"

agents:
  - id: editor-chief
    name: 主编
    file: editor-chief.md
    skills: [review-quality, term-lookup, lint-check]
    mention: "@editor-chief"

  - id: author-draft
    name: 作者
    file: author-draft.md
    skills: [chapter-draft, term-lookup]
    mention: "@author-draft"

  - id: reviewer
    name: 审稿人
    file: reviewer.md
    skills: [lint-check, review-quality, term-lookup]
    mention: "@reviewer"

  - id: researcher
    name: 研究员
    file: researcher.md
    skills: [research-search]
    mention: "@researcher"

  - id: case-writer
    name: 案例师
    file: case-writer.md
    skills: [case-develop]
    mention: "@case-writer"

  - id: illustrator
    name: 插画师
    file: illustrator.md
    skills: [diagram-create]
    mention: "@illustrator"

skills:
  - id: chapter-draft
    file: ../skills/chapter-draft.md
  - id: review-quality
    file: ../skills/review-quality.md
  - id: lint-check
    file: ../skills/lint-check.md
  - id: term-lookup
    file: ../skills/term-lookup.md
  - id: case-develop
    file: ../skills/case-develop.md
  - id: diagram-create
    file: ../skills/diagram-create.md
  - id: research-search
    file: ../skills/research-search.md
```

同时需要在每个 Agent 文件头部增加 YAML frontmatter：

```yaml
---
agent_id: editor-chief
mention: "@editor-chief"
skills: [review-quality, term-lookup, lint-check]
---
```

每个 Skill 文件头部增加：

```yaml
---
skill_id: chapter-draft
callers: [author-draft]
---
```

**变更清单**：
1. 新建 `multica/agents/manifest.yaml`
2. 更新 6 个 Agent 文件 — 增加 frontmatter
3. 更新 7 个 Skill 文件 — 增加 frontmatter
4. 更新 `multica/CLAUDE.md` — 引用 manifest.yaml 为权威源
5. 更新 `multica/agents/CLAUDE.md` — 说明 manifest 为注册表

---

### C2. 10 要素结构定义不一致（两个版本冲突）

**现状**：

`standards/CLAUDE.md` 的「关键约束摘要」中定义的 10 要素：
> 标题→引入场景→概念引出→核心讲解→类比解释→案例→常见误区→实操建议→延伸思考→章节小结

`style-guide.md` 和 `workflow-config.md` 和 `tdd-template.md` 中定义的 10 要素：
> 1.本章要解决什么问题 → 2.真实业务场景开场 → 3.核心概念解释 → 4.为什么PM容易误解 → 5.开发视角 → 6.PM应该如何做 → 7.AI如何辅助 → 8.本章checklist → 9.案例复盘 → 10.本章总结

**两个版本不同。** `style-guide.md` 版本更详细且有完整文风要求，应为权威版本。

**影响**：AI（特别是 Claude/Codex 读取 `standards/CLAUDE.md` 摘要时）会使用错误的 10 要素结构。

**修复方案**：修改 `standards/CLAUDE.md` 中的摘要，使其与 `style-guide.md` 完全一致：

```diff
- | 章节结构 | 10 要素（标题→引入场景→概念引出→核心讲解→类比解释→案例→常见误区→实操建议→延伸思考→章节小结） | style-guide.md |
+ | 章节结构 | 10 要素（问题定义→业务场景→核心概念→PM误解→开发视角→PM行动→AI辅助→Checklist→案例复盘→总结） | style-guide.md |
```

---

### C3. 人物角色描述混乱（3 个文件自相矛盾）

**现状**：

| 文件 | 老李描述 | 小想描述 |
|------|---------|---------|
| `project-definition.md`（权威源） | 40+岁高级产品总监 | 22岁实习生 |
| `term-glossary.md` | 40+岁资深产品总监 ✅ | 22岁实习生 ✅ |
| `CLAUDE.md`（根） | **资深工程师** ❌ | **产品经理** ❌ |
| `standards/CLAUDE.md` | **资深工程师，≥10年经验** ❌ | **产品经理，2-3年经验** ❌ |

根 `CLAUDE.md` 和 `standards/CLAUDE.md` 把老李的角色说反了（工程师→应为产品总监），小想的资历也写错了（2-3年→应为实习生）。

**影响**：AI 读取上层 CLAUDE.md 后会用错误人设写作，与 `project-definition.md` 中深度定义的角色设定冲突。

**修复方案**：

`CLAUDE.md`（根）修改：
```diff
- **角色**：老李（资深工程师）和小想（产品经理），角色设定不可改动
+ **角色**：老李（40+岁产品总监，经验丰富不写代码）和小想（22岁实习生，AI原生代），角色设定不可改动（权威定义见 project-definition.md）
```

`standards/CLAUDE.md` 修改：
```diff
- | 老李人设 | 资深工程师，≥10 年经验，耐心但直接 | term-glossary.md |
- | 小想人设 | 产品经理，2-3 年经验，聪明但缺工程常识 | term-glossary.md |
+ | 老李人设 | 40+岁产品总监，≥15 年经验，不会写代码，靠判断力和全局观 | project-definition.md / term-glossary.md |
+ | 小想人设 | 22 岁实习生，AI 原生代，敢动手但缺经验和判断力 | project-definition.md / term-glossary.md |
```

---

### C4. lint-rules.yaml 不是可解析的 YAML

**现状**：`standards/lint-rules.yaml` 实际上是一个 Markdown 文件（含 `#` 标题、正文描述、YAML 代码块嵌套），后缀虽为 `.yaml` 但无法被任何 YAML 解析器解析。

**影响**：
- 无法实现自动化 lint（文件不可解析）
- `lint-check` skill 声称"加载 lint 规则配置"，但实际无法程序化加载
- Codex / multica 无法将其作为结构化配置使用

**修复方案**：拆分为两个文件：

1. `standards/lint-rules.yaml` — 纯 YAML，可被工具解析：
```yaml
version: "0.1"
rules:
  style:
    sentence-length:
      threshold: 30
      severity: warning
    no-empty-phrases:
      patterns: ["非常重要", "十分关键", "极其重要", "必不可少", "不可或缺"]
      severity: warning
    humor-meter:
      target: moderate
      severity: info
    no-redundancy:
      severity: warning
  terminology:
    term-consistency:
      glossary: standards/term-glossary.md
      severity: error
    term-defined:
      severity: error
    no-tech-jargon:
      glossary: standards/term-glossary.md
      severity: warning
  structure:
    chapter-structure:
      elements: 10
      severity: error
    cross-reference:
      severity: warning
  execution:
    run_on: [chapter_draft_complete, chapter_review, before_git_commit]
```

2. `standards/lint-rules-guide.md` — 人类可读的规则说明文档（当前文件内容迁移至此）。

---

## 🟠 High — 工作流会逐步退化

### H1. Issue-Based 开发无强制机制

**现状**：TDD 工作流声称 "Issue 驱动"，但：
- `tdd-template.md` 末尾有 Issue 模板，但未定义 Issue 存储位置（GitHub Issues? 本地 Markdown?）
- 无 Issue 编号规范（`ISS-001`?）
- 无 Issue 状态机（Open→In Progress→Review→Done）
- 无 Issue 与 Git commit 的关联规范
- 章节目录表（`manuscript/CLAUDE.md`）有 `TDD Issue` 列但为空

**影响**：没有 Issue 强制机制，任何 Agent/人类都可以跳过 TDD 直接写稿，"先定义验收标准再写内容"会沦为口号。

**修复方案**：

1. 新建 `process/issue-protocol.md`：

```markdown
# Issue 管理协议

## Issue 存储
- 正式 Issue 使用 GitHub Issues
- 每个 Issue 必须包含 TDD 验收标准（模板：multica/workflows/tdd-template.md）

## Issue 编号
- 格式：`CH-XX`（章节 Issue）、`FIX-XX`（修订 Issue）、`META-XX`（流程/标准变更 Issue）
- 编号自增，不可复用

## Issue 状态流转
- `open` → `researching` → `drafting` → `reviewing` → `approved` → `committed` → `closed`
- 每个状态变更必须由对应 Agent 执行

## Issue → Git 关联
- commit message 格式：`[CH-01] 章节初稿完成` 或 `[FIX-03] 术语修正`
- branch 命名：`ch-01/initial-draft`、`fix-03/term-correction`

## 门禁规则（Gating）
- 无 Issue 不得创建章节文件
- Issue 无验收标准不得开始写作
- 未通过 review-quality 不得关闭 Issue
```

2. 在 `multica/workflows/workflow-config.md` 中增加 Issue 协议引用
3. 在 `editor-chief.md` 中增加 Issue 创建/关闭的门禁检查

---

### H2. process/ 目录为空 — 无 SOP 定义

**现状**：`process/` 目录存在但完全为空，无任何过程定义文档。

**影响**：工作流的 SOP（标准操作程序）散落在各 CLAUDE.md 和 workflow-config.md 中，无统一入口。当换工具（Claude→Codex→multica）时，没有一个人类可读、工具无关的流程文档。

**修复方案**：在 `process/` 下建立以下文件：

```
process/
├── issue-protocol.md        # Issue 管理协议（H1）
├── git-convention.md         # Git 提交/分支规范（H3）
├── quality-gate.md           # 质量门禁定义
└── tool-compatibility.md     # 多工具兼容协议（H4）
```

---

### H3. Git 工作流未定义

**现状**：`editor-chief.md` 声明有"Git 提交决策"权限，`workflow-config.md` 流程图以"Git 提交"结束，但：
- 无 branch 策略
- 无 commit message 规范
- 无 PR/MR 流程
- 无 Issue → commit 关联

**影响**：多人/多 Agent 协作时 Git 历史混乱，无法追溯变更原因。

**修复方案**：新建 `process/git-convention.md`：

```markdown
# Git 提交规范

## 分支策略
- `main` — 已审核通过的内容
- `ch-XX/描述` — 章节开发分支
- `fix-XX/描述` — 修订分支

## Commit Message
- 格式：`[ISSUE-ID] 动作描述`
- 示例：`[CH-01] 完成初稿写作`、`[CH-01] lint修复：术语不一致`

## PR 流程
- 章节完成后提 PR → reviewer 审核 → editor-chief 终审 → merge to main

## 门禁
- PR 必须关联 Issue
- PR 必须通过 lint-check
- PR 必须通过 review-quality
```

---

### H4. 多工具兼容性未定义

**现状**：项目可能被 Claude Code、Codex、multica CLI 等不同工具执行。但：
- `workflow-config.md` 绑定了 Claude Code 的 Runtime ID
- CLAUDE.md 文件只对 Claude 有效，Codex 不读取
- multica 需要 manifest.yaml，Claude 不需要
- 无工具切换时的行为定义

**影响**：换工具后工作流立即腐化。

**修复方案**：新建 `process/tool-compatibility.md`：

```markdown
# 多工具兼容协议

## 原则
- 单一事实源：所有规则定义在 standards/ 和 process/ 中，不在工具配置中重复
- CLAUDE.md 系列为 Claude Code/Claude 专属索引，不包含规则本身
- manifest.yaml 为 multica 专属注册表
- 所有工具均须遵守 process/ 和 standards/ 中的规范

## 工具适配层

| 工具 | 入口文件 | 读取路径 |
|------|---------|---------|
| Claude Code | CLAUDE.md（层级） | CLAUDE.md → 子级 CLAUDE.md → 具体文件 |
| multica CLI | multica/agents/manifest.yaml | manifest → agent/*.md → skills/*.md |
| Codex | AGENTS.md（如需） | AGENTS.md → process/ → standards/ |
| 人类 | README.md | README → process/ → standards/ |

## 防腐化检查清单
- [ ] 修改规则后，检查所有工具入口是否同步
- [ ] 新增 Agent/Skill 后，更新 manifest.yaml + CLAUDE.md
- [ ] 换工具前，用 manifest.yaml 验证 Agent 注册完整性
```

---

### H5. 工作流无状态追踪机制

**现状**：`manuscript/CLAUDE.md` 有章节目录表（含状态列），但：
- 无定义状态有哪些值
- 无定义谁负责更新状态
- 无定义状态与 Issue 的关系

**影响**：无法知道某个章节当前处于流水线的哪个位置。

**修复方案**：在 `manuscript/CLAUDE.md` 中增加状态定义：

```markdown
## 章节状态定义

| 状态 | 含义 | 责任 Agent | 对应 Issue 状态 |
|------|------|-----------|----------------|
| `planned` | 已规划，未创建 Issue | editor-chief | — |
| `issue-created` | Issue 已创建，含验收标准 | editor-chief | open |
| `researching` | 素材搜索中 | researcher | researching |
| `drafting` | 初稿写作中 | author-draft | drafting |
| `lint-review` | Lint 检查中 | reviewer | reviewing |
| `content-review` | 内容验收中 | reviewer | reviewing |
| `revision` | 修订中（未通过审核） | author-draft | drafting |
| `approved` | 终审通过 | editor-chief | approved |
| `committed` | 已提交 Git | editor-chief | committed |
| `published` | 已发布 | editor-chief | closed |
```

---

## 🟡 Medium — 质量会随时间腐蚀

### M1. Skill 对外部工具依赖未声明

**现状**：
- `researcher.md` / `research-search.md` 依赖 Tavily 搜索，但无 API 配置说明
- `illustrator.md` / `diagram-create.md` 提到 "glm-image 或其他工具"，但无具体配置
- 这些外部依赖不在 `manifest.yaml` 或任何配置中声明

**影响**：换环境/换操作者时，外部工具不可用但无提示。

**修复方案**：在 `manifest.yaml` 的 skill 段增加 `external_deps` 字段：

```yaml
skills:
  - id: research-search
    file: ../skills/research-search.md
    external_deps:
      - tool: tavily
        required: true
        config_ref: "环境变量 TAVILY_API_KEY"
  - id: diagram-create
    file: ../skills/diagram-create.md
    external_deps:
      - tool: glm-image
        required: false
        fallback: "mermaid markdown"
```

---

### M2. 标准文件无版本变更日志

**现状**：`style-guide.md`、`term-glossary.md`、`lint-rules.yaml` 底部都有 `版本: v0.1`，但无变更日志。

**影响**：标准文件被修改后，已写章节是否需要回溯适配无从判断。

**修复方案**：每个标准文件底部增加 Changelog 段：

```markdown
## Changelog

| 版本 | 日期 | 变更内容 | 影响范围 |
|------|------|---------|---------|
| v0.1 | 2026-04-18 | 初始版本 | — |
```

---

### M3. 单一职责边界需明确注释

**现状**：Agent 和 Skill 各自有职责描述，但某些边界模糊：
- `editor-chief` 既分配任务又做终审（PM 和 QA 双角色）— 可接受但需声明
- `reviewer` 持有 3 个 Skill（lint-check、review-quality、term-lookup）— 均为质量类，合理
- `chapter-draft` skill 声称依赖 `case-develop`，但 `author-draft` agent 并未绑定 `case-develop` — 依赖链断裂

**具体问题**：
- `chapter-draft.md` 的依赖段写了 `case-develop: 案例引用`
- 但 `author-draft.md` 只绑定了 `[chapter-draft, term-lookup]`，无 `case-develop`
- 这意味着 author-draft 写稿时需要案例，但自己调不了 case-develop

**修复方案**：

方案 A（保持现状，明确协作）：在 `chapter-draft.md` 中明确案例来源是通过工作流由 `case-writer` 提前准备，而非运行时调用：
```diff
## 依赖
- `term-lookup`：术语查询
- - `case-develop`：案例引用
+ - 案例素材：由 `@case-writer` 在写作阶段前准备，存放于 `assets/cases/` 或 `manuscript/cases/`
```

方案 B（扩展绑定）：给 `author-draft` 增加 `case-develop` 能力绑定。
**推荐方案 A**，维持单一职责。

---

## 🔵 Low — 有则更好

### L1. 工作流缺少异常/回退处理

**现状**：工作流是一条线性的 happy path（Issue→研究→写作→审核→终审→提交），无定义：
- lint-check 不通过怎么回退？
- review-quality 不通过重新走哪一步？
- 研究员搜不到素材怎么办？

**修复方案**：在 `workflow-config.md` 的流程图中增加回退路径和最大重试次数：

```
reviewer 审核不通过 → 返回 author-draft 修订（最多 3 轮）
reviewer lint 不通过 → 返回 author-draft 修复（最多 2 轮）
researcher 无素材 → editor-chief 决策：降级/换主题/人工补充
3 轮修订后仍不通过 → 升级至 editor-chief + 人工介入
```

---

### L2. 缺少工作流执行日志规范

**现状**：无定义各阶段的输出应存储在哪里、以什么格式记录。

**修复方案**：建议在 `process/` 下定义日志规范，或在 `manuscript/` 下为每个章节创建 `ch-XX-log.md` 记录执行历史。

---

## 执行优先级与依赖关系

> ✅ 全部已完成（2026-04-18）

```
Phase 1 — 基础设施修复 ✅
├── C1. ✅ 创建 manifest.yaml + Agent/Skill frontmatter
├── C2. ✅ 修复 standards/CLAUDE.md 10 要素描述
├── C3. ✅ 修复 CLAUDE.md + standards/CLAUDE.md 人物描述
└── C4. ✅ 拆分 lint-rules.yaml → 纯 YAML + lint-rules-guide.md

Phase 2 — 流程补全 ✅
├── H1. ✅ 创建 process/issue-protocol.md
├── H2. ✅ 填充 process/ 目录（含 quality-gate.md）
├── H3. ✅ 创建 process/git-convention.md
├── H4. ✅ 创建 process/tool-compatibility.md
└── H5. ✅ 在 manuscript/CLAUDE.md 增加状态定义

Phase 3 — 防腐化加固 ✅
├── M1. ✅ manifest.yaml 增加外部依赖声明
├── M2. ✅ 标准文件增加 changelog
├── M3. ✅ 修复 chapter-draft 依赖链
├── L1. ✅ 工作流增加回退路径（workflow-config.md）
└── L2. ✅ 定义执行日志规范（workflow-config.md）

所有 CLAUDE.md 引用已同步更新 ✅
```

---

## 附录：交叉引用一致性检查表

以下为审计中发现的所有文件间引用，标注一致（✅）或不一致（❌）：

| 引用关系 | 状态 | 说明 |
|---------|------|------|
| `multica/CLAUDE.md` Agent 表 ↔ `agents/CLAUDE.md` 清单 | ✅ | 6 Agent 一致 |
| `multica/CLAUDE.md` Skill 表 ↔ `skills/CLAUDE.md` 清单 | ✅ | 7 Skill 一致 |
| `workflow-config.md` Agent 表 ↔ `agents/CLAUDE.md` | ✅ | 一致 |
| `workflow-config.md` Skill 表 ↔ `skills/CLAUDE.md` | ✅ | 一致 |
| Agent 绑定 Skill ↔ Skill 声明调用者 | ✅ | 双向一致 |
| `editor-chief.md` Skill 绑定 ↔ 总表 | ✅ | review-quality, term-lookup, lint-check |
| `author-draft.md` Skill 绑定 ↔ 总表 | ✅ | chapter-draft, term-lookup |
| `chapter-draft.md` 依赖 ↔ `author-draft.md` 能力 | ❌ | **chapter-draft 声称依赖 case-develop，但 author-draft 未绑定**（M3） |
| `standards/CLAUDE.md` 10 要素摘要 ↔ `style-guide.md` | ❌ | **两个版本不同**（C2） |
| `CLAUDE.md` 人物角色 ↔ `project-definition.md` | ❌ | **角色描述错误**（C3） |
| `standards/CLAUDE.md` 人物角色 ↔ `term-glossary.md` | ❌ | **角色描述错误**（C3） |
| `workflow-config.md` 流程图 ↔ `workflows/CLAUDE.md` 概要 | ✅ | 步骤一致 |
| `lint-rules.yaml` 规则 ↔ `lint-check.md` 检查项 | ✅ | 规则名一致 |
| `tdd-template.md` 结构检查 ↔ `style-guide.md` 10 要素 | ✅ | 一致 |
| Skill 依赖标准文件 ↔ 文件实际存在 | ✅ | 四文件均存在 |

---

*审计日期：2026-04-18*
*适用范围：agentic-pm-brochure 全仓库*
