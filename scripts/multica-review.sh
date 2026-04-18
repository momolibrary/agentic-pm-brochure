#!/usr/bin/env bash
# multica-review.sh — 从 Issue 的 Handoff Comment 中提取分支，自动 fetch + diff
# 用法: ./scripts/multica-review.sh <issue-id> [--merge]
#
# 依赖: multica CLI, git, jq (可选，回退到 python3)

set -euo pipefail

ISSUE_ID="${1:?用法: $0 <issue-id> [--merge]}"
DO_MERGE="${2:-}"

# ─── 颜色 ───
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[review]${NC} $*"; }
ok()    { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
fail()  { echo -e "${RED}[✗]${NC} $*"; exit 1; }

# ─── 1. 获取 Issue 信息 ───
info "获取 Issue ${ISSUE_ID} 信息..."
ISSUE_JSON=$(multica issue get "$ISSUE_ID" --output json 2>&1)
ISSUE_TITLE=$(echo "$ISSUE_JSON" | python3 -c "import json,sys; print(json.load(sys.stdin)['title'])")
ISSUE_STATUS=$(echo "$ISSUE_JSON" | python3 -c "import json,sys; print(json.load(sys.stdin)['status'])")
info "Issue: ${ISSUE_TITLE} (状态: ${ISSUE_STATUS})"

# ─── 2. 获取最新 Handoff Comment ───
info "搜索 Handoff Comment..."
COMMENTS_JSON=$(multica issue comment list "$ISSUE_ID" --output json 2>&1)

# 找到包含 "🔀 Handoff" 或 "Handoff:" 的最新评论
HANDOFF_COMMENT=$(echo "$COMMENTS_JSON" | python3 -c "
import json, sys, re
comments = json.load(sys.stdin)
# 按时间倒序
comments.sort(key=lambda c: c.get('created_at',''), reverse=True)
for c in comments:
    content = c.get('content', '') or ''
    if 'Handoff' in content or '🔀' in content:
        print(content)
        sys.exit(0)
print('')
" 2>&1)

if [[ -z "$HANDOFF_COMMENT" ]]; then
    fail "未找到 Handoff Comment。Agent 可能还未完成交接。"
fi

ok "找到 Handoff Comment"

# ─── 3. 提取分支名 ───
BRANCH=$(echo "$HANDOFF_COMMENT" | python3 -c "
import sys, re
text = sys.stdin.read()
# 匹配 **分支**: \`xxx\` 或 Branch: xxx
m = re.search(r'[*]*分支[*]*:\s*\`([^']+)\`', text)
if not m:
    m = re.search(r'[Bb]ranch:\s*\`([^']+)\`', text)
if m:
    print(m.group(1))
" 2>&1)

if [[ -z "$BRANCH" ]]; then
    warn "无法从 Handoff Comment 中提取分支名"
    echo -e "${YELLOW}Handoff Comment 内容:${NC}"
    echo "$HANDOFF_COMMENT" | head -20
    echo ""
    read -rp "请手动输入分支名（或按 Enter 跳过）: " BRANCH
    [[ -z "$BRANCH" ]] && fail "无分支名，无法继续"
fi

info "目标分支: ${BRANCH}"

# ─── 4. 检查附件 ───
ATTACHMENTS=$(echo "$COMMENTS_JSON" | python3 -c "
import json, sys
comments = json.load(sys.stdin)
att_ids = []
for c in comments:
    content = c.get('content', '') or ''
    if 'Handoff' in content or '🔀' in content:
        for a in c.get('attachments', []):
            att_ids.append(a.get('id', ''))
if att_ids:
    print('\n'.join(att_ids))
" 2>&1)

if [[ -n "$ATTACHMENTS" ]]; then
    info "发现附件："
    echo "$ATTACHMENTS"
    read -rp "是否下载附件到 ./review/ ? (y/N): " DL
    if [[ "$DL" == "y" || "$DL" == "Y" ]]; then
        mkdir -p ./review
        while IFS= read -r att_id; do
            [[ -n "$att_id" ]] && multica attachment download "$att_id" -o ./review/
        done <<< "$ATTACHMENTS"
        ok "附件已下载到 ./review/"
    fi
fi

# ─── 5. Git fetch + diff ───
info "执行 git fetch..."
git fetch origin

# 检查分支是否存在
if ! git rev-parse --verify "origin/${BRANCH}" &>/dev/null; then
    fail "远程分支 origin/${BRANCH} 不存在。Agent 可能还未 push。"
fi

ok "分支 origin/${BRANCH} 已获取"

# diff 概要
echo ""
echo -e "${CYAN}═══════════════ 变更概要 ═══════════════${NC}"
git diff --stat "main...origin/${BRANCH}"

echo ""
echo -e "${CYAN}═══════════════ 提交历史 ═══════════════${NC}"
git log --oneline "main..origin/${BRANCH}"

echo ""
read -rp "查看完整 diff? (y/N): " SHOW_DIFF
if [[ "$SHOW_DIFF" == "y" || "$SHOW_DIFF" == "Y" ]]; then
    git diff "main...origin/${BRANCH}"
fi

# ─── 6. Merge 或退回 ───
if [[ "$DO_MERGE" == "--merge" ]]; then
    info "合并分支..."
    git merge "origin/${BRANCH}" --no-ff -m "[${ISSUE_ID}] merge ${BRANCH}"
    multica issue comment add "$ISSUE_ID" --content "审核通过，已 merge 分支 \`${BRANCH}\`。"
    multica issue status "$ISSUE_ID" approved 2>/dev/null || true
    ok "已 merge 并更新 Issue 状态"
else
    echo ""
    echo -e "${CYAN}下一步操作:${NC}"
    echo "  通过并 merge:  $0 ${ISSUE_ID} --merge"
    echo "  退回修订:      multica issue comment add ${ISSUE_ID} --content \"退回：<理由>\""
    echo "                 multica issue status ${ISSUE_ID} drafting"
fi

echo ""
ok "审核完毕"
