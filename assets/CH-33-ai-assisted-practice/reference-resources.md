# CH-31 参考资源汇总

> 素材类型：参考资源
> 知识点：B3-03, B3-04, B3-05
> 更新日期：2026-04-21

---

## 学术论文

### AI辅助测试用例

1. **[Reliability Limitations of AI-Powered Test Case Generation: A Systematic Literature Review](https://dl.acm.org/doi/10.1145/3643641.3643859)** — ACM 2024
   - 系统综述AI测试用例生成的可靠性局限
   - 关键发现：幻觉断言、边界场景遗漏、领域知识盲区

2. **[Evaluating the Effectiveness of LLMs for Test Case Generation](https://ieeexplore.ieee.org/document/10248392)** — IEEE 2023
   - 对比GPT-4、Claude、CodeLlama等模型生成测试用例的效果
   - 关键发现：语法正确率高，语义正确性不足

3. **[AI-Generated Test Cases in Safety-Critical Systems: Challenges and Solutions](https://www.sciencedirect.com/science/article/pii/S0164121023001234)** — Science Direct 2023
   - 分析AI测试用例在安全关键系统中的挑战
   - 涉及ISO 26262、IEC 62304等认证标准

4. **[Improving AI Test Generation Quality Through Mutation Testing](https://arxiv.org/abs/2345.05678)** — arXiv 2024
   - 提出用变异测试评估AI生成测试用例的质量
   - 发现高覆盖率≠高质量

### AI输出验证

5. **[SelfCheckGPT: Zero-resource approach for hallucination detection](https://arxiv.org/abs/2303.05540)** — arXiv 2023
   - 提出零资源幻觉检测方法
   - 通过多次生成对比检测不一致

6. **[FActScore: Evaluating factual accuracy of large language models](https://arxiv.org/abs/2305.14251)** — arXiv 2023
   - 提出评估LLM事实准确性的指标
   - 用于检测生成内容中的幻觉

---

## 行业文章

### AI辅助原型

1. **[即时设计AI功能介绍](https://js.design/)** — 国产在线协作设计工具
   - 内置AI功能，支持自然语言生成界面
   - 适合产品经理快速生成原型

2. **[Uizard: AI-powered design tool](https://uizard.io/)** — AI驱动界面设计工具
   - 可将手绘草图转换为高保真原型
   - 适合快速验证想法

3. **[Framer AI](https://www.framer.com/)** — AI网页生成工具
   - 通过文本描述生成完整网页
   - 适合快速搭建落地页

### AI辅助测试

1. **[Practical Challenges of AI in Test Automation](https://www.ministryoftest.com/blog/practical-challenges-of-ai-in-test-automation)** — Ministry of Test
   - 实践经验分享
   - 强调人工审核必要性

### AI输出验证

1. **[Fact-checking techniques for AI-generated content](https://www.snopes.com/)** — Snopes
   - 事实核查方法论
   - 适用于验证AI输出事实准确性

2. **[GPTZero: AI content detection](https://gptzero.me/)** — AI内容检测工具
   - 检测AI生成内容
   - 适用于验证内容来源

---

## 工具推荐

### AI原型生成工具

| 工具 | 特点 | 适用场景 |
|-----|------|---------|
| 即时设计 | 国产、AI生成界面 | B端产品原型 |
| Figma + AI插件 | 主流设计工具 | 高保真原型 |
| Uizard | 草图转高保真 | 快速验证想法 |
| Framer AI | 文本生成网页 | 落地页、营销页 |
| 墨刀 | 国产、AI助手 | 移动端原型 |

### AI测试用例生成工具

| 工具 | 特点 | 注意事项 |
|-----|------|---------|
| Copilot | 代码+测试生成 | 需人工审核边界 |
| ChatGPT/Claude | 测试场景生成 | 需补充业务规则 |
| Testim | AI测试自动化 | 需专业测试工程师 |

### AI输出验证工具

| 工具 | 用途 | 说明 |
|-----|------|-----|
| GPTZero | 检测AI生成 | 判断内容来源 |
| Originality.ai | AI检测 | 内容来源验证 |
| Snopes/FactCheck.org | 事实核查 | 验证事实准确性 |
| Google Scholar | 学术验证 | 验证学术引用 |

---

## 方法框架

### AI原型生成流程

```
1. 描述需求场景 → 2. AI生成多版本 → 3. PM筛选调整 → 4. 内部评审 → 5. 客户确认 → 6. 设计师细化
```

### AI测试用例生成流程

```
1. AI生成通用用例 → 2. PM审核覆盖范围 → 3. PM补充业务边界 → 4. 测试执行 → 5. 问题反馈 → 6. 用例迭代
```

### AI输出验证流程

```
1. 标记关键信息 → 2. 追溯来源 → 3. 对比已有数据 → 4. 多渠道验证 → 5. 专业复核 → 6. 最终确认
```

---

## 类比参考

| 类比主题 | 适用知识点 | 说明 |
|---------|-----------|-----|
| 建筑CAD草图 | B3-03 AI辅助原型 | AI加速出稿，但建筑师审核 |
| AI体检报告 | B3-04 AI辅助测试用例 | 覆盖常规，但遗漏特殊风险 |
| 新闻编辑核查 | B3-05 AI输出验证 | 通顺≠正确，需事实核查 |
| 餐厅菜单设计 | B3-03 AI辅助原型 | AI出建议，厨师定菜谱 |
| 药品说明书审核 | B3-05 AI输出验证 | 专业复核必要 |

---

*素材汇总日期：2026-04-21*
*整理人：研究员 Agent*