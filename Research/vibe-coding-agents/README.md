# 🚀 Vibe Coding Agents - Sistema Multi-Agente No-App-First

Sistema completo de agentes especializados para desarrollo asistido por IA, diseñado con el principio **No-App-First**: toda la orquestación vive en el repo mediante archivos de instrucciones, reglas y workflows.

## 📋 Índice

1. [Arquitectura del Sistema](#arquitectura-del-sistema)
2. [Agentes Disponibles](#agentes-disponibles)
3. [Flujo de Trabajo](#flujo-de-trabajo)
4. [Configuración por Herramienta](#configuración-por-herramienta)
5. [Uso Rápido](#uso-rápido)

## 🏗️ Arquitectura del Sistema

### Principio: Context Layering

El contexto se organiza en capas para evitar "context bloat":

| Capa | Archivo | Contenido | Estabilidad |
|------|---------|-----------|-------------|
| **L0 - Core** | `.ai/context/CORE.md` | Objetivo, cómo correr, quality gates, definición de terminado | Estable |
| **L1 - Standards** | `.ai/context/STANDARDS.md` | Estilo, testing, seguridad | Modular |
| **L2 - Architecture** | `docs/ARCHITECTURE.md` | ADRs y decisiones arquitectónicas | Referenciado |
| **L3 - Task Pack** | `.ai/logs/runs/*.md` | Contexto temporal por feature/PR | Temporal |

### Estructura del Repo

```text
.
├─ README.md
├─ docs/
│  ├─ PRD.md                    # Product Requirements Document
│  ├─ ARCHITECTURE.md           # Documentación arquitectónica
│  ├─ ADR/                      # Architecture Decision Records
│  └─ RUNBOOK.md                # Guía de operaciones
├─ .ai/
│  ├─ context/
│  │  ├─ CORE.md               # L0: Contexto core
│  │  ├─ STANDARDS.md          # L1: Estándares
│  │  ├─ SECURITY.md           # L1: Seguridad
│  │  └─ TESTING.md            # L1: Testing
│  ├─ agents/                   # Definición de agentes
│  │  ├─ ASK.md                # Agente de requisitos
│  │  ├─ PLAN.md               # Agente de planificación
│  │  ├─ BUILD.md              # Agente de implementación
│  │  ├─ TEST.md               # Agente de testing
│  │  ├─ REVIEW.md             # Agente de revisión
│  │  └─ RELEASE.md            # Agente de release
│  └─ logs/runs/               # Logs de ejecución
├─ (Codex) AGENTS.md
├─ (Claude) .claude/CLAUDE.md
├─ (Claude) .claude/rules/*.md
├─ (Gemini CLI) GEMINI.md
├─ (Gemini Code Assist) .gemini/config.yaml
├─ (Gemini Code Assist) .gemini/styleguide.md
├─ (Windsurf) .windsurf/workflows/*.md
├─ (Windsurf) .windsurf/rules/*.md
├─ (Cursor) .cursor/rules/*.md
├─ (Copilot) .github/copilot-instructions.md
└─ scripts/
   ├─ init-project.sh
   └─ log-run.sh
```

## 🤖 Agentes Disponibles

| Agente | Rol | Trigger | Output |
|--------|-----|---------|--------|
| **ASK** | Analista de requisitos | `/ask` o prompt inicial | PRD refinado, user stories |
| **PLAN** | Arquitecto/Planificador | `/plan` | Plan técnico, tareas, estimaciones |
| **BUILD** | Desarrollador | `/build [slice]` | Código implementado |
| **TEST** | QA Engineer | `/test` | Tests, cobertura, reporte |
| **REVIEW** | Code Reviewer | `/review` | Feedback, sugerencias |
| **RELEASE** | DevOps | `/release` | Deploy, changelog |

## 🔄 Flujo de Trabajo

```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│  INIT   │───→│   ASK   │───→│  PLAN   │───→│  BUILD  │───→│  TEST   │───→│ RELEASE │
│ /init   │    │  /ask   │    │  /plan  │    │ /build  │    │  /test  │    │ /release│
└─────────┘    └─────────┘    └─────────┘    └─────────┘    └─────────┘    └─────────┘
                    ↑              ↑              ↑              ↑
                    └──────────────┴──────────────┴──────────────┘
                                        │
                                   ┌─────────┐
                                   │  REVIEW │
                                   │ /review │
                                   └─────────┘
```

## 🛠️ Configuración por Herramienta

### OpenAI Codex
- **Archivo**: `AGENTS.md` en root
- **Carga automática**: Sí, al detectar el archivo
- **Scope**: Todo el repo
- **Comandos**: Natural language

### Claude Code
- **Archivo**: `.claude/CLAUDE.md` + `.claude/rules/*.md`
- **Carga automática**: Sí, jerárquica
- **Scope**: Directorio y subdirectorios
- **Comandos**: `/memory`, `/init`, `/compact`

### Gemini CLI
- **Archivo**: `GEMINI.md` (puede estar en `.gemini/`)
- **Carga automática**: Sí, jerárquica (global → project → subdir)
- **Scope**: Hasta 200 directorios
- **Comandos**: `/memory show`, `/memory refresh`

### Windsurf
- **Archivos**: `.windsurf/rules/*.md` + `.windsurf/workflows/*.md`
- **Carga automática**: Sí, con descubrimiento
- **Scope**: Workspace y subdirectorios
- **Comandos**: `/[workflow-name]`

### Cursor
- **Archivos**: `.cursor/rules/*.mdc`
- **Carga automática**: Sí, con globs
- **Scope**: Project rules (versioned)
- **Comandos**: `@ruleName` para incluir manual

### GitHub Copilot
- **Archivo**: `.github/copilot-instructions.md`
- **Carga automática**: Sí, al abrir repo
- **Scope**: Todo el repo
- **Referencias**: Aparece en "References" del chat

## 🚀 Uso Rápido

### Iniciar un proyecto

```bash
# 1. Clonar este repo de agentes
git clone <repo-url> vibe-coding-agents
cd vibe-coding-agents

# 2. Ejecutar script de inicialización
./scripts/init-project.sh

# 3. Seleccionar tu herramienta y empezar
```

### Comandos por herramienta

**Claude Code:**
```bash
claude
# Dentro de Claude:
/init          # Generar CLAUDE.md inicial
/ask "Crear una app de gestión de tareas"  # Iniciar con ASK agent
/plan          # Generar plan técnico
/build slice-1 # Implementar slice 1
/test          # Ejecutar tests
/review        # Revisar código
```

**Windsurf:**
```bash
# En Cascade:
/ask "Crear una app de gestión de tareas"
/plan
/build slice-1
/test
/review
/release
```

**Gemini CLI:**
```bash
gemini
# Dentro de Gemini:
/ask "Crear una app de gestión de tareas"
/plan
/build slice-1
/test
```

## 📚 Documentación Adicional

- [Agente ASK](.ai/agents/ASK.md) - Análisis de requisitos
- [Agente PLAN](.ai/agents/PLAN.md) - Planificación técnica
- [Agente BUILD](.ai/agents/BUILD.md) - Implementación
- [Agente TEST](.ai/agents/TEST.md) - Testing y QA
- [Agente REVIEW](.ai/agents/REVIEW.md) - Revisión de código
- [Agente RELEASE](.ai/agents/RELEASE.md) - Release y deploy

---

**Nota**: Este sistema está diseñado para ser "plug-and-play". Solo necesitas copiar los archivos relevantes a tu repo y empezar a usar los comandos.
