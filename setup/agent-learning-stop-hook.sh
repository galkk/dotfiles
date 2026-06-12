#!/usr/bin/env bash

set -euo pipefail

input="$(cat || true)"
cwd=""
session_id=""
transcript_path=""

if command -v jq >/dev/null && [ -n "$input" ]; then
    cwd="$(printf '%s' "$input" | jq -r '.cwd // .workspace_root // empty' 2>/dev/null || true)"
    session_id="$(printf '%s' "$input" | jq -r '.session_id // .sessionId // empty' 2>/dev/null || true)"
    transcript_path="$(printf '%s' "$input" | jq -r '.transcript_path // .transcriptPath // empty' 2>/dev/null || true)"
fi

[ -n "$cwd" ] || cwd="${PWD}"
project_name="$(basename "$cwd")"
[ -n "$project_name" ] || project_name="default"

inbox="$HOME/research/$project_name/learning-inbox"
mkdir -p "$inbox"

marker="$inbox/auto-capture-enabled"
[ -f "$marker" ] || exit 0

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
if command -v jq >/dev/null; then
    jq -cn \
        --arg timestamp "$timestamp" \
        --arg cwd "$cwd" \
        --arg session_id "$session_id" \
        --arg transcript_path "$transcript_path" \
        '{timestamp:$timestamp,cwd:$cwd,session_id:$session_id,transcript_path:$transcript_path}' \
        >>"$inbox/stop-events.jsonl"
else
    printf '{"timestamp":"%s","cwd":"%s","session_id":"%s","transcript_path":"%s"}\n' \
        "$timestamp" "$cwd" "$session_id" "$transcript_path" >>"$inbox/stop-events.jsonl"
fi
