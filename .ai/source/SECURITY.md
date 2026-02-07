---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.ai/context/SECURITY.md
Template-Version: 1.3.0
Last-Generated: 2026-02-03T19:32:10Z
Ownership: Managed
---

# SECURITY (L1)

## Secrets Policy
- Never store secrets in the repo.
- Use `.env.example` for configuration variables.
- Do not copy credentials into prompts or logs.

## Data Handling
- Classify data as: Public / Internal / Restricted.
- Restricted data must not leave the repo or logs.

## Security Checks
- Run the security command defined in `docs/RUNBOOK.md`.
- Record results in `.agentic/bus/artifacts/<run_id>/security_report.md`.
- If no security command is defined, BLOCK and request it.

## Safe Defaults
- Validate inputs and reject invalid payloads.
- Avoid dynamic code execution.
- Log security-relevant events.
