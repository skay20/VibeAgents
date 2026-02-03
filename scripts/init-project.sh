#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/init-project.sh
# Template-Version: 1.0.0
# Last-Generated: 2026-02-03T18:17:45Z
# Ownership: Managed

set -euo pipefail

ROOT="${1:-$(pwd)}"

mkdir -p "$ROOT/docs/ADR"   "$ROOT/.ai/context"   "$ROOT/.ai/logs/runs"   "$ROOT/.ai/state"   "$ROOT/.agentic/bus/artifacts"   "$ROOT/.agentic/bus/state"   "$ROOT/scripts"

create_if_missing() {
  local path="$1"
  local content="$2"
  if [[ ! -f "$path" ]]; then
    printf "%s
" "$content" > "$path"
  fi
}

create_if_missing "$ROOT/docs/PRD.md" "# PRD

TO_CONFIRM
"
create_if_missing "$ROOT/docs/RUNBOOK.md" "# Runbook

TO_CONFIRM
"
create_if_missing "$ROOT/docs/ARCHITECTURE.md" "# Architecture

TO_CONFIRM
"

echo "Init complete. Review docs/PRD.md and docs/RUNBOOK.md."
