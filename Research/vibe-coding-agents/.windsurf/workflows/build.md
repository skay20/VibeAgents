# Workflow: BUILD

Implement a slice following the technical plan.

---

## Trigger

`/build [slice-id]`

## Steps

### 1. Read Context

- `docs/PLAN.md` - Technical plan
- Slice definition
- Existing code (if any)
- `.ai/context/STANDARDS.md`

### 2. Plan Implementation

Before writing code:

1. Understand what needs to be built
2. Identify files to create/modify
3. Plan tests to write
4. Check for reusable components

### 3. Implement Code

Follow principles:
- [SF] Keep it simple
- [RP] Readable code
- [TDT] Write tests alongside
- [ISA] Follow conventions

### 4. Write Tests

```typescript
// AAA Pattern
describe('Feature', () => {
  it('should work correctly', () => {
    // Arrange
    // Act
    // Assert
  });
});
```

### 5. Run Quality Gates

```bash
npm run lint
npm run typecheck
npm run test
npm run build
```

### 6. Document

Add JSDoc/TSDoc to public APIs:

```typescript
/**
 * Description
 * @param param - Description
 * @returns Description
 */
function myFunction(param: Type): ReturnType {}
```

### 7. Update Status

Mark tasks as complete in plan.

### 8. Log the Run

Create `.ai/logs/runs/build-[slice-id]-[timestamp].md`

## Output

### If successful:

```
✅ BUILD Workflow Complete

📁 Files created/modified:
   - src/...
   - tests/...

✅ Quality Gates:
   - Tests: PASS (X tests, Y% coverage)
   - Lint: PASS
   - Type Check: PASS
   - Build: PASS

📊 Progress:
   - Slice S-001: 100% complete
   - Tasks: X/Y completed

Next: Run `/test` for QA validation
```

### If quality gates fail:

```
❌ BUILD Workflow - Issues Found

⚠️ Quality Gates:
   - Tests: FAIL (X failed)
   - Lint: FAIL (Y errors)
   - Type Check: FAIL (Z errors)

🔧 Fix required before proceeding
```
