# 📖 Guía Completa - Vibe Coding Agents

Guía detallada de uso del sistema multi-agente para desarrollo asistido por IA.

---

## 📋 Tabla de Contenidos

1. [Conceptos Fundamentales](#conceptos-fundamentales)
2. [Arquitectura del Sistema](#arquitectura-del-sistema)
3. [Los 6 Agentes](#los-6-agentes)
4. [Flujo de Trabajo](#flujo-de-trabajo)
5. [Configuración por Herramienta](#configuración-por-herramienta)
6. [Comandos y Triggers](#comandos-y-triggers)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## Conceptos Fundamentales

### ¿Qué es Vibe Coding?

Vibe coding es un paradigma de desarrollo donde los desarrolladores describen lo que quieren en lenguaje natural y los agentes de IA generan el código. El "vibe" se refiere a la sensación de fluidez y colaboración con la IA.

### ¿Por qué Multi-Agente?

En lugar de un único agente que hace todo, usamos agentes especializados:

| Ventaja | Descripción |
|---------|-------------|
| **Especialización** | Cada agente es experto en su dominio |
| **Calidad** | Revisión por pares (agentes) |
| **Escalabilidad** | Fácil agregar nuevos agentes |
| **Mantenibilidad** | Responsabilidades claras |

### Principio No-App-First

Toda la orquestación vive en el repositorio:

```
❌ App externa que controla todo
✅ Archivos de instrucciones en el repo
```

Ventajas:
- Versionado con git
- Sin dependencia de herramientas externas
- Reproducible entre equipos
- Auditabilidad

---

## Arquitectura del Sistema

### Context Layering

El contexto se organiza en capas para evitar "context bloat":

```
┌─────────────────────────────────────────────────────────┐
│  L3 - Task Pack                                         │
│  Contexto temporal por feature/PR                       │
│  .ai/logs/runs/*.md                                     │
├─────────────────────────────────────────────────────────┤
│  L2 - Architecture                                      │
│  ADRs y decisiones arquitectónicas                      │
│  docs/ARCHITECTURE.md, docs/ADR/*.md                    │
├─────────────────────────────────────────────────────────┤
│  L1 - Standards                                         │
│  Estilo, testing, seguridad                             │
│  .ai/context/STANDARDS.md, SECURITY.md, TESTING.md      │
├─────────────────────────────────────────────────────────┤
│  L0 - Core                                              │
│  Objetivo, cómo correr, quality gates                   │
│  .ai/context/CORE.md                                    │
└─────────────────────────────────────────────────────────┘
```

### Sistema de Archivos

```
.
├─ README.md
├─ docs/
│  ├─ PRD.md                    # Product Requirements
│  ├─ ARCHITECTURE.md           # Arquitectura
│  ├─ ADR/                      # Decision Records
│  └─ RUNBOOK.md                # Operaciones
├─ .ai/
│  ├─ context/                  # Contexto en capas
│  │  ├─ CORE.md               # L0
│  │  ├─ STANDARDS.md          # L1
│  │  ├─ SECURITY.md           # L1
│  │  └─ TESTING.md            # L1
│  ├─ agents/                   # Definición de agentes
│  │  ├─ ASK.md
│  │  ├─ PLAN.md
│  │  ├─ BUILD.md
│  │  ├─ TEST.md
│  │  ├─ REVIEW.md
│  │  └─ RELEASE.md
│  └─ logs/runs/               # Logs de ejecución
├─ AGENTS.md                   # OpenAI Codex
├─ .claude/                    # Claude Code
├─ GEMINI.md                   # Gemini CLI
├─ .gemini/                    # Gemini Code Assist
├─ .windsurf/                  # Windsurf
├─ .cursor/                    # Cursor
├─ .github/copilot-instructions.md  # GitHub Copilot
└─ scripts/
   ├─ init-project.sh
   └─ log-run.sh
```

---

## Los 6 Agentes

### 1. 🤔 ASK - Analista de Requisitos

**Rol**: Transformar ideas en especificaciones claras

**Trigger**: `/ask [descripción]`

**Input**:
- Descripción de la idea (puede ser vaga)
- Contexto del proyecto

**Output**:
- PRD refinado
- User Stories con criterios de aceptación
- Preguntas de clarificación
- Supuestos documentados

**Ejemplo**:
```
Usuario: /ask "Quiero una app de gestión de tareas"

ASK: "Entendido. Para ayudarte mejor, necesito clarificar:

1. ¿Es para uso personal o equipo?
2. ¿Necesita autenticación?
3. ¿Qué features son imprescindibles?
...

Mientras tanto, asumiré:
- App web para equipos
- Autenticación básica
- Features: CRUD tareas, asignación, estados"
```

### 2. 📋 PLAN - Arquitecto y Planificador

**Rol**: Crear plan técnico ejecutable

**Trigger**: `/plan`

**Input**:
- PRD del agente ASK
- Stack y constraints (CORE.md)

**Output**:
- Arquitectura propuesta
- Slices de implementación
- Tareas con estimaciones
- Dependencias y riesgos

**Slices típicos**:
1. Foundation - Setup y configuración
2. Domain - Modelos y lógica de negocio
3. API - Endpoints y validación
4. UI - Componentes y layout
5. Features - Implementación
6. Polish - Testing y refinamiento

### 3. 🔨 BUILD - Desarrollador

**Rol**: Implementar código de alta calidad

**Trigger**: `/build [slice-id]`

**Input**:
- Plan técnico
- Slice a implementar
- Estándares del proyecto

**Output**:
- Código implementado
- Tests unitarios
- Documentación de código

**Principios**:
- [SF] Código simple
- [RP] Legible
- [TDT] Testeable
- [ISA] Convenciones

### 4. 🧪 TEST - QA Engineer

**Rol**: Asegurar calidad mediante testing

**Trigger**: `/test`

**Input**:
- Código implementado
- User stories
- Plan de testing

**Output**:
- Reporte de tests
- Cobertura
- Bugs encontrados
- Validación de criterios

**Quality Gates**:
- Unit tests: 80% cobertura
- Integration tests: 60% cobertura
- Lint: 0 errores
- Type check: 0 errores

### 5. 👁️ REVIEW - Code Reviewer

**Rol**: Revisar código para calidad y estándares

**Trigger**: `/review`

**Input**:
- Código (diff)
- Estándares
- Contexto

**Output**:
- Feedback detallado
- Sugerencias
- Decisión: approve/request_changes

**Dimensiones**:
- Correctness
- Maintainability
- Testing
- Security
- Performance
- Style

### 6. 🚀 RELEASE - DevOps

**Rol**: Gestionar release y deploy

**Trigger**: `/release [environment]`

**Input**:
- Código aprobado
- Historial de cambios
- Configuración de deploy

**Output**:
- Changelog
- Versión bump
- Deploy ejecutado
- Monitoreo post-release

---

## Flujo de Trabajo

### Flujo Completo

```
┌─────────┐     ┌─────────┐     ┌─────────┐
│  INIT   │────→│   ASK   │────→│  PLAN   │
│ /init   │     │  /ask   │     │  /plan  │
└─────────┘     └─────────┘     └────┬────┘
                                     │
                                     ▼
┌─────────┐     ┌─────────┐     ┌─────────┐
│ RELEASE │←────│  TEST   │←────│  BUILD  │
│ /release│     │  /test  │     │ /build  │
└─────────┘     └────┬────┘     └────┬────┘
                     │               │
                     └───────┬───────┘
                             ▼
                       ┌─────────┐
                       │  REVIEW │
                       │ /review │
                       └─────────┘
```

### Handoffs

Cada agente pasa el control al siguiente con:

```
🔄 HANDOFF to [NEXT_AGENT]
- [Artifact]: [location]
- [Context]: [información relevante]
- [Notes]: [consideraciones]
```

---

## Configuración por Herramienta

### OpenAI Codex

**Archivo**: `AGENTS.md` (root)

```markdown
# AGENTS.md
## Project Overview
...
## Commands
...
## Quality Gates
...
```

**Carga**: Automática al detectar el archivo

### Claude Code

**Archivos**:
- `.claude/CLAUDE.md` - Contexto principal
- `.claude/rules/*.md` - Reglas específicas

**Comandos**:
- `/init` - Generar CLAUDE.md
- `/memory` - Editar memoria
- `/compact` - Compactar contexto

**Carga**: Jerárquica (global → project → directory)

### Gemini CLI

**Archivo**: `GEMINI.md` (o `.gemini/GEMINI.md`)

**Comandos**:
- `/memory show` - Ver contexto cargado
- `/memory refresh` - Recargar contexto

**Carga**: Jerárquica (global ~/.gemini/ → project → subdir)

### Windsurf

**Archivos**:
- `.windsurf/rules/*.md` - Reglas
- `.windsurf/workflows/*.md` - Workflows

**Comandos**:
- `/[workflow-name]` - Ejecutar workflow

**Carga**: Descubrimiento automático en workspace

### Cursor

**Archivos**:
- `.cursor/rules/*.mdc` - Reglas

**Comandos**:
- `@ruleName` - Incluir regla manualmente

**Carga**: Automática con globs

### GitHub Copilot

**Archivo**: `.github/copilot-instructions.md`

**Verificación**: Aparece en "References" del chat

---

## Comandos y Triggers

### Comandos Globales

| Comando | Agente | Descripción |
|---------|--------|-------------|
| `/init` | Setup | Inicializar proyecto |
| `/ask [idea]` | ASK | Analizar requisitos |
| `/plan` | PLAN | Planificación técnica |
| `/build [slice]` | BUILD | Implementar slice |
| `/test` | TEST | Ejecutar tests |
| `/review` | REVIEW | Code review |
| `/release [env]` | RELEASE | Release y deploy |

### Comandos Específicos por Agente

**ASK**:
- `/clarify` - Solicitar más info
- `/story [id]` - Ver user story
- `/prioritize` - Re-priorizar

**PLAN**:
- `/slice [id]` - Ver slice
- `/arch` - Ver arquitectura
- `/estimate` - Re-estimar
- `/risk` - Analizar riesgos

**BUILD**:
- `/fix [issue]` - Corregir bug
- `/refactor [comp]` - Refactorizar
- `/commit` - Sugerir commit

**TEST**:
- `/test unit` - Solo unit tests
- `/test integration` - Solo integration
- `/coverage` - Reporte de cobertura
- `/regression` - Tests de regresión
- `/bug [desc]` - Reportar bug

**REVIEW**:
- `/review [file]` - Review específico
- `/approve` - Aprobar
- `/request-changes` - Solicitar cambios
- `/nit [comment]` - Comentario menor

**RELEASE**:
- `/release staging` - Deploy a staging
- `/release production` - Deploy a prod
- `/rollback` - Ejecutar rollback
- `/changelog` - Generar changelog
- `/version [type]` - Bump versión

---

## Best Practices

### 1. Mantener Contexto Actualizado

```bash
# Después de cambios significativos
# Actualizar CORE.md, STANDARDS.md
```

### 2. Logs de Ejecución

```bash
# Usar script de logging
./scripts/log-run.sh [agent] [status] [notes]
```

### 3. Commits Atómicos

```bash
# Un commit por cambio lógico
git commit -m "feat: add user authentication"
git commit -m "test: add auth tests"
```

### 4. Documentar Decisiones

```bash
# Crear ADR para decisiones importantes
echo "docs/ADR/0002-decision-name.md"
```

### 5. Quality Gates Siempre

```bash
# Antes de cualquier handoff
npm run lint
npm run typecheck
npm run test
npm run build
```

---

## Troubleshooting

### Contexto No Carga

**Síntoma**: La IA no reconoce el proyecto

**Solución**:
1. Verificar ubicación de archivos
2. Recargar contexto:
   - Claude: Reiniciar sesión
   - Gemini: `/memory refresh`
   - Windsurf: Recargar ventana

### Quality Gates Fallan

**Síntoma**: Tests o lint fallan

**Solución**:
1. Leer errores cuidadosamente
2. Corregir issues
3. Re-ejecutar gates

### Agente No Responde

**Síntoma**: Comando no reconocido

**Solución**:
1. Verificar sintaxis del comando
2. Usar formato: `/comando [args]`
3. Referirse a definición del agente

### Handoff Falla

**Síntoma**: Agente siguiente no recibe contexto

**Solución**:
1. Verificar formato de handoff
2. Asegurar que artifacts existen
3. Documentar en log de ejecución

---

## Recursos Adicionales

- [README.md](README.md) - Overview del sistema
- [Agentes](.ai/agents/) - Definiciones de agentes
- [Contexto](.ai/context/) - Capas de contexto
- [Documentación](docs/) - PRD, Arquitectura, Runbook

---

**Versión**: 1.0.0
**Última actualización**: 2024
