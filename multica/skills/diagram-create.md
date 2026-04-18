---
skill_id: diagram-create
skill_uuid: "ba1ae40b-16b0-4339-a431-4ac54e8ab4da"
callers:
  - illustrator     # 2f0e9417-105a-4607-8ee3-9dd26527f578
external_deps:
  - tool: glm-image
    required: false
    fallback: "mermaid markdown"
registry: ../agents/manifest.yaml
---

# Skill: diagram-create

插图与流程图绘制能力

## 功能

为章节创建可视化素材：
- 流程图
- 架构图
- 对比图
- 状态图
- 时序图

## 输入

- 图示类型
- 内容描述
- 目标读者理解需求

## 输出

- 图示文件（SVG/PNG）
- 图示说明文字

## 执行流程

1. 分析图示需求
2. 设计图示结构
3. 选择合适图示类型
4. 使用 glm-image 或其他工具生成
5. 编写图示说明

## 图示类型指南

| 类型 | 适用场景 |
|------|----------|
| 流程图 | 展示步骤流程 |
| 架构图 | 展示系统结构 |
| 对比图 | 展示前后对比 |
| 状态图 | 展示状态变迁 |
| 时序图 | 展示交互顺序 |

## 质量标准

- 图示清晰易懂
- 适合产品经理理解
- 有配套说明文字

## Mention 语法

multica 使用 `mention://` 协议路由，纯文本 `@` 不生效。

```
[@插画师](mention://agent/2f0e9417-105a-4607-8ee3-9dd26527f578) 绘制 [描述] 流程图
[@插画师](mention://agent/2f0e9417-105a-4607-8ee3-9dd26527f578) 为 [章节] 创建架构图
```