---
name: command-execution-hygiene
description: Command execution and shell hygiene preferences for noisy commands, durable logs, repeated queries, targeted reads, zsh glob behavior, preferred CLI tools, command formatting, and parallel command caps. Use before running shell commands, test suites, builds, package installs, log queries, broad searches, or repeated command sequences.
---

# Command Execution Hygiene

- For noisy commands such as Docker builds, package installs, test suites, and dependency downloads: cap returned output aggressively. Report success/failure and include only the final error region on failure. Do not stream full successful logs.
- When a command sequence, parser, query, or exploration is likely to be repeated, save it as a reusable script or documented command and reuse it instead of regenerating ad hoc shell each time.
- Prefer durable artifacts over repeated tool calls: use tools in modes that write logs, traces, reports, or machine-readable output to their normal locations, and inspect those artifacts on follow-up passes instead of rerunning the same tools.
- Invoke tools with enough verbosity, flags, and output paths to make later debugging possible without rerunning. Capture the exact command/query, relevant flags, working directory, and output/log location in notes or the final result.
- Before rerunning an expensive/noisy command such as Bazel, Docker builds, package installs, broad test suites, or log queries, first check the tool’s existing output locations and any recent saved research notes to see whether they already answer the question.
- If rerunning is necessary because inputs changed, logs are missing, output is stale, or verification requires fresh results, state that reason briefly and ensure the new run leaves reusable logs or output for future inspection.
- Prefer targeted reads: use `rg -n` first, then read narrow line ranges. Avoid full-file dumps unless structure across the whole file matters.
- Zsh doesn't expand `*` in paths the same as bash — use `find` or explicit paths for glob patterns in shell commands
- Prefer `rg` (ripgrep) over `grep`/`find`, `sd` over `sed`, `yq` for YAML, `jq` for JSON in bash commands — they're installed and ergonomic
- For complex bash commands: use `\` line continuations for readability, prefer long flags (`--count` not `-c`) unless the short form is universally known
- xargs/parallel: cap at 8 jobs (`-P 8`); ask before exceeding.
