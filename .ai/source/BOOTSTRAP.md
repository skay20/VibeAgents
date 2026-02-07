---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.ai/context/BOOTSTRAP.md
Template-Version: 2.2.0
Last-Generated: 2026-02-05T23:51:57Z
Ownership: Managed
---

# BOOTSTRAP (L0-min)

## Purpose
Provide minimal context for fast startup. Load only what is needed to begin safely.

## Load Order (Startup)
1. `.ai/context/RUNTIME_MIN.md`
2. `.ai/context/BOOTSTRAP.md`
3. `.ai/context/PROJECT.md`
4. `.agentic/settings.json`
5. `.agentic/CONSTITUTION.md` (only if policy conflict appears)
6. `docs/PRD.md` (only when planning or implementing)

## Rules
- Do not load L1 files unless required.
- If PRD is missing or placeholder, write questions and BLOCK.
- If run mode is not set, ask for `AgentX`, `AgentL`, or `AgentM` (or read `AGENTIC_RUN_MODE`). Default to `AgentL` if unanswered.
- Read operational toggles from `.agentic/settings.json` (env vars override).

## Startup Performance Profile
If `settings.startup.profile=fast`:
- Ask only missing calibration inputs, up to `settings.startup.max_initial_questions`.
- Ask calibration in one message if `settings.startup.single_calibration_message=true`.
- Defer deep decisions until planning if not required to proceed.
- Do not read scripts under `scripts/`; call them directly if automation is enabled.
- Avoid directory listings; use `repo_manifest.json` or `TREE.md` only when needed.
- Bundle startup logs if `settings.startup.batch_startup_logging=true`.
