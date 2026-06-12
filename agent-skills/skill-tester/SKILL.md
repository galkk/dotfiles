---
name: skill-tester
description: Use when creating, editing, reviewing, or debugging agent skills to validate metadata, trigger descriptions, duplicate names, supporting files, and pressure-test whether agents will actually discover and follow the skill.
---

# Skill Tester

Use this before considering a skill ready.

## Static Checks

Run the validator from the dotfiles repo:

```bash
python3 agent-skills/skill-tester/scripts/validate-skills.py agent-skills
```

For live installs:

```bash
python3 ~/.codex/skills/skill-tester/scripts/validate-skills.py \
  ~/.codex/skills ~/.claude/skills
```

Fix errors before testing behavior.

## Behavioral Checks

1. Write 2-4 realistic prompts that should trigger the skill.
2. Write 1-2 nearby prompts that should not trigger it.
3. Test with minimal context. Do not leak the intended answer to the tester.
4. Check whether the agent:
   - notices the skill from its description,
   - loads only the relevant references,
   - follows required constraints under time pressure,
   - avoids using the skill for unrelated work.
5. Tighten the description first. Body text cannot help discovery if the skill
   never loads.

## Quality Bar

- `description` starts with the exact task class and trigger words.
- SKILL.md is concise; long details live in `references/`.
- Deterministic checks live in `scripts/`.
- No README, changelog, or extra meta docs inside the skill.
- Every script has a clear command example in SKILL.md.
