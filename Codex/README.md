# Codex

`config.toml` records the current model, reasoning effort, service tier, feature
flags, and plugin preferences. `AGENTS.md` shares the global coding instructions
with the Claude configuration.

Merge these settings into `~/.codex/config.toml`; do not replace an existing file.
Local marketplace paths and plugin availability are managed by the installed
client. The snapshot omits authentication, trusted project paths, disabled skill
paths, local MCP processes, notification commands, and desktop/session state.
Keep those machine-specific sections local.

Use `~/.agents/skills` for shared skills. See [Claude/README.md](../Claude/README.md)
for the sync and doctor commands.

Configuration reference: https://learn.chatgpt.com/docs/config-file/config-reference
