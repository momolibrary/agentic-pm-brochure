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

## Gate 4: 审核准出 → 进入终审

| 检查项 | 必须 | 验证方式 |
|--------|------|----------|
| lint-check 通过（无 error） | ✅ | lint-check skill 执行 |
| review-quality 通过率 100% | ✅ | review-quality skill 执行 |
| 术语一致性通过 | ✅ | term-consistency rule |
| 结构完整性通过 | ✅ | chapter-structure rule |
| 图示已完成（如需） | 按需 | [@插画师](mention://agent/2f0e9417-105a-4607-8ee3-9dd26527f578) 产出 |

**责任人**: [@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c)
**不通过**: 退回 [@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2) 修订，附具体修订清单，最多 3 轮

## Gate 5: 终审准出 → Git 提交

| 检查项 | 必须 | 验证方式 |
|--------|------|---------|
| Gate 4 全部通过 | ✅ | 验收报告确认 |
| 人类已确认终审 | ✅ | editor-chief 请求确认 |
| commit message 符合规范 | ✅ | `[ISSUE-ID] 动作描述` |
| PR 已创建并关联 Issue | ✅ | GitHub PR |

**责任人**: [@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c)
**不通过**: 退回 Gate 4 重新审核

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
