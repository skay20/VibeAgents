---
Managed-By: AgenticRepoBuilder
Template-Source: templates/docs/ADR/0001-initial.md
Template-Version: 1.0.0
Last-Generated: 2026-02-03T18:17:45Z
Ownership: Managed
---

# ADR 0001: No-App-First Multi-Agent Repo Builder

## Status
Accepted

## Date
2026-02-03

## Context
We need a deterministic, versionable, portable system to convert research and PRD inputs into a plug-and-play repo. Tooling must work across multiple IDEs and CLIs without relying on a separate app.

## Decision
Adopt a No-App-First architecture with a God Orchestrator, file-based bus, and modular agent prompts stored in the repository.

## Consequences
- All orchestration and rules live in the repo.
- Gates enforce human approval between phases unless explicitly waived.
- Logs and run packs provide auditability.
