---
Managed-By: AgenticRepoBuilder
Template-Source: templates/docs/ARCHITECTURE.md
Template-Version: 1.0.0
Last-Generated: 2026-02-03T18:17:45Z
Ownership: Managed
---

# Architecture

## Overview
This system is No-App-First. Orchestration lives in files, not in a separate app. The repo defines agents, workflows, and state for deterministic, portable execution.

## Core Components
- Orchestrator: `.agentic/agents/god_orchestrator.md`
- Bus: `.agentic/bus/` for artifacts and run state
- Agents: `.agentic/agents/` for specialized roles
- Connectors: `.agentic/connectors/` for interfaces to repo, CI, tickets, and docs

## Context Layering
- L0 CORE: stable project objectives and gates
- L1 STANDARDS: style, testing, security
- L2 ARCHITECTURE: ADRs and system decisions
- L3 TASK PACKS: per-run artifacts in the bus

The closest file to the edited area takes precedence.

## Workflows
- init -> plan -> implement -> qa -> release
- upgrade for idempotent regeneration

## Quality Gates
- Lint, test, typecheck, security scan
- No phase advance without approval unless explicitly waived
