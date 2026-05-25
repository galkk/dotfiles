@../.codex/AGENTS.md

- ALWAYS run agents in background (run_in_background: true) — no exceptions unless the result is needed before the very next response
- Use agents liberally — parallelize independent work, prefer multiple focused agents over sequential
- Sub-agents cannot run in max mode. Use them as research gatherers; synthesis, edits, commits, pushes, and final decisions stay in the main session unless explicitly requested.
