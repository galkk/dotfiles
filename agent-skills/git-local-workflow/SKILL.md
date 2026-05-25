---
name: git-local-workflow
description: Local git workflow preferences for revert semantics, worktrees, sparse checkout, repository-relative commands, command ordering, and permission-friendly git/gh invocation. Use when reverting, creating worktrees, inspecting diffs, committing, or running local git and gh commands.
---

# Git Local Workflow

- "Revert" means restore from master/main, not git revert or delete
- Worktrees: create sparse siblings named `../{repo}-{task}`; add paths as needed; never full-checkout worktrees.
- Use `git -C` only outside cwd.
- When equivalent, prefer subcommand-first forms. Avoid approval-triggering forms for local/read-only operations.
