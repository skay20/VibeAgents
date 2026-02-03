# Workflow: Init

Initialize a new project with proper structure and configuration.

---

## Steps

### 1. Analyze Project Requirements

Read and understand:
- `docs/PRD.md` (if exists)
- `.ai/context/CORE.md`
- User input about project type

### 2. Setup Project Structure

```bash
# Create directory structure
mkdir -p src/{components/{ui,features},hooks,services,stores,types,utils,lib}
mkdir -p tests/{unit,integration,e2e}
mkdir -p docs/ADR
mkdir -p .ai/{context,agents,logs/runs}
```

### 3. Initialize Package Manager

```bash
# Choose based on project type
npm init -y
# or
pnpm init
# or
yarn init -y
```

### 4. Install Core Dependencies

Based on project type from CORE.md:

**Web App (React + TypeScript):**
```bash
npm install react react-dom
npm install -D typescript @types/react @types/react-dom vite
npm install -D vitest @testing-library/react @testing-library/jest-dom
npm install -D eslint prettier eslint-config-prettier
```

**API (Node + TypeScript):**
```bash
npm install express cors helmet
npm install -D typescript @types/express @types/cors
npm install -D vitest supertest @types/supertest
```

### 5. Setup Configuration Files

Create:
- `tsconfig.json`
- `vite.config.ts` (if applicable)
- `vitest.config.ts`
- `.eslintrc.js`
- `.prettierrc`
- `.gitignore`

### 6. Setup AI Context

Create/update:
- `AGENTS.md`
- `.claude/CLAUDE.md`
- `GEMINI.md`
- `.ai/context/CORE.md`

### 7. Initialize Git

```bash
git init
git add .
git commit -m "chore: initial project setup"
```

### 8. Verify Setup

Run quality gates:
```bash
npm run lint
npm run typecheck
npm run build
```

## Output

Report success with:
- Project structure created
- Dependencies installed
- Configuration files created
- Quality gates status
