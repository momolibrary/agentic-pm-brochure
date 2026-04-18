# 制品交接协议（Artifact Handoff Protocol）

> 解决跨服务器 Agent-Human 协作中"看不见改了什么"的问题

---

## 问题定义

multica 远程 Agent 在自己的 worktree（`/multica_workspaces/<ws-id>/<hash>/workdir/`）中修改文件后：
- 人类本地 clone **看不到变更**
- Issue comment 只有文字描述，没有可审核的 diff
- 违反 TDD 原则：验收无法基于实际产物进行

## 核心原则

1. **Git 是制品总线**：所有可审核的产物必须通过 git 分支传递，不走口头描述
2. **结构化交接评论**：Agent 完成后在 Issue 中发布机器可解析的 Handoff Comment
3. **附件兜底**：非 git 管理的产物（图片、临时分析等）通过 `--attachment` 上传
4. **人类侧一键拉取**：提供 `multica-review` 脚本，自动拉取分支并展示 diff

---

## 交接通道

### 通道 A：Git 分支（主通道，适用于仓库内文件）

```
Agent worktree ──git push──→ remote branch ──git fetch──→ Human local clone
```

**Agent 侧**：
1. 在 worktree 中完成文件修改
2. 创建分支：`<issue-id>/<agent-name>/deliverable`（如 `ch-01/author-draft/deliverable`）
3. `git add → git commit → git push origin <branch>`
4. 在 Issue 中发布 **Handoff Comment**（格式见下节）

**Human 侧**：
1. 看到 Handoff Comment 通知
2. 执行 `./scripts/multica-review.sh <issue-id>`（或手动 `git fetch && git diff`）
3. 审核 → 通过则 merge，不通过则在 Issue 中评论退回

### 通道 B：附件上传（兜底通道，适用于非 git 产物）

```
Agent filesystem ──attachment──→ multica server ──download──→ Human local
```

**Agent 侧**：
```bash
multica issue comment add <issue-id> \
  --attachment /path/to/diagram.png \
  --attachment /path/to/analysis.md \
  --content "交接：附件包含流程图和分析文档"
```

**Human 侧**：
```bash
# 从 issue comment 中获取 attachment-id
multica issue comment list <issue-id> --output json | jq '.[0].attachments'
# 下载
multica attachment download <attachment-id> -o ./review/
```

---

## Handoff Comment 格式

Agent 完成工作后，**必须**在 Issue 中发布如下格式的评论：

````markdown
## 🔀 Handoff: <简要描述>

**分支**: `ch-01/author-draft/deliverable`
**提交**: `a1b2c3d` — <commit message>
**基底**: `main@e4f5g6h`

### 变更文件
| 文件 | 操作 | 行数 |
|------|------|------|
| manuscript/chapters/ch-01.md | 新增 | +320 |
| assets/cases/login-case.md | 新增 | +85 |
| standards/term-glossary.md | 修改 | +3/-1 |

### 附件（如有）
- `diagram-ch01-flow.png` (attachment: <attachment-id>)

### 自检清单
- [x] lint-check 通过
- [x] 术语与 term-glossary.md 一致
- [x] 10 要素结构完整
- [ ] 待人类确认：第三节类比是否恰当

### 审核请求
请 [@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c) 审核，
或人类直接 `git diff main...ch-01/author-draft/deliverable` 查看。
````

### 格式要求

- **`## 🔀 Handoff:`** 前缀是必须的，用于机器解析识别
- **分支名**和**提交 SHA** 是必填字段
- **变更文件表**至少列出主要文件（可省略 trivial 变更）
- **自检清单**映射到 `process/quality-gate.md` 的对应门禁

---

## 人类侧审核流程

### 快速审核（命令行）

```bash
# 1. 拉取远程分支
git fetch origin

# 2. 查看 diff 概要
git diff --stat main...origin/ch-01/author-draft/deliverable

# 3. 查看完整 diff
git diff main...origin/ch-01/author-draft/deliverable

# 4a. 通过 → merge
git merge origin/ch-01/author-draft/deliverable
multica issue comment add <issue-id> --content "审核通过，已 merge。"

# 4b. 不通过 → 退回
multica issue comment add <issue-id> --content "退回修订：第三节类比不恰当，建议改用 XX 场景。"
multica issue status <issue-id> drafting
```

### 自动化审核（脚本）

```bash
./scripts/multica-review.sh <issue-id>
```

脚本自动完成：获取分支名 → fetch → diff → 交互式确认。

---

## 双向同步协议

不只 Agent→Human，也包括 Human→Agent：

### Human → Agent（修订反馈→重新执行）

```
Human 在 Issue comment 中写退回理由
  → multica 将 issue 重新分配给 Agent（status → drafting）
  → Agent 重新 checkout，看到最新 main + 退回评论
  → Agent 修改 → 新 commit → 新 Handoff Comment
```

### Agent → Agent（跨 Agent 交接）

```
Agent A 完成研究，push 素材到 branch
  → Handoff Comment mention Agent B
  → Agent B checkout 同一个 branch 继续工作
  → Agent B 完成后发新的 Handoff Comment
```

示例（研究员→作者的交接）：
```markdown
## 🔀 Handoff: CH-01 素材准备完成

**分支**: `ch-01/researcher/material`
**提交**: `f7g8h9i` — 新增 3 篇案例素材

请 [@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2) 基于此分支开始初稿写作。
建议先 merge 到 `ch-01/author-draft/deliverable` 再开工。
```

---

## 分支命名规范

与 `process/git-convention.md` 对齐，扩展 Agent 交接场景：

| 模式 | 示例 | 用途 |
|------|------|------|
| `<issue-id>/<agent>/deliverable` | `ch-01/author-draft/deliverable` | Agent 交付分支 |
| `<issue-id>/<agent>/material` | `ch-01/researcher/material` | 素材准备分支 |
| `<issue-id>/<agent>/fix-round<n>` | `ch-01/author-draft/fix-round2` | 修订轮次分支 |
| `<issue-id>/review` | `ch-01/review` | 审核专用分支（合并多人产物） |

---

## 异常处理

### Agent 无法 push（repo 不在 cache 中）

```
multica repo checkout <url> 失败
  → Agent 改用附件通道：将文件作为 --attachment 上传
  → Handoff Comment 标注 "⚠️ 附件模式：无法 push，请手动合入"
  → 人类 download 后手动 commit
```

### 网络中断导致 push 失败

```
Agent 保存 git bundle 作为 attachment 上传
  → multica issue comment add <issue-id> --attachment /tmp/deliverable.bundle
  → 人类: git bundle unbundle deliverable.bundle
```

### 分支冲突

```
Agent 发现目标分支已有冲突
  → 不自行 force push
  → 在 Handoff Comment 中标注 "⚠️ 需要人类解决冲突"
  → 同时上传 .patch 文件作为 attachment 兜底
```

---

## 与现有流程的整合

### TDD 流程中的交接点

```
open → researching ──[Handoff A]──→ drafting ──[Handoff B]──→ reviewing ──[Handoff C]──→ approved
         研究员                        作者                      审稿人
       push 素材分支              push 初稿分支              评论审核结果
       Handoff Comment           Handoff Comment            通过/退回
```

| TDD 阶段 | 交接方向 | 通道 | Handoff 必填 |
|-----------|---------|------|-------------|
| researching → drafting | 研究员 → 作者 | Git 分支 | 分支名 + 素材文件表 |
| drafting → reviewing | 作者 → 审稿人 | Git 分支 | 分支名 + 自检清单 |
| reviewing → approved | 审稿人 → 主编 | Issue comment | 审核结论 + 问题列表 |
| reviewing → drafting | 审稿人 → 作者 | Issue comment | 退回理由 + 修改建议 |
| approved → committed | 主编 → 人类 | Git 分支 | merge 请求 |

### 质量门禁扩展

在 `process/quality-gate.md` 各门禁中增加：

- **Gate 2 (素材完整)**: 研究员 Handoff Comment 中的文件表与 Issue 素材需求匹配
- **Gate 3 (初稿提交)**: 作者 Handoff Comment 中自检清单全部 ✅
- **Gate 4 (审核通过)**: 审稿人可 `git diff` 实际审核，不是只看 Issue 描述

---

*版本: v0.1*
*创建日期: 2026-04-18*
