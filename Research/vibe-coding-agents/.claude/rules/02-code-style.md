# Rule: Code Style

**Applies to**: All TypeScript/JavaScript files

---

## Description

Convenciones de estilo de código para mantener consistencia.

## Rule

### Nomenclatura

```typescript
// Variables/funciones: camelCase
const userName = 'John';
function getUserById(id: string) {}

// Clases/interfaces: PascalCase
class UserService {}
interface UserProps {}

// Constantes: UPPER_SNAKE_CASE
const MAX_RETRY_COUNT = 3;

// Archivos: kebab-case
user-service.ts
api-client.test.ts
```

### Formato

- Indentación: 2 espacios
- Max line length: 100 caracteres
- Terminación de línea: LF
- Quotes: single
- Semicolons: siempre
- Trailing comma: es5

### Funciones

```typescript
// ✅ CORRECTO: Funciones pequeñas y enfocadas
function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// ❌ INCORRECTO: Funciones largas y complejas
function processOrder(order: Order) {
  // 100+ líneas de código
}
```

### Imports

```typescript
// Orden: externos → internos → relativos
import React from 'react';
import { useQuery } from '@tanstack/react-query';

import { Button } from '@/components/ui';
import { useAuth } from '@/hooks';

import { helper } from './utils';
```

### Documentación

```typescript
/**
 * Descripción breve de qué hace
 * @param param - Descripción del parámetro
 * @returns Descripción del retorno
 * @throws Cuándo lanza error
 */
function myFunction(param: Type): ReturnType {
  // Implementación
}
```

## Enforcement

- Usar auto-formatter (Prettier)
- Lint en pre-commit hook
