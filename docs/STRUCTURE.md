---
Managed-By: AgenticRepoBuilder
Template-Source: templates/docs/STRUCTURE.md
Template-Version: 1.17.0
Last-Generated: 2026-02-06T14:05:00Z
Ownership: Managed
---
# Project Structure

```text
.
├─ TREE.md
├─ repo_manifest.json
├─ README.md
├─ CHANGELOG.md
├─ docs/
│  ├─ PRD.md
│  ├─ ARCHITECTURE.md
│  ├─ QUICKSTART.md
│  ├─ RUNBOOK.md
│  ├─ STRUCTURE.md
│  ├─ GENERICITY_FIX_REPORT.md
│  └─ ADR/
│     └─ 0001-initial.md
├─ .ai/
│  ├─ context/
│  │  ├─ BOOTSTRAP.md
│  │  ├─ CORE.md
│  │  ├─ PROJECT.md
│  │  ├─ RUNTIME_MIN.md
│  │  ├─ STANDARDS.md
│  │  ├─ SECURITY.md
│  │  └─ TESTING.md
│  ├─ logs/
│  │  └─ runs/.gitkeep
│  └─ state/.gitkeep
├─ .agentic/
│  ├─ README.md
│  ├─ VERSION.md
│  ├─ CHANGELOG.md
│  ├─ CONSTITUTION.md
│  ├─ WORKFLOWS_GUIDE.md
│  ├─ AGENTS_CATALOG.md
│  ├─ settings.json
│  ├─ adapters/
│  │  └─ UNIVERSAL.md
│  ├─ templates/.gitkeep
│  ├─ migrations/.gitkeep
│  ├─ migrations/0.4.0/README.md
│  ├─ connectors/
│  │  ├─ README.md
│  │  ├─ repo_fs.md
│  │  ├─ ci.md
│  │  ├─ tickets.md
│  │  └─ docs_knowledge.md
│  ├─ bus/
│  │  ├─ SCHEMA.md
│  │  ├─ schemas/
│  │  │  ├─ task.schema.json
│  │  │  ├─ decision.schema.json
│  │  │  ├─ artifact.schema.json
│  │  │  ├─ diff_summary.schema.json
│  │  │  ├─ plan.schema.json
│  │  │  ├─ qa_report.schema.json
│  │  │  ├─ runstate.schema.json
│  │  │  ├─ agent_metrics.schema.json
│  │  │  └─ event.schema.json
│  │  ├─ artifacts/.gitkeep
│  │  ├─ locks/.gitkeep
│  │  ├─ metrics/.gitkeep
│  │  └─ state/.gitkeep
│  └─ agents/
│     ├─ _CORE.md
│     ├─ god_orchestrator.md
│     ├─ god_orchestrator.v2.md
│     ├─ intent_translator.md
│     ├─ intent_translator.v2.md
│     ├─ context_curator.md
│     ├─ context_curator.v2.md
│     ├─ stack_advisor.md
│     ├─ stack_advisor.v2.md
│     ├─ architect.md
│     ├─ architect.v2.md
│     ├─ planner.md
│     ├─ planner.v2.md
│     ├─ implementer.md
│     ├─ implementer.v2.md
│     ├─ qa_reviewer.md
│     ├─ qa_reviewer.v2.md
│     ├─ security_reviewer.md
│     ├─ security_reviewer.v2.md
│     ├─ docs_writer.md
│     ├─ docs_writer.v2.md
│     ├─ release_manager.md
│     ├─ release_manager.v2.md
│     ├─ repo_maintainer.md
│     ├─ repo_maintainer.v2.md
│     ├─ template_librarian.md
│     ├─ template_librarian.v2.md
│     ├─ migration_manager.md
│     ├─ migration_manager.v2.md
│     └─ backup_v1/
├─ AGENTS.md
├─ GEMINI.md
├─ .gemini/
│  ├─ config.yaml
│  └─ styleguide.md
├─ .claude/
│  ├─ CLAUDE.md
│  └─ rules/
│     ├─ prd.md
│     ├─ style.md
│     ├─ testing.md
│     └─ security.md
├─ .cursor/
│  └─ rules/
│     ├─ 00-global.mdc
│     ├─ 10-frontend.mdc
│     ├─ 20-backend.mdc
│     └─ 90-prd.mdc
├─ .windsurf/
│  ├─ rules/
│  │  ├─ 00-global.md
│  │  ├─ 10-frontend.md
│  │  ├─ 20-backend.md
│  │  └─ 90-prd.md
│  └─ workflows/
│     ├─ init.md
│     ├─ plan.md
│     ├─ implement.md
│     ├─ qa.md
│     └─ release.md
├─ .github/
│  ├─ copilot-instructions.md
│  └─ workflows/
│     └─ node-ci.yml
└─ scripts/
   ├─ init-project.sh
   ├─ log-run.sh
   ├─ log-metrics.sh
   ├─ log-event.sh
   ├─ log-question.sh
   ├─ preflight.py
   ├─ preflight.sh
   ├─ start-run.sh
   ├─ render-agent-prompt.sh
   ├─ resolve-project-root.py
   ├─ resolve-project-root.sh
   ├─ ensure-project-runbook.py
   ├─ ensure-project-runbook.sh
   ├─ ensure-project-readme.py
   ├─ ensure-project-readme.sh
   └─ verify.sh
```
