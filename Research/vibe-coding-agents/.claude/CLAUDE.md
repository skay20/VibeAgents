# CLAUDE.md - Claude Code Project Memory

> Este archivo contiene el contexto persistente para Claude Code en este proyecto.

---

## 🎯 Contexto del Proyecto

<!-- Completar con /init o manualmente -->

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

## 🚀 Comandos Esenciales

```bash
# Setup
npm install

# Development
npm run dev          # Iniciar servidor de desarrollo
npm run build        # Build de producción

# Quality
npm run test         # Ejecutar tests
npm run lint         # Linting
npm run typecheck    # Type checking

# Otros
npm run db:migrate   # Migraciones de DB
npm run db:seed      # Seed data
```

## 📋 Quality Gates (Obligatorios)

Todo código debe pasar:

1. ✅ Tests: `npm test` (0 fallos)
2. ✅ Lint: `npm run lint` (0 errores)
3. ✅ Types: `npm run typecheck` (0 errores)
4. ✅ Build: `npm run build` (exitoso)

## 🏗️ Arquitectura

### Estructura

```
src/
├── components/     # UI components (React/Vue/etc)
│   ├── ui/        # Componentes base
│   └── features/  # Componentes de feature
├── hooks/         # Custom hooks
├── services/      # Business logic, API calls
├── stores/        # State management
├── types/         # TypeScript definitions
├── utils/         # Utilities
└── lib/           # Library configs
```

### Principios

- [SF] Simplicity First - soluciones simples
- [RP] Readability Priority - código legible
- [DM] Dependency Minimalism - pocas deps
- [TDT] Test-Driven Thinking - diseñar para testear

## 🔒 Seguridad

- NO commitear secrets
- Usar `.env.local`
- Validar input
- SQL parametrizado

## 🧪 Testing

```typescript
// AAA Pattern
describe('Feature', () => {
  it('should do something', () => {
    // Arrange
    // Act
    // Assert
  });
});
```

## 🤖 Sistema Multi-Agente

Este proyecto usa agentes especializados en `.ai/agents/`:

| Comando | Agente | Descripción |
|---------|--------|-------------|
| `/ask` | ASK | Analizar requisitos |
| `/plan` | PLAN | Planificación técnica |
| `/build [slice]` | BUILD | Implementar código |
| `/test` | TEST | Ejecutar tests |
| `/review` | REVIEW | Code review |
| `/release` | RELEASE | Release y deploy |

## 📚 Documentación

- @/.ai/context/CORE.md - Contexto core
- @/.ai/context/STANDARDS.md - Estándares
- @/.ai/context/SECURITY.md - Seguridad
- @/.ai/context/TESTING.md - Testing
- @/docs/PRD.md - Requisitos
- @/docs/ARCHITECTURE.md - Arquitectura

## 📝 Notas

<!-- Espacio para notas temporales -->

---

**Memory loaded from**: .claude/CLAUDE.md
**Last updated**: [FECHA]

Para actualizar: `/memory` o `# nueva regla`
