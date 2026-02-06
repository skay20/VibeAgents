#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/enforce-flow.sh
# Template-Version: 1.0.0
# Last-Generated: 2026-02-06T16:42:21Z
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-}"
TIER="${2:-}"
MODE="${3:-pre_release}" # pre_release|final

if [[ -z "$RUN_ID" ]]; then
  echo "Usage: scripts/enforce-flow.sh <run_id> [tier] [pre_release|final]"
  exit 1
fi

if [[ "$MODE" != "pre_release" && "$MODE" != "final" ]]; then
  echo "[FAIL] Invalid mode '$MODE'. Use pre_release or final."
  exit 1
fi

SETTINGS_FILE=".agentic/settings.json"
STATE_FILE=".agentic/bus/state/${RUN_ID}.json"
ART_DIR=".agentic/bus/artifacts/${RUN_ID}"
METRICS_DIR=".agentic/bus/metrics/${RUN_ID}"

if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo "[FAIL] Missing settings file: $SETTINGS_FILE"
  exit 1
fi
if [[ ! -f "$STATE_FILE" ]]; then
  echo "[FAIL] Missing run state file: $STATE_FILE"
  exit 1
fi
if [[ ! -d "$ART_DIR" ]]; then
  echo "[FAIL] Missing artifacts directory: $ART_DIR"
  exit 1
fi
if [[ ! -d "$METRICS_DIR" ]]; then
  echo "[FAIL] Missing metrics directory: $METRICS_DIR"
  exit 1
fi

SETTINGS_FILE="$SETTINGS_FILE" STATE_FILE="$STATE_FILE" ART_DIR="$ART_DIR" METRICS_DIR="$METRICS_DIR" RUN_ID="$RUN_ID" TIER="$TIER" MODE="$MODE" python3 - <<'PY'
import json
import os
import re
import sys
from pathlib import Path

settings_file = Path(os.environ["SETTINGS_FILE"])
state_file = Path(os.environ["STATE_FILE"])
art_dir = Path(os.environ["ART_DIR"])
metrics_dir = Path(os.environ["METRICS_DIR"])
run_id = os.environ["RUN_ID"]
requested_tier = os.environ["TIER"].strip()
mode = os.environ["MODE"]

settings = json.loads(settings_file.read_text())
flow = settings.get("settings", {}).get("flow_control", {})
dispatch = settings.get("settings", {}).get("agent_dispatch", {})
required_by_tier = flow.get("required_agents", {})
default_tier = flow.get("default_tier", "standard")
catalog = dispatch.get("catalog", [])
always_required_agents = dispatch.get("always_required_agents", [])

tier = requested_tier or default_tier
if tier not in {"lean", "standard", "strict"}:
    print(f"[FAIL] Invalid tier '{tier}'.")
    sys.exit(1)

required_agents = required_by_tier.get(tier, [])
if not isinstance(required_agents, list) or not required_agents:
    print(f"[FAIL] No required agents configured for tier '{tier}'.")
    sys.exit(1)
if not isinstance(catalog, list) or not catalog:
    print("[FAIL] Missing settings.agent_dispatch.catalog.")
    sys.exit(1)
if not isinstance(always_required_agents, list) or not always_required_agents:
    print("[FAIL] Missing settings.agent_dispatch.always_required_agents.")
    sys.exit(1)

state = json.loads(state_file.read_text())
gate_status = state.get("gate_status", "")

metrics_files = list(metrics_dir.glob("*.json"))
executed_agents = sorted([p.stem for p in metrics_files])
decisions_text = (art_dir / "decisions.md").read_text() if (art_dir / "decisions.md").exists() else ""

required_artifacts = [
    "tier_decision.md",
    "dispatch_signals.md",
    "dispatch_resolution.md",
    "planned_agents.md",
    "flow_evidence.md",
]
missing_required_artifacts = [name for name in required_artifacts if not (art_dir / name).exists()]

planned_agents = []
planned_path = art_dir / "planned_agents.md"
if planned_path.exists():
    text = planned_path.read_text()
    planned_agents = sorted(set(re.findall(r"\b(god_orchestrator|intent_translator|context_curator|stack_advisor|architect|planner|implementer|qa_reviewer|security_reviewer|docs_writer|release_manager|repo_maintainer|template_librarian|migration_manager)\b", text)))

dispatch_entries = {}
dispatch_path = art_dir / "dispatch_resolution.md"
if dispatch_path.exists():
    for line in dispatch_path.read_text().splitlines():
        line = line.strip()
        # Expected format:
        # - agent_id: architect | selected=true | required=true | reason=required | score=3
        m = re.match(
            r"^-?\s*agent_id:\s*([a-z_]+)\s*\|\s*selected=(true|false)\s*\|\s*required=(true|false)\s*\|\s*reason=([a-z_]+)\s*\|\s*score=([0-9]+)\s*$",
            line
        )
        if not m:
            continue
        agent_id, selected, required, reason, score = m.groups()
        dispatch_entries[agent_id] = {
            "selected": selected == "true",
            "required": required == "true",
            "reason": reason,
            "score": int(score),
        }

missing_catalog_rows = [agent for agent in catalog if agent not in dispatch_entries]

non_omittable = {"architect", "qa_reviewer", "docs_writer"}
effective_required = sorted(
    set(required_agents)
    | set(always_required_agents)
    | non_omittable
    | {a for a, entry in dispatch_entries.items() if entry.get("required") or entry.get("selected")}
)

missing_metrics = []
missing_evidence = []
missing_planned = []

for agent in effective_required:
    agent_file = metrics_dir / f"{agent}.json"
    if not agent_file.exists():
        missing_metrics.append(agent)
        continue

    has_outputs = False
    try:
        payload = json.loads(agent_file.read_text())
        outputs = payload.get("outputs_written", [])
        has_outputs = isinstance(outputs, list) and len(outputs) > 0
    except Exception:
        pass

    has_decision = bool(re.search(rf"\b{re.escape(agent)}\b", decisions_text))
    if not has_outputs and not has_decision:
        missing_evidence.append(agent)

    if planned_agents and agent not in planned_agents:
        missing_planned.append(agent)

status = "PASS"
reasons = []

if missing_required_artifacts:
    status = "FAIL"
    reasons.append("missing_required_artifacts")
if missing_metrics:
    status = "FAIL"
    reasons.append("missing_metrics")
if missing_evidence:
    status = "FAIL"
    reasons.append("missing_evidence")
if missing_planned:
    status = "FAIL"
    reasons.append("missing_planned_dispatch")
if missing_catalog_rows:
    status = "FAIL"
    reasons.append("missing_catalog_rows")

report = []
report.append("# Flow Evidence")
report.append("")
report.append(f"- Run ID: {run_id}")
report.append(f"- Mode: {mode}")
report.append(f"- Tier: {tier}")
report.append(f"- Gate Status: {gate_status}")
report.append(f"- Required Agents: {', '.join(required_agents)}")
report.append(f"- Always Required Agents: {', '.join(sorted(set(always_required_agents) | non_omittable))}")
report.append(f"- Effective Required Agents: {', '.join(effective_required)}")
report.append(f"- Executed Agents: {', '.join(executed_agents) if executed_agents else '(none)'}")
report.append(f"- Planned Agents: {', '.join(planned_agents) if planned_agents else '(none)'}")
report.append(f"- Status: {status}")
if reasons:
    report.append(f"- Reasons: {', '.join(reasons)}")
if missing_required_artifacts:
    report.append(f"- Missing Required Artifacts: {', '.join(missing_required_artifacts)}")
if missing_metrics:
    report.append(f"- Missing Metrics: {', '.join(missing_metrics)}")
if missing_evidence:
    report.append(f"- Missing Evidence: {', '.join(missing_evidence)}")
if missing_planned:
    report.append(f"- Missing Planned Dispatch: {', '.join(missing_planned)}")
if missing_catalog_rows:
    report.append(f"- Missing Catalog Rows: {', '.join(missing_catalog_rows)}")

(art_dir / "flow_evidence.md").write_text("\n".join(report) + "\n")

print("\n".join(report))
if status != "PASS":
    sys.exit(2)
PY

echo "[OK] enforce-flow completed"
