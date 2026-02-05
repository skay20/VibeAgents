# VibeAgents Quickstart Guide

## 1) Que es este repositorio
Este repositorio es un sistema no-app-first para convertir un PRD en ejecucion guiada por agentes, con trazabilidad por archivos.

Single source of truth operativo:
- Reglas y comportamiento: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/CONSTITUTION.md`
- Configuracion de features: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/settings.json`
- Contexto base: `/Users/matiassouza/Desktop/Projects/VibeAgents/.ai/context/`
- Orquestacion y artefactos: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/`

Nota: este archivo esta pensado para este proyecto y no debe regenerarse automaticamente cuando uses esta base para otros repos.

## 2) Flujo rapido (5 minutos)
1. Validar que estas en la raiz del repo:
```bash
pwd
```
2. Revisar settings actuales:
```bash
cat /Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/settings.json
```
3. Elegir run mode por variable de entorno (opcional pero recomendado):
```bash
export AGENTIC_RUN_MODE=AgentX
```
Opciones:
- `AgentX`: minimo de preguntas, mayor autonomia.
- `AgentL`: balanceado.
- `AgentM`: mas explicacion y checkpoints.
4. Iniciar un run y guardar `run_id`:
```bash
AGENTIC_TOOL=codex /Users/matiassouza/Desktop/Projects/VibeAgents/scripts/start-run.sh
```
5. Entregar PRD al asistente y responder calibracion minima.
6. Verificar run:
```bash
/Users/matiassouza/Desktop/Projects/VibeAgents/scripts/verify.sh
```

## 3) Mapa de arquitectura operativa
Capas:
- L0 bootstrap: `/Users/matiassouza/Desktop/Projects/VibeAgents/.ai/context/BOOTSTRAP.md`
- L1 standards: `/Users/matiassouza/Desktop/Projects/VibeAgents/.ai/context/CORE.md`, `/Users/matiassouza/Desktop/Projects/VibeAgents/.ai/context/STANDARDS.md`, `/Users/matiassouza/Desktop/Projects/VibeAgents/.ai/context/SECURITY.md`, `/Users/matiassouza/Desktop/Projects/VibeAgents/.ai/context/TESTING.md`
- L2 arquitectura: `/Users/matiassouza/Desktop/Projects/VibeAgents/docs/ARCHITECTURE.md`, `/Users/matiassouza/Desktop/Projects/VibeAgents/docs/ADR/`
- L3 run artifacts: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/`

Regla de precedencia:
1. Instruccion del usuario actual.
2. `docs/PRD.md`.
3. Contexto y constitucion.

## 4) Agentes (que hace cada uno)
Catalogo completo:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/AGENTS_CATALOG.md`

Core de operacion:
- Orquestador: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/agents/god_orchestrator.md`
- Intent: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/agents/intent_translator.md`
- Planner: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/agents/planner.md`
- Implementer: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/agents/implementer.md`
- QA/Security: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/agents/qa_reviewer.md`, `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/agents/security_reviewer.md`
- Mantenimiento: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/agents/repo_maintainer.md`

Como saber si realmente se usaron:
- Eventos: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/metrics/<run_id>/events.jsonl`
- Metricas por agente: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/metrics/<run_id>/<agent_id>.json`
- Reporte consolidado: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/agent_performance_report.md`

## 5) Settings criticos (on/off)
Archivo:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/settings.json`

Bloques importantes:
- `settings.run_mode`: comportamiento de autonomia.
- `settings.startup`: velocidad de arranque y numero maximo de preguntas iniciales.
- `settings.telemetry`: captura de eventos, preguntas y tokens.
- `settings.automation`: ejecucion automatica de scripts de logging.
- `settings.checks`: preflight y controles npm/dev.
- `settings.validation`: validaciones duras como `enforce_agent_id`.

Preset recomendado para velocidad:
- `settings.startup.profile=fast`
- `settings.startup.ask_only_missing=true`
- `settings.startup.max_initial_questions=3`

Preset recomendado para maximo tracking:
- `settings.telemetry.enabled=true`
- `settings.telemetry.events=true`
- `settings.telemetry.questions=true`
- `settings.telemetry.questions_log=true`
- `settings.automation.run_scripts=true`

## 6) Telemetria y trazabilidad
Objetivo: saber que se ejecuto, cuando, por quien, y cuanto duro.

Rutas clave:
- Estado del run: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/state/<run_id>.json`
- Eventos: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/metrics/<run_id>/events.jsonl`
- Preguntas y respuestas: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/questions_log.md`
- Decisiones: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/decisions.md`
- Diff y QA: `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/diff_summary.md`, `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/qa_report.md`

Si faltan logs:
1. Verifica que `settings.telemetry.enabled=true`.
2. Verifica que `settings.automation.run_scripts=true`.
3. Verifica `AGENTIC_TOOL` y `agent_id` valido.

## 7) Preflight (evitar sorpresas de npm/dev)
Comando:
```bash
/Users/matiassouza/Desktop/Projects/VibeAgents/scripts/preflight.sh <run_id> <project_root>
```

Salida esperada:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/preflight_report.md`

Que valida:
- Instalacion de dependencias.
- Arranque de `dev` con timeout configurable.
- Diagnostico explicito para errores de red/registry y dependencias no resolubles.

Uso recomendado:
- Ejecutar antes de cerrar una fase de implementacion web app.
- Bloquear release si preflight falla y no hay waiver explicito.

## 8) CI y quality gates
Workflow:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.github/workflows/node-ci.yml`

Que corre (si hay `package.json`):
- Install (`npm ci`/`pnpm install --frozen-lockfile`/`yarn install --frozen-lockfile`)
- `lint` (si script existe)
- `typecheck` (si script existe)
- `build` (si script existe)

Verificacion local de repo:
```bash
/Users/matiassouza/Desktop/Projects/VibeAgents/scripts/verify.sh
```

## 9) Troubleshooting rapido
Problema: demasiadas preguntas al inicio.
- Ajustar `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/settings.json`:
  - `startup.profile=fast`
  - `startup.max_initial_questions=1..3`
  - `startup.ask_only_missing=true`

Problema: solo aparece `codex` en metrica.
- Confirmar que cada agente llama `log-metrics.sh` con `agent_id` real.
- Confirmar `validation.enforce_agent_id` y que los ids coinciden con archivos en `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/agents/`.

Problema: `npm install` falla por red en entorno restringido.
- Ejecutar preflight en entorno con red.
- Revisar reporte de preflight y registrar waiver si aplica.

Problema: PRD incompleto bloquea.
- Completar campos criticos o responder preguntas de calibracion.
- Mantener consistencia con constitucion y ownership policy.

## 10) Ejemplo de corrida
1. Iniciar:
```bash
AGENTIC_TOOL=codex /Users/matiassouza/Desktop/Projects/VibeAgents/scripts/start-run.sh
```
2. Guardar `run_id` devuelto.
3. Entregar PRD y responder calibracion.
4. Revisar:
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/state/<run_id>.json`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/artifacts/<run_id>/decisions.md`
- `/Users/matiassouza/Desktop/Projects/VibeAgents/.agentic/bus/metrics/<run_id>/events.jsonl`
5. Cerrar con:
```bash
/Users/matiassouza/Desktop/Projects/VibeAgents/scripts/verify.sh
```

## 11) Checklist final
- PRD cargado y calibracion resuelta.
- Run mode documentado.
- Artefactos de run generados.
- Logs de eventos y preguntas presentes (si telemetry on).
- Preflight ejecutado para web app.
- `scripts/verify.sh` en verde.
- Changelog actualizado si hubo cambios de reglas/prompts.

