---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/_CORE.md
Template-Version: 2.0.0
Last-Generated: 2026-02-06T12:08:18Z
Ownership: Managed
---
# Agent Core Contract v2

Prompt-ID: AGENT-CORE-CONTRACT
Version: 2.0.0
Owner: Repo Owner
Last-Updated: 2026-02-06

## Startup Policy
- Load minimal startup context first: `.ai/context/RUNTIME_MIN.md`, `.ai/context/PROJECT.md`, `.agentic/settings.json`.
- In fast profile, avoid broad repository scans and script source reads.
- Use one bundled startup calibration message when `settings.startup.single_calibration_message=true`.
- Use hybrid dispatch: evaluate full catalog, then execute only required/triggered agents.
- Start runs with `settings.startup.official_entrypoint` and resolve dispatch with `scripts/resolve-dispatch.sh`.

## Escalation Policy
- `hard_blocker`: ask up to 3 targeted questions and output `BLOCKED`.
- `soft_blocker`: write `.agentic/bus/artifacts/<run_id>/questions.md` and continue.
- `startup`: prefer bundled calibration and defaults from settings.
- In CI/headless (`CI=true` or `AGENTIC_HEADLESS=1`), do not wait for answers; write questions artifact and stop/continue according to blocker type.

## Verification Policy
- Always confirm required inputs exist.
- Always write declared outputs to exact paths.
- Always write metrics to `.agentic/bus/metrics/<run_id>/<agent_id>.json`.
- Always record relevant decisions in `.agentic/bus/artifacts/<run_id>/decisions.md`.
- Always keep catalog evaluation evidence in `.agentic/bus/artifacts/<run_id>/dispatch_resolution.md`.

## Anti-Generic Policy
- No vague language without decision and criteria.
- Every workflow step must include a success condition.
- Every output section must include explicit file paths and schema reference.

## Telemetry and Logging
- Respect `.agentic/settings.json` telemetry and automation toggles.
- In startup, use batch logging when `settings.startup.batch_startup_logging=true`.
- After startup, use detailed per-question/per-agent logs.

## Ownership Guardrails
- Managed files may be regenerated with traceability.
- Hybrid files may only modify managed blocks.
- Human-owned files are never overwritten automatically.

## Definition of Done Baseline
- Inputs validated.
- Outputs produced at declared paths.
- Metrics and decisions recorded.
- Escalation handled by blocker severity.
