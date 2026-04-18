# Lint 规则配置

> 书籍质量自动化检查规则

---

## 文风检查规则

### sentence-length
单句长度检查

```yaml
rule: sentence-length
description: 单句不超过30字
threshold: 30
severity: warning
message: "句子过长（{length}字），建议拆分为短句"
```

### no-empty-phrases
空洞表达检查

```yaml
rule: no-empty-phrases
description: 禁止空洞表达
patterns:
  - "非常重要"
  - "十分关键"
  - "极其重要"
  - "必不可少"
  - "不可或缺"
severity: warning
message: "避免空洞表达，请用具体描述替代"
```

### humor-meter
幽默度检测

```yaml
rule: humor-meter
description: 幽默度适中检测
target: moderate  # low, moderate, high
indicators:
  high:
    - 过多使用比喻
    - 连续幽默表达
    - 幽默与主题无关
  low:
    - 全文无幽默元素
    - 过于严肃枯燥
severity: info
message: "幽默度检测：{level}"
```

### no-redundancy
重复内容检查

```yaml
rule: no-redundancy
description: 消除重复内容
check:
  - 同一概念重复解释
  - 相似段落重复出现
  - checklist重复条目
severity: warning
message: "发现重复内容，建议合并或删除"
```

---

## 术语检查规则

### term-consistency
术语一致性检查

```yaml
rule: term-consistency
description: 术语使用必须与术语表一致
glossary: standards/term-glossary.md
check:
  - 术语名称一致性
  - 定义引用一致性
  - 别名使用规范
severity: error
message: "术语 '{term}' 使用不一致，术语表定义为 '{definition}'"
```

### term-defined
新术语首次定义检查

```yaml
rule: term-defined
description: 新术语首次出现必须定义
check:
  - 新术语首次出现位置
  - 是否有定义段落
  - 定义是否清晰
severity: error
message: "术语 '{term}' 首次出现但未定义"
```

### no-tech-jargon
未解释技术术语检查

```yaml
rule: no-tech-jargon
description: 避免未解释的技术术语
glossary: standards/term-glossary.md
check:
  - 技术术语是否在术语表
  - 是否有类比解释
  - 是否适合产品经理理解
severity: warning
message: "技术术语 '{term}' 未在术语表中，建议添加定义"
```

---

## 结构检查规则

### chapter-structure
章节结构完整性检查

```yaml
rule: chapter-structure
description: 章节必须包含10要素
elements:
  1:
    name: "本章要解决什么问题"
    required: true
    min_length: 100
    max_length: 500
  2:
    name: "真实业务场景开场"
    required: true
    must_have: ["人物", "情境", "冲突"]
  3:
    name: "核心概念解释"
    required: true
    min_concepts: 2
    max_concepts: 5
  4:
    name: "为什么产品经理容易误解"
    required: true
    must_have: ["误解表现", "误解原因"]
  5:
    name: "开发视角如何看这个问题"
    required: true
    must_have: ["开发关注点", "技术约束"]
  6:
    name: "产品经理应该如何做"
    required: true
    must_have: ["行动建议", "checklist"]
  7:
    name: "AI可以如何辅助"
    required: true
    must_have: ["AI应用场景", "具体方法"]
  8:
    name: "本章 checklist"
    required: true
    min_items: 3
    max_items: 10
  9:
    name: "案例复盘"
    required: true
    must_have: ["案例回溯", "要点提炼"]
  10:
    name: "本章总结"
    required: true
    max_length: 300
severity: error
message: "章节结构不完整，缺失要素：{missing_elements}"
```

### cross-reference
章节间引用一致性检查

```yaml
rule: cross-reference
description: 章节间引用必须一致
check:
  - 引用章节是否存在
  - 引用位置是否准确
  - 引用内容是否匹配
severity: warning
message: "引用 '{reference}' 不一致或不存在"
```

---

## 运行配置

```yaml
lint:
  run_on:
    - chapter_draft_complete
    - chapter_review
    - before_git_commit

  output:
    format: markdown
    file: lint-report.md

  threshold:
    error: 0  # 0个error才能通过
    warning: 5  # 最多5个warning
```

---

*配置版本: v0.1*
*创建日期: 2026-04-18*