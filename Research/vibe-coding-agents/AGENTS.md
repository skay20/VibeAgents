# AGENTS.md - OpenAI Codex Configuration

> Este archivo guía a OpenAI Codex en la navegación y trabajo con este codebase.

---

## 🎯 Descripción del Proyecto

<!-- Completar al inicializar -->
- **Nombre**: 
- **Tipo**: [web-app | api | mobile | data | infra]
- **Stack**: 
- **Estado**: [planning | development | production]

## 🏗️ Arquitectura

### Estructura de Carpetas

```
src/
├── components/     # Componentes UI
├── hooks/         # Custom React hooks
├── services/      # Lógica de negocio
├── stores/        # Estado global
├── types/         # TypeScript types
├── utils/         # Utilidades
└── lib/           # Configuración de libs
```

### Stack Tecnológico

```yaml
frontend:
  framework: ""
  language: ""
  styling: ""
  
backend:
  framework: ""
  language: ""
  database: ""
  
deployment:
  platform: ""
  ci_cd: ""
```

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

## 📋 Quality Gates

Antes de cualquier cambio:

1. [ ] Tests pasan: `npm test`
2. [ ] Lint limpio: `npm run lint`
3. [ ] Type check: `npm run typecheck`
4. [ ] Build exitoso: `npm run build`

## 🧪 Testing

- **Unit**: Vitest/Jest
- **Integration**: Supertest
- **E2E**: Playwright
- **Cobertura mínima**: 80%

## 🔒 Seguridad

- NUNCA commitear secrets
- Usar `.env.local` para variables locales
- Validar todo input de usuario
- Usar parametrización en queries

## 📝 Convenciones

### Nomenclatura
- `camelCase` para variables/funciones
- `PascalCase` para clases/interfaces
- `kebab-case` para archivos

### Commits
Conventional Commits obligatorio:
```
feat: nueva feature
fix: bug fix
docs: documentación
refactor: refactorización
test: tests
```

## 🤖 Agentes Disponibles

Este proyecto usa un sistema multi-agente. Los agentes están definidos en `.ai/agents/`:

| Agente | Descripción | Trigger |
|--------|-------------|---------|
| ASK | Análisis de requisitos | `/ask` |
| PLAN | Planificación técnica | `/plan` |
| BUILD | Implementación | `/build` |
| TEST | Testing y QA | `/test` |
| REVIEW | Code review | `/review` |
| RELEASE | Release y deploy | `/release` |

## 📚 Documentación

- [CORE.md](.ai/context/CORE.md) - Contexto fundamental
- [STANDARDS.md](.ai/context/STANDARDS.md) - Estándares de código
- [SECURITY.md](.ai/context/SECURITY.md) - Políticas de seguridad
- [TESTING.md](.ai/context/TESTING.md) - Guía de testing

## 🔗 Referencias

- [PRD](docs/PRD.md)
- [Arquitectura](docs/ARCHITECTURE.md)
- [Runbook](docs/RUNBOOK.md)

---

**Contexto cargado desde**: AGENTS.md
**Última actualización**: [FECHA]
