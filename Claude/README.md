# Claude Code config

Public-safe, generic Claude Code configuration. Authentication, history,
sessions, caches, MCP configuration, and device-specific state are
intentionally excluded.

## Contents

- `CLAUDE.md` — global instructions
- `settings.json` — common settings without account-specific extensions: Remote Control off at startup, fullscreen TUI, and no claude.ai skill/plugin sync or connectors (only locally installed plugins and MCP servers load)


## Personal and work profiles

`bin/clpersonal` and `bin/clwork` are executable launchers for separate Claude
Code config directories: `~/.claude-personal` and `~/.claude-work`. Both forward
all arguments to `claude`, including `--resume`, and replace the launcher process
with Claude. No shell aliases are required.

From the repository root, copy the shared defaults and link the launchers:

```sh
mkdir -p "$HOME/.local/bin" "$HOME/.claude-personal" "$HOME/.claude-work"
cp -n Claude/settings.json Claude/CLAUDE.md "$HOME/.claude-personal/"
cp -n Claude/settings.json Claude/CLAUDE.md "$HOME/.claude-work/"
ln -sf "$PWD/Claude/bin/clpersonal" "$HOME/.local/bin/clpersonal"
ln -sf "$PWD/Claude/bin/clwork" "$HOME/.local/bin/clwork"
```

The included Zsh configuration already adds `~/.local/bin` to `PATH`. Open a new
terminal tab after installing it. The copy commands keep existing profile files.

Start each profile and sign in separately when prompted:

```sh
clpersonal
clwork
```

Resume a conversation using the profile that created it:

```sh
clpersonal --resume <session-id>
clwork --resume <session-id>
```

Keep each profile's authentication and conversation state outside this repository.
