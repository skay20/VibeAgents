---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/CHANGELOG.md
Template-Version: 1.25.0
Last-Generated: 2026-02-06T16:26:32Z
Ownership: Managed
---

# Agentic Changelog

## 0.26.0 - 2026-02-06
- Add mandatory structure-driven PRD intake policy (no keyword dependency) in Constitution and adapters.
- Add incremental PRD evolution/versioning contract for feature additions (`prd_delta` + `prd_versions` artifacts).
- Update intent translator v2 and orchestrator v2 to classify `new_prd|prd_update|not_prd` and route PRD updates before calibration.
- Extend verification with `settings.prd_intake` contract checks and PRD intake/versioning prompt checks.

## 0.25.0 - 2026-02-06
- Add adaptive flow policy (`lean|standard|strict`) with required-agent evidence rules in Constitution.
- Extend orchestrator v2 contract with risk classification, tier dispatch, and missing-evidence blockers.
- Add flow-control settings contract and strict key validation in `scripts/verify.sh`.
- Document adaptive tier routing in workflows and quickstart.

## 0.24.0 - 2026-02-06
- Add dual-track prompt system with shared core (`_CORE.md`) and thin `*.v2.md` prompts for all agents.
- Add `scripts/render-agent-prompt.sh` to resolve `v1|v2|auto` and write compiled prompts into run artifacts.
- Update verification to enforce v1 + core + v2 prompt contracts and prompt resolution settings keys.

## 0.23.0 - 2026-02-05
- Revamp all agent prompt contracts with startup behavior and hard/soft blocker escalation.
- Require output schema references in all agent contracts.
- Add plan, diff_summary, and qa_report bus schemas.

## 0.22.0 - 2026-02-05
- Add `RUNTIME_MIN.md` ultra-short startup context.
- Add single-message startup calibration and startup batch logging policy.
- Update orchestrator and intent translator contracts for reduced startup overhead.

## 0.21.0 - 2026-02-05
- Add fast-start profile settings to reduce startup questions and script reads.

## 0.20.0 - 2026-02-05
- Add universal adapter references to reduce tool adapter duplication.
- Add Node CI workflow with conditional package manager detection.
- Improve preflight reporting for network-restricted installs.

## 0.19.0 - 2026-02-04
- Add preflight scripts and automation flags for auto-run checks.
- Extend QA to require preflight when enabled.

## 0.18.0 - 2026-02-04
- Add automation flags for auto-running telemetry scripts by default.

## 0.17.0 - 2026-02-04
- Make question logging default when enabled and initialize questions_log at run start.

## 0.16.0 - 2026-02-04
- Ensure AgentX mode does not ask "move on" prompts in orchestrator.

## 0.15.0 - 2026-02-04
- Add question logging flags and validation reference in Constitution.

## 0.14.0 - 2026-02-04
- Add question logging (events + questions_log) with settings toggles.
- Enforce agent_id validation in metrics logging.

## 0.13.0 - 2026-02-04
- Replace run modes with AgentX/L/M and update calibration defaults.
- Add event schema and align run start behavior with mode tiers.

## 0.12.0 - 2026-02-04
- Add run-start and event logging scripts with settings-based toggles.
- Add event schema and document run_meta artifact.

## 0.11.0 - 2026-02-04
- Add `.agentic/settings.json` for scalable feature toggles.
- Implement calibration questions flow with autonomous preference and guided default.
- Respect telemetry toggles in metrics logging.

## 0.10.0 - 2026-02-04
- Always ask calibration questions after PRD; default run mode to guided if unanswered.

## 0.9.0 - 2026-02-04
- Add run modes (autonomous/guided) with recorded run state.
- Enable automatic token capture in metrics (env-based) and extend reports.

## 0.8.0 - 2026-02-03
- Add metrics schema, logging scripts, and per-agent metrics requirement.

## 0.7.0 - 2026-02-03
- Add BOOTSTRAP + PROJECT context layers for fast startup.
- Add PRD overlay rules per tool.

## 0.6.0 - 2026-02-03
- Make PRD.md hybrid with managed block; enforce header preservation.

## 0.5.0 - 2026-02-03
- Add headless/CI escalation and bootstrap questions artifact.
- Add bus concurrency policy and locks directory.
- Reduce GEMINI.md imports to on-demand context.

## 0.4.0 - 2026-02-03
- Add PRD→Repo adaptive engine and safe overwrite protocol.
- Enhance verify.sh with contract, placeholder, and adapter checks.
- Add migration entry for 0.4.0.

## 0.3.0 - 2026-02-03
- Rewrite all agent prompts to Spec v2 contracts with explicit outputs and gates.
- Align tool adapters to L0/L1 context references.

## 0.2.0 - 2026-02-03
- Add Agent Prompt Spec v2 and anti-genericity rubric.
- Update AGENTS_CATALOG with explicit inputs/outputs and gates.

## 0.1.0 - 2026-02-03
- Initial set of agent prompts and bus schemas.
