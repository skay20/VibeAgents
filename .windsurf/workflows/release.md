<!-- Managed-By: AgenticRepoBuilder -->
<!-- Template-Source: templates/.windsurf/workflows/release.md -->
<!-- Template-Version: 1.1.0 -->
<!-- Last-Generated: 2026-02-03T19:08:34Z -->
<!-- Ownership: Managed -->

# Workflow: release

## Purpose
Prepare release notes and update changelogs.

## Outputs
- `.agentic/bus/artifacts/<run_id>/release_notes.md`
- `CHANGELOG.md`
- `.agentic/CHANGELOG.md`

## Steps
1. Require QA pass.
2. Apply version bump.
3. Write release notes.
