#!/usr/bin/env bash
# multica-watch.sh — 章节 issue 异常巡检（默认低请求量）
# 用法:
#   ./scripts/multica-watch.sh
#   ./scripts/multica-watch.sh --deep
#   STALE_MIN=30 ./scripts/multica-watch.sh
#   WS=<workspace-id> ./scripts/multica-watch.sh

set -euo pipefail

WS="${WS:-38f948e7-3827-40d0-b3ea-519c39440bf7}"
CLI="${MULTICA_CLI:-/opt/homebrew/bin/multica}"
MODE="light"
STALE_MIN="${STALE_MIN:-20}"

if [[ "${1:-}" == "--deep" ]]; then
  MODE="deep"
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[watch]${NC} $*"; }
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

info "workspace: $WS"
info "mode: $MODE (stale>${STALE_MIN}m)"

ISSUES_JSON="$($CLI issue list --workspace-id "$WS" --output json)"
CH_ISSUES="$(echo "$ISSUES_JSON" | jq -c '.issues[] | select(.title|test("^\\[CH-(03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27)\\]"))')"

TOTAL=$(echo "$CH_ISSUES" | wc -l | tr -d ' ')
IN_PROGRESS=$(echo "$CH_ISSUES" | jq -r 'select(.status=="in_progress") | .id' | wc -l | tr -d ' ')
TODO=$(echo "$CH_ISSUES" | jq -r 'select(.status=="todo") | .id' | wc -l | tr -d ' ')
DONE=$(echo "$CH_ISSUES" | jq -r 'select(.status=="done") | .id' | wc -l | tr -d ' ')
BLOCKED=$(echo "$CH_ISSUES" | jq -r 'select(.status=="blocked") | .id' | wc -l | tr -d ' ')
CANCELLED=$(echo "$CH_ISSUES" | jq -r 'select(.status=="cancelled") | .id' | wc -l | tr -d ' ')

echo ""
info "章节盘点"
echo "  total:      $TOTAL"
echo "  in_progress:$IN_PROGRESS"
echo "  todo:       $TODO"
echo "  done:       $DONE"
echo "  blocked:    $BLOCKED"
echo "  cancelled:  $CANCELLED"

echo ""
info "异常扫描（status=blocked/cancelled）"
STATUS_ANOM="$(echo "$CH_ISSUES" | jq -r 'select(.status=="blocked" or .status=="cancelled") | [.identifier,.id,.status,.assignee_id,.title] | @tsv')"
if [[ -n "$STATUS_ANOM" ]]; then
  echo "$STATUS_ANOM"
else
  ok "未发现 blocked/cancelled issue"
fi

echo ""
info "停滞扫描（in_progress 且长时间未更新）"
NOW_EPOCH="$(date +%s)"
STALE_COUNT=0
while IFS= read -r row; do
  [[ -z "$row" ]] && continue
  STATUS="$(echo "$row" | jq -r '.status')"
  [[ "$STATUS" != "in_progress" ]] && continue

  IDENTIFIER="$(echo "$row" | jq -r '.identifier')"
  ISSUE_ID="$(echo "$row" | jq -r '.id')"
  TITLE="$(echo "$row" | jq -r '.title')"
  UPDATED_AT="$(echo "$row" | jq -r '.updated_at')"

  UPDATED_EPOCH="$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$UPDATED_AT" +%s 2>/dev/null || echo 0)"
  [[ "$UPDATED_EPOCH" -eq 0 ]] && continue
  AGE_MIN=$(( (NOW_EPOCH - UPDATED_EPOCH) / 60 ))

  if [[ "$AGE_MIN" -gt "$STALE_MIN" ]]; then
    STALE_COUNT=$((STALE_COUNT + 1))
    echo -e "${YELLOW}${IDENTIFIER}${NC}\t${ISSUE_ID}\t${AGE_MIN}m\t${TITLE}"
  fi
done < <(echo "$CH_ISSUES")

if [[ "$STALE_COUNT" -eq 0 ]]; then
  ok "未发现停滞的 in_progress issue"
else
  warn "发现 $STALE_COUNT 条可能停滞 issue"
fi

if [[ "$MODE" == "deep" ]]; then
  echo ""
  info "深度扫描（latest run=failed/cancelled，仅用于排障）"
  RUN_ANOM_COUNT=0
  while IFS= read -r row; do
    [[ -z "$row" ]] && continue
    ISSUE_ID="$(echo "$row" | jq -r '.id')"
    IDENTIFIER="$(echo "$row" | jq -r '.identifier')"
    TITLE="$(echo "$row" | jq -r '.title')"

    RUNS_JSON="$($CLI issue runs "$ISSUE_ID" --workspace-id "$WS" --output json)"
    LATEST="$(echo "$RUNS_JSON" | jq -c 'if type=="array" then (.[-1] // {}) else (.runs[-1] // {}) end')"
    RUN_STATUS="$(echo "$LATEST" | jq -r '.status // "none"')"
    RUN_ID="$(echo "$LATEST" | jq -r '.id // "-"')"

    if [[ "$RUN_STATUS" == "failed" || "$RUN_STATUS" == "cancelled" ]]; then
      RUN_ANOM_COUNT=$((RUN_ANOM_COUNT + 1))
      echo -e "${YELLOW}${IDENTIFIER}${NC}\t${ISSUE_ID}\t${RUN_STATUS}\t${RUN_ID}\t${TITLE}"
    fi
  done < <(echo "$CH_ISSUES")

  if [[ "$RUN_ANOM_COUNT" -eq 0 ]]; then
    ok "未发现 failed/cancelled 最新执行"
  else
    warn "发现 $RUN_ANOM_COUNT 条执行异常，建议抽查 run-messages"
  fi
fi

echo ""
info "巡检完成"
