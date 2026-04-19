#!/usr/bin/env bash
set -euo pipefail

echo "[process] Checking PR governance structure"

if [ -z "${GITHUB_EVENT_PATH:-}" ] || [ ! -f "${GITHUB_EVENT_PATH:-}" ]; then
  echo "[process] No GITHUB_EVENT_PATH available, skipping local check"
  exit 0
fi

python3 - <<'PYTHON'
import json
import os
import re
import sys

path = os.environ['GITHUB_EVENT_PATH']
with open(path, 'r', encoding='utf-8') as f:
    event = json.load(f)

pr = event.get('pull_request')
if not pr:
    print('[process] Not a pull_request event, skipping')
    sys.exit(0)

body = pr.get('body') or ''
errors = []

required_headers = [
    '## Stage Context',
    '## Checklist',
]
for header in required_headers:
    if header not in body:
        errors.append(f"Missing section: {header}")

stage_match = re.search(r"- Stage:\s*(.+)", body)
if not stage_match or not stage_match.group(1).strip() or '<!--' in stage_match.group(1):
    errors.append('Stage line is empty or contains template placeholder')

meta_match = re.search(r"- Meta Issue:\s*(.+)", body)
if not meta_match or not meta_match.group(1).strip() or '<!--' in meta_match.group(1):
    errors.append('Meta Issue line is empty or contains template placeholder')
else:
    value = meta_match.group(1).strip()
    if not (re.search(r"#\d+", value) or value.upper() == 'N/A'):
        errors.append('Meta Issue must reference #<id> or be N/A')

if not re.search(r"- \[[ xX]\] #<id>", body) and not re.search(r"- \[[ xX]\] #\d+", body):
    errors.append('Subtasks list must include at least one checkbox with issue reference')

if errors:
    print('[process] PR governance check failed:')
    for err in errors:
        print(f"- {err}")
    sys.exit(1)

print('[process] PR governance structure check passed')
PYTHON
