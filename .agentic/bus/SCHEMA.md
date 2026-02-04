---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/bus/SCHEMA.md
Template-Version: 1.9.0
Last-Generated: 2026-02-04T00:36:08Z
Ownership: Managed
---

# Bus Schema

## Run ID
Format: YYYYMMDD-HHMMSSZ-<slug>

## Artifacts
- Path: `.agentic/bus/artifacts/<run_id>/`
- Required files: plan.md, decisions.md, diff_summary.md, qa_report.md, release_notes.md
- Optional files: calibration_questions.md, intent.md, upgrade_plan.md

## State
- Path: `.agentic/bus/state/<run_id>.json`
- Tracks phase, gate status, timestamps, run_mode, approval_mode, toolchain


## Concurrency Policy
- Single-writer per run_id (orchestrator writes state).
- Subagents write only their own artifact files.
- Optional lock file: `.agentic/bus/state/<run_id>.lock` (create via atomic mkdir).


## Metrics
- Path: `.agentic/bus/metrics/<run_id>/`
- File per agent: `<agent_id>.json`
- Schema: `.agentic/bus/schemas/agent_metrics.schema.json`
- Each metrics file should include `tool` when available

## Metrics Report
- `.agentic/bus/artifacts/<run_id>/agent_performance_report.md`
