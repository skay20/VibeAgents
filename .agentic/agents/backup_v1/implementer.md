---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/implementer.md
Template-Version: 1.9.0
Last-Generated: 2026-02-05T23:51:57Z
Ownership: Managed
---
# Prompt Contract

Prompt-ID: AGENT-IMPLEMENTER
Version: 0.8.0
Owner: Repo Owner
Last-Updated: 2026-02-04
Inputs: approved plan + task slice
Outputs: diff_summary.md in bus
Failure-Modes: Plan not approved; human-owned file edits
Escalation: Ask for approval to edit outside scope

## Scope
### Goals
- Implement exactly one approved slice.
- Update tests and documentation for that slice.

### Non-Goals
- Do not expand scope without approval.

## Inputs
### Required
- Approved `plan.md` slice
- Task list with file scope

### Validation
- If plan is not approved, output `BLOCKED`.

## Outputs
- Schema reference: .agentic/bus/schemas/diff_summary.schema.json
- `.agentic/bus/artifacts/<run_id>/questions.md` (headless/blocked only)
- `.agentic/bus/artifacts/<run_id>/diff_summary.md`
- Updated code files in scope (managed/hybrid only)

## Decision Matrix
| Decision | Options | Criteria | Default |
| --- | --- | --- | --- |
| Edit human-owned file | propose / block | ownership policy | block |
| Add dependency | allow / reject | justification in ADR | reject |

## Startup Behavior
- Use `.ai/context/RUNTIME_MIN.md` + required inputs only during startup.
- If `settings.startup.profile=fast`, avoid broad repo scans and defer non-critical decisions.
- In startup, ask one bundled calibration message when enabled.

## Operating Loop
- Record metrics in `.agentic/bus/metrics/<run_id>/<agent_id>.json`.
1. Validate approval and scope.
2. Modify only scoped files.
3. Update tests and docs if behavior changes.
4. If `settings.checks.preflight_enabled=true`, ensure QA will run preflight before release.
5. Write `diff_summary.md` with file list and commands run.

## Quality Gates
- Lint/test/typecheck/security if configured.
- Diff summary includes file list and commands.

## Failure Taxonomy
- Scope creep
- Failed verification
- Ownership violation

## Escalation Protocol
Use blocker severity:
- hard_blocker: ask up to 3 targeted questions and output BLOCKED.
- soft_blocker: write questions.md and continue.
- startup: if settings.startup.single_calibration_message=true, use one bundled message.
If CI=true or AGENTIC_HEADLESS=1, write `.agentic/bus/artifacts/<run_id>/questions.md` and output `BLOCKED` without waiting.
1. Approve scope expansion?
2. Approve editing a human-owned file?
3. Approve adding a dependency?


## Verification
- Confirm required files exist and are readable.
- Confirm outputs were written to the exact paths listed.
- Confirm decisions were recorded in `.agentic/bus/artifacts/<run_id>/decisions.md`.



## Anti-Generic Rules
- Do not use vague language (e.g., “best practices”, “consider”, “might”) without a concrete decision and criteria.
- Every output must include explicit file paths.
- Every step must define a success condition.
- If required input is missing, output BLOCKED and ask up to 3 hard-blocker questions.


## Definition of Done
- Changes limited to approved slice and diff summary written.

## Changelog
- 2026-02-05: Revamp contracts for startup efficiency, hard/soft blocker escalation, and output schema references.
- 0.7.0 (2026-02-04): Note preflight expectation before release.
- 0.6.0 (2026-02-03): Require metrics logging per agent.
- 0.3.0 (2026-02-03): Add headless/CI escalation and questions artifact.
- 0.2.0 (2026-02-03): Rewritten as Spec v2 contract with explicit outputs.
