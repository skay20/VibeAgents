---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.claude/CLAUDE.md
Template-Version: 1.11.0
Last-Generated: 2026-02-04T16:33:06Z
Ownership: Managed
---

# Claude Code Instructions

## Imports
@.ai/context/BOOTSTRAP.md
@.ai/context/PROJECT.md
@.agentic/CONSTITUTION.md
@.agentic/settings.json
@.agentic/WORKFLOWS_GUIDE.md
@.claude/rules/prd.md

## On-Demand Context
- @docs/PRD.md
- @.ai/context/CORE.md
- @.ai/context/STANDARDS.md
- @.ai/context/SECURITY.md
- @.ai/context/TESTING.md

## Rules
- Apply Agent Prompt Spec v2.
- If PRD is missing or placeholder, output BLOCKED.
- At run start, ensure run mode is set (`AgentX`, `AgentL`, `AgentM`). Ask once if missing or read `AGENTIC_RUN_MODE`. Default to `AgentL` if unanswered.
- Set `AGENTIC_TOOL=claude` to enable automatic token logging when available.
- When asking any user question, call `scripts/log-question.sh` if `settings.telemetry.questions=true`.
