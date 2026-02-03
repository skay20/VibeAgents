# 📖 MASTER PROMPT USAGE GUIDE

**Version:** 1.0.0  
**Date:** 2026-02-03  
**For:** Vibe Coding System Generator Master Prompt

---

## 🎯 What Is This?

This Master Prompt generates a **complete, production-ready "Vibe Coding" system** for your repository. It creates:

✅ **God Agent (Orchestrator)** that coordinates everything  
✅ **6 Specialized Agents** (planner, architect, implementer, tester, reviewer, releaser)  
✅ **6 Workflows** (init, plan, implement, test, review, release)  
✅ **Tool Adapters** for Codex, Claude Code, Gemini, Windsurf, Cursor, Copilot  
✅ **Context Management** (layered, modular, no bloat)  
✅ **Logging & Versioning** (full traceability)  
✅ **Documentation** (guides, indexes, runbooks)

**No app needed.** Everything lives in your repo. AI tools execute it.

---

## 🚀 Quick Start (3 Steps)

### Step 1: Choose Your Tool

Pick ONE of these AI tools to run the Master Prompt:

| Tool | How to Use |
|------|------------|
| **OpenAI Codex** | Copy XML or Markdown prompt → Paste in Codex chat → Fill inputs |
| **Claude Code (CLI)** | Copy XML or Markdown prompt → `claude` → Paste → Fill inputs |
| **Gemini 2.0 (IDE)** | Copy XML or Markdown prompt → Paste in Gemini chat → Fill inputs |
| **Windsurf** | Copy XML or Markdown prompt → Paste in Cascade chat → Fill inputs |
| **Cursor** | Copy XML or Markdown prompt → Paste in Composer → Fill inputs |
| **VS Code + Copilot** | Copy XML or Markdown prompt → Paste in Copilot chat → Fill inputs |

**Recommendation:** Use **Claude Code CLI** or **Gemini 2.0 Flash Thinking** for best results (extended reasoning).

### Step 2: Fill Required Inputs

Before pasting the prompt, prepare these values:

```yaml
PROJECT_INFO: "E-commerce platform for artisan products"
PROJECT_TYPE: "web app"
STACK: "TypeScript/Next.js/PostgreSQL"
REPO_TYPE: "single"
```

**Or for a universal template:**

```yaml
PROJECT_INFO: "TBD"
PROJECT_TYPE: "unknown"
STACK: "unknown"
REPO_TYPE: "single"
```

### Step 3: Run the Prompt

1. Open your chosen tool (e.g., `claude` in terminal)
2. Copy **MASTER_PROMPT_VIBE_CODING_SYSTEM.xml** (or .md)
3. Scroll to `<user_input_section>` (XML) or "User Input Template" (Markdown)
4. Replace `{{TO_BE_PROVIDED}}` with your values
5. Paste the **entire prompt** into the tool
6. Hit Enter

**The tool will:**
- Confirm it understands the mission
- Ask clarifying questions (if needed)
- Present a generation plan
- Wait for your approval
- Generate files phase by phase (with checkpoints)
- Deliver the complete system

---

## 📋 Detailed Usage Instructions

### A. Preparing Your Inputs

#### Required Inputs

| Input | Description | Examples |
|-------|-------------|----------|
| `PROJECT_INFO` | Project name/description or PRD | "Blog engine", "REST API for payments", "TBD" |
| `PROJECT_TYPE` | Type of project | `web app`, `api`, `mobile`, `data`, `infra`, `cli`, `library`, `unknown` |
| `STACK` | Tech stack | "Python/FastAPI/PostgreSQL", "TypeScript/React/Node", "Go/gRPC", "unknown" |
| `REPO_TYPE` | Repository structure | `single` or `monorepo` |

#### Optional Inputs

| Input | Description | Default | Examples |
|-------|-------------|---------|----------|
| `AVAILABLE_TOOLS` | Which tools you use | `all` | "codex, claude_code, gemini", "windsurf, cursor" |
| `QUALITY_GATES` | Required checks | `tests, lint` | "tests, lint, typecheck, security, coverage" |
| `CONSTRAINTS` | Special requirements | None | "No secrets in files", "Use structured logging" |
| `CUSTOM_AGENTS` | Additional agents | None | "documenter, deployer, monitor" |

#### Input Scenarios

**Scenario 1: New Project (Specific)**
```yaml
PROJECT_INFO: "SaaS platform for invoice management"
PROJECT_TYPE: "web app"
STACK: "TypeScript/Next.js/Prisma/PostgreSQL"
REPO_TYPE: "single"
AVAILABLE_TOOLS: "claude_code, cursor"
QUALITY_GATES: "tests, lint, typecheck, security"
```

**Scenario 2: Universal Template**
```yaml
PROJECT_INFO: "TBD"
PROJECT_TYPE: "unknown"
STACK: "unknown"
REPO_TYPE: "single"
AVAILABLE_TOOLS: "all"
QUALITY_GATES: "tests, lint"
```

**Scenario 3: Existing Project (Python API)**
```yaml
PROJECT_INFO: "Machine learning model serving API"
PROJECT_TYPE: "api"
STACK: "Python/FastAPI/PostgreSQL/Redis"
REPO_TYPE: "single"
AVAILABLE_TOOLS: "codex, gemini"
QUALITY_GATES: "tests, lint, typecheck, coverage"
CONSTRAINTS: "Never log PII, use async/await"
```

### B. Using the XML Prompt

**File:** `MASTER_PROMPT_VIBE_CODING_SYSTEM.xml`

1. Open the XML file
2. Scroll to the end: `<user_input_section>`
3. Replace placeholders:

```xml
<user_inputs>
  <PROJECT_INFO>E-commerce platform for artisan products</PROJECT_INFO>
  <PROJECT_TYPE>web app</PROJECT_TYPE>
  <STACK>TypeScript/Next.js/PostgreSQL</STACK>
  <REPO_TYPE>single</REPO_TYPE>
  <AVAILABLE_TOOLS>claude_code, cursor, gemini</AVAILABLE_TOOLS>
  <QUALITY_GATES>tests, lint, typecheck</QUALITY_GATES>
  <CONSTRAINTS></CONSTRAINTS>
  <CUSTOM_AGENTS></CUSTOM_AGENTS>
</user_inputs>
```

4. Copy the **entire XML file** (including your inputs)
5. Paste into your AI tool
6. Run

**Pros of XML:**
- Machine-readable (best for LLMs)
- Structured and unambiguous
- Easy to validate

**Cons of XML:**
- Less human-readable
- Requires XML syntax knowledge

### C. Using the Markdown Prompt

**File:** `MASTER_PROMPT_VIBE_CODING_SYSTEM.md`

1. Open the Markdown file
2. Scroll to: "## 📋 User Input Template"
3. Fill in the template:

```yaml
# REQUIRED
PROJECT_INFO: "E-commerce platform for artisan products"
PROJECT_TYPE: "web app"
STACK: "TypeScript/Next.js/PostgreSQL"
REPO_TYPE: "single"

# OPTIONAL
AVAILABLE_TOOLS: "claude_code, cursor, gemini"
QUALITY_GATES: "tests, lint, typecheck"
CONSTRAINTS: ""
CUSTOM_AGENTS: ""
```

4. Copy the **entire Markdown file** (including your inputs)
5. Paste into your AI tool
6. Run

**Pros of Markdown:**
- Human-readable
- Familiar format
- Easy to edit

**Cons of Markdown:**
- Slightly less structured than XML
- Some LLMs prefer XML

**Recommendation:** Use **XML** for Claude/Gemini/Codex (better parsing). Use **Markdown** for Cursor/Windsurf (better readability).

### D. Running in Different Tools

#### Claude Code (CLI)

```bash
# Start Claude Code
claude

# Paste the prompt (XML or Markdown with filled inputs)
# Claude will respond and start the generation process

# Follow the steps:
# 1. Confirm mission understanding
# 2. Answer any clarifying questions
# 3. Approve generation plan
# 4. Approve each phase (Core → Agents → Workflows → Adapters → Docs → Scripts)
# 5. Review final output

# To exit
exit
```

#### Gemini 2.0 (VS Code or IDE)

1. Open Gemini chat in your IDE
2. Paste the prompt with filled inputs
3. Gemini will start the phased generation
4. Approve each phase when prompted
5. Files will be created in your workspace

#### Codex (VS Code)

1. Open Codex chat in VS Code
2. Paste the prompt with filled inputs
3. Codex will generate files in phases
4. Confirm each phase
5. Review generated structure

#### Windsurf/Cascade

1. Open Cascade chat
2. Paste the prompt with filled inputs
3. Approve the generation plan
4. Windsurf will create workflows in `.windsurf/workflows/`
5. Review and test workflows

#### Cursor

1. Open Cursor Composer
2. Paste the prompt with filled inputs
3. Cursor will generate the system
4. Files appear in `.cursor/rules/` and `.ai/`
5. Test with Cursor's AI features

---

## 🔄 What Happens During Generation?

### Phase 1: Core System (5-10 files)

**Generated:**
- `.ai/ORCHESTRATOR.md` ← God Agent
- `.ai/CONFIG.yaml` ← Configuration
- `.ai/GUIDE.md` ← User guide
- `.ai/AGENTS_INDEX.md` ← Agent documentation
- `.ai/CHANGELOG.md` ← Version tracking
- `.ai/context/CORE.md` ← L0 context
- `.ai/context/STANDARDS.md` ← L1 standards
- `.ai/context/SECURITY.md` ← L1 security
- `.ai/context/TESTING.md` ← L1 testing

**You'll see:**
```
✅ Generated .ai/ORCHESTRATOR.md
✅ Generated .ai/CONFIG.yaml
✅ Generated .ai/GUIDE.md
...
📋 Phase 1 complete. Review the files.
❓ Ready to proceed to Phase 2 (Specialized Agents)?
```

**What to do:** Review the files, then respond `yes` or `proceed` or `continue`.

### Phase 2: Specialized Agents (6 files)

**Generated:**
- `.ai/agents/planner.md`
- `.ai/agents/architect.md`
- `.ai/agents/implementer.md`
- `.ai/agents/tester.md`
- `.ai/agents/reviewer.md`
- `.ai/agents/releaser.md`

**What to do:** Review each agent. If you need modifications (e.g., "Make planner more detailed"), say so now.

### Phase 3: Workflows (6 files)

**Generated:**
- `.ai/workflows/00-init.md`
- `.ai/workflows/10-plan.md`
- `.ai/workflows/20-implement.md`
- `.ai/workflows/30-test.md`
- `.ai/workflows/40-review.md`
- `.ai/workflows/50-release.md`

**What to do:** Review workflows. Check if they match your process.

### Phase 4: Tool Adapters (varies)

**Generated** (based on `AVAILABLE_TOOLS`):
- `AGENTS.md` (if Codex)
- `.claude/CLAUDE.md` + `.claude/rules/*.md` (if Claude Code)
- `.gemini/GEMINI.md` + `.gemini/config.yaml` + `.gemini/styleguide.md` (if Gemini)
- `.windsurf/workflows/*.md` + `.windsurf/rules/*.md` (if Windsurf)
- `.cursor/rules/*.md` (if Cursor)
- `.github/copilot-instructions.md` (if Copilot)

**What to do:** Verify tool-specific files are correct for your setup.

### Phase 5: Project Documentation (4+ files)

**Generated:**
- `docs/PRD.md`
- `docs/ARCHITECTURE.md`
- `docs/RUNBOOK.md`
- `docs/ADR/0001-initial-architecture.md`

**What to do:** Review docs. If PROJECT_INFO was "TBD", these will be templates.

### Phase 6: Utility Scripts (2 files)

**Generated:**
- `scripts/init-project.sh`
- `scripts/log-run.sh`
- `.ai/logs/runs/.gitkeep`

**What to do:** Test scripts if applicable (e.g., `bash scripts/init-project.sh`).

### Final Output

```
✅ All phases complete!

📁 Final File Tree:
.
├── .ai/
│   ├── ORCHESTRATOR.md
│   ├── CONFIG.yaml
│   ├── GUIDE.md
│   ├── AGENTS_INDEX.md
│   ├── CHANGELOG.md
│   ├── context/
│   │   ├── CORE.md
│   │   ├── STANDARDS.md
│   │   ├── SECURITY.md
│   │   └── TESTING.md
│   ├── agents/
│   │   ├── planner.md
│   │   ├── architect.md
│   │   ├── implementer.md
│   │   ├── tester.md
│   │   ├── reviewer.md
│   │   └── releaser.md
│   ├── workflows/
│   │   ├── 00-init.md
│   │   ├── 10-plan.md
│   │   ├── 20-implement.md
│   │   ├── 30-test.md
│   │   ├── 40-review.md
│   │   └── 50-release.md
│   └── logs/runs/.gitkeep
├── AGENTS.md
├── .claude/
├── .gemini/
├── .windsurf/
├── .cursor/
├── .github/
├── docs/
├── scripts/
└── ...

🎯 Next Steps:
1. Read .ai/GUIDE.md for usage instructions
2. Review .ai/ORCHESTRATOR.md to understand routing
3. Check tool-specific files (AGENTS.md, .claude/, etc.)
4. Run scripts/init-project.sh if starting fresh
5. Try a workflow: "Use the planner workflow to break down a feature"

💡 Need changes? Just ask:
- "Update the tester agent to use pytest"
- "Add a 'deployer' agent"
- "Modify CONFIG.yaml to make agents more verbose"
```

---

## 🛠️ After Generation: Using Your System

### Step 1: Read the Guide

```bash
# View the generated guide
cat .ai/GUIDE.md

# Or open in your editor
code .ai/GUIDE.md
```

### Step 2: Understand the Orchestrator

```bash
# Read the God Agent logic
cat .ai/ORCHESTRATOR.md
```

The Orchestrator will:
- Detect which tools you have (Codex, Claude Code, etc.)
- Route your requests to the right agent
- Log everything
- Suggest next steps

### Step 3: Try a Workflow

**Example: Planning a new feature**

In your AI tool (Claude Code, Gemini, etc.):

```
"Use the planning workflow to break down the 'user authentication' feature"
```

The tool will:
1. Read `.ai/workflows/10-plan.md`
2. Invoke `.ai/agents/planner.md`
3. Generate tasks, risks, dependencies
4. Log to `.ai/logs/runs/TIMESTAMP/plan.md`
5. Suggest next steps (e.g., "Ready to implement? Use the implement workflow")

**Example: Implementing a task**

```
"Use the implement workflow to build the login form"
```

The tool will:
1. Read `.ai/workflows/20-implement.md`
2. Invoke `.ai/agents/implementer.md`
3. Generate code
4. Log to `.ai/logs/runs/TIMESTAMP/changes.diff`
5. Suggest: "Ready to test? Use the test workflow"

### Step 4: Customize with CONFIG.yaml

Edit `.ai/CONFIG.yaml` to change behavior:

```yaml
agent_behavior:
  verbosity: detailed  # Change to 'concise' or 'minimal'
  autonomy: high       # Change to 'medium' or 'low'
  
quality_gates:
  tests: true
  lint: true
  typecheck: true
  security: true       # Add this
  
logging:
  level: info          # Change to 'debug' for more detail
  
tool_overrides:
  claude_code:
    max_context: 150000
  codex:
    project_doc_max_bytes: 65536
```

Save, and the system adapts.

### Step 5: Monitor Logs

```bash
# View recent runs
ls -la .ai/logs/runs/

# View a specific run
cat .ai/logs/runs/2026-02-03T14-30-00/summary.md
```

Logs contain:
- Plan
- Code changes (diff)
- Test results
- Review findings
- Summary

---

## 🔧 Customization and Iteration

### Adding a New Agent

Ask the tool:

```
"Add a new 'documenter' agent that auto-generates API docs from code"
```

The tool will:
1. Create `.ai/agents/documenter.md`
2. Update `.ai/AGENTS_INDEX.md`
3. Update `.ai/ORCHESTRATOR.md` to route to documenter
4. Suggest usage: "Invoke with: Use the documenter agent on src/api/"

### Modifying an Existing Agent

```
"Update the tester agent to use pytest instead of jest"
```

The tool will:
1. Read current `.ai/agents/tester.md`
2. Update test framework logic
3. Update version header
4. Add changelog entry

### Adding a Workflow

```
"Create a 'deploy' workflow that uses the releaser agent and pushes to production"
```

The tool will:
1. Create `.ai/workflows/60-deploy.md`
2. Reference `.ai/agents/releaser.md`
3. Add deployment steps
4. Update `.ai/GUIDE.md` with deploy instructions

### Tool-Specific Tweaks

**For Claude Code:**

```
"Add a Claude Code rule that enforces async/await in all API routes"
```

Creates: `.claude/rules/api-async.md` with glob pattern `["src/api/**/*.ts"]`

**For Windsurf:**

```
"Create a Windsurf workflow that combines test + review into one QA step"
```

Creates: `.windsurf/workflows/qa.md`

---

## 🐛 Troubleshooting

### Issue: "Tool not generating files"

**Solution:**
1. Check if tool has file creation permissions
2. Ensure you're in the correct directory
3. For Codex: check `codex status`
4. For Claude Code: check `claude --version`

### Issue: "Generated files have placeholders"

**Solution:**
1. This should NOT happen (it's a quality requirement)
2. Ask the tool: "Regenerate [filename] with complete content, no placeholders"
3. If persists, report to tool vendor (bug in LLM)

### Issue: "ORCHESTRATOR.md doesn't work"

**Solution:**
1. ORCHESTRATOR.md is documentation + logic
2. AI tool reads it and executes logic
3. Test by asking: "Route my request: Plan a new feature"
4. Tool should invoke planner agent

### Issue: "Workflows don't chain"

**Solution:**
1. Workflows are invoked by the Orchestrator
2. Ask: "Use the init workflow, then plan workflow"
3. If manual: read workflow file, follow steps, invoke next workflow

### Issue: "Too many files, context overload"

**Solution:**
1. This is why we use **layered context**
2. AI tools should read `.ai/context/CORE.md` (≤2 pages)
3. Point to other files with `@` syntax: "See @.ai/context/SECURITY.md"
4. Use `/compact` (Claude Code) to compress context

---

## 📊 Expected Results

### What You Should Have

After successful generation:

✅ **40-60 files** (varies by tool selection)  
✅ **Full folder structure** (.ai/, docs/, scripts/, tool dirs)  
✅ **Complete God Agent** with routing logic  
✅ **6 specialized agents** ready to invoke  
✅ **6 workflows** for common tasks  
✅ **Tool adapters** for your selected tools  
✅ **Documentation** (GUIDE, AGENTS_INDEX, RUNBOOK, PRD, ARCHITECTURE)  
✅ **Versioning** (all files have headers, CHANGELOG.md exists)  
✅ **Logging structure** (.ai/logs/runs/)  
✅ **Scripts** (init-project.sh, log-run.sh)

### What You Can Do

**Immediately:**
- Use workflows to plan, implement, test features
- Invoke agents for specialized tasks
- Customize via CONFIG.yaml
- Track changes in logs

**Over Time:**
- Add custom agents
- Create domain-specific workflows
- Fine-tune tool adapters
- Build team-specific conventions

---

## 🎓 Learning Path

### Beginner (Week 1)

1. Generate system with basic inputs
2. Read `.ai/GUIDE.md`
3. Try planning workflow: "Plan a simple feature"
4. Review generated plan
5. Try implement workflow: "Implement one task from plan"

### Intermediate (Week 2-3)

6. Customize `.ai/CONFIG.yaml`
7. Add a custom agent
8. Chain multiple workflows
9. Review logs from past runs
10. Modify tool adapters for your setup

### Advanced (Week 4+)

11. Create complex workflows with branching logic
12. Integrate with CI/CD (GitHub Actions reads workflows)
13. Build team-specific conventions in `.ai/context/STANDARDS.md`
14. Use hooks (Cursor) or MCP (Claude Code) for automation
15. Contribute improvements to ORCHESTRATOR logic

---

## 📚 Additional Resources

### Internal References

- **MASTER_PROMPT_VIBE_CODING_SYSTEM.xml** - Full prompt (XML format)
- **MASTER_PROMPT_VIBE_CODING_SYSTEM.md** - Full prompt (Markdown format)
- Generated `.ai/GUIDE.md` - System-specific guide
- Generated `.ai/AGENTS_INDEX.md` - Agent documentation
- Generated `docs/RUNBOOK.md` - Project commands

### External References

- [OpenAI Codex Docs](https://developers.openai.com/codex)
- [Claude Code Docs](https://code.claude.com/docs)
- [Gemini Code Assist Docs](https://developers.google.com/gemini-code-assist)
- [Windsurf Docs](https://docs.codeium.com/windsurf)
- [Cursor Docs](https://cursor.sh/docs)
- [AGENTS.md Spec](https://agents.md)

---

## ❓ FAQ

### Q: Can I use this with multiple tools simultaneously?

**A:** Yes! Set `AVAILABLE_TOOLS: "all"` and the system generates adapters for all tools. You can use Codex for planning, Claude Code for implementation, Gemini for reviews, etc.

### Q: What if my stack isn't TypeScript/Python?

**A:** Set `STACK: "your stack"` (e.g., "Rust/Actix-web/PostgreSQL"). The system adapts. If `STACK: "unknown"`, you get a universal template.

### Q: Can I use this in an existing project?

**A:** Absolutely. The system is additive. It won't overwrite existing files (unless you name conflicts). Drop it in, commit, start using.

### Q: How do I update the system later?

**A:** 
1. Modify files directly and update version headers
2. Or regenerate with new inputs (specify `AVAILABLE_TOOLS` to avoid duplicates)
3. Use `.ai/CHANGELOG.md` to track changes

### Q: Is this for solo devs or teams?

**A:** Both! Solo devs get instant structure. Teams customize `.ai/CONFIG.yaml` and `.ai/context/STANDARDS.md` for shared conventions.

### Q: What if I only want Windsurf support?

**A:** Set `AVAILABLE_TOOLS: "windsurf"`. Only `.windsurf/` files are generated. Core `.ai/` system still created (universal).

### Q: Can I remove an agent I don't need?

**A:** Yes. Delete the agent file (e.g., `.ai/agents/releaser.md`). Update `.ai/AGENTS_INDEX.md` and `.ai/ORCHESTRATOR.md` to remove references.

### Q: How do I know it's working?

**A:** After generation:
1. Ask your AI tool: "Use the planning workflow to plan a test feature"
2. Tool should read `.ai/workflows/10-plan.md`, invoke `.ai/agents/planner.md`, output plan
3. Check `.ai/logs/runs/` for log files

If this happens, it's working!

---

## 🎉 Success Checklist

Before considering setup complete:

- [ ] All required files generated (check file tree)
- [ ] `.ai/GUIDE.md` exists and is readable
- [ ] `.ai/ORCHESTRATOR.md` has routing logic
- [ ] Tool-specific files present (AGENTS.md, .claude/, etc.)
- [ ] Tested one workflow successfully
- [ ] Logs appear in `.ai/logs/runs/` after workflow
- [ ] `scripts/init-project.sh` runs without errors (if applicable)
- [ ] `.ai/CONFIG.yaml` is customized for your needs
- [ ] Version headers present in all files
- [ ] `.ai/CHANGELOG.md` exists

---

## 📞 Getting Help

### If the Prompt Doesn't Work

1. **Check inputs:** Are all required fields filled?
2. **Check tool:** Is your AI tool up to date?
3. **Check syntax:** XML must be valid, YAML must be valid
4. **Check permissions:** Can the tool create files in your directory?

### If Generated Files Have Issues

1. **Ask for regeneration:** "Regenerate [filename] with [specific fix]"
2. **Manual edit:** Edit the file, update version header
3. **Report:** If it's a systematic issue, report to tool vendor

### If You Need Features Not Included

1. **Request addition:** "Add a [feature] to [component]"
2. **Modify CONFIG.yaml:** Many behaviors are configurable
3. **Fork and extend:** The system is designed for customization

---

## 🏁 Final Notes

This Master Prompt is designed to be:

✅ **Complete:** No placeholders, no "TODO", production-ready  
✅ **Modular:** Easy to extend, customize, and maintain  
✅ **Universal:** Works with any project, stack, tool combination  
✅ **Traceable:** Full versioning and logging  
✅ **Guided:** Step-by-step for users, clear for LLMs  

**Start simple, iterate often, and enjoy Vibe Coding!** 🚀

---

**End of Usage Guide**

*Version 1.0.0 | 2026-02-03 | Ready to use*
