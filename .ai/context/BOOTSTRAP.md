---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.ai/context/BOOTSTRAP.md
Template-Version: 2.0.0
Last-Generated: 2026-02-04T14:22:29Z
Ownership: Managed
---

# BOOTSTRAP (L0-min)

## Purpose
Provide minimal context for fast startup. Load only what is needed to begin safely.

## Load Order (Startup)
1. `.ai/context/BOOTSTRAP.md`
2. `.ai/context/PROJECT.md`
3. `.agentic/CONSTITUTION.md`
4. `docs/PRD.md` (only when planning or implementing)

## Rules
- Do not load L1 files unless required.
- If PRD is missing or placeholder, write questions and BLOCK.
- If run mode is not set, ask for `AgentX`, `AgentL`, or `AgentM` (or read `AGENTIC_RUN_MODE`). Default to `AgentL` if unanswered.
- Read operational toggles from `.agentic/settings.json` (env vars override).
