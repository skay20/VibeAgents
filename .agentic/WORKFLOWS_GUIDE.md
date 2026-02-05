---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/WORKFLOWS_GUIDE.md
Template-Version: 2.4.0
Last-Generated: 2026-02-04T17:55:11Z
Ownership: Managed
---

# Workflows Guide

## Standard Flow
1. init
2. plan
3. implement
4. qa
5. release

## Upgrade Flow
1. detect
2. plan
3. approve
4. apply
5. release

## PRD→Repo Engine
- PRD changes trigger decision records, file updates, version bumps, and migrations.
- Use `.agentic/bus/artifacts/<run_id>/` for traceability.

## Run Modes
- `AgentX`: minimal questions. Auto-advance gates after calibration. Document changes at the end.
- `AgentL`: normal collaborative mode. Approval required per phase gate.
- `AgentM`: more collaborative. Explain and suggest more.
- If `AGENTIC_RUN_MODE` is set, use it; otherwise ask at run start and default to `AgentL` if unanswered.

## Safe Overwrite Protocol
- Always write `diff_summary.md` before applying changes.
- Never overwrite human-owned files.
- Block if PRD conflicts with Constitution.

## Notes
- Each workflow writes artifacts to the bus.
- Use run_id for all artifacts and logs.
- Operational toggles live in `.agentic/settings.json`.
- Use `scripts/start-run.sh` to create run state and initial telemetry.
- Question logging is default when `settings.telemetry.questions=true`.
- If `settings.automation.run_scripts=true`, logging scripts run automatically.


## Metrics
- Log per-agent metrics to `.agentic/bus/metrics/<run_id>/`.
- Generate `agent_performance_report.md` after each run.
