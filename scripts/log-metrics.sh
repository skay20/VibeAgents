#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/log-metrics.sh
# Template-Version: 1.13.0
# Last-Generated: 2026-02-04T14:22:29Z
# Ownership: Managed

set -euo pipefail

RUN_ID="$1"
AGENT_ID="${2:-${AGENTIC_AGENT_ID:-god_orchestrator}}"
STATUS="$3"  # ok|blocked|failed
START_AT="$4"
END_AT="$5"
DURATION_MS="$6"
PHASE="${7:-}"
BLOCK_REASON="${8:-}"
OUTPUTS_WRITTEN="${9:-}"   # comma-separated
ITERATIONS="${10:-1}"
TOKENS_IN="${11:-auto}"
TOKENS_OUT="${12:-auto}"
NOTES="${13:-}"
TOOL="${14:-${AGENTIC_TOOL:-}}"
SETTINGS_FILE=".agentic/settings.json"

is_false() {
  local v
  v=$(printf "%s" "${1:-}" | tr '[:upper:]' '[:lower:]')
  case "$v" in
    0|false|off|no|disable|disabled) return 0 ;;
    *) return 1 ;;
  esac
}

is_true() {
  local v
  v=$(printf "%s" "${1:-}" | tr '[:upper:]' '[:lower:]')
  case "$v" in
    1|true|on|yes|enable|enabled) return 0 ;;
    *) return 1 ;;
  esac
}

telemetry_enabled="true"
capture_tokens="true"
enforce_agent_id="true"

if [[ -f "$SETTINGS_FILE" ]]; then
  read -r telemetry_enabled capture_tokens enforce_agent_id < <(python3 - <<'PY'
import json
from pathlib import Path
p = Path(".agentic/settings.json")
try:
    data = json.loads(p.read_text())
except Exception:
    data = {}
settings = data.get("settings", {})
tele = settings.get("telemetry", {})
validation = settings.get("validation", {})
enabled = tele.get("enabled", True)
cap = tele.get("capture_tokens", True)
enf = validation.get("enforce_agent_id", True)
print("true" if enabled else "false", "true" if cap else "false", "true" if enf else "false")
PY
)
fi

# Env overrides
if [[ -n "${AGENTIC_TELEMETRY:-}" ]]; then
  if is_false "$AGENTIC_TELEMETRY"; then telemetry_enabled="false"; else telemetry_enabled="true"; fi
fi
if [[ -n "${AGENTIC_TELEMETRY_TOKENS:-}" ]]; then
  if is_false "$AGENTIC_TELEMETRY_TOKENS"; then capture_tokens="false"; else capture_tokens="true"; fi
fi

if is_false "$telemetry_enabled"; then
  echo "Telemetry disabled; skipping metrics."
  exit 0
fi

if [[ "$enforce_agent_id" == "true" ]]; then
  if [[ -d ".agentic/agents" ]]; then
    allowed=$(ls .agentic/agents/*.md 2>/dev/null | xargs -n1 basename | sed 's/\.md$//')
    if ! echo "$allowed" | grep -qx "$AGENT_ID"; then
      echo "[FAIL] Invalid agent_id '$AGENT_ID' (not in .agentic/agents)"
      exit 1
    fi
  fi
fi

METRICS_DIR=".agentic/bus/metrics/$RUN_ID"
mkdir -p "$METRICS_DIR"

# Convert outputs to JSON array safely
export OUTPUTS_WRITTEN
JSON_OUTPUTS=$(python3 - <<'PY'
import json, os
raw = os.environ.get("OUTPUTS_WRITTEN", "")
items = [i.strip() for i in raw.split(",") if i.strip()]
print(json.dumps(items))
PY
)

pick_tokens() {
  local dir="$1"
  local val=""
  if [[ "$dir" == "in" ]]; then
    val="${AGENTIC_TOKENS_IN:-}"
  else
    val="${AGENTIC_TOKENS_OUT:-}"
  fi
  if [[ -z "$val" && -n "$TOOL" ]]; then
    case "$TOOL" in
      codex) val="${CODEX_TOKENS_${dir^^}:-}" ;;
      gemini) val="${GEMINI_TOKENS_${dir^^}:-}" ;;
      claude) val="${CLAUDE_TOKENS_${dir^^}:-}" ;;
      cursor) val="${CURSOR_TOKENS_${dir^^}:-}" ;;
      windsurf) val="${WINDSURF_TOKENS_${dir^^}:-}" ;;
      copilot) val="${COPILOT_TOKENS_${dir^^}:-}" ;;
    esac
  fi
  if [[ -z "$val" ]]; then
    echo "null"
  else
    echo "$val"
  fi
}

if is_false "$capture_tokens"; then
  TOKENS_IN="null"
  TOKENS_OUT="null"
else
  if [[ "$TOKENS_IN" == "auto" || "$TOKENS_IN" == "AUTO" || -z "$TOKENS_IN" ]]; then
    TOKENS_IN="$(pick_tokens in)"
  fi
  if [[ "$TOKENS_OUT" == "auto" || "$TOKENS_OUT" == "AUTO" || -z "$TOKENS_OUT" ]]; then
    TOKENS_OUT="$(pick_tokens out)"
  fi
fi

if [[ -z "$TOKENS_IN" ]]; then TOKENS_IN="null"; fi
if [[ -z "$TOKENS_OUT" ]]; then TOKENS_OUT="null"; fi

cat > "$METRICS_DIR/$AGENT_ID.json" <<EOF
{
  "agent_id": "$AGENT_ID",
  "run_id": "$RUN_ID",
  "phase": "$PHASE",
  "tool": "$TOOL",
  "status": "$STATUS",
  "start_at": "$START_AT",
  "end_at": "$END_AT",
  "duration_ms": $DURATION_MS,
  "block_reason": "$BLOCK_REASON",
  "outputs_written": $JSON_OUTPUTS,
  "iterations": $ITERATIONS,
  "tokens_in": $TOKENS_IN,
  "tokens_out": $TOKENS_OUT,
  "notes": "$NOTES"
}
EOF

STATE_FILE=".agentic/bus/state/$RUN_ID.json"
ART_DIR=".agentic/bus/artifacts/$RUN_ID"
if [[ -f "$STATE_FILE" ]]; then
  STATE_FILE="$STATE_FILE" ART_DIR="$ART_DIR" AGENT_ID="$AGENT_ID" STATUS="$STATUS" python3 - <<'PY'
import json
import os
from datetime import datetime, timezone
from pathlib import Path

state_path = Path(os.environ["STATE_FILE"])
art_dir = Path(os.environ["ART_DIR"])
agent_id = os.environ["AGENT_ID"]
status = os.environ["STATUS"]

state = json.loads(state_path.read_text(encoding="utf-8"))
executed = state.get("executed_agents", [])
if not isinstance(executed, list):
    executed = []
if agent_id not in executed:
    executed.append(agent_id)
state["executed_agents"] = executed

dispatch_ready = (art_dir / "dispatch_resolution.md").exists() and (art_dir / "planned_agents.md").exists()
flow_status = state.get("flow_status", "started")

if agent_id == "implementer" and not dispatch_ready:
    state["flow_status"] = "invalid_path"
elif status == "ok":
    if flow_status in {"started", "orchestrator_entrypoint_ok", "dispatch_resolved"}:
        state["flow_status"] = "execution_in_progress"
elif status in {"blocked", "failed"}:
    state["flow_status"] = "blocked_flow"

state["updated_at"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
state_path.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")
PY
fi

echo "Metrics written: $METRICS_DIR/$AGENT_ID.json"
