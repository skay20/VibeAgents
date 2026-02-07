#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/resolve-project-root.sh
# Template-Version: 1.0.0
# Last-Generated: 2026-02-07T00:00:00Z
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-}"
if [[ -z "$RUN_ID" ]]; then
  echo "Usage: scripts/resolve-project-root.sh <run_id> [--write-artifact]"
  exit 1
fi

shift || true
exec python3 "scripts/resolve-project-root.py" "$RUN_ID" --print-relative "$@"

