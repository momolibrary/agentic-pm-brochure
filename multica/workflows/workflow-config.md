# Multica 编辑部工作流配置

> 基于 TDD 模式的人机协作书籍写作系统

---

## Workspace 信息

- **名称**: pm-brochure
- **ID**: `38f948e7-3827-40d0-b3ea-519c39440bf7`
- **项目仓库**: `/Users/tecson/Documents/github/agentic-pm-brochure`

---

## Agents（角色）

| Agent | 角色 | 负责工作 |
|-------|------|----------|
| `editor-chief` | 主编 | 任务分配、质量把控、最终审核、人类协作接口 |
| `author-draft` | 作者 | 章节初稿写作、内容生成 |
| `researcher` | 研究员 | 资料搜索、素材整理、类比挖掘 |
| `illustrator` | 插图师 | 图示绘制、流程图、架构图 |
| `reviewer` | 审稿人 | Lint检查、术语一致性、文风检查 |
| `case-writer` | 案例师 | 案例开发、反例设计、场景构建 |

---

## Skills（能力）

| Skill | 功能 | 使用者 |
|-------|------|--------|
| `chapter-draft` | 章节初稿写作 | author-draft |
| `research-search` | 资料搜索与整理 | researcher |
| `diagram-create` | 插图/流程图绘制 | illustrator |
| `lint-check` | 文风/术语一致性检查 | reviewer |
| `term-lookup` | 术语表查询与维护 | reviewer, author-draft |
| `review-quality` | 质量审核验收 | reviewer, editor-chief |
| `case-develop` | 案例开发与设计 | case-writer |

---

## TDD 写作流程

### 1. Issue 创建（人类或主编）

```
Issue: [章节名] - 初稿开发
├── 验收标准（测试用例）
│   ├── 必须回答的问题（3-5个）
│   ├── 读者读完后能做到的事（3件）
│   ├── 必须纠正的误解（2-3个）
│   └── 必须准确的概念（关键术语）
├── 素材需求
│   ├── 需要的案例
│   ├── 需要的类比
│   ├── 需要的图示
└── 风格要求
    ├── 幽默度（适度）
    ├── 技术深度（适中）
    └── 目标读者（P0/P1/P2）
```

### 2. 工作流执行

```
┌─────────────────────────────────────────────────────────────┐
│                    Issue 驱动工作流                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [创建 Issue]                                               │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────┐    ┌──────────┐    ┌───────────┐              │
│  │研究阶段 │───▶│写作阶段  │───▶│审核阶段   │              │
│  │researcher│    │author-   │    │reviewer   │              │
│  │         │    │draft     │    │           │              │
│  └─────────┘    └──────────┘    └───────────┘              │
│       │              │              │                       │
│       │              │              ▼                       │
│       │              │        ┌───────────┐                 │
│       │              │        │lint-check │                 │
│       │              │        │           │                 │
│       │              │        └───────────┘                 │
│       │              │              │                       │
│       │              ▼              ▼                       │
│       │        ┌──────────┐    ┌───────────┐                │
│       │        │插图阶段  │    │主编审核   │                │
│       │        │illustrator│    │editor-    │                │
│       │        │         │    │chief      │                │
│       │        └──────────┘    └───────────┘                │
│       │              │              │                       │
│       ▼              ▼              ▼                       │
│  ┌─────────────────────────────────────────┐                │
│  │           人类确认点                      │                │
│  │  - 内容方向确认                          │                │
│  │  - 术语使用确认                          │                │
│  │  - 风格调整确认                          │                │
│  │  - 最终发布确认                          │                │
│  └─────────────────────────────────────────┘                │
│                      │                                      │
│                      ▼                                      │
│               [关闭 Issue]                                  │
│               [提交 Git]                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3. Agent 协作语法（Mention）

multica 使用 Markdown 链接 + `mention://` scheme 路由消息。**纯文本 `@agent-name` 不会被路由。**

```
[@显示名](mention://agent/<agent-uuid>) [任务描述]
```

#### Agent Mention 速查表

| Agent | Mention |
|-------|---------|
| 主编 | `[@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c)` |
| 作者 | `[@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2)` |
| 审稿人 | `[@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c)` |
| 研究员 | `[@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c)` |
| 案例师 | `[@案例师](mention://agent/2eb4c3b6-d91c-4372-9245-61769ab1032b)` |
| 插画师 | `[@插画师](mention://agent/2f0e9417-105a-4607-8ee3-9dd26527f578)` |

#### Issue Mention

```
[WS-123](mention://issue/<issue-uuid>)
```

#### 示例

```
[@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c) 搜索"软件工程入门"相关资料
[@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2) 基于验收标准写作章节初稿
[@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c) 执行 lint-check 检查文风一致性
[@插画师](mention://agent/2f0e9417-105a-4607-8ee3-9dd26527f578) 绘制"需求到交付流程图"
[@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) 审核 chapter-01 初稿质量
```

> 完整 UUID 映射见 `agents/manifest.yaml`

---

## 异常回退与重试规则

工作流不是单向线性的。以下定义了每个阶段的回退路径和最大重试次数：

| 场景 | 回退目标 | 最大重试 | 升级条件 |
|------|---------|---------|---------|
| lint-check 不通过 | → [@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2) 修复 | 2 轮 | 2 轮后 [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) + 人工介入 |
| review-quality 不通过 | → [@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2) 修订 | 3 轮 | 3 轮后 [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) + 人工介入 |
| 素材不足 | → [@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c) 补搜 | 2 轮 | 2 轮后 [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) 决策：降级/换题/人工补充 |
| 终审不通过 | → Gate 4 重审 | 1 轮 | 直接人工介入 |

### 回退流程图

```
[@审稿人](mention://agent/6586d624-...) 审核
  ├── lint-check ❌ → [@作者](mention://agent/a054c330-...) 修复（≤2轮）→ 重新审核
  ├── review-quality ❌ → [@作者](mention://agent/a054c330-...) 修订（≤3轮）→ 重新审核
  └── 通过 ✅ → [@主编](mention://agent/7ba899bd-...) 终审
        ├── 终审 ❌ → 退回 [@审稿人](mention://agent/6586d624-...)（≤1轮）→ 人工介入
        └── 通过 ✅ → 人工确认 → Git 提交
```

> 门禁详细定义见 `process/quality-gate.md`

---

## 执行日志规范

每个章节开发过程中，在 `manuscript/reviews/` 下自动生成执行日志：

### 日志文件命名
```
manuscript/reviews/ch-XX-log.md
```

### 日志内容模板
```markdown
# CH-XX 执行日志

## Issue
- ID: [CH-XX]
- 创建日期: [日期]
- 状态: [当前状态]

## 执行记录
| 日期 | Agent | 动作 | 结果 | 备注 |
|------|-------|------|------|------|
| 2026-04-XX | [@主编](mention://agent/7ba899bd-...) | 创建 Issue | ✅ | 验收标准已确认 |
| 2026-04-XX | [@研究员](mention://agent/4828ea52-...) | 素材搜索 | ✅ | 3 篇素材入库 |
| 2026-04-XX | [@作者](mention://agent/a054c330-...) | 初稿写作 | ✅ | 提交审核 |
| 2026-04-XX | [@审稿人](mention://agent/6586d624-...) | lint-check | ❌ | 2 处术语不一致 |
| 2026-04-XX | [@作者](mention://agent/a054c330-...) | lint 修复 | ✅ | 重新提交 |
| 2026-04-XX | [@审稿人](mention://agent/6586d624-...) | review-quality | ✅ | 通过率 100% |
| 2026-04-XX | [@主编](mention://agent/7ba899bd-...) | 终审 | ✅ | 人类已确认 |

## 审核报告链接
- lint 报告: [链接]
- 验收报告: [链接]
```

---

## Lint 规则

### 文风检查

| 规则 | 说明 |
|------|------|
| `sentence-length` | 单句不超过30字（短句优先）|
| `no-empty-phrases` | 禁止空洞表达（"非常重要"、"十分关键"）|
| `humor-meter` | 幽默度检测（适度，不刻意）|
| `no-redundancy` | 消除重复内容 |

### 术语检查

| 规则 | 说明 |
|------|------|
| `term-consistency` | 术语使用一致性检查 |
| `term-defined` | 新术语必须在首次出现时定义 |
| `no-tech-jargon` | 避免未解释的技术术语 |

### 结构检查

| 规则 | 说明 |
|------|------|
| `chapter-structure` | 章节结构完整性（10要素）|
| `cross-reference` | 章节间引用一致性 |
| `case-complete` | 案例完整性检查 |

---

## 章节结构模板（10要素）

每个章节必须包含：

1. **本章要解决什么问题**
2. **一个真实业务场景开场**
3. **核心概念解释**
4. **为什么产品经理容易误解**
5. **开发视角如何看这个问题**
6. **产品经理应该如何做**
7. **AI可以如何辅助**
8. **本章 checklist**
9. **案例复盘**
10. **本章总结**

---

## Runtime 配置

使用 Claude Code runtime:
- Runtime ID: `8818eca1-d977-4112-9845-7e57dabbff10` (Claude - bogon)
- Provider: `claude`
- Runtime Mode: `local`

---

## 项目文件映射

```
agentic-pm-brochure/
├── multica/
│   ├── skills/           # Skill 定义文件
│   ├── agents/           # Agent 定义文件
│   └── workflows/        # 工作流定义
├── standards/
│   ├── lint-rules.yaml   # Lint 规则配置
│   ├── term-glossary.md  # 术语表
│   └── style-guide.md    # 文风指南
├── manuscript/
│   └── chapters/         # 章节文件
│       ├── chapter-01.md
│       ├── chapter-02.md
│       └── ...
```

---

*配置版本: v0.1*
*创建日期: 2026-04-18*