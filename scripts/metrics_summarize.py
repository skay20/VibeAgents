#!/usr/bin/env python3
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/metrics_summarize.py
# Template-Version: 1.11.0
# Last-Generated: 2026-02-04T17:55:11Z
# Ownership: Managed

import json
import sys
from pathlib import Path

if len(sys.argv) < 2:
    print("Usage: scripts/metrics_summarize.py <run_id>")
    sys.exit(1)

run_id = sys.argv[1]
settings_path = Path(".agentic/settings.json")
if settings_path.exists():
    try:
        settings = json.loads(settings_path.read_text()).get("settings", {})
        tele = settings.get("telemetry", {})
        if tele.get("enabled", True) is False:
            print("Telemetry disabled in settings; no report generated.")
            sys.exit(0)
    except Exception:
        pass
metrics_dir = Path(f".agentic/bus/metrics/{run_id}")
art_dir = Path(f".agentic/bus/artifacts/{run_id}")
art_dir.mkdir(parents=True, exist_ok=True)

events_path = metrics_dir / "events.jsonl"
event_counts = {}
questions_by_agent = {}
answers_by_agent = {}

if events_path.exists():
    try:
        for line in events_path.read_text().splitlines():
            if not line.strip():
                continue
            e = json.loads(line)
            et = e.get("event_type", "")
            event_counts[et] = event_counts.get(et, 0) + 1
            agent = e.get("agent_id", "")
            if et == "question_asked":
                questions_by_agent[agent] = questions_by_agent.get(agent, 0) + 1
            if et == "answer_received":
                answers_by_agent[agent] = answers_by_agent.get(agent, 0) + 1
    except Exception:
        pass

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
    "## Event Summary",
    f"- run_start: {event_counts.get('run_start', 0)}",
    f"- agent_start: {event_counts.get('agent_start', 0)}",
    f"- agent_end: {event_counts.get('agent_end', 0)}",
    f"- blocked: {event_counts.get('blocked', 0)}",
    f"- run_end: {event_counts.get('run_end', 0)}",
    f"- preflight_start: {event_counts.get('preflight_start', 0)}",
    f"- preflight_end: {event_counts.get('preflight_end', 0)}",
    f"- question_asked: {event_counts.get('question_asked', 0)}",
    f"- answer_received: {event_counts.get('answer_received', 0)}",
    "",
    "| Agent | Tool | Status | Duration (ms) | Iterations | Tokens In | Tokens Out | Outputs |",
    "| --- | --- | --- | --- | --- | --- | --- | --- |",
]

for r in rows:
    lines.append(
        f"| {r.get('agent_id','')} | {r.get('tool','')} | {r.get('status','')} | {r.get('duration_ms','')} | {r.get('iterations','')} | {r.get('tokens_in','')} | {r.get('tokens_out','')} | {len(r.get('outputs_written',[]))} |"
    )

if questions_by_agent:
    lines += [
        "",
        "## Questions by Agent",
        "| Agent | Questions | Answers |",
        "| --- | --- | --- |",
    ]
    agents = sorted(set(list(questions_by_agent.keys()) + list(answers_by_agent.keys())))
    for a in agents:
        lines.append(f"| {a} | {questions_by_agent.get(a,0)} | {answers_by_agent.get(a,0)} |")

report = "\n".join(lines) + "\n"
(art_dir / "agent_performance_report.md").write_text(report)
print("Report written to", art_dir / "agent_performance_report.md")
