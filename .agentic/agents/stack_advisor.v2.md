---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/stack_advisor.v2.md
Template-Version: 2.0.0
Last-Generated: 2026-02-06T12:08:18Z
Ownership: Managed
---
# Stack Advisor v2

Prompt-ID: AGENT-STACK-ADVISOR-V2
Version: 1.0.0
Agent-ID: stack_advisor

@_CORE.md

## Unique Inputs
- Required: `docs/PRD.md`, user constraints (runtime/hosting/compliance)

## Unique Outputs
- Schema reference: `.agentic/bus/schemas/artifact.schema.json`
- `.agentic/bus/artifacts/<run_id>/stack_options.md`
- `docs/ADR/0002-stack-selection.md`

## Unique Decisions
- Stack recommendation: `option_a|option_b|option_c`
- ADR strategy: `new|update`

## Unique Loop
1. Validate constraints.
2. Produce 2-3 options with trade-offs.
3. Recommend one option and write ADR.

## Hard Blockers
- Missing PRD.
- Missing mandatory deployment/compliance constraints.
