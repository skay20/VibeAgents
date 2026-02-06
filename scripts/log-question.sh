#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/log-question.sh
# Template-Version: 1.2.0
# Last-Generated: 2026-02-04T16:33:06Z
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-}"
ARG2="${2:-}"
ARG3="${3:-}"
ARG4="${4:-}"
ARG5="${5:-}"
ARG6="${6:-}"
ARG7="${7:-}"

SETTINGS_FILE=".agentic/settings.json"

allowed_agent_ids() {
  if [[ -d ".agentic/agents" ]]; then
    ls .agentic/agents/*.md 2>/dev/null | xargs -n1 basename | sed 's/\.md$//'
  fi
}

is_allowed_agent_id() {
  local cand="$1"
  [[ -z "$cand" ]] && return 1
  allowed_agent_ids | grep -qx "$cand"
}

# Two supported signatures:
# 1) scripts/log-question.sh <run_id> <agent_id> <question_id> <question_text> [answer_text] [phase] [tool]
# 2) scripts/log-question.sh <run_id> <question_id> <question_text> [answer_text] [phase] [tool]
#
# Detect by checking whether ARG2 looks like a valid agent id.
if is_allowed_agent_id "$ARG2"; then
  AGENT_ID="$ARG2"
  QUESTION_ID="$ARG3"
  QUESTION_TEXT="$ARG4"
  ANSWER_TEXT="$ARG5"
  PHASE="$ARG6"
  TOOL="${ARG7:-${AGENTIC_TOOL:-}}"
else
  AGENT_ID="${AGENTIC_AGENT_ID:-god_orchestrator}"
  QUESTION_ID="$ARG2"
  QUESTION_TEXT="$ARG3"
  ANSWER_TEXT="$ARG4"
  PHASE="$ARG5"
  TOOL="${ARG6:-${AGENTIC_TOOL:-}}"
fi

if [[ -z "$RUN_ID" || -z "$QUESTION_ID" || -z "$QUESTION_TEXT" ]]; then
  echo "Usage:"
  echo "  scripts/log-question.sh <run_id> <agent_id> <question_id> <question_text> [answer_text] [phase] [tool]"
  echo "  scripts/log-question.sh <run_id> <question_id> <question_text> [answer_text] [phase] [tool]"
  exit 1
fi

telemetry_enabled="true"
telemetry_events="true"
telemetry_questions="true"
telemetry_questions_log="true"
enforce_agent_id="true"

if [[ -f "$SETTINGS_FILE" ]]; then
  read -r telemetry_enabled telemetry_events telemetry_questions telemetry_questions_log enforce_agent_id < <(python3 - <<'PY'
import json
from pathlib import Path
p = Path(".agentic/settings.json")
try:
    data = json.loads(p.read_text())
except Exception:
    data = {}
s = data.get("settings", {})
tele = s.get("telemetry", {})
validation = s.get("validation", {})
enabled = tele.get("enabled", True)
events = tele.get("events", True)
questions = tele.get("questions", True)
qlog = tele.get("questions_log", True)
enf = validation.get("enforce_agent_id", True)
print("true" if enabled else "false",
      "true" if events else "false",
      "true" if questions else "false",
      "true" if qlog else "false",
      "true" if enf else "false")
PY
)
fi

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
if [[ -n "${AGENTIC_TELEMETRY_QUESTIONS:-}" ]]; then
  case "$(lower "$AGENTIC_TELEMETRY_QUESTIONS")" in
    0|false|off|no|disable|disabled) telemetry_questions="false" ;;
    *) telemetry_questions="true" ;;
  esac
fi
if [[ -n "${AGENTIC_TELEMETRY_QUESTIONS_LOG:-}" ]]; then
  case "$(lower "$AGENTIC_TELEMETRY_QUESTIONS_LOG")" in
    0|false|off|no|disable|disabled) telemetry_questions_log="false" ;;
    *) telemetry_questions_log="true" ;;
  esac
fi

if [[ "$telemetry_enabled" != "true" || "$telemetry_questions" != "true" ]]; then
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

ART_DIR=".agentic/bus/artifacts/$RUN_ID"
METRICS_DIR=".agentic/bus/metrics/$RUN_ID"
mkdir -p "$ART_DIR" "$METRICS_DIR"

TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

if [[ "$telemetry_questions_log" == "true" ]]; then
  {
    echo "### $QUESTION_ID"
    echo "- Timestamp: $TS"
    echo "- Agent: $AGENT_ID"
    echo "- Tool: $TOOL"
    echo "- Phase: $PHASE"
    echo "- Q: $QUESTION_TEXT"
    if [[ -n "$ANSWER_TEXT" ]]; then
      echo "- A: $ANSWER_TEXT"
    fi
    echo ""
  } >> "$ART_DIR/questions_log.md"
fi

if [[ "$telemetry_events" == "true" && -x scripts/log-event.sh ]]; then
  scripts/log-event.sh "$RUN_ID" "question_asked" "$AGENT_ID" "$QUESTION_TEXT" "$PHASE" "$TOOL"
  if [[ -n "$ANSWER_TEXT" ]]; then
    scripts/log-event.sh "$RUN_ID" "answer_received" "$AGENT_ID" "$ANSWER_TEXT" "$PHASE" "$TOOL"
  fi
fi

echo "Question logged: $QUESTION_ID"
