---
Managed-By: AgenticRepoBuilder
Template-Source: templates/AGENTS.md
Template-Version: 1.11.0
Last-Generated: 2026-02-04T16:33:06Z
Ownership: Managed
---

# Codex Instructions

## Scope and Precedence
- Codex reads AGENTS.override.md before AGENTS.md.
- Codex loads instructions from global scope and from each directory from repo root to the current working directory.
- Files closer to the current directory override earlier guidance.

## Required Context (Bootstrap)
- `.ai/context/BOOTSTRAP.md`
- `.ai/context/PROJECT.md`
- `.agentic/CONSTITUTION.md`
- `.agentic/settings.json`

## On-Demand Context
- `docs/PRD.md`
- `.ai/context/CORE.md`
- `.ai/context/STANDARDS.md`
- `.ai/context/SECURITY.md`
- `.ai/context/TESTING.md`

## Working Agreements
- Follow Agent Prompt Spec v2 and the anti-genericity rubric.
- Do not modify human-owned files (missing Managed-By header).
- If PRD is missing or placeholder, output BLOCKED and ask minimal questions.
- Record decisions in `.agentic/bus/artifacts/<run_id>/decisions.md`.
- At run start, ensure run mode is set (`AgentX`, `AgentL`, `AgentM`). Ask once if missing or read `AGENTIC_RUN_MODE`. Default to `AgentL` if unanswered.
- Set `AGENTIC_TOOL=codex` to enable automatic token logging when available.
- When asking any user question, call `scripts/log-question.sh` if `settings.telemetry.questions=true`.
