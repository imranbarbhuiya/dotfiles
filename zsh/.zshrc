export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

DISABLE_AUTO_TITLE="true"

plugins=(
    git
    zsh-autosuggestions
)

source "$ZSH/oh-my-zsh.sh"

unset LESS

export EDITOR="cursor"
export REACT_EDITOR="cursor"

export BUN_INSTALL="$HOME/.bun"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"

typeset -U path PATH

path=(
    "$HOME/.cargo/bin"
    "$BUN_INSTALL/bin"
    "$HOME/.opencode/bin"
    "$HOME/.local/bin"
    "$JAVA_HOME/bin"
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/platform-tools"
    $path
)

export PATH

[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

eval "$(fnm env --use-on-cd --corepack-enabled --shell zsh)"

alias cltec="CLAUDE_CONFIG_DIR=$HOME/.claude-tec claude"
alias clsofi="CLAUDE_CONFIG_DIR=$HOME/.claude-sofi claude"
alias clzethy="CLAUDE_CONFIG_DIR=$HOME/.claude-zethy claude"

eval "$(starship init zsh)"
