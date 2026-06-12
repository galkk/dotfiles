---
name: agent-learning-curator
description: Use after a difficult session, repeated correction, surprising repo discovery, or workflow failure to capture durable agent learnings into a review inbox and promote them into existing skills or instructions without creating prompt bloat.
---

# Agent Learning Curator

Use this when a session produced a reusable lesson that should improve future
agent behavior.

## Workflow

1. Decide whether the lesson is durable.
   - Durable: repo convention, recurring command, verified pitfall, workflow
     correction, config rule, tool quirk.
   - Ephemeral: one-off task detail, temporary branch state, stale log output,
     unresolved speculation.
2. Capture a short inbox note, not a new rule by default:

   ```bash
   python3 ~/.codex/skills/agent-learning-curator/scripts/capture-learning.py \
     --title "short-title" \
     --kind lesson \
     --skill target-skill-name
   ```

   Pipe or paste the note on stdin.
3. Prefer updating an existing skill, `AGENTS.md`, or `CLAUDE.md` over creating
   a new skill. Create a new skill only when the lesson defines a repeatable
   workflow with a clear trigger.
4. Before promotion, check nearby skills for overlap:

   ```bash
   rg -n "keyword|related phrase" ~/.codex/skills ~/.claude/skills
   ```

5. Promote only concise, verified guidance. Leave raw notes in
   `~/research/<project>/learning-inbox/`.

## Promotion Rules

- Do not store secrets, tokens, credentials, private URLs with embedded auth, or
  copied customer data.
- Add the rule where it will be discovered with the least context cost.
- If a skill already exists, edit that skill instead of adding a parallel skill.
- Keep the trigger phrase in the skill description when discovery matters.
- For corrections caused by agent failure, include the failure mode and the new
  required behavior.

## Hook

The optional Stop hook creates the learning inbox and records stop-event
metadata only when `~/research/<project>/learning-inbox/auto-capture-enabled`
exists. It does not summarize conversations automatically.
