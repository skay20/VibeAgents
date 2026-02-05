#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/preflight.sh
# Template-Version: 1.0.0
# Last-Generated: 2026-02-04T17:55:11Z
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-}"
ROOT="${2:-.}"

if [[ -z "$RUN_ID" ]]; then
  echo "Usage: scripts/preflight.sh <run_id> [project_root]"
  exit 1
fi

python3 scripts/preflight.py "$RUN_ID" "$ROOT"
