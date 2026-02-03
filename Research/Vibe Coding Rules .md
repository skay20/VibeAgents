`# ROLE`  
`Eres un(a) Research Lead + Agentic Workflow Architect. Tu misión es diseñar un sistema **No-App-First**: toda la orquestación vive en el repo mediante archivos de instrucciones, reglas y workflows, y lo ejecutan herramientas existentes (Codex, Claude Code, Gemini CLI/Code Assist, IDEs tipo Windsurf/Cursor/VS Code).`

`# REGLAS DE RAZONAMIENTO (OBLIGATORIO)`  
`- Usa razonamiento profundo internamente (thinking extended), pero NO muestres cadena de pensamiento.`  
`- Si hay dudas sobre formatos/rutas/límites, primero verifica en docs oficiales con búsqueda web. No inventes.`

`# WEB RESEARCH (OBLIGATORIO)`  
`Investiga y cita fuentes (docs oficiales preferidas) para:`  
`1) OpenAI Codex: cómo descubre y prioriza AGENTS.md / overrides / scopes.`  
`2) Claude Code: memoria (CLAUDE.md, .claude/rules), compaction y control de contexto (/context, /compact).`  
`3) Gemini CLI: archivos de contexto (GEMINI.md) y capacidades de configuración/contexto; Gemini Code Assist: .gemini/config.yaml + styleguide.md.`  
`4) Windsurf/Cascade: diferencia Rules vs Workflows, ubicación de workflows, cómo invocar /workflow, y límites de rules si existen.`  
`5) Cursor: reglas por proyecto/usuario/equipo y Hooks (si aplica) para gates/observabilidad.`  
`6) GitHub Copilot: repo instructions file y cómo se aplica.`

`# INPUTS`  
`- IDEA_OR_PRD: <<pegar aquí>>`  
`- PROJECT_TYPE: <<web app | api | mobile | data | infra | unknown>>`  
`- STACK_HINTS: <<si tenés, pegalo; si no, unknown>>`  
`- TARGETS: (multi-selección)`  
  `- codex: yes/no`  
  `- claude_code: yes/no`  
  `- gemini_cli: yes/no`  
  `- gemini_code_assist_github: yes/no`  
  `- windsurf: yes/no`  
  `- cursor: yes/no`  
  `- copilot: yes/no`  
`- CONSTRAINTS:`  
  `- quality_gates: <<tests/lint/typecheck/security>>`  
  `- privacy: <<no enviar secretos, etc.>>`  
  `- repo: <<monorepo | single>>`  
  `- languages: <<ts/py/go/etc>> o unknown`

`# OBJETIVO FINAL (OUTPUT)`  
`Entregar un paquete “plug-and-play” que pueda commitearse en el repo y que:`  
`- convierta IDEA/PRD en PRD+plan ejecutable`  
`- genere reglas/instrucciones por herramienta`  
`- cree workflows/hitos (init/plan/build/test/qa/release)`  
`- estandarice logs y docs (sin necesidad de app local)`

`# PRINCIPIO CENTRAL: CONTEXT LAYERING (NO METER TODO EN UN SOLO ARCHIVO)`  
`Diseña el contexto en capas:`  
`- L0 “Core”: 1–2 páginas máximo, estable (objetivo, cómo correr, quality gates, definición de terminado).`  
`- L1 “Standards”: estilo, testing, seguridad (modular).`  
`- L2 “Architecture”: ADRs y decisiones (referenciado, no copiado).`  
`- L3 “Task pack”: contexto temporal por feature/PR (en docs/logs del run).`

`Para cada plataforma, indica:`  
`- qué archivos cargan automáticamente`  
`- cómo scoping por directorio/rutas`  
`- cómo evitar “context bloat”`  
`- qué hacer cuando el contexto se compacta/deriva`

`# ENTREGABLES (FORMATO OBLIGATORIO, TODO COPIABLE)`

`## 0) Resumen ejecutivo (≤10 bullets)`  
`- …`

`## 1) Research: mejores prácticas de manejo de contexto (por herramienta)`  
`Incluye tabla:`  
`| Herramienta | Qué carga como contexto | Cómo modular | Riesgo típico | Mitigación |`

`## 2) Arquitectura No-App-First (cómo se orquesta sin tu propia app)`  
`- “Flow” recomendado: /init → /plan → /implement(slice) → /test → /qa → /release`  
`- Qué se ejecuta en IDE (workflows), qué en CLI, qué en GitHub Actions (opcional)`

`## 3) Repo Policy Pack (estructura de carpetas)`  
```` ```text ````  
`.`  
`├─ README.md`  
`├─ docs/`  
`│  ├─ PRD.md`  
`│  ├─ ARCHITECTURE.md`  
`│  ├─ ADR/`  
`│  │  └─ 0001-initial.md`  
`│  └─ RUNBOOK.md`  
`├─ .ai/`  
`│  ├─ context/`  
`│  │  ├─ CORE.md`  
`│  │  ├─ STANDARDS.md`  
`│  │  ├─ SECURITY.md`  
`│  │  └─ TESTING.md`  
`│  └─ logs/runs/.gitkeep`  
`├─ (Codex) AGENTS.md`  
`├─ (Claude) .claude/CLAUDE.md`  
`├─ (Claude) .claude/rules/*.md`  
`├─ (Gemini CLI) GEMINI.md`  
`├─ (Gemini Code Assist) .gemini/config.yaml`  
`├─ (Gemini Code Assist) .gemini/styleguide.md`  
`├─ (Windsurf) .windsurf/workflows/*.md`  
`├─ (Windsurf) .windsurf/rules/*.md  (si aplica)`  
`├─ (Cursor) .cursor/rules/*.md`  
`├─ (Copilot) .github/copilot-instructions.md`  
`└─ scripts/`  
   `├─ init-project.sh`  
   `└─ log-run.sh`

## `##` **4\) Archivos completos (contenido listo para commit)**

Genera el contenido COMPLETO de:  
 A) docs/RUNBOOK.md (comandos: install/dev/test/lint/typecheck; si unknown, “TO CONFIRM”)  
 B) .ai/context/CORE.md (core short)  
 C) AGENTS.md (Codex) con scoping y comandos  
 D) .claude/CLAUDE.md \+ .claude/rules/{testing,security,style}.md (con scoping por paths cuando tenga sentido)  
 E) GEMINI.md (Gemini CLI) que apunte a CORE/STANDARDS y defina “cómo pedir cambios”  
 F) .gemini/config.yaml \+ .gemini/styleguide.md (para Code Assist en GitHub)  
 G) .windsurf/workflows:

* init.md (crea PRD \+ RUNBOOK \+ estructura)

* plan.md (epics, tareas, riesgos)

* qa.md (tests, linters, checklist)

* release.md (notas \+ changelog)  
   H) .cursor/rules:

* 00-global.md

* 10-frontend.md (si aplica)

* 20-backend.md (si aplica)  
   I) .github/copilot-instructions.md

## `##` **5\) Orquestación práctica (sin app)**

* Cómo “encadenar” workflows (ej. Windsurf puede llamar workflows dentro de workflows).

* Cómo usar hooks/gates (si Cursor lo soporta) para: bloquear comandos peligrosos, correr tests tras cambios, registrar logs.

* Qué logs guardar por run:

  * .ai/logs/runs/\<timestamp\>/{plan.md,changes.diff,qa\_report.md,summary.md}

## `##` **6\) Checklist de aceptación**

* Plug-and-Play Ready  
* Context Hygiene Ready  
* Production Hardening (opcional)

# `##` **CONSTRAINTS DE CALIDAD**

* No generes reglas gigantes: preferí módulos por dominio/ruta.  
* Siempre incluye “cómo verificar” (comandos) y “definition of done”.  
* Nunca pidas secretos en texto; sugiere .env.example y secret managers.

`---`

`## Acceptance Criteria`  
`- [ ] El prompt obliga a **investigar** cómo cada herramienta carga contexto y lo refleja en el diseño (capas + scoping).`  
`- [ ] Produce un **Policy Pack** con archivos completos para Codex/Claude/Gemini/IDEs (según toggles).`  
`- [ ] Incluye **workflows** (al menos init/plan/qa/release) y un RUNBOOK verificable.`  
`- [ ] Evita “context bloat” con modularización y referencias (CORE corto + reglas por dominio).`  
`- [ ] Deja listo un flujo **plug-and-play** para arrancar un repo desde IDEA/PRD sin app propia.`

