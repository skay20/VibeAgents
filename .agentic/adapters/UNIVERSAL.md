---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/adapters/UNIVERSAL.md
Template-Version: 1.3.0
Last-Generated: 2026-02-06T17:20:00Z
Ownership: Managed
---

# Universal Adapter Rules

## Bootstrap Context (Required)
- `.ai/context/RUNTIME_MIN.md`
- `.ai/context/BOOTSTRAP.md`
- `.ai/context/PROJECT.md`
- `.agentic/CONSTITUTION.md`
- `.agentic/settings.json`

## Agent Behavior
- Apply Agent Prompt Spec v2 and anti-genericity rubric.
- PRD ingest is mandatory when the user provides a PRD in chat:
  - Write the PRD into `docs/PRD.md` (Hybrid file) by editing only the `BEGIN_MANAGED` / `END_MANAGED` block.
  - Preserve the PRD header and managed markers.
  - Record `PRD ingested` in `.agentic/bus/artifacts/<run_id>/decisions.md`.
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

## Startup Handshake (Order)
1. Load bootstrap context (RUNTIME_MIN + BOOTSTRAP + PROJECT + CONSTITUTION + settings).
2. If automation is enabled and no run exists yet, call `scripts/start-run.sh` to create `run_id`.
3. Ingest PRD from chat into `docs/PRD.md` managed block.
4. Ask calibration (single bundled message when configured), including run mode if not set.
5. Only then proceed to planning/implementation agents per flow tier.

## Blocking Rule
- If required inputs are missing, stop and request them.

## Tool Environment
- `AGENTIC_TOOL=<tool_name>` must be set in the tool-specific adapter.
