# dotfiles

Personal shell, editor, terminal, Git, and development-tool configuration.

## Current macOS setup

- Zsh + Oh My Zsh
- Starship prompt
- Ghostty / Cursor integrated terminal
- JetBrainsMono Nerd Font
- fnm for Node.js
- Bun
- Rust/Cargo
- Android Studio JBR + Android SDK
- Claude Code
- Herdr

## Files

| Path | Purpose |
| --- | --- |
| `zsh/.zshrc` | Zsh, PATH, fnm, Bun, and Starship |
| `starship.toml` | Starship prompt and Git status styling |
| `.gitconfig` | Global Git behavior, signing, aliases, rebase and diff defaults |
| `.gitignore` | Local and sensitive state exclusions |
| `vscode-settings.json` | Cursor / VS Code editor and terminal settings |
| `vscode-keybindings.json` | Cursor / VS Code keybindings |
| `herdr/` | Herdr configuration and notes |
| `Claude/` | Generic Claude Code defaults and global instructions |
| `PowerShell/` | Windows PowerShell setup |
| `Windows-Terminal/` | Windows Terminal configuration |
| `parbez-renovate.json` | Shared Renovate preset |

## macOS setup

Install the main tools:

```sh
brew install starship fnm bun
brew install --cask font-jetbrains-mono-nerd-font
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

## Claude Code

The `Claude/` directory contains public-safe generic configuration only. Authentication, sessions, history, MCP state, and device-specific state are intentionally excluded.

For setup details, see `Claude/README.md`.

## Herdr

The `herdr/` directory contains the terminal workspace configuration and setup notes for supported agent integrations.

For setup details, see `herdr/README.md`.

## Notes

Secrets, authentication state, local agent state, sessions, databases, logs, sockets, caches, and `.env` files are intentionally excluded from the repository.
