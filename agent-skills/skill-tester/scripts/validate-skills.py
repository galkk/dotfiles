#!/usr/bin/env python3
"""Static validation for local Agent Skills."""

from __future__ import annotations

import argparse
import os
import re
import sys
from collections import defaultdict
from pathlib import Path


NAME_RE = re.compile(r"^[a-z0-9][a-z0-9-]{0,62}$")


def parse_frontmatter(path: Path) -> dict[str, str]:
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        return {}
    end = text.find("\n---", 4)
    if end == -1:
        return {}
    fields: dict[str, str] = {}
    for line in text[4:end].splitlines():
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        fields[key.strip()] = value.strip().strip('"').strip("'")
    return fields


def iter_skills(root: Path) -> list[Path]:
    if (root / "SKILL.md").is_file():
        return [root / "SKILL.md"]
    return sorted(root.glob("*/SKILL.md"))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("roots", nargs="*", default=["agent-skills"])
    args = parser.parse_args()

    errors: list[str] = []
    warnings: list[str] = []
    seen: dict[str, list[Path]] = defaultdict(list)
    visited: set[Path] = set()

    for root_arg in args.roots:
        root = Path(os.path.expanduser(root_arg))
        if not root.exists():
            warnings.append(f"{root}: root does not exist")
            continue
        for skill_file in iter_skills(root):
            real = skill_file.resolve()
            if real in visited:
                continue
            visited.add(real)
            fields = parse_frontmatter(skill_file)
            name = fields.get("name", "")
            description = fields.get("description", "")
            rel = skill_file.parent

            if not name:
                errors.append(f"{rel}: missing frontmatter name")
            elif not NAME_RE.fullmatch(name):
                errors.append(f"{rel}: invalid skill name {name!r}")
            else:
                seen[name].append(skill_file)

            if not description:
                errors.append(f"{rel}: missing frontmatter description")
            elif len(description) > 1024:
                errors.append(f"{rel}: description exceeds 1024 chars")
            elif len(description.split()) < 8:
                warnings.append(f"{rel}: description may be too terse for discovery")

            if not (skill_file.parent / "agents" / "openai.yaml").is_file():
                warnings.append(f"{rel}: missing agents/openai.yaml")

            for extra in ["README.md", "CHANGELOG.md", "INSTALLATION_GUIDE.md"]:
                if (skill_file.parent / extra).exists():
                    warnings.append(f"{rel}: avoid extra skill doc {extra}")

    for name, paths in sorted(seen.items()):
        unique = sorted({str(p.resolve()) for p in paths})
        if len(unique) > 1:
            joined = ", ".join(str(p) for p in paths)
            errors.append(f"duplicate skill name {name}: {joined}")

    for item in warnings:
        print(f"WARN: {item}")
    for item in errors:
        print(f"ERROR: {item}")

    print(f"Checked {len(visited)} skill(s)")
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
