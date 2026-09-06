# Herdr

Install Herdr with Homebrew, link `config.toml` to
`~/.config/herdr/config.toml`, then install current native-resume integrations:

```sh
brew install herdr
mkdir -p "$HOME/.config/herdr"
ln -sf "$PWD/config.toml" "$HOME/.config/herdr/config.toml"

herdr integration install codex
herdr integration install cursor
herdr integration install claude
```

Run `herdr` inside Ghostty. Herdr manages internal workspaces, tabs, panes,
agent-state indicators, macOS notifications, and supported native session
restoration. Experimental Kitty graphics remain disabled.
