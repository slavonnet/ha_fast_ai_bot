#!/usr/bin/env python3
"""Bootstrap role state labels in GitHub via gh CLI.

Reads role ids from ISSUE_LABELS_*.yaml files and ensures
req_start_/in_work_/done_/accept_/reject_ labels exist.
"""

from __future__ import annotations

import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ROLE_LABEL_GLOBS = [
    "agents/roles/*/ISSUE_LABELS_*.yaml",
    "agents/task_worker/*/ISSUE_LABELS_*.yaml",
]


def run(cmd: list[str]) -> str:
    result = subprocess.run(cmd, check=True, capture_output=True, text=True)
    return result.stdout.strip()


def has_gh() -> bool:
    try:
        run(["gh", "--version"])
        return True
    except Exception:
        return False


def parse_role_id(path: Path) -> str | None:
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.startswith("role_id:"):
            return line.split(":", 1)[1].strip()
    return None


def iter_labels_files() -> list[Path]:
    files: list[Path] = []
    for pattern in ROLE_LABEL_GLOBS:
        for file in sorted(ROOT.glob(pattern)):
            if file.is_file():
                files.append(file)
    return files


def label_exists(name: str) -> bool:
    names = run(["gh", "label", "list", "--limit", "1000", "--json", "name", "--jq", ".[].name"])
    return name in {line.strip() for line in names.splitlines() if line.strip()}


def ensure_label(name: str, color: str, description: str) -> None:
    if label_exists(name):
        run(["gh", "label", "edit", name, "--color", color, "--description", description])
        print(f"updated: {name}")
    else:
        run(["gh", "label", "create", name, "--color", color, "--description", description])
        print(f"created: {name}")


def main() -> int:
    print("Bootstrapping role state labels")
    if not has_gh():
        print("gh CLI is required")
        return 1

    role_ids: set[str] = set()
    for file in iter_labels_files():
        rid = parse_role_id(file)
        if rid:
            role_ids.add(rid)

    for role_id in sorted(role_ids):
        ensure_label(f"req_start_{role_id}", "1d76db", "Request to start role")
        ensure_label(f"in_work_{role_id}", "fbca04", "Role is currently processing (lock label)")
        ensure_label(f"done_{role_id}", "5319e7", "Role finished execution")
        ensure_label(f"accept_{role_id}", "0e8a16", "Role result accepted")
        ensure_label(f"reject_{role_id}", "b60205", "Role result rejected")

    print("Role labels bootstrap complete")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
