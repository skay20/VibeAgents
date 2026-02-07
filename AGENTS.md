---
Managed-By: AgenticRepoBuilder
Template-Source: templates/AGENTS.md
Template-Version: 2.3.0
Last-Generated: AUTO
Ownership: Managed
---

# Codex Instructions

## Shared Rules
Read .agentic/adapters/UNIVERSAL.md.
Bootstrap context:
- `.ai/context/RUNTIME_MIN.md`
- `.ai/context/BOOTSTRAP.md`
- `.ai/context/PROJECT.md`

Startup handshake (must happen even on fast runs):
- Create `run_id` via `scripts/orchestrator-first.sh` (when automation enabled).
- Detect PRD by structure (not only keyword) and ingest/update `docs/PRD.md` (managed block) before calibration.
- Ask calibration once, including run mode if `AGENTIC_RUN_MODE` is unset.
## Compiled Universal Rules (Inline)
- Startup handshake must run in this order: bootstrap context -> orchestrator entrypoint -> PRD ingest -> single calibration -> dispatch -> execution.
- PRD intake is structure-based (not keyword-only) and updates `docs/PRD.md` managed block.
- Always resolve dispatch and write: `tier_decision.md`, `dispatch_signals.md`, `dispatch_resolution.md`, `planned_agents.md`.
- In implementation runs, do not omit `architect`, `qa_reviewer`, or `docs_writer`.
- Planned agents are not execution evidence; executed agents must emit metrics with `ok|blocked|failed`.
- Enforce flow gates with `scripts/enforce-flow.sh <run_id> <tier> pre_release|final`.

## Codex-Specific
- Precedence: `AGENTS.override.md` > `AGENTS.md`.
- Directory overrides: nearer `AGENTS.md` wins.
- Tool identifier: set `AGENTIC_TOOL=codex`.
