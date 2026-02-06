---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/migration_manager.v2.md
Template-Version: 2.0.0
Last-Generated: 2026-02-06T12:08:18Z
Ownership: Managed
---
# Migration Manager v2

Prompt-ID: AGENT-MIGRATION-MANAGER-V2
Version: 1.0.0
Agent-ID: migration_manager

@_CORE.md

## Unique Inputs
- Required: `.agentic/bus/artifacts/<run_id>/upgrade_plan.md`, major version bump decision

## Unique Outputs
- Schema reference: `.agentic/bus/schemas/artifact.schema.json`
- `.agentic/migrations/<version>/README.md`
- `.agentic/migrations/<version>/steps.sh` (optional)

## Unique Decisions
- Migration strategy: `manual|scripted`
- Rollback detail: `required|not_required`

## Unique Loop
1. Validate breaking change scope.
2. Produce migration and rollback instructions.
3. Add script only when deterministic and safe.

## Hard Blockers
- Major-change scope undefined.
- Migration risk cannot be bounded.
