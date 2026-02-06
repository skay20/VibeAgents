---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/AGENTS_CATALOG.md
Template-Version: 1.6.0
Last-Generated: 2026-02-04T17:55:11Z
Ownership: Managed
---

# Agents Catalog (Spec v2)

Each agent follows Agent Prompt Spec v2 and must BLOCK if required inputs are missing.
Run mode is selected at the start of a run (`AgentX`, `AgentL`, `AgentM`); if unanswered, default to `AgentL`.
All agents now include startup behavior and escalation severity:
- hard_blocker: ask up to 3 targeted questions and BLOCK.
- soft_blocker: record in questions artifact and continue.
- startup: one bundled calibration prompt when enabled.
All agents must include an explicit `Schema reference` under outputs.

## God Orchestrator
- Purpose: system-wide orchestration, gates, and run state
- Inputs (required): `docs/PRD.md`, `repo_manifest.json`, `TREE.md`
- Outputs:
  - `.agentic/bus/artifacts/<run_id>/plan.md`
  - `.agentic/bus/artifacts/<run_id>/decisions.md`
  - `.agentic/bus/artifacts/<run_id>/diff_summary.md`
  - `.agentic/bus/artifacts/<run_id>/qa_report.md`
  - `.agentic/bus/artifacts/<run_id>/release_notes.md`
  - `.agentic/bus/state/<run_id>.json`
- Gates: phase approval and DoD checks

## Intent Translator
- Purpose: convert idea/PRD into precise requirements
- Inputs (required): `docs/PRD.md`
- Outputs:
  - `.agentic/bus/artifacts/<run_id>/intent.md`
  - `.agentic/bus/artifacts/<run_id>/calibration_questions.md`
- Gates: blocks if PRD missing or ambiguous

## Context Curator
- Purpose: curate layered context without bloat
- Inputs (required): `docs/PRD.md`, `.ai/context/*`
- Outputs: `.agentic/bus/artifacts/<run_id>/context_pack.md`
- Gates: blocks if context sources missing

## Stack Advisor
- Purpose: propose stacks with trade-offs and recommendation
- Inputs (required): `docs/PRD.md`, constraints
- Outputs:
  - `.agentic/bus/artifacts/<run_id>/stack_options.md`
  - `docs/ADR/0002-stack-selection.md`
- Gates: blocks without PRD or constraints

## Architect
- Purpose: system design and ADRs
- Inputs (required): `docs/PRD.md`, stack decision
- Outputs:
  - `docs/ARCHITECTURE.md`
  - `docs/ADR/0003-architecture.md`
- Gates: blocks if stack decision missing

## Planner
- Purpose: create phased plan with slices and risks
- Inputs (required): `docs/PRD.md`, `docs/ARCHITECTURE.md`
- Outputs: `.agentic/bus/artifacts/<run_id>/plan.md`
- Gates: requires human approval before implementation

## Implementer
- Purpose: implement one approved slice
- Inputs (required): approved plan + tasks
- Outputs: diff + `.agentic/bus/artifacts/<run_id>/diff_summary.md`
- Gates: blocks if plan not approved

## QA Reviewer
- Purpose: run and report quality gates
- Inputs (required): diff + test commands
- Outputs: `.agentic/bus/artifacts/<run_id>/qa_report.md`
- Gates: blocks if commands undefined
 - Preflight: writes `.agentic/bus/artifacts/<run_id>/preflight_report.md` when enabled

## Security Reviewer
- Purpose: security review and secret checks
- Inputs (required): diff + security policy
- Outputs: `.agentic/bus/artifacts/<run_id>/security_report.md`
- Gates: blocks if security checks undefined

## Docs Writer
- Purpose: update docs to match changes
- Inputs (required): diff + plan
- Outputs: updated `docs/*` + `.agentic/bus/artifacts/<run_id>/docs_report.md`
- Gates: blocks if plan missing

## Release Manager
- Purpose: version bump and release notes
- Inputs (required): qa report + diff summary
- Outputs:
  - `CHANGELOG.md`
  - `.agentic/CHANGELOG.md`
  - `.agentic/bus/artifacts/<run_id>/release_notes.md`
- Gates: blocks if QA not passed

## Repo Maintainer
- Purpose: idempotent upgrades
- Inputs (required): `repo_manifest.json`, `docs/PRD.md`
- Outputs:
  - `.agentic/bus/artifacts/<run_id>/upgrade_plan.md`
  - `.agentic/bus/artifacts/<run_id>/diff_summary.md`
- Gates: blocks if ownership conflicts detected

## Template Librarian
- Purpose: maintain `.agentic/templates/` canonical sources
- Inputs (required): templates + manifest
- Outputs: updated templates + `repo_manifest.json`
- Gates: blocks if template headers inconsistent

## Migration Manager
- Purpose: create migrations for breaking changes
- Inputs (required): change plan + version bump
- Outputs: `.agentic/migrations/<version>/README.md`
- Gates: blocks if breaking changes not documented
