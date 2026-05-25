---
name: document-hygiene
description: Documentation, prose, and technical writing hygiene for drafts, docs, stamped specs and ADRs, append-only session/state files, code block wrapping, test reproducers, and external-source references. Use when drafting prose or editing documentation, specs, ADRs, session/state files, SQL, PromQL, or test reproducer docs.
---

# Document Hygiene

- Drafts: lead with the rule, no preambles, no "this is important because…" framing. Bad/good code examples don't need narration.
- When editing or asked to "look into X" in a doc, audit the fragment against three axes: (1) does it belong in this section?, (2) does it restate something already in the doc? (highest-priority check — grep before declaring clean), (3) does it fit the template's purpose for this section?
- Bump "Last updated" in stamped docs (tech specs, ADRs) on every content edit.
- Session/state files (e.g., SESSION.md, STATE.md): append-only chronological log; never edit or rewrite past entries.
- Wrap SQL, PromQL, and other long code at 80 cols max (S3 paths / single-token literals excepted).
- Always use language-tagged fenced code blocks for syntax highlighting.
- For test reproducer / throwaway harness code (anything under `test/`), skip non-correctness fixes — only items affecting verdict accuracy, re-runnability, or doc accuracy.
- Any reference to an external source (Chronosphere logs/metrics, GitHub PR/issue/line, Slack thread, Notion page, Buildkite build, Snowflake table) must include a direct link OR the exact query/command to reproduce. "Checked the latency dashboard" alone is not enough — link the dashboard or paste the PromQL/SQL.
