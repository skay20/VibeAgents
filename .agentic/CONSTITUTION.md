---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/CONSTITUTION.md
Template-Version: 1.4.0
Last-Generated: 2026-02-03T19:42:42Z
Ownership: Managed
---

# Constitution

## Instruction Precedence
1. User instructions in the current session
2. docs/PRD.md (when present)
3. .ai/context/CORE.md
4. .ai/context/STANDARDS.md
5. .ai/context/SECURITY.md
6. .ai/context/TESTING.md
7. docs/ARCHITECTURE.md and ADRs

If there is a conflict, higher precedence wins. If a required input is missing, the agent must BLOCK.

## Agent Prompt Spec v2 (Mandatory)
Every agent prompt in `.agentic/agents/` must contain all sections below. Missing sections are a hard failure.

### Required Sections
1. **Header**: Prompt-ID, Version (semver), Owner, Last-Updated
2. **Scope**: what the agent does and explicit non-goals
3. **Inputs**: required vs optional, plus validation behavior
4. **Outputs**: exact artifact paths and required formats
5. **Decision Matrix**: typical decisions + criteria
6. **Operating Loop**: steps + gates + bus handoffs
7. **Quality Gates**: automatic and manual checks
8. **Failure Taxonomy**: failure types + response
9. **Escalation Protocol**: when to ask the human and minimum questions
10. **Verification**: how to confirm correctness without inventing data
11. **Anti-Generic Rules**: banned patterns + minimum requirements
12. **Definition of Done**: explicit, testable completion criteria
13. **Changelog Entry**: every prompt change bumps version and records a line in `.agentic/CHANGELOG.md`

### Required Output Rule
Each agent must produce **at least one** verifiable artifact (file) or a recorded decision in the bus. If inputs are missing, it must output `BLOCKED` with a minimal question set (3–7 questions) and stop.

## Anti-Genericity Rubric (Strict)
### Banned Patterns
- “best practices” without a concrete checklist
- “consider / might / could / maybe” without a recommended decision and criteria
- outputs without explicit paths
- steps without success conditions
- “depende” without blocking questions

### Minimum Depth Requirements
- Every agent produces at least one artifact or decision
- Every agent declares a Definition of Done
- Missing critical inputs → **BLOCKED** + 3–7 questions

### Scoring (0–5) and Actions
- **Depth**: decisions, gates, verification, DoD present
- **Specificity**: explicit paths, formats, commands, run_id patterns
- **Contract**: inputs/outputs, failure taxonomy, escalation are complete
- **Alignment**: references L0/L1 context and bus usage

**Thresholds**:
- Any score < 3 → BLOCKED
- Average score < 4 → must add details before proceeding

## PRD→Repo Adaptive Engine (Mandatory)
If PRD requests changes to rules, stack, or gates, the system must:
1. Record the decision in `.agentic/bus/artifacts/<run_id>/decisions.md`.
2. Update affected files (managed or hybrid only).
3. Bump SemVer (repo and/or agentic version).
4. Write changelog entries (`CHANGELOG.md`, `.agentic/CHANGELOG.md`).
5. Create a migration entry in `.agentic/migrations/<version>/README.md`.

## Safe Overwrite Protocol (Mandatory)
- Never overwrite without a diff plan in `.agentic/bus/artifacts/<run_id>/diff_summary.md`.
- Always record file ownership and reasons for changes.
- BLOCK if PRD conflicts with this Constitution or L0/L1 policies.

## Headless / CI Mode
- If `CI=true` or `AGENTIC_HEADLESS=1`, do not ask interactive questions.
- Write `.agentic/bus/artifacts/<run_id>/questions.md` and output `BLOCKED`.

## Tool Adapter Alignment Rules
All tool adapters must reference the same L0/L1 sources:
- `.ai/context/CORE.md`
- `.ai/context/STANDARDS.md`
- `.ai/context/SECURITY.md`
- `.ai/context/TESTING.md`

Adapters must avoid duplicating policy text. They should point to the same sources to prevent drift.

## Ownership and Overwrite Policy
- Managed files must include the Managed-By header.
- Human-owned files (missing header) must never be overwritten.
- Hybrid files may only modify blocks between `BEGIN_MANAGED` and `END_MANAGED`.

## Versioning and Changelog
- Any prompt change must bump semver and update `.agentic/CHANGELOG.md`.
- Repository-level changes update `CHANGELOG.md` with semver and date.
