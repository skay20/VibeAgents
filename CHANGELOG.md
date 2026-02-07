---
Managed-By: AgenticRepoBuilder
Template-Source: templates/CHANGELOG.md
Template-Version: 1.27.0
Last-Generated: 2026-02-06T16:43:23Z
Ownership: Managed
---

# Changelog

## 0.1.31 - 2026-02-07
- Remove A/B benchmarking feature from runtime tooling.
- Delete `scripts/metrics_compare.py` and `scripts/metrics_summarize.py`.
- Remove benchmark schema/docs references and cleanup benchmark sample artifacts/metrics folders.

## 0.1.32 - 2026-02-07
- Add project-docs auto-generation: `<project_root>/README.md` managed block and `<project_root>/RUNBOOK.md` enforcement for generated projects.
- Add scripts `scripts/ensure-project-readme.sh` and `scripts/ensure-project-readme.py`.
- Extend settings/docs contract and enforcement to require README/RUNBOOK when a generated project is detected.

## 0.1.30 - 2026-02-07
- Add official run entrypoint `scripts/orchestrator-first.sh` and dispatch resolver `scripts/resolve-dispatch.sh`.
- Enforce complete adaptive flow artifacts (`orchestrator_entrypoint`, `tier_decision`, `dispatch_signals`, `dispatch_resolution`, `planned_agents`) before release gates.
- Extend run-state contract with `selected_tier`, `planned_agents`, `executed_agents`, and `flow_status`.
- Harden `scripts/enforce-flow.sh` with deterministic missing-agent checks, catalog coverage checks, timestamp consistency checks, and rollout enforcement mode.
- Improve telemetry quality by logging structured question events and avoiding duplicate calibration records.

## 0.1.29 - 2026-02-06
- Add hybrid agent-dispatch settings to enforce full catalog evaluation with conditional execution.
- Make `architect`, `qa_reviewer`, and `docs_writer` required baseline coverage for implementation runs.
- Add dispatch governance artifacts (`dispatch_signals.md`, `dispatch_resolution.md`) to runtime flow evidence.
- Harden `scripts/enforce-flow.sh` and `scripts/verify.sh` to block runs that omit catalog rows or required evidence.
- Update quickstart and workflows for adaptive dispatch behavior without unnecessary overhead.

## 0.1.28 - 2026-02-06
- Add hard runtime flow checker `scripts/enforce-flow.sh` to block release when required tier agents are missing evidence.
- Add project-meta compatibility checker `scripts/check-project-meta.sh` to detect outdated side-project templates/contracts before implementation.
- Add docs target contract (`settings.docs.project_runbook_path`) and project-meta compatibility settings in `.agentic/settings.json`.
- Harden orchestrator/release/docs contracts and verification so flow governance is enforced at runtime and not only by prompt intent.

## 0.1.27 - 2026-02-06
- Add base PRD-intake contract to detect PRD by structure (without requiring `new PRD` keyword).
- Add incremental PRD evolution/versioning policy for follow-up feature requests.
- Update startup contracts (`UNIVERSAL`, `RUNTIME_MIN`, `AGENTS`) to enforce PRD ingest/update before calibration.
- Extend `scripts/verify.sh` with `settings.prd_intake` and intake/versioning checks.

## 0.1.26 - 2026-02-06
- Add adaptive flow-control settings for risk-tiered dispatch (`lean|standard|strict`) in `.agentic/settings.json`.
- Add adaptive flow policy and required-agent evidence rules in `.agentic/CONSTITUTION.md`.
- Update orchestrator v2 and verification checks to enforce tier selection and evidence gating.
- Update workflow and quickstart docs for the adaptive flow model.

## 0.1.25 - 2026-02-06
- Add `scripts/metrics_compare.py` for A/B run comparison (`feature OFF` vs `feature ON`).
- Add canonical benchmark artifacts under `.agentic/bus/artifacts/benchmarks/<benchmark_id>/`.
- Update `docs/QUICKSTART.md` with one-command A/B comparison workflow.

## 0.1.24 - 2026-02-06
- Add `_CORE.md` plus `*.v2.md` dual-track prompt set for all 14 agents.
- Add `scripts/render-agent-prompt.sh` for deterministic prompt resolution (`v1`, `v2`, `auto`) and compiled prompt artifacts.
- Extend `scripts/verify.sh` and settings validation for dual-track prompt contracts and pilot controls.

## 0.1.23 - 2026-02-05
- Revamp all agent prompt contracts with startup behavior and hard/soft blocker escalation.
- Add output schema references in all agent outputs.
- Add bus schemas for plan, diff summary, and QA report.

## 0.1.22 - 2026-02-05
- Add runtime-min startup context and single-message calibration defaults.
- Add startup batch logging policy to reduce first-response overhead.
- Register `docs/QUICKSTART.md` as Human-owned in repo manifest.

## 0.1.21 - 2026-02-05
- Add fast-start profile settings to reduce startup questions and script reads.

## 0.1.20 - 2026-02-05
- Add universal adapter references to reduce tool adapter duplication.
- Add Node CI workflow with conditional package manager detection.
- Improve preflight reporting for network-restricted installs.

## 0.1.19 - 2026-02-04
- Add preflight scripts and automation flags for auto-run checks.

## 0.1.18 - 2026-02-04
- Add automation flags to auto-run telemetry scripts.

## 0.1.17 - 2026-02-04
- Make question logging default when enabled and initialize questions_log at run start.

## 0.1.16 - 2026-02-04
- Ensure AgentX mode does not ask to proceed between phases.

## 0.1.15 - 2026-02-04
- Add question logging flags and validation references.

## 0.1.14 - 2026-02-04
- Add question logging and enforce agent_id validation in metrics.

## 0.1.13 - 2026-02-04
- Add AgentX/L/M run modes and update calibration defaults.

## 0.1.12 - 2026-02-04
- Add run-start and event logging scripts with settings-based toggles.

## 0.1.11 - 2026-02-04
- Add `.agentic/settings.json` and telemetry/run-mode toggles.

## 0.1.10 - 2026-02-04
- Add calibration questions after PRD and default run mode behavior.

## 0.1.9 - 2026-02-04
- Add run modes with recorded run state and adapter alignment.
- Enable automatic token capture in metrics and richer reports.

## 0.1.8 - 2026-02-03
- Add agent metrics logging layer and reporting.

## 0.1.7 - 2026-02-03
- Add BOOTSTRAP + PROJECT context layers and PRD overlay rules.

## 0.1.6 - 2026-02-03
- Make PRD.md hybrid with managed block; enforce header preservation.

## 0.1.5 - 2026-02-03
- Add headless/CI bootstrap safeguards and bus concurrency policy.
- Reduce GEMINI.md imports to on-demand context.

## 0.1.4 - 2026-02-03
- Strengthen L0/L1 context files with explicit gates, outputs, and blocking rules.

## 0.1.3 - 2026-02-03
- Add PRD→Repo adaptive engine and safe overwrite protocol.
- Enhance verification with prompt contract and adapter checks.

## 0.1.2 - 2026-02-03
- Rewrite agent prompts to Spec v2 contracts.
- Align adapters and workflows to L0/L1 contexts.

## 0.1.1 - 2026-02-03
- Add Agent Prompt Spec v2 and anti-genericity rubric.
- Update agents catalog with explicit contract requirements.

## 0.1.0 - 2026-02-03
- Initial scaffold for No-App-First multi-agent repo builder.
