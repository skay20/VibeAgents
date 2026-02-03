# Workflow: PLAN

Create a technical plan with architecture, tasks, and estimations.

---

## Trigger

`/plan`

## Steps

### 1. Analyze Requirements

Read:
- `docs/PRD.md` (from ASK agent)
- `.ai/context/CORE.md` (stack and constraints)
- `.ai/context/STANDARDS.md` (standards)

### 2. Design Architecture

Define:

```yaml
architecture:
  pattern: [mvc|layered|hexagonal|clean|microservices]
  
  components:
    - name: ""
      responsibility: ""
      technologies: []
      
  data_flow: |
    [Descripción del flujo de datos]
    
  tech_stack:
    frontend:
      framework: ""
      state_management: ""
      styling: ""
    backend:
      framework: ""
      database: ""
      api_style: [rest|graphql|grpc]
    deployment:
      platform: ""
      ci_cd: ""
```

### 3. Define Slices

Break down into implementation slices:

```
Slice 1: Foundation
- Project setup
- Core configuration
- CI/CD setup

Slice 2: Domain Layer
- Data models
- Business logic
- Repositories

Slice 3: API Layer
- Endpoints
- Validation
- Authentication

Slice 4: UI Foundation
- Component library
- Layout system
- Routing

Slice 5: Features
- Feature implementations

Slice 6: Polish
- Testing
- Performance
- Documentation
```

### 4. Create Tasks

For each slice, create tasks:

```yaml
slices:
  - id: "S-001"
    name: "Foundation"
    tasks:
      - id: "T-001"
        description: "Setup TypeScript configuration"
        effort: 1
        dependencies: []
        
      - id: "T-002"
        description: "Configure ESLint and Prettier"
        effort: 1
        dependencies: ["T-001"]
```

### 5. Estimate Effort

Use story points or hours:
- 1: Trivial (< 1 hour)
- 2: Simple (1-2 hours)
- 3: Medium (2-4 hours)
- 5: Complex (4-8 hours)
- 8: Very complex (1-2 days)
- 13: Epic (needs breakdown)

### 6. Identify Dependencies

```yaml
dependencies:
  internal:
    - "T-002 depends on T-001"
    
  external:
    - "Need API keys for service X"
    - "Waiting on design approval"
```

### 7. Assess Risks

```yaml
risks:
  - description: "Third-party API reliability"
    probability: medium
    impact: high
    mitigation: "Implement caching and fallback"
```

### 8. Create Plan Document

Write to `docs/PLAN.md`:

```markdown
# Technical Plan

## Architecture
...

## Slices
...

## Estimations
...

## Dependencies
...

## Risks
...
```

### 9. Log the Run

Create `.ai/logs/runs/plan-[timestamp].md`

## Output

```
✅ PLAN Workflow Complete

🏗️ Architecture: [pattern]
📦 Slices: X total
📋 Tasks: Y total
⏱️ Estimated: Z hours/days
🔗 Dependencies: N internal, M external
⚠️ Risks: P identified with mitigations

Next: Run `/build S-001` to start implementation
```
