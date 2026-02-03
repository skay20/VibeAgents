# L1: STANDARDS - Estándares de Código

> **Capa L1**: Modular, puede dividirse en archivos separados. Actualizar según evolución del proyecto.

---

## 📝 Estilo de Código

### Principios Generales

| Principio | Abbr | Descripción |
|-----------|------|-------------|
| **Simplicity First** | [SF] | Siempre elegir la solución más simple |
| **Readability Priority** | [RP] | El código debe ser inmediatamente comprensible |
| **Dependency Minimalism** | [DM] | Sin nuevas dependencias sin aprobación explícita |
| **Industry Standards** | [ISA] | Seguir convenciones establecidas del lenguaje/framework |
| **Strategic Documentation** | [SD] | Documentar solo lógica compleja o funciones críticas |
| **Test-Driven Thinking** | [TDT] | Diseñar código para ser fácilmente testeable |

### Convenciones de Nomenclatura

```
# Variables/Funciones: camelCase
const userName = "..."
function getUserById() {}

# Clases/Interfaces: PascalCase
class UserService {}
interface UserProps {}

# Constantes: UPPER_SNAKE_CASE
const MAX_RETRY_COUNT = 3

# Archivos: kebab-case
user-service.ts
api-client.test.ts
```

### Formato

```yaml
indentacion: 2 espacios
max_line_length: 100
terminacion_linea: LF
quotes: single (para JS/TS)
semicolons: true
trailing_comma: es5
```

## 🧪 Testing Standards

### Pirámide de Tests

```
    /\
   /  \     E2E (10%)
  /____\
 /      \   Integration (30%)
/________\
           Unit (60%)
```

### Cobertura Mínima

| Tipo | Cobertura | Descripción |
|------|-----------|-------------|
| Unit | 80% | Lógica de negocio pura |
| Integration | 60% | APIs, DB, servicios externos |
| E2E | Critical paths | Flujos de usuario principales |

### Estructura de Tests

```typescript
// AAA Pattern: Arrange, Act, Assert
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a user with valid data', () => {
      // Arrange
      const userData = { name: 'John', email: 'john@example.com' };
      
      // Act
      const result = userService.createUser(userData);
      
      // Assert
      expect(result).toHaveProperty('id');
      expect(result.email).toBe(userData.email);
    });
    
    it('should throw error for invalid email', () => {
      // Test de error
    });
  });
});
```

## 🔒 Security Standards

### OWASP Top 10 - Checklist

- [ ] **Injection**: Usar parametrización en queries
- [ ] **Broken Auth**: Implementar JWT con refresh tokens
- [ ] **Sensitive Data**: Encriptar en tránsito (TLS) y reposo
- [ ] **XXE**: Deshabilitar entidades externas en XML parsers
- [ ] **Broken Access**: Validar permisos en cada endpoint
- [ ] **Security Misconfig**: Remover headers sensibles, usar Helmet
- [ ] **XSS**: Sanitizar input, usar CSP headers
- [ ] **Insecure Deserialization**: Validar schemas, no usar eval()
- [ ] **Vulnerable Components**: Mantener dependencias actualizadas
- [ ] **Insufficient Logging**: Loggear eventos de seguridad

### Secrets Management

```bash
# ✅ CORRECTO
DATABASE_URL=${DATABASE_URL}  # .env.local

# ❌ INCORRECTO
DATABASE_URL=postgres://user:password@host:5432/db  # NUNCA en código
```

## 🏗️ Arquitectura Standards

### Estructura de Carpetas

```
src/
├── components/          # Componentes UI (presentacionales)
│   ├── ui/             # Componentes base (Button, Input)
│   └── features/       # Componentes de feature
├── hooks/              # Custom React hooks
├── services/           # Lógica de negocio, APIs
├── stores/             # Estado global (Zustand, Redux)
├── types/              # TypeScript types/interfaces
├── utils/              # Funciones utilitarias
└── lib/                # Configuración de librerías
```

### Principios SOLID

| Principio | Aplicación |
|-----------|------------|
| **S**ingle Responsibility | Un componente = una responsabilidad |
| **O**pen/Closed | Extender con composición, no modificar |
| **L**iskov Substitution | Interfaces consistentes |
| **I**nterface Segregation | Interfaces pequeñas y específicas |
| **D**ependency Inversion | Depender de abstracciones |

### Patrones Recomendados

- **Container/Presentational**: Separar lógica de UI
- **Custom Hooks**: Extraer lógica reutilizable
- **Compound Components**: Componentes que trabajan juntos
- **Render Props**: Para flexibilidad (legacy)
- **Higher-Order Components**: Para cross-cutting concerns

## 🔄 Git Standards

### Conventional Commits

```
<type>(<scope>): <subject>

[body]

[footer]
```

**Types:**
- `feat`: Nueva feature
- `fix`: Bug fix
- `docs`: Documentación
- `style`: Formato (sin cambios de código)
- `refactor`: Refactorización
- `test`: Tests
- `chore`: Tareas de mantenimiento

**Ejemplos:**
```
feat(auth): add OAuth2 login with Google
fix(api): resolve null pointer in user service
docs(readme): update installation instructions
```

### Branching Strategy

```
main
  └── develop
       ├── feature/user-authentication
       ├── feature/payment-integration
       └── bugfix/login-redirect
```

## 📊 Performance Standards

### Métricas Objetivo

| Métrica | Objetivo | Máximo |
|---------|----------|--------|
| First Contentful Paint | < 1.8s | 3s |
| Largest Contentful Paint | < 2.5s | 4s |
| Time to Interactive | < 3.8s | 7s |
| Bundle Size (initial) | < 200KB | 500KB |

### Checklist de Performance

- [ ] Lazy loading de rutas/componentes
- [ ] Optimización de imágenes
- [ ] Code splitting
- [ ] Minificación y compresión
- [ ] CDN para assets estáticos
- [ ] Caching strategy

---

**Referencias:**
- @./SECURITY.md - Estándares de seguridad detallados
- @./TESTING.md - Guía completa de testing
