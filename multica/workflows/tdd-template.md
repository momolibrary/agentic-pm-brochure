# TDD 章节验收标准模板

> 每个章节开发前必须先定义验收标准（测试用例），写作完成后进行审核验收

---

## 验收标准定义流程

```
1. 定义验收标准（测试用例）
   ├── 必须回答的问题
   ├── 读者能做到的事
   ├── 必须纠正的误解
   └── 必须准确的概念
2. 写作初稿
3. 执行验收检查
4. 通过 → 提交；不通过 → 修订
```

---

## 验收标准模板

```yaml
chapter: "章节编号 - 章节名称"
version: v0.1
created: 2026-04-18

# ========== 测试用例 ==========

test_cases:
  # 必须回答的问题（3-5个）
  questions:
    - q1: "问题1"
      expected_answer: "期望的回答要点"
    - q2: "问题2"
      expected_answer: "期望的回答要点"
    - q3: "问题3"
      expected_answer: "期望的回答要点"

  # 读者读完后能做到的事（3件）
  actions:
    - a1: "能力描述"
      verification: "如何验证读者已掌握"
    - a2: "能力描述"
      verification: "如何验证读者已掌握"
    - a3: "能力描述"
      verification: "如何验证读者已掌握"

  # 必须纠正的误解（2-3个）
  misconceptions:
    - m1: "常见误解"
      correction: "正确理解"
    - m2: "常见误解"
      correction: "正确理解"

  # 必须准确的概念（关键术语）
  concepts:
    - term: "术语名称"
      definition: "定义（来自术语表）"
      usage_context: "使用场景说明"

# ========== 章节结构验收 ==========

structure_check:
  - element: "本章要解决什么问题"
    required: true
    min_length: 100
    max_length: 500
  - element: "真实业务场景开场"
    required: true
    must_have: ["人物", "情境", "冲突"]
  - element: "核心概念解释"
    required: true
    min_concepts: 2
    max_concepts: 5
  - element: "为什么产品经理容易误解"
    required: true
    must_have: ["误解表现", "误解原因"]
  - element: "开发视角如何看这个问题"
    required: true
    must_have: ["开发关注点", "技术约束"]
  - element: "产品经理应该如何做"
    required: true
    must_have: ["行动建议", "checklist"]
  - element: "AI可以如何辅助"
    required: true
    must_have: ["AI应用场景", "具体方法"]
  - element: "本章 checklist"
    required: true
    min_items: 3
    max_items: 10
  - element: "案例复盘"
    required: true
    must_have: ["案例回溯", "要点提炼"]
  - element: "本章总结"
    required: true
    max_length: 300

# ========== 文风验收 ==========

style_check:
  humor_level: "moderate"  # low, moderate, high
  sentence_max_length: 30
  no_empty_phrases: true
  no_unexplained_jargon: true
  reading_difficulty: "easy"  # easy, medium, hard

# ========== 质量门槛 ==========

quality_threshold:
  test_pass_rate: 100%  # 所有测试用例必须通过
  structure_complete: true
  style_compliant: true
  term_consistent: true
```

---

## 验收检查执行流程

### Step 1: 问题回答检查

```markdown
检查方式：人工 + AI审核

针对每个问题：
- Q: [问题]
- 章节内容是否回答？[是/否]
- 回答是否准确？[是/否]
- 回答是否可理解？[是/否]
```

### Step 2: 能力验收检查

```markdown
检查方式：试读 + 反馈

针对每个能力：
- 能力: [描述]
- 读者能否理解如何做到？[是/否]
- 是否提供了可执行的步骤？[是/否]
- 是否有 checklist 或模板？[是/否]
```

### Step 3: 误解纠正检查

```markdown
检查方式：人工审核

针对每个误解：
- 误解: [描述]
- 是否识别出这个误解？[是/否]
- 是否给出正确理解？[是/否]
- 是否有场景说明？[是/否]
```

### Step 4: 术语准确性检查

```markdown
检查方式：lint-check

- 术语使用是否与术语表一致？
- 新术语是否已定义？
- 是否避免未解释的技术术语？
```

### Step 5: 结构完整性检查

```markdown
检查方式：自动化 lint

- 10要素是否齐全？
- 各要素长度是否达标？
- 必须包含的内容是否存在？
```

### Step 6: 文风一致性检查

```markdown
检查方式：lint-check + 人工审核

- 幽默度是否适中？
- 单句是否超过30字？
- 是否有空洞表达？
- 技术术语是否已解释？
```

---

## 验收报告模板

```markdown
# 章节验收报告

## 基本信息
- 章节: [章节编号 - 名称]
- 版本: [版本号]
- 审核日期: [日期]
- 审核人: [审核者]

## 验收结果

### 测试用例通过情况
| 测试项 | 状态 | 备注 |
|--------|------|------|
| Q1 回答准确 | ✅/❌ | |
| Q2 回答准确 | ✅/❌ | |
| Q3 回答准确 | ✅/❌ | |
| A1 能力传达 | ✅/❌ | |
| A2 能力传达 | ✅/❌ | |
| A3 能力传达 | ✅/❌ | |
| M1 误解纠正 | ✅/❌ | |
| M2 误解纠正 | ✅/❌ | |
| 术语准确 | ✅/❌ | |

### 结构验收
| 要素 | 状态 | 备注 |
|------|------|------|
| 问题定义 | ✅/❌ | |
| 场景开场 | ✅/❌ | |
| 概念解释 | ✅/❌ | |
| 误解说明 | ✅/❌ | |
| 开发视角 | ✅/❌ | |
| 行动建议 | ✅/❌ | |
| AI辅助 | ✅/❌ | |
| Checklist | ✅/❌ | |
| 案例复盘 | ✅/❌ | |
| 本章总结 | ✅/❌ | |

### 文风验收
| 检查项 | 状态 | 备注 |
|--------|------|------|
| 幽默度适中 | ✅/❌ | |
| 短句为主 | ✅/❌ | |
| 无空洞表达 | ✅/❌ | |
| 术语已解释 | ✅/❌ | |

## 总体评估
- 通过率: [X/Y]
- 是否通过: ✅/❌
- 修订建议: [如有问题，列出修订建议]

## 下一步
- [ ] 修订后重新验收
- [ ] 提交 Git
- [ ] 关闭 Issue
```

---

## TDD Issue 模板

创建章节开发 Issue 时使用：

```markdown
## 章节
[章节编号 - 章节名称]

## 验收标准

### 必须回答的问题
1. [问题1]
2. [问题2]
3. [问题3]

### 读者能做到的事
1. [能力1]
2. [能力2]
3. [能力3]

### 必须纠正的误解
1. [误解1]
2. [误解2]

### 必须准确的概念
- [术语1]: [定义]
- [术语2]: [定义]

## 素材需求
- 案例: [需要的案例]
- 类比: [需要的类比]
- 图示: [需要的图示]

## 目标读者
[P0/P1/P2]

## 技术深度
[浅/适中/深]

## 幽默度
[低/适中/高]

## Assignee
[@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2)

## 参考
- [相关资料链接]
- [术语表]
- [文风指南]
```

---

*模板版本: v0.1*
*创建日期: 2026-04-18*