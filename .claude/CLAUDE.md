@../.codex/AGENTS.md

# Claude Code

- ALWAYS run agents in background (run_in_background: true) — no exceptions unless the result is needed before the very next response
- Background sub-agents inherit the parent model — OMIT the `model` parameter on Agent calls so they run on Opus 1M. Never pass `model: "sonnet"` or `model: "haiku"` for background work.
- Use agents liberally — parallelize independent work, prefer multiple focused agents over sequential
- Sub-agents cannot run in max mode. Treat agents as gatherers: return raw, structured findings and context. Never synthesize, summarize, or pick themes, unless explicitly asked — that work belongs in the main session.
