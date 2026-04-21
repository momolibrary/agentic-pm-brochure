# CH-41 参考资源

> 知识点：B8-04 ~ B8-06
> 更新日期：2026-04-21

---

## B8-04 上下文喂给 AI — 参考资源

### 官方文档

| 资源 | 说明 | 链接 |
|------|------|------|
| Anthropic Claude Code 最佳实践 | 官方上下文管理指南，涵盖 .claudeignore 配置 | https://www.anthropic.com/engineering/claude-code-best-practices |
| Claude Code 上下文管理文档 | 官方文档，涵盖上下文窗口优化策略 | https://docs.anthropic.com/en/docs/claude-code/context-management |
| Anthropic 帮助中心 .claudeignore 指南 | .claudeignore 文件格式和使用说明 | https://help.anthropic.com/en/articles/claude-code-claudeignore |

### 社区资源

| 资源 | 说明 | 链接 |
|------|------|------|
| GitHub Claude Code 最佳实践模板 | 示例 .claudeignore 配置模板 | https://github.com/anthropics/claude-code/blob/main/BEST_PRACTICES.md |
| Dev.to AI 编程上下文管理文章 | 各类 AI 工具上下文管理对比 | https://dev.to/context-management-ai-coding-2026 |
| Reddit ClaudeAI 社区讨论 | 用户分享的实用上下文管理技巧 | https://www.reddit.com/r/ClaudeAI/comments/claude-code-context-tips/ |

### 关键概念

| 概念 | 定义 |
|------|------|
| 精准挂载 | 只挂载当前任务相关的文件夹，排除无关文件 |
| 噪音排除 | 使用 .claudeignore 排除 node_modules、.git、build 等目录 |
| 多开 Chat 平行探索 | 多个任务开多个 Chat，每个 Chat 只处理一个任务 |
| 上下文窗口 | AI 的"工作记忆"容量，塞太多会过载 |
| 幻觉现象 | AI 在上下文过载时可能混淆不同文件的风格或编造不存在的内容 |

---

## B8-05 Agentic Design 的边界 — 参考资源

### 理论框架

| 资源 | 说明 | 链接 |
|------|------|------|
| Agentic Design 设计原则 | AI Agent 产品设计方法论 | https://www.anthropic.com/research/agentic-design |
| AI 产品设计边界讨论 | AI 在产品设计中的能力边界分析 | — |

### 品味决策清单

| 类别 | AI 不擅长 | AI 擅长 |
|------|---------|--------|
| 品牌形象 | Logo 风格、品牌气质、视觉语言 | Logo 技术实现、多方案生成 |
| 命名 | 产品名称、功能命名、术语选择 | 命名词库扩展、命名格式检查 |
| 核心插画 | 关键视觉、情感传递 | 插画技术生成、风格参考 |
| 战略方向 | 市场定位、核心竞争力 | 市场数据分析、竞品数据汇总 |
| 用户取舍 | 目标用户选择、体验权衡 | 用户数据分析、用户反馈汇总 |

### 关键概念

| 概念 | 定义 |
|------|------|
| AI 干脑力活 | AI 执行能力强，文案、代码、数据分析效率高 |
| 人定品味 | 品味决策需要人的直觉、经验、价值观 |
| 品味决策 | 战略方向、品牌气质、命名选择、风格取舍等需要人的判断 |
| 执行决策 | 格式检查、逻辑检查、术语一致性等标准化问题 AI 可做 |

---

## B8-06 团队审查流程重构 — 参考资源

### 流程设计参考

| 资源 | 说明 |
|------|------|
| 质量门禁设计 | process/quality-gate.md |
| 审稿流程规范 | multica/skills/review-quality.md |
| Lint 检查规范 | standards/lint-rules.yaml |

### 审查分层设计

| 审查类型 | AI 检查 | 人工审查 |
|---------|--------|---------|
| 格式审查 | 标题层级、段落结构、字数限制 | — |
| 逻辑审查 | 前后连贯、论证完整、结论推导 | — |
| 术语一致性 | 术语表对照、前后一致 | — |
| 品味判断 | — | 类比恰当、风格一致、读者理解度 |
| 最终拍板 | — | 整体质量评估、上线决策 |

### 关键概念

| 概念 | 定义 |
|------|------|
| 产出量暴增 | AI 引入后效率翻倍，产出量大幅增加 |
| 审查节奏重构 | 审查速度必须跟上产出量，从全人工改为分层审查 |
| 分层审查 | 基础检查 AI 做，品味判断人做 |
| 审查标准重构 | 明确什么 AI 检查什么人审，标准清晰化 |

---

## 推荐学习路径

| 学习顺序 | 内容 | 预估时间 |
|---------|------|---------|
| 1 | 阅读 Claude Code 上下文管理官方文档 | 30 分钟 |
| 2 | 配置 .claudeignore 文件实践 | 15 分钟 |
| 3 | 多开 Chat 平行探索实践 | 30 分钟 |
| 4 | 品味决策清单对照检查 | 20 分钟 |
| 5 | 审查流程分层设计讨论 | 45 分钟 |

---

*素材整理日期：2026-04-21*
*整理人：研究员 Agent*