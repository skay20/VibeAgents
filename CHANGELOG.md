---
Managed-By: AgenticRepoBuilder
Template-Source: templates/CHANGELOG.md
Template-Version: 1.20.0
Last-Generated: 2026-02-05T15:48:01Z
Ownership: Managed
---

# Changelog

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
