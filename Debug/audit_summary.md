# Debug Audit Summary

- Run ID: `20260203-182331Z-vibeagents`
- Tier: `unknown`
- Gate Status: `approved`
- Flow Status: `unknown`

## Agents
- Planned: (none)
- Executed (metrics): (none)
- Dispatch rows: 0

## Events
- Total: 0
- run_start: 0
- agent_start: 0
- agent_end: 0
- question_asked: 0
- answer_received: 0

## Detected Shapes
- debug_sweep_command_failures
- debug_sweep_missing_files

## Suggestions
- Missing dispatch_resolution.md; ensure resolve-dispatch.sh was executed for this run before implementation.
- Missing flow_evidence.md; enforce-flow.sh was not run or artifacts were not copied into Debug.
- Some debug sweep commands failed. Check Debug/errors.txt to see which commands failed and why.
- Some expected evidence files were missing from the Debug package. Check Debug/missing.txt and ensure the target repo actually produced those artifacts for this run.

## Evidence Paths
- State: `/Users/matiassouza/Desktop/Projects/VibeAgents/Debug/.agentic/bus/state/20260203-182331Z-vibeagents.json`
- Artifacts: `/Users/matiassouza/Desktop/Projects/VibeAgents/Debug/.agentic/bus/artifacts/20260203-182331Z-vibeagents`
- Metrics: `/Users/matiassouza/Desktop/Projects/VibeAgents/Debug/.agentic/bus/metrics/20260203-182331Z-vibeagents`
- Events: `/Users/matiassouza/Desktop/Projects/VibeAgents/Debug/.agentic/bus/metrics/20260203-182331Z-vibeagents/events.jsonl`

## Debug Sweep Files
- checks.txt: `/Users/matiassouza/Desktop/Projects/VibeAgents/Debug/checks.txt`
- errors.txt: `/Users/matiassouza/Desktop/Projects/VibeAgents/Debug/errors.txt`
- missing.txt: `/Users/matiassouza/Desktop/Projects/VibeAgents/Debug/missing.txt`
