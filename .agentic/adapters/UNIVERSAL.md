---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/adapters/UNIVERSAL.md
Template-Version: 1.4.0
Last-Generated: 2026-02-06T16:26:32Z
Ownership: Managed
---

# Universal Adapter Rules

## Bootstrap Context (Required)
- `.ai/context/RUNTIME_MIN.md`
- `.ai/context/BOOTSTRAP.md`
- `.ai/context/PROJECT.md`
- `.agentic/CONSTITUTION.md`
- `.agentic/settings.json`

## Startup Handshake (Must Happen, In This Order)
1. Load bootstrap context (list above).
2. If automation is enabled and no run exists yet, create `run_id` by calling `scripts/start-run.sh`.
3. Detect PRD from chat by structure (not only by keyword). If it matches configured PRD signals, ingest into `docs/PRD.md` by editing only `BEGIN_MANAGED` / `END_MANAGED` (preserve header/markers).
4. Ask calibration once (single bundled message when configured), including run mode if `AGENTIC_RUN_MODE` is not set. Default per `.agentic/settings.json` if unanswered.
5. Only then proceed to planning/implementation agents per flow tier.

## Agent Behavior
- Apply Agent Prompt Spec v2 and anti-genericity rubric.
- PRD ingest is mandatory when the user provides a PRD in chat:
  - Write the PRD into `docs/PRD.md` (Hybrid file) by editing only the `BEGIN_MANAGED` / `END_MANAGED` block.
  - Preserve the PRD header and managed markers.
  - Record `PRD ingested` in `.agentic/bus/artifacts/<run_id>/decisions.md`.
- PRD evolution is mandatory when new features are requested:
  - Update PRD incrementally instead of replacing prior validated scope.
  - Write PRD versions in `.agentic/bus/artifacts/<run_id>/prd_versions/` and summarize changes in `.agentic/bus/artifacts/<run_id>/prd_delta.md`.
- If PRD is missing or placeholder-only after ingest, output `BLOCKED` and ask minimal questions.
- Run mode: use `AGENTIC_RUN_MODE` if set; otherwise ask once (after PRD ingest) and default per settings.
- Telemetry + automation: honor `.agentic/settings.json` flags.

## Context Loading Rules
- L0/L1 on-demand only.
- L2 (Architecture) only when planning or implementing.
- L3 artifacts only for the active run.

## Startup Performance
If `settings.startup.profile=fast`:
- Ask only missing calibration inputs, max `settings.startup.max_initial_questions`.
- Do not read `scripts/*`; call them directly when automation is enabled.

## Automation Defaults
- If `settings.automation.run_scripts=true`, run scripts automatically:
  - `scripts/start-run.sh`
  - `scripts/log-event.sh`
  - `scripts/log-question.sh`
  - `scripts/log-metrics.sh`

## Blocking Rule
- If required inputs are missing, stop and request them.

## Tool Environment
- `AGENTIC_TOOL=<tool_name>` must be set in the tool-specific adapter.
