---
name: git-local-workflow
description: Local git workflow preferences for status/diff inspection, stash/autostash, rebase, pull, revert/restore semantics, worktrees, sparse checkout, commits, repository-relative commands, and permission-friendly git/gh invocation.
---

# Git Local Workflow

- "Revert" means restore from master/main, not git revert or delete
- Worktrees: create sparse siblings named `../{repo}-{task}`; add paths as needed; never full-checkout worktrees.
- Use `git -C` only outside cwd.
- When equivalent, prefer subcommand-first forms. Avoid approval-triggering forms for local/read-only operations.
