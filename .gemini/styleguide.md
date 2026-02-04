---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.gemini/styleguide.md
Template-Version: 1.9.0
Last-Generated: 2026-02-04T00:36:08Z
Ownership: Managed
---

# Gemini Code Assist Style Guide

Refer to:
- `.ai/context/BOOTSTRAP.md`
- `.ai/context/PROJECT.md`
- `.agentic/settings.json`

Rules:
- Apply Agent Prompt Spec v2 for reviews.
- Avoid vague feedback; include concrete fixes and paths.
- At run start, ensure run mode is set (`autonomous` or `guided`) or read `AGENTIC_RUN_MODE`. Default to `guided` if unanswered.
- Set `AGENTIC_TOOL=gemini` to enable automatic token logging when available.
