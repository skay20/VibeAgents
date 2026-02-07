#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/resolve-dispatch.sh
# Template-Version: 1.0.0
# Last-Generated: 2026-02-07T00:00:00Z
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-}"
TIER_OVERRIDE="${2:-}"

if [[ -z "$RUN_ID" ]]; then
  echo "Usage: scripts/resolve-dispatch.sh <run_id> [tier_override]"
  exit 1
fi

SETTINGS_FILE=".agentic/settings.json"
STATE_FILE=".agentic/bus/state/${RUN_ID}.json"
ART_DIR=".agentic/bus/artifacts/${RUN_ID}"
METRICS_DIR=".agentic/bus/metrics/${RUN_ID}"
PRD_FILE="docs/PRD.md"

if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo "[FAIL] Missing settings file: $SETTINGS_FILE"
  exit 1
fi
if [[ ! -f "$STATE_FILE" ]]; then
  echo "[FAIL] Missing run state: $STATE_FILE"
  exit 1
fi

mkdir -p "$ART_DIR"
mkdir -p "$METRICS_DIR"

SETTINGS_FILE="$SETTINGS_FILE" STATE_FILE="$STATE_FILE" ART_DIR="$ART_DIR" METRICS_DIR="$METRICS_DIR" PRD_FILE="$PRD_FILE" RUN_ID="$RUN_ID" TIER_OVERRIDE="$TIER_OVERRIDE" python3 - <<'PY'
import json
import os
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path

settings_file = Path(os.environ["SETTINGS_FILE"])
state_file = Path(os.environ["STATE_FILE"])
art_dir = Path(os.environ["ART_DIR"])
metrics_dir = Path(os.environ["METRICS_DIR"])
prd_file = Path(os.environ["PRD_FILE"])
run_id = os.environ["RUN_ID"]
tier_override = os.environ["TIER_OVERRIDE"].strip()
tool = os.environ.get("AGENTIC_TOOL", "")

data = json.loads(settings_file.read_text())
settings = data.get("settings", {})
flow = settings.get("flow_control", {})
dispatch = settings.get("agent_dispatch", {})

catalog = dispatch.get("catalog", [])
always_required = set(dispatch.get("always_required_agents", []))
required_by_tier = flow.get("required_agents", {})
strict_triggers = flow.get("strict_triggers", [])
auto_tier = bool(flow.get("auto_tier_by_change", True))
default_tier = flow.get("default_tier", "standard")
conditional_cfg = dispatch.get("conditional_agents", {})
weights = dispatch.get("signal_weights", {})
weight_file = int(weights.get("file_match", 2))
weight_prd = int(weights.get("prd_keyword", 1))
weight_diff = int(weights.get("diff_hint", 2))

tier_rank = {"lean": 0, "standard": 1, "strict": 2}
if tier_override:
    selected_tier = tier_override
else:
    selected_tier = default_tier

prd_text = prd_file.read_text(encoding="utf-8") if prd_file.exists() else ""
prd_lower = prd_text.lower()

changed_paths = []
diff_summary = art_dir / "diff_summary.md"
if diff_summary.exists():
    for line in diff_summary.read_text(encoding="utf-8").splitlines():
        for m in re.findall(r"`([^`]+)`", line):
            if "/" in m or "." in m:
                changed_paths.append(m.strip())
        m2 = re.match(r"^\s*-\s+([A-Za-z0-9_./-]+)\s*$", line)
        if m2:
            changed_paths.append(m2.group(1).strip())

try:
    out = subprocess.check_output(["git", "diff", "--name-only"], text=True).splitlines()
    changed_paths.extend([x.strip() for x in out if x.strip()])
except Exception:
    pass

dedup = []
seen = set()
for path in changed_paths:
    if path not in seen:
        dedup.append(path)
        seen.add(path)
changed_paths = dedup

def has_path_token(token: str) -> bool:
    token_low = token.lower()
    for p in changed_paths:
        if token_low in p.lower():
            return True
    return False

trigger_hits = []
if has_path_token("package.json") or has_path_token("requirements.txt") or has_path_token("cargo.toml") or has_path_token("lock"):
    trigger_hits.append("dependency_files_changed")
if has_path_token("scripts/") or has_path_token("package.json"):
    trigger_hits.append("build_or_dev_scripts_changed")
if has_path_token("schema") or has_path_token("openapi") or has_path_token("api/"):
    trigger_hits.append("api_or_schema_changed")
if has_path_token("auth") or has_path_token("security") or has_path_token("token") or has_path_token("password"):
    trigger_hits.append("auth_or_security_changed")
if has_path_token("docs/architecture.md") or has_path_token("docs/adr/") or "architecture" in prd_lower:
    trigger_hits.append("architecture_or_adr_changed")

strict_hit = any(t in trigger_hits for t in strict_triggers)
if auto_tier and strict_hit:
    selected_tier = "strict"

if selected_tier not in tier_rank:
    selected_tier = default_tier if default_tier in tier_rank else "standard"

base_required = set(required_by_tier.get(selected_tier, []))
core_required = {"architect", "qa_reviewer", "docs_writer"}
base_required |= always_required | core_required

agent_order = [
    "god_orchestrator",
    "intent_translator",
    "context_curator",
    "stack_advisor",
    "architect",
    "planner",
    "implementer",
    "qa_reviewer",
    "security_reviewer",
    "docs_writer",
    "release_manager",
    "repo_maintainer",
    "template_librarian",
    "migration_manager",
]
order_index = {a: i for i, a in enumerate(agent_order)}

resolution = []
signal_rows = []

for agent in catalog:
    cfg = conditional_cfg.get(agent, {})
    min_score = int(cfg.get("min_score", 2))
    tier_min = cfg.get("tier_min", "standard")
    needed_rank = tier_rank.get(tier_min, 1)

    score = 0
    signals = []
    required = agent in base_required
    selected = False
    reason = "not_needed"

    file_patterns = cfg.get("file_patterns", [])
    if isinstance(file_patterns, list):
        for token in file_patterns:
            if has_path_token(str(token)):
                score += weight_file
                signals.append(f"file:{token}")

    prd_keywords = cfg.get("prd_keywords", [])
    if isinstance(prd_keywords, list):
        for keyword in prd_keywords:
            if str(keyword).lower() in prd_lower:
                score += weight_prd
                signals.append(f"prd:{keyword}")

    if agent == "stack_advisor" and "dependency_files_changed" in trigger_hits:
        score += weight_diff
        signals.append("diff:dependency_files_changed")
    if agent == "architect" and "architecture_or_adr_changed" in trigger_hits:
        score += weight_diff
        signals.append("diff:architecture_or_adr_changed")
    if agent == "security_reviewer" and "auth_or_security_changed" in trigger_hits:
        score += weight_diff
        signals.append("diff:auth_or_security_changed")
    if agent == "migration_manager" and "migration" in prd_lower:
        score += weight_diff
        signals.append("diff:migration_keyword")

    if required:
        selected = True
        reason = "required"
        score = max(score, 3)
    elif tier_rank[selected_tier] >= needed_rank and score >= min_score:
        selected = True
        reason = "triggered"

    resolution.append({
        "agent_id": agent,
        "selected": selected,
        "required": required,
        "reason": reason,
        "score": score,
        "signals": signals,
    })
    signal_rows.append((agent, score, ", ".join(signals) if signals else "-"))

planned = [r["agent_id"] for r in resolution if r["selected"]]
planned = sorted(planned, key=lambda a: order_index.get(a, 999))

tier_decision_lines = [
    "# Tier Decision",
    "",
    f"- Run ID: {run_id}",
    f"- Selected Tier: {selected_tier}",
    f"- Default Tier: {default_tier}",
    f"- Auto Tier By Change: {'true' if auto_tier else 'false'}",
    f"- Strict Trigger Hits: {', '.join(trigger_hits) if trigger_hits else '(none)'}",
]
(art_dir / "tier_decision.md").write_text("\n".join(tier_decision_lines) + "\n", encoding="utf-8")

signal_lines = [
    "# Dispatch Signals",
    "",
    f"- Run ID: {run_id}",
    f"- Tier: {selected_tier}",
    f"- Changed Paths Count: {len(changed_paths)}",
    "",
    "## Strict Trigger Hits",
]
if trigger_hits:
    signal_lines.extend([f"- {hit}" for hit in trigger_hits])
else:
    signal_lines.append("- (none)")
signal_lines += [
    "",
    "## Agent Scores",
    "| Agent | Score | Signals |",
    "| --- | ---: | --- |",
]
for agent, score, signals in signal_rows:
    signal_lines.append(f"| {agent} | {score} | {signals} |")
(art_dir / "dispatch_signals.md").write_text("\n".join(signal_lines) + "\n", encoding="utf-8")

resolution_lines = [
    "# Dispatch Resolution",
    "",
    f"- Run ID: {run_id}",
    f"- Tier: {selected_tier}",
    "",
]
for row in resolution:
    resolution_lines.append(
        f"- agent_id: {row['agent_id']} | selected={'true' if row['selected'] else 'false'} | required={'true' if row['required'] else 'false'} | reason={row['reason']} | score={row['score']}"
    )
(art_dir / "dispatch_resolution.md").write_text("\n".join(resolution_lines) + "\n", encoding="utf-8")

matrix_lines = [
    "# Agent Activation Matrix",
    "",
    f"- Run ID: {run_id}",
    f"- Tier: {selected_tier}",
    "",
    "| agent_id | evaluated | selected | required | triggered_by | reason | score |",
    "| --- | --- | --- | --- | --- | --- | ---: |",
]
for row in resolution:
    signals = ", ".join(row["signals"]) if row["signals"] else "-"
    matrix_lines.append(
        f"| {row['agent_id']} | true | {'true' if row['selected'] else 'false'} | {'true' if row['required'] else 'false'} | {signals} | {row['reason']} | {row['score']} |"
    )
(art_dir / "agent_activation_matrix.md").write_text("\n".join(matrix_lines) + "\n", encoding="utf-8")

planned_lines = [
    "# Planned Agents",
    "",
    f"- Run ID: {run_id}",
    f"- Tier: {selected_tier}",
    "",
]
if planned:
    planned_lines.extend([f"- {agent}" for agent in planned])
else:
    planned_lines.append("- (none)")
(art_dir / "planned_agents.md").write_text("\n".join(planned_lines) + "\n", encoding="utf-8")

# Create deterministic planning stubs so enforcement can distinguish
# "planned but not executed" from "missing metrics entirely".
metrics_dir.mkdir(parents=True, exist_ok=True)
for agent in planned:
    target = metrics_dir / f"{agent}.json"
    if target.exists():
        continue
    payload = {
        "agent_id": agent,
        "run_id": run_id,
        "phase": "phase1_dispatch",
        "tool": tool,
        "status": "planned",
        "start_at": None,
        "end_at": None,
        "duration_ms": 0,
        "block_reason": "",
        "outputs_written": [],
        "iterations": 0,
        "tokens_in": None,
        "tokens_out": None,
        "token_source": "none",
        "token_status": "unknown",
        "notes": "planned_by_dispatch",
    }
    target.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")

state = json.loads(state_file.read_text(encoding="utf-8"))
state["selected_tier"] = selected_tier
state["planned_agents"] = planned
state.setdefault("executed_agents", [])
state["flow_status"] = "dispatch_resolved"
state["updated_at"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
state_file.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")

print(f"[OK] Dispatch resolved for run {run_id} with tier={selected_tier}")
print(f"[OK] Planned agents: {', '.join(planned) if planned else '(none)'}")
PY
