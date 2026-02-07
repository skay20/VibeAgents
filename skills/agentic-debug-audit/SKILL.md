---
name: agentic-debug-audit
description: Audit agentic Debug/ sweeps and run telemetry for cross-project troubleshooting and optimization. Use when a project contains a Debug folder produced by a "DEBUG SWEEP" (missing.txt/errors.txt/checks.txt plus copied .agentic/.ai artifacts) and you need to verify which agents actually executed, whether tier/dispatch/enforcement ran, and what to fix next.
---

# Agentic Debug Audit

Run a deterministic audit over a `Debug/` folder (from any project) and produce an actionable summary.

## What This Skill Does

- Read the `Debug/` folder produced by your debug sweep.
- Determine the real `run_id`, tier, planned agents, executed agents, and missing evidence.
- Detect common failure shapes (e.g., "dispatch resolved but no metrics", "debug run created instead of auditing a real run").
- Emit a concise, actionable report with concrete next fixes.

## How To Use

1. Ask for the path to the Debug folder if not provided.
- Default: `./Debug`

2. Run the audit script.

```bash
python3 skills/agentic-debug-audit/scripts/audit_debug.py --debug-dir ./Debug
```

3. Use the generated outputs as your source of truth in your response:
- `Debug/audit_summary.md`
- `Debug/audit.json`

## Output Contract (What You Must Return)

- A short diagnosis (what happened, with evidence paths).
- A short action plan (what to fix next, minimal changes first).
- If this audit indicates the debug sweep is misconfigured: propose an updated sweep procedure.

## Constraints

- Do not invent run data.
- Prefer evidence from:
  - `Debug/.agentic/bus/state/<run_id>.json`
  - `Debug/.agentic/bus/metrics/<run_id>/events.jsonl`
  - `Debug/.agentic/bus/metrics/<run_id>/*.json` (per-agent)
  - `Debug/.agentic/bus/artifacts/<run_id>/dispatch_resolution.md`
  - `Debug/.agentic/bus/artifacts/<run_id>/planned_agents.md`
  - `Debug/.agentic/bus/artifacts/<run_id>/flow_evidence.md`

## Common Fix Patterns

- If `planned_agents` exists but no per-agent metrics exist:
  - The run likely never executed agents or `log-metrics.sh` was not called.
  - Or you created a new run during audit instead of auditing the real run.
- If `events.jsonl` exists but has only `run_start`:
  - Entry point ran, but the actual "work" chain did not run.
- If enforcement fails with `missing_metrics`:
  - Treat as governance success (it blocked), not a product failure.

