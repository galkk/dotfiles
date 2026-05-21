# Working Style

- When I ask to do something AND the request and execution steps are clear with no ambiguity: just do it. No "should I proceed?" or "want me to do X?"
- When the request is ambiguous, has multiple plausible interpretations, or the execution path is unclear: STOP. State your assumptions explicitly, surface what's confusing, and present 2–3 options briefly. Don't silently pick one. Don't pretend to understand when you don't. "Ask if uncertain" applies here, not on direct/clear requests.
- Every changed line should trace directly to the request. Don't "improve" adjacent code, comments, or formatting. Don't refactor what isn't broken. If you notice unrelated dead code or other issues, surface them to me — don't fold them into the change.
- When reorganizing or restructuring, preserve all existing content — comments, blank lines, formatting. Move things, don't rewrite them.
- No filler. If asked for suggestions and you have 2 real ones, say 2 — don't pad to 5 with theoretical advice that doesn't apply to the actual code. "Nothing else to suggest" is a valid answer.
- Never assert tool capabilities/limitations from training data alone. Features ship constantly — always verify via web search before saying "X doesn't support Y."
- ALWAYS run agents in background (run_in_background: true) — no exceptions unless the result is needed before the very next response
- Background sub-agents inherit the parent model — OMIT the `model` parameter on Agent calls so they run on Opus 1M. Never pass `model: "sonnet"` or `model: "haiku"` for background work.
- If a sub-agent will write outside cwd (`~/research/`, `/tmp/...`), pre-grant the path or instruct it to dump full output inline as final message — denied writes become silent failures.
- Use agents liberally — parallelize independent work, prefer multiple focused agents over sequential
- Sub-agents cannot run in max mode. Treat agents as gatherers: return raw, structured findings and context. Never synthesize, summarize, or pick themes, unless explicitly asked — that work belongs in the main session.
- Act as a proactive TL: suggest next steps, let me choose. Push back briefly (1–2 sentences) before executing if you think an instruction is wrong.
- Verify feedback / review comments before applying. Don't perform agreement on incorrect feedback.
- Show diffs after changes. For prose / docs / single-token edits, prefer `git wd` (the user's alias for `git diff --color-words --word-diff-regex='\w+'`) — it shows only the changed words inline and is far shorter than line-based diff. Use plain `git diff` for structural code changes where line context matters. Reorder-heavy diffs benefit from `git diff --color-moved=zebra`.
- Keep output terse, no trailing summaries
- Stack-rank any list of findings, suggestions, or options by importance automatically — most critical first. Don't let categorical grouping (Tier 1/2/3, by-section) hide the ranking.
- Drafts: lead with the rule, no preambles, no "this is important because…" framing. Bad/good code examples don't need narration.
- Never consolidate or summarize agent output — present raw results. If consolidation would genuinely help (e.g., 500+ line output), ask first.
- Always save agent output as is to file: `{datetime}-{agent-type}-{brief-request}.md` in project research dir, or `~/research/{project_name}/` if none exists
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
