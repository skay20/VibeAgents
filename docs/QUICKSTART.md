---
Managed-By: AgenticRepoBuilder
Template-Source: templates/docs/QUICKSTART.md
Template-Version: 1.2.0
Last-Generated: 2026-02-06T17:00:00Z
Ownership: Managed
---

# VibeAgents Quickstart

## Purpose
This repository turns a PRD into agentic execution with file-based state, artifacts, and verification.

Authoritative operational files:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/CONSTITUTION.md`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/settings.json`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/AGENTS_CATALOG.md`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/SCHEMA.md`

## Fast Start
1. Validate root:
```bash
pwd
```
2. Check settings:
```bash
cat /Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/settings.json
```
3. Optional run mode:
```bash
export AGENTIC_RUN_MODE=AgentX
```
4. Start run:
```bash
AGENTIC_TOOL=codex /Users/matiassouza/Desktop/Projects/VibeAgents/scripts/start-run.sh
```
5. Provide PRD to the assistant and answer startup calibration.
6. Verify repository contracts:
```bash
/Users/matiassouza/Desktop/Projects/VibeAgents/scripts/verify.sh
```

## Prompt System (v1/v2)
Dual-track prompt model:
- v1 standalone prompt: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/agents/<agent_id>.md`
- v2 thin prompt: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/agents/<agent_id>.v2.md`
- shared core for v2: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/agents/_CORE.md`

Deterministic resolution:
```bash
/Users/matiassouza/Desktop/Projects/VibeAgents/scripts/render-agent-prompt.sh <agent_id> <v1|v2|auto> [run_id]
```

`auto` reads `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/settings.json`:
- `settings.prompt_resolution.default_version`
- `settings.prompt_resolution.pilot_v2_enabled`
- `settings.prompt_resolution.pilot_agents`
- `settings.prompt_resolution.fallback_version`
- `settings.prompt_resolution.write_compiled_artifacts`

If compiled artifacts are enabled:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/compiled_prompts/<agent_id>.md`

## Settings You Will Use Most
- `settings.run_mode`: AgentX/AgentL/AgentM behavior
- `settings.startup`: startup speed and question count
- `settings.telemetry`: events/questions/tokens capture
- `settings.automation`: automatic run/log script behavior
- `settings.prompt_resolution`: v1/v2 resolver control
- `settings.flow_control`: adaptive agent flow by risk tier (`lean|standard|strict`)
- `settings.checks`: preflight install/dev checks
- `settings.validation`: strict validation flags

Disable telemetry/logging fast path:
- Set these to `false`:
  - `settings.telemetry.enabled`
  - `settings.telemetry.capture_tokens`
  - `settings.telemetry.events`
  - `settings.telemetry.questions`
  - `settings.telemetry.questions_log`
  - `settings.automation.run_scripts`
  - `settings.automation.auto_start_run`
  - `settings.automation.auto_log_questions`
  - `settings.automation.auto_log_agents`
  - `settings.run_start.enabled`
  - `settings.run_start.write_run_meta`

## Run Artifacts and Metrics
Main run state:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/state/<run_id>.json`

Operational artifacts:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/plan.md`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/decisions.md`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/diff_summary.md`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/qa_report.md`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/release_notes.md`

Telemetry (if enabled):
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/metrics/<run_id>/events.jsonl`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/metrics/<run_id>/<agent_id>.json`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/questions_log.md`

## A/B Run Comparison
Use this when you run `feature OFF` vs `feature ON` and want a single comparison package.

1. Ensure both run IDs have metrics:
```bash
/Users/matiassouza/Desktop/Projects/VibeAgents/scripts/metrics_summarize.py <baseline_run_id>
/Users/matiassouza/Desktop/Projects/VibeAgents/scripts/metrics_summarize.py <experiment_run_id>
```
2. Generate benchmark comparison:
```bash
/Users/matiassouza/Desktop/Projects/VibeAgents/scripts/metrics_compare.py <baseline_run_id> <experiment_run_id> <benchmark_id>
```

Canonical benchmark output:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/benchmarks/<benchmark_id>/baseline_run_id.txt`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/benchmarks/<benchmark_id>/experiment_run_id.txt`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/benchmarks/<benchmark_id>/baseline_report.md`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/benchmarks/<benchmark_id>/experiment_report.md`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/benchmarks/<benchmark_id>/comparison.md`

## Adaptive Agent Flow (Quality + Speed)
Tier behavior:
- `lean`: low-risk work, minimal required agents.
- `standard`: default, balanced quality/speed.
- `strict`: high-risk changes with expanded required-agent checks.

Settings:
- `settings.flow_control.default_tier`
- `settings.flow_control.auto_tier_by_change`
- `settings.flow_control.required_agents`
- `settings.flow_control.strict_triggers`

Goal:
- avoid full-pipeline overhead on low-risk changes
- block release when required-agent evidence is missing for the selected tier

## Preflight for Web Projects
Run preflight before release decisions:
```bash
/Users/matiassouza/Desktop/Projects/VibeAgents/scripts/preflight.sh <run_id> <project_root>
```

Output:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/preflight_report.md`

## Maintenance Policy
`docs/QUICKSTART.md` is managed and must be updated on iterations that change:
- workflow or phase gates
- settings keys/defaults
- prompt routing (`v1/v2`, resolver behavior)
- scripts used during startup, logging, or verification
- required artifact paths or schemas

If an iteration has no Quickstart-impacting changes, docs writer must record `No Quickstart delta` in:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/docs_report.md`
