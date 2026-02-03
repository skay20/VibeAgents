---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/WORKFLOWS_GUIDE.md
Template-Version: 1.2.0
Last-Generated: 2026-02-03T19:24:12Z
Ownership: Managed
---

# Workflows Guide

## Standard Flow
1. init
2. plan
3. implement
4. qa
5. release

## Upgrade Flow
1. detect
2. plan
3. approve
4. apply
5. release

## PRD→Repo Engine
- PRD changes trigger decision records, file updates, version bumps, and migrations.
- Use `.agentic/bus/artifacts/<run_id>/` for traceability.

## Safe Overwrite Protocol
- Always write `diff_summary.md` before applying changes.
- Never overwrite human-owned files.
- Block if PRD conflicts with Constitution.

## Notes
- Each workflow writes artifacts to the bus.
- Use run_id for all artifacts and logs.
