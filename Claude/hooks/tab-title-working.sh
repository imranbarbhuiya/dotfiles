#!/bin/bash
input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
project=$(basename "${cwd:-$PWD}")
seq=$'\033]0;'"⏳ ${project} — working"$'\007'
jq -n --arg seq "$seq" '{terminalSequence: $seq}'
