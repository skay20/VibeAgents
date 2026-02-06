---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.agentic/agents/intent_translator.v2.md
Template-Version: 2.1.0
Last-Generated: 2026-02-06T17:20:00Z
Ownership: Managed
---
# Intent Translator v2

Prompt-ID: AGENT-INTENT-TRANSLATOR-V2
Version: 1.1.0
Agent-ID: intent_translator

@_CORE.md

## Unique Inputs
- Required: `docs/PRD.md`, `.agentic/settings.json`

## Unique Outputs
- Schema reference: `.agentic/bus/schemas/artifact.schema.json`
- Normalize PRD into `docs/PRD.md` (Hybrid): update only the managed block and preserve header/markers
- `.agentic/bus/artifacts/<run_id>/intent.md`
- `.agentic/bus/artifacts/<run_id>/calibration_questions.md`
- `.agentic/bus/artifacts/<run_id>/questions.md` (headless/blocked)

## Unique Decisions
- PRD completeness: `accept|block`
- Calibration mode: `bundled|detailed`

## Unique Loop
1. Normalize PRD: if the user provided PRD text in chat, write it into `docs/PRD.md` managed block.
2. Validate PRD completeness (block if placeholder-only).
3. Extract goals/non-goals/acceptance criteria.
4. Generate startup calibration prompt (bundled when configured).
5. Write intent artifact.

## Hard Blockers
- Missing PRD.
- Placeholder-only PRD.
