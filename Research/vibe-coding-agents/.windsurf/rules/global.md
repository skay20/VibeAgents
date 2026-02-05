# Global Rules - Windsurf

> Reglas globales para Cascade en este proyecto.

---

## Principios

- [SF] **Simplicity First**: Soluciones simples sobre complejas
- [RP] **Readability Priority**: Código legible
- [DM] **Dependency Minimalism**: Sin nuevas deps sin aprobación
- [ISA] **Industry Standards**: Seguir convenciones del lenguaje
- [SD] **Strategic Documentation**: Documentar lógica compleja
- [TDT] **Test-Driven Thinking**: Diseñar para testear

## Quality Gates (Obligatorios)

Antes de cualquier cambio:

1. ✅ `npm test` - Todos pasan
2. ✅ `npm run lint` - 0 errores
3. ✅ `npm run typecheck` - 0 errores
4. ✅ `npm run build` - Exitoso

## Estructura del Proyecto

```
src/
├── components/     # UI components
│   ├── ui/        # Componentes base
│   └── features/  # Componentes de feature
├── hooks/         # Custom hooks
├── services/      # Business logic
├── stores/        # State management
├── types/         # TypeScript types
├── utils/         # Utilities
└── lib/           # Library configs
```

## Convenciones

### Nomenclatura
- `camelCase`: variables, funciones
- `PascalCase`: clases, interfaces, componentes
- `UPPER_SNAKE_CASE`: constantes
- `kebab-case`: archivos

### Formato
- Indentación: 2 espacios
- Max line: 100 caracteres
- Quotes: single
- Semicolons: siempre

## Seguridad

- NO commitear secrets
- Validar input
- SQL parametrizado
- Manejar errores

## Testing

- Cobertura mínima: 80%
- AAA Pattern: Arrange, Act, Assert
- Tests junto con código

## Sistema de Agentes

| Comando | Agente |
|---------|--------|
| `/ask` | ASK |
| `/plan` | PLAN |
| `/build [slice]` | BUILD |
| `/test` | TEST |
| `/review` | REVIEW |
| `/release` | RELEASE |

## Documentación

- `.ai/context/CORE.md` - Contexto core
- `.ai/context/STANDARDS.md` - Estándares
- `docs/PRD.md` - Requisitos
- `docs/ARCHITECTURE.md` - Arquitectura
