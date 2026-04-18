#!/usr/bin/env bash
# multica-gc.sh — 清理已合并分支和过期 worktree
# 用法: ./scripts/multica-gc.sh [--dry-run]
#
# 清理范围:
#   1. 已合并到 main 的本地分支
#   2. 远端已删除的 stale 引用
#   3. 超过 7 天的 multica worktree 目录
#   4. bare clone 中悬空的 worktree 引用

set -euo pipefail

DRY_RUN="${1:-}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[gc]${NC} $*"; }
ok()    { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
dry()   { echo -e "${YELLOW}[dry-run]${NC} 将执行: $*"; }

# ─── 1. 已合并到 main 的本地分支 ───
info "检查已合并到 main 的本地分支..."
MERGED=$(git branch --merged main 2>/dev/null | grep -v '\* main' | grep -v '^  main$' | sed 's/^  //' || true)

if [[ -n "$MERGED" ]]; then
    echo "$MERGED" | while IFS= read -r branch; do
        [[ -z "$branch" ]] && continue
        if [[ "$DRY_RUN" == "--dry-run" ]]; then
            dry "git branch -d $branch"
        else
            git branch -d "$branch" 2>/dev/null && ok "删除本地分支: $branch" || warn "跳过: $branch"
        fi
    done
else
    ok "无已合并的 stale 本地分支"
fi

# ─── 2. 远端 stale 引用 ───
info "清理远端 stale 引用..."
if [[ "$DRY_RUN" == "--dry-run" ]]; then
    dry "git fetch --prune"
    git remote prune origin --dry-run 2>/dev/null || true
else
    BEFORE=$(git branch -r | wc -l)
    git fetch --prune 2>/dev/null
    AFTER=$(git branch -r | wc -l)
    PRUNED=$((BEFORE - AFTER))
    if [[ $PRUNED -gt 0 ]]; then
        ok "清理了 $PRUNED 个 stale 远端引用"
    else
        ok "远端引用干净"
    fi
fi

# ─── 3. multica worktree 目录 ───
WORKSPACES_DIR="$HOME/multica_workspaces"
if [[ -d "$WORKSPACES_DIR" ]]; then
    info "检查 multica worktree 目录（超过 7 天）..."
    TOTAL_SIZE=$(du -sh "$WORKSPACES_DIR" 2>/dev/null | cut -f1)
    info "当前 worktree 总占用: $TOTAL_SIZE"

    STALE_DIRS=$(find "$WORKSPACES_DIR" -maxdepth 3 -name "workdir" -type d -mtime +7 2>/dev/null || true)
    if [[ -n "$STALE_DIRS" ]]; then
        COUNT=$(echo "$STALE_DIRS" | wc -l | tr -d ' ')
        warn "发现 $COUNT 个超过 7 天的 worktree"
        echo "$STALE_DIRS" | while IFS= read -r dir; do
            [[ -z "$dir" ]] && continue
            PARENT=$(dirname "$dir")
            AGE=$(( ( $(date +%s) - $(stat -f%m "$dir") ) / 86400 ))
            if [[ "$DRY_RUN" == "--dry-run" ]]; then
                dry "rm -rf $PARENT  (${AGE}天前)"
            else
                rm -rf "$PARENT" && ok "删除: $PARENT (${AGE}天前)"
            fi
        done
    else
        ok "无超期 worktree"
    fi

    # 清理 bare clone 悬空引用
    info "清理 bare clone 悬空 worktree 引用..."
    find "$WORKSPACES_DIR/.repos" -name "*.git" -type d 2>/dev/null | while IFS= read -r bare; do
        [[ -z "$bare" ]] && continue
        if [[ "$DRY_RUN" == "--dry-run" ]]; then
            dry "git -C $bare worktree prune"
        else
            git -C "$bare" worktree prune 2>/dev/null
        fi
    done
    ok "bare clone worktree 引用已清理"
else
    info "未找到 multica_workspaces 目录，跳过"
fi

# ─── 4. 汇总 ───
echo ""
info "当前状态:"
echo "  本地分支: $(git branch | wc -l | tr -d ' ')"
echo "  远端分支: $(git branch -r | wc -l | tr -d ' ')"
echo "  Worktree: $(git worktree list | wc -l | tr -d ' ')"
if [[ -d "$WORKSPACES_DIR" ]]; then
    echo "  multica workspaces: $(du -sh "$WORKSPACES_DIR" 2>/dev/null | cut -f1)"
fi

echo ""
ok "gc 完成"
