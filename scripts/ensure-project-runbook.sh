#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/ensure-project-runbook.sh
# Template-Version: 1.0.0
# Last-Generated: 2026-02-07T00:00:00Z
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-}"
if [[ -z "$RUN_ID" ]]; then
  echo "Usage: scripts/ensure-project-runbook.sh <run_id>"
  exit 1
fi

exec python3 "scripts/ensure-project-runbook.py" "$RUN_ID"

