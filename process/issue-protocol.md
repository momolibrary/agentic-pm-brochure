# Issue 管理协议

> 所有内容开发必须由 Issue 驱动，无 Issue 不开工

---

## Issue 存储

- **正式 Issue**：使用 GitHub Issues
- 每个 Issue 必须包含 TDD 验收标准（模板：`multica/workflows/tdd-template.md`）
- Issue 标题格式：`[ISSUE-ID] 简要描述`

## Issue 编号规范

| 前缀 | 用途 | 示例 |
|------|------|------|
| `CH-XX` | 章节开发 Issue | `CH-01 第一章初稿开发` |
| `FIX-XX` | 修订 Issue（审核不通过后） | `FIX-03 ch-01 术语修正` |
| `META-XX` | 流程/标准/配置变更 Issue | `META-01 术语表新增 API 定义` |
| `ASSET-XX` | 素材/案例/图示开发 Issue | `ASSET-01 登录注册案例` |

编号自增，不可复用。

## Issue 状态流转

```
open → researching → drafting → reviewing → approved → committed → closed
                                    ↓
                               drafting (退回修订，最多 3 轮)
```

| 状态 | 含义 | 责任 Agent | 操作 |
|------|------|-----------|------|
| `open` | 已创建，含验收标准 | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | 创建 Issue，定义验收标准 |
| `researching` | 素材搜索中 | [@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c) | 搜索素材，更新素材库 |
| `drafting` | 初稿写作/修订中 | [@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2) | 写作初稿或按审核意见修订 |
| `reviewing` | 审核中 | [@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c) | lint-check + review-quality |
| `approved` | 终审通过 | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | 终审 + 请求人类确认 |
| `committed` | 已提交 Git | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | Git commit + PR |
| `closed` | 完结 | [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) | 关闭 Issue |

## 门禁规则（Gating）

### 创建门禁
- [ ] 无 Issue 不得创建 `manuscript/chapters/` 下的章节文件
- [ ] Issue 必须包含完整 TDD 验收标准（问题、能力、误解、概念）
- [ ] Issue 必须指定目标读者层级（P0/P1/P2）

### 写作门禁
- [ ] Issue 状态为 `drafting` 才可开始写作
- [ ] 素材需求（案例/类比/图示）已由 [@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c) 或 [@案例师](mention://agent/2eb4c3b6-d91c-4372-9245-61769ab1032b) 准备完成
- [ ] 术语表中对应术语已确认

### 审核门禁
- [ ] 初稿自查 checklist 已完成（来自 `style-guide.md`）
- [ ] 10 要素结构完整
- [ ] lint-check 已运行且无 error 级问题

### 关闭门禁
- [ ] review-quality 通过率 100%
- [ ] 人类已确认终审
- [ ] Git commit 已关联 Issue 编号

## Issue → Git 关联

- commit message 格式：`[ISSUE-ID] 动作描述`
- 示例：
  - `[CH-01] 完成初稿写作`
  - `[CH-01] lint修复：术语不一致`
  - `[FIX-03] 修订案例复盘段落`
- branch 命名规范见 `git-convention.md`

## Issue 模板

见 `multica/workflows/tdd-template.md` 末尾的「TDD Issue 模板」。

---

*版本: v0.1*
*创建日期: 2026-04-18*
