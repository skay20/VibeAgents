---
Managed-By: AgenticRepoBuilder
Template-Source: templates/AGENTS.md
Template-Version: 2.2.0
Last-Generated: 2026-02-06T16:26:32Z
Ownership: Managed
---

# Codex Instructions

## Shared Rules
Read `.agentic/adapters/UNIVERSAL.md`.
Bootstrap context:
- `.ai/context/RUNTIME_MIN.md`
- `.ai/context/BOOTSTRAP.md`
- `.ai/context/PROJECT.md`

Startup handshake (must happen even on fast runs):
- Create `run_id` via `scripts/start-run.sh` (when automation enabled).
- Detect PRD by structure (not only keyword) and ingest/update `docs/PRD.md` (managed block) before calibration.
- Ask calibration once, including run mode if `AGENTIC_RUN_MODE` is unset.

## Codex-Specific
- Precedence: `AGENTS.override.md` > `AGENTS.md`.
- Directory overrides: nearer `AGENTS.md` wins.
- Tool identifier: set `AGENTIC_TOOL=codex`.
