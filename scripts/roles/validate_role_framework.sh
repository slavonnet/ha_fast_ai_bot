#!/usr/bin/env bash
set -euo pipefail

echo "Deprecated wrapper: use scripts/roles/validate_role_framework.py"
python3 scripts/roles/validate_role_framework.py "$@"
