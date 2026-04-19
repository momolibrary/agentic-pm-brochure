#!/usr/bin/env bash
# multica-poll.sh — 低频轮询：巡检 + 稳定续跑
set -euo pipefail

ROOT="/Users/tecson/Documents/github/agentic-pm-brochure"
INTERVAL="${INTERVAL:-180}"
MAX_NUDGE="${MAX_NUDGE:-2}"
WS="${WS:-38f948e7-3827-40d0-b3ea-519c39440bf7}"
STALE_MIN="${STALE_MIN:-20}"
NUDGE_COOLDOWN_MIN="${NUDGE_COOLDOWN_MIN:-60}"

info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

cd "$ROOT"
info "Start polling (interval=${INTERVAL}s, max_nudge=${MAX_NUDGE}, stale_min=${STALE_MIN}m, cooldown=${NUDGE_COOLDOWN_MIN}m, WS=${WS})"

ITERATION=0
while true; do
  ITERATION=$((ITERATION + 1))
  info "━━━━━━━━━━━━━━━━━━━━━━━━ Iteration ${ITERATION} ━━━━━━━━━━━━━━━━━━━━━━━━"

  WS="$WS" STALE_MIN="$STALE_MIN" ./scripts/multica-watch.sh || true
  WS="$WS" STALE_MIN="$STALE_MIN" NUDGE_COOLDOWN_MIN="$NUDGE_COOLDOWN_MIN" ./scripts/multica-nudge-safe.sh "$MAX_NUDGE" || true

  info "Next check in ${INTERVAL}s... (Ctrl+C to stop)"
  sleep "$INTERVAL"
done
