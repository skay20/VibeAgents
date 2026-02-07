---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/README.md
Template-Version: 1.2.0
Last-Generated: 2026-02-06T14:05:00Z
Ownership: Managed
---

# Agentic System

This folder contains the No-App-First multi-agent system.

## Key Paths
- `agents/`: prompt files for all agents
- `bus/`: schemas, artifacts, and run state
- `connectors/`: interface contracts for external systems
- `templates/`: canonical templates (optional)
- `migrations/`: breaking-change migrations
- `settings.json`: operational toggles (run mode, telemetry)
- `agents/_CORE.md`: shared contract for v2 thin prompts
- `scripts/render-agent-prompt.sh`: resolves effective prompt (`v1`, `v2`, or `auto`)

## Run Pack
Each run writes to `.agentic/bus/artifacts/<run_id>/` and updates `.agentic/bus/state/<run_id>.json`.
