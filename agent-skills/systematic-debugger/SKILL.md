---
name: systematic-debugger
description: Use for failing tests, flaky behavior, crashes, regressions, bad logs, broken builds, or unexplained runtime behavior; reproduce and isolate the failure before proposing fixes.
---

# Systematic Debugger

Use this when the task is debugging rather than normal implementation.

## Debug Loop

1. State the observed failure and the command, input, or user action that shows it.
2. Reproduce the failure with the smallest command available.
3. Reduce scope before editing:
   - inspect recent diffs,
   - identify the failing boundary,
   - compare expected vs actual behavior,
   - isolate one plausible cause at a time.
4. Prefer deterministic evidence over guesses: stack traces, assertions, logs,
   snapshots, generated output, or minimal repros.
5. Make the smallest fix that explains the evidence.
6. Rerun the failing check and one adjacent check.
7. Report residual uncertainty separately.

## Subagent

Use the `systematic-debugger` agent for read-only reproduction and isolation.
Keep edits in the main thread unless the user explicitly delegates fixes to a
worker.

## Guardrails

- Do not broaden into cleanup while debugging.
- Do not patch symptoms without explaining the failing boundary.
- Do not skip reproduction because the cause looks obvious.
- Do not rerun noisy suites repeatedly without changing evidence.
