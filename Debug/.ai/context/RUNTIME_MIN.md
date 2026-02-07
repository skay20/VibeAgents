---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.ai/context/RUNTIME_MIN.md
Template-Version: 1.1.0
Last-Generated: 2026-02-06T16:26:32Z
Ownership: Managed
---

# RUNTIME_MIN (L0-ultra)

## Purpose
Ultra-short startup contract for fast first response.

## Startup Inputs
Load only:
1. `.ai/context/RUNTIME_MIN.md`
2. `.ai/context/PROJECT.md`
3. `.agentic/settings.json`
4. `.agentic/CONSTITUTION.md` only if policy conflict needs resolution

## Startup Rules
- Ask one calibration message if `settings.startup.single_calibration_message=true`.
- Ask only missing inputs from PRD.
- Respect `settings.startup.max_initial_questions` as hard cap.
- In `AgentX`, use defaults and continue unless critical blocker exists.
- Detect PRD from structured user input even without explicit keywords.
- If the user provided a PRD in chat, ingest it into `docs/PRD.md` by editing only `BEGIN_MANAGED` / `END_MANAGED` before calibration.

## Logging Rules
- If `settings.startup.batch_startup_logging=true`, log calibration as one bundled entry.
- Use one `question_id` for startup calibration (`Q_CALIBRATION`).
- Continue detailed per-question logs only after startup calibration.

## Blocking Rules
- Block only on critical missing inputs:
  - missing PRD
  - missing target platform constraints
  - hard policy conflict in Constitution
- Non-critical ambiguity must not block startup.
