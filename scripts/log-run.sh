#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/log-run.sh
# Template-Version: 1.0.0
# Last-Generated: 2026-02-03T18:17:45Z
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-$(date -u +%Y%m%d-%H%M%SZ)}"
shift || true

LOG_DIR=".ai/logs/runs/$RUN_ID"
BUS_DIR=".agentic/bus/artifacts/$RUN_ID"

mkdir -p "$LOG_DIR" "$BUS_DIR"

for f in "$@"; do
  if [[ -f "$f" ]]; then
    cp "$f" "$LOG_DIR/"
  fi
 done

echo "Run logged: $LOG_DIR"
