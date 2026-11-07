# Claude Code config

Public-safe, generic Claude Code configuration. Authentication, history,
sessions, caches, MCP configuration, and device-specific state are
intentionally excluded.

## Contents

- `CLAUDE.md` — global instructions
- `settings.json` — shared defaults: Concise output, extended-context Opus, fullscreen TUI, local Figma/context-bar plugins, Remote Control off at startup, and no claude.ai skill/plugin sync or connectors
- `bin/skills-sync` — link shared skills into every local Claude profile
- `bin/skills-doctor` — inspect missing skills, conflicts, invalid skills, and stale links without changing files


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

## Concise output

The shared settings select Claude Code's built-in Concise output style with
`"outputStyle": "Concise"`. Use Claude Code v2.1.237 or later. For existing
profiles, merge this field into each profile's `settings.json`; keep its other
settings and authentication state. New profiles can start from the shared
settings above. Project settings can override the user-level output style.

## Shared skills

Keep skill contents in `~/.agents/skills`. Install them directly with the
upstream CLI; no `skills` shell function or alias is needed:

```sh
npx skills add <owner/repo> -g -a codex
```

From the repository root, install the sync and doctor commands:

```sh
mkdir -p "$HOME/.local/bin"
ln -sf "$PWD/Claude/bin/skills-sync" "$HOME/.local/bin/skills-sync"
ln -sf "$PWD/Claude/bin/skills-doctor" "$HOME/.local/bin/skills-doctor"
```

Both commands require Python 3 and discover `~/.claude` plus existing
`~/.claude-*` directories automatically; no account names are configured.

```sh
skills-sync
skills-doctor
```

Run sync after adding, updating, or removing skills, or creating a profile. It
links directories containing `SKILL.md`, preserves local overrides and unrelated
symlinks, and removes stale links pointing to the shared skills directory.
Profile-only skills remain local; move them into `~/.agents/skills` to share them.
Codex uses that shared directory directly.

Doctor does not change files. It exits with status 1 when it finds missing,
invalid, conflicting, or stale entries; otherwise it exits with status 0. Sync
also returns status 1 for unresolved conflicts or invalid source entries.
