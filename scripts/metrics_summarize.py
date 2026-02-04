#!/usr/bin/env python3
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/metrics_summarize.py
# Template-Version: 1.8.0
# Last-Generated: 2026-02-04T00:25:01Z
# Ownership: Managed

import json
import sys
from pathlib import Path

if len(sys.argv) < 2:
    print("Usage: scripts/metrics_summarize.py <run_id>")
    sys.exit(1)

run_id = sys.argv[1]
metrics_dir = Path(f".agentic/bus/metrics/{run_id}")
art_dir = Path(f".agentic/bus/artifacts/{run_id}")
art_dir.mkdir(parents=True, exist_ok=True)

rows = []
for p in metrics_dir.glob("*.json"):
    try:
        rows.append(json.loads(p.read_text()))
    except Exception:
        continue

if not rows:
    print("No metrics found for run_id", run_id)
    sys.exit(1)

blocked = sum(1 for r in rows if r.get("status") == "blocked")
failed = sum(1 for r in rows if r.get("status") == "failed")

def _num(v):
    if v is None:
        return None
    try:
        return int(v)
    except Exception:
        return None

durations = [_num(r.get("duration_ms")) for r in rows]
durations = [d for d in durations if d is not None]
tokens_in = [_num(r.get("tokens_in")) for r in rows]
tokens_out = [_num(r.get("tokens_out")) for r in rows]
tokens_in = [t for t in tokens_in if t is not None]
tokens_out = [t for t in tokens_out if t is not None]
avg_duration = int(sum(durations) / len(durations)) if durations else 0
total_tokens_in = sum(tokens_in) if tokens_in else 0
total_tokens_out = sum(tokens_out) if tokens_out else 0

lines = [
    "# Agent Performance Report",
    "",
    f"Run ID: {run_id}",
    "",
    f"Total agents: {len(rows)}",
    f"Blocked: {blocked}",
    f"Failed: {failed}",
    f"Average duration (ms): {avg_duration}",
    f"Total tokens in: {total_tokens_in}",
    f"Total tokens out: {total_tokens_out}",
    "",
    "| Agent | Tool | Status | Duration (ms) | Iterations | Tokens In | Tokens Out | Outputs |",
    "| --- | --- | --- | --- | --- | --- | --- | --- |",
]

for r in rows:
    lines.append(
        f"| {r.get('agent_id','')} | {r.get('tool','')} | {r.get('status','')} | {r.get('duration_ms','')} | {r.get('iterations','')} | {r.get('tokens_in','')} | {r.get('tokens_out','')} | {len(r.get('outputs_written',[]))} |"
    )

report = "\n".join(lines) + "\n"
(art_dir / "agent_performance_report.md").write_text(report)
print("Report written to", art_dir / "agent_performance_report.md")
