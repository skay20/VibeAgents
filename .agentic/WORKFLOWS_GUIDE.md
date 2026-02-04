---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/WORKFLOWS_GUIDE.md
Template-Version: 1.9.0
Last-Generated: 2026-02-04T00:36:08Z
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
- `autonomous`: minimal supervision. Auto-advance gates after an initial explicit approval.
- `guided`: frequent checkpoints. Approval required per phase gate.
- If `AGENTIC_RUN_MODE` is set, use it; otherwise ask at run start and default to `guided` if unanswered.

## Safe Overwrite Protocol
- Always write `diff_summary.md` before applying changes.
- Never overwrite human-owned files.
- Block if PRD conflicts with Constitution.

## Notes
- Each workflow writes artifacts to the bus.
- Use run_id for all artifacts and logs.


## Metrics
- Log per-agent metrics to `.agentic/bus/metrics/<run_id>/`.
- Generate `agent_performance_report.md` after each run.
