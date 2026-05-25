---
name: github-pr-workflow
description: GitHub pull request workflow preferences for diffs, commits, pushes, PR descriptions, PR titles, review comments, and merge policy. Use when working on GitHub PRs, preparing or reviewing pull request changes, addressing PR comments, committing, pushing, or merging.
---

# GitHub PR Workflow

- Verify feedback / review comments before applying. Don't perform agreement on incorrect feedback.
- Show diffs before commit or when I ask. For prose / docs / single-token edits, prefer `git wd` (the user's alias for `git diff --color-words --word-diff-regex='\w+'`) — it shows only the changed words inline and is far shorter than line-based diff. Use plain `git diff` for structural code changes where line context matters. Reorder-heavy diffs benefit from `git diff --color-moved=zebra`. For noisy or generated diffs, summarize the changed files and show only relevant hunks.

# PR Style
- PR descriptions should explain WHY, not list individual file changes — the diff IS the change
- Only describe substantial algorithm/logic changes, not mechanics
- Include Jira ticket in PR title when branch, issue, repo convention, or user context provides one (e.g., "[PROJ-1234] Title here").
- Always merge with squash + rebase; never merge commits.
- Don't push after every local commit during PR iteration. Before pushing, report concise `git status` and summarize the relevant diff; show full hunks only when asked or when the diff is small enough to review inline. Wait for an explicit "push" cue.
- PR review comments stay on the diff. Surface broader concerns (perf, security, correctness outside the diff) to me, not as drive-by comments.
