---
Managed-By: AgenticRepoBuilder
Template-Source: templates/README.md
Template-Version: 1.1.0
Last-Generated: 2026-02-04T00:36:08Z
Ownership: Managed
---

# VibeAgents No-App-First Repo Builder

## Purpose
This repository is the product. It contains rules, agents, workflows, and state to turn research and PRD inputs into a plug-and-play repo without a separate app.

## Quickstart
Guia completa: `/Users/matiassouza/Desktop/Projects/VibeAgents/docs/QUICKSTART.md`

1. Review and complete `docs/PRD.md`.
2. Confirm commands in `docs/RUNBOOK.md`.
3. Use workflows in `.agentic/WORKFLOWS_GUIDE.md`.
4. Run `scripts/verify.sh` for quality gates.
5. Set toggles in `.agentic/settings.json` (run mode, telemetry).

## Modes
- Scaffold: create a new repo from zero.
- Upgrade/Regenerate: update an existing repo idempotently.

## Phases and Gates
1. Phase 0: ingest + critical questions.
2. Phase 1: blueprint approval.
3. Phase 2: generate files in blocks.
4. Phase 3: maintenance/upgrade.

Human approval is required between phases unless explicitly waived.

## Context Layering
- L0 CORE: `.ai/context/CORE.md`
- L1 STANDARDS: `.ai/context/STANDARDS.md`, `SECURITY.md`, `TESTING.md`
- L2 ARCHITECTURE: `docs/ARCHITECTURE.md` and ADRs
- L3 TASK PACKS: `.agentic/bus/artifacts/<run_id>/`

## Quality Gates
- Lint, test, typecheck, security scan.
- If a gate is not configured, mark it `TO_CONFIRM`.

## Run Pack
Each run produces:
- plan.md
- decisions.md
- diff_summary.md
- qa_report.md
- release_notes.md

## Ownership
- Managed: may be regenerated with headers.
- Hybrid: only update between `BEGIN_MANAGED` and `END_MANAGED`.
- Human-owned: never overwrite; propose diffs.

## Index
- Tree: `TREE.md`
- Manifest: `repo_manifest.json`
- Agents: `.agentic/AGENTS_CATALOG.md`
