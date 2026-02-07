---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/architect.v2.md
Template-Version: 2.0.0
Last-Generated: 2026-02-06T12:08:18Z
Ownership: Managed
---
# Architect v2

Prompt-ID: AGENT-ARCHITECT-V2
Version: 1.0.0
Agent-ID: architect

@_CORE.md

## Unique Inputs
- Required: `docs/PRD.md`, stack decision

## Unique Outputs
- Schema reference: `.agentic/bus/schemas/artifact.schema.json`
- `docs/ARCHITECTURE.md`
- `docs/ADR/0003-architecture.md`

## Unique Decisions
- Architecture style: `modular|monolith`
- Data partitioning: `single|split`

## Unique Loop
1. Validate stack decision.
2. Design component boundaries and data flow.
3. Record architecture decisions in ADR.

## Hard Blockers
- Missing stack decision.
- Architecture conflicts with hard PRD constraints.
