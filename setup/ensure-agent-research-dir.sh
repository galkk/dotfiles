#!/usr/bin/env bash

set -euo pipefail

input="$(cat || true)"
cwd=""

if command -v jq >/dev/null && [ -n "$input" ]; then
    cwd="$(printf '%s' "$input" | jq -r '.cwd // .workspace_root // empty' 2>/dev/null || true)"
fi

[ -n "$cwd" ] || cwd="${PWD}"

project_name="$(basename "$cwd")"
[ -n "$project_name" ] || project_name="default"

mkdir -p "$HOME/research/$project_name"
