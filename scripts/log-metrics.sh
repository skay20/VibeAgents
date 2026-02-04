#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/log-metrics.sh
# Template-Version: 1.9.0
# Last-Generated: 2026-02-04T00:36:08Z
# Ownership: Managed

set -euo pipefail

RUN_ID="$1"
AGENT_ID="$2"
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

if [[ "$TOKENS_IN" == "auto" || "$TOKENS_IN" == "AUTO" || -z "$TOKENS_IN" ]]; then
  TOKENS_IN="$(pick_tokens in)"
fi
if [[ "$TOKENS_OUT" == "auto" || "$TOKENS_OUT" == "AUTO" || -z "$TOKENS_OUT" ]]; then
  TOKENS_OUT="$(pick_tokens out)"
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

echo "Metrics written: $METRICS_DIR/$AGENT_ID.json"
