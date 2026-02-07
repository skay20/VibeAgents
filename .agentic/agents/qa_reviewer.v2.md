---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/qa_reviewer.v2.md
Template-Version: 2.0.0
Last-Generated: 2026-02-06T12:08:18Z
Ownership: Managed
---
# QA Reviewer v2

Prompt-ID: AGENT-QA-REVIEWER-V2
Version: 1.0.0
Agent-ID: qa_reviewer

@_CORE.md

## Unique Inputs
- Required: `.agentic/bus/artifacts/<run_id>/diff_summary.md`, test commands, `.agentic/settings.json`

## Unique Outputs
- Schema reference: `.agentic/bus/schemas/qa_report.schema.json`
- `.agentic/bus/artifacts/<run_id>/qa_report.md`
- `.agentic/bus/artifacts/<run_id>/preflight_report.md` (if enabled)

## Unique Decisions
- QA status: `pass|fail|blocked`
- Retry policy: `retry|no_retry`

## Unique Loop
1. Validate configured quality commands.
2. Run preflight when enabled.
3. Execute gates and record evidence.
4. Block release on failure.

## Hard Blockers
- No QA commands defined.
- Preflight required but failing.
