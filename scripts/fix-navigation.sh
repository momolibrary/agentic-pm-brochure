#!/bin/bash
# Fix all chapter navigation links
# Run from: manuscript/chapters/

cd "$(dirname "$0")/../manuscript/chapters" || exit 1

echo "=== Phase 1: Remove all existing navigation lines ==="
for f in CH-*.md; do
  # Remove lines starting with *下一章预告 or 下一章预告 or *上一章
  sed -i '' '/^\*下一章预告/d' "$f"
  sed -i '' '/^下一章预告/d' "$f"
  sed -i '' '/^\*上一章/d' "$f"
done
echo "Old navigation removed."

echo "=== Phase 2: Append correct navigation ==="

# Define chapter files and their next chapter info
# Format: "filename|next_chapter_preview"
nav_entries=(
  "CH-01-数据基础.md|*下一章预告：CH-02 数据流转与约束*"
  "CH-02-数据流转与约束.md|*下一章预告：CH-03 数据建模与本体*"
  "CH-03-数据建模与本体.md|*下一章预告：CH-04 接口基础*"
  "CH-04-接口基础.md|*下一章预告：CH-05 系统集成与边界*"
  "CH-05-系统集成与边界.md|*下一章预告：CH-06 API设计原则与常见问题*"
  "CH-06-API设计原则与常见问题.md|*下一章预告：CH-07 流程基础*"
  "CH-07-流程基础.md|*下一章预告：CH-08 异常流程与编排*"
  "CH-08-异常流程与编排.md|*下一章预告：CH-09 活动定义与流程架构*"
  "CH-09-活动定义与流程架构.md|*下一章预告：CH-10 流程遵从性与挖掘困难*"
  "CH-10-流程遵从性与挖掘困难.md|*下一章预告：CH-11 流程治理与行业标准*"
  "CH-11-流程治理与行业标准.md|*下一章预告：CH-12 权限基础*"
  "CH-12-权限基础.md|*下一章预告：CH-13 数据权限与继承*"
  "CH-13-数据权限与继承.md|*下一章预告：CH-14 权限框架与认证体系*"
  "CH-14-权限框架与认证体系.md|*下一章预告：CH-15 状态基础与约束*"
  "CH-15-状态基础与约束.md|*下一章预告：CH-16 状态冲突与状态机*"
  "CH-16-状态冲突与状态机.md|*下一章预告：CH-17 验收与测试*"
  "CH-17-验收与测试.md|*下一章预告：CH-18 回归测试与监控*"
  "CH-18-回归测试与监控.md|*下一章预告：CH-19 DDD与TDD*"
  "CH-19-DDD与TDD.md|*下一章预告：CH-20 TOGAF企业架构与DevOps*"
  "CH-20-TOGAF企业架构与DevOps.md|*下一章预告：CH-21 MVC架构模式与CQRS*"
  "CH-21-MVC架构模式与CQRS.md|*下一章预告：CH-22 IDE开发工具认知*"
  "CH-22-IDE开发工具认知.md|*下一章预告：CH-23 Git认知与版本控制基础*"
  "CH-23-Git认知与版本控制基础.md|*下一章预告：CH-24 SSH服务器连接基础*"
  "CH-24-SSH服务器连接基础.md|*下一章预告：CH-25 域名DNS证书与CDN*"
  "CH-25-域名DNS证书与CDN.md|*下一章预告：CH-26 云服务前后端与数据库缓存*"
  "CH-26-云服务前后端与数据库缓存.md|*下一章预告：CH-27 消息队列日志监控与API网关*"
  "CH-27-消息队列日志监控与API网关.md|*下一章预告：CH-28 系统成本与切换代价*"
  "CH-28-系统成本与切换代价.md|*下一章预告：CH-29 人力弹性与组织耦合*"
  "CH-29-人力弹性与组织耦合.md|*下一章预告：CH-30 需求结构化*"
  "CH-30-需求结构化.md|*下一章预告：CH-31 方案预演*"
  "CH-31-方案预演.md|*下一章预告：CH-32 AI能力边界*"
  "CH-32-AI能力边界.md|*下一章预告：CH-33 AI辅助实践*"
  "CH-33-AI辅助实践.md|*下一章预告：CH-34 质量把控*"
  "CH-34-质量把控.md|*下一章预告：CH-35 协作沟通基础*"
  "CH-35-协作沟通基础.md|*下一章预告：CH-36 排期评审与Git-like协作*"
  "CH-36-排期评审与Git-like协作.md|*下一章预告：CH-37 Human-Agent协作模型*"
  "CH-37-Human-Agent协作模型.md|*下一章预告：CH-38 价值主张画布与用户旅程图*"
  "CH-38-价值主张画布与用户旅程图.md|*下一章预告：CH-39 服务蓝图与商业模式画布*"
  "CH-39-服务蓝图与商业模式画布.md|*下一章预告：CH-40 设计系统*"
  "CH-40-设计系统.md|*下一章预告：CH-41 Git协作实操*"
  "CH-41-Git协作实操.md|*下一章预告：CH-42 Agentic-Design基础*"
  "CH-42-Agentic-Design基础.md|*下一章预告：CH-43 AI上下文管理与审查重构*"
)
# CH-43 is the last chapter, no next preview needed

for entry in "${nav_entries[@]}"; do
  file="${entry%%|*}"
  nav="${entry##*|}"
  if [ -f "$file" ]; then
    # Remove trailing blank lines
    sed -i '' -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$file"
    # Append navigation
    printf '\n\n---\n\n%s\n' "$nav" >> "$file"
    echo "  ✓ $file"
  else
    echo "  ✗ MISSING: $file"
  fi
done

echo ""
echo "=== Phase 3: Verify navigation ==="
for f in CH-*.md; do
  nav=$(grep '下一章预告' "$f" 2>/dev/null | tail -1)
  if [ -n "$nav" ]; then
    echo "  $f → $nav"
  else
    echo "  $f → (no nav)"
  fi
done
