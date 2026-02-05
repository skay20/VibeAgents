---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/README.md
Template-Version: 1.1.0
Last-Generated: 2026-02-04T00:36:08Z
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

## Run Pack
Each run writes to `.agentic/bus/artifacts/<run_id>/` and updates `.agentic/bus/state/<run_id>.json`.
