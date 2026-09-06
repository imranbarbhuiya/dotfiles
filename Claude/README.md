# Claude Code config

Public-safe, generic Claude Code configuration. Authentication, history,
sessions, caches, MCP configuration, generated hooks, and device-specific state
are intentionally excluded.

## Contents

- `CLAUDE.md` — global instructions
- `settings.json` — common settings without account-specific extensions

## Herdr integration

Herdr owns terminal status and desktop notifications. Its generated hook is not
committed because the installer writes the current version automatically.

Install and verify the integration:

```sh
herdr integration install claude
herdr integration status
```

Do not replace a live `settings.json` blindly after installing Herdr; merge the
public settings so the generated `SessionStart` hook remains present.
