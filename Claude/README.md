# Claude Code config

Global config for [Claude Code](https://docs.claude.com/en/docs/claude-code), shared across profiles.

## Contents

- `CLAUDE.md` — global instructions
- `settings.json` — model, theme, plugins, and hook wiring
- `hooks/` — terminal tab-title + notification scripts

## Hooks

The hooks keep the terminal tab title in sync with session state and send a
macOS notification when Claude needs input (e.g. a permission prompt):

| Event                          | Script                  | Effect                          |
| ------------------------------ | ----------------------- | ------------------------------- |
| `SessionStart`/`UserPromptSubmit` | `tab-title-working.sh` | `⏳ <project> — working`         |
| `Stop`                         | `tab-title-done.sh`     | `✅ <project> — done`            |
| `Notification`                 | `tab-title-notify.sh`   | `⏸ <project> — needs input` + banner |

### Clickable notification → Cursor

`tab-title-notify.sh` uses [`terminal-notifier`](https://github.com/julienXX/terminal-notifier)
so the permission banner is **clickable**: clicking it runs `cursor <cwd>`, which
focuses the existing Cursor window for that repo (or reopens it there). If
`terminal-notifier` isn't installed it falls back to a plain, non-clickable
`osascript` banner.

Dependency:

```bash
brew install terminal-notifier
```

First run may require allowing notifications for `terminal-notifier` in
System Settings → Notifications (style: Alerts or Banners for click-to-open).

## Install

Symlink into each Claude profile (`~/.claude`, `~/.claude-tec`, `~/.claude-sofi`, …):

```bash
ln -sf "$PWD/CLAUDE.md"  ~/.claude/CLAUDE.md
ln -sf "$PWD/settings.json" ~/.claude/settings.json   # or merge by hand
ln -sf "$PWD/hooks"      ~/.claude/hooks
```

`settings.json` references hooks via `$HOME/.claude/hooks/...`, so pointing each
profile's `hooks` symlink at the same directory keeps all profiles in sync.
