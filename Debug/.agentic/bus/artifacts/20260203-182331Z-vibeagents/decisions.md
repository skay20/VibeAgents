# Decisions

Run ID: 20260203-182331Z-vibeagents
Date: 2026-02-03T18:23:31Z

## Decisions
- Use `.agentic/` as the canonical agent system root.
- Use file-based bus with JSON schemas in `.agentic/bus/schemas/`.
- Use layered context files in `.ai/context/`.
- Generate tool-specific rules for Codex, Claude, Gemini, Cursor, Windsurf, Copilot.
- Default ownership to Managed with explicit headers.
