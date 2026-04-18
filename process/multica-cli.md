# multica CLI 操作手册

> **multica 是本地安装的命令行工具**（`/opt/homebrew/bin/multica`），不是文件夹、不是网站、不需要联网搜索。
> 它管理着服务端的 Agent/Skill/Issue/Workspace 等资源，仓库里的 `.md` 文件只是本地定义，**必须通过 CLI 同步到服务端才生效**。

---

## 核心概念：双写规则

修改 Agent 或 Skill 时，**必须同时更新两处**：

| 位置 | 说明 | 方式 |
|------|------|------|
| 仓库文件 | `multica/skills/*.md`、`multica/agents/*.md` | 编辑文件 + git commit |
| multica 服务端 | 实际运行环境 | `multica skill update` / `multica agent update` |

> **只改文件不更新服务端 = 服务端仍是旧版本。只更新服务端不改文件 = 仓库与运行态不一致。**

---

## Workspace 隔离（极重要）

multica 支持多 workspace，**操作前必须确认目标 workspace**：

```bash
# 查看所有 workspace
multica workspace list

# 本项目的 workspace
# Name: pm-brochure
# ID:   38f948e7-3827-40d0-b3ea-519c39440bf7
```

**所有命令都必须指定 `--workspace-id`**，否则会操作到默认 workspace（个人空间），导致数据错位。

```bash
# ✅ 正确：指定 workspace
multica skill list --workspace-id 38f948e7-3827-40d0-b3ea-519c39440bf7

# ❌ 错误：不指定，会操作到默认个人 workspace
multica skill list
```

---

## 常用命令速查

### Skill 操作

```bash
WS="38f948e7-3827-40d0-b3ea-519c39440bf7"

# 列出所有 skill
multica skill list --workspace-id $WS

# 查看某个 skill 详情（用 skill UUID）
multica skill get <skill-uuid> --workspace-id $WS --output json

# 更新 skill（同步仓库文件到服务端）
multica skill update <skill-uuid> --workspace-id $WS \
  --description "新描述" \
  --content "$(cat multica/skills/<skill-name>.md)"

# 创建新 skill
multica skill create --workspace-id $WS \
  --name "<skill-name>" \
  --description "描述" \
  --content "$(cat multica/skills/<skill-name>.md)"

# 删除 skill（不可逆，会要求确认）
multica skill delete --workspace-id $WS <skill-uuid>
```

### Agent/Issue/Workspace

```bash
multica agent list --workspace-id $WS
multica issue list --workspace-id $WS
multica workspace list
```

---

## Skill UUID 对照表

> 权威来源：`multica/agents/manifest.yaml`

| Skill 名 | UUID | 文件 |
|-----------|------|------|
| chapter-draft | `e3a93712-a72c-4ce9-9291-44008951d565` | `multica/skills/chapter-draft.md` |
| review-quality | `850b316e-e735-4664-a7a8-b454604c003b` | `multica/skills/review-quality.md` |
| lint-check | `d9f5ed84-0b61-43a3-86f0-488403d3b8d9` | `multica/skills/lint-check.md` |
| term-lookup | `8ccb36b5-c098-4581-b94d-d4727f34a49d` | `multica/skills/term-lookup.md` |
| case-develop | `626fa367-c31e-444d-9304-81106944620b` | `multica/skills/case-develop.md` |
| diagram-create | `ba1ae40b-16b0-4339-a431-4ac54e8ab4da` | `multica/skills/diagram-create.md` |
| research-search | `bafcf7de-d91d-443e-971a-8cf42932d145` | `multica/skills/research-search.md` |

---

## 典型操作流程：更新 Skill

```
1. 编辑仓库文件    →  multica/skills/chapter-draft.md
2. 同步到服务端    →  multica skill update e3a93712-... --workspace-id 38f948e7-... --content "$(cat multica/skills/chapter-draft.md)"
3. 验证            →  multica skill get e3a93712-... --workspace-id 38f948e7-... --output json
4. git commit      →  git add + commit
```

---

*版本: v0.1*
*创建日期: 2026-04-19*
