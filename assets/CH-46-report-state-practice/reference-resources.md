# CH-46 参考资料

> 知识点：C1-03 数据报表实战 + C1-04 状态流转实战
> 更新日期：2026-04-22

---

## 数据报表设计相关

### 学术/技术资源

1. **Microsoft Power BI - Row-Level Security**
   https://learn.microsoft.com/en-us/power-bi/admin/service-admin-rls
   行级权限设计指南，适用于数据报表权限控制

2. **Tableau - Row Level Security Guide**
   https://www.tableau.com/developer/articles/row-level-security
   数据可视化工具的权限实现方案

3. **Databricks - Row-Level Security on Delta Tables**
   https://www.databricks.com/blog/2024/03/12/row-level-security-on-delta-tables.html
   大数据平台上的权限控制实现

### 性能优化相关

1. **Microsoft Power BI - Best Practices for Large Data Exports**
   https://learn.microsoft.com/en-us/power-bi/guidance/report-export-large-data
   大数据量导出的最佳实践，包含限制建议

2. **Tableau - Exporting Large Datasets**
   https://help.tableau.com/current/pro/desktop/en-us/export_data.htm
   百万级数据导出的处理策略

3. **Google Looker - Data Export Best Practices**
   https://cloud.google.com/looker/docs/exporting-data
   异步导出、流式导出方案

---

## 状态机设计相关

### 设计模式

1. **State Pattern (GOF)**
   状态模式：将状态封装为独立对象，每个状态类定义自己的行为

2. **Saga Pattern**
   分布式事务中的状态补偿模式，适用于跨服务的订单流程

3. **Process Manager Pattern**
   复杂工作流的状态协调模式，包含超时、重试处理

### 并发处理

1. **Optimistic Locking**
   乐观锁：使用版本号/时间戳检测冲突，适用于低冲突场景

2. **Pessimistic Locking**
   悲观锁：先锁定资源再操作，适用于高冲突场景

3. **Idempotent Design**
   幂等设计：重复请求不产生副作用，适用于网络不稳定场景

### 行业实践

1. **Martin Fowler - State Machine Pattern**
   https://martinfowler.com/books/eaapatterns.html
   企业应用架构模式中的状态机设计

2. **电商订单状态机最佳实践**
   - 订单状态：待支付 → 已支付 → 待发货 → 已发货 → 已签收 → 已完成
   - 异常状态：已取消、退货中、已退款
   - 超时处理：待支付超时自动取消、发货超时自动确认签收

---

## 方法框架

### 报表设计六要素框架

| 要素 | 核心问题 | 设计要点 |
|------|---------|---------|
| 展示字段 | 用户关心什么？ | 从用户视角选字段，不是数据库搬字段 |
| 筛选条件 | 用户如何缩小范围？ | 使用业务语言，不是数据库字段名 |
| 排序规则 | 数据呈现顺序？ | 默认排序 + 用户可自定义 |
| 分页策略 | 大数据量如何展示？ | 默认20-50条，支持配置 |
| 数据权限 | 不同角色看什么范围？ | 行级权限 + 列级权限 |
| 导出功能 | 数据如何输出？ | 数量限制 + 异步导出 |

### 状态机设计六步骤框架

| 步骤 | 核心任务 | 输出 |
|------|---------|------|
| ①列出所有状态 | 确定订单可能处于的阶段 | 状态清单（含异常状态） |
| ②定义合法流转路径 | 确定哪些状态可以跳转到哪些状态 | 流转矩阵 |
| ③标注流转条件 | 每个流转需要什么前置条件 | 条件规则表 |
| ④处理并发冲突 | 多操作同时触发的保护机制 | 锁策略 + 幂等设计 |
| ⑤设计异常状态 | 超时、取消、失败的流转路径 | 异常路径定义 |
| ⑥输出状态流转图 | 可视化全流程（含正常+异常路径） | 状态流转图 |

---

*素材来源：网络搜索整理*
*创建日期：2026-04-22*
*整理人：研究员 Agent*