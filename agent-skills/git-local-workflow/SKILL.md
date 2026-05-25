---
name: git-local-workflow
description: Local git workflow preferences for revert semantics, worktrees, sparse checkout, repository-relative commands, command ordering, and permission-friendly git/gh invocation. Use when reverting, creating worktrees, inspecting diffs, committing, or running local git and gh commands.
---

# Git Local Workflow

- "Revert" means restore from master/main, not git revert or delete
- Create git worktrees as siblings of the repo directory using the current repo basename as the prefix, e.g. `../dotfiles-chezmoi`; do not create worktrees under `.worktrees/`.
- When creating git worktrees, always use `--sparse` and then `git sparse-checkout set` only the paths needed for the task. Add more paths with `git sparse-checkout add` as you discover dependencies. Never create full-checkout worktrees.
- Use `git -C <path>` only when the target repo differs from cwd. If you're already in the repo (per the environment's "Primary working directory"), plain `git <subcmd>` is correct — `-C <samepath>` is dead noise.
- When equivalent forms exist, put subcommand and positional args first, flags after (`gh pr list --repo X` not `gh -R X pr list`; `git log --oneline` not `git --no-pager log`). Permission allowlist matches command prefix — flag-first invocations trigger needless prompts.
- Prefer tool invocations and command forms that don't trigger permission checks for local operations and remote non-mutating operations (reads, queries). Keep permission checks for remote mutations (push, PR create, issue edits, etc.)
