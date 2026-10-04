# limit

A Claude Code status line gauge that starts at **100%** and drains as your
session consumes the model's context-window token limit.

```
[Sonnet 5] ██████████████████░░ 92% left (15,500/200,000 tokens)
[Sonnet 5] ████████░░░░░░░░░░░░ 40% left (120,000/200,000 tokens)
[Sonnet 5] █░░░░░░░░░░░░░░░░░░░ 5% left (190,000/200,000 tokens)
```

- Green above 50% remaining, yellow at 50–21%, red at 20% or below.
- Reads `context_window.used_percentage` / `context_window_size` /
  `total_input_tokens` from the JSON Claude Code feeds the status line on
  every update (new assistant message, `/compact`, etc.) — no polling, no
  extra API calls.

## Why this lives in a `plugin/` folder but isn't auto-installed

Claude Code plugins cannot register a status line directly — `statusLine`
is strictly a setting in `settings.json`. This plugin just ships the
script; you point your settings at it once.

## Setup

1. Make sure the script is executable (already done if you cloned this repo):

   ```bash
   chmod +x plugin/limit/scripts/limit-bar.sh
   ```

2. Add a `statusLine` entry to `~/.claude/settings.json` (user-wide) or
   `.claude/settings.json` (this project only), pointing at the script's
   absolute path:

   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "/home/dat/Documents/ai/plugin/limit/scripts/limit-bar.sh"
     }
   }
   ```

3. Save — Claude Code reloads settings and runs the script immediately.

## Uninstall

Remove the `statusLine` field from your settings.json, or run `/statusline
clear` inside Claude Code.
