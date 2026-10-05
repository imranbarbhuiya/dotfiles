# Herdr

Optional terminal agent management for Ghostty, Claude Code, Codex, and Cursor
Agent. This configuration uses Zsh login-shell defaults on macOS, follows the
current pane's directory, uses the terminal's color palette, and puts agents
needing attention first in the sidebar.

## Setup

Install Herdr separately using its [installation guide](https://herdr.dev/docs/install/).
From the repository root, link the configuration:

```sh
mkdir -p "$HOME/.config/herdr"
ln -sf "$PWD/herdr/config.toml" "$HOME/.config/herdr/config.toml"
herdr config check
```

Set up the executable launchers from [Claude/README.md](../Claude/README.md), then
install the native session-identity integrations into each Claude profile:

```sh
CLAUDE_CONFIG_DIR="$HOME/.claude-personal" herdr integration install claude
CLAUDE_CONFIG_DIR="$HOME/.claude-work" herdr integration install claude
herdr integration install codex
herdr integration install cursor
herdr integration status
```

Codex and Cursor integration commands are optional; use them only for installed
agents. Restart Claude sessions after installing their hooks.

Run `herdr` inside Ghostty, then start `clpersonal` or `clwork` in its panes.
Both launchers execute Claude directly, preserving native process detection.

## Shortcuts

Press Ctrl+semicolon, release it, then press the next key:

| Key | Action |
| --- | --- |
| `q` | Detach while keeping the server and agents running |
| `Alt+1` through `Alt+9` | Focus an agent |
| `1` through `9` | Switch Herdr tabs |
| `Shift+1` through `Shift+9` | Switch workspaces |
| `\` | Split vertically |
| `Enter` | Split horizontally |
| `m` | Zoom the current pane |
| `Shift+r` | Enter resize mode |
| `?` | Show active keybindings |

If the terminal consumes Ctrl+semicolon, choose another prefix in `config.toml`.
Reload changes with `herdr server reload-config`.

## Persistence and profile selection

Normal detach leaves the server and original Claude processes running. Run
`herdr` again to reconnect. Detach instead of stopping the server when you want
to keep working sessions alive.

Automatic agent resume after a full server restart is disabled deliberately:
Herdr's standard Claude restore command is `claude --resume <id>`, which does not
recreate the profile environment supplied by `clpersonal` or `clwork`. A restarted
server restores the layout with shells; resume each conversation explicitly with
its original profile:

```sh
clpersonal --resume
clwork --resume
```

Add a conversation ID after `--resume` to select it directly. The setting applies
to all agents, including Codex and Cursor. Do not enable
`resume_agents_on_restore` for mixed Claude profiles until a profile-aware custom
resume integration is installed and tested. Herdr 0.9.2+ supports reported custom
resume commands, but this repository does not install that integration yet.

## Optional native Ghostty tabs

Herdr-managed agents can be displayed individually in native Ghostty tabs,
without the full Herdr workspace interface. Find each agent's name or pane ID:

```sh
herdr agent list
```

In a separate Ghostty tab, attach to the chosen target:

```sh
herdr agent attach <agent-name-or-pane-id>
```

Repeat in other Ghostty tabs for other agents. Direct attach on macOS/Linux uses
Ctrl+B then `q` to detach; this shortcut is separate from the full UI prefix.
Agents remain owned by Herdr. Independently launched ordinary Ghostty sessions
are not imported by this setup.

## Read or steer an agent

A local assistant with command access can use:

```sh
herdr agent list
herdr agent get <target>
herdr agent read <target> --lines 100
herdr agent prompt <target> "Run the tests and explain any failures."
```

Check the target and its status before sending input, then verify the response.

## References

- [Configuration](https://herdr.dev/docs/configuration/)
- [Integrations](https://herdr.dev/docs/integrations/)
- [Session restore](https://herdr.dev/docs/session-state/)
- [Custom resume commands](https://herdr.dev/docs/add-herdr-support/)
- [Direct terminal attach](https://herdr.dev/docs/persistence-remote/)
