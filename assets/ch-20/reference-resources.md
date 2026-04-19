# CH-20 参考资源

> 章节：CH-20 — TOGAF 企业架构与 DevOps
> 更新日期：2026-04-19

---

## A7-03 TOGAF 企业架构

### 官方资源

| 资源 | 链接 | 说明 |
|------|------|------|
| The Open Group 官网 | https://www.opengroup.org/togaf | TOGAF 官方组织 |
| TOGAF 10 文档 | https://pubs.opengroup.org/togaf-standard/ | 最新版 TOGAF 标准 |
| TOGAF 认证 | https://www.opengroup.org/certifications/togaf | 官方认证信息 |

### 中文资源

| 资源 | 链接 | 说明 |
|------|------|------|
| 架构评审之痛 | https://zhuanlan.zhihu.com/p/596836392 | 架构评审的目的和改进方法 |
| 架构评审指南 | https://www.infoq.cn/article/eb8585c5-2c80-4cf6-a3de-23abf7a3d2de | InfoQ 架构评审实践指南 |
| 研发体系建设：架构评审如何落地 | https://zhuanlan.zhihu.com/p/680528564 | 架构评审落地实践 |
| 技术债务 \| 重复造轮子带来的孤岛效应 | https://zhuanlan.zhihu.com/p/688027338 | 技术孤岛案例 |
| B端产品经理与架构师 | https://zhuanlan.zhihu.com/p/699972936 | 产品经理与架构师协作 |
| 企业架构整体规划方法与案例分析 | https://www.infoq.cn/article/6575803c-e664-4e54-bc4d-3254430319ec | 企业架构实践案例 |

### 核心概念速查

| 概念 | 定义 |
|------|------|
| **TOGAF** | The Open Group Architecture Framework，企业架构框架 |
| **四大架构域（BDAT）** | Business（业务）、Data（数据）、Application（应用）、Technology（技术） |
| **ADM** | Architecture Development Method，架构开发方法 |
| **架构评审** | 评估架构设计是否符合业务需求、技术标准和最佳实践 |
| **技术孤岛** | 各团队自建系统导致的资源浪费和协作困难 |

---

## A7-04 DevOps 与持续交付

### 官方/权威资源

| 资源 | 链接 | 说明 |
|------|------|------|
| 《持续交付》 | Jez Humble & David Farley | 持续交付经典著作 |
| Red Hat DevOps | https://www.redhat.com/en/topics/devops | DevOps 概念和最佳实践 |
| AWS CI/CD | https://aws.amazon.com/devops/ | AWS DevOps 工具和流程 |
| Kubernetes Deployments | https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/ | K8s 部署策略 |

### 部署策略资源

| 资源 | 链接 | 说明 |
|------|------|------|
| What is a Canary Release? | https://www.split.io/glossary/canary-release/ | Canary Release 概念 |
| Canary Deployment Best Practices | https://www.redhat.com/en/topics/devops/what-is-a-canary-deployment | Canary 最佳实践 |
| Argo Rollouts | https://argoproj.github.io/argo-rollouts/ | 渐进式交付工具 |
| Istio Traffic Management | https://istio.io/latest/docs/concepts/traffic-management/ | Service Mesh 流量管理 |
| AWS Best Practices for Canary | https://aws.amazon.com/blogs/containers/best-practices-for-canary-deployments-with-amazon-ecs/ | ECS Canary 最佳实践 |

### CI/CD 工具

| 工具 | 链接 | 说明 |
|------|------|------|
| Jenkins | https://www.jenkins.io/ | 开源 CI/CD 工具 |
| GitHub Actions | https://github.com/features/actions | GitHub 内置 CI/CD |
| GitLab CI/CD | https://docs.gitlab.com/ee/ci/ | GitLab 内置 CI/CD |
| CircleCI | https://circleci.com/ | 云端 CI/CD |
| Azure DevOps | https://azure.microsoft.com/en-us/services/devops/ | Microsoft DevOps 平台 |
| Argo CD | https://argoproj.io/ | Kubernetes GitOps 工具 |

### 核心概念速查

| 概念 | 定义 |
|------|------|
| **CI** | Continuous Integration，持续集成（自动构建和测试） |
| **CD** | Continuous Delivery/Deployment，持续交付/部署 |
| **Pipeline** | 从代码提交到上线的自动化流程 |
| **Staging 环境** | 测试环境，接近生产环境配置 |
| **Pre-prod 环境** | 预发环境，最后一道验证关卡 |
| **灰度发布（Canary）** | 先给部分用户使用新版本，逐步扩大范围 |
| **蓝绿部署（Blue-Green）** | 维护两套环境，瞬间切换流量 |
| **回滚（Rollback）** | 发现问题后恢复到上一版本 |

---

## CI/CD Pipeline 典型阶段

```
代码提交 → 构建 → 单元测试 → 集成测试 → 部署到测试环境 → UAT 验证 → 部署到预发环境 → 上线到生产环境
```

| 阶段 | 英文名 | 主要内容 | 时长（典型） |
|------|--------|----------|-------------|
| 代码提交 | Source | Git commit/push | 5 分钟 |
| 构建 | Build | 编译代码、打包镜像 | 10-30 分钟 |
| 单元测试 | Unit Test | 测试单个模块逻辑 | 10-20 分钟 |
| 集成测试 | Integration Test | 测试模块间协作 | 20-30 分钟 |
| 测试环境部署 | Deploy Staging | 部署到 Staging | 10 分钟 |
| UAT 验证 | User Acceptance | 人工或自动验证 | 数小时 |
| 预发环境部署 | Deploy Pre-prod | 部署到 Pre-prod | 10 分钟 |
| 生产上线 | Deploy Production | 上线到生产 | 10 分钟 |

---

## 发布策略对比

| 策略 | 英文名 | 特点 | 适用场景 |
|------|--------|------|----------|
| 全量发布 | Full Rollout | 一次性给所有用户 | 低风险改动 |
| 灰度发布 | Canary Release | 先 1%-5%-25%-50%-100% | 大部分上线场景 |
| 蓝绿部署 | Blue-Green | 两套环境瞬间切换 | 需要零停机场景 |
| 滚动更新 | Rolling Update | 逐步替换实例 | Kubernetes 默认策略 |

---

## 灰度发布流量递增模式

| 模式 | 递增方式 | 示例 |
|------|----------|------|
| Linear（线性） | 固定比例递增 | 1% → 2% → 3% → 4% → 5% ... |
| Exponential（指数） | 每次翻倍 | 1% → 2% → 4% → 8% → 16% → 32% ... |
| Manual（手动） | 人工确认每步 | 1% → [人工确认] → 5% → [人工确认] → ... |

---

## 素材使用建议

- 官方资源用于正文中引用，提升可信度
- 中文资源用于补充实际案例
- 核心概念速查用于术语解释
- 部署策略对比用于读者理解不同策略选择