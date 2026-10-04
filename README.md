# limit

A Claude Code status line with two gauges that start at **100%** and drain
as you use Claude: the context window (per-session tokens) and your 5-hour
rate limit (Pro/Max plans).

```
[Sonnet 5] ██████████████████░░ 92%  |  limit ███████████████░░░░░ 77%
```

- Reads `context_window.used_percentage` and `rate_limits.five_hour.used_percentage`
  from the JSON Claude Code feeds the status line on every update (new
  assistant message, `/compact`, etc.) — no polling, no extra API calls.
- Shows `limit n/a` until your first API response of the session, or if
  your account doesn't report rate limits.

## Install

One line, on any machine — no `git clone` needed (just needs `jq`):

```bash
curl -fsSL https://raw.githubusercontent.com/dudu2705/limit/main/install.sh | bash
```

This downloads the script into `~/.claude/plugins/limit/` and adds a
`statusLine` entry to `~/.claude/settings.json`, keeping any other settings
you already have there. Reopen (or reload) Claude Code to see it.

### From a clone

```bash
git clone https://github.com/dudu2705/limit.git
bash limit/install.sh
```

## Why a shell script instead of an auto-installed plugin

Claude Code plugins cannot register a status line directly — `statusLine`
is strictly a setting in `settings.json`. `install.sh` does that wiring
for you so you don't have to edit JSON by hand.

## Uninstall

Remove the `statusLine` field from `~/.claude/settings.json`, or run
`/statusline clear` inside Claude Code.
