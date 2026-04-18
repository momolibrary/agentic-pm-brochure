---
skill_id: research-search
skill_uuid: "bafcf7de-d91d-443e-971a-8cf42932d145"
callers:
  - researcher      # 4828ea52-91fe-4422-b101-b3504d28b82c
external_deps:
  - tool: tavily
    required: true
    config_ref: "TAVILY_API_KEY"
registry: ../agents/manifest.yaml
---

# Skill: research-search

资料搜索与整理能力

## 功能

为章节写作提供素材支持：
- 搜索相关资料
- 整理类比素材
- 提炼关键概念解释
- 收集反例和案例素材

## 输入

- 搜索关键词
- 章节主题
- 素材类型需求（案例/类比/反例）

## 输出

- 资料摘要
- 类比建议列表
- 概念解释素材
- 参考资料链接

## 执行流程

1. 分析章节主题，提取搜索关键词
2. 执行网络搜索（Tavily）
3. 整理搜索结果，提取关键内容
4. 生成类比建议
5. 标记素材来源和可信度

## 质量标准

- 素材来源可追溯
- 类比适合产品经理理解
- 内容准确可靠

## Mention 语法

multica 使用 `mention://` 协议路由，纯文本 `@` 不生效。

```
[@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c) 搜索 [主题] 相关资料
[@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c) 为 [章节] 提供类比素材
```