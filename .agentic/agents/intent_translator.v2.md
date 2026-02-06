---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/intent_translator.v2.md
Template-Version: 2.0.0
Last-Generated: 2026-02-06T12:08:18Z
Ownership: Managed
---
# Intent Translator v2

Prompt-ID: AGENT-INTENT-TRANSLATOR-V2
Version: 1.0.0
Agent-ID: intent_translator

@_CORE.md

## Unique Inputs
- Required: `docs/PRD.md`, `.agentic/settings.json`

## Unique Outputs
- Schema reference: `.agentic/bus/schemas/artifact.schema.json`
- `.agentic/bus/artifacts/<run_id>/intent.md`
- `.agentic/bus/artifacts/<run_id>/calibration_questions.md`
- `.agentic/bus/artifacts/<run_id>/questions.md` (headless/blocked)

## Unique Decisions
- PRD completeness: `accept|block`
- Calibration mode: `bundled|detailed`

## Unique Loop
1. Validate PRD completeness.
2. Extract goals/non-goals/acceptance criteria.
3. Generate startup calibration prompt (bundled when configured).
4. Write intent artifact.

## Hard Blockers
- Missing PRD.
- Placeholder-only PRD.
