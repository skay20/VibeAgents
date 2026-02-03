# Workflow: ASK

Analyze requirements and create a refined PRD with user stories.

---

## Trigger

`/ask [description of the idea/feature]`

## Steps

### 1. Understand the Input

Read and analyze:
- User's description
- Existing `docs/PRD.md` (if any)
- `.ai/context/CORE.md` for context

### 2. Ask Clarifying Questions

If the description is vague, ask:

1. What is the primary goal of this feature?
2. Who are the users?
3. What are the must-have features?
4. Are there any technical constraints?
5. What platform(s)? (web, mobile, desktop)
6. Any integrations needed?
7. Timeline or deadline?

### 3. Structure the Requirements

Create:

```yaml
project:
  name: ""
  description: ""
  objectives: []
  
user_stories:
  - id: "US-001"
    title: ""
    as_a: ""
    i_want: ""
    so_that: ""
    acceptance_criteria: []
    priority: high|medium|low
    effort: 1|2|3|5|8|13
    
technical_constraints:
  - ""
  
open_questions:
  - ""
  
assumptions:
  - ""
```

### 4. Prioritize with MoSCoW

- **Must have**: Critical for MVP
- **Should have**: Important but not critical
- **Could have**: Nice to have
- **Won't have**: Out of scope (for now)

### 5. Document Assumptions

List all assumptions made:
- Technical assumptions
- Business assumptions
- User behavior assumptions

### 6. Create/Update PRD

Write to `docs/PRD.md`:

```markdown
# Product Requirements Document

## Overview
...

## User Stories
...

## Technical Constraints
...

## Open Questions
...

## Assumptions
...
```

### 7. Log the Run

Create `.ai/logs/runs/ask-[timestamp].md` with:
- Input received
- Questions asked
- Decisions made
- Output generated

## Output

```
✅ ASK Workflow Complete

📄 PRD created/updated: docs/PRD.md
📊 User Stories: X total
   - Must have: Y
   - Should have: Z
   - Could have: W
❓ Open Questions: N
📝 Assumptions documented: M

Next: Run `/plan` to create technical plan
```
