#!/usr/bin/env python3
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/ensure-project-runbook.py
# Template-Version: 1.0.0
# Last-Generated: 2026-02-07T00:00:00Z
# Ownership: Managed

from __future__ import annotations

import argparse
import json
import os
from datetime import datetime, timezone
from pathlib import Path


def _now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _read_settings(repo_root: Path) -> dict:
    settings_path = repo_root / ".agentic" / "settings.json"
    return json.loads(settings_path.read_text(encoding="utf-8"))


def _resolve_project_root(repo_root: Path, run_id: str, write_artifact: bool) -> str:
    import subprocess

    cmd = ["python3", str(repo_root / "scripts" / "resolve-project-root.py"), run_id, "--print-relative"]
    if write_artifact:
        cmd.append("--write-artifact")
    out = subprocess.check_output(cmd, cwd=str(repo_root), text=True).strip()
    return out


def _detect_pm(project_root: Path) -> str:
    pkg_mgr = None
    pkg_json = project_root / "package.json"
    if pkg_json.exists():
        try:
            payload = json.loads(pkg_json.read_text(encoding="utf-8"))
            pkg_mgr = payload.get("packageManager")
        except Exception:
            pkg_mgr = None

    if isinstance(pkg_mgr, str):
        if pkg_mgr.startswith("pnpm@"):
            return "pnpm"
        if pkg_mgr.startswith("yarn@"):
            return "yarn"

    if (project_root / "pnpm-lock.yaml").exists():
        return "pnpm"
    if (project_root / "yarn.lock").exists():
        return "yarn"
    return "npm"


def _pm_run(pm: str, script: str) -> str:
    if pm == "yarn":
        return f"yarn {script}"
    if pm == "pnpm":
        return f"pnpm {script}"
    return f"npm run {script}"


def _pm_install(pm: str, prefer_ci: bool) -> list[str]:
    if pm == "yarn":
        return ["yarn install --frozen-lockfile" if prefer_ci else "yarn install"]
    if pm == "pnpm":
        return ["pnpm install --frozen-lockfile" if prefer_ci else "pnpm install"]
    return ["npm ci" if prefer_ci else "npm install"]


def _render_node_runbook(project_root_rel: str, project_root: Path) -> str:
    pkg_json = project_root / "package.json"
    payload = json.loads(pkg_json.read_text(encoding="utf-8"))
    name = payload.get("name") or project_root.name
    scripts = payload.get("scripts") or {}
    if not isinstance(scripts, dict):
        scripts = {}

    pm = _detect_pm(project_root)
    prefer_ci = any((project_root / lf).exists() for lf in ["package-lock.json", "pnpm-lock.yaml", "yarn.lock"])
    install_cmds = _pm_install(pm, prefer_ci=prefer_ci)

    rows = []
    rows.append(("Install", install_cmds[0]))
    if "dev" in scripts:
        rows.append(("Dev", _pm_run(pm, "dev")))
    if "build" in scripts:
        rows.append(("Build", _pm_run(pm, "build")))
    if "test" in scripts:
        rows.append(("Test", _pm_run(pm, "test")))
    if "lint" in scripts:
        rows.append(("Lint", _pm_run(pm, "lint")))
    if "typecheck" in scripts:
        rows.append(("Typecheck", _pm_run(pm, "typecheck")))

    # Always show a fallback "start" if present.
    if "start" in scripts and not any(k == "Dev" for k, _ in rows):
        rows.append(("Start", _pm_run(pm, "start")))

    header = "\n".join(
        [
            "---",
            "Managed-By: AgenticRepoBuilder",
            "Template-Source: templates/project/RUNBOOK.md",
            "Template-Version: 1.0.0",
            f"Last-Generated: {_now_iso()}",
            "Ownership: Managed",
            "---",
            "",
        ]
    )

    md = [header]
    md.append(f"# Runbook: {name}")
    md.append("")
    md.append("## Quick Start")
    md.append(f"- Project root: `{project_root_rel}`")
    md.append(f"- From repo root: `cd {project_root_rel}`")
    md.append(f"- Install: `{install_cmds[0]}`")
    if "dev" in scripts:
        md.append(f"- Dev: `{_pm_run(pm, 'dev')}`")
    elif "start" in scripts:
        md.append(f"- Start: `{_pm_run(pm, 'start')}`")
    md.append("")
    md.append("## Commands")
    md.append("| Task | Command |")
    md.append("| --- | --- |")
    for task, cmd in rows:
        md.append(f"| {task} | `{cmd}` |")
    md.append("")
    md.append("## Notes")
    md.append("- If a command is missing in `package.json`, add a script or document it explicitly in this file.")
    md.append("- If the app fails to start, capture the terminal output and attach it to the next agent run.")
    md.append("")
    return "\n".join(md)


def main() -> int:
    ap = argparse.ArgumentParser(description="Generate/update a project RUNBOOK.md for a generated project run.")
    ap.add_argument("run_id")
    ap.add_argument("--repo-root", default=".")
    args = ap.parse_args()

    repo_root = Path(args.repo_root).resolve()
    settings = _read_settings(repo_root).get("settings", {})
    docs_cfg = settings.get("docs", {})

    run_id = args.run_id
    art_dir = repo_root / ".agentic" / "bus" / "artifacts" / run_id
    art_dir.mkdir(parents=True, exist_ok=True)

    project_root_rel = _resolve_project_root(repo_root, run_id, write_artifact=True)
    if not project_root_rel:
        (art_dir / "project_runbook_path.txt").write_text("\n", encoding="utf-8")
        print("[SKIP] No generated project root detected from metrics outputs_written.")
        return 0

    project_root = (repo_root / project_root_rel).resolve()
    if not project_root.exists():
        raise SystemExit(f"[FAIL] Resolved project_root does not exist: {project_root_rel}")

    template = docs_cfg.get("project_runbook_path", "<project_root>/RUNBOOK.md")
    runbook_rel = template.replace("<project_root>", project_root_rel).lstrip("./")
    runbook_path = (repo_root / runbook_rel).resolve()

    # Only generate if we can detect a runnable project type.
    if (project_root / "package.json").exists():
        content = _render_node_runbook(project_root_rel, project_root)
    else:
        (art_dir / "project_runbook_path.txt").write_text(runbook_rel + "\n", encoding="utf-8")
        print("[SKIP] Project detected but no supported marker found (package.json/pyproject.toml/etc).")
        return 0

    runbook_path.parent.mkdir(parents=True, exist_ok=True)
    runbook_path.write_text(content, encoding="utf-8")

    (art_dir / "project_runbook_path.txt").write_text(runbook_rel + "\n", encoding="utf-8")
    print(f"[OK] Wrote project runbook: {runbook_rel}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
