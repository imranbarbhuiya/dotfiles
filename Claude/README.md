# Claude Code config

Public-safe, generic Claude Code configuration. Authentication, history,
sessions, caches, MCP configuration, and device-specific state are
intentionally excluded.

## Contents

- `CLAUDE.md` — symlink to the exact local instructions in `../.agents/AGENTS.md`
- `settings.json` — shared defaults: Concise output, extended-context Opus, fullscreen TUI, local Figma/context-bar plugins, Remote Control off at startup, and no claude.ai skill/plugin sync or connectors
- `bin/skills-sync` — link shared skills into every local Claude profile
- `bin/skills-doctor` — inspect missing skills, conflicts, invalid skills, and stale links without changing files
- `hooks/guard-bash` — PreToolUse hook that blocks `--no-verify` on git commit/push/merge/rebase, and `git worktree remove` on a worktree with uncommitted work (untracked symlinks such as a linked `node_modules` are ignored)


## Personal and work profiles

`bin/clpersonal` and `bin/clwork` are executable launchers for separate Claude
Code config directories: `~/.claude-personal` and `~/.claude-work`. Both forward
all arguments to `claude`, including `--resume`, and replace the launcher process
with Claude. No shell aliases are required.

From the repository root, copy the shared defaults and link the launchers:

```sh
mkdir -p "$HOME/.local/bin" "$HOME/.agents" "$HOME/.claude" "$HOME/.claude-personal" "$HOME/.claude-work"
cp -n .agents/AGENTS.md "$HOME/.agents/AGENTS.md"
ln -sfn "$HOME/.agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
cp -n Claude/settings.json "$HOME/.claude-personal/"
cp -n Claude/settings.json "$HOME/.claude-work/"
ln -sfn "$HOME/.claude/CLAUDE.md" "$HOME/.claude-personal/CLAUDE.md"
ln -sfn "$HOME/.claude/CLAUDE.md" "$HOME/.claude-work/CLAUDE.md"
ln -sf "$PWD/Claude/bin/clpersonal" "$HOME/.local/bin/clpersonal"
ln -sf "$PWD/Claude/bin/clwork" "$HOME/.local/bin/clwork"
```

The included Zsh configuration already adds `~/.local/bin` to `PATH`. Open a new
terminal tab after installing it. The copy commands keep existing profile files.
The instruction links mirror the local chain: `~/.agents/AGENTS.md` → `~/.claude/CLAUDE.md` → each profile's
`CLAUDE.md`. The repository uses a relative link so it works in any checkout.

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

## Bash guard hook

`settings.json` registers `~/.claude/hooks/guard-bash` for every Bash call. Each
profile's `hooks` directory is a symlink to `~/.claude/hooks`, so one link covers
all profiles. Requires Python 3.

```sh
mkdir -p "$HOME/.claude/hooks"
ln -sf "$PWD/Claude/hooks/guard-bash" "$HOME/.claude/hooks/guard-bash"
ln -sfn "$HOME/.claude/hooks" "$HOME/.claude-personal/hooks"
ln -sfn "$HOME/.claude/hooks" "$HOME/.claude-work/hooks"
```

For existing profiles, merge the `hooks.PreToolUse` entry from `settings.json`
into each profile's settings.

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

## Local settings excluded from this snapshot

The shared defaults omit the app-managed `CLAUDE_CODE_ENTRYPOINT` environment
variable, private project-specific auto-mode permissions and environment descriptions. These stay in the local profile settings; exporting
them verbatim would publish account or internal project details.

Other preferences used locally can be merged individually without recording
which account uses them:

```json
{
  "theme": "dark",
  "model": "opus",
  "autoCompactEnabled": true,
  "switchModelsOnFlag": false,
  "enabledPlugins": {
    "rust-analyzer-lsp@claude-plugins-official": true,
    "swift-lsp@claude-plugins-official": true
  }
}
```

This is an optional settings fragment, not another default. Merge the plugin
entries into the existing `enabledPlugins` object rather than replacing it.
