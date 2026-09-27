# Claude Code config

Public-safe, generic Claude Code configuration. Authentication, history,
sessions, caches, MCP configuration, and device-specific state are
intentionally excluded.

## Contents

- `CLAUDE.md` — global instructions
- `settings.json` — common settings without account-specific extensions: Remote Control off at startup, fullscreen TUI, agent push notifications, and no claude.ai skill/plugin sync or connectors (only locally installed plugins and MCP servers load)
