---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/migrations/0.4.0/README.md
Template-Version: 1.2.0
Last-Generated: 2026-02-03T19:24:12Z
Ownership: Managed
---

# Migration 0.4.0

## Summary
Introduce PRD→Repo adaptive engine enforcement and safe overwrite protocol checks.

## Applies To
All repos using this agentic system.

## Steps
1. Ensure `scripts/verify.sh` is updated to include contract and placeholder checks.
2. Ensure tool adapters reference L0/L1 contexts.
3. Re-run verification after applying updates.

## Risks
- Builds may fail until placeholders are removed from managed files.

## Rollback
Revert the updated Constitution and verify script to the previous version.
