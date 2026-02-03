# ADR-0001: Use Vibe Coding Agents

## Status

Accepted

## Context

Necesitamos establecer un sistema consistente para desarrollo asistido por IA que:
- Sea reproducible entre diferentes herramientas (Claude Code, Windsurf, Gemini, etc.)
- Mantenga contexto entre sesiones
- Asegure calidad mediante gates automatizados
- Sea fácil de onboarding para nuevos desarrolladores

## Decision

Adoptaremos el sistema "Vibe Coding Agents" con las siguientes características:

1. **Arquitectura No-App-First**: La orquestación vive en el repo, no en una app externa
2. **Context Layering**: Organización en capas (L0 Core, L1 Standards, L2 Architecture, L3 Task)
3. **Multi-Agent System**: Agentes especializados (ASK, PLAN, BUILD, TEST, REVIEW, RELEASE)
4. **Quality Gates**: Checks obligatorios antes de cualquier cambio
5. **Multi-Tool Support**: Configuración para Codex, Claude, Gemini, Windsurf, Cursor, Copilot

## Consequences

### Positive

- Consistencia entre herramientas y desarrolladores
- Contexto persistente y versionado
- Calidad asegurada mediante gates
- Onboarding simplificado
- Documentación viva en el repo

### Negative

- Overhead inicial de configuración
- Curva de aprendizaje para el sistema
- Mantenimiento de múltiples archivos de configuración

### Neutral

- Requiere disciplina para mantener contextos actualizados
- Los agentes deben ser entrenados en el sistema

## References

- [Vibe Coding Agents README](../../README.md)
- [CORE.md](../../.ai/context/CORE.md)
- [Agent Definitions](../../.ai/agents/)
