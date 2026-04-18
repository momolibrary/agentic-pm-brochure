# 产品经理的软件工程认知书

> 帮助产品经理获得"最小必要软件工程素养"，在AI时代成为懂交付的产品负责人。

## 项目定位

这是一本写给产品经理的软件工程认知书，目标不是把产品经理培养成程序员，而是帮助他们获得做产品设计、方案判断、需求协同、交付把控所需的最小必要软件工程能力。

## 项目结构

```
agentic-pm-brochure/
├── docs/                    # 项目文档
│   └── project-definition.md # 项目定义（一页纸）
├── manuscript/              # 书稿本体
│   ├── chapters/            # 章节正文
│   ├── cases/               # 章节案例
│   └── diagrams/            # 图示素材
├── standards/               # 质量标准体系
├── process/                 # 写作与审核流程
├── assets/                  # 素材库
│   ├── cases/               # 案例库
│   ├── analogies/           # 类比库
│   └── anti-patterns/      # 反例库
└── extensions/              # 延展资产
    ├── courses/            # 课程化内容
    ├── workshops/          # 工作坊设计
    └── diagnostics/        # 诊断问卷
```

## 交付物体系

本项目是一个完整的交付系统，包含5层成果：

1. **核心交付**：书稿本体（书名、目录、正文、案例、图示、术语表、索引、参考阅读）
2. **质量交付**：可审核的标准体系（读者定义、质量标准、术语规范、风格指南、审核流程）
3. **方法交付**：基于TDD的写作-审核机制（章节验收标准、审稿流程）
4. **延展交付**：课程化资产（配套课、训练营、讲义、工作坊、企业内训、诊断问卷、练习册）
5. **品牌交付**：个人IP资产（核心观点、方法框架、概念命名、案例系统、表达方式）

## 当前进度

### 基础设施（已完成）

- [x] 项目定义（`docs/project-definition.md`）
- [x] 读者画像与价值主张画布（`docs/价值主张画布.md`）
- [x] 知识点地图 V2.0（`docs/知识点地图.md`，三大域 20 模块 130+ 知识点，含批量写作并行度规划）
- [x] 文风指南（`standards/style-guide.md`，10 要素章节结构 + 文风规范）
- [x] 术语表（`standards/term-glossary.md`，50+ 术语定义）
- [x] Lint 规则体系（`standards/lint-rules.yaml` + `lint-rules-guide.md`）
- [x] Issue 管理协议（`process/issue-protocol.md`，6 状态流转 + 门禁规则）
- [x] Git 规范（`process/git-convention.md`）
- [x] 质量门禁（`process/quality-gate.md`，5 级质量门）
- [x] 产物交接协议（`process/artifact-handoff.md`）
- [x] AI 多智能体系统 multica（6 Agent + 7 Skill + 工作流编排）
- [x] TDD 验收标准模板（`multica/workflows/tdd-template.md`）

### 内容开发（待启动）

- [ ] 写作模板与 TDD 验收标准制定（为知识点地图的章节生成具体 Issue）
- [ ] 样章开发与验证（ch-01 试跑完整 TDD 工作流）
- [ ] 案例库建设（`assets/cases/`）
- [ ] 全书批量写作（50 章，11 批次并行）
- [ ] 统稿与结构优化
- [ ] 试读反馈与迭代

---

*项目启动日期：2026-04-18*