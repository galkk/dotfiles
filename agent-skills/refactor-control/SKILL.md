---
name: refactor-control
description: Scope control for refactors and cleanup. Use when simplifying conditionals, adding guards, doing cleanup, reorganizing code, preserving behavior, or deciding whether adjacent refactors are warranted.
---

# Refactor Control

- Keep refactors behavior-preserving unless the user explicitly asks for behavior changes.
- Do not make nearby cleanups, robustness rewrites, style changes, or opportunistic refactors just because they are adjacent to the requested change.
- When a conditional accumulates multiple guards, helper variables, or special-case checks, pause before adding more.
- Try inverting the predicate or reframing the success/skip condition, then use the simpler equivalent when behavior is unchanged.
- When moving or reorganizing code, preserve existing content, comments, blank lines, and formatting. Move things; do not rewrite them.
- Surface unrelated issues separately instead of folding them into the requested change.
