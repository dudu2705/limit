#!/bin/bash
# Claude Code statusLine script: two gauges that start at 100% and drain —
# one for the context-window token limit, one for the 5-hour rate limit.
#
# Wire it up in settings.json:
#   {
#     "statusLine": {
#       "type": "command",
#       "command": "~/.claude/plugins/limit/scripts/limit-bar.sh"
#     }
#   }

input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')

# "Magic mushroom blue" — vivid electric blue, true-color.
BLUE='\033[38;2;77;127;255m'; GRAY='\033[90m'; RESET='\033[0m'
BAR_WIDTH=20

# Renders a "remaining%" gauge: filled blocks = what's left, draining as usage grows.
build_bar() {
  local remain=$1
  local filled=$((remain * BAR_WIDTH / 100))
  local empty=$((BAR_WIDTH - filled))
  local bar=""
  [ "$filled" -gt 0 ] && printf -v fill "%${filled}s" && bar="${fill// /█}"
  [ "$empty" -gt 0 ] && printf -v pad "%${empty}s" && bar="${bar}${pad// /░}"
  echo -e "${BLUE}${bar}${RESET} ${remain}%"
}

# --- Context window gauge ---
USED=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
[ -z "$USED" ] && USED=0
CTX_REMAIN=$((100 - USED))
[ "$CTX_REMAIN" -lt 0 ] && CTX_REMAIN=0

CTX_LINE="[$MODEL] $(build_bar "$CTX_REMAIN")"

# --- 5-hour rate limit gauge ("limit token") ---
RATE_USED=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' | cut -d. -f1)

if [ -n "$RATE_USED" ]; then
  RATE_REMAIN=$((100 - RATE_USED))
  [ "$RATE_REMAIN" -lt 0 ] && RATE_REMAIN=0
  RATE_LINE="limit $(build_bar "$RATE_REMAIN")"
else
  RATE_LINE="${GRAY}limit n/a${RESET}"
fi

echo -e "${CTX_LINE}  |  ${RATE_LINE}"
