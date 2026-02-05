---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/adapters/UNIVERSAL.md
Template-Version: 1.0.0
Last-Generated: 2026-02-05T12:45:00Z
Ownership: Managed
---

# Universal Adapter Rules

## Bootstrap Context (Required)
- `.ai/context/BOOTSTRAP.md`
- `.ai/context/PROJECT.md`
- `.agentic/CONSTITUTION.md`
- `.agentic/settings.json`

## Agent Behavior
- Apply Agent Prompt Spec v2 and anti-genericity rubric.
- If PRD is missing or placeholder, output `BLOCKED` and ask minimal questions.
- Run mode: use `AGENTIC_RUN_MODE` if set; otherwise ask once and default per settings.
- Telemetry + automation: honor `.agentic/settings.json` flags.

## Context Loading Rules
- L0/L1 on-demand only.
- L2 (Architecture) only when planning or implementing.
- L3 artifacts only for the active run.

## Automation Defaults
- If `settings.automation.run_scripts=true`, run scripts automatically:
  - `scripts/start-run.sh`
  - `scripts/log-event.sh`
  - `scripts/log-question.sh`
  - `scripts/log-metrics.sh`

## Blocking Rule
- If required inputs are missing, stop and request them.

## Tool Environment
- `AGENTIC_TOOL=<tool_name>` must be set in the tool-specific adapter.
