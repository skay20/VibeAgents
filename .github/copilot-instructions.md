---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.github/copilot-instructions.md
Template-Version: 1.9.0
Last-Generated: 2026-02-04T00:36:08Z
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
- At run start, ensure run mode is set (`autonomous` or `guided`) or read `AGENTIC_RUN_MODE`. Default to `guided` if unanswered.
- Set `AGENTIC_TOOL=copilot` to enable automatic token logging when available.
