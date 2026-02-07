#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/enforce-flow.sh
# Template-Version: 1.1.0
# Last-Generated: 2026-02-07T00:00:00Z
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
from datetime import datetime, timezone
from pathlib import Path

settings_file = Path(os.environ["SETTINGS_FILE"])
state_file = Path(os.environ["STATE_FILE"])
art_dir = Path(os.environ["ART_DIR"])
metrics_dir = Path(os.environ["METRICS_DIR"])
run_id = os.environ["RUN_ID"]
requested_tier = os.environ["TIER"].strip()
mode = os.environ["MODE"]

settings = json.loads(settings_file.read_text())
cfg = settings.get("settings", {})
flow = cfg.get("flow_control", {})
dispatch = cfg.get("agent_dispatch", {})
rollout = cfg.get("rollout", {})
docs_cfg = cfg.get("docs", {})
required_by_tier = flow.get("required_agents", {})
default_tier = flow.get("default_tier", "standard")
catalog = dispatch.get("catalog", [])
always_required_agents = dispatch.get("always_required_agents", [])
enforcement_mode = rollout.get("enforcement_mode", "blocking")

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
    "orchestrator_entrypoint.md",
    "tier_decision.md",
    "dispatch_signals.md",
    "dispatch_resolution.md",
    "planned_agents.md",
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
timestamp_issues = []
runbook_issue = None
readme_issue = None

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

events_path = metrics_dir / "events.jsonl"
run_start_ts = None
agent_starts = {}
agent_ends = {}

def parse_ts(value):
    if not value:
        return None
    value = value.replace("Z", "+00:00")
    try:
        return datetime.fromisoformat(value)
    except Exception:
        return None

if events_path.exists():
    for line in events_path.read_text().splitlines():
        if not line.strip():
            continue
        try:
            evt = json.loads(line)
        except Exception:
            continue
        et = evt.get("event_type")
        aid = evt.get("agent_id", "")
        ts = parse_ts(evt.get("timestamp"))
        if ts is None:
            continue
        if et == "run_start" and aid == "god_orchestrator":
            if run_start_ts is None or ts < run_start_ts:
                run_start_ts = ts
        if et == "agent_start":
            if aid not in agent_starts or ts < agent_starts[aid]:
                agent_starts[aid] = ts
        if et == "agent_end":
            if aid not in agent_ends or ts > agent_ends[aid]:
                agent_ends[aid] = ts

for metric_file in metrics_files:
    try:
        payload = json.loads(metric_file.read_text())
    except Exception:
        continue
    aid = payload.get("agent_id", metric_file.stem)
    s = parse_ts(payload.get("start_at"))
    e = parse_ts(payload.get("end_at"))
    if s and e and e < s:
        timestamp_issues.append(f"{aid}:metrics_end_before_start")
    if run_start_ts and s and s < run_start_ts:
        timestamp_issues.append(f"{aid}:metrics_start_before_run_start")

for aid, s in agent_starts.items():
    e = agent_ends.get(aid)
    if s and e and e < s:
        timestamp_issues.append(f"{aid}:event_end_before_start")

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
if mode == "final" and gate_status != "approved":
    status = "FAIL"
    reasons.append("gate_status_not_approved")
if timestamp_issues:
    status = "FAIL"
    reasons.append("timestamp_inconsistency")

# Project runbook enforcement (final only, zero overhead for runs without a detected project root)
def _safe_read_json(path: Path):
    try:
        return json.loads(path.read_text())
    except Exception:
        return None

def _resolve_project_root_rel() -> str:
    # Prefer artifact if already written, else derive from metrics outputs_written.
    p = art_dir / "project_root.txt"
    if p.exists():
        return p.read_text().strip()

    outputs = []
    for mf in metrics_files:
        payload = _safe_read_json(mf)
        if not isinstance(payload, dict):
            continue
        ow = payload.get("outputs_written", [])
        if isinstance(ow, list):
            for item in ow:
                if isinstance(item, str) and item.strip():
                    outputs.append(item.strip())

    # Candidate roots: parent containing a supported marker file.
    repo_root = Path(".").resolve()
    markers = ["package.json", "pyproject.toml", "requirements.txt", "Cargo.toml", "go.mod"]
    lockfiles = ["package-lock.json", "pnpm-lock.yaml", "yarn.lock", "Cargo.lock", "poetry.lock"]

    best = None
    best_score = -1

    for rel in outputs:
        relp = Path(rel)
        if relp.is_absolute():
            continue
        if relp.parts and (relp.parts[0].startswith(".") or relp.parts[0] in {"docs", "scripts", "Research"}):
            continue
        absp = (repo_root / relp).resolve()
        if not absp.exists():
            continue
        for parent in [absp] + list(absp.parents):
            if parent == repo_root or repo_root not in parent.parents:
                break
            if parent.is_file():
                parent = parent.parent
            score = 0
            for m in markers:
                if (parent / m).exists():
                    score += 10
            for l in lockfiles:
                if (parent / l).exists():
                    score += 2
            if score <= 0:
                continue
            if score > best_score:
                best = parent
                best_score = score

    if best is None:
        return ""
    return os.path.relpath(str(best), str(Path(".").resolve()))


if mode == "final" and "docs_writer" in effective_required:
    # Only enforce if docs settings opt-in and we detect a project root.
    if docs_cfg.get("require_project_runbook_when_project_detected", False):
        project_root_rel = _resolve_project_root_rel()
        if project_root_rel:
            template = docs_cfg.get("project_runbook_path", "<project_root>/RUNBOOK.md")
            runbook_rel = template.replace("<project_root>", project_root_rel).lstrip("./")
            runbook_path = Path(".") / runbook_rel
            if not runbook_path.exists():
                status = "FAIL"
                reasons.append("missing_project_runbook")
                runbook_issue = f"Missing project runbook: {runbook_rel}"

    if docs_cfg.get("require_project_readme_when_project_detected", False):
        project_root_rel = _resolve_project_root_rel()
        if project_root_rel:
            template = docs_cfg.get("project_readme_path", "<project_root>/README.md")
            readme_rel = template.replace("<project_root>", project_root_rel).lstrip("./")
            readme_path = Path(".") / readme_rel
            if not readme_path.exists():
                status = "FAIL"
                reasons.append("missing_project_readme")
                readme_issue = f"Missing project README: {readme_rel}"

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
report.append(f"- Enforcement Mode: {enforcement_mode}")
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
if timestamp_issues:
    report.append(f"- Timestamp Issues: {', '.join(sorted(set(timestamp_issues)))}")
if runbook_issue:
    report.append(f"- Runbook Issue: {runbook_issue}")
if readme_issue:
    report.append(f"- README Issue: {readme_issue}")

(art_dir / "flow_evidence.md").write_text("\n".join(report) + "\n")

flow_status = "flow_ok"
if status != "PASS":
    if any(r in reasons for r in ("missing_required_artifacts", "missing_catalog_rows", "missing_planned_dispatch")):
        flow_status = "invalid_path"
    else:
        flow_status = "blocked_flow"
elif mode == "pre_release":
    flow_status = "pre_release_passed"
elif mode == "final":
    flow_status = "approved"

state["selected_tier"] = tier
state["planned_agents"] = planned_agents
state["executed_agents"] = executed_agents
state["flow_status"] = flow_status
state["updated_at"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
state_file.write_text(json.dumps(state, indent=2) + "\n")

print("\n".join(report))
if status != "PASS" and enforcement_mode != "report_only":
    sys.exit(2)
PY

echo "[OK] enforce-flow completed"
