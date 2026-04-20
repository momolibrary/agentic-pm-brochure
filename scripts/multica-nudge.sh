#!/usr/bin/env bash
# multica-nudge.sh — 停滞任务小批量续跑（限流版）
# 用法:
#   ./scripts/multica-nudge.sh
#   ./scripts/multica-nudge.sh 5
#   STALE_MIN=30 ./scripts/multica-nudge.sh 2

set -euo pipefail

WS="${WS:-38f948e7-3827-40d0-b3ea-519c39440bf7}"
CLI="${MULTICA_CLI:-/opt/homebrew/bin/multica}"
STALE_MIN="${STALE_MIN:-20}"
MAX_NUDGE="${1:-3}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[nudge]${NC} $*"; }
ok()    { echo -e "${GREEN}[ok]${NC} $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC} $*"; }
err()   { echo -e "${RED}[err]${NC} $*"; }

if ! command -v "$CLI" >/dev/null 2>&1; then
  err "multica CLI not found: $CLI"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  err "jq is required"
  exit 1
fi

mention_for_assignee() {
  case "$1" in
    7ba899bd-9e47-43d6-8f82-9940839f157c)
      echo "[@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c)"
      ;;
    a054c330-d1a7-445c-b9da-94b8564970b2)
      echo "[@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2)"
      ;;
    6586d624-bd24-4af2-884c-2ce54705555c)
      echo "[@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c)"
      ;;
    4828ea52-91fe-4422-b101-b3504d28b82c)
      echo "[@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c)"
      ;;
    2eb4c3b6-d91c-4372-9245-61769ab1032b)
      echo "[@案例师](mention://agent/2eb4c3b6-d91c-4372-9245-61769ab1032b)"
      ;;
    2f0e9417-105a-4607-8ee3-9dd26527f578)
      echo "[@插画师](mention://agent/2f0e9417-105a-4607-8ee3-9dd26527f578)"
      ;;
    *)
      echo ""
      ;;
  esac
}

info "workspace: $WS"
info "policy: stale>${STALE_MIN}m, max_nudge=${MAX_NUDGE}"

ISSUES_JSON="$($CLI issue list --workspace-id "$WS" --output json)"
NOW_EPOCH="$(date +%s)"

CANDIDATES="$(echo "$ISSUES_JSON" | jq -c '.issues[] | select(.title|test("^\\[CH-(03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27)\\]")) | select(.status=="in_progress")')"

# 构造: age_min<TAB>id<TAB>identifier<TAB>assignee_id<TAB>title
ROWS=""
while IFS= read -r row; do
  [[ -z "$row" ]] && continue
  UPDATED_AT="$(echo "$row" | jq -r '.updated_at')"
  UPDATED_EPOCH="$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$UPDATED_AT" +%s 2>/dev/null || echo 0)"
  [[ "$UPDATED_EPOCH" -eq 0 ]] && continue
  AGE_MIN=$(( (NOW_EPOCH - UPDATED_EPOCH) / 60 ))
  if [[ "$AGE_MIN" -gt "$STALE_MIN" ]]; then
    ID="$(echo "$row" | jq -r '.id')"
    IDENTIFIER="$(echo "$row" | jq -r '.identifier')"
    ASSIGNEE_ID="$(echo "$row" | jq -r '.assignee_id')"
    TITLE="$(echo "$row" | jq -r '.title')"
    ROWS+="${AGE_MIN}"$'\t'"${ID}"$'\t'"${IDENTIFIER}"$'\t'"${ASSIGNEE_ID}"$'\t'"${TITLE}"$'\n'
  fi
done < <(echo "$CANDIDATES")

if [[ -z "$ROWS" ]]; then
  ok "没有需要续跑的停滞任务"
  exit 0
fi

COUNT=0
while IFS=$'\t' read -r AGE_MIN ISSUE_ID IDENTIFIER ASSIGNEE_ID TITLE; do
  [[ -z "$ISSUE_ID" ]] && continue
  if [[ "$COUNT" -ge "$MAX_NUDGE" ]]; then
    continue
  fi

  MENTION="$(mention_for_assignee "$ASSIGNEE_ID")"
  [[ -z "$MENTION" ]] && continue

  cat <<EOF | "$CLI" issue comment add "$ISSUE_ID" --workspace-id "$WS" --content-stdin --output json >/dev/null
## 续跑提醒（限流模式）

当前 issue 处于 in_progress 且已 ${AGE_MIN} 分钟无更新。
请在当前上下文继续执行并在完成后按既定流程交接下游（无需并发扩张）。

${TITLE}

${MENTION}
EOF

  ok "nudged: ${IDENTIFIER} (${AGE_MIN}m)"
  COUNT=$((COUNT + 1))
done < <(echo "$ROWS" | sort -nr -k1,1)

if [[ "$COUNT" -eq 0 ]]; then
  warn "没有成功发送续跑提醒（可能 assignee 缺失）"
else
  info "done: sent ${COUNT} nudges"
fi
