#!/usr/bin/env python3
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/metrics_summarize.py
# Template-Version: 1.7.0
# Last-Generated: 2026-02-04T00:04:25Z
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

lines = [
    "# Agent Performance Report",
    "",
    f"Run ID: {run_id}",
    "",
    f"Total agents: {len(rows)}",
    f"Blocked: {blocked}",
    f"Failed: {failed}",
    "",
    "| Agent | Status | Duration (ms) | Iterations | Outputs |",
    "| --- | --- | --- | --- | --- |",
]

for r in rows:
    lines.append(
        f"| {r.get('agent_id','')} | {r.get('status','')} | {r.get('duration_ms','')} | {r.get('iterations','')} | {len(r.get('outputs_written',[]))} |"
    )

report = "\n".join(lines) + "\n"
(art_dir / "agent_performance_report.md").write_text(report)
print("Report written to", art_dir / "agent_performance_report.md")
