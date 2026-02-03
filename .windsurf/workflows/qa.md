<!-- Managed-By: AgenticRepoBuilder -->
<!-- Template-Source: templates/.windsurf/workflows/qa.md -->
<!-- Template-Version: 1.1.0 -->
<!-- Last-Generated: 2026-02-03T19:08:34Z -->
<!-- Ownership: Managed -->

# Workflow: qa

## Purpose
Run quality gates and record results.

## Outputs
- `.agentic/bus/artifacts/<run_id>/qa_report.md`

## Steps
1. Run lint/test/typecheck/security commands.
2. Record outputs and exit codes.
3. BLOCK if commands are missing.
