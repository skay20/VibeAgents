#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import shutil
import subprocess
from pathlib import Path


def _write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def _append(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as f:
        f.write(content)


def _copy_file(src: Path, dst: Path, missing_file: Path) -> None:
    if not src.exists():
        _append(missing_file, f"MISSING: {src.as_posix()}\n")
        return
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)


def _copy_tree(src: Path, dst: Path, missing_file: Path) -> None:
    if not src.exists():
        _append(missing_file, f"MISSING: {src.as_posix()}\n")
        return
    if src.is_file():
        _copy_file(src, dst, missing_file)
        return
    if dst.exists():
        shutil.rmtree(dst)
    shutil.copytree(src, dst)


def _run(cmd: list[str], cwd: Path, out_file: Path, err_file: Path) -> int:
    try:
        p = subprocess.run(cmd, cwd=str(cwd), text=True, capture_output=True)
    except Exception as e:
        _append(err_file, f"CMD FAILED (exception): {' '.join(cmd)}\n{e}\n\n")
        return 1
    if p.stdout:
        _append(out_file, p.stdout + ("\n" if not p.stdout.endswith("\n") else ""))
    if p.returncode != 0:
        _append(err_file, f"CMD FAILED ({p.returncode}): {' '.join(cmd)}\n{p.stderr}\n\n")
    return p.returncode


def _find_latest_run_id_with_metrics(repo_root: Path) -> str | None:
    metrics_root = repo_root / ".agentic" / "bus" / "metrics"

    # Prefer runs that have any per-agent metrics (implementer.json is the best signal).
    if metrics_root.is_dir():
        candidates = []
        for run_dir in sorted(metrics_root.iterdir()):
            if not run_dir.is_dir():
                continue
            if (run_dir / "implementer.json").exists():
                candidates.append(run_dir)
        candidates.sort(key=lambda p: p.stat().st_mtime, reverse=True)
        if candidates:
            return candidates[0].name

        # Fallback: any metrics json besides events.jsonl
        candidates = []
        for run_dir in sorted(metrics_root.iterdir()):
            if not run_dir.is_dir():
                continue
            any_json = [p for p in run_dir.glob("*.json") if p.name != "events.jsonl"]
            if any_json:
                candidates.append(run_dir)
        candidates.sort(key=lambda p: p.stat().st_mtime, reverse=True)
        if candidates:
            return candidates[0].name

    return None


def _write_llm_prompt(debug_dir: Path) -> None:
    prompt = """# Debug Sweep Review (Do Not Invent)

You are reviewing a run Debug package created by `agentic-debug-audit`.

## What You Must Do
- Use `Debug/audit_summary.md` as the primary source.
- Cross-check with copied evidence under `Debug/.agentic/` and `Debug/.ai/` when needed.
- Confirm whether agent concatenation worked:
  - Planned agents vs executed agents (metrics-based).
  - Tier/dispatch artifacts present.
  - Enforcement results (pre_release/final) and why.
- Identify the minimal, highest-leverage fixes for the next iteration.

## Output Format
1. Verdict: `OK` or `BROKEN`
2. Evidence (bullet list of file paths you used)
3. Root cause (1-3 bullets)
4. Fix plan (3-7 bullets, minimal changes first)
5. Optional: Suggested improvement to the debug sweep if it is misconfigured
"""
    _write(debug_dir / "LLM_PROMPT.md", prompt)


def main() -> int:
    ap = argparse.ArgumentParser(description="Create Debug/ folder and audit agentic run evidence.")
    ap.add_argument("--debug-dir", default="Debug", help="Debug folder (default: Debug)")
    ap.add_argument("--run-id", default="", help="Run ID override (default: auto-detect)")
    ap.add_argument("--tier", default="standard", help="Tier for enforcement checks (default: standard)")
    args = ap.parse_args()

    repo_root = Path(os.getcwd()).resolve()
    debug_dir = (repo_root / args.debug_dir).resolve()
    debug_dir.mkdir(parents=True, exist_ok=True)

    missing_file = debug_dir / "missing.txt"
    errors_file = debug_dir / "errors.txt"
    checks_file = debug_dir / "checks.txt"

    # Reset sweep logs for deterministic re-runs.
    for p in (missing_file, errors_file, checks_file):
        _write(p, "")

    run_id = args.run_id.strip() or _find_latest_run_id_with_metrics(repo_root)
    if not run_id:
        _append(errors_file, "No audit-able RUN_ID detected.\n")
        _append(errors_file, "This sweep requires a run with per-agent metrics JSON files under:\n")
        _append(errors_file, "  .agentic/bus/metrics/<run_id>/*.json\n")
        _append(errors_file, "Fix:\n")
        _append(errors_file, "- Run a real PRD iteration that calls log-metrics.sh for agents.\n")
        _append(errors_file, "- Or re-run with an explicit run id: --run-id <RUN_ID>\n")
        return 2

    _write(debug_dir / "run_id.txt", f"{run_id}\n")
    _write(debug_dir / "tier.txt", f"{args.tier}\n")

    # Copy core instruction files (best-effort; paths may differ per project).
    _copy_file(repo_root / "AGENTS.md", debug_dir / "AGENTS.md", missing_file)
    _copy_file(repo_root / ".agentic" / "adapters" / "UNIVERSAL.md", debug_dir / ".agentic" / "adapters" / "UNIVERSAL.md", missing_file)
    _copy_file(repo_root / ".agentic" / "CONSTITUTION.md", debug_dir / ".agentic" / "CONSTITUTION.md", missing_file)
    _copy_file(repo_root / ".agentic" / "settings.json", debug_dir / ".agentic" / "settings.json", missing_file)
    _copy_file(repo_root / ".ai" / "context" / "RUNTIME_MIN.md", debug_dir / ".ai" / "context" / "RUNTIME_MIN.md", missing_file)

    # Copy run evidence.
    _copy_file(
        repo_root / ".agentic" / "bus" / "state" / f"{run_id}.json",
        debug_dir / ".agentic" / "bus" / "state" / f"{run_id}.json",
        missing_file,
    )
    _copy_file(
        repo_root / ".agentic" / "bus" / "metrics" / run_id / "events.jsonl",
        debug_dir / ".agentic" / "bus" / "metrics" / run_id / "events.jsonl",
        missing_file,
    )
    # Copy per-agent metrics json files.
    metrics_dir = repo_root / ".agentic" / "bus" / "metrics" / run_id
    if metrics_dir.is_dir():
        for p in sorted(metrics_dir.glob("*.json")):
            if p.name == "events.jsonl":
                continue
            _copy_file(p, debug_dir / ".agentic" / "bus" / "metrics" / run_id / p.name, missing_file)
    else:
        _append(missing_file, f"MISSING: {metrics_dir.as_posix()}\n")

    # Copy artifacts directory (selected key artifacts only, plus flow governance).
    art_dir = repo_root / ".agentic" / "bus" / "artifacts" / run_id
    if art_dir.is_dir():
        keys = [
            "orchestrator_entrypoint.md",
            "decisions.md",
            "plan.md",
            "diff_summary.md",
            "qa_report.md",
            "docs_report.md",
            "release_notes.md",
            "questions_log.md",
            "tier_decision.md",
            "dispatch_signals.md",
            "dispatch_resolution.md",
            "planned_agents.md",
            "flow_evidence.md",
            "project_root.txt",
            "project_runbook_path.txt",
            "project_readme_path.txt",
        ]
        for k in keys:
            _copy_file(art_dir / k, debug_dir / ".agentic" / "bus" / "artifacts" / run_id / k, missing_file)
    else:
        _append(missing_file, f"MISSING: {art_dir.as_posix()}\n")

    # Run checks (do not fail sweep if a check is missing).
    _append(checks_file, f"RUN_ID={run_id}\nTIER={args.tier}\n\n")
    if (repo_root / "scripts" / "verify.sh").exists():
        _append(checks_file, "===== verify =====\n./scripts/verify.sh\n")
        _run(["bash", "./scripts/verify.sh"], repo_root, checks_file, errors_file)
        _append(checks_file, "\n")
    else:
        _append(missing_file, f"MISSING: {(repo_root / 'scripts' / 'verify.sh').as_posix()}\n")

    if (repo_root / "scripts" / "enforce-flow.sh").exists():
        _append(checks_file, "===== enforce pre_release =====\n")
        _append(checks_file, f"./scripts/enforce-flow.sh {run_id} {args.tier} pre_release\n")
        _run(["bash", "./scripts/enforce-flow.sh", run_id, args.tier, "pre_release"], repo_root, checks_file, errors_file)
        _append(checks_file, "\n===== enforce final =====\n")
        _append(checks_file, f"./scripts/enforce-flow.sh {run_id} {args.tier} final\n")
        _run(["bash", "./scripts/enforce-flow.sh", run_id, args.tier, "final"], repo_root, checks_file, errors_file)
        _append(checks_file, "\n")
    else:
        _append(missing_file, f"MISSING: {(repo_root / 'scripts' / 'enforce-flow.sh').as_posix()}\n")

    # Write LLM prompt for copy/paste.
    _write_llm_prompt(debug_dir)

    # Run local audit over the generated Debug/ folder.
    audit_script = repo_root / "skills" / "agentic-debug-audit" / "scripts" / "audit_debug.py"
    if audit_script.exists():
        _run(["python3", str(audit_script), "--debug-dir", str(debug_dir)], repo_root, checks_file, errors_file)
    else:
        _append(missing_file, f"MISSING: {audit_script.as_posix()}\n")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
