# GitHub Copilot Instructions

> Instrucciones personalizadas para GitHub Copilot en este repositorio.

---

## 🎯 Sobre este Proyecto

<!-- Completar al inicializar -->

- **Tipo**: [web-app | api | mobile | data | infra]
- **Stack**: 
- **Estado**: [planning | development | production]

## 🚀 Comandos Comunes

```bash
# Instalación
npm install

# Desarrollo
npm run dev

# Build
npm run build

# Tests
npm run test

# Lint
npm run lint

# Type check
npm run typecheck
```

## 📋 Quality Gates (Obligatorios)

Antes de cualquier cambio:

1. ✅ Tests pasan: `npm test`
2. ✅ Lint limpio: `npm run lint`
3. ✅ Type check: `npm run typecheck`
4. ✅ Build exitoso: `npm run build`

## 🏗️ Arquitectura

### Estructura

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

### Principios

- **Simplicity First**: Soluciones simples
- **Readability Priority**: Código legible
- **Test-Driven Thinking**: Diseñar para testear

## 🧪 Testing

- **Framework**: Vitest/Jest
- **Cobertura mínima**: 80%
- **Patrón**: AAA (Arrange, Act, Assert)

## 🔒 Seguridad

- NO commitear secrets
- Validar input
- SQL parametrizado
- Manejar errores seguros

## 📝 Convenciones

### Nomenclatura
- `camelCase`: variables, funciones
- `PascalCase`: clases, interfaces
- `UPPER_SNAKE_CASE`: constantes
- `kebab-case`: archivos

### Commits
Conventional Commits:
```
feat: nueva feature
fix: bug fix
docs: documentación
refactor: refactorización
test: tests
```

## 🤖 Sistema Multi-Agente

Este proyecto usa agentes especializados en `.ai/agents/`:

| Agente | Descripción | Trigger |
|--------|-------------|---------|
| ASK | Análisis de requisitos | `/ask` |
| PLAN | Planificación técnica | `/plan` |
| BUILD | Implementación | `/build` |
| TEST | Testing | `/test` |
| REVIEW | Code review | `/review` |
| RELEASE | Release | `/release` |

## 📚 Documentación

- `.ai/context/CORE.md` - Contexto fundamental
- `.ai/context/STANDARDS.md` - Estándares de código
- `.ai/context/SECURITY.md` - Seguridad
- `.ai/context/TESTING.md` - Testing
- `docs/PRD.md` - Requisitos
- `docs/ARCHITECTURE.md` - Arquitectura

---

**Nota**: Estas instrucciones se aplican automáticamente a todas las interacciones con Copilot en este repositorio.
