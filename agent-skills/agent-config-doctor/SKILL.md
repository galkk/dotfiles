---
name: agent-config-doctor
description: Use to audit local Claude, Codex, AGENTS.md, CLAUDE.md, skills, hooks, rules, memories, symlinks, and custom agent files for drift, conflicts, stale config, or unsafe automation.
---

# Agent Config Doctor

Use this when checking whether the local agent setup is coherent.

## Quick Audit

From the dotfiles repo:

```bash
python3 agent-skills/agent-config-doctor/scripts/audit-agent-config.py
```

For a specific root:

```bash
python3 agent-skills/agent-config-doctor/scripts/audit-agent-config.py \
  --dotfiles /home/andy/projects/dotfiles
```

## What To Check

- Global instruction files are present and symlinked.
- Skills have valid metadata and no duplicate names.
- Custom agents exist in both Claude and Codex when intended.
- Hook commands point at existing scripts.
- Codex memories are enabled with external-context exclusion.
- Rules do not grant broad destructive privileges.
- Claude and Codex config diverge only where intentional.

Report findings by severity and keep unrelated suggestions separate.
