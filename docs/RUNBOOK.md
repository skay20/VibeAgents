---
Managed-By: AgenticRepoBuilder
Template-Source: templates/docs/RUNBOOK.md
Template-Version: 1.1.0
Last-Generated: 2026-02-04T17:55:11Z
Ownership: Managed
---

# Runbook

## Setup
- Install dependencies: TO_CONFIRM
- Configure environment: TO_CONFIRM

## Commands
| Task | Command |
| --- | --- |
| Install | TO_CONFIRM |
| Dev | TO_CONFIRM |
| Test | TO_CONFIRM |
| Lint | TO_CONFIRM |
| Typecheck | TO_CONFIRM |
| Security | TO_CONFIRM |
| Preflight | `scripts/preflight.sh <run_id> <project_root>` |

## Quality Gates
- Run `scripts/verify.sh` or the commands above.
- If any command is not configured, mark it `TO_CONFIRM` and escalate.

## Troubleshooting
- If a command fails, capture logs in `.ai/logs/runs/<run_id>/`.
- If a gate is missing, update this file and `scripts/verify.sh`.
