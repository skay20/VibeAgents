#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any


AGENT_ID_RE = re.compile(
    r"\b("
    r"god_orchestrator|intent_translator|context_curator|stack_advisor|architect|planner|implementer|qa_reviewer|"
    r"security_reviewer|docs_writer|release_manager|repo_maintainer|template_librarian|migration_manager"
    r")\b"
)


def _read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def _safe_read_text(path: Path) -> str:
    try:
        return _read_text(path)
    except Exception:
        return ""


def _safe_read_json(path: Path) -> dict[str, Any] | None:
    try:
        return json.loads(_read_text(path))
    except Exception:
        return None


def _parse_iso(ts: str | None) -> datetime | None:
    if not ts:
        return None
    ts = ts.replace("Z", "+00:00")
    try:
        return datetime.fromisoformat(ts)
    except Exception:
        return None


def _find_run_id(debug_dir: Path) -> str | None:
    run_id_txt = debug_dir / "run_id.txt"
    if run_id_txt.exists():
        rid = run_id_txt.read_text(encoding="utf-8").strip()
        return rid or None

    # Fallback: take the newest state file.
    state_dir = debug_dir / ".agentic" / "bus" / "state"
    if state_dir.is_dir():
        candidates = sorted(state_dir.glob("*.json"), key=lambda p: p.stat().st_mtime, reverse=True)
        if candidates:
            return candidates[0].stem
    return None


def _parse_planned_agents(planned_agents_md: str) -> list[str]:
    agents = []
    for line in planned_agents_md.splitlines():
        m = re.match(r"^\s*-\s*([a-z_]+)\s*$", line)
        if m and AGENT_ID_RE.search(m.group(1)):
            agents.append(m.group(1))
    # Dedup preserving order
    seen = set()
    out = []
    for a in agents:
        if a not in seen:
            out.append(a)
            seen.add(a)
    return out


def _parse_dispatch_resolution(dispatch_md: str) -> dict[str, dict[str, Any]]:
    out: dict[str, dict[str, Any]] = {}
    for line in dispatch_md.splitlines():
        line = line.strip()
        m = re.match(
            r"^-?\s*agent_id:\s*([a-z_]+)\s*\|\s*selected=(true|false)\s*\|\s*required=(true|false)\s*\|\s*reason=([a-z_]+)\s*\|\s*score=([0-9]+)\s*$",
            line,
        )
        if not m:
            continue
        agent_id, selected, required, reason, score = m.groups()
        out[agent_id] = {
            "selected": selected == "true",
            "required": required == "true",
            "reason": reason,
            "score": int(score),
        }
    return out


@dataclass(frozen=True)
class AuditPaths:
    debug_dir: Path
    run_id: str
    state_file: Path
    artifacts_dir: Path
    metrics_dir: Path
    events_file: Path


def _resolve_paths(debug_dir: Path, run_id: str) -> AuditPaths:
    state_file = debug_dir / ".agentic" / "bus" / "state" / f"{run_id}.json"
    artifacts_dir = debug_dir / ".agentic" / "bus" / "artifacts" / run_id
    metrics_dir = debug_dir / ".agentic" / "bus" / "metrics" / run_id
    events_file = metrics_dir / "events.jsonl"
    return AuditPaths(
        debug_dir=debug_dir,
        run_id=run_id,
        state_file=state_file,
        artifacts_dir=artifacts_dir,
        metrics_dir=metrics_dir,
        events_file=events_file,
    )


def _list_agent_metrics(metrics_dir: Path) -> list[Path]:
    if not metrics_dir.is_dir():
        return []
    files = []
    for p in sorted(metrics_dir.glob("*.json")):
        if p.name == "events.jsonl":
            continue
        files.append(p)
    return files


def _parse_events(events_path: Path) -> dict[str, Any]:
    result: dict[str, Any] = {
        "event_count": 0,
        "run_start_count": 0,
        "agent_start_count": 0,
        "agent_end_count": 0,
        "question_asked_count": 0,
        "answer_received_count": 0,
        "agents_seen": [],
        "first_ts": None,
        "last_ts": None,
    }
    if not events_path.exists():
        return result

    agents_seen: set[str] = set()
    first: datetime | None = None
    last: datetime | None = None

    for line in _safe_read_text(events_path).splitlines():
        if not line.strip():
            continue
        try:
            evt = json.loads(line)
        except Exception:
            continue
        result["event_count"] += 1
        et = evt.get("event_type", "")
        aid = evt.get("agent_id", "")
        if isinstance(aid, str) and aid:
            agents_seen.add(aid)

        ts = _parse_iso(evt.get("timestamp"))
        if ts:
            first = ts if first is None or ts < first else first
            last = ts if last is None or ts > last else last

        if et == "run_start":
            result["run_start_count"] += 1
        elif et == "agent_start":
            result["agent_start_count"] += 1
        elif et == "agent_end":
            result["agent_end_count"] += 1
        elif et == "question_asked":
            result["question_asked_count"] += 1
        elif et == "answer_received":
            result["answer_received_count"] += 1

    result["agents_seen"] = sorted(agents_seen)
    result["first_ts"] = first.isoformat() if first else None
    result["last_ts"] = last.isoformat() if last else None
    return result


def _mk_missing(debug_dir: Path, rel: str) -> None:
    missing = debug_dir / "missing.txt"
    missing.parent.mkdir(parents=True, exist_ok=True)
    with missing.open("a", encoding="utf-8") as f:
        f.write(f"MISSING: {rel}\n")


def main() -> int:
    ap = argparse.ArgumentParser(description="Audit a Debug/ folder for agentic run correctness.")
    ap.add_argument("--debug-dir", default="Debug", help="Path to Debug folder (default: Debug)")
    ap.add_argument("--run-id", default="", help="Optional run_id override")
    args = ap.parse_args()

    debug_dir = Path(args.debug_dir).resolve()
    if not debug_dir.is_dir():
        raise SystemExit(f"[FAIL] Debug dir not found: {debug_dir}")

    run_id = args.run_id.strip() or _find_run_id(debug_dir)
    if not run_id:
        raise SystemExit("[FAIL] Could not determine run_id (missing run_id.txt and no state files).")

    paths = _resolve_paths(debug_dir, run_id)

    state = _safe_read_json(paths.state_file) or {}
    if not paths.state_file.exists():
        _mk_missing(debug_dir, str(paths.state_file.relative_to(debug_dir)))

    planned_agents_md = _safe_read_text(paths.artifacts_dir / "planned_agents.md")
    dispatch_resolution_md = _safe_read_text(paths.artifacts_dir / "dispatch_resolution.md")
    flow_evidence_md = _safe_read_text(paths.artifacts_dir / "flow_evidence.md")

    planned_agents = _parse_planned_agents(planned_agents_md) if planned_agents_md else []
    dispatch_resolution = _parse_dispatch_resolution(dispatch_resolution_md) if dispatch_resolution_md else {}
    catalog_rows = sorted(dispatch_resolution.keys())

    metrics_files = _list_agent_metrics(paths.metrics_dir)
    executed_agents = sorted([p.stem for p in metrics_files])
    events_summary = _parse_events(paths.events_file)

    tier = state.get("selected_tier") or ""
    gate_status = state.get("gate_status") or ""
    flow_status = state.get("flow_status") or ""

    # Failure shape detection
    shapes: list[str] = []
    if planned_agents and not executed_agents:
        shapes.append("planned_but_no_agent_metrics")
    if events_summary.get("event_count", 0) > 0 and events_summary.get("agent_end_count", 0) == 0:
        shapes.append("no_agent_end_events")
    if dispatch_resolution and len(catalog_rows) < 14:
        shapes.append("dispatch_catalog_incomplete")
    if gate_status != "approved" and "final" in flow_evidence_md.lower():
        shapes.append("final_gate_not_approved")

    # Actionable suggestions
    suggestions: list[str] = []
    if "planned_but_no_agent_metrics" in shapes:
        suggestions.append(
            "No per-agent metrics found even though agents were planned. This usually means the work chain never executed, or log-metrics.sh was not called by the tool/flow."
        )
        suggestions.append(
            "If this Debug folder was generated by a sweep, confirm it audited a real run_id (from the real implementation run) instead of starting a new empty run."
        )
    if events_summary.get("run_start_count", 0) >= 1 and events_summary.get("agent_start_count", 0) <= 1 and not executed_agents:
        suggestions.append(
            "Entrypoint started but did not progress into agent execution. Check the side-project runner path: it may be using only orchestrator-first + resolve-dispatch without actually invoking agents."
        )
    if not dispatch_resolution_md:
        suggestions.append("Missing dispatch_resolution.md; ensure resolve-dispatch.sh was executed for this run before implementation.")
    if not flow_evidence_md:
        suggestions.append("Missing flow_evidence.md; enforce-flow.sh was not run or artifacts were not copied into Debug.")

    audit = {
        "run_id": run_id,
        "debug_dir": str(debug_dir),
        "tier": tier,
        "gate_status": gate_status,
        "flow_status": flow_status,
        "planned_agents": planned_agents,
        "executed_agents": executed_agents,
        "dispatch_catalog_rows": catalog_rows,
        "events": events_summary,
        "shapes": shapes,
        "suggestions": suggestions,
        "paths": {
            "state_file": str(paths.state_file),
            "artifacts_dir": str(paths.artifacts_dir),
            "metrics_dir": str(paths.metrics_dir),
            "events_file": str(paths.events_file),
        },
    }

    out_json = debug_dir / "audit.json"
    out_md = debug_dir / "audit_summary.md"
    out_json.write_text(json.dumps(audit, indent=2) + "\n", encoding="utf-8")

    md_lines: list[str] = []
    md_lines.append("# Debug Audit Summary")
    md_lines.append("")
    md_lines.append(f"- Run ID: `{run_id}`")
    md_lines.append(f"- Tier: `{tier or 'unknown'}`")
    md_lines.append(f"- Gate Status: `{gate_status or 'unknown'}`")
    md_lines.append(f"- Flow Status: `{flow_status or 'unknown'}`")
    md_lines.append("")
    md_lines.append("## Agents")
    md_lines.append(f"- Planned: {', '.join(planned_agents) if planned_agents else '(none)'}")
    md_lines.append(f"- Executed (metrics): {', '.join(executed_agents) if executed_agents else '(none)'}")
    md_lines.append(f"- Dispatch rows: {len(catalog_rows)}")
    md_lines.append("")
    md_lines.append("## Events")
    md_lines.append(f"- Total: {events_summary.get('event_count', 0)}")
    md_lines.append(f"- run_start: {events_summary.get('run_start_count', 0)}")
    md_lines.append(f"- agent_start: {events_summary.get('agent_start_count', 0)}")
    md_lines.append(f"- agent_end: {events_summary.get('agent_end_count', 0)}")
    md_lines.append(f"- question_asked: {events_summary.get('question_asked_count', 0)}")
    md_lines.append(f"- answer_received: {events_summary.get('answer_received_count', 0)}")
    md_lines.append("")
    md_lines.append("## Detected Shapes")
    if shapes:
        for s in shapes:
            md_lines.append(f"- {s}")
    else:
        md_lines.append("- (none)")
    md_lines.append("")
    md_lines.append("## Suggestions")
    if suggestions:
        for s in suggestions:
            md_lines.append(f"- {s}")
    else:
        md_lines.append("- (none)")
    md_lines.append("")
    md_lines.append("## Evidence Paths")
    md_lines.append(f"- State: `{paths.state_file}`")
    md_lines.append(f"- Artifacts: `{paths.artifacts_dir}`")
    md_lines.append(f"- Metrics: `{paths.metrics_dir}`")
    md_lines.append(f"- Events: `{paths.events_file}`")
    md_lines.append("")

    out_md.write_text("\n".join(md_lines), encoding="utf-8")
    print(str(out_md))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

