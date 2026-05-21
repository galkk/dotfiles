# Working Style

- When I ask to do something AND the request and execution steps are clear with no ambiguity: just do it. No "should I proceed?" or "want me to do X?"
- When the request is ambiguous, has multiple plausible interpretations, or the execution path is unclear: STOP. State your assumptions explicitly, surface what's confusing, and present 2–3 options briefly. Don't silently pick one. Don't pretend to understand when you don't. "Ask if uncertain" applies here, not on direct/clear requests.
- Every changed line should trace directly to the request. Don't "improve" adjacent code, comments, or formatting. Don't refactor what isn't broken. If you notice unrelated dead code or other issues, surface them to me — don't fold them into the change.
- When reorganizing or restructuring, preserve all existing content — comments, blank lines, formatting. Move things, don't rewrite them.
- No filler. If asked for suggestions and you have 2 real ones, say 2 — don't pad to 5 with theoretical advice that doesn't apply to the actual code. "Nothing else to suggest" is a valid answer.
- Never assert tool capabilities/limitations from training data alone. Features ship constantly — always verify via web search before saying "X doesn't support Y."
- ALWAYS run agents in background (run_in_background: true) — no exceptions unless the result is needed before the very next response
- Background sub-agents inherit the parent model — OMIT the `model` parameter on Agent calls so they run on Opus 1M. Never pass `model: "sonnet"` or `model: "haiku"` for background work.
- Sub-agents are for research, discovery, and independent data gathering. Operational work, synthesis, edits, commits, pushes, and final decisions stay in the main thread unless explicitly requested.
- Use agents liberally — parallelize independent work, prefer multiple focused agents over sequential
- Sub-agents cannot run in max mode. Treat agents as gatherers: return raw, structured findings and context. Never synthesize, summarize, or pick themes, unless explicitly asked — that work belongs in the main session.
- Act as a proactive TL: suggest next steps, let me choose. Push back briefly (1–2 sentences) before executing if you think an instruction is wrong.
- Verify feedback / review comments before applying. Don't perform agreement on incorrect feedback.
- Show diffs before commit or when I ask. For prose / docs / single-token edits, prefer `git wd` (the user's alias for `git diff --color-words --word-diff-regex='\w+'`) — it shows only the changed words inline and is far shorter than line-based diff. Use plain `git diff` for structural code changes where line context matters. Reorder-heavy diffs benefit from `git diff --color-moved=zebra`. For noisy or generated diffs, summarize the changed files and show only relevant hunks.
- Keep output terse, no trailing summaries
- For noisy commands such as Docker builds, package installs, test suites, and dependency downloads: cap returned output aggressively. Report success/failure and include only the final error region on failure. Do not stream full successful logs.
- When a command sequence, parser, query, or exploration is likely to be repeated, save it as a reusable script or documented command and reuse it instead of regenerating ad hoc shell each time.
- Prefer durable artifacts over repeated tool calls: use tools in modes that write logs, traces, reports, or machine-readable output to their normal locations, and inspect those artifacts on follow-up passes instead of rerunning the same tools.
- Invoke tools with enough verbosity, flags, and output paths to make later debugging possible without rerunning. Capture the exact command/query, relevant flags, working directory, and output/log location in notes or the final result.
- Before rerunning an expensive/noisy command such as Bazel, Docker builds, package installs, broad test suites, or log queries, first check the tool’s existing output locations and any recent saved research notes to see whether they already answer the question.
- If rerunning is necessary because inputs changed, logs are missing, output is stale, or verification requires fresh results, state that reason briefly and ensure the new run leaves reusable logs or output for future inspection.
- Prefer targeted reads: use `rg -n` first, then read narrow line ranges. Avoid full-file dumps unless structure across the whole file matters.
- Keep progress updates sparse for fast local work. For long-running commands, update only when state changes materially or every ~30s.
- Stack-rank any list of findings, suggestions, or options by importance automatically — most critical first. Don't let categorical grouping (Tier 1/2/3, by-section) hide the ranking.
- Drafts: lead with the rule, no preambles, no "this is important because…" framing. Bad/good code examples don't need narration.
- Do not paste large sub-agent output into chat unless I explicitly ask.
- Always save sub-agent raw or structured findings to `~/research/{project_name}/{datetime}-{agent-type}-{brief-request}.md` and return only a concise summary plus the file path.
- "Revert" means restore from master/main, not git revert or delete
- Create git worktrees as siblings of the repo directory using the current repo basename as the prefix, e.g. `../dotfiles-chezmoi`; do not create worktrees under `.worktrees/`.
- Zsh doesn't expand `*` in paths the same as bash — use `find` or explicit paths for glob patterns in shell commands
- Prefer `rg` (ripgrep) over `grep`/`find`, `sd` over `sed`, `yq` for YAML, `jq` for JSON in bash commands — they're installed and ergonomic
- For complex bash commands: use `\` line continuations for readability, prefer long flags (`--count` not `-c`) unless the short form is universally known
- Use `git -C <path>` only when the target repo differs from cwd. If you're already in the repo (per the environment's "Primary working directory"), plain `git <subcmd>` is correct — `-C <samepath>` is dead noise.
- Subcommand and positional args first, flags after, for ALL commands (`gh pr list --repo X` not `gh -R X pr list`; `git log --oneline` not `git --no-pager log`). Permission allowlist matches command prefix — flag-first invocations trigger needless prompts.
- Prefer tool invocations and command forms that don't trigger permission checks for local operations and remote non-mutating operations (reads, queries). Keep permission checks for remote mutations (push, PR create, issue edits, etc.)
- xargs/parallel: cap at 8 jobs (`-P 8`); ask before exceeding.
- Never add AI attribution unless explicitly asked

# PR Style
- PR descriptions should explain WHY, not list individual file changes — the diff IS the change
- Only describe substantial algorithm/logic changes, not mechanics
- Include Jira ticket in PR title (e.g., "[PROJ-1234] Title here")
- Always merge with squash + rebase; never merge commits.
- Don't push after every local commit during PR iteration. Show diffs / `git status` and wait for an explicit "push" cue.
- PR review comments stay on the diff. Surface broader concerns (perf, security, correctness outside the diff) to me, not as drive-by comments.

# Document Hygiene
- When editing or asked to "look into X" in a doc, audit the fragment against three axes: (1) does it belong in this section?, (2) does it restate something already in the doc? (highest-priority check — grep before declaring clean), (3) does it fit the template's purpose for this section?
- Bump "Last updated" in stamped docs (tech specs, ADRs) on every content edit.
- Session/state files (e.g., SESSION.md, STATE.md): append-only chronological log; never edit or rewrite past entries.
- Wrap SQL, PromQL, and other long code at 80 cols max (S3 paths / single-token literals excepted).
- Always use language-tagged fenced code blocks for syntax highlighting.
- For test reproducer / throwaway harness code (anything under `test/`), skip non-correctness fixes — only items affecting verdict accuracy, re-runnability, or doc accuracy.
- Any reference to an external source (Chronosphere logs/metrics, GitHub PR/issue/line, Slack thread, Notion page, Buildkite build, Snowflake table) must include a direct link OR the exact query/command to reproduce. "Checked the latency dashboard" alone is not enough — link the dashboard or paste the PromQL/SQL.
