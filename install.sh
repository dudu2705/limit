#!/bin/bash
# Installs the "limit" status-line plugin on THIS machine:
#   1. Copies scripts/limit-bar.sh into ~/.claude/plugins/limit/
#   2. Merges a "statusLine" entry into ~/.claude/settings.json
#      (keeps any other settings already in that file)
#
# Run this once on every new machine after copying/cloning this folder there:
#   bash install.sh

set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not installed." >&2
  echo "  Debian/Ubuntu: sudo apt install jq" >&2
  echo "  macOS:         brew install jq" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="$HOME/.claude/plugins/limit/scripts"
DEST_SCRIPT="$DEST_DIR/limit-bar.sh"
SETTINGS="$HOME/.claude/settings.json"

mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/scripts/limit-bar.sh" "$DEST_SCRIPT"
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
