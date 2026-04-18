---
skill_id: lint-check
skill_uuid: "d9f5ed84-0b61-43a3-86f0-488403d3b8d9"
callers:
  - reviewer        # 6586d624-bd24-4af2-884c-2ce54705555c
registry: ../agents/manifest.yaml
---

# Skill: lint-check

文风与术语一致性检查能力

## 功能

对章节内容执行自动化检查：
- 文风检查（短句、幽默度、空洞表达）
- 术语一致性检查
- 结构完整性检查
- 章节间引用一致性检查

## 输入

- 章节内容文件
- lint-rules.yaml 配置
- 术语表
- 文风指南

## 输出

- lint 检查报告
- 问题列表（位置、类型、建议修复）
- 通过/不通过状态

## 执行流程

1. 加载 lint 规则配置
2. 加载术语表
3. 执行文风检查
4. 执行术语检查
5. 执行结构检查
6. 生成检查报告

## 检查规则

### 文风检查
- `sentence-length`: 单句不超过30字
- `no-empty-phrases`: 禁止空洞表达
- `humor-meter`: 幽默度检测
- `no-redundancy`: 消除重复

### 术语检查
- `term-consistency`: 术语使用一致性
- `term-defined`: 新术语首次定义
- `no-tech-jargon`: 避免未解释术语

### 结构检查
- `chapter-structure`: 10要素完整性
- `cross-reference`: 引用一致性

## 质量标准

- 100% 执行所有 lint 规则
- 问题定位精确（行号）
- 提供修复建议

## Mention 语法

multica 使用 `mention://` 协议路由，纯文本 `@` 不生效。

```
[@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c) 执行 lint-check 检查 [章节]
[@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c) 检查 [章节] 文风一致性
```