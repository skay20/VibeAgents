---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.ai/context/STANDARDS.md
Template-Version: 1.3.0
Last-Generated: 2026-02-03T19:32:10Z
Ownership: Managed
---

# STANDARDS (L1)

## Change Discipline
- Scope changes to the approved slice only.
- Record decisions in `.agentic/bus/artifacts/<run_id>/decisions.md`.
- Write `diff_summary.md` before applying changes.

## Ownership Rules
- Managed files can be regenerated.
- Human-owned files must not be overwritten.
- Hybrid files only change within `BEGIN_MANAGED` / `END_MANAGED` blocks.

## Dependency Policy
- New dependencies require explicit justification and an ADR entry.
- If a dependency is proposed, record the decision before changes.

## Documentation Rules
- Update `docs/*` when behavior changes.
- Update `CHANGELOG.md` for user-visible changes.

## Quality Gate Enforcement
- If any required gate is missing, BLOCK and ask for the command.
