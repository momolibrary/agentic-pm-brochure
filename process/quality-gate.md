# 质量门禁定义

> 每个阶段的准入/准出条件，阻止低质量内容流入下游

---

## 门禁总览

```
 [Issue创建] ──Gate 1──→ [素材研究] ──Gate 2──→ [初稿写作] ──Gate 3──→ [审核]
                                                                         │
                                                              Gate 4 ←──┘
                                                                │
                                                    [终审] ──Gate 5──→ [Git提交]
```

## Gate 1: Issue 准出 → 进入研究

| 检查项 | 必须 | 验证方式 |
|--------|------|---------|
| Issue 编号已分配 | ✅ | 格式: CH-XX / FIX-XX / META-XX |
| TDD 验收标准已填写 | ✅ | questions ≥ 3, actions ≥ 3, misconceptions ≥ 2 |
| 目标读者已指定 | ✅ | P0 / P1 / P2 |
| 素材需求已列出 | ✅ | 案例/类比/图示需求 |
| 人类已确认验收标准 | ✅ | editor-chief 请求确认 |

**责任人**: [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c)
**不通过**: 修改 Issue 内容，重新确认

## Gate 2: 素材准出 → 进入写作

| 检查项 | 必须 | 验证方式 |
|--------|------|----------|
| 搜索结果已整理 | ✅ | 存放于 assets/ 或 manuscript/cases/ |
| 类比素材已准备 | ✅ | 至少 2 个可用类比 |
| 案例素材已准备 | 按需 | [@案例师](mention://agent/2eb4c3b6-d91c-4372-9245-61769ab1032b) 产出存放于 manuscript/cases/ |
| 术语对照已确认 | ✅ | 涉及术语在 term-glossary.md 中有定义 |

**责任人**: [@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c) + [@案例师](mention://agent/2eb4c3b6-d91c-4372-9245-61769ab1032b)
**不通过**: 补充素材或降级素材需求（需 [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) 决策）

## Gate 3: 初稿准出 → 进入审核

| 检查项 | 必须 | 验证方式 |
|--------|------|---------|
| 10 要素结构完整 | ✅ | 章节结构自查 |
| 测试用例覆盖 | ✅ | 自查每个 Q/A/M 是否被回答 |
| 术语与术语表一致 | ✅ | 自查或 term-lookup |
| 文风自查 checklist 通过 | ✅ | style-guide.md 底部清单 |
| 无空洞表达 | ✅ | 自查禁用词列表 |

**责任人**: [@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2)
**不通过**: 自行修订后重新提交

## Gate 4: 审核完成 → 状态转移

### 通过审核（outcome: pass）
| 检查项 | 必须 | 验证方式 |
|--------|------|----------|
| lint-check 通过（无 error） | ✅ | lint-check skill 执行 |
| review-quality 通过率 100% | ✅ | review-quality skill 执行 |
| 术语一致性通过 | ✅ | term-consistency rule |
| 结构完整性通过 | ✅ | chapter-structure rule |
| 图示已完成（如需） | 按需 | [@插画师](mention://agent/2f0e9417-105a-4607-8ee3-9dd26527f578) 产出 |

**责任人**: [@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c)  
**动作**：
1. 发布 Handoff 评论，outcome=**pass**
2. 自行改 issue status: `reviewing` → `approved`
3. Mention [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) 执行终审

### 审核失败（outcome: fail）  
| 检查项 | 状态 |
|--------|------|
| 修复项≤2项 | 二次机会（返回 drafting） |
| 修复项>2项 或 同项连续失败 | 三次重审后升级 |

**责任人**: [@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c)  
**动作**：
1. 发布 Handoff 评论，outcome=**fail**，附**明确修订清单**（列项目、原因、建议）
2. 自行改 issue status: `reviewing` → `drafting`
3. Mention [@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2) 修订，最多 3 轮
4. 3 轮仍失败：改 status 为 `blocked`，Mention [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) 介入

### 无法修补（outcome: blocked）
- 改 issue status: `reviewing` → `blocked`
- Mention [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) 及人工决策

## Gate 5: approved → committed (主编终审)

| 检查项 | 必须 | 验证方式 |
|--------|------|---------|
| Gate 4 全部通过（outcome=pass） | ✅ | 审稿人 Handoff 确认 |
| 主编仲裁通过 | ✅ | 主编自行基于远端分支审核 |
| 人类已确认最终审核 | ✅ | 人机协作确认 |

**责任人**: [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c)  
**动作**：
1. 接收审稿人 Handoff（outcome=pass）
2. 基于远端分支 git diff 再审一遍
3. **若同意**：改 status `approved` → `committed`，发 Handoff 说明 Git 合并准备好
4. **若不同意**：改 status `approved` → `reviewing`，mention 审稿人说明反驳原因
5. **最多 1 轮反驳**；若再失败则人工介入

## Gate 6: committed → closed (Git 提交 & 关闭)

| 检查项 | 必须 | 验证方式 |
|--------|------|---------|
| PR 已创建 | ✅ | GitHub PR + Issue 关联 |
| 人类已批准合并 | ✅ | 人机协作确认 |
| commit message 符合规范 | ✅ | `[ISSUE-ID] 动作描述` |
| 分支已删除 | ✅ | Git 清理 |

**责任人**: [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c)  
**动作**：
1. 创建 PR：`origin/<deliverable-branch>` → `main`
2. 请求人类最终审批
3. 人类批准后：`git merge && git push`
4. 删除交付分支：`git branch -D <branch> && git push origin --delete <branch>`
5. 改 status `committed` → `closed`
6. 归档本次发布日志

## 回退规则

| 场景 | 回退目标 | 最大重试 | 升级条件 |
|------|---------|---------|----------|
| lint-check 不通过 | [@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2) 修复 | 2 轮 | 2 轮后 [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) 介入 |
| review-quality 不通过 | [@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2) 修订 | 3 轮 | 3 轮后 [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) + 人工介入 |
| 素材不足 | [@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c) 补搜 | 2 轮 | 2 轮后 [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c) 决策降级/换题 |
| 终审不通过 | Gate 4 重审 | 1 轮 | 直接人工介入 |

---

*版本: v0.1*
*创建日期: 2026-04-18*
