#!/usr/bin/env python3
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/preflight.py
# Template-Version: 1.1.0
# Last-Generated: 2026-02-04T17:55:11Z
# Ownership: Managed

import json
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path


def load_settings():
    p = Path(".agentic/settings.json")
    if not p.exists():
        return {}
    try:
        return json.loads(p.read_text()).get("settings", {})
    except Exception:
        return {}


def pick_package_manager(root: Path, settings: dict) -> str:
    checks = settings.get("checks", {})
    if checks.get("package_manager_auto", True) is False:
        return "npm"
    if (root / "pnpm-lock.yaml").exists():
        return "pnpm"
    if (root / "yarn.lock").exists():
        return "yarn"
    return "npm"


def run_cmd(cmd, cwd, timeout_sec=None):
    start = time.time()
    proc = subprocess.Popen(
        cmd,
        cwd=str(cwd),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    try:
        out, err = proc.communicate(timeout=timeout_sec)
        duration = int((time.time() - start) * 1000)
        return {
            "cmd": cmd,
            "exit_code": proc.returncode,
            "stdout": out,
            "stderr": err,
            "duration_ms": duration,
            "timed_out": False,
        }
    except subprocess.TimeoutExpired:
        proc.terminate()
        try:
            proc.wait(timeout=3)
        except subprocess.TimeoutExpired:
            proc.kill()
        out, err = proc.communicate()
        duration = int((time.time() - start) * 1000)
        return {
            "cmd": cmd,
            "exit_code": 0,
            "stdout": out,
            "stderr": err,
            "duration_ms": duration,
            "timed_out": True,
        }


def main():
    if len(sys.argv) < 2:
        print("Usage: scripts/preflight.py <run_id> [project_root]")
        sys.exit(1)

    run_id = sys.argv[1]
    root = Path(sys.argv[2]) if len(sys.argv) > 2 else Path(".")

    settings = load_settings()
    checks = settings.get("checks", {})
    telemetry = settings.get("telemetry", {})
    automation = settings.get("automation", {})

    if not checks.get("preflight_enabled", True):
        print("Preflight disabled in settings.")
        sys.exit(0)

    if not (root / "package.json").exists():
        print("No package.json found; skipping npm preflight.")
        sys.exit(0)

    pkg_manager = pick_package_manager(root, settings)
    if shutil.which(pkg_manager) is None:
        print(f"Package manager not found: {pkg_manager}")
        sys.exit(1)

    if automation.get("run_scripts", True) and automation.get("auto_log_agents", True):
        if telemetry.get("events", True) and Path("scripts/log-event.sh").exists():
            subprocess.run(
                ["scripts/log-event.sh", run_id, "preflight_start", "qa_reviewer", "preflight start", "qa", os.environ.get("AGENTIC_TOOL", "")],
                check=False,
            )

    install_cmd = [pkg_manager, "install"] if pkg_manager != "yarn" else ["yarn", "install"]
    dev_cmd = (
        [pkg_manager, "run", "dev"]
        if pkg_manager != "yarn"
        else ["yarn", "dev"]
    )

    results = []
    timeout_sec = int(checks.get("preflight_timeout_sec", 20))

    if checks.get("preflight_run_install", True):
        results.append(run_cmd(install_cmd, root, timeout_sec=None))

    if checks.get("preflight_run_dev", True):
        results.append(run_cmd(dev_cmd, root, timeout_sec=timeout_sec))

    status = "pass"
    notes = []
    for r in results:
        if r["cmd"] == dev_cmd and r["timed_out"]:
            notes.append("Dev server started (timeout reached).")
            continue
        if r["exit_code"] != 0:
            status = "fail"
            if "ETARGET" in (r["stderr"] or ""):
                notes.append("ETARGET: dependency version not found.")
            if "command not found" in (r["stderr"] or ""):
                notes.append("Missing binary (check devDependencies).")

    art_dir = Path(f".agentic/bus/artifacts/{run_id}")
    art_dir.mkdir(parents=True, exist_ok=True)
    report_path = art_dir / "preflight_report.md"

    lines = [
        "# Preflight Report",
        "",
        f"Run ID: {run_id}",
        f"Project Root: {root}",
        f"Package Manager: {pkg_manager}",
        f"Status: {status}",
        "",
        "## Steps",
    ]

    for r in results:
        lines += [
            f"### {' '.join(r['cmd'])}",
            f"- Exit Code: {r['exit_code']}",
            f"- Duration (ms): {r['duration_ms']}",
            f"- Timed Out: {r['timed_out']}",
            "",
            "```",
            (r["stdout"] or "").strip(),
            "```",
            "",
            "```",
            (r["stderr"] or "").strip(),
            "```",
            "",
        ]

    if notes:
        lines += ["## Notes"] + [f"- {n}" for n in notes]

    report_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Preflight report written: {report_path}")

    if automation.get("run_scripts", True) and automation.get("auto_log_agents", True):
        if telemetry.get("events", True) and Path("scripts/log-event.sh").exists():
            subprocess.run(
                ["scripts/log-event.sh", run_id, "preflight_end", "qa_reviewer", f"preflight {status}", "qa", os.environ.get("AGENTIC_TOOL", "")],
                check=False,
            )


if __name__ == "__main__":
    main()
