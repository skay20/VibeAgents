#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/log-metrics.sh
# Template-Version: 1.14.0
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

TOKEN_SOURCE="none"
TOKEN_STATUS="unknown"
TOKENS_IN_SOURCE="none"
TOKENS_IN_STATUS="unknown"
TOKENS_OUT_SOURCE="none"
TOKENS_OUT_STATUS="unknown"

is_int() {
  [[ "${1:-}" =~ ^-?[0-9]+$ ]]
}

read_auto_token() {
  local dir="$1"
  local up
  up="$(printf "%s" "$dir" | tr '[:lower:]' '[:upper:]')"
  local val=""

  # Provider/runtime usage first
  for var in \
    "AGENTIC_PROVIDER_TOKENS_${up}" \
    "PROVIDER_TOKENS_${up}" \
    "OPENAI_TOKENS_${up}" \
    "ANTHROPIC_TOKENS_${up}" \
    "GEMINI_PROVIDER_TOKENS_${up}" \
    "CODEX_TOKENS_${up}" \
    "CLAUDE_TOKENS_${up}" \
    "GEMINI_TOKENS_${up}" \
    "CURSOR_TOKENS_${up}" \
    "WINDSURF_TOKENS_${up}" \
    "COPILOT_TOKENS_${up}" \
    "AGENTIC_TOKENS_${up}"
  do
    # shellcheck disable=SC2086,SC2016
    val="$(eval printf '%s' \"\${$var:-}\")"
    if [[ -n "$val" ]]; then
      if is_int "$val"; then
        echo "$val|provider_usage|measured"
      else
        echo "null|none|unknown"
      fi
      return 0
    fi
  done

  echo "null|none|unknown"
}

normalize_token_value() {
  local value="$1"
  local status="$2"

  if [[ -z "$value" || "$value" == "null" || "$value" == "NULL" ]]; then
    echo "null"
    return 0
  fi
  if ! is_int "$value"; then
    echo "null"
    return 0
  fi
  if [[ "$value" == "0" && "$status" != "measured" ]]; then
    echo "null"
    return 0
  fi
  echo "$value"
}

if is_false "$capture_tokens"; then
  TOKENS_IN="null"
  TOKENS_OUT="null"
  TOKENS_IN_SOURCE="none"
  TOKENS_OUT_SOURCE="none"
  TOKENS_IN_STATUS="unknown"
  TOKENS_OUT_STATUS="unknown"
else
  if [[ "$TOKENS_IN" == "auto" || "$TOKENS_IN" == "AUTO" || -z "$TOKENS_IN" ]]; then
    IFS='|' read -r TOKENS_IN TOKENS_IN_SOURCE TOKENS_IN_STATUS < <(read_auto_token in)
  else
    if is_int "$TOKENS_IN"; then
      TOKENS_IN_SOURCE="manual"
      TOKENS_IN_STATUS="estimated"
    else
      TOKENS_IN="null"
      TOKENS_IN_SOURCE="none"
      TOKENS_IN_STATUS="unknown"
    fi
  fi

  if [[ "$TOKENS_OUT" == "auto" || "$TOKENS_OUT" == "AUTO" || -z "$TOKENS_OUT" ]]; then
    IFS='|' read -r TOKENS_OUT TOKENS_OUT_SOURCE TOKENS_OUT_STATUS < <(read_auto_token out)
  else
    if is_int "$TOKENS_OUT"; then
      TOKENS_OUT_SOURCE="manual"
      TOKENS_OUT_STATUS="estimated"
    else
      TOKENS_OUT="null"
      TOKENS_OUT_SOURCE="none"
      TOKENS_OUT_STATUS="unknown"
    fi
  fi
fi

TOKENS_IN="$(normalize_token_value "$TOKENS_IN" "$TOKENS_IN_STATUS")"
TOKENS_OUT="$(normalize_token_value "$TOKENS_OUT" "$TOKENS_OUT_STATUS")"

if [[ "$TOKENS_IN" == "null" && "$TOKENS_IN_STATUS" != "measured" ]]; then
  TOKENS_IN_SOURCE="none"
  TOKENS_IN_STATUS="unknown"
fi
if [[ "$TOKENS_OUT" == "null" && "$TOKENS_OUT_STATUS" != "measured" ]]; then
  TOKENS_OUT_SOURCE="none"
  TOKENS_OUT_STATUS="unknown"
fi

if [[ "$TOKENS_IN_STATUS" == "measured" || "$TOKENS_OUT_STATUS" == "measured" ]]; then
  TOKEN_STATUS="measured"
elif [[ "$TOKENS_IN_STATUS" == "estimated" || "$TOKENS_OUT_STATUS" == "estimated" ]]; then
  TOKEN_STATUS="estimated"
else
  TOKEN_STATUS="unknown"
fi

if [[ "$TOKENS_IN_SOURCE" == "manual" || "$TOKENS_OUT_SOURCE" == "manual" ]]; then
  TOKEN_SOURCE="manual"
elif [[ "$TOKENS_IN_SOURCE" == "provider_usage" || "$TOKENS_OUT_SOURCE" == "provider_usage" ]]; then
  TOKEN_SOURCE="provider_usage"
elif [[ "$TOKENS_IN_SOURCE" == "env" || "$TOKENS_OUT_SOURCE" == "env" ]]; then
  TOKEN_SOURCE="env"
else
  TOKEN_SOURCE="none"
fi

if [[ -n "$NOTES" ]]; then
  NOTES="${NOTES}; token_provenance=in:${TOKENS_IN_SOURCE}/${TOKENS_IN_STATUS},out:${TOKENS_OUT_SOURCE}/${TOKENS_OUT_STATUS}"
else
  NOTES="token_provenance=in:${TOKENS_IN_SOURCE}/${TOKENS_IN_STATUS},out:${TOKENS_OUT_SOURCE}/${TOKENS_OUT_STATUS}"
fi

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
  "token_source": "$TOKEN_SOURCE",
  "token_status": "$TOKEN_STATUS",
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
