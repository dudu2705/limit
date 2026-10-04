#!/bin/bash
# Installs the "limit" status-line plugin on THIS machine:
#   1. Fetches scripts/limit-bar.sh into ~/.claude/plugins/limit/
#      (from a local clone if run from inside this repo, otherwise from GitHub)
#   2. Merges a "statusLine" entry into ~/.claude/settings.json
#      (keeps any other settings already in that file)
#
# Run it from a clone:
#   bash install.sh
# Or in one line, on any machine, with no clone needed:
#   curl -fsSL https://raw.githubusercontent.com/dudu2705/limit/main/install.sh | bash

set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not installed." >&2
  echo "  Debian/Ubuntu: sudo apt install jq" >&2
  echo "  macOS:         brew install jq" >&2
  exit 1
fi

RAW_URL="https://raw.githubusercontent.com/dudu2705/limit/main/scripts/limit-bar.sh"
DEST_DIR="$HOME/.claude/plugins/limit/scripts"
DEST_SCRIPT="$DEST_DIR/limit-bar.sh"
SETTINGS="$HOME/.claude/settings.json"

mkdir -p "$DEST_DIR"

# ${BASH_SOURCE[0]} points at a real file only when this script is run from a
# saved/cloned copy. When piped straight from curl, there is no local file to
# copy from, so fall back to downloading it from GitHub.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd || true)"
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/scripts/limit-bar.sh" ]; then
  cp "$SCRIPT_DIR/scripts/limit-bar.sh" "$DEST_SCRIPT"
else
  curl -fsSL "$RAW_URL" -o "$DEST_SCRIPT"
fi
chmod +x "$DEST_SCRIPT"

mkdir -p "$(dirname "$SETTINGS")"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

TMP=$(mktemp)
jq --arg cmd "$DEST_SCRIPT" \
  '.statusLine = {"type": "command", "command": $cmd}' \
  "$SETTINGS" > "$TMP" && mv "$TMP" "$SETTINGS"

echo "Installed: $DEST_SCRIPT"
echo "Wired into: $SETTINGS"
echo "Open (or reload) Claude Code to see it."
