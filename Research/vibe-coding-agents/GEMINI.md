# GEMINI.md - Gemini CLI Context

> Contexto persistente para Gemini CLI en este proyecto.

---

## 🎯 Sobre este Proyecto

```yaml
project:
  name: ""
  description: ""
  type: [web-app | api | mobile | data | infra]
  stack:
    frontend: ""
    backend: ""
    database: ""
  status: [planning | development | production]
```

## 🚀 Comandos del Proyecto

```bash
# Setup
npm install

# Desarrollo
npm run dev          # Servidor de desarrollo
npm run build        # Build producción

# Calidad
npm run test         # Tests
npm run lint         # Lint
npm run typecheck    # Type check
```

## 📋 Quality Gates

Antes de completar cualquier tarea:

1. ✅ `npm test` - Todos pasan
2. ✅ `npm run lint` - 0 errores
3. ✅ `npm run typecheck` - 0 errores
4. ✅ `npm run build` - Exitoso

## 🏗️ Estructura

```
src/
├── components/     # UI components
├── hooks/         # Custom hooks
├── services/      # Business logic
├── stores/        # State management
├── types/         # TypeScript types
├── utils/         # Utilities
└── lib/           # Library configs
```

## 🤖 Sistema de Agentes

Agentes especializados en `.ai/agents/`:

| Comando | Agente | Descripción |
|---------|--------|-------------|
| `/ask` | ASK | Analizar requisitos |
| `/plan` | PLAN | Planificación técnica |
| `/build [slice]` | BUILD | Implementar código |
| `/test` | TEST | Testing |
| `/review` | REVIEW | Code review |
| `/release` | RELEASE | Release |

## 📚 Documentación

- @/.ai/context/CORE.md - Contexto core
- @/.ai/context/STANDARDS.md - Estándares
- @/.ai/context/SECURITY.md - Seguridad
- @/.ai/context/TESTING.md - Testing
- @/docs/PRD.md - Requisitos
- @/docs/ARCHITECTURE.md - Arquitectura

## 🔒 Seguridad

- NO commitear secrets
- Usar `.env.local`
- Validar input
- SQL parametrizado

## 📝 Notas

<!-- Notas temporales -->

---

Para ver contexto cargado: `/memory show`
Para recargar: `/memory refresh`
