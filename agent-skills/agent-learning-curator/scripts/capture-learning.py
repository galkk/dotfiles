#!/usr/bin/env python3
"""Capture a reviewed agent learning note into a project inbox."""

from __future__ import annotations

import argparse
import datetime as dt
import os
import re
import sys
from pathlib import Path


SECRET_PATTERNS = [
    re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----"),
    re.compile(r"\b(?:OPENAI|ANTHROPIC|GITHUB|AWS|GOOGLE)_[A-Z0-9_]*KEY\s*="),
    re.compile(r"\bgh[pousr]_[A-Za-z0-9_]{20,}\b"),
    re.compile(r"\bsk-[A-Za-z0-9_-]{20,}\b"),
]


def slug(value: str) -> str:
    value = value.lower()
    value = re.sub(r"[^a-z0-9]+", "-", value)
    return value.strip("-")[:80] or "learning"


def project_name(explicit: str | None) -> str:
    if explicit:
        return slug(explicit)
    cwd = Path.cwd()
    return slug(cwd.name or "default")


def reject_if_secret(text: str) -> None:
    for pattern in SECRET_PATTERNS:
        if pattern.search(text):
            raise SystemExit(
                "Refusing to capture note because it looks like it contains a secret."
            )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--title", required=True)
    parser.add_argument(
        "--kind",
        choices=["lesson", "correction", "pitfall", "workflow", "config"],
        default="lesson",
    )
    parser.add_argument("--skill", action="append", default=[])
    parser.add_argument("--source", default="")
    parser.add_argument("--project")
    args = parser.parse_args()

    body = sys.stdin.read().strip()
    if not body:
        raise SystemExit("Pass the learning note on stdin.")
    reject_if_secret(body)

    now = dt.datetime.now(dt.timezone.utc).astimezone()
    project = project_name(args.project)
    out_dir = Path.home() / "research" / project / "learning-inbox"
    out_dir.mkdir(parents=True, exist_ok=True)

    filename = f"{now.strftime('%Y%m%d-%H%M%S')}-{slug(args.title)}.md"
    path = out_dir / filename
    skills = ", ".join(args.skill) if args.skill else "unassigned"

    path.write_text(
        "\n".join(
            [
                "---",
                f"title: {args.title}",
                f"kind: {args.kind}",
                f"project: {project}",
                f"created: {now.isoformat(timespec='seconds')}",
                f"target_skills: {skills}",
                f"source: {args.source}",
                "---",
                "",
                body,
                "",
                "Promotion checklist:",
                "- [ ] Verified against current files or docs",
                "- [ ] No secrets or private data",
                "- [ ] Existing skill/instruction target chosen",
                "- [ ] Added only if it reduces future repeated correction",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    print(path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
