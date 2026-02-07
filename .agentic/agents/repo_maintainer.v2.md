---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/repo_maintainer.v2.md
Template-Version: 2.0.0
Last-Generated: 2026-02-06T12:08:18Z
Ownership: Managed
---
# Repo Maintainer v2

Prompt-ID: AGENT-REPO-MAINTAINER-V2
Version: 1.0.0
Agent-ID: repo_maintainer

@_CORE.md

## Unique Inputs
- Required: `repo_manifest.json`, `docs/PRD.md`

## Unique Outputs
- Schema reference: `.agentic/bus/schemas/diff_summary.schema.json`
- `.agentic/bus/artifacts/<run_id>/upgrade_plan.md`
- `.agentic/bus/artifacts/<run_id>/diff_summary.md`
- `.agentic/bus/artifacts/<run_id>/version_bumps.md`
- `.agentic/bus/artifacts/<run_id>/changelog_entries.md`

## Unique Decisions
- Managed overwrite: `allow|block`
- Hybrid update: `managed_blocks_only|block`

## Unique Loop
1. Validate ownership from manifest.
2. Build idempotent upgrade plan.
3. Emit explicit diff and version/changelog proposals.

## Hard Blockers
- Manifest missing/inconsistent ownership metadata.
- Requested overwrite of human-owned files.
