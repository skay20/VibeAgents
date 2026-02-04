<!-- Managed-By: AgenticRepoBuilder -->
<!-- Template-Source: templates/.windsurf/rules/00-global.md -->
<!-- Template-Version: 1.8.0
<!-- Last-Generated: 2026-02-04T00:36:08Z
<!-- Ownership: Managed -->

# Global Rules

Refer to:
- `.ai/context/BOOTSTRAP.md`
- `.ai/context/PROJECT.md`

Rules:
- Apply Agent Prompt Spec v2 and anti-genericity rubric.
- If PRD is missing or placeholder, output BLOCKED.
- At run start, ensure run mode is set (`autonomous` or `guided`) or read `AGENTIC_RUN_MODE`. Default to `guided` if unanswered.
- Set `AGENTIC_TOOL=windsurf` to enable automatic token logging when available.
