# Git 提交与分支规范

> 确保变更可追溯、历史可读、Issue 可关联

---

## 分支策略

| 分支 | 用途 | 来源 | 合并目标 |
|------|------|------|---------|
| `main` | 已审核通过的正式内容 | — | — |
| `ch-XX/描述` | 章节开发 | `main` | `main`（via PR） |
| `fix-XX/描述` | 修订（审核退回后） | `ch-XX/*` 或 `main` | `main`（via PR） |
| `meta-XX/描述` | 流程/标准变更 | `main` | `main`（via PR） |
| `agent/<name>/<hash>` | multica 自动创建 | `main` | **不 merge，仅临时** |

### 分支生命周期

**分支是临时工作区，不是档案。** 合并后删除。

```
merge 后必须执行:
  git push origin --delete <branch>   # 删远端
  git branch -d <branch>              # 删本地
  git fetch --prune                   # 同步引用
```

详见 `process/artifact-handoff.md`「干净退出原则」。

### 分支命名示例

```
ch-01/initial-draft
ch-01/lint-fix-round2
fix-03/term-correction
meta-01/add-issue-protocol
```

## Commit Message 规范

### 格式

```
[ISSUE-ID] 动词 + 描述

可选: 多行正文说明
```

### 动词表

| 动词 | 用途 |
|------|------|
| 完成 | 阶段性交付（初稿完成、审核通过） |
| 修复 | 修正问题（lint 修复、术语修正） |
| 新增 | 新增内容（案例、图示、术语） |
| 更新 | 更新已有内容 |
| 调整 | 结构/格式/配置调整 |

### 示例

```
[CH-01] 完成初稿写作
[CH-01] 修复 lint-check 发现的 3 处术语不一致
[ASSET-01] 新增登录注册正例案例
[META-01] 新增 Issue 管理协议
```

## PR（Pull Request）流程

### 创建 PR 条件
- [ ] 关联 Issue 编号
- [ ] lint-check 通过（无 error 级问题）
- [ ] 自查 checklist 完成

### PR 审核流程

```
author-draft 提交 PR
  → [@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c) lint-check + review-quality
    → 通过 → [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) 终审
      → 通过 → 人类确认 → merge to main
    → 不通过 → 退回修订（标注具体问题）
```

### PR 标题格式

```
[ISSUE-ID] PR 描述
```

### Merge 策略
- 使用 **Squash Merge**，保持 main 历史简洁
- Squash commit message 沿用 `[ISSUE-ID] 描述` 格式

## 门禁

- PR 必须关联 Issue
- PR 必须通过 lint-check（无 error）
- PR 必须通过 review-quality
- PR 必须有至少一个 reviewer 审核
- 合并到 main 须 editor-chief 批准

---

*版本: v0.1*
*创建日期: 2026-04-18*
