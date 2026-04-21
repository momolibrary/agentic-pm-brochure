#!/usr/bin/env bash
# multica-restart-failed-429.sh — 重启因 429 节流失败的章节 issue（限流版）
set -euo pipefail

WS="${WS:-38f948e7-3827-40d0-b3ea-519c39440bf7}"
CLI="${MULTICA_CLI:-/opt/homebrew/bin/multica}"
MAX_RESTART="${1:-2}"
RESTART_COOLDOWN_MIN="${RESTART_COOLDOWN_MIN:-60}"

info() { echo "[restart-429] $*"; }
ok()   { echo "[ok] $*"; }
warn() { echo "[warn] $*"; }

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

is_review_stage() {
  local issue_id="$1"
  local comments_json
  comments_json="$($CLI issue comment list "$issue_id" --workspace-id "$WS" --output json 2>/dev/null || echo '[]')"
  echo "$comments_json" | jq -r '[.[] | (.content // "")] | any(contains("请人类确认") or contains("人类确认") or contains("终审报告") or contains("审核通过，可进入下一阶段") or contains("请 [@主编]"))'
}

iso_to_epoch() {
  local ts="$1"
  date -u -j -f "%Y-%m-%dT%H:%M:%SZ" "$ts" "+%s" 2>/dev/null \
    || date -u -d "$ts" "+%s" 2>/dev/null \
    || echo 0
}

has_recent_restart_comment() {
  local issue_id="$1"
  local cooldown_min="$2"
  local comments_json latest_ts latest_epoch now_epoch age_min

  comments_json="$($CLI issue comment list "$issue_id" --workspace-id "$WS" --output json 2>/dev/null || echo '[]')"
  latest_ts="$(echo "$comments_json" | jq -r '[.[] | select((.content // "") | contains("## 429 失败恢复")) | .created_at] | sort | last // ""')"
  [[ -z "$latest_ts" ]] && return 1

  latest_epoch="$(iso_to_epoch "$latest_ts")"
  now_epoch="$(date -u "+%s")"
  [[ "$latest_epoch" -le 0 ]] && return 1

  age_min=$(( (now_epoch - latest_epoch) / 60 ))
  [[ "$age_min" -lt "$cooldown_min" ]]
}

info "workspace: $WS"
info "max_restart=${MAX_RESTART}"
info "cooldown_min=${RESTART_COOLDOWN_MIN}"

ISSUES_JSON="$($CLI issue list --workspace-id "$WS" --output json)"
CH_ISSUES="$(echo "$ISSUES_JSON" | jq -c '.issues[] | select(.title|test("^\\[CH-(03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27)\\]"))')"

ROWS=""
while IFS= read -r row; do
  [[ -z "$row" ]] && continue
  issue_id="$(echo "$row" | jq -r '.id')"
  ident="$(echo "$row" | jq -r '.identifier')"
  status="$(echo "$row" | jq -r '.status')"
  assignee_id="$(echo "$row" | jq -r '.assignee_id')"
  title="$(echo "$row" | jq -r '.title')"

  [[ "$status" == "done" ]] && continue

  latest_run="$($CLI issue runs "$issue_id" --workspace-id "$WS" --output json | jq -c 'if type=="array" then (.[-1] // {}) else (.runs[-1] // {}) end')"
  run_status="$(echo "$latest_run" | jq -r '.status // "none"')"
  task_id="$(echo "$latest_run" | jq -r '.id // ""')"
  [[ "$run_status" != "failed" ]] && continue
  [[ -z "$task_id" ]] && continue

  run_text="$($CLI issue run-messages "$task_id" --workspace-id "$WS" --output json 2>/dev/null | jq -r '[.[].content // empty] | join(" ")')"
  echo "$run_text" | rg -qi '429|throttling|quota exceeded|usage allocated quota exceeded|invalid_request_error' || continue

  review_stage="$(is_review_stage "$issue_id")"
  [[ "$review_stage" == "true" ]] && continue

  has_recent_restart_comment "$issue_id" "$RESTART_COOLDOWN_MIN" && continue

  priority=2
  [[ "$status" == "todo" ]] && priority=0
  [[ "$status" == "in_progress" ]] && priority=1

  ROWS+="${priority}"$'\t'"${ident}"$'\t'"${issue_id}"$'\t'"${status}"$'\t'"${assignee_id}"$'\t'"${title}"$'\n'
done < <(echo "$CH_ISSUES")

if [[ -z "$ROWS" ]]; then
  ok "没有待重启的 429 失败 issue"
  exit 0
fi

COUNT=0
while IFS=$'\t' read -r priority ident issue_id status assignee_id title; do
  [[ -z "$issue_id" ]] && continue
  [[ "$COUNT" -ge "$MAX_RESTART" ]] && break

  mention="$(mention_for_assignee "$assignee_id")"
  [[ -z "$mention" ]] && continue

  if [[ "$status" == "todo" ]]; then
    $CLI issue status "$issue_id" in_progress --workspace-id "$WS" --output json >/dev/null || true
  fi

  cat <<EOF | $CLI issue comment add "$issue_id" --workspace-id "$WS" --content-stdin --output json >/dev/null
## 429 失败恢复

上一次执行因配额节流中断：API Error 429 / throttling / usage allocated quota exceeded。
请从当前 issue 上下文继续推进，不要并发扩张；本轮恢复按 2 个一组限流。

${title}

${mention}
EOF

  ok "restarted: ${ident} (${status})"
  COUNT=$((COUNT + 1))
done < <(echo "$ROWS" | sort -n -k1,1 -k2,2)

info "done: restarted ${COUNT} issue(s)"
