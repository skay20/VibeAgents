# L0: CORE - Contexto Fundamental

> **Capa L0**: Estable, 1-2 páginas máximo. No modificar sin consenso del equipo.

---

## 🎯 Objetivo del Proyecto

<!-- Rellenar por el usuario al inicializar -->
**Estado**: [PENDIENTE DE DEFINIR]

```yaml
nombre: ""
descripcion: ""
tipo: [web-app | api | mobile | data | infra]
estado: [planning | development | production]
```

## 🚀 Cómo Correr el Proyecto

### Requisitos Previos
<!-- Listar dependencias necesarias -->
- [ ] Node.js >= 18
- [ ] Python >= 3.10
- [ ] Docker (opcional)

### Comandos Esenciales

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
```

## 🚪 Quality Gates (Definición de Terminado)

### Checklist de Calidad

| Gate | Criterio | Verificación |
|------|----------|--------------|
| **QG1** | Tests pasan | `npm test` → 0 fallos |
| **QG2** | Lint limpio | `npm run lint` → 0 errores |
| **QG3** | Type check | `npm run typecheck` → 0 errores |
| **QG4** | Build exitoso | `npm run build` → sin errores |
| **QG5** | Security scan | Sin vulnerabilidades críticas |

### Definición de Terminado (DoD)

Una tarea está **TERMINADA** cuando:

1. [ ] Código implementado y funcional
2. [ ] Tests unitarios escritos (cobertura > 80%)
3. [ ] Tests de integración (si aplica)
4. [ ] Documentación actualizada
5. [ ] Code review aprobado
6. [ ] QA gates pasan
7. [ ] Sin TODOs críticos en el código
8. [ ] CHANGELOG.md actualizado (si aplica)

## 🔒 Constraints y Políticas

### Seguridad
- **NUNCA** commitear secrets en el repo
- Usar `.env.local` para variables locales
- Rotar keys cada 90 días

### Privacidad
- No enviar datos PII a servicios externos sin consentimiento
- Anonimizar logs en producción

### Repo
- **Tipo**: [monorepo | single]
- **Estrategia de branching**: Git Flow / Trunk Based
- **Commits**: Conventional Commits obligatorio

## 🛠️ Stack Tecnológico

<!-- Completar según el proyecto -->

```yaml
frontend:
  framework: ""
  language: ""
  styling: ""

backend:
  framework: ""
  language: ""
  database: ""

infra:
  hosting: ""
  ci_cd: ""
  monitoring: ""
```

## 📞 Contactos y Recursos

| Rol | Contacto |
|-----|----------|
| Tech Lead | @... |
| Product Owner | @... |
| DevOps | @... |

### Links Importantes
- [Documentación técnica](./docs/ARCHITECTURE.md)
- [Runbook](./docs/RUNBOOK.md)
- [Board de tareas](...)
- [Staging URL](...)
- [Producción URL](...)

---

**Última actualización**: [FECHA]
**Versión**: 1.0.0
