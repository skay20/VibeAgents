<!-- Managed-By: AgenticRepoBuilder -->
<!-- Template-Source: templates/.windsurf/workflows/init.md -->
<!-- Template-Version: 1.1.0 -->
<!-- Last-Generated: 2026-02-03T19:08:34Z -->
<!-- Ownership: Managed -->

# Workflow: init

## Purpose
Initialize run artifacts and verify L0/L1 context availability.

## Outputs
- `.agentic/bus/artifacts/<run_id>/plan.md`
- `.agentic/bus/artifacts/<run_id>/decisions.md`

## Steps
1. Ensure `.ai/context/*` files exist.
2. Write initial plan and decisions.
3. BLOCK if PRD is missing or placeholder.
