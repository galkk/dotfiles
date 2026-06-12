---
name: parallel-pr-review-board
description: Use for deep pull request review by spawning focused read-only reviewers for security, bugs, concurrency, tests, maintainability, and API/docs, then consolidating findings by severity.
---

# Parallel PR Review Board

Use this for review, not implementation.

## Reviewers

Spawn one reviewer per relevant concern:

- `pr-security-reviewer`: auth, secrets, injection, unsafe IO, dependency risk.
- `pr-bug-reviewer`: correctness, edge cases, regressions, error handling.
- `pr-concurrency-reviewer`: races, ordering, retries, locks, async behavior.
- `pr-test-reviewer`: missing coverage, flaky tests, weak assertions.
- `pr-maintainability-reviewer`: complexity, ownership boundaries, coupling.
- `pr-api-docs-reviewer`: public API, migration notes, docs, examples.

Ask each reviewer to inspect the PR diff against the target branch and return
only findings with file/line references, severity, and confidence.

## Consolidation

1. Deduplicate overlapping findings.
2. Reject speculative findings that lack a concrete failing path.
3. Stack-rank as `F1`, `F2`, `F3`.
4. Keep summaries secondary to findings.
5. Call out test gaps separately when there are no defects.

## Output Shape

```text
F1. [severity] file:line - issue
Evidence: ...
Fix direction: ...

Open questions:
...
```

If no reviewer finds a real issue, say so clearly and list residual risk.
