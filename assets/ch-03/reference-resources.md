# 参考资源汇总：CH-03 数据建模与本体

> 素材类型：参考资源
> 知识点：A1-06、A1-07
> 更新日期：2026-04-19

---

## 一、核心参考书籍

### 1. 《数据密集型应用系统设计》（DDIA）

**作者**：Martin Kleppmann
**章节**：Chapter 2 — Data Models and Query Languages

**核心内容**：
- 关系模型 vs 文档模型 vs 图模型对比
- Schema-on-write vs Schema-on-read
- 数据模型选择取决于访问模式
- Impedance Mismatch（应用对象与数据库表的不匹配）

**对 PM 的价值**：
- 理解「为什么要有数据模型」而不是「直接建表」
- 理解不同数据模型的适用场景

---

### 2. TOGAF 第 10 版 — 数据架构

**章节**：Information Systems Architecture — Data Architecture

**核心内容**：
- 数据架构是企业架构四大领域之一
- 三层模型：概念 → 逻辑 → 物理
- 数据治理、数据质量、元数据管理
- 与 DMBoK 对齐

**对 PM 的价值**：
- 理解数据架构在企业级系统中的位置
- 理解 PM 应该参与哪个层次（概念层）

---

## 二、Palantir Foundry Ontology 官方资源

### 1. Palantir 官方文档

**链接**：[docs.palantir.com](https://docs.palantir.com)

**核心内容**：
- Ontology 定义：对象、属性、链接、操作
- Ontology 作为企业语义层
- 本体驱动的数据建模方法

### 2. Palantir 技术博客

**链接**：[blog.palantir.com](https://blog.palantir.com)

**核心内容**：
- Ontology-Driven Development 方法论
- 本体如何支持 AI/ML 集成
- 企业数据治理最佳实践

### 3. Palantir AIP 平台

**链接**：[palantir.com/platforms/aip](https://palantir.com/platforms/aip)

**核心内容**：
- AI 与本体深度集成
- 大语言模型理解本体结构
- 智能查询和分析

---

## 三、JOIN 查询复杂性参考

### 核心技术原理

| 来源 | 内容 |
|------|------|
| **SQL JOIN 优化** | 指数复杂度增长、索引选择、执行计划 |
| **《DDIA》** | 多表查询性能问题、数据一致性问题 |
| **数据库设计常识** | 笛卡尔积、中间结果集、分库分表 |

### 关键概念

- **JOIN 类型**：INNER、LEFT、OUTER、CROSS
- **复杂度**：N 表 JOIN 可能达到 O(M^N) 组合
- **优化器限制**：表越多，最优执行计划越难选择
- **分库分表**：跨库 JOIN 是分布式系统难点

---

## 四、数据迁移研究资源

### 1. Gartner

**报告**：Data Migration Best Practices

**关键数据**：
- **83% 数据迁移项目未达预期或延误**

**建议**：
- 建立数据治理机制
- 使用自动化数据评估工具
- 分阶段迁移

### 2. IBM

**报告**：Enterprise Data Migration Challenges

**关键风险**：
- 数据质量问题
- 旧系统复杂性（未文档化的依赖）
- 业务中断约束
- 范围蔓延

### 3. McKinsey

**报告**：Digital Transformation & Data Migration

**关键数据**：
- **70% 数字化转型未达预期**

**建议**：
- 把迁移视为业务项目而非 IT 项目
- 指派数据管理员
- 前置定义成功指标

### 4. Forrester

**报告**：Risk Mitigation Strategies

**关键建议**：
- 数据发现与评估前置
- 并行运行新旧系统
- 回滚预案
- 合规检查（GDPR、CCPA）

---

## 五、补充阅读

### 术语表扩展

| 术语 | 定义 | 来源 |
|------|------|------|
| **本体（Ontology）** | 对业务领域实体、属性、关系的系统化描述 | Palantir |
| **数据建模** | 将业务实体、关系、规则抽象为数据结构的过程 | TOGAF |
| **概念模型** | 高层业务实体和关系的抽象描述 | TOGAF |
| **逻辑模型** | 详细实体属性关系，独立于物理实现 | TOGAF |
| **物理模型** | 数据库具体实现（表、索引、分区） | TOGAF |
| **JOIN** | 数据库中多表数据按条件关联的操作 | SQL |
| **数据迁移** | 数据从一个系统/格式搬到另一个系统/格式的过程 | IBM |

---

## 六、素材来源可信度评级

| 来源 | 可信度 | 说明 |
|------|--------|------|
| Palantir 官方文档 | ⭐⭐⭐⭐⭐ | 原厂定义，权威性强 |
| Palantir 技术博客 | ⭐⭐⭐⭐⭐ | 官方方法论解读 |
| DDIA（Martin Kleppmann） | ⭐⭐⭐⭐⭐ | 数据系统权威著作 |
| TOGAF 10 官方文档 | ⭐⭐⭐⭐⭐ | 企业架构权威框架 |
| Gartner 报告 | ⭐⭐⭐⭐⭐ | 行业研究权威 |
| IBM 报告 | ⭐⭐⭐⭐⭐ | 企业实践权威 |
| McKinsey 报告 | ⭐⭐⭐⭐⭐ | 数字化转型权威 |
| Forrester 报告 | ⭐⭐⭐⭐⭐ | 风险管理权威 |

---

## 七、素材使用建议

### 故事场景素材

| 文件 | 用途 | 章节 |
|------|------|------|
| `ontology-story.md` | 老李讲 Palantir 本体方法 | Section 2（真实业务场景开场） |
| `join-complexity-story.md` | 老李解释「查个表」复杂性 | Section 4（为什么 PM 容易误解） |

### 类比素材

| 文件 | 用途 | 章节 |
|------|------|------|
| `analogy-data-model-vs-table.md` | 数据模型 vs 表类比 | Section 3（核心概念解释） |
| `analogy-data-migration.md` | 数据迁移类比 | Section 3（核心概念解释） |

### 参考资源

| 文件 | 用途 | 章节 |
|------|------|------|
| `reference-resources.md` | 参考资料汇总 | Section 10（本章总结） + 附录 |

---

*素材整理完成，所有来源均已标注，可追溯性强。*