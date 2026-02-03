# L1: TESTING - Estándares de Testing

> **Capa L1**: Estrategia y prácticas de testing.

---

## 🎯 Estrategia de Testing

### Pirámide de Tests

```
        /\
       /  \     E2E Tests (10%)
      /____\    - Playwright/Cypress
     /      \   - Flujos críticos de usuario
    /________\
   /          \  Integration Tests (30%)
  /            \ - APIs, DB, servicios
 /______________\
/                \ Unit Tests (60%)
                   - Lógica de negocio
                   - Funciones puras
```

## 🧪 Unit Testing

### Frameworks Recomendados

| Lenguaje | Framework |
|----------|-----------|
| TypeScript | Vitest / Jest |
| Python | pytest |
| Go | testing + testify |
| Rust | built-in |

### Patrones

```typescript
// AAA Pattern: Arrange, Act, Assert
describe('Feature', () => {
  describe('functionName', () => {
    it('should [expected behavior] when [condition]', () => {
      // Arrange
      const input = ...;
      const expected = ...;
      
      // Act
      const result = functionName(input);
      
      // Assert
      expect(result).toEqual(expected);
    });
  });
});
```

### Mocking

```typescript
// Vitest
import { vi } from 'vitest';

// Mock de módulo
vi.mock('./api', () => ({
  fetchUser: vi.fn().mockResolvedValue({ id: 1, name: 'John' }),
}));

// Mock de función
const mockFn = vi.fn();
mockFn.mockReturnValue('mocked');

// Spy
const spy = vi.spyOn(console, 'log');
```

## 🔗 Integration Testing

### API Testing

```typescript
// Supertest + Vitest
import request from 'supertest';
import { app } from '../app';

describe('POST /api/users', () => {
  it('should create a new user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'John', email: 'john@example.com' })
      .expect(201);
    
    expect(response.body).toHaveProperty('id');
    expect(response.body.email).toBe('john@example.com');
  });
});
```

### Database Testing

```typescript
// Testcontainers para DB real
import { PostgreSqlContainer } from '@testcontainers/postgresql';

let container: PostgreSqlContainer;
let db: Database;

beforeAll(async () => {
  container = await new PostgreSqlContainer().start();
  db = createDatabase(container.getConnectionUri());
});

afterAll(async () => {
  await container.stop();
});

beforeEach(async () => {
  await db.migrate.latest();
});

afterEach(async () => {
  await db.migrate.rollback();
});
```

## 🎭 E2E Testing

### Playwright

```typescript
// tests/e2e/auth.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Authentication', () => {
  test('user can login', async ({ page }) => {
    await page.goto('/login');
    await page.fill('[name="email"]', 'user@example.com');
    await page.fill('[name="password"]', 'password');
    await page.click('button[type="submit"]');
    
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('h1')).toContainText('Welcome');
  });
});
```

### Page Object Model

```typescript
// tests/pages/LoginPage.ts
export class LoginPage {
  constructor(private page: Page) {}
  
  async goto() {
    await this.page.goto('/login');
  }
  
  async login(email: string, password: string) {
    await this.page.fill('[name="email"]', email);
    await this.page.fill('[name="password"]', password);
    await this.page.click('button[type="submit"]');
  }
  
  async expectLoggedIn() {
    await expect(this.page).toHaveURL('/dashboard');
  }
}
```

## 📊 Cobertura

### Objetivos

| Tipo | Objetivo | Mínimo |
|------|----------|--------|
| Statements | 90% | 80% |
| Branches | 85% | 75% |
| Functions | 90% | 80% |
| Lines | 90% | 80% |

### Configuración Vitest

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        statements: 80,
        branches: 75,
        functions: 80,
        lines: 80,
      },
      exclude: [
        'node_modules/',
        'tests/',
        '**/*.d.ts',
        '**/*.config.*',
      ],
    },
  },
});
```

## 🔄 Testing en CI/CD

### GitHub Actions

```yaml
# .github/workflows/test.yml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run linter
        run: npm run lint
        
      - name: Run type check
        run: npm run typecheck
        
      - name: Run unit tests
        run: npm run test:unit -- --coverage
        
      - name: Run integration tests
        run: npm run test:integration
        
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

## 🐛 Debugging Tests

### VS Code Launch Config

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Debug Current Test",
      "program": "${workspaceFolder}/node_modules/vitest/vitest.mjs",
      "args": ["run", "${relativeFile}"],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen"
    }
  ]
}
```

---

**Recuerda**: Tests son documentación ejecutable. Mantenlos claros y actualizados.
