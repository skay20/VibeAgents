# Rule: Quality Gates

**Applies to**: All files

---

## Description

Quality gates obligatorios antes de cualquier commit o cambio.

## Rule

Antes de declarar cualquier tarea como "completada", DEBES:

1. **Ejecutar tests**: `npm test`
   - Todos los tests deben pasar
   - Cobertura mínima: 80%

2. **Ejecutar lint**: `npm run lint`
   - 0 errores
   - Warnings deben ser justificados

3. **Ejecutar type check**: `npm run typecheck`
   - 0 errores de TypeScript

4. **Ejecutar build**: `npm run build`
   - Build debe completarse exitosamente

## Enforcement

Si algún quality gate falla:
- NO declarar la tarea como completada
- Corregir los issues
- Volver a ejecutar los gates

## Output Format

Al completar una tarea, reporta:

```
✅ Quality Gates:
   - Tests: PASS (X tests, Y% coverage)
   - Lint: PASS (0 errors)
   - Type Check: PASS (0 errors)
   - Build: PASS
```
