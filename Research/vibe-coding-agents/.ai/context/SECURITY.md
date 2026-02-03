# L1: SECURITY - Estándares de Seguridad

> **Capa L1**: Políticas de seguridad específicas del proyecto.

---

## 🔐 Política de Secrets

### NUNCA commitear:

- Contraseñas
- API Keys
- Tokens de acceso
- Certificados privados
- Connection strings con credenciales

### Gestión de Secrets

```bash
# Desarrollo local: .env.local (gitignored)
# Staging/Prod: Secret manager (AWS Secrets Manager, Vault, etc.)

# Ejemplo .env.local
DATABASE_URL=postgresql://localhost:5432/mydb
API_KEY=sk_test_...
JWT_SECRET=your-secret-key
```

### Pre-commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    hooks:
      - id: detect-secrets
```

## 🛡️ Headers de Seguridad

### Configuración Recomendada

```javascript
// Helmet.js configuration
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true,
  },
}));
```

## 🔑 Autenticación y Autorización

### JWT Best Practices

```typescript
// Configuración segura de JWT
const jwtConfig = {
  algorithm: 'HS256',      // O RS256 para asimetría
  expiresIn: '15m',        // Access token corto
  issuer: 'your-app',
  audience: 'your-api',
};

// Refresh token separado
const refreshConfig = {
  expiresIn: '7d',
  httpOnly: true,
  secure: true,
  sameSite: 'strict',
};
```

### RBAC (Role-Based Access Control)

```typescript
// Definición de roles
enum Role {
  USER = 'user',
  ADMIN = 'admin',
  SUPER_ADMIN = 'super_admin',
}

// Permisos por recurso
const permissions = {
  users: {
    read: [Role.USER, Role.ADMIN, Role.SUPER_ADMIN],
    write: [Role.ADMIN, Role.SUPER_ADMIN],
    delete: [Role.SUPER_ADMIN],
  },
};
```

## 📝 Input Validation

### Sanitización

```typescript
import { z } from 'zod';

// Schema de validación
const userSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2).max(100),
  age: z.number().int().min(0).max(150),
});

// Uso
const validated = userSchema.parse(req.body);
```

### SQL Injection Prevention

```typescript
// ✅ CORRECTO: Parametrización
const result = await db.query(
  'SELECT * FROM users WHERE id = $1',
  [userId]
);

// ❌ INCORRECTO: Concatenación
const result = await db.query(`SELECT * FROM users WHERE id = ${userId}`);
```

## 🔍 Security Scanning

### Dependencias

```bash
# npm audit
npm audit
npm audit fix

# Snyk
snyk test
snyk monitor
```

### Código

```bash
# Semgrep
semgrep --config=auto .

# CodeQL (GitHub Actions)
```

## 🚨 Incident Response

### Checklist de Respuesta

1. **Detectar**: Identificar el incidente
2. **Contener**: Limitar el alcance
3. **Erradicar**: Eliminar la causa
4. **Recuperar**: Restaurar servicios
5. **Lecciones**: Documentar y mejorar

### Contactos de Emergencia

| Rol | Contacto | Escalación |
|-----|----------|------------|
| Security Lead | @... | +1h |
| CTO | @... | +4h |
| Legal | @... | Si hay data breach |

---

**Revisión mensual obligatoria**
