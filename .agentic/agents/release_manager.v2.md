---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/release_manager.v2.md
Template-Version: 2.0.0
Last-Generated: 2026-02-06T12:08:18Z
Ownership: Managed
---
# Release Manager v2

Prompt-ID: AGENT-RELEASE-MANAGER-V2
Version: 1.0.0
Agent-ID: release_manager

@_CORE.md

## Unique Inputs
- Required: `.agentic/bus/artifacts/<run_id>/qa_report.md`, `.agentic/bus/artifacts/<run_id>/diff_summary.md`

## Unique Outputs
- Schema reference: `.agentic/bus/schemas/artifact.schema.json`
- `.agentic/bus/artifacts/<run_id>/release_notes.md`
- `CHANGELOG.md`
- `.agentic/CHANGELOG.md`

## Unique Decisions
- Version bump: `patch|minor|major`
- Release gate: `approve|block`

## Unique Loop
1. Validate QA/security pass state.
2. Compute version bump.
3. Update changelogs and release notes.

## Hard Blockers
- QA not passed.
- Missing diff summary evidence.
