<!-- Managed-By: AgenticRepoBuilder -->
<!-- Template-Source: templates/.windsurf/rules/00-global.md -->
<!-- Template-Version: 1.10.0
<!-- Last-Generated: 2026-02-04T14:22:29Z
<!-- Ownership: Managed -->

# Global Rules

Refer to:
- `.ai/context/BOOTSTRAP.md`
- `.ai/context/PROJECT.md`
- `.agentic/settings.json`

Rules:
- Apply Agent Prompt Spec v2 and anti-genericity rubric.
- If PRD is missing or placeholder, output BLOCKED.
- At run start, ensure run mode is set (`AgentX`, `AgentL`, `AgentM`) or read `AGENTIC_RUN_MODE`. Default to `AgentL` if unanswered.
- Set `AGENTIC_TOOL=windsurf` to enable automatic token logging when available.
