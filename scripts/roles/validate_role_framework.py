#!/usr/bin/env python3
"""Validate role framework integrity."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def fail(msg: str) -> None:
    print(f"[roles] {msg}")
    raise SystemExit(1)


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def ensure_exists(path: Path, kind: str = "file") -> None:
    ok = path.is_file() if kind == "file" else path.is_dir()
    if not ok:
        fail(f"Missing {kind}: {path.as_posix()}")


def parse_yaml_scalar(text: str, key: str) -> str:
    m = re.search(rf"^{re.escape(key)}:\s*(.+?)\s*$", text, flags=re.M)
    return m.group(1).strip() if m else ""


def parse_allowed_prefixes(text: str) -> list[str]:
    m = re.search(r"^allowed_prefixes:\s*$", text, flags=re.M)
    if not m:
        return []
    result: list[str] = []
    for line in text[m.end() :].splitlines():
        if not line.startswith("  - "):
            break
        result.append(line[4:].strip())
    return result


def main() -> int:
    ensure_exists(ROOT / "AGENTS.md")
    ensure_exists(ROOT / "agents" / "roles", kind="dir")
    ensure_exists(ROOT / "agents" / "rules", kind="dir")
    ensure_exists(ROOT / "agents" / "state-machine", kind="dir")

    role_dirs = sorted(p for p in (ROOT / "agents" / "roles").iterdir() if p.is_dir())
    task_worker_dirs = sorted((ROOT / "agents" / "task_worker").glob("*")) if (ROOT / "agents" / "task_worker").is_dir() else []
    if len(role_dirs) < 10:
        fail(f"Expected >= 10 role directories, got {len(role_dirs)}")

    allowed = {"req_", "in_work_", "done_", "accept_", "reject_"}

    for role_dir in role_dirs:
        role_name = role_dir.name
        upper = role_name.upper()

        agents_file = role_dir / f"AGENTS.{upper}.md"
        labels_file = role_dir / f"ISSUE_LABELS_{upper}.yaml"
        prompt_file = role_dir / "ROLE_PROMPT.md"
        agents_ref = f"agents/roles/{role_name}/AGENTS.{upper}.md"

        for p in (agents_file, labels_file, prompt_file):
            ensure_exists(p)

        agents_text = read_text(agents_file)
        if "## Next step" in agents_text:
            fail(f"Next-step section is forbidden in role AGENTS file: {agents_file.as_posix()}")

        prompt_text = read_text(prompt_file)
        if "Source of truth" not in prompt_text:
            fail(f"ROLE_PROMPT must declare source-of-truth policy: {prompt_file.as_posix()}")
        if agents_ref not in prompt_text:
            fail(f"ROLE_PROMPT must reference role AGENTS file: {prompt_file.as_posix()}")

        labels_text = read_text(labels_file)
        rid = parse_yaml_scalar(labels_text, "role_id")
        suffix = parse_yaml_scalar(labels_text, "state_suffix")
        model = parse_yaml_scalar(labels_text, "state_model")
        if rid != role_name:
            fail(f"role_id mismatch in {labels_file.as_posix()}")
        if suffix != role_name:
            fail(f"state_suffix mismatch in {labels_file.as_posix()}")
        if model != "prefix_plus_role_id":
            fail(f"state_model invalid in {labels_file.as_posix()}")

        prefixes = parse_allowed_prefixes(labels_text)
        for prefix in prefixes:
            if prefix not in allowed:
                fail(f"Disallowed prefix '{prefix}' in {labels_file.as_posix()}")

    for worker_dir in task_worker_dirs:
        if not worker_dir.is_dir():
            continue
        label_files = list(worker_dir.glob("ISSUE_LABELS_*.yaml"))
        for labels_file in label_files:
            labels_text = read_text(labels_file)
            prefixes = parse_allowed_prefixes(labels_text)
            for prefix in prefixes:
                if prefix not in allowed:
                    fail(f"Disallowed prefix '{prefix}' in {labels_file.as_posix()}")

    required_files = [
        "agents/rules/RULES.ISSUE_WORKFLOW.md",
        "agents/rules/RULES.PR_WORKFLOW.md",
        "agents/rules/RULES.CODE_DEVELOPMENT.md",
        "agents/rules/RULES.TEST_DEVELOPMENT.md",
        "agents/rules/RULES.DOC_DEVELOPMENT.md",
        "agents/rules/RULES.STATE_MACHINE.md",
        "agents/state-machine/STORY_SUBTASK_STATE_MACHINE.md",
        "agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json",
        "agents/state-machine/ROLE_PAIRS.md",
        "agents/state-machine/ROLLBACK_MATRIX.json",
        "agents/WORKERS_AUTOMATION_MAP.yaml",
        "agents/AUTOMATION_SETUP.md",
        "agents/roles/orchestrator_story/ORCHESTRATION_STATE_MACHINE.json",  # current Story orchestrator
        "agents/roles/orchestrator_story/ROLLBACK_MATRIX.json",  # current Story orchestrator
    ]
    for rel in required_files:
        ensure_exists(ROOT / rel)

    workers_map_text = read_text(ROOT / "agents" / "WORKERS_AUTOMATION_MAP.yaml")
    if re.search(r"^\s*-\s*role_id:\s*", workers_map_text, flags=re.M):
        fail("WORKERS_AUTOMATION_MAP must be autodiscovery config without hardcoded role list")

    global_sm_text = read_text(ROOT / "agents" / "state-machine" / "STORY_SUBTASK_STATE_MACHINE.json")
    if '"role_state_sources"' in global_sm_text or '"roles_order"' in global_sm_text:
        fail("Global state-machine JSON must be pointer-only")

    print("[roles] Role framework integrity check passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
