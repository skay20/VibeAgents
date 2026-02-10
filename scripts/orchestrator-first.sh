#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/orchestrator-first.sh
# Template-Version: 1.0.0
# Last-Generated: 2026-02-07T00:00:00Z
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-$(date -u +%Y%m%d-%H%M%SZ)}"
TOOLCHAIN="${2:-${AGENTIC_TOOLCHAIN:-unknown}}"
RUN_MODE="${3:-${AGENTIC_RUN_MODE:-}}"
APPROVAL_MODE="${4:-}"

AGENTIC_HOME="${AGENTIC_HOME:-$(python3 - <<'PY'
import json
from pathlib import Path
p = Path(".agentic/settings.json")
default = ".agentic"
try:
    data = json.loads(p.read_text())
    print(data.get("settings", {}).get("paths", {}).get("agentic_home", default))
except Exception:
    print(default)
PY
)}"

OUTPUT="$(scripts/start-run.sh "$RUN_ID" "$TOOLCHAIN" "$RUN_MODE" "$APPROVAL_MODE")"
echo "$OUTPUT"

if ! echo "$OUTPUT" | grep -q "Run started:"; then
  echo "[FAIL] start-run did not complete."
  exit 1
fi

RESOLVED_RUN_ID="$(echo "$OUTPUT" | awk '/Run started:/ {print $3}' | tail -n1)"
if [[ -z "$RESOLVED_RUN_ID" ]]; then
  RESOLVED_RUN_ID="$RUN_ID"
fi

ART_DIR="$AGENTIC_HOME/bus/artifacts/$RESOLVED_RUN_ID"
STATE_FILE="$AGENTIC_HOME/bus/state/$RESOLVED_RUN_ID.json"
mkdir -p "$ART_DIR"

cat > "$ART_DIR/orchestrator_entrypoint.md" <<EOF
# Orchestrator Entrypoint

- Run ID: $RESOLVED_RUN_ID
- Entrypoint: scripts/orchestrator-first.sh
- Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
- Tool: ${AGENTIC_TOOL:-}
EOF

if [[ -f "$STATE_FILE" ]]; then
  STATE_FILE="$STATE_FILE" python3 - <<'PY'
import json, os
from datetime import datetime, timezone
from pathlib import Path

state_file = Path(os.environ["STATE_FILE"])
state = json.loads(state_file.read_text(encoding="utf-8"))
state["flow_status"] = "orchestrator_entrypoint_ok"
state.setdefault("selected_tier", "")
state.setdefault("planned_agents", [])
state.setdefault("executed_agents", [])
state["updated_at"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
state_file.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")
PY
fi

if [[ -x scripts/log-event.sh ]]; then
  scripts/log-event.sh "$RESOLVED_RUN_ID" "agent_start" "god_orchestrator" "orchestrator entrypoint initialized" "phase0_bootstrap" "${AGENTIC_TOOL:-}"
fi

echo "Orchestrator entrypoint ready: $RESOLVED_RUN_ID"
