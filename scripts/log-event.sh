#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/log-event.sh
# Template-Version: 1.2.0
# Last-Generated: 2026-02-10T20:25:14Z
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-}"
EVENT_TYPE="${2:-}"
ARG3="${3:-}"
ARG4="${4:-}"
ARG5="${5:-}"
ARG6="${6:-}"

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

allowed_agent_ids() {
  if [[ -d "$AGENTIC_HOME/agents" ]]; then
    ls "$AGENTIC_HOME"/agents/*.md 2>/dev/null | xargs -n1 basename | sed 's/\.md$//'
  fi
}

is_allowed_agent_id() {
  local cand="$1"
  [[ -z "$cand" ]] && return 1
  allowed_agent_ids | grep -qx "$cand"
}

# Two supported signatures:
# 1) scripts/log-event.sh <run_id> <event_type> <agent_id> <message> [phase] [tool]
# 2) scripts/log-event.sh <run_id> <event_type> <message> [phase] [tool]
if is_allowed_agent_id "$ARG3"; then
  AGENT_ID="$ARG3"
  MESSAGE="$ARG4"
  PHASE="$ARG5"
  TOOL="${ARG6:-${AGENTIC_TOOL:-}}"
else
  AGENT_ID="${AGENTIC_AGENT_ID:-god_orchestrator}"
  MESSAGE="$ARG3"
  PHASE="$ARG4"
  TOOL="${ARG5:-${AGENTIC_TOOL:-}}"
fi

if [[ -z "$RUN_ID" || -z "$EVENT_TYPE" ]]; then
  echo "Usage:"
  echo "  scripts/log-event.sh <run_id> <event_type> <agent_id> <message> [phase] [tool]"
  echo "  scripts/log-event.sh <run_id> <event_type> <message> [phase] [tool]"
  exit 1
fi

SETTINGS_FILE="$AGENTIC_HOME/settings.json"
telemetry_enabled="true"
telemetry_events="true"

if [[ -f "$SETTINGS_FILE" ]]; then
  read -r telemetry_enabled telemetry_events < <(SETTINGS_FILE="$SETTINGS_FILE" python3 - <<'PY'
import json
import os
from pathlib import Path
p = Path(os.environ["SETTINGS_FILE"])
try:
    data = json.loads(p.read_text())
except Exception:
    data = {}
s = data.get("settings", {})
tele = s.get("telemetry", {})
enabled = tele.get("enabled", True)
events = tele.get("events", True)
print("true" if enabled else "false", "true" if events else "false")
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

if [[ "$telemetry_enabled" != "true" || "$telemetry_events" != "true" ]]; then
  exit 0
fi

if [[ -z "${TOOL:-}" ]]; then
  STATE_FILE="$AGENTIC_HOME/bus/state/$RUN_ID.json"
  if [[ -f "$STATE_FILE" ]]; then
    TOOL="$(STATE_FILE="$STATE_FILE" python3 - <<'PY'
import json
import os
from pathlib import Path
p = Path(os.environ["STATE_FILE"])
try:
    data = json.loads(p.read_text())
except Exception:
    data = {}
print(data.get("toolchain", ""))
PY
)"
  fi
fi

EVENTS_DIR="$AGENTIC_HOME/bus/metrics/$RUN_ID"
mkdir -p "$EVENTS_DIR"

TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

TS="$TS" EVENT_TYPE="$EVENT_TYPE" RUN_ID="$RUN_ID" AGENT_ID="$AGENT_ID" PHASE="$PHASE" TOOL="$TOOL" MESSAGE="$MESSAGE" EVENTS_DIR="$EVENTS_DIR" python3 - <<'PY'
import json, os, sys
payload = {
  "timestamp": os.environ.get("TS"),
  "event_type": os.environ.get("EVENT_TYPE"),
  "run_id": os.environ.get("RUN_ID"),
  "agent_id": os.environ.get("AGENT_ID"),
  "phase": os.environ.get("PHASE"),
  "tool": os.environ.get("TOOL"),
  "message": os.environ.get("MESSAGE"),
}
with open(os.path.join(os.environ.get("EVENTS_DIR"), "events.jsonl"), "a", encoding="utf-8") as f:
  f.write(json.dumps(payload, ensure_ascii=False) + "\n")
PY

echo "Event logged: $EVENT_TYPE"
