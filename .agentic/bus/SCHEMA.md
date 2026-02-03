---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/bus/SCHEMA.md
Template-Version: 1.4.0
Last-Generated: 2026-02-03T19:42:42Z
Ownership: Managed
---

# Bus Schema

## Run ID
Format: YYYYMMDD-HHMMSSZ-<slug>

## Artifacts
- Path: `.agentic/bus/artifacts/<run_id>/`
- Required files: plan.md, decisions.md, diff_summary.md, qa_report.md, release_notes.md

## State
- Path: `.agentic/bus/state/<run_id>.json`
- Tracks phase, gate status, and timestamps


## Concurrency Policy
- Single-writer per run_id (orchestrator writes state).
- Subagents write only their own artifact files.
- Optional lock file: `.agentic/bus/state/<run_id>.lock` (create via atomic mkdir).
