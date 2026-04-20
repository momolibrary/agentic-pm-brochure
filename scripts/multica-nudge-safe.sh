#!/usr/bin/env bash
# multica-nudge-safe.sh — 稳定版续跑提醒（带审核阶段跳过 + 冷却）
set -euo pipefail

WS="${WS:-38f948e7-3827-40d0-b3ea-519c39440bf7}"
CLI="${MULTICA_CLI:-/opt/homebrew/bin/multica}"
STALE_MIN="${STALE_MIN:-20}"
MAX_NUDGE="${1:-2}"
NUDGE_COOLDOWN_MIN="${NUDGE_COOLDOWN_MIN:-60}"
MEMBER_ID="${MEMBER_ID:-50a90523-6e80-4107-9d3c-55ae656dddf4}"

info()  { echo "[nudge-safe] $*"; }
ok()    { echo "[ok] $*"; }
warn()  { echo "[warn] $*"; }

mention_for_assignee() {
  case "$1" in
    7ba899bd-9e47-43d6-8f82-9940839f157c) echo "[@主编](mention://agent/7ba899bd-9e47-43d6-8f82-9940839f157c)" ;;
    a054c330-d1a7-445c-b9da-94b8564970b2) echo "[@作者](mention://agent/a054c330-d1a7-445c-b9da-94b8564970b2)" ;;
    6586d624-bd24-4af2-884c-2ce54705555c) echo "[@审稿人](mention://agent/6586d624-bd24-4af2-884c-2ce54705555c)" ;;
    4828ea52-91fe-4422-b101-b3504d28b82c) echo "[@研究员](mention://agent/4828ea52-91fe-4422-b101-b3504d28b82c)" ;;
    2eb4c3b6-d91c-4372-9245-61769ab1032b) echo "[@案例师](mention://agent/2eb4c3b6-d91c-4372-9245-61769ab1032b)" ;;
    2f0e9417-105a-4607-8ee3-9dd26527f578) echo "[@插画师](mention://agent/2f0e9417-105a-4607-8ee3-9dd26527f578)" ;;
    *) echo "" ;;
  esac
}

should_skip_issue() {
  local issue_id="$1"
  local comments_json latest_nudge_at latest_nudge_epoch now_epoch age_min review_signal

  comments_json="$($CLI issue comment list "$issue_id" --workspace-id "$WS" --output json 2>/dev/null || echo '[]')"
  now_epoch="$(date +%s)"

  review_signal="$(echo "$comments_json" | jq -r '[.[] | (.content // "")] | any(contains("请人类确认") or contains("人类确认") or contains("终审报告") or contains("审核通过，可进入下一阶段") or contains("请 [@主编]"))')"
  if [[ "$review_signal" == "true" ]]; then
    echo "review-stage"
    return
  fi

  latest_nudge_at="$(echo "$comments_json" | jq -r --arg mid "$MEMBER_ID" '[.[] | select(.author_type=="member" and .author_id==$mid and ((.content // "") | test("续跑提醒（限流模式）"))) | .created_at] | last // ""')"
  if [[ -n "$latest_nudge_at" ]]; then
    latest_nudge_epoch="$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$latest_nudge_at" +%s 2>/dev/null || echo 0)"
    if [[ "$latest_nudge_epoch" -gt 0 ]]; then
      age_min=$(( (now_epoch - latest_nudge_epoch) / 60 ))
      if [[ "$age_min" -lt "$NUDGE_COOLDOWN_MIN" ]]; then
        echo "cooldown:${age_min}m"
        return
      fi
    fi
  fi

  echo ""
}

info "workspace: $WS"
info "policy: stale>${STALE_MIN}m, max_nudge=${MAX_NUDGE}, cooldown=${NUDGE_COOLDOWN_MIN}m"

ISSUES_JSON="$($CLI issue list --workspace-id "$WS" --output json)"
NOW_EPOCH="$(date +%s)"
CANDIDATES="$(echo "$ISSUES_JSON" | jq -c '.issues[] | select(.title|test("^\\[CH-(03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27)\\]")) | select(.status=="in_progress")')"

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
  [[ "$COUNT" -ge "$MAX_NUDGE" ]] && continue

  MENTION="$(mention_for_assignee "$ASSIGNEE_ID")"
  [[ -z "$MENTION" ]] && continue

  SKIP_REASON="$(should_skip_issue "$ISSUE_ID")"
  if [[ -n "$SKIP_REASON" ]]; then
    warn "skip: ${IDENTIFIER} (${SKIP_REASON})"
    continue
  fi

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
  warn "没有成功发送续跑提醒（全部命中跳过规则）"
else
  info "done: sent ${COUNT} nudges"
fi
