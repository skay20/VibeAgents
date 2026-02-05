---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.github/copilot-instructions.md
Template-Version: 1.12.0
Last-Generated: 2026-02-04T17:55:11Z
Ownership: Managed
---

# Copilot Instructions

Refer to:
- `.ai/context/BOOTSTRAP.md`
- `.ai/context/PROJECT.md`
- `.agentic/settings.json`

Rules:
- Follow Agent Prompt Spec v2.
- Do not edit human-owned files.
- If PRD is missing or placeholder, output BLOCKED.
- At run start, ensure run mode is set (`AgentX`, `AgentL`, `AgentM`) or read `AGENTIC_RUN_MODE`. Default to `AgentL` if unanswered.
- Set `AGENTIC_TOOL=copilot` to enable automatic token logging when available.
- If `settings.automation.run_scripts=true`, run logging scripts automatically.
