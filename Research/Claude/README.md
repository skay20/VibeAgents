# 🎯 Vibe Coding System Generator - Complete Package

**Version:** 1.0.0  
**Created:** 2026-02-03  
**Status:** Production Ready ✅

---

## 📦 What's Included

This package contains a **complete Master Prompt system** for generating No-App-First Vibe Coding infrastructure. You get:

### 1. Master Prompt (2 formats)

| File | Format | Best For | Size |
|------|--------|----------|------|
| `MASTER_PROMPT_VIBE_CODING_SYSTEM.xml` | XML | Claude, Codex, Gemini (best LLM parsing) | 37 KB |
| `MASTER_PROMPT_VIBE_CODING_SYSTEM.md` | Markdown | Human reading, Cursor, Windsurf | 22 KB |

### 2. Usage Guide

| File | Purpose |
|------|---------|
| `USAGE_GUIDE.md` | Complete step-by-step instructions (22 KB) |

### 3. Supporting Documentation

- Context from research (uploaded files)
- Best practices from official docs (researched during generation)

---

## 🚀 Quick Start (30 seconds)

### Step 1: Choose Your Format

- **For Claude Code, Codex, Gemini:** Use `MASTER_PROMPT_VIBE_CODING_SYSTEM.xml`
- **For Cursor, Windsurf, Human Reading:** Use `MASTER_PROMPT_VIBE_CODING_SYSTEM.md`

### Step 2: Fill Inputs

Open your chosen file and find the user input section at the bottom:

**XML:** Look for `<user_input_section>`
**Markdown:** Look for "## 📋 User Input Template"

Fill in your project details:

```yaml
PROJECT_INFO: "Your project description"
PROJECT_TYPE: "web app | api | mobile | etc"
STACK: "Your tech stack"
REPO_TYPE: "single | monorepo"
```

### Step 3: Run in Your AI Tool

```bash
# Example with Claude Code
claude

# Paste the entire prompt (with your filled inputs)
# Hit Enter
# Follow the phased generation
# Approve each phase
# Done!
```

**In 5-15 minutes**, you'll have a complete Vibe Coding system with:
- God Agent (Orchestrator)
- 6 Specialized Agents
- 6 Workflows
- Tool adapters for Codex, Claude Code, Gemini, Windsurf, Cursor, Copilot
- Full documentation
- Versioning and logging

---

## 📋 What Gets Generated

### File Structure (40-60 files)

```
your-project/
├── .ai/                          # Core system (universal)
│   ├── ORCHESTRATOR.md           # God Agent
│   ├── CONFIG.yaml               # Configuration
│   ├── GUIDE.md                  # User guide
│   ├── AGENTS_INDEX.md           # Agent documentation
│   ├── CHANGELOG.md              # Versioning
│   ├── context/                  # Layered context
│   │   ├── CORE.md               # L0: Essential (≤2 pages)
│   │   ├── STANDARDS.md          # L1: Code standards
│   │   ├── SECURITY.md           # L1: Security rules
│   │   └── TESTING.md            # L1: Test strategy
│   ├── agents/                   # Specialized agents
│   │   ├── planner.md
│   │   ├── architect.md
│   │   ├── implementer.md
│   │   ├── tester.md
│   │   ├── reviewer.md
│   │   └── releaser.md
│   ├── workflows/                # Executable workflows
│   │   ├── 00-init.md
│   │   ├── 10-plan.md
│   │   ├── 20-implement.md
│   │   ├── 30-test.md
│   │   ├── 40-review.md
│   │   └── 50-release.md
│   └── logs/runs/                # Run logs
├── AGENTS.md                     # OpenAI Codex adapter
├── .claude/                      # Claude Code adapter
│   ├── CLAUDE.md
│   └── rules/
│       ├── testing.md
│       ├── security.md
│       └── style.md
├── .gemini/                      # Gemini adapter
│   ├── GEMINI.md
│   ├── config.yaml
│   └── styleguide.md
├── .windsurf/                    # Windsurf adapter
│   ├── workflows/
│   └── rules/
├── .cursor/                      # Cursor adapter
│   └── rules/
├── .github/                      # GitHub Copilot adapter
│   └── copilot-instructions.md
├── docs/                         # Project docs
│   ├── PRD.md
│   ├── ARCHITECTURE.md
│   ├── RUNBOOK.md
│   └── ADR/
│       └── 0001-initial.md
└── scripts/                      # Utilities
    ├── init-project.sh
    └── log-run.sh
```

---

## ✨ Key Features

### 1. God Agent Pattern
Central orchestrator that:
- Detects available tools automatically
- Routes requests to specialized agents
- Maintains global state
- Logs all decisions
- Suggests next steps

### 2. Context Layering
No bloat! Context organized in layers:
- **L0 Core:** 1-2 pages, stable essentials
- **L1 Standards:** Modular rules (testing, security, style)
- **L2 Architecture:** Referenced ADRs
- **L3 Task Pack:** Temporal per feature/PR

### 3. Tool Adaptability
Works with ANY combination of:
- OpenAI Codex
- Claude Code
- Gemini 2.0
- Windsurf/Cascade
- Cursor
- VS Code + Copilot

### 4. Phased Generation
Not monolithic! Generates in 6 phases:
1. Core System (orchestrator, config, context)
2. Specialized Agents (planner, architect, etc.)
3. Workflows (init, plan, implement, test, review, release)
4. Tool Adapters (AGENTS.md, .claude/, .gemini/, etc.)
5. Project Documentation (PRD, architecture, runbook)
6. Utility Scripts (init, logging)

**You approve each phase before proceeding.**

### 5. Complete, Not Templates
Every file is **100% complete** with:
- Full content (no placeholders)
- Version headers
- Inline documentation
- Concrete examples
- Clear references

No "TODO", no "...", no "EXAMPLE" unless you request templates.

### 6. Versioning & Logging
- Every file has semver version header
- Global CHANGELOG.md tracks changes
- Every workflow run logged to `.ai/logs/runs/TIMESTAMP/`
- Full traceability

---

## 🎯 Use Cases

### Use Case 1: New Project
**Input:**
```yaml
PROJECT_INFO: "TBD"
PROJECT_TYPE: "unknown"
STACK: "unknown"
REPO_TYPE: "single"
```
**Output:** Universal template ready to customize

### Use Case 2: Existing TypeScript Project
**Input:**
```yaml
PROJECT_INFO: "E-commerce SaaS platform"
PROJECT_TYPE: "web app"
STACK: "TypeScript/Next.js/Prisma/PostgreSQL"
REPO_TYPE: "single"
```
**Output:** Customized system with TS-specific standards and commands

### Use Case 3: Python API with ML
**Input:**
```yaml
PROJECT_INFO: "ML model serving API"
PROJECT_TYPE: "api"
STACK: "Python/FastAPI/PostgreSQL/Redis"
REPO_TYPE: "single"
QUALITY_GATES: "tests, lint, typecheck, coverage"
```
**Output:** Python-optimized system with ML considerations

### Use Case 4: Team Using Only Claude Code & Cursor
**Input:**
```yaml
PROJECT_INFO: "Internal admin dashboard"
PROJECT_TYPE: "web app"
STACK: "React/Node/MongoDB"
REPO_TYPE: "single"
AVAILABLE_TOOLS: "claude_code, cursor"
```
**Output:** Only `.claude/` and `.cursor/` adapters (plus core `.ai/`)

---

## 🔧 Customization

After generation, customize via:

### 1. CONFIG.yaml
```yaml
# Change agent behavior
agent_behavior:
  verbosity: detailed  # or concise, minimal
  autonomy: high       # or medium, low

# Toggle quality gates
quality_gates:
  tests: true
  lint: true
  typecheck: true
  security: true       # add this
  coverage: true       # add this

# Adjust logging
logging:
  level: debug         # or info, warn, error
```

### 2. Add Custom Agents
Ask your AI tool:
```
"Add a 'documenter' agent that generates API docs from code"
```

### 3. Modify Workflows
```
"Update the test workflow to use pytest instead of jest"
```

### 4. Extend Tool Adapters
```
"Add a Cursor hook that blocks commits without tests"
```

---

## 📊 Expected Results

### Immediate Benefits
- ✅ Structured project from day 1
- ✅ Consistent workflows across team
- ✅ AI tools work better with clear context
- ✅ Decisions logged and traceable
- ✅ Quality gates enforced

### Long-term Benefits
- ✅ Onboarding new devs: "Read `.ai/GUIDE.md`"
- ✅ No context bloat (layered approach)
- ✅ Easy to evolve (modular agents/workflows)
- ✅ Tool-agnostic (switch Codex → Claude Code → Gemini)
- ✅ Audit trail (all changes versioned)

---

## 🐛 Troubleshooting

### Issue: Files not generating
**Solution:** Check tool permissions, verify you're in correct directory

### Issue: Placeholders in files
**Solution:** Should NOT happen (quality requirement). Ask tool to regenerate.

### Issue: Orchestrator doesn't route
**Solution:** Test with: "Route my request: Plan a new feature". Tool should invoke planner.

### Issue: Too many files
**Solution:** This is by design (modular). AI tools read only what they need via context layering.

**Full troubleshooting:** See `USAGE_GUIDE.md`

---

## 📚 Documentation

### Included Files
1. **MASTER_PROMPT_VIBE_CODING_SYSTEM.xml** - Complete prompt (XML)
2. **MASTER_PROMPT_VIBE_CODING_SYSTEM.md** - Complete prompt (Markdown)
3. **USAGE_GUIDE.md** - Comprehensive usage instructions

### Generated Files (After Running Prompt)
4. **`.ai/GUIDE.md`** - System-specific user guide
5. **`.ai/AGENTS_INDEX.md`** - Agent documentation
6. **`docs/RUNBOOK.md`** - Project commands and setup

### External References
- [OpenAI Codex Docs](https://developers.openai.com/codex)
- [Claude Code Docs](https://code.claude.com/docs)
- [Gemini Code Assist Docs](https://developers.google.com/gemini-code-assist)
- [Windsurf Docs](https://docs.codeium.com/windsurf)
- [Cursor Docs](https://cursor.sh/docs)
- [AGENTS.md Spec](https://agents.md)

---

## 🎓 Learning Path

### Week 1: Get Started
1. Run the Master Prompt
2. Read generated `.ai/GUIDE.md`
3. Try one workflow: "Plan a simple feature"
4. Review logs in `.ai/logs/runs/`

### Week 2-3: Customize
5. Edit `.ai/CONFIG.yaml` to fit your style
6. Add a custom agent or workflow
7. Integrate with your team's tools
8. Build team conventions in `.ai/context/STANDARDS.md`

### Week 4+: Master
9. Create complex multi-agent workflows
10. Integrate with CI/CD
11. Use hooks/gates for automation
12. Contribute improvements to orchestrator

---

## 🔒 Quality Guarantees

This Master Prompt guarantees:

✅ **Complete Files:** No placeholders, no "TODO"  
✅ **Modular Design:** Easy to extend and maintain  
✅ **Tool Agnostic:** Works with any AI coding tool  
✅ **Versioned:** Full traceability of changes  
✅ **Documented:** Every component explained  
✅ **Production Ready:** Use immediately  
✅ **Iterative:** Approve each phase before proceeding  
✅ **Customizable:** CONFIG.yaml + easy modifications  

---

## 🌟 Advanced Features

### Multi-Tool Orchestration
Use different tools for different tasks:
- Codex for quick edits
- Claude Code for complex refactors
- Gemini for code reviews
- Windsurf for workflow automation

All reading from the same `.ai/` system.

### CI/CD Integration
GitHub Actions can read workflows:
```yaml
# .github/workflows/test.yml
- name: Run Test Workflow
  run: |
    cat .ai/workflows/30-test.md
    # Parse and execute test commands
```

### Team Conventions
Store shared knowledge:
```markdown
# .ai/context/STANDARDS.md
## Naming Conventions
- Components: PascalCase
- Utilities: camelCase
- Constants: UPPER_SNAKE_CASE

## File Organization
- Tests next to source: `Button.tsx` + `Button.test.tsx`
- Hooks in `src/hooks/`
- Utils in `src/utils/`
```

All AI tools read this automatically.

---

## 🎯 Success Metrics

### You'll know it's working when:
- ✅ AI tools invoke workflows correctly
- ✅ Logs appear after each workflow run
- ✅ Code quality improves (agents enforce standards)
- ✅ Context stays clean (no bloat)
- ✅ Team has shared conventions
- ✅ New devs onboard faster

---

## 📞 Support

### If You Need Help

1. **Read USAGE_GUIDE.md** (comprehensive troubleshooting)
2. **Check generated `.ai/GUIDE.md`** (system-specific instructions)
3. **Review `.ai/AGENTS_INDEX.md`** (agent explanations)
4. **Ask your AI tool:** "How do I use the planning workflow?"

### If You Find Issues

1. **Minor issues:** Edit files directly, update version headers
2. **Major issues:** Regenerate with updated inputs
3. **Systematic issues:** Report to AI tool vendor

---

## 🚀 Next Steps

### Right Now
1. ✅ Read this README (you're here!)
2. 📖 Skim `USAGE_GUIDE.md` (detailed instructions)
3. 🎯 Choose XML or Markdown prompt
4. ⚙️ Fill in your project inputs
5. 🚀 Run in your AI tool
6. 📦 Get your complete Vibe Coding system

### In 1 Hour
7. 📚 Read generated `.ai/GUIDE.md`
8. 🧪 Try a workflow: "Plan a test feature"
9. 📝 Review logs in `.ai/logs/runs/`
10. 🔧 Customize `.ai/CONFIG.yaml`

### In 1 Week
11. 🤖 Add a custom agent
12. 🔄 Create a custom workflow
13. 👥 Share with your team
14. 🎉 Start Vibe Coding!

---

## 🏆 What Makes This Special?

### Compared to "Just Using AI"
- ❌ Ad-hoc: No structure, context gets messy
- ✅ Vibe Coding: Structured, layered, traceable

### Compared to "Building Your Own App"
- ❌ Custom App: Maintenance burden, vendor lock-in
- ✅ No-App-First: Use existing tools, repo-based

### Compared to "Manual Setup"
- ❌ Manual: Hours of setup, easy to miss things
- ✅ Master Prompt: 15 minutes, complete system

### The Vibe Coding Advantage
**Structured Chaos → Organized Flow**

- Context layering prevents bloat
- God Agent routes intelligently
- Workflows chain seamlessly
- Tools adapt automatically
- Quality enforced by design

---

## 📄 License & Attribution

**Created by:** Master Prompt Generator (Claude)  
**Date:** 2026-02-03  
**Version:** 1.0.0  
**Status:** Production Ready

**Based on research from:**
- Vibe Coding y Orquestación Multi-Agente (Blueprint 2026)
- Diseño de Sistema No-App-First
- Official documentation: OpenAI, Anthropic, Google, Windsurf, Cursor

**Use freely for:**
- Personal projects
- Commercial projects
- Team projects
- Open source

**Attribution appreciated but not required.**

---

## 🎉 You're Ready!

You now have everything you need to generate a **complete Vibe Coding system** for any project.

**Pick your prompt format, fill your inputs, run it, and start Vibe Coding!**

Questions? Read `USAGE_GUIDE.md`  
Issues? Check troubleshooting  
Success? Share with your team!

**Happy Vibe Coding! 🚀**

---

**Package Contents:**
- ✅ MASTER_PROMPT_VIBE_CODING_SYSTEM.xml (37 KB)
- ✅ MASTER_PROMPT_VIBE_CODING_SYSTEM.md (22 KB)
- ✅ USAGE_GUIDE.md (22 KB)
- ✅ README.md (this file)

**Total Size:** ~81 KB of pure productivity 💎
