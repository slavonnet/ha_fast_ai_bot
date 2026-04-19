#!/usr/bin/env bash
set -euo pipefail

echo "Deprecated wrapper: use scripts/github/bootstrap_role_labels.py"
python3 scripts/github/bootstrap_role_labels.py "$@"
