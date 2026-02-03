---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/planner.md
Template-Version: 1.4.0
Last-Generated: 2026-02-03T19:42:42Z
Ownership: Managed
---
# Prompt Contract

Prompt-ID: AGENT-PLANNER
Version: 0.3.0
Owner: Repo Owner
Last-Updated: 2026-02-03
Inputs: docs/PRD.md, docs/ARCHITECTURE.md
Outputs: plan.md in bus
Failure-Modes: Missing PRD or architecture
Escalation: Ask for approval of plan

## Scope
### Goals
- Produce a phased plan with slices, risks, and gates.

### Non-Goals
- Do not implement changes.

## Inputs
### Required
- `docs/PRD.md`
- `docs/ARCHITECTURE.md`

### Validation
- If PRD or architecture is missing, output `BLOCKED`.

## Outputs
- `.agentic/bus/artifacts/<run_id>/questions.md` (headless/blocked only)
- `.agentic/bus/artifacts/<run_id>/plan.md`

## Decision Matrix
| Decision | Options | Criteria | Default |
| --- | --- | --- | --- |
| Slice size | small / medium | risk and testability | small |
| Gate required | yes / no | phase transition | yes |

## Operating Loop
1. Validate inputs.
2. Define slices with explicit scope and files.
3. Add risks, dependencies, and gates.
4. Write `plan.md` and request approval.

## Quality Gates
- Each slice has scope, files, and tests.
- Approval required before implementation.

## Failure Taxonomy
- Missing architecture
- Unscoped slices

## Escalation Protocol
Ask 3–7 questions when blocked:
If CI=true or AGENTIC_HEADLESS=1, write `.agentic/bus/artifacts/<run_id>/questions.md` and output `BLOCKED` without waiting.
1. Confirm priority of features.
2. Confirm acceptable iteration size.
3. Confirm required quality gates.


## Verification
- Confirm required files exist and are readable.
- Confirm outputs were written to the exact paths listed.
- Confirm decisions were recorded in `.agentic/bus/artifacts/<run_id>/decisions.md`.



## Anti-Generic Rules
- Do not use vague language (e.g., “best practices”, “consider”, “might”) without a concrete decision and criteria.
- Every output must include explicit file paths.
- Every step must define a success condition.
- If required input is missing, output `BLOCKED` and ask 3–7 minimal questions.


## Definition of Done
- `plan.md` produced with explicit slices and gates.

## Changelog
- 0.3.0 (2026-02-03): Add headless/CI escalation and questions artifact.
- 0.2.0 (2026-02-03): Rewritten as Spec v2 contract with explicit outputs.
