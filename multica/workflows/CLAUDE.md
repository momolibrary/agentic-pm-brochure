# multica/workflows/CLAUDE.md — 工作流配置

> 父级：[../CLAUDE.md](../CLAUDE.md) → [../../CLAUDE.md](../../CLAUDE.md)

## 概述

本目录包含项目的工作流配置和模板，定义了完整的 TDD 写作协作流程。

## 文件清单

| 文件 | 用途 | 何时加载 |
|------|------|---------|
| `workflow-config.md` | 工作流全局配置：Agent 表、Skill 表、流程图、协作语法、lint 摘要、异常回退规则、执行日志规范 | 了解协作流程 / 启动新任务时 |
| `tdd-template.md` | TDD 验收标准模板：YAML 模板、验证流程、验收报告模板、Issue 模板 | 创建章节任务 / 定义验收标准时 |

### 关联的 process 文件

| 文件 | 用途 | 何时加载 |
|------|------|---------|
| `../../process/issue-protocol.md` | Issue 编号、状态流转、门禁规则 | 创建/管理 Issue 时 |
| `../../process/git-convention.md` | 分支、commit、PR 规范 | Git 操作时 |
| `../../process/quality-gate.md` | 各阶段准入/准出条件 | 阶段切换时 |
| `../../process/tool-compatibility.md` | 多工具兼容协议 | 切换工具 / 防腐化检查时 |

## 核心流程概要

```
1. editor-chief 创建 Issue（含 TDD 验收标准 ← tdd-template.md）
2. researcher 搜索素材 → assets/
3. author-draft 写作初稿 → manuscript/chapters/
4. reviewer 执行 lint-check → 生成 lint 报告
5. illustrator 绘制图示 → manuscript/diagrams/
6. reviewer 执行 review-quality → 验收报告
7. editor-chief 终审 → 人工确认 → Git 提交
```

## 人工确认节点

工作流中有 5 个需要人工介入的决策点（定义于 `workflow-config.md` 中 `editor-chief` 的人机协作说明）：

1. Issue 验收标准确认
2. 素材方向确认
3. 初稿大方向确认
4. 终审通过/打回
5. 发布确认

## 修改规则

- 修改流程步骤须同步更新 `workflow-config.md` 中的流程图
- 修改 TDD 模板须检查 `../skills/review-quality.md` 的验证逻辑是否匹配
- 流程变更须通知所有相关 Agent 定义文件（`../agents/`）**及 `../agents/manifest.yaml` transitions 段**
- 新增工作流模板：创建文件 → 更新本文件清单
- 修改门禁/回退规则须同步 `../../process/quality-gate.md`
