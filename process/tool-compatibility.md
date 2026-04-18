# 多工具兼容协议

> 确保在 Claude Code / Codex / multica CLI / 人工 等不同执行环境下，规则和流程不退化

---

## 核心原则

1. **单一事实源（SSOT）**：所有规则定义在 `standards/` 和 `process/` 中，不在工具配置中重复
2. **工具层是适配器**：CLAUDE.md、manifest.yaml 等只是不同工具的"入口索引"，不包含规则本身
3. **规则与工具解耦**：换工具时只需维护新入口，不需修改规则

## 工具适配层

| 工具 | 入口文件 | 读取路径 | 适用场景 |
|------|---------|---------|---------|
| Claude Code | `CLAUDE.md`（层级） | CLAUDE.md → 子级 CLAUDE.md → 具体文件 | 交互式写作、审稿 |
| multica CLI | `multica/agents/manifest.yaml` | manifest → agent/*.md → skills/*.md | 自动化工作流编排 |
| Codex | `AGENTS.md`（如需创建） | AGENTS.md → process/ → standards/ | 异步批量任务 |
| 人类 | `README.md` | README → process/ → standards/ | 人工审核、决策 |

## 各工具行为约束

### Claude Code
- 必须遵守分形文件修改协议（读取 CLAUDE.md 链）
- 修改文件前必须读取同目录 CLAUDE.md
- 不得跳过 TDD 验收标准直接写稿

### multica CLI
- 必须通过 `manifest.yaml` 注册的 UUID 路由消息
- Agent 间通信必须使用 `[@显示名](mention://agent/<uuid>) {任务}` 格式
- **纯文本 `@agent-name` 不会被 multica 路由**
- 状态流转必须符合 `manifest.yaml` 中定义的 transitions
- Issue 关联使用 `[WS-123](mention://issue/<issue-uuid>)` 格式

### Codex
- 必须在 task 描述中引用 Issue 编号
- 输出必须满足 `standards/lint-rules.yaml` 全部 error 级规则
- 不得自造术语（以 `standards/term-glossary.md` 为准）

### 人工操作
- 关键决策点必须人工确认（见 `multica/workflows/workflow-config.md` 人类确认点）
- 标准文件变更须走 META Issue 流程

## 防腐化检查清单

每次切换工具或长期停工后重启，执行以下检查：

### Agent/Skill 完整性
- [ ] `manifest.yaml` 中的 Agent ID 与 `multica/agents/*.md` 文件一一对应
- [ ] `manifest.yaml` 中的 Skill ID 与 `multica/skills/*.md` 文件一一对应
- [ ] 每个 Agent 文件的 frontmatter `agent_id` 与 manifest 一致
- [ ] 每个 Skill 文件的 frontmatter `skill_id` 与 manifest 一致

### 规则一致性
- [ ] `standards/CLAUDE.md` 摘要与 `style-guide.md`、`term-glossary.md`、`lint-rules.yaml` 一致
- [ ] `multica/CLAUDE.md` 索引与实际 Agent/Skill 文件一致
- [ ] 各 CLAUDE.md 的人物描述与 `docs/project-definition.md` 一致

### 流程完整性
- [ ] `process/issue-protocol.md` 的状态机与 `manifest.yaml` workflow 一致
- [ ] `process/git-convention.md` 的 commit 格式与 Issue 编号规则一致
- [ ] `multica/workflows/workflow-config.md` 的流程图与 `workflows/CLAUDE.md` 概要一致

## 新工具接入指南

接入新工具时：

1. 在本文件「工具适配层」表中新增行
2. 创建该工具的入口文件（如 `AGENTS.md`），内容为索引+路径指引，不包含规则本身
3. 在新入口文件中引用 `process/` 和 `standards/` 下的规范文件
4. 运行「防腐化检查清单」确认一致性
5. 通过 `META-XX` Issue 记录变更

---

*版本: v0.1*
*创建日期: 2026-04-18*
