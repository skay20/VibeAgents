# Workflow: TEST

Execute comprehensive testing and QA validation.

---

## Trigger

`/test`

## Steps

### 1. Analyze Code

Review:
- Code implemented
- User stories criteria
- Test coverage

### 2. Run Test Suite

```bash
# Unit tests
npm run test:unit

# Integration tests
npm run test:integration

# E2E tests (if applicable)
npm run test:e2e
```

### 3. Static Analysis

```bash
# Lint
npm run lint

# Type check
npm run typecheck

# Security scan
npm audit
```

### 4. Coverage Report

```bash
npm run test:coverage
```

### 5. Validate Acceptance Criteria

For each user story:
- [ ] Criteria met
- [ ] Edge cases covered
- [ ] Error handling tested

### 6. Find Bugs

Document any issues:

```yaml
bugs:
  - id: "BUG-001"
    severity: critical|high|medium|low
    description: ""
    reproduction: ""
    expected: ""
    actual: ""
```

### 7. Create Report

Generate test report:

```yaml
test_report:
  summary:
    total_tests: 0
    passed: 0
    failed: 0
    coverage: 0%
    
  quality_gates:
    - name: "Unit Tests"
      status: pass|fail
    - name: "Integration Tests"
      status: pass|fail
    - name: "Lint"
      status: pass|fail
    - name: "Type Check"
      status: pass|fail
      
  bugs: []
  
  recommendations: []
```

### 8. Log the Run

Create `.ai/logs/runs/test-[timestamp].md`

## Output

### If all pass:

```
✅ TEST Workflow Complete - All Pass

📊 Test Results:
   - Unit: X/Y passed
   - Integration: A/B passed
   - Coverage: Z%

✅ Quality Gates: ALL PASS

🐛 Bugs Found: 0

Next: Run `/review` for code review
```

### If issues found:

```
⚠️ TEST Workflow Complete - Issues Found

📊 Test Results:
   - Unit: X/Y passed
   - Failed tests: [list]

❌ Quality Gates:
   - Unit Tests: FAIL
   - Coverage: Z% (target: 80%)

🐛 Bugs Found: N
   - Critical: X
   - High: Y

Next: Run `/build` to fix issues
```
