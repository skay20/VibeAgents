---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.ai/context/TESTING.md
Template-Version: 1.3.0
Last-Generated: 2026-02-03T19:32:10Z
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

## Execution Rules
- Run all configured gates for any behavior change.
- If a gate fails, block release and record the failure.

## Outputs
- `.agentic/bus/artifacts/<run_id>/qa_report.md`
- `.agentic/bus/artifacts/<run_id>/security_report.md`
