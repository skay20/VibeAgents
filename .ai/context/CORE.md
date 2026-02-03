---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.ai/context/CORE.md
Template-Version: 1.3.0
Last-Generated: 2026-02-03T19:32:10Z
Ownership: Managed
---

# CORE (L0)

## Objective
Operate a No-App-First, file-based multi-agent system that turns PRD inputs into a deterministic, versioned repo state.

## Run Identity
- Format: `YYYYMMDD-HHMMSSZ-<slug>`
- State: `.agentic/bus/state/<run_id>.json`

## Required Artifacts (per run)
- `.agentic/bus/artifacts/<run_id>/plan.md`
- `.agentic/bus/artifacts/<run_id>/decisions.md`
- `.agentic/bus/artifacts/<run_id>/diff_summary.md`
- `.agentic/bus/artifacts/<run_id>/qa_report.md`
- `.agentic/bus/artifacts/<run_id>/release_notes.md`

## How to Run
1. Ensure `docs/PRD.md` is complete and free of placeholders.
2. Use phase gates in `README.md` and `.agentic/WORKFLOWS_GUIDE.md`.
3. Record every decision and diff summary in the bus.

## Blocking Conditions
- `docs/PRD.md` missing or contains placeholders.
- Attempt to advance phase without approval.
- Attempt to overwrite a human-owned file.

## Definition of Done
- Plan approved and recorded.
- All required artifacts exist for the run.
- Verification executed or explicitly blocked with reasons.
- Documentation and changelog updated when behavior changes.
- Run state updated and consistent with artifacts.
