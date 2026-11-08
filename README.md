# dotfiles

Personal shell, editor, terminal, Git, and development-tool configuration.

## Current macOS setup

- Zsh + Oh My Zsh
- Starship prompt
- Ghostty / Cursor integrated terminal
- JetBrainsMono Nerd Font
- fnm for Node.js
- Bun
- Python 3 for shared skill commands
- Android Studio JBR + Android SDK
- OrbStack for Docker (memory capped at 8 GB)
- Homebrew `kubectl`
- 1Password CLI (`op`) for secrets
- Claude Code

## Files

| Path | Purpose |
| --- | --- |
| `zsh/` | Zsh startup files, PATH, fnm, Bun, Starship, and OrbStack |
| `bash/` | Bash/profile startup files |
| `git/global-ignore` | Global Git ignore patterns |
| `gh/config.yml` | GitHub CLI preferences without authentication |
| `Codex/` | Portable Codex settings |
| `.agents/AGENTS.md` | Exact local shared agent instructions |
| `starship.toml` | Starship prompt and Git status styling |
| `.gitconfig` | Global Git behavior, signing, aliases, rebase and diff defaults |
| `.gitignore` | Local and sensitive state exclusions |
| `vscode-settings.json` | Cursor / VS Code editor and terminal settings |
| `vscode-keybindings.json` | Cursor / VS Code keybindings |
| `docker/local-dev/` | Shared local Postgres, Redis, MongoDB, RabbitMQ, and MinIO for every project |
| `Claude/` | Shared Claude Code defaults, global instructions, launchers, and skill sync/doctor commands |
| `PowerShell/` | Windows PowerShell setup |
| `Windows-Terminal/` | Windows Terminal configuration |
| `parbez-renovate.json` | Shared Renovate preset |

## macOS setup

Install the main tools:

```sh
brew install starship fnm bun python@3.14 kubernetes-cli 1password-cli
brew install --cask font-jetbrains-mono-nerd-font orbstack
```

Install Oh My Zsh and `zsh-autosuggestions`, then link or copy the configs to their expected locations:

```sh
ln -sf "$PWD/zsh/.zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.config"
ln -sf "$PWD/starship.toml" "$HOME/.config/starship.toml"
ln -sf "$PWD/.gitconfig" "$HOME/.gitconfig"
```

Restart the shell after changing Zsh configuration:

```sh
exec zsh
```

Starship reads `~/.config/starship.toml` when rendering the prompt, so Starship-only changes normally appear on the next prompt without restarting the shell.

## Docker and shared dev services

Docker runs on OrbStack, which returns memory to macOS when containers go idle. Cap it so it
stays clear of the Android emulator:

```sh
orb config set memory_mib 8192 && orb stop
```

`docker/local-dev/` is one shared instance of each backing service, so projects and worktrees
create a database, vhost, or bucket inside it instead of starting their own containers. Link it
to the path agents expect and start it:

```sh
mkdir -p ~/docker
ln -s "$PWD/docker/local-dev" ~/docker/local-dev
cd ~/docker/local-dev && docker compose up -d
```

Ports, credentials, and version pins are in `docker/local-dev/README.md`. The credentials are
local-only defaults and every port listens on `127.0.0.1`.

## Claude Code

The `Claude/` directory contains public-safe generic configuration only. Authentication, sessions, history, MCP state, and device-specific state are intentionally excluded.

The `clpersonal` and `clwork` executables select separate config directories and forward all Claude arguments without shell aliases. The shared settings use Concise output. `skills-sync` links `~/.agents/skills` into all local Claude profiles, and `skills-doctor` checks their links without changes. For setup details, see `Claude/README.md`.

## Notes

Secrets, authentication state, local agent state, sessions, databases, logs, sockets, caches, and `.env` files are intentionally excluded from the repository.

## Additional development configs

The editor settings mirror Cursor's user settings and keybindings. Private SSH
host mappings are omitted from the editor snapshot. Git configuration includes
SSH signing through 1Password and GitHub CLI credential-helper commands; it
contains a public signing key, not private key material.

For the other configs, copy or link the matching paths after reviewing them:

| Repository path | Local destination |
| --- | --- |
| `zsh/.zprofile`, `zsh/.zshenv` | `~/.zprofile`, `~/.zshenv` |
| `bash/.bashrc`, `bash/.bash_profile` | Corresponding files in `~` |
| `git/global-ignore` | `~/.gitignore` |
| `gh/config.yml` | `~/.config/gh/config.yml` |
| `vscode-settings.json`, `vscode-keybindings.json` | Cursor or VS Code user settings/keybindings |
| `Codex/config.toml` | Merge into `~/.codex/config.toml` |
| `.agents/AGENTS.md` | `~/.agents/AGENTS.md` |
| `Claude/CLAUDE.md` | Symlink to the shared instructions; see `Claude/README.md` |

This repository is a reviewed snapshot, not an automatic uploader. Review local
changes before committing them. Package-manager authentication files, SSH host
configs, private project permissions, app-managed paths, and conversation/runtime
state remain local. OpenCode custom-provider settings and service credentials,
package-manager auth-only files, and generated shell integrations are excluded.
Ghostty currently uses its defaults; its generated comment-only
template is not copied. The existing Windows configs are retained.
