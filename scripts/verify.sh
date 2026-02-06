#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/verify.sh
# Template-Version: 1.20.0
# Last-Generated: 2026-02-06T17:00:00Z
# Ownership: Managed

set -euo pipefail

FAIL=0

fail() {
  echo "[FAIL] $1"
  FAIL=1
}

# 1) Header checks for non-human-owned files
MANAGED_FILES=$(python3 - <<'PYCODE'
import json
from pathlib import Path
m=json.loads(Path('repo_manifest.json').read_text())
for f in m['files']:
    print(f"{f['path']}|{f.get('ownership', 'Managed')}")
PYCODE
)

for item in $MANAGED_FILES; do
  f="${item%%|*}"
  ownership="${item##*|}"
  if [[ ! -f "$f" ]]; then
    fail "Missing managed file: $f"
    continue
  fi
  if [[ "$ownership" == "Human" ]]; then
    continue
  fi
  if ! grep -q "Managed-By" "$f"; then
    fail "Missing Managed-By header in $f"
  fi
  if ! grep -q "Template-Version" "$f"; then
    fail "Missing Template-Version in $f"
  fi
  if ! grep -q "Last-Generated" "$f"; then
    fail "Missing Last-Generated in $f"
  fi
 done

# 2) Placeholder check (TO_CONFIRM) with allowlist
ALLOWLIST=("docs/PRD.md" "docs/RUNBOOK.md" "README.md" ".agentic/agents/god_orchestrator.md" "scripts/verify.sh")
for f in $MANAGED_FILES; do
  f="${f%%|*}"
  skip=0
  for a in "${ALLOWLIST[@]}"; do
    if [[ "$f" == "$a" ]]; then
      skip=1
      break
    fi
  done
  if [[ $skip -eq 1 ]]; then
    continue
  fi
  if grep -q "TO_CONFIRM" "$f"; then
    fail "Placeholder TO_CONFIRM found in $f"
  fi
 done


# 2b) PRD managed block check
if [[ -f "docs/PRD.md" ]]; then
  if ! grep -q "BEGIN_MANAGED" "docs/PRD.md" || ! grep -q "END_MANAGED" "docs/PRD.md"; then
    fail "docs/PRD.md missing BEGIN_MANAGED/END_MANAGED block"
  fi
fi



# 2c) PROJECT managed block check
if [[ -f ".ai/context/PROJECT.md" ]]; then
  if ! grep -q "BEGIN_MANAGED" ".ai/context/PROJECT.md" || ! grep -q "END_MANAGED" ".ai/context/PROJECT.md"; then
    fail "PROJECT.md missing BEGIN_MANAGED/END_MANAGED block"
  fi
fi


# 2d) Metrics schema and folder check
if [[ ! -f ".agentic/bus/schemas/agent_metrics.schema.json" ]]; then
  fail "Missing agent_metrics schema"
fi
if [[ ! -f ".agentic/bus/schemas/event.schema.json" ]]; then
  fail "Missing event schema"
fi
if [[ ! -f ".agentic/bus/schemas/plan.schema.json" ]]; then
  fail "Missing plan schema"
fi
if [[ ! -f ".agentic/bus/schemas/diff_summary.schema.json" ]]; then
  fail "Missing diff summary schema"
fi
if [[ ! -f ".agentic/bus/schemas/qa_report.schema.json" ]]; then
  fail "Missing qa report schema"
fi
if [[ ! -d ".agentic/bus/metrics" ]]; then
  fail "Missing metrics directory"
fi
if [[ ! -f ".ai/context/RUNTIME_MIN.md" ]]; then
  fail "Missing .ai/context/RUNTIME_MIN.md"
fi

# 2g) Startup handshake must be near the top of UNIVERSAL adapter
if [[ -f ".agentic/adapters/UNIVERSAL.md" ]]; then
  if ! head -n 60 ".agentic/adapters/UNIVERSAL.md" | grep -q "Startup Handshake"; then
    fail "UNIVERSAL.md must contain Startup Handshake within first 60 lines"
  fi
  if ! head -n 80 ".agentic/adapters/UNIVERSAL.md" | grep -q "Ingest.*docs/PRD.md\\|PRD ingest"; then
    fail "UNIVERSAL.md must mention PRD ingest near the top"
  fi
fi

# 2h) Codex adapter must reference RUNTIME_MIN
if [[ -f "AGENTS.md" ]]; then
  if ! grep -q "RUNTIME_MIN" "AGENTS.md"; then
    fail "AGENTS.md must include .ai/context/RUNTIME_MIN.md in bootstrap context"
  fi
fi

# 2i) RUNTIME_MIN must mention PRD ingest
if [[ -f ".ai/context/RUNTIME_MIN.md" ]]; then
  if ! head -n 80 ".ai/context/RUNTIME_MIN.md" | grep -q "Ingest.*docs/PRD.md\\|PRD"; then
    fail "RUNTIME_MIN.md must mention PRD ingest before calibration"
  fi
fi

# 2e) Settings file check
if [[ ! -f ".agentic/settings.json" ]]; then
  fail "Missing .agentic/settings.json"
else
  python3 - <<'PYCODE'
import json, sys
from pathlib import Path
p = Path(".agentic/settings.json")
try:
    data = json.loads(p.read_text())
except Exception:
    print("[FAIL] Invalid JSON in .agentic/settings.json")
    sys.exit(1)
settings = data.get("settings")
if not isinstance(settings, dict):
    print("[FAIL] Missing settings key in .agentic/settings.json")
    sys.exit(1)
tele = settings.get("telemetry", {})
run_start = settings.get("run_start", {})
run_mode = settings.get("run_mode", {})
startup = settings.get("startup", {})
automation = settings.get("automation", {})
checks = settings.get("checks", {})
validation = settings.get("validation", {})
prompt_resolution = settings.get("prompt_resolution", {})
flow_control = settings.get("flow_control", {})
required_agents = flow_control.get("required_agents", {})
required = [
    ("telemetry.enabled", tele.get("enabled", None)),
    ("telemetry.capture_tokens", tele.get("capture_tokens", None)),
    ("telemetry.events", tele.get("events", None)),
    ("telemetry.questions", tele.get("questions", None)),
    ("telemetry.questions_log", tele.get("questions_log", None)),
    ("run_start.enabled", run_start.get("enabled", None)),
    ("run_start.write_run_meta", run_start.get("write_run_meta", None)),
    ("run_mode.preferred", run_mode.get("preferred", None)),
    ("run_mode.default_if_unanswered", run_mode.get("default_if_unanswered", None)),
    ("startup.profile", startup.get("profile", None)),
    ("startup.max_initial_questions", startup.get("max_initial_questions", None)),
    ("startup.ask_only_missing", startup.get("ask_only_missing", None)),
    ("startup.avoid_script_reads", startup.get("avoid_script_reads", None)),
    ("startup.defer_repo_map", startup.get("defer_repo_map", None)),
    ("startup.single_calibration_message", startup.get("single_calibration_message", None)),
    ("startup.batch_startup_logging", startup.get("batch_startup_logging", None)),
    ("automation.run_scripts", automation.get("run_scripts", None)),
    ("automation.auto_start_run", automation.get("auto_start_run", None)),
    ("automation.auto_log_questions", automation.get("auto_log_questions", None)),
    ("automation.auto_log_agents", automation.get("auto_log_agents", None)),
    ("prompt_resolution.default_version", prompt_resolution.get("default_version", None)),
    ("prompt_resolution.pilot_v2_enabled", prompt_resolution.get("pilot_v2_enabled", None)),
    ("prompt_resolution.pilot_agents", prompt_resolution.get("pilot_agents", None)),
    ("prompt_resolution.fallback_version", prompt_resolution.get("fallback_version", None)),
    ("prompt_resolution.write_compiled_artifacts", prompt_resolution.get("write_compiled_artifacts", None)),
    ("flow_control.default_tier", flow_control.get("default_tier", None)),
    ("flow_control.auto_tier_by_change", flow_control.get("auto_tier_by_change", None)),
    ("flow_control.required_agents.lean", required_agents.get("lean", None)),
    ("flow_control.required_agents.standard", required_agents.get("standard", None)),
    ("flow_control.required_agents.strict", required_agents.get("strict", None)),
    ("flow_control.strict_triggers", flow_control.get("strict_triggers", None)),
    ("flow_control.max_parallel_agents", flow_control.get("max_parallel_agents", None)),
    ("checks.preflight_enabled", checks.get("preflight_enabled", None)),
    ("checks.preflight_run_install", checks.get("preflight_run_install", None)),
    ("checks.preflight_run_dev", checks.get("preflight_run_dev", None)),
    ("checks.preflight_timeout_sec", checks.get("preflight_timeout_sec", None)),
    ("checks.package_manager_auto", checks.get("package_manager_auto", None)),
    ("validation.enforce_agent_id", validation.get("enforce_agent_id", None)),
]
missing = [k for k,v in required if v is None]
if missing:
    print("[FAIL] Missing settings keys: " + ", ".join(missing))
    sys.exit(1)
if flow_control.get("default_tier") not in {"lean", "standard", "strict"}:
    print("[FAIL] flow_control.default_tier must be one of lean|standard|strict")
    sys.exit(1)
for key in ("lean", "standard", "strict"):
    value = required_agents.get(key, [])
    if not isinstance(value, list) or not value:
        print(f"[FAIL] flow_control.required_agents.{key} must be a non-empty list")
        sys.exit(1)
strict_triggers = flow_control.get("strict_triggers", [])
if not isinstance(strict_triggers, list):
    print("[FAIL] flow_control.strict_triggers must be a list")
    sys.exit(1)
PYCODE
  if [[ $? -ne 0 ]]; then
    FAIL=1
  fi
fi

# 2f) Scripts check
for s in scripts/start-run.sh scripts/log-event.sh scripts/log-question.sh scripts/preflight.sh scripts/preflight.py scripts/render-agent-prompt.sh; do
  if [[ ! -f "$s" ]]; then
    fail "Missing script: $s"
  fi
done

# 2g) Orchestrator adaptive flow checks
ORCH_V2=".agentic/agents/god_orchestrator.v2.md"
if [[ -f "$ORCH_V2" ]]; then
  for text in "Flow tier:" "Classify change risk and select flow tier" "Missing metrics/artifact evidence for any required agent"; do
    if ! grep -q "$text" "$ORCH_V2"; then
      fail "Orchestrator v2 missing adaptive flow requirement: $text"
    fi
  done
fi

# 3) Adapter coherence (bootstrap)
ADAPTERS=(
  "AGENTS.md"
  "GEMINI.md"
  ".gemini/styleguide.md"
  ".claude/CLAUDE.md"
  ".cursor/rules/00-global.mdc"
  ".windsurf/rules/00-global.md"
  ".github/copilot-instructions.md"
)
for f in "${ADAPTERS[@]}"; do
  if [[ -f "$f" ]]; then
    for ref in BOOTSTRAP.md PROJECT.md; do
      if ! grep -q "$ref" "$f"; then
        fail "Adapter $f missing reference to $ref"
      fi
    done
  fi
 done

# 4) Agent prompt structural checks (v1 + core + v2)
python3 - <<'PYCODE'
import re, sys

agent_ids = [
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

v1_required = [
    '## Scope', '## Inputs', '## Outputs', '## Decision Matrix', '## Operating Loop',
    '## Quality Gates', '## Failure Taxonomy', '## Escalation Protocol', '## Verification',
    '## Anti-Generic Rules', '## Definition of Done', '## Changelog'
]
v2_required = [
    '## Unique Inputs', '## Unique Outputs', '## Unique Decisions', '## Unique Loop',
    '## Hard Blockers'
]
core_required = [
    '## Startup Policy',
    '## Escalation Policy',
    '## Verification Policy',
    '## Anti-Generic Policy',
    '## Telemetry and Logging',
    '## Ownership Guardrails',
    '## Definition of Done Baseline',
]

fail = False

for agent_id in agent_ids:
    path = f'.agentic/agents/{agent_id}.md'
    try:
        text = open(path, encoding='utf-8').read()
    except FileNotFoundError:
        print(f"[FAIL] Missing v1 prompt: {path}")
        fail = True
        continue
    if 'Prompt-ID:' not in text or 'Version:' not in text:
        print(f"[FAIL] Missing Prompt-ID or Version in {path}")
        fail = True
    for sec in v1_required:
        if sec not in text:
            print(f"[FAIL] Missing section {sec} in {path}")
            fail = True
    if not re.search(r'`[^`]+/[^`]+`', text):
        print(f"[FAIL] No explicit file paths in {path}")
        fail = True
    if "Schema reference:" not in text:
        print(f"[FAIL] Missing schema reference in {path}")
        fail = True
    if "Ask 3" in text and "questions when blocked" in text:
        print(f"[FAIL] Legacy escalation wording in {path}")
        fail = True

core_path = '.agentic/agents/_CORE.md'
try:
    core_text = open(core_path, encoding='utf-8').read()
except FileNotFoundError:
    print(f"[FAIL] Missing core prompt: {core_path}")
    fail = True
    core_text = ''

if core_text:
    if 'Prompt-ID:' not in core_text or 'Version:' not in core_text:
        print(f"[FAIL] Missing Prompt-ID or Version in {core_path}")
        fail = True
    for sec in core_required:
        if sec not in core_text:
            print(f"[FAIL] Missing section {sec} in {core_path}")
            fail = True
    if "Ask 3" in core_text and "questions when blocked" in core_text:
        print(f"[FAIL] Legacy escalation wording in {core_path}")
        fail = True

for agent_id in agent_ids:
    path = f'.agentic/agents/{agent_id}.v2.md'
    try:
        text = open(path, encoding='utf-8').read()
    except FileNotFoundError:
        print(f"[FAIL] Missing v2 prompt: {path}")
        fail = True
        continue
    if 'Prompt-ID:' not in text or 'Version:' not in text or 'Agent-ID:' not in text:
        print(f"[FAIL] Missing Prompt-ID/Version/Agent-ID in {path}")
        fail = True
    if '@_CORE.md' not in text:
        print(f"[FAIL] Missing @_CORE include in {path}")
        fail = True
    for sec in v2_required:
        if sec not in text:
            print(f"[FAIL] Missing section {sec} in {path}")
            fail = True
    if "Schema reference:" not in text:
        print(f"[FAIL] Missing schema reference in {path}")
        fail = True
    lower = text.lower()
    if "ask 3-7 questions when blocked" in lower or ("ask 3" in lower and "questions when blocked" in lower):
        print(f"[FAIL] Legacy escalation wording in {path}")
        fail = True

if fail:
    sys.exit(1)
PYCODE
if [[ $? -ne 0 ]]; then
  FAIL=1
fi

# 5) Anti-genericity lint (outside Anti-Generic section)
python3 - <<'PYCODE'
import glob, re, sys
# Use word boundaries to avoid false positives (e.g., "dependencies" contains "depende").
banned = [
    r'best practices',
    r'consider',
    r'could',
    r'might',
    r'maybe',
    r'it depends',
    r'\\bdepende\\b',
]
fail = False
for path in glob.glob('.agentic/agents/*.md'):
    text = open(path, encoding='utf-8').read()
    parts = text.split('## Anti-Generic Rules')
    if len(parts) > 1:
        before = parts[0]
        after = parts[1]
        after_split = re.split(r'\n## ', after, maxsplit=1)
        remainder = ''
        if len(after_split) == 2:
            remainder = '## ' + after_split[1]
        text = before + '\n' + remainder
    lower = text.lower()
    for pat in banned:
        if re.search(pat, lower):
            print(f"[FAIL] Vague pattern '{pat}' in {path}")
            fail = True
            break
if fail:
    sys.exit(1)
PYCODE
if [[ $? -ne 0 ]]; then
  FAIL=1
fi

if [[ $FAIL -ne 0 ]]; then
  exit 1
fi

echo "[OK] verify.sh completed"
