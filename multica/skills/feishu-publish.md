---
name: feishu-publish
uuid: "f3a7c821-9d4e-4b2a-8e15-2c6d0f1a3b9e"
version: 1.0.0
description: "飞书文章发布工作流：将本地写完的 Markdown 章节发布到飞书文档，并完成 L4 公开权限设置、串联上一篇下一章预告链接、加入目录文档。"
callers: [editor-chief]
external_deps:
  - tool: lark-cli
    required: true
---

# 飞书文章发布工作流

## 功能

将本地 `.md` 章节文件一键发布到飞书，完成发布、权限、串联、目录四步。

## 输入

| 参数 | 说明 | 示例 |
|------|------|------|
| `md_path` | 本地 Markdown 文件路径 | `manuscript/chapters/CH-11-xxx.md` |
| `title` | 文档标题 | `CH-11 流程优化与持续改进` |
| `prev_doc_id` | 上一篇飞书文档的 doc_id | `OcIjdH7TAoyySbxdPMGcUXxtnHd` |
| `toc_doc_id` | 目录文档的 doc_id | `IS0WdUIyloJuvlxEoMNcXFZenZb` |

执行前确认用户已提供以上四项，缺少任何一项需先询问。

## 输出

```
✓ 文档已发布：https://www.feishu.cn/docx/<doc_id>
✓ 权限已设为 L4 公开
✓ 上一篇预告已更新
✓ 已加入目录
```

## 执行流程

```
本地 .md 文件
     │
     ▼
[Step 1] 发布文档  ──→ 获得 new_doc_id
     │
     ├──────────────────┬──────────────────┐
     ▼                  ▼                  ▼
[Step 2]           [Step 3]           [Step 4]
设置 L4 公开权限   更新上一篇预告     加入目录
```

Step 1 必须先完成；Step 2 / 3 / 4 无依赖关系，可并行执行。

---

### Step 1：发布文档

使用 lark-cli skill：`~/.agents/skills/lark-doc-publish/SKILL.md`

```bash
lark-cli docs +create \
  --title "<title>" \
  --markdown "$(cat <md_path>)" \
  --as user
```

记录返回的 `doc_id`（后续三步均需要）和 `doc_url`（告知用户）。

---

### Step 2：设置 L4 公开权限

使用 lark-cli skill：`~/.agents/skills/lark-doc-permission/SKILL.md`

```bash
lark-cli api PATCH /open-apis/drive/v2/permissions/<new_doc_id>/public \
  --params '{"type":"docx"}' \
  --data '{
    "external_access_entity": "open",
    "link_share_entity": "anyone_readable",
    "security_entity": "anyone_can_view",
    "comment_entity": "anyone_can_view"
  }' \
  --as user
```

> **已知问题**：PATCH 在当前环境下 exit=1 且无输出（静默失败）。遇到此情况需手动在飞书客户端设置权限：分享 → 互联网上拥有链接的人可查看。

---

### Step 3：更新上一篇的下一章预告

使用 lark-cli skill：`~/.agents/skills/lark-doc-next-chapter/SKILL.md`

**关键：`lark-cli --markdown` 中的 `<mention-doc>` 会被 HTML 转义失效，必须用原生 API PATCH block 写入 `mention_doc` element。**

```bash
# Step 3a：找末尾预告行的 block_id
lark-cli api GET /open-apis/docx/v1/documents/<prev_doc_id>/blocks \
  --params '{"page_size":"200","document_revision_id":"-1"}' \
  --as user \
  | python3 -c "
import sys,json
d=json.load(sys.stdin)
items=d['data']['items']
for b in items[-5:]:
    txt = b.get('text',{}).get('elements',[])
    content = ''.join(e.get('text_run',{}).get('content','') for e in txt)
    print(b['block_id'], repr(content[:60]))
"

# Step 3b：PATCH 该 block 写入 mention_doc element
lark-cli api PATCH /open-apis/docx/v1/documents/<prev_doc_id>/blocks/<block_id> \
  --data '{
    "update_text_elements": {
      "elements": [
        {"text_run": {"content": "下一章预告：", "text_element_style": {"italic": true}}},
        {"mention_doc": {
          "token": "<new_doc_id>",
          "obj_type": 22,
          "url": "https://www.feishu.cn/docx/<new_doc_id>",
          "title": "<title>"
        }}
      ]
    }
  }' \
  --as user
```

如果末尾没有预告行，先 `append` 一行占位文本，再获取其 block_id，再 PATCH（详见 lark-doc-next-chapter skill）。

---

### Step 4：加入目录

使用 lark-cli skill：`~/.agents/skills/lark-doc-toc/SKILL.md`

```bash
lark-cli docs +update \
  --doc <toc_doc_id> \
  --mode append \
  --markdown $'\n<mention-doc token="<new_doc_id>" type="docx"><title></mention-doc>' \
  --as user
```

---

## 质量标准

- 四步全部返回 `"ok": true` 或 `"success": true`
- 发布后可通过 `doc_url` 访问文档
- 目录文档末尾可见新章节内链

## 依赖

| 依赖 | 路径 |
|------|------|
| lark-doc-publish | `~/.agents/skills/lark-doc-publish/SKILL.md` |
| lark-doc-permission | `~/.agents/skills/lark-doc-permission/SKILL.md` |
| lark-doc-next-chapter | `~/.agents/skills/lark-doc-next-chapter/SKILL.md` |
| lark-doc-toc | `~/.agents/skills/lark-doc-toc/SKILL.md` |

## 调用语法

```
[@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) 请执行 feishu-publish：
- md_path: manuscript/chapters/CH-11-xxx.md
- title: CH-11 流程优化与持续改进
- prev_doc_id: OcIjdH7TAoyySbxdPMGcUXxtnHd
- toc_doc_id: IS0WdUIyloJuvlxEoMNcXFZenZb
```
