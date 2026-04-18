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

```
@agent-name [任务描述]
```

示例：
- `@researcher 搜索"软件工程入门"相关资料`
- `@author-draft 基于[验收标准]写作章节初稿`
- `@reviewer 执行 lint-check 检查文风一致性`
- `@illustrator 绘制"需求到交付流程图"`
- `@editor-chief 审核 chapter-01 初稿质量`

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