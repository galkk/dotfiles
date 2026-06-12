#!/usr/bin/env python3
"""Audit local Claude/Codex dotfiles and live symlinks."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path


def is_link_to(path: Path, target: Path) -> bool:
    return path.is_symlink() and path.resolve() == target.resolve()


def add(items: list[str], level: str, msg: str) -> None:
    items.append(f"{level}: {msg}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dotfiles", default="/home/andy/projects/dotfiles")
    args = parser.parse_args()

    root = Path(args.dotfiles).expanduser()
    home = Path.home()
    findings: list[str] = []

    required = [
        root / ".codex" / "AGENTS.md",
        root / ".claude" / "CLAUDE.md",
        root / ".codex" / "user-hooks.json",
    ]
    for path in required:
        if not path.exists():
            add(findings, "ERROR", f"missing {path}")

    links = [
        (home / ".codex" / "AGENTS.md", root / ".codex" / "AGENTS.md"),
        (home / ".claude" / "CLAUDE.md", root / ".claude" / "CLAUDE.md"),
        (home / ".codex" / "hooks.json", root / ".codex" / "user-hooks.json"),
    ]
    for live, target in links:
        if not is_link_to(live, target):
            add(findings, "WARN", f"{live} is not symlinked to {target}")

    skills = sorted((root / "agent-skills").glob("*/SKILL.md"))
    if not skills:
        add(findings, "ERROR", "no dotfiles agent skills found")
    for skill in skills:
        name = skill.parent.name
        for base in [home / ".codex" / "skills", home / ".claude" / "skills"]:
            live = base / name
            if live.exists() and not is_link_to(live, skill.parent):
                add(findings, "WARN", f"{live} exists but is not expected symlink")
            elif not live.exists():
                add(findings, "WARN", f"{live} is missing")

    hooks = root / ".codex" / "user-hooks.json"
    if hooks.exists():
        try:
            data = json.loads(hooks.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            add(findings, "ERROR", f"invalid hook JSON: {exc}")
        else:
            for groups in data.values():
                for group in groups:
                    for hook in group.get("hooks", []):
                        cmd = hook.get("command", "")
                        if "agent-learning-stop-hook" in cmd:
                            script = root / "setup" / "agent-learning-stop-hook.sh"
                            if not script.exists():
                                add(findings, "ERROR", f"missing hook script {script}")

    config_text = (home / ".codex" / "config.toml").read_text(
        encoding="utf-8", errors="ignore"
    ) if (home / ".codex" / "config.toml").exists() else ""
    if "features.memories = true" not in config_text and "memories = true" not in config_text:
        add(findings, "WARN", "Codex memories do not appear enabled in live config")
    if "disable_on_external_context = true" not in config_text:
        add(findings, "WARN", "Codex memories should exclude external-context sessions")

    claude_agents = {p.stem for p in (root / ".claude" / "agents").glob("*.md")}
    codex_agents = {p.stem for p in (root / ".codex" / "agents").glob("*.toml")}
    for name in sorted((claude_agents | codex_agents) - {"research-gatherer"}):
        if name not in claude_agents:
            add(findings, "WARN", f"missing Claude agent for {name}")
        if name not in codex_agents:
            add(findings, "WARN", f"missing Codex agent for {name}")

    if not findings:
        print("No agent config issues found.")
        return 0

    for idx, finding in enumerate(findings, start=1):
        print(f"C{idx}. {finding}")
    return 1 if any(f.startswith("ERROR:") for f in findings) else 0


if __name__ == "__main__":
    raise SystemExit(main())
