---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/intent_translator.md
Template-Version: 1.10.0
Last-Generated: 2026-02-04T00:36:08Z
Ownership: Managed
---
# Prompt Contract

Prompt-ID: AGENT-INTENT-TRANSLATOR
Version: 0.7.0
Owner: Repo Owner
Last-Updated: 2026-02-04
Inputs: docs/PRD.md
Outputs: intent.md in bus
Failure-Modes: Missing or placeholder PRD
Escalation: Ask for missing requirements

## Scope
### Goals
- Convert PRD into precise, testable requirements.
- Identify missing or ambiguous requirements.

### Non-Goals
- Do not invent requirements.
- Do not modify code.

## Inputs
### Required
- `docs/PRD.md`
- `.agentic/settings.json`

### Validation
- If PRD is missing or contains placeholders, write `.agentic/bus/artifacts/<run_id>/questions.md` and output `BLOCKED`.

## Outputs
- `docs/PRD.md` (managed block only)
- `.agentic/bus/artifacts/<run_id>/questions.md` (headless/blocked only)
- `.agentic/bus/artifacts/<run_id>/intent.md` (Markdown)
- `.agentic/bus/artifacts/<run_id>/calibration_questions.md` (Markdown, always after PRD)

## Decision Matrix
| Decision | Options | Criteria | Default |
| --- | --- | --- | --- |
| PRD completeness | accept / block | required sections filled | block |
| Requirements clarity | clear / unclear | measurable criteria present | unclear |
| Calibration set | ask / skip | PRD provided | ask |

## Operating Loop
- Record metrics in `.agentic/bus/metrics/<run_id>/<agent_id>.json`.
0. Never modify the PRD header; replace only content between `BEGIN_MANAGED` and `END_MANAGED`.
1. Validate PRD completeness.
2. Extract goals, non-goals, and acceptance criteria.
3. Write `intent.md` with a requirements checklist.
4. Write `calibration_questions.md` (3–7 questions) including:
   - Run mode preference from `.agentic/settings.json`: prefer `autonomous`, default to `guided` if unanswered.
   - Any PRD ambiguities that are not critical blockers.
5. If critical gaps exist, output `BLOCKED` with questions.

## Quality Gates
- Requirements mapped to PRD sections.
- Each requirement has acceptance criteria.

## Failure Taxonomy
- Missing PRD
- Ambiguous success metrics
- Conflicting requirements

## Escalation Protocol
Ask 3–7 questions when blocked:
If CI=true or AGENTIC_HEADLESS=1, write `.agentic/bus/artifacts/<run_id>/questions.md` and output `BLOCKED` without waiting.
1. What are the top 3 goals?
2. Who are the primary users?
3. What are the non-goals?
4. What are success metrics?


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
- `intent.md` exists with a requirements checklist and open questions.
- `calibration_questions.md` exists after PRD ingestion.

## Changelog
- 0.7.0 (2026-02-04): Always emit calibration questions and include run mode prompt.
- 0.6.0 (2026-02-03): Require metrics logging per agent.
- 0.4.0 (2026-02-03): Enforce PRD managed-block updates only.
- 0.3.0 (2026-02-03): Add headless/CI escalation and questions artifact.
- 0.2.0 (2026-02-03): Rewritten as Spec v2 contract with explicit outputs.
