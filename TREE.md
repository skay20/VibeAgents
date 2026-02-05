---
Managed-By: AgenticRepoBuilder
Template-Source: templates/TREE.md
Template-Version: 1.14.0
Last-Generated: 2026-02-05T15:33:50Z
Ownership: Managed
---
# Repository Tree

This file is generated. Update it via the orchestrator and templates.

```text
.
├─ TREE.md
├─ repo_manifest.json
├─ README.md
├─ CHANGELOG.md
├─ docs/
│  ├─ PRD.md
│  ├─ ARCHITECTURE.md
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
│  │  │  ├─ runstate.schema.json
│  │  │  ├─ agent_metrics.schema.json
│  │  │  └─ event.schema.json
│  │  ├─ artifacts/.gitkeep
│  │  ├─ locks/.gitkeep
│  │  ├─ metrics/.gitkeep
│  │  └─ state/.gitkeep
│  └─ agents/
│     ├─ god_orchestrator.md
│     ├─ intent_translator.md
│     ├─ context_curator.md
│     ├─ stack_advisor.md
│     ├─ architect.md
│     ├─ planner.md
│     ├─ implementer.md
│     ├─ qa_reviewer.md
│     ├─ security_reviewer.md
│     ├─ docs_writer.md
│     ├─ release_manager.md
│     ├─ repo_maintainer.md
│     ├─ template_librarian.md
│     └─ migration_manager.md
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
   ├─ metrics_summarize.py
   └─ verify.sh
```
