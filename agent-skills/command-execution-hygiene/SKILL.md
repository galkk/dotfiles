---
name: command-execution-hygiene
description: Shell command and repository exploration hygiene. Use when running commands, reading/searching files, handling noisy tests/builds/package installs/Docker output, formatting bash, managing command logs, or using xargs/parallel.
---

# Command Execution Hygiene

- Prefer targeted reads: use `rg -n` first, then read narrow line ranges. Avoid full-file dumps unless structure across the whole file matters.
- Prefer `rg` for search, `sd` for replacements, `yq` for YAML, and `jq` for JSON.
- Zsh errors on unmatched `*` path globs by default; use `find` or explicit paths for glob patterns in shell commands.
- For noisy commands such as Docker builds, package installs, test suites, and dependency downloads: cap returned output aggressively. Report success/failure and include only the final error region on failure.
- For expensive or repeated commands, inspect existing outputs before rerunning. When rerunning, note why and capture command, cwd, key flags, and output location.
- For complex bash commands: use `\` line continuations, keep continued lines around 60 characters, and prefer long flags unless the short form is universally known.
- For `xargs` or `parallel`, cap at 8 jobs (`-P 8`) unless the user explicitly approves more.
