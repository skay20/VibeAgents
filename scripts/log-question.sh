#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/log-question.sh
# Template-Version: 1.3.0
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

if [[ "$telemetry_events" == "true" ]]; then
  EVENTS_FILE="$METRICS_DIR/events.jsonl"
  TS="$TS" EVENTS_FILE="$EVENTS_FILE" RUN_ID="$RUN_ID" AGENT_ID="$AGENT_ID" QUESTION_ID="$QUESTION_ID" QUESTION_TEXT="$QUESTION_TEXT" ANSWER_TEXT="$ANSWER_TEXT" PHASE="$PHASE" TOOL="$TOOL" python3 - <<'PY'
import json
import os
from pathlib import Path

events_file = Path(os.environ["EVENTS_FILE"])
run_id = os.environ["RUN_ID"]
agent_id = os.environ["AGENT_ID"]
question_id = os.environ["QUESTION_ID"]
question_text = os.environ["QUESTION_TEXT"]
answer_text = os.environ["ANSWER_TEXT"]
phase = os.environ["PHASE"]
tool = os.environ["TOOL"]
ts = os.environ["TS"]

existing = []
if events_file.exists():
    for line in events_file.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        try:
            existing.append(json.loads(line))
        except Exception:
            continue

def already_logged(event_type: str, qid: str, qtext: str, atext: str) -> bool:
    for evt in existing:
        if evt.get("event_type") != event_type:
            continue
        if evt.get("run_id") != run_id or evt.get("agent_id") != agent_id:
            continue
        if evt.get("question_id") != qid:
            continue
        if event_type == "question_asked" and evt.get("question_text") == qtext:
            return True
        if event_type == "answer_received" and evt.get("answer_text") == atext:
            return True
    return False

payloads = []
if not already_logged("question_asked", question_id, question_text, answer_text):
    payloads.append({
        "timestamp": ts,
        "event_type": "question_asked",
        "run_id": run_id,
        "agent_id": agent_id,
        "phase": phase,
        "tool": tool,
        "message": question_id,
        "question_id": question_id,
        "question_text": question_text
    })
if answer_text and not already_logged("answer_received", question_id, question_text, answer_text):
    payloads.append({
        "timestamp": ts,
        "event_type": "answer_received",
        "run_id": run_id,
        "agent_id": agent_id,
        "phase": phase,
        "tool": tool,
        "message": question_id,
        "question_id": question_id,
        "answer_text": answer_text
    })

if payloads:
    with events_file.open("a", encoding="utf-8") as fh:
        for payload in payloads:
            fh.write(json.dumps(payload, ensure_ascii=False) + "\n")
PY
fi

echo "Question logged: $QUESTION_ID"
