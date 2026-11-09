# Claude Code config

Public-safe, generic Claude Code configuration. Authentication, history,
sessions, caches, MCP configuration, and device-specific state are
intentionally excluded.

## Contents

- `CLAUDE.md` — symlink to the exact local instructions in `../.agents/AGENTS.md`
- `settings.json` — shared defaults: Concise output, extended-context Opus, fullscreen TUI, local Figma/context-bar plugins, Remote Control off at startup, and no claude.ai skill/plugin sync or connectors
- `bin/skills-sync` — link shared skills into every local Claude profile
- `bin/skills-doctor` — inspect missing skills, conflicts, invalid skills, and stale links without changing files
- `bin/settings-sync` — merge the shared `settings.json` into every local profile's settings
- `bin/memory-sync` (also `hooks/memory-sync`) — share auto-memory between chosen profiles and keep T3 scratch-folder memory
- `hooks/guard-bash` — PreToolUse hook that blocks `--no-verify` on git commit/push/merge/rebase unless prefixed with `ALLOW_NO_VERIFY=1`, and `git worktree remove` on a worktree with uncommitted work (untracked symlinks such as a linked `node_modules` are ignored)


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

`settings.json` registers `~/.claude/hooks/guard-bash` for every Bash call.
`~/.claude/hooks` is a symlink to this repo's `Claude/hooks`, and each profile's
`hooks` is a symlink to `~/.claude/hooks`, so hooks added here reach every
profile. Requires Python 3.

```sh
ln -sfn "$PWD/Claude/hooks" "$HOME/.claude/hooks"
ln -sfn "$HOME/.claude/hooks" "$HOME/.claude-personal/hooks"
ln -sfn "$HOME/.claude/hooks" "$HOME/.claude-work/hooks"
```

For existing profiles, run `settings-sync` (below) to add the hook entries.

## Shared settings

Install the command, then run it after editing `settings.json` or creating a profile:

```sh
ln -sf "$PWD/Claude/bin/settings-sync" "$HOME/.local/bin/settings-sync"
settings-sync --check   # report drift, exit 1 if any
settings-sync           # write
```

It merges the shared file into `~/.claude/settings.json` and every existing
`~/.claude-*/settings.json`. Shared keys win, except `model` and `theme`, which only
fill a profile that doesn't set them. Nested objects merge key by key, so a profile's
own plugins, `env` and auto-mode rules stay, and shared hook groups are added without
removing a profile's own hooks.

## Shared memory

Claude Code keeps auto-memory per profile under `projects/<project-key>/memory`, so
two profiles working on the same repo each remember different things. `memory-sync`
moves the memory of the profiles you list into one folder per project,
`~/.local/share/claude-memory/<project-key>`, and links each profile's memory folder to it.

T3 scratch folders get a new project key every thread, so memory saved there is never
read again. Their memory folders are linked to one shared scratch memory instead:
`~/.local/share/claude-memory/t3-scratch` for listed profiles, `<profile>/scratch-memory`
for the rest.

List the profiles to share, one config directory name per line (kept out of this repo):

```sh
mkdir -p ~/.config/claude-memory-sync
printf '.claude-personal\n.claude-work\n' > ~/.config/claude-memory-sync/profiles
ln -sf "$PWD/Claude/bin/memory-sync" "$HOME/.local/bin/memory-sync"
memory-sync --check   # show what would move
memory-sync
```

Files that differ between profiles are reported as conflicts and left in place;
`MEMORY.md` indexes are merged line by line. `settings.json` also runs
`memory-sync --hook` at SessionStart, which syncs again and links a new folder's memory.
A newly linked folder's index isn't loaded in that first session, so the hook prints it
into the session context.

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
    "swift-lsp@claude-plugins-official": true
  }
}
```

This is an optional settings fragment, not another default. Merge the plugin
entries into the existing `enabledPlugins` object rather than replacing it.
