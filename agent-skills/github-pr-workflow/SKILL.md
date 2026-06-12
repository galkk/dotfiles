---
name: github-pr-workflow
description: GitHub pull request workflow preferences for PR comments, review threads, CI-facing PR iteration, diffs, commits, pushes, PR descriptions, PR titles, review comments, merge policy, and GitHub review responses.
---

# GitHub PR Workflow

- Verify feedback / review comments before applying. Don't perform agreement on incorrect feedback.
- Show compact diffs before commit or when asked: `git wd` for prose/tiny edits, `git diff` for structural changes, `--color-moved=zebra` for reorders, summaries for noisy diffs.

# PR Style
- PR descriptions explain why, not file-by-file changes. During PR iteration, wait for an explicit push cue; before pushing, report `git status --short` plus diff summary. Keep review comments diff-scoped; send broader concerns to me.
