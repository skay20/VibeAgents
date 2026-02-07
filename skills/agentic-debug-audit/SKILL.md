---
name: agentic-debug-audit
description: Audit and debug agentic cross-project runs using a deterministic Debug/ sweep. Use when you want to verify agent concatenation (planned vs executed), tier/dispatch/enforcement health, and actionable fixes based on real run evidence copied into a Debug folder.
---

# Agentic Debug Audit

This skill turns a target repo into a self-auditable package: it creates/refreshes a `Debug/` folder, auto-detects the right `RUN_ID`, copies the minimal evidence set, runs checks, and produces a concise report.

## What This Skill Does

- Create/refresh `Debug/` in the target repo root.
- Auto-detect the most relevant `RUN_ID` without starting a new run.
- Copy evidence needed to answer:
  - Which agents were actually executed (metrics), not just planned.
  - Whether startup handshake, tier selection, dispatch, and enforcement happened.
  - What is missing and why (artifacts, metrics, events).
- Run checks (if present) and capture output:
  - `./scripts/verify.sh`
  - `./scripts/enforce-flow.sh <run_id> <tier> pre_release`
  - `./scripts/enforce-flow.sh <run_id> <tier> final`
- Generate a single actionable audit summary.

## One-Command Usage (Recommended)

From the target repo root:

```bash
python3 skills/agentic-debug-audit/scripts/debug_sweep.py
```

Optional overrides:

```bash
python3 skills/agentic-debug-audit/scripts/debug_sweep.py --run-id <RUN_ID> --tier standard
python3 skills/agentic-debug-audit/scripts/debug_sweep.py --debug-dir ./Debug
```

Audit-only (if `Debug/` already exists):

```bash
python3 skills/agentic-debug-audit/scripts/audit_debug.py --debug-dir ./Debug
```

## Outputs (Single Source of Truth)

Always written:
- `Debug/run_id.txt`
- `Debug/tier.txt`
- `Debug/missing.txt`
- `Debug/errors.txt`
- `Debug/checks.txt`
- `Debug/audit.json`
- `Debug/audit_summary.md`
- `Debug/LLM_PROMPT.md`

Best-effort copied (missing entries are recorded in `Debug/missing.txt`):
- `Debug/AGENTS.md`
- `Debug/.agentic/adapters/UNIVERSAL.md`
- `Debug/.agentic/CONSTITUTION.md`
- `Debug/.agentic/settings.json`
- `Debug/.ai/context/RUNTIME_MIN.md`
- `Debug/.agentic/bus/state/<RUN_ID>.json`
- `Debug/.agentic/bus/metrics/<RUN_ID>/events.jsonl`
- `Debug/.agentic/bus/metrics/<RUN_ID>/*.json`
- `Debug/.agentic/bus/artifacts/<RUN_ID>/*` (core + flow governance)

## Copy/Paste Prompt For LLM

After running the sweep, paste `Debug/LLM_PROMPT.md` into your LLM tool. It instructs the LLM to:
- Use `audit_summary.md` and copied evidence paths.
- Confirm agent concatenation health.
- Call out root causes and the minimal next fixes.

## Constraints

- Do not invent run data.
- Do not create a new run during audit.
- The sweep only auto-selects runs that have per-agent metrics under `.agentic/bus/metrics/<run_id>/*.json`. If none exist, it stops with an actionable error in `Debug/errors.txt`.
