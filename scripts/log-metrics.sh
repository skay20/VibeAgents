#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/log-metrics.sh
# Template-Version: 1.7.0
# Last-Generated: 2026-02-04T00:04:25Z
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
TOKENS_IN="${11:-null}"
TOKENS_OUT="${12:-null}"
NOTES="${13:-}"

METRICS_DIR=".agentic/bus/metrics/$RUN_ID"
mkdir -p "$METRICS_DIR"

# Convert outputs to JSON array
IFS="," read -r -a outputs <<< "$OUTPUTS_WRITTEN"
JSON_OUTPUTS="[]"
if [[ -n "$OUTPUTS_WRITTEN" ]]; then
  JSON_OUTPUTS="["
  for o in "${outputs[@]}"; do
    o_trim=$(echo "$o" | xargs)
    JSON_OUTPUTS+=""$o_trim","
  done
  JSON_OUTPUTS=${JSON_OUTPUTS%,}
  JSON_OUTPUTS+="]"
fi

cat > "$METRICS_DIR/$AGENT_ID.json" <<EOF
{
  "agent_id": "$AGENT_ID",
  "run_id": "$RUN_ID",
  "phase": "$PHASE",
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
