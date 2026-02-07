#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/metrics-token-summary.sh
# Template-Version: 1.0.0
# Last-Generated: AUTO
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-}"
if [[ -z "$RUN_ID" ]]; then
  echo "Usage: scripts/metrics-token-summary.sh <run_id>"
  exit 1
fi

METRICS_DIR=".agentic/bus/metrics/${RUN_ID}"
ART_DIR=".agentic/bus/artifacts/${RUN_ID}"
OUT_FILE="${ART_DIR}/token_summary.md"

mkdir -p "$ART_DIR"

if [[ ! -d "$METRICS_DIR" ]]; then
  cat > "$OUT_FILE" <<EOF
# Token Summary

- Run ID: ${RUN_ID}
- Metrics directory: ${METRICS_DIR}
- Status: missing_metrics_directory
EOF
  echo "[WARN] Missing metrics directory, wrote ${OUT_FILE}"
  exit 0
fi

METRICS_DIR="$METRICS_DIR" RUN_ID="$RUN_ID" OUT_FILE="$OUT_FILE" python3 - <<'PY'
import json
import os
from pathlib import Path

run_id = os.environ["RUN_ID"]
metrics_dir = Path(os.environ["METRICS_DIR"])
out_file = Path(os.environ["OUT_FILE"])

files = sorted(metrics_dir.glob("*.json"))

total_agents = 0
executed_agents = 0
planned_agents = 0

tot_in_measured = 0
tot_out_measured = 0
tot_in_estimated = 0
tot_out_estimated = 0
tot_in_known = 0
tot_out_known = 0

measured_count = 0
estimated_count = 0
unknown_count = 0

unknown_agents = []
rows = []

for f in files:
    try:
        payload = json.loads(f.read_text(encoding="utf-8"))
    except Exception:
        continue
    agent_id = str(payload.get("agent_id", f.stem))
    status = str(payload.get("status", ""))
    token_status = str(payload.get("token_status", "unknown"))
    token_source = str(payload.get("token_source", "none"))
    tokens_in = payload.get("tokens_in")
    tokens_out = payload.get("tokens_out")

    total_agents += 1
    if status == "planned":
        planned_agents += 1
    else:
        executed_agents += 1

    if token_status == "measured":
        measured_count += 1
    elif token_status == "estimated":
        estimated_count += 1
    else:
        unknown_count += 1
        unknown_agents.append(agent_id)

    if isinstance(tokens_in, int):
        tot_in_known += tokens_in
        if token_status == "measured":
            tot_in_measured += tokens_in
        elif token_status == "estimated":
            tot_in_estimated += tokens_in
    if isinstance(tokens_out, int):
        tot_out_known += tokens_out
        if token_status == "measured":
            tot_out_measured += tokens_out
        elif token_status == "estimated":
            tot_out_estimated += tokens_out

    rows.append({
        "agent_id": agent_id,
        "status": status,
        "token_source": token_source,
        "token_status": token_status,
        "tokens_in": tokens_in,
        "tokens_out": tokens_out,
    })

coverage = 0.0
if executed_agents > 0:
    coverage = ((measured_count + estimated_count) / executed_agents) * 100.0

lines = [
    "# Token Summary",
    "",
    f"- Run ID: {run_id}",
    f"- Metrics Files: {total_agents}",
    f"- Executed Agents: {executed_agents}",
    f"- Planned Agents: {planned_agents}",
    f"- Coverage (measured+estimated over executed): {coverage:.1f}%",
    "",
    "## Totals",
    f"- tokens_in_known_total: {tot_in_known}",
    f"- tokens_out_known_total: {tot_out_known}",
    f"- tokens_in_measured_total: {tot_in_measured}",
    f"- tokens_out_measured_total: {tot_out_measured}",
    f"- tokens_in_estimated_total: {tot_in_estimated}",
    f"- tokens_out_estimated_total: {tot_out_estimated}",
    f"- token_status_count_measured: {measured_count}",
    f"- token_status_count_estimated: {estimated_count}",
    f"- token_status_count_unknown: {unknown_count}",
    "",
    "## Per Agent",
    "| Agent | Status | Token Source | Token Status | Tokens In | Tokens Out |",
    "| --- | --- | --- | --- | ---: | ---: |",
]

for row in rows:
    lines.append(
        f"| {row['agent_id']} | {row['status']} | {row['token_source']} | {row['token_status']} | {row['tokens_in']} | {row['tokens_out']} |"
    )

if unknown_agents:
    lines += [
        "",
        "## Unknown Token Coverage",
        "- Agents without reliable token usage:",
    ]
    lines.extend([f"- {a}" for a in unknown_agents])

out_file.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"[OK] wrote {out_file}")
PY
