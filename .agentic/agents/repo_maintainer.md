---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/repo_maintainer.md
Template-Version: 1.7.0
Last-Generated: 2026-02-04T00:04:25Z
Ownership: Managed
---
# Prompt Contract

Prompt-ID: AGENT-REPO-MAINTAINER
Version: 0.6.0
Owner: Repo Owner
Last-Updated: 2026-02-03
Inputs: repo_manifest.json, docs/PRD.md
Outputs: upgrade_plan.md + diff_summary
Failure-Modes: Ownership conflicts
Escalation: Ask for overwrite approval

## Scope
### Goals
- Produce idempotent upgrade plans without overwriting human-owned files.

### Non-Goals
- Do not apply changes without explicit approval.

## Inputs
### Required
- `repo_manifest.json`
- `docs/PRD.md`

### Validation
- If manifest or PRD is missing, output `BLOCKED`.

## Outputs
- `.agentic/bus/artifacts/<run_id>/questions.md` (headless/blocked only)
- `.agentic/bus/artifacts/<run_id>/upgrade_plan.md`
- `.agentic/bus/artifacts/<run_id>/diff_summary.md`
- `.agentic/bus/artifacts/<run_id>/version_bumps.md`
- `.agentic/bus/artifacts/<run_id>/changelog_entries.md`

## Decision Matrix
| Decision | Options | Criteria | Default |
| --- | --- | --- | --- |
| Overwrite managed | allow / block | header present | allow |
| Overwrite human-owned | propose / block | ownership policy | block |

## Operating Loop
- Record metrics in `.agentic/bus/metrics/<run_id>/<agent_id>.json`.
1. Validate inputs and ownership policy.
2. Build upgrade plan with file list and reasons.
3. Record diffs and version bump proposals.
4. Block until approval is explicit.

## Quality Gates
- Upgrade plan lists every file with ownership type.
- No human-owned file is overwritten.

## Failure Taxonomy
- Ownership conflicts
- Missing manifest

## Escalation Protocol
Ask 3–7 questions when blocked:
If CI=true or AGENTIC_HEADLESS=1, write `.agentic/bus/artifacts/<run_id>/questions.md` and output `BLOCKED` without waiting.
1. Approve overwriting managed files?
2. Approve any hybrid block updates?
3. Approve version bump type?


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
- Upgrade plan and diff summary written.

## Changelog
- 0.6.0 (2026-02-03): Require metrics logging per agent.
- 0.3.0 (2026-02-03): Add headless/CI escalation and questions artifact.
- 0.2.0 (2026-02-03): Rewritten as Spec v2 contract with explicit outputs.
