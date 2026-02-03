# Workflow: REVIEW

Perform code review for quality and standards compliance.

---

## Trigger

`/review`

## Steps

### 1. Understand Context

Read:
- Code changes (diff)
- User stories
- Standards

### 2. Review Dimensions

### Correctness
- [ ] Code does what it should
- [ ] Edge cases handled
- [ ] No bugs introduced

### Maintainability
- [ ] Clear naming
- [ ] Small functions
- [ ] No duplication
- [ ] SOLID principles

### Testing
- [ ] Tests present
- [ ] Coverage adequate
- [ ] Tests meaningful

### Security
- [ ] No secrets
- [ ] Input validated
- [ ] Errors handled safely

### Performance
- [ ] No N+1 queries
- [ ] No unnecessary re-renders
- [ ] Efficient algorithms

### Style
- [ ] Follows conventions
- [ ] Consistent
- [ ] Lint passes

### 3. Provide Feedback

For each issue:

```
🚨 Critical: [description]
   Why: [explanation]
   Suggestion: [code]

⚠️ Major: [description]
   Consideration: [why]
   Alternative: [code]

💡 Minor: [suggestion]
   Reason: [why]

📝 Nit: [observation]
```

### 4. Make Decision

```yaml
review:
  decision: approve|approve_with_comments|request_changes
  
  dimensions:
    correctness: 1-5
    maintainability: 1-5
    testing: 1-5
    security: 1-5
    performance: 1-5
    style: 1-5
    
  comments:
    critical: 0
    major: 0
    minor: 0
    nit: 0
    
  action_items: []
```

### 5. Log the Run

Create `.ai/logs/runs/review-[timestamp].md`

## Output

### If approved:

```
✅ REVIEW Workflow Complete - APPROVED

📊 Review Scores:
   - Correctness: X/5
   - Maintainability: Y/5
   - Testing: Z/5
   - Security: A/5
   - Performance: B/5
   - Style: C/5

💬 Comments:
   - Minor: X
   - Nit: Y

✅ Decision: APPROVE

Next: Run `/release` to deploy
```

### If changes requested:

```
🔄 REVIEW Workflow Complete - CHANGES REQUESTED

📊 Issues Found:
   - Critical: X
   - Major: Y
   - Minor: Z

❌ Decision: REQUEST CHANGES

🔧 Priority Fixes:
   1. [description]
   2. [description]

Next: Run `/build` to fix issues
```
