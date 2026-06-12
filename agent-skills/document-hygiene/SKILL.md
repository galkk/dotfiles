---
name: document-hygiene
description: Documentation, prose, and technical writing hygiene for specs, ADRs, docs edits, prose reviews, changelogs, stamped docs, append-only session/state files, SQL/PromQL wrapping, test reproducers, and external-source citations.
---

# Document Hygiene

- Drafts: lead with the rule, no preambles, no "this is important because…" framing. Bad/good code examples don't need narration.
- Doc audits: check section fit, duplicate content (`rg` first), and template purpose.
- Bump "Last updated" in stamped docs (tech specs, ADRs) on every content edit when the field already exists.
- Session/state files (e.g., SESSION.md, STATE.md): append-only chronological log; never edit or rewrite past entries.
- Wrap SQL, PromQL, and other long code at 80 cols max (S3 paths / single-token literals excepted).
- Always use language-tagged fenced code blocks for syntax highlighting.
- For test reproducer / throwaway harness code (anything under `test/`), skip non-correctness fixes — only items affecting verdict accuracy, re-runnability, or doc accuracy.
- External-source claims need a direct link or exact reproduction query/command.
