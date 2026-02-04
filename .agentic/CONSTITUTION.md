---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/CONSTITUTION.md
Template-Version: 2.6.0
Last-Generated: 2026-02-04T17:55:11Z
Ownership: Managed
---

# Constitution

## Instruction Precedence
1. User instructions in the current session
2. docs/PRD.md (when present)
3. .ai/context/PROJECT.md
4. .ai/context/CORE.md
5. .ai/context/STANDARDS.md
6. .ai/context/SECURITY.md
7. .ai/context/TESTING.md
8. docs/ARCHITECTURE.md and ADRs
9. .agentic/settings.json (operational toggles; overridden by env vars)

If there is a conflict, higher precedence wins. If a required input is missing, the agent must BLOCK.

## Bootstrap Context Policy
- Startup should load only BOOTSTRAP + PROJECT + CONSTITUTION.
- Load PRD and L1 contexts on-demand.

## Settings and Overrides
Primary settings live in `.agentic/settings.json`. Environment variables override settings:
- `AGENTIC_RUN_MODE`
- `AGENTIC_TELEMETRY` (true/false)
- `AGENTIC_TELEMETRY_TOKENS` (true/false)
- `AGENTIC_TELEMETRY_EVENTS` (true/false)
- `AGENTIC_TELEMETRY_QUESTIONS` (true/false)
- `AGENTIC_TELEMETRY_QUESTIONS_LOG` (true/false)
- `AGENTIC_RUN_START` (true/false)
- `validation.enforce_agent_id` (boolean in settings, no env override)

## Automation (Default On)
If `settings.automation.run_scripts=true`, the assistant must run the logging scripts automatically.
- `auto_start_run=true`: call `scripts/start-run.sh` on the first PRD interaction.
- `auto_log_questions=true`: call `scripts/log-question.sh` for every question and answer.
- `auto_log_agents=true`: call `scripts/log-event.sh` and `scripts/log-metrics.sh` for each agent start/end.
If `settings.automation.run_scripts=false`, do not run scripts and explicitly note telemetry is disabled.

## Run Modes (Required Choice)
The orchestrator must select a run mode the first time a PRD is ingested for a run.
- `AgentX`: minimal questions, autonomous execution. Auto-advance gates after initial calibration. Document changes at the end.
- `AgentL`: balanced mode. Ask questions and require approvals at each phase gate.
- `AgentM`: maximum collaboration. Ask more questions, explain options, and invite more edits.

If `AGENTIC_RUN_MODE` is set, use it. Otherwise, ask the user to choose.
Record the decision in `.agentic/bus/state/<run_id>.json` and `.agentic/bus/artifacts/<run_id>/decisions.md`.

## Calibration Questions (After PRD)
After the PRD is provided, the system must ask a short calibration set (3–7 questions).
- The run mode question must be asked here, with `AgentX` as the suggested option.
- If the user does not answer, default to `AgentL`.
- Calibration questions are non-blocking unless a critical input is missing (then follow normal BLOCK rules).

## Communication Style by Mode
- `AgentX`: short, decisive. Do not ask “move on?” prompts. Proceed unless a critical blocker appears.
- `AgentL`: concise but collaborative. Ask at each phase gate.
- `AgentM`: explanatory. Provide alternatives and ask for confirmation more often.

## Agent Prompt Spec v2 (Mandatory)
Every agent prompt in `.agentic/agents/` must contain all sections below. Missing sections are a hard failure.

### Required Sections
1. **Header**: Prompt-ID, Version (semver), Owner, Last-Updated
2. **Scope**: what the agent does and explicit non-goals
3. **Inputs**: required vs optional, plus validation behavior
4. **Outputs**: exact artifact paths and required formats
5. **Decision Matrix**: typical decisions + criteria
6. **Operating Loop**: steps + gates + bus handoffs
7. **Quality Gates**: automatic and manual checks
8. **Failure Taxonomy**: failure types + response
9. **Escalation Protocol**: when to ask the human and minimum questions
10. **Verification**: how to confirm correctness without inventing data
11. **Anti-Generic Rules**: banned patterns + minimum requirements
12. **Definition of Done**: explicit, testable completion criteria
13. **Changelog Entry**: every prompt change bumps version and records a line in `.agentic/CHANGELOG.md`

### Required Output Rule
Each agent must produce **at least one** verifiable artifact (file) or a recorded decision in the bus. If inputs are missing, it must output `BLOCKED` with a minimal question set (3–7 questions) and stop.

## Anti-Genericity Rubric (Strict)
### Banned Patterns
- “best practices” without a concrete checklist
- “consider / might / could / maybe” without a recommended decision and criteria
- outputs without explicit paths
- steps without success conditions
- “depende” without blocking questions

### Minimum Depth Requirements
- Every agent produces at least one artifact or decision
- Every agent declares a Definition of Done
- Missing critical inputs → **BLOCKED** + 3–7 questions

### Scoring (0–5) and Actions
- **Depth**: decisions, gates, verification, DoD present
- **Specificity**: explicit paths, formats, commands, run_id patterns
- **Contract**: inputs/outputs, failure taxonomy, escalation are complete
- **Alignment**: references L0/L1 context and bus usage

**Thresholds**:
- Any score < 3 → BLOCKED
- Average score < 4 → must add details before proceeding

## PRD→Repo Adaptive Engine (Mandatory)
If PRD requests changes to rules, stack, or gates, the system must:
1. Record the decision in `.agentic/bus/artifacts/<run_id>/decisions.md`.
2. Update affected files (managed or hybrid only).
3. Bump SemVer (repo and/or agentic version).
4. Write changelog entries (`CHANGELOG.md`, `.agentic/CHANGELOG.md`).
5. Create a migration entry in `.agentic/migrations/<version>/README.md`.

## Safe Overwrite Protocol (Mandatory)
- Never overwrite without a diff plan in `.agentic/bus/artifacts/<run_id>/diff_summary.md`.
- Always record file ownership and reasons for changes.
- BLOCK if PRD conflicts with this Constitution or L0/L1 policies.

## Headless / CI Mode
- If `CI=true` or `AGENTIC_HEADLESS=1`, do not ask interactive questions.
- Write `.agentic/bus/artifacts/<run_id>/questions.md` and output `BLOCKED`.
- If `AGENTIC_RUN_MODE` is set, use it; otherwise default to `AgentL` with `approval_mode=explicit`.
- Calibration questions should still be written to `calibration_questions.md` when possible.

## Tool Adapter Alignment Rules
All tool adapters must reference the same L0/L1 sources:
- `.ai/context/CORE.md`
- `.ai/context/STANDARDS.md`
- `.ai/context/SECURITY.md`
- `.ai/context/TESTING.md`

Adapters must avoid duplicating policy text. They should point to the same sources to prevent drift.

## Ownership and Overwrite Policy
- Managed files must include the Managed-By header.
- Human-owned files (missing header) must never be overwritten.
- Hybrid files may only modify blocks between `BEGIN_MANAGED` and `END_MANAGED`.
- `docs/PRD.md` is Hybrid: only edit the managed block, never the header.
- `.ai/context/PROJECT.md` is Hybrid: only edit the managed block, never the header.

## Metrics Logging
- Each agent must write metrics to `.agentic/bus/metrics/<run_id>/<agent_id>.json`.
- Orchestrator must generate `agent_performance_report.md`.
- Tokens may be captured automatically from env vars: `AGENTIC_TOKENS_IN/OUT` or tool-specific `CODEX_TOKENS_*`, `GEMINI_TOKENS_*`, `CLAUDE_TOKENS_*`.
- If telemetry events are enabled, append to `.agentic/bus/metrics/<run_id>/events.jsonl` for run_start, agent_start, agent_end, blocked, run_end.
- If telemetry questions are enabled, write `questions_log.md` and log question_asked/answer_received events.

## Question Logging (Default)
When `settings.telemetry.questions=true`:
- Every question asked to the user must be logged via `scripts/log-question.sh`.
- Use the real `agent_id` (file name under `.agentic/agents/`).
- Reuse the same `question_id` when logging the answer.
- If `settings.telemetry.questions_log=false`, only events are written (no `questions_log.md`).

## Versioning and Changelog
- Any prompt change must bump semver and update `.agentic/CHANGELOG.md`.
- Repository-level changes update `CHANGELOG.md` with semver and date.
