# Style Guide - Gemini Code Assist

Guía de estilo para código generado por Gemini Code Assist.

---

## Principios Generales

1. **Simplicity First**: Soluciones simples sobre complejas
2. **Readability**: Código legible y auto-documentado
3. **Consistency**: Seguir convenciones del proyecto
4. **Testability**: Diseñar para ser fácilmente testeable

## TypeScript/JavaScript

### Variables y Funciones

```typescript
// ✅ CORRECTO
const userName = 'John';
const isActive = true;
const userList: User[] = [];

function getUserById(id: string): User | null {
  return users.find(u => u.id === id) ?? null;
}

// ❌ INCORRECTO
const usrNm = 'John';
const active = 1;
const list = [];

function getUser(id) {
  return users.find(u => u.id == id);
}
```

### Clases e Interfaces

```typescript
// ✅ CORRECTO
interface UserProps {
  id: string;
  name: string;
  email: string;
}

class UserService {
  constructor(private repository: UserRepository) {}
  
  async findById(id: string): Promise<User | null> {
    return this.repository.findById(id);
  }
}

// ❌ INCORRECTO
interface userProps {
  ID: string;
  Name: string;
}

class user_service {
  constructor(repo) {
    this.repo = repo;
  }
}
```

### Async/Await

```typescript
// ✅ CORRECTO
async function fetchUsers(): Promise<User[]> {
  try {
    const response = await api.get('/users');
    return response.data;
  } catch (error) {
    logger.error('Failed to fetch users', error);
    throw new UserFetchError(error);
  }
}

// ❌ INCORRECTO
function fetchUsers() {
  return api.get('/users').then(r => r.data);
}
```

### Error Handling

```typescript
// ✅ CORRECTO
class DomainError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number = 500
  ) {
    super(message);
    this.name = this.constructor.name;
  }
}

async function processUser(userId: string): Promise<User> {
  if (!userId) {
    throw new ValidationError('User ID is required');
  }
  
  try {
    const user = await userService.findById(userId);
    if (!user) {
      throw new NotFoundError('User', userId);
    }
    return user;
  } catch (error) {
    if (error instanceof DomainError) {
      throw error;
    }
    logger.error('Unexpected error', error);
    throw new InternalError('Failed to process user');
  }
}
```

## React

### Componentes

```tsx
// ✅ CORRECTO: Función con tipos explícitos
interface ButtonProps {
  variant?: 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
  onClick?: () => void;
  disabled?: boolean;
}

export function Button({
  variant = 'primary',
  size = 'md',
  children,
  onClick,
  disabled = false,
}: ButtonProps) {
  return (
    <button
      className={cn(buttonVariants({ variant, size }))}
      onClick={onClick}
      disabled={disabled}
      type="button"
    >
      {children}
    </button>
  );
}

// ❌ INCORRECTO
function Button(props) {
  return <button onClick={props.onClick}>{props.children}</button>;
}
```

### Hooks

```typescript
// ✅ CORRECTO
export function useUsers() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  const fetchUsers = useCallback(async () => {
    setLoading(true);
    try {
      const data = await userApi.getAll();
      setUsers(data);
    } catch (err) {
      setError(err as Error);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  return { users, loading, error, refetch: fetchUsers };
}
```

## Testing

```typescript
// ✅ CORRECTO
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a user with valid data', async () => {
      // Arrange
      const userData = { name: 'John', email: 'john@example.com' };
      
      // Act
      const result = await userService.createUser(userData);
      
      // Assert
      expect(result).toHaveProperty('id');
      expect(result.email).toBe(userData.email);
    });
    
    it('should throw error for invalid email', async () => {
      const userData = { name: 'John', email: 'invalid' };
      
      await expect(userService.createUser(userData))
        .rejects
        .toThrow(ValidationError);
    });
  });
});
```

## Documentación

```typescript
/**
 * Calcula el total de una orden incluyendo impuestos
 * @param items - Lista de items de la orden
 * @param taxRate - Tasa de impuesto (ej: 0.16 para 16%)
 * @returns El total calculado
 * @throws Error si items está vacío
 * @example
 * ```ts
 * const total = calculateTotal([{ price: 100 }], 0.16);
 * // Returns: 116
 * ```
 */
function calculateTotal(items: OrderItem[], taxRate: number): number {
  if (items.length === 0) {
    throw new Error('Order must have at least one item');
  }
  const subtotal = items.reduce((sum, item) => sum + item.price, 0);
  return subtotal * (1 + taxRate);
}
```

---

**Nota**: Este style guide es complementario a los estándares del proyecto en `.ai/context/STANDARDS.md`.
