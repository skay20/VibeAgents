# Rule: Testing Requirements

**Applies to**: All files

---

## Description

Requisitos de testing para todo código nuevo o modificado.

## Rule

### Cobertura Mínima

| Tipo | Cobertura |
|------|-----------|
| Unit | 80% |
| Integration | 60% |
| E2E | Critical paths |

### Estructura de Tests

```typescript
// AAA Pattern: Arrange, Act, Assert
describe('FeatureName', () => {
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
    
    it('should throw [error] when [invalid condition]', () => {
      // Test de error
    });
  });
});
```

### Qué Testear

- [ ] Happy path
- [ ] Edge cases
- [ ] Error handling
- [ ] Null/undefined
- [ ] Límites de input
- [ ] Async/await

### Mocking

```typescript
// Mock de módulos
vi.mock('./api', () => ({
  fetchUser: vi.fn().mockResolvedValue({ id: 1 }),
}));

// Mock de funciones
const mockFn = vi.fn().mockReturnValue('value');
```

## Enforcement

- Tests junto con código (TDD preferido)
- No mergear sin tests
- Cobertura reportada en CI
