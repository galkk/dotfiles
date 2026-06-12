---
name: controlled-memory
description: Use when enabling, reviewing, pruning, or reasoning about Codex memories so stable preferences are remembered without storing secrets, external-source artifacts, or rules that belong in AGENTS.md.
---

# Controlled Memory

Use memory for durable personal recall, not mandatory policy.

## What Belongs In Memory

- Stable user preferences.
- Recurring local workflows.
- Repeated repo/tool pitfalls.
- Durable project context that is not secret.

## What Does Not Belong

- Secrets, tokens, credentials, customer data.
- Temporary branch state.
- External-source details copied from MCP, web, email, or docs.
- Required team rules; put those in `AGENTS.md`, `CLAUDE.md`, or repo docs.

## Codex Policy

Recommended local config:

```toml
features.memories = true

[memories]
generate_memories = true
use_memories = true
disable_on_external_context = true
min_rate_limit_remaining_percent = 20
```

Use `/memories` in Codex to inspect or disable memory behavior per thread.
Review `~/.codex/memories/` before sharing config or generated artifacts.

## Promotion

When memory becomes a rule future agents must always obey, move it into an
instruction file or skill and remove/ignore the memory copy.
