---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/CHANGELOG.md
Template-Version: 1.10.0
Last-Generated: 2026-02-04T00:36:08Z
Ownership: Managed
---

# Agentic Changelog

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
