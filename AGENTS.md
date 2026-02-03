---
Managed-By: AgenticRepoBuilder
Template-Source: templates/AGENTS.md
Template-Version: 1.1.0
Last-Generated: 2026-02-03T19:08:34Z
Ownership: Managed
---

# Codex Instructions

## Scope and Precedence
- Codex reads AGENTS.override.md before AGENTS.md.
- Codex loads instructions from global scope and from each directory from repo root to the current working directory.
- Files closer to the current directory override earlier guidance.

## Required Context (L0/L1)
- `.ai/context/CORE.md`
- `.ai/context/STANDARDS.md`
- `.ai/context/SECURITY.md`
- `.ai/context/TESTING.md`
- `.agentic/CONSTITUTION.md`

## Working Agreements
- Follow Agent Prompt Spec v2 and the anti-genericity rubric.
- Do not modify human-owned files (missing Managed-By header).
- If PRD is missing or placeholder, output BLOCKED and ask minimal questions.
- Record decisions in `.agentic/bus/artifacts/<run_id>/decisions.md`.
