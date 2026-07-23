#!/bin/bash
input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
project=$(basename "${cwd:-$PWD}")
message=$(printf '%s' "$input" | jq -r '.message // "Claude needs your input"' 2>/dev/null)
seq=$'\033]0;'"⏸ ${project} — needs input"$'\007'
jq -n --arg seq "$seq" '{terminalSequence: $seq}'

target="${cwd:-$PWD}"
notifier=$(command -v terminal-notifier || echo /opt/homebrew/bin/terminal-notifier)
ttl="${CLAUDE_NOTIFY_TTL:-60}"
group="claude-${project}"
if [ -x "$notifier" ]; then
  esc_target=$(printf '%s' "$target" | sed "s/'/'\\\\''/g")
  "$notifier" \
    -title "Claude Code — ${project}" \
    -message "$message" \
    -execute "/usr/local/bin/cursor '${esc_target}'" \
    -group "$group" \
    -sound default \
    >/dev/null 2>&1 &
  ( sleep "$ttl"; "$notifier" -remove "$group" >/dev/null 2>&1 ) >/dev/null 2>&1 &
else
  esc_message=$(printf '%s' "$message" | sed 's/\\/\\\\/g; s/"/\\"/g')
  esc_project=$(printf '%s' "$project" | sed 's/\\/\\\\/g; s/"/\\"/g')
  osascript <<EOF >/dev/null 2>&1
display notification "${esc_message}" with title "Claude Code — ${esc_project}"
EOF
fi
