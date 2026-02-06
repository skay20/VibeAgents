---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/CONSTITUTION.md
Template-Version: 2.12.0
Last-Generated: 2026-02-06T16:43:23Z
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
- Startup should load only RUNTIME_MIN + BOOTSTRAP + PROJECT.
- Load PRD and L1 contexts on-demand.
If `settings.startup.profile=fast`, avoid directory listings and script reads unless required.

## PRD Intake and Evolution (Mandatory)
PRD intake must be structure-driven, not keyword-driven.
- If user input matches PRD structure signals from `settings.prd_intake.structural_signals` and reaches `settings.prd_intake.min_structural_signals`, treat it as PRD even without phrases like `new PRD`.
- If ambiguous, ask exactly one confirmation question when `settings.prd_intake.on_ambiguity=confirm_once`.
- Always normalize accepted PRD content into `docs/PRD.md` by editing only `BEGIN_MANAGED` / `END_MANAGED`.
- On follow-up feature requests, update PRD incrementally (do not discard prior valid scope) when `settings.prd_intake.update_strategy=incremental`.
- If scope is a full reset and `settings.prd_intake.create_new_prd_on_scope_reset=true`, create a new PRD lineage entry and record rationale in decisions.
- If `settings.prd_intake.write_prd_versions=true`, write versioned snapshots under `.agentic/bus/artifacts/<run_id>/prd_versions/` and summarize delta in `.agentic/bus/artifacts/<run_id>/prd_delta.md`.

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

## Adaptive Flow Policy (Quality + Speed)
Execution must use a risk tier to avoid unnecessary overhead while enforcing minimum safety.

`settings.flow_control.default_tier` defines fallback behavior. If `settings.flow_control.auto_tier_by_change=true`, select tier by change risk:
- `lean`: low-risk edits (copy/style/docs/localized UI without dependency, build, API, security, or architecture impact)
- `standard`: normal feature/code changes (default)
- `strict`: high-risk changes triggered by `settings.flow_control.strict_triggers`

Required agents by tier come from `settings.flow_control.required_agents`.

Minimum required evidence for every required agent:
- Metrics file: `.agentic/bus/metrics/<run_id>/<agent_id>.json`
- At least one artifact output or decision entry in `.agentic/bus/artifacts/<run_id>/`

If required evidence is missing, output `BLOCKED` and do not release.
Reading a prompt file does not count as execution evidence.

## Run Completion Contract (Mandatory)
A run can be finalized only when both conditions hold:
- `gate_status=approved` in `.agentic/bus/state/<run_id>.json`
- Flow evidence passes for the selected tier (`scripts/enforce-flow.sh <run_id> <tier> final`)

Pre-release gate must execute:
- `scripts/enforce-flow.sh <run_id> <tier> pre_release`

If the check fails, output `BLOCKED` and include missing-agent reasons.

## Documentation Target Contract
- Global `docs/RUNBOOK.md` remains framework-level unless explicitly requested otherwise.
- Project-specific generated documentation must be written by docs flow to `settings.docs.project_runbook_path` (default `<project_root>/RUNBOOK.md`).
- Documentation stage is incomplete if project runbook target is missing for generated projects.

## Project Template Compatibility (Cross-Project)
When running this system against a generated side project (`project_meta`):
- Validate compatibility when `settings.project_meta.enforce_compatibility=true`.
- Required files and minimum template versions come from:
  - `settings.project_meta.required_files`
  - `settings.project_meta.min_template_versions`
- If compatibility check fails, block run with actionable error before implementation.

## Calibration Questions (After PRD)
After the PRD is provided, the system must ask a short calibration set.
- PRD provision includes structured PRD text in chat, even when no explicit keyword is used.
- The run mode question must be asked here, with `AgentX` as the suggested option.
- If the user does not answer, default to `AgentL`.
- Calibration questions are non-blocking unless a critical input is missing (then follow normal BLOCK rules).
If `settings.startup.profile=fast`:
- Ask only missing inputs (read the PRD first).
- Cap the initial set at `settings.startup.max_initial_questions`.
- Defer non-critical decisions to the planning phase.
- If `settings.startup.single_calibration_message=true`, ask calibration in one bundled message.

## Startup Performance (Fast Profile)
If `settings.startup.profile=fast`:
- Do not read scripts under `scripts/`; call them directly when automation is enabled.
- Avoid listing directories; rely on `repo_manifest.json` or `TREE.md` only when required.
- If `settings.startup.batch_startup_logging=true`, emit one startup calibration log entry (`Q_CALIBRATION`) instead of per-question logs.

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

## Preflight (Required for Web Apps)
If `settings.checks.preflight_enabled=true` and a `package.json` exists:
- QA must run `scripts/preflight.sh <run_id>` before release.
- A failing preflight blocks release until fixed or explicitly waived.

## Versioning and Changelog
- Any prompt change must bump semver and update `.agentic/CHANGELOG.md`.
- Repository-level changes update `CHANGELOG.md` with semver and date.
