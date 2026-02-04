---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.ai/context/TESTING.md
Template-Version: 1.4.0
Last-Generated: 2026-02-04T17:55:11Z
Ownership: Managed
---

# TESTING (L1)

## Gate Matrix
| Gate | Command Source | Evidence | Block Condition |
| --- | --- | --- | --- |
| Lint | `docs/RUNBOOK.md` | `qa_report.md` | Command missing |
| Test | `docs/RUNBOOK.md` | `qa_report.md` | Command missing |
| Typecheck | `docs/RUNBOOK.md` | `qa_report.md` | Command missing |
| Security | `docs/RUNBOOK.md` | `security_report.md` | Command missing |
| Preflight (start) | `scripts/preflight.sh` | `preflight_report.md` | App does not start |

## Execution Rules
- Run all configured gates for any behavior change.
- If a gate fails, block release and record the failure.

## Outputs
- `.agentic/bus/artifacts/<run_id>/qa_report.md`
- `.agentic/bus/artifacts/<run_id>/security_report.md`
- `.agentic/bus/artifacts/<run_id>/preflight_report.md`
