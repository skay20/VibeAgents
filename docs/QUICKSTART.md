---
Managed-By: AgenticRepoBuilder
Template-Source: templates/docs/QUICKSTART.md
Template-Version: 1.5.0
Last-Generated: 2026-02-06T16:43:23Z
Ownership: Managed
---

# VibeAgents Quickstart

## Purpose
This repository turns a PRD into agentic execution with file-based state, artifacts, and verification.

Authoritative operational files:
- `.agentic/CONSTITUTION.md`
- `.agentic/settings.json`
- `.agentic/AGENTS_CATALOG.md`
- `.agentic/bus/SCHEMA.md`

## Fast Start
1. Validate root:
```bash
pwd
```
2. Check settings:
```bash
cat .agentic/settings.json
```
3. Optional run mode:
```bash
export AGENTIC_RUN_MODE=AgentX
```
4. Start run:
```bash
AGENTIC_TOOL=codex scripts/orchestrator-first.sh
```
5. Provide PRD to the assistant and answer startup calibration.
6. Resolve tier + dispatch before implementation:
```bash
scripts/resolve-dispatch.sh <run_id>
```
7. Verify repository contracts:
```bash
scripts/verify.sh
```
8. Optional: refresh compiled adapters/context from source rules:
```bash
scripts/sync-agents.sh --profile default
```

If running this framework inside a generated side project with `project_meta`, run:
```bash
scripts/check-project-meta.sh <project_meta_dir>
```

## Startup Handshake (If You See “No Questions” or “PRD Not Ingested”)
Common failure mode: the tool only reads the top part of shared instruction files. This repo keeps the handshake in the first lines of:
- `.agentic/adapters/UNIVERSAL.md`
- `AGENTS.md`
- `.ai/context/RUNTIME_MIN.md`

If your assistant skipped calibration questions or did not write `docs/PRD.md`, run this diagnostic prompt inside the side project session (copy/paste verbatim):

```text
PRE-FLIGHT CHECK (before PRD) - do not invent.

1) Confirm you can read these files and quote 1 sentence from each (with absolute path):
- AGENTS.md
- .agentic/adapters/UNIVERSAL.md
- .ai/context/RUNTIME_MIN.md
- .agentic/settings.json

2) Print the effective startup settings you are using (exact keys/values):
- settings.run_mode.preferred
- settings.run_mode.default_if_unanswered
- settings.telemetry.enabled / events / questions / questions_log
- settings.automation.run_scripts / auto_start_run / auto_log_questions

3) Execute a no-PRD run start (do not continue to implementation):
AGENTIC_TOOL=codex scripts/start-run.sh "" "side-project" ""
Return the RUN_ID.

4) Log one calibration question and the answer using real agent_id:
AGENTIC_AGENT_ID=god_orchestrator scripts/log-question.sh <RUN_ID> Q_CALIBRATION "preflight ok?" "yes" "preflight" "codex"

5) Show me the evidence paths you created (do not paste full file contents):
- .agentic/bus/state/<RUN_ID>.json
- .agentic/bus/artifacts/<RUN_ID>/run_meta.md
- .agentic/bus/metrics/<RUN_ID>/events.jsonl
- .agentic/bus/artifacts/<RUN_ID>/questions_log.md

6) Explain: did you run the Startup Handshake steps (PRD ingest then calibration)? If not, which step was skipped and why.
```

PRD intake baseline rule:
- The assistant must detect PRD by structure, not only by keywords like `new PRD`.
- Structured project briefs (for example with `PROJECT:`, `ROLE`, requirements, routes, output expectation) must be treated as PRD input.

## Prompt System (v1/v2)
Dual-track prompt model:
- v1 standalone prompt: `.agentic/agents/<agent_id>.md`
- v2 thin prompt: `.agentic/agents/<agent_id>.v2.md`
- shared core for v2: `.agentic/agents/_CORE.md`

Deterministic resolution:
```bash
scripts/render-agent-prompt.sh <agent_id> <v1|v2|auto> [run_id]
```

`auto` reads `.agentic/settings.json`:
- `settings.prompt_resolution.default_version`
- `settings.prompt_resolution.pilot_v2_enabled`
- `settings.prompt_resolution.pilot_agents`
- `settings.prompt_resolution.fallback_version`
- `settings.prompt_resolution.write_compiled_artifacts`

If compiled artifacts are enabled:
- `.agentic/bus/artifacts/<run_id>/compiled_prompts/<agent_id>.md`

## Settings You Will Use Most
- `settings.run_mode`: AgentX/AgentL/AgentM behavior
- `settings.prd_intake`: structure-based PRD detection and PRD version evolution policy
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
- `.agentic/bus/state/<run_id>.json`

Operational artifacts:
- `.agentic/bus/artifacts/<run_id>/plan.md`
- `.agentic/bus/artifacts/<run_id>/decisions.md`
- `.agentic/bus/artifacts/<run_id>/diff_summary.md`
- `.agentic/bus/artifacts/<run_id>/qa_report.md`
- `.agentic/bus/artifacts/<run_id>/release_notes.md`

Telemetry (if enabled):
- `.agentic/bus/metrics/<run_id>/events.jsonl`
- `.agentic/bus/metrics/<run_id>/<agent_id>.json`
- `.agentic/bus/artifacts/<run_id>/questions_log.md`

Flow governance artifacts:
- `.agentic/bus/artifacts/<run_id>/tier_decision.md`
- `.agentic/bus/artifacts/<run_id>/dispatch_signals.md`
- `.agentic/bus/artifacts/<run_id>/dispatch_resolution.md`
- `.agentic/bus/artifacts/<run_id>/agent_activation_matrix.md`
- `.agentic/bus/artifacts/<run_id>/planned_agents.md`
- `.agentic/bus/artifacts/<run_id>/token_summary.md`
- `.agentic/bus/artifacts/<run_id>/flow_evidence.md`

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
- `settings.agent_dispatch.mode`
- `settings.agent_dispatch.catalog`
- `settings.agent_dispatch.always_required_agents`

Goal:
- avoid full-pipeline overhead on low-risk changes
- block release when required-agent evidence is missing for the selected tier
- evaluate all agents every run but execute only required/triggered ones

Runtime enforcement:
```bash
scripts/enforce-flow.sh <run_id> <tier> pre_release
scripts/enforce-flow.sh <run_id> <tier> final
```

Token summary (on demand):
```bash
scripts/metrics-token-summary.sh <run_id>
```

Execution evidence rule:
- `planned` metrics created by dispatch are not execution.
- executed agents must update status to `ok|blocked|failed`.
- enforcement reports `agents_not_executed` when planned stubs never became real execution metrics.

Rollout controls:
- `settings.rollout.enforcement_mode=report_only` for dry enforcement (Phase A).
- `settings.rollout.enforcement_mode=blocking` for hard gates (Phase B/C).

## Preflight for Web Projects
Run preflight before release decisions:
```bash
scripts/preflight.sh <run_id> <project_root>
```

Output:
- `.agentic/bus/artifacts/<run_id>/preflight_report.md`

## Context Profiles (Optional)
Switch compiled adapter focus without changing runtime artifacts:
```bash
scripts/switch-context.sh default
scripts/switch-context.sh architect
scripts/switch-context.sh developer
```

## Tech Gate (Optional / Tier Driven)
Run technical quality checks and write a report:
```bash
scripts/gates/verify-tech.sh <run_id>
```

Output:
- `.agentic/bus/artifacts/<run_id>/tech_verify_report.md`

## Project Docs (Auto)
When `settings.docs.auto_generate_project_runbook=true` and `settings.docs.auto_generate_project_readme=true`, the docs stage can auto-write:
- `<project_root>/RUNBOOK.md` (exact install/dev/test commands)
- `<project_root>/README.md` (managed block linking to RUNBOOK + summary)

Scripts:
```bash
scripts/ensure-project-runbook.sh <run_id>
scripts/ensure-project-readme.sh <run_id>
```

## Generated Project Docs
- Global `docs/RUNBOOK.md` is framework-level.
- Generated project runbook target is controlled by:
  - `settings.docs.project_runbook_path` (default `<project_root>/RUNBOOK.md`)

## Maintenance Policy
`docs/QUICKSTART.md` is managed and must be updated on iterations that change:
- workflow or phase gates
- settings keys/defaults
- prompt routing (`v1/v2`, resolver behavior)
- scripts used during startup, logging, or verification
- required artifact paths or schemas

If an iteration has no Quickstart-impacting changes, docs writer must record `No Quickstart delta` in:
- `.agentic/bus/artifacts/<run_id>/docs_report.md`
