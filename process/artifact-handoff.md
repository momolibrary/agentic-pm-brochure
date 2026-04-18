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
2. **即产即推（Commit-on-Produce）**：Agent 每次新建或修改文件后，**必须立即** `git add → commit → push`，不得等到"全部完成"再推送（详见下节）
3. **结构化交接评论**：Agent 完成后在 Issue 中发布机器可解析的 Handoff Comment
4. **Mention 尾行路由**：评论中需要触发其他 Agent 时，mention 必须放在评论**最后一行**，作为独立的路由行（详见下节）
5. **干净退出（Clean Exit）**：分支在 merge 后删除，worktree 在 task 结束后清理。历史通过 commit / PR / Issue 回溯，不依赖残留分支（详见下节）
6. **附件兜底**：非 git 管理的产物（图片、临时分析等）通过 `--attachment` 上传
7. **人类侧一键拉取**：提供 `multica-review` 脚本，自动拉取分支并展示 diff

---

## 即产即推规则（Commit-on-Produce）

> **教训来源**：CH-02 开发中，作者 Agent 声称已修改文件并在评论中描述了修改内容，但实际文件未被 commit/push。审稿人在不同 worktree 中 grep 检查，发现文件未变。经多轮催促仍无法解决，最终由主编介入 cherry-pick 才完成交付。

### 规则

**Agent 每次对仓库文件执行写入操作后，必须立即执行 commit + push。**

```
编辑文件 → git add <files> → git commit -m "[ISSUE-ID] 描述" → git push origin <branch>
```

不存在「先写完所有内容再一次性提交」的流程。每一次有意义的文件变更都必须立即推送到远端。

### 为什么

1. **跨 worktree 可见性**：multica Agent 各自运行在独立的 worktree 中。Agent A 的本地修改，Agent B 看不到。只有 push 到远端，其他 Agent 和人类才能 `git fetch` 看到变更
2. **防止「声称修改但未落盘」**：Agent 可能在评论中描述了修改，但因工具调用失败、路径错误等原因未实际写入文件。commit + push 是唯一的「修改已落盘」证据
3. **支持增量审核**：审稿人可以在作者写作过程中 fetch 查看进度，不必等到最终 Handoff
4. **异常恢复**：如果 Agent 中途崩溃，已 push 的 commit 不会丢失

### 时机

| 场景 | 是否需要立即 commit + push |
|------|---------------------------|
| 新建章节文件 | **是** — 文件创建后立即推送 |
| 修改章节内容（如补充误解三） | **是** — 每次修改后立即推送 |
| 修改术语表、lint 报告等辅助文件 | **是** — 同上 |
| 写评论（不涉及文件修改） | 否 — 评论不经过 Git |

### Commit Message 格式

增量 commit 使用以下格式（与 `git-convention.md` 对齐）：

```
[ISSUE-ID] WIP: 描述当前修改
```

最终交付的 commit 不带 WIP 前缀：

```
[ISSUE-ID] 完成初稿写作
```

### 验证方式

审稿人在审核时，**必须基于远端分支内容审核**，不得仅依赖评论中的描述：

```bash
git fetch origin
git show origin/<branch>:<file-path>   # 审核实际文件内容
```

如果评论声称已修改但远端分支中未找到变更，审稿人应立即在评论中指出并要求重新 push。

---

## Mention 路由规范

> **教训来源**：CH-02 开发中，mention 散落在评论中间段落，部分 Agent 未被正确触发，导致工作流卡死。

### 规则

**评论中需要触发其他 Agent 执行任务时，mention 必须作为评论的最后一行，独立成行。**

### 格式

```markdown
<评论正文内容>
<空行>
请 [@目标Agent](mention://agent/<uuid>) 执行 <具体任务描述>。
```

### 为什么

1. **解析可靠性**：multica 的 mention 路由基于 `[@显示名](mention://agent/<uuid>)` 格式。放在最后一行独立成行，确保解析器稳定识别，不被上下文干扰
2. **单一职责**：一条评论只触发一个 Agent。如果需要触发多个 Agent，发多条评论，每条评论的最后一行 mention 不同的 Agent
3. **人类可读**：人类扫一眼评论末尾就知道「这条消息是发给谁的」，不用在大段文字中找 mention

### 正例

```markdown
## CH-02 初稿完成

已完成数据流转与约束章节写作，自查清单全部通过。

请 [@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c) 执行 lint-check 和 review-quality 审核。
```

### 反例

```markdown
## CH-02 初稿完成

请 [@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c) 审核，  ← mention 埋在中间
已完成数据流转与约束章节写作，自查清单全部通过。
另外 [@作者](mention://agent/a054c330-...) 注意一下术语。   ← 同一评论触发两个 Agent
```

### 一评论一 Agent 规则

如果一个交接点需要通知多个 Agent：

```bash
# 评论 1：触发审稿人
multica issue comment add <issue-id> --content "初稿完成，请审核。

请 [@审稿人](mention://agent/6586d624-...) 执行审核。"

# 评论 2：触发插画师（如有需要）
multica issue comment add <issue-id> --content "需要绘制数据流转图。

请 [@插画师](mention://agent/2f0e9417-...) 绘制 Section 2.1 的数据流转示意图。"
```

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
- **审核请求（mention）必须放在评论最后一行**，遵循「Mention 路由规范」

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

## Worktree 隔离模型与分支约定

### multica 的 worktree 机制

multica daemon 为每个 task 创建**独立的 git worktree**：

```
~/multica_workspaces/.repos/<workspace-id>/<repo>.git       ← bare clone (所有 agent 共享)
    └── worktree: ~/<workspace-id>/<task-hash>/workdir/      ← 每个 task 独占一个目录
          自动分支: agent/<agent-name>/<task-hash>            ← multica 自动创建
          基底:     refs/remotes/origin/main                  ← 基于最新 main
```

核心事实：
- **每个 agent 的每个 task 运行在独立目录中**，不共享文件系统
- multica 自动创建 `agent/<agent-name>/<task-hash>` 作为 worktree 的工作分支
- **跨 agent 可见性只有一种方式**：通过 `git push` 推到远端，然后其他 agent `git fetch` 拉取
- 当 `reused=true` 时，同一个 agent 的新 task 复用上一次的 workdir（含残留文件和分支）

### 双分支模型

实际运行中存在两类分支：

| 类型 | 命名格式 | 创建者 | 生命周期 |
|------|----------|--------|----------|
| 临时分支 | `agent/<agent-name>/<task-hash>` | multica 自动创建 | 随 task 生灭，不保证推送到远端 |
| 约定分支 | `<issue-id>/<agent-name>/deliverable` | Agent 手动创建 | 需人类 merge 后清理 |

### 启动仪式（Task Start Ritual）

**Agent 接收 task 后的前三条命令**（在做任何文件操作之前）：

```bash
# 1. 拉取最新远端状态
git fetch origin

# 2. 创建约定分支（基于最新 main）
git checkout -b <issue-id>/<agent-name>/deliverable origin/main

# 3. 确认当前分支正确
git branch --show-current
# 应输出: <issue-id>/<agent-name>/deliverable
```

如果是修订轮次，使用 `<issue-id>/<agent-name>/fix-round<n>` 替换 `deliverable`。

> **为什么不用 multica 自动分支？**
> `agent/<name>/<hash>` 分支名包含 task hash，对人类不可读，且不包含 issue 信息。
> 约定分支明确关联 issue 和 agent，方便人类审核和自动化脚本匹配。

### 审核方的 Fetch 仪式

审核 Agent（reviewer / editor-chief）在审核前的必做操作：

```bash
# 1. 拉取最新远端分支
git fetch origin

# 2. 从 Handoff Comment 中获取分支名，查看文件
git show origin/<branch-from-handoff>:<file-path>

# 3. 查看完整 diff
git diff origin/main...origin/<branch-from-handoff>
```

**不要** `git checkout` 到对方的分支。直接通过 `origin/<branch>` 远程引用读取即可，避免影响自己的 worktree 状态。

### 分支命名规范

与 `process/git-convention.md` 对齐，扩展 Agent 交接场景：

| 模式 | 示例 | 用途 |
|------|------|------|
| `agent/<agent>/<task-hash>` | `agent/author-draft/fe253f31` | multica 自动创建，**不用于交付** |
| `<issue-id>/<agent>/deliverable` | `ch-02/author-draft/deliverable` | Agent 交付分支 |
| `<issue-id>/<agent>/material` | `ch-02/researcher/material` | 素材准备分支 |
| `<issue-id>/<agent>/fix-round<n>` | `ch-02/author-draft/fix-round2` | 修订轮次分支 |
| `<issue-id>/review` | `ch-02/review` | 审核专用分支（合并多人产物） |

---

## 干净退出原则（Clean Exit）

> **问题**：并行章节开发时，每个 task 会创建约定分支 + multica 自动分支。5 章并行就是 10+ 分支 + 若干 worktree 目录。不清理会导致：`git branch` 输出满屏噪声、`git fetch` 越来越慢、磁盘被 worktree 吃掉。

### 核心思路

**分支是临时工作区，不是档案。** 历史通过 merge commit（Squash）、PR、Issue comment 回溯，已合并分支没有保留价值。

这与 GitHub Flow 一致：feature branch → PR → merge → delete branch。

### 分支生命周期

```
create ──→ push ──→ review ──→ merge to main ──→ delete (local + remote)
  │                                                  │
  └─── commit history preserved via squash merge ─────┘
```

| 阶段 | 谁执行 | 操作 |
|------|--------|------|
| 创建 | Agent (task start) | `git checkout -b <issue-id>/<agent>/deliverable origin/main` |
| 推送 | Agent (即产即推) | `git push origin <branch>` |
| 合并 | 人类 (review 通过后) | `git merge --squash origin/<branch>` 或 PR merge |
| 删除远端 | 人类 / 脚本 (merge 后) | `git push origin --delete <branch>` |
| 删除本地 | 人类 / 脚本 (merge 后) | `git branch -d <branch>` |
| 清理 stale | 定期 | `git fetch --prune` + `git branch --merged main \| grep -v main \| xargs git branch -d` |

### multica worktree 清理

multica daemon 在 `~/multica_workspaces/<ws-id>/<task-hash>/workdir/` 创建 worktree。这些目录在 task 结束后不会自动删除（`reused=true` 机制会复用）。

定期清理：

```bash
# 查看 worktree 占用
du -sh ~/multica_workspaces/

# 清理已结束 task 的 worktree（保留最近 7 天）
find ~/multica_workspaces -maxdepth 3 -name "workdir" -type d -mtime +7 -exec rm -rf {} +

# 清理 bare clone 中的悬空 worktree 引用
find ~/multica_workspaces/.repos -name "*.git" -type d -exec git -C {} worktree prune \;
```

### `multica-review.sh --merge` 增强

`scripts/multica-review.sh --merge` 在合并后自动执行分支清理。详见脚本。

### Agent 的退出清单

Agent 在 task 结束前（发布 Handoff Comment 之后）：

1. 确认所有文件已 commit + push
2. **不要主动删除分支** — 分支由人类在 merge 后删除
3. 如果 task 涉及多个中间分支（如 `material` + `deliverable`），在 Handoff Comment 中列出，方便人类统一清理

### 人工清理一键命令

```bash
# 清理所有已合并到 main 的本地分支
git branch --merged main | grep -v '\* main' | xargs -r git branch -d

# 同步远端已删除的分支引用
git fetch --prune

# 完整清理（脚本封装）
./scripts/multica-gc.sh
```

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

## 复盘记录

### CH-02 事故：声称修改但未 push（2026-04-19）

**现象**：作者 Agent 在评论中声称已添加「误解三」并给出了修改内容的 Markdown 引用，但审稿人在远端 grep 检查发现文件未变更。经 3 轮催促、主编介入后才修复。

**根因**：
1. 作者 Agent 可能只是「计划修改」并在评论中描述，但未实际执行文件编辑或执行后未 commit/push
2. 审稿人和作者在不同 worktree 中工作，没有 push 就互相不可见
3. 评论中的 mention 位置不规范，部分触发失败

**修复措施**：
1. 新增「即产即推（Commit-on-Produce）」规则 — 编辑文件后必须立即 commit + push
2. 新增「Mention 尾行路由」规范 — mention 必须放在最后一行独立成行
3. 审稿人审核必须基于远端分支实际文件，不得仅依赖评论描述

---

*版本: v0.3*
*创建日期: 2026-04-18*
*更新日期: 2026-04-19 — v0.2 即产即推+Mention路由; v0.3 Worktree隔离模型+干净退出原则*
