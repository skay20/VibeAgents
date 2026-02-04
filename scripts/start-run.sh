#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/start-run.sh
# Template-Version: 1.4.0
# Last-Generated: 2026-02-04T16:33:06Z
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-$(date -u +%Y%m%d-%H%M%SZ)}"
TOOLCHAIN="${2:-${AGENTIC_TOOLCHAIN:-unknown}}"
RUN_MODE="${3:-${AGENTIC_RUN_MODE:-}}"
APPROVAL_MODE="${4:-}"

SETTINGS_FILE=".agentic/settings.json"

telemetry_enabled="true"
telemetry_events="true"
telemetry_questions_log="true"
run_start_enabled="true"
write_run_meta="true"
preferred_run_mode="autonomous"
default_run_mode="guided"

if [[ -f "$SETTINGS_FILE" ]]; then
  read -r telemetry_enabled telemetry_events telemetry_questions_log run_start_enabled write_run_meta preferred_run_mode default_run_mode < <(python3 - <<'PY'
import json
from pathlib import Path
p = Path(".agentic/settings.json")
try:
    data = json.loads(p.read_text())
except Exception:
    data = {}
s = data.get("settings", {})
tele = s.get("telemetry", {})
run_start = s.get("run_start", {})
run_mode = s.get("run_mode", {})
def b(v, default=True):
    if v is None:
        v = default
    return "true" if v else "false"
enabled = tele.get("enabled", True)
events = tele.get("events", True)
qlog = tele.get("questions_log", True)
rs_enabled = run_start.get("enabled", True)
rs_meta = run_start.get("write_run_meta", True)
pref = run_mode.get("preferred", "autonomous")
default = run_mode.get("default_if_unanswered", "guided")
print("true" if enabled else "false",
      "true" if events else "false",
      "true" if qlog else "false",
      "true" if rs_enabled else "false",
      "true" if rs_meta else "false",
      pref, default)
PY
)
fi

# Env overrides
lower() { printf "%s" "${1:-}" | tr '[:upper:]' '[:lower:]'; }

if [[ -n "${AGENTIC_TELEMETRY:-}" ]]; then
  case "$(lower "$AGENTIC_TELEMETRY")" in
    0|false|off|no|disable|disabled) telemetry_enabled="false" ;;
    *) telemetry_enabled="true" ;;
  esac
fi
if [[ -n "${AGENTIC_TELEMETRY_EVENTS:-}" ]]; then
  case "$(lower "$AGENTIC_TELEMETRY_EVENTS")" in
    0|false|off|no|disable|disabled) telemetry_events="false" ;;
    *) telemetry_events="true" ;;
  esac
fi
if [[ -n "${AGENTIC_RUN_START:-}" ]]; then
  case "$(lower "$AGENTIC_RUN_START")" in
    0|false|off|no|disable|disabled) run_start_enabled="false" ;;
    *) run_start_enabled="true" ;;
  esac
fi

if [[ "$run_start_enabled" != "true" ]]; then
  echo "Run-start disabled; skipping."
  exit 0
fi

if [[ -z "$RUN_MODE" ]]; then
  RUN_MODE="$default_run_mode"
fi

if [[ -z "$APPROVAL_MODE" ]]; then
  if [[ "$RUN_MODE" == "AgentX" ]]; then
    APPROVAL_MODE="auto"
  else
    APPROVAL_MODE="explicit"
  fi
fi

STARTED_AT="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

STATE_DIR=".agentic/bus/state"
METRICS_DIR=".agentic/bus/metrics/$RUN_ID"
ART_DIR=".agentic/bus/artifacts/$RUN_ID"
mkdir -p "$STATE_DIR" "$METRICS_DIR" "$ART_DIR"

if [[ "$telemetry_questions_log" == "true" ]]; then
  if [[ ! -f "$ART_DIR/questions_log.md" ]]; then
    cat > "$ART_DIR/questions_log.md" <<EOF
# Questions Log

Run ID: $RUN_ID
EOF
  fi
fi

cat > "$STATE_DIR/$RUN_ID.json" <<EOF
{
  "run_id": "$RUN_ID",
  "phase": "phase0_bootstrap",
  "gate_status": "pending",
  "started_at": "$STARTED_AT",
  "updated_at": "$STARTED_AT",
  "run_mode": "$RUN_MODE",
  "approval_mode": "$APPROVAL_MODE",
  "toolchain": "$TOOLCHAIN",
  "checkpoints": [
    "run_start"
  ]
}
EOF

if [[ "$write_run_meta" == "true" ]]; then
  cat > "$ART_DIR/run_meta.md" <<EOF
# Run Meta

- Run ID: $RUN_ID
- Started At: $STARTED_AT
- Toolchain: $TOOLCHAIN
- Run Mode: $RUN_MODE
- Approval Mode: $APPROVAL_MODE
- Run Mode Preference: $preferred_run_mode
- Run Mode Default: $default_run_mode
- Telemetry Enabled: $telemetry_enabled
- Telemetry Events: $telemetry_events
- Settings File: $SETTINGS_FILE
EOF
fi

if [[ "$telemetry_enabled" == "true" && "$telemetry_events" == "true" && -x scripts/log-event.sh ]]; then
  scripts/log-event.sh "$RUN_ID" "run_start" "god_orchestrator" "run started" "phase0_bootstrap" "${AGENTIC_TOOL:-}"
fi

echo "Run started: $RUN_ID"
