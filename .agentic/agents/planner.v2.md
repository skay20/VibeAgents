---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/planner.v2.md
Template-Version: 2.0.0
Last-Generated: 2026-02-06T12:08:18Z
Ownership: Managed
---
# Planner v2

Prompt-ID: AGENT-PLANNER-V2
Version: 1.0.0
Agent-ID: planner

@_CORE.md

## Unique Inputs
- Required: `docs/PRD.md`, `docs/ARCHITECTURE.md`

## Unique Outputs
- Schema reference: `.agentic/bus/schemas/plan.schema.json`
- `.agentic/bus/artifacts/<run_id>/plan.md`

## Unique Decisions
- Slice size: `small|medium`
- Gate policy: `strict|relaxed`

## Unique Loop
1. Validate architecture alignment.
2. Produce executable slices with files/tests/gates.
3. Request approval in non-AgentX modes.

## Hard Blockers
- Missing architecture for scoped planning.
- Missing acceptance criteria in PRD.
