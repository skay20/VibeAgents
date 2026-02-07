#!/usr/bin/env python3
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/metrics_compare.py
# Template-Version: 1.1.0
# Last-Generated: 2026-02-06T16:25:00Z
# Ownership: Managed

import json
import shutil
import sys
from pathlib import Path
from typing import Dict, List, Optional


def usage() -> None:
    print("Usage: scripts/metrics_compare.py <baseline_run_id> <experiment_run_id> <benchmark_id>")


def num(value) -> Optional[int]:
    if value is None:
        return None
    try:
        return int(value)
    except Exception:
        return None


def load_events(events_path: Path) -> Dict[str, int]:
    counts: Dict[str, int] = {}
    if not events_path.exists():
        return counts
    try:
        for line in events_path.read_text().splitlines():
            if not line.strip():
                continue
            event = json.loads(line)
            event_type = event.get("event_type", "")
            counts[event_type] = counts.get(event_type, 0) + 1
    except Exception:
        return counts
    return counts


def load_rows(metrics_dir: Path) -> List[dict]:
    rows: List[dict] = []
    for path in sorted(metrics_dir.glob("*.json")):
        try:
            rows.append(json.loads(path.read_text()))
        except Exception:
            continue
    return rows


def summarize_run(run_id: str) -> dict:
    metrics_dir = Path(f".agentic/bus/metrics/{run_id}")
    if not metrics_dir.exists():
        raise FileNotFoundError(f"Missing metrics dir: {metrics_dir}")

    rows = load_rows(metrics_dir)
    if not rows:
        raise ValueError(f"No metrics found for run_id {run_id} in {metrics_dir}")

    events = load_events(metrics_dir / "events.jsonl")
    blocked = sum(1 for r in rows if r.get("status") == "blocked")
    failed = sum(1 for r in rows if r.get("status") == "failed")

    durations = [num(r.get("duration_ms")) for r in rows]
    durations = [d for d in durations if d is not None]
    avg_duration = int(sum(durations) / len(durations)) if durations else 0

    tokens_in_list = [num(r.get("tokens_in")) for r in rows]
    tokens_out_list = [num(r.get("tokens_out")) for r in rows]
    tokens_in_list = [t for t in tokens_in_list if t is not None]
    tokens_out_list = [t for t in tokens_out_list if t is not None]
    total_tokens_in = sum(tokens_in_list) if tokens_in_list else None
    total_tokens_out = sum(tokens_out_list) if tokens_out_list else None

    per_agent = {}
    for row in rows:
        agent_id = row.get("agent_id", "")
        per_agent[agent_id] = {
            "tool": row.get("tool", ""),
            "status": row.get("status", ""),
            "duration_ms": num(row.get("duration_ms")),
            "tokens_in": num(row.get("tokens_in")),
            "tokens_out": num(row.get("tokens_out")),
        }

    return {
        "run_id": run_id,
        "rows": rows,
        "total_agents": len(rows),
        "blocked": blocked,
        "failed": failed,
        "avg_duration_ms": avg_duration,
        "total_tokens_in": total_tokens_in,
        "total_tokens_out": total_tokens_out,
        "questions_asked": events.get("question_asked", 0),
        "answers_received": events.get("answer_received", 0),
        "events": events,
        "per_agent": per_agent,
    }


def delta(exp: int, base: int) -> int:
    return exp - base


def fmt_num(value):
    return "n/a" if value is None else value


def fmt_delta(exp, base):
    if exp is None or base is None:
        return "n/a"
    return delta(exp, base)


def maybe_copy_report(run_id: str, destination: Path) -> None:
    source = Path(f".agentic/bus/artifacts/{run_id}/agent_performance_report.md")
    if source.exists():
        shutil.copy2(source, destination)
        return
    destination.write_text(
        "# Agent Performance Report\n\n"
        f"Run ID: {run_id}\n\n"
        "Source report not found at `.agentic/bus/artifacts/<run_id>/agent_performance_report.md`.\n"
    )


def write_comparison(benchmark_dir: Path, baseline: dict, experiment: dict) -> Path:
    all_agents = sorted(set(baseline["per_agent"].keys()) | set(experiment["per_agent"].keys()))

    lines = [
        "# A/B Metrics Comparison",
        "",
        f"- Baseline run: `{baseline['run_id']}`",
        f"- Experiment run: `{experiment['run_id']}`",
        f"- Benchmark id: `{benchmark_dir.name}`",
        "",
        "## Summary",
        "| Metric | Baseline | Experiment | Delta (Exp-Base) |",
        "| --- | ---: | ---: | ---: |",
        f"| Total agents used | {baseline['total_agents']} | {experiment['total_agents']} | {delta(experiment['total_agents'], baseline['total_agents'])} |",
        f"| Blocked | {baseline['blocked']} | {experiment['blocked']} | {delta(experiment['blocked'], baseline['blocked'])} |",
        f"| Failed | {baseline['failed']} | {experiment['failed']} | {delta(experiment['failed'], baseline['failed'])} |",
        f"| Avg duration (ms) | {baseline['avg_duration_ms']} | {experiment['avg_duration_ms']} | {delta(experiment['avg_duration_ms'], baseline['avg_duration_ms'])} |",
        f"| Tokens in | {fmt_num(baseline['total_tokens_in'])} | {fmt_num(experiment['total_tokens_in'])} | {fmt_delta(experiment['total_tokens_in'], baseline['total_tokens_in'])} |",
        f"| Tokens out | {fmt_num(baseline['total_tokens_out'])} | {fmt_num(experiment['total_tokens_out'])} | {fmt_delta(experiment['total_tokens_out'], baseline['total_tokens_out'])} |",
        f"| Questions asked | {baseline['questions_asked']} | {experiment['questions_asked']} | {delta(experiment['questions_asked'], baseline['questions_asked'])} |",
        f"| Answers received | {baseline['answers_received']} | {experiment['answers_received']} | {delta(experiment['answers_received'], baseline['answers_received'])} |",
        "",
        "## Per-Agent Delta",
        "| Agent | Base Status | Exp Status | Base Duration | Exp Duration | Delta Duration | Base Tokens In | Exp Tokens In | Delta Tokens In | Base Tokens Out | Exp Tokens Out | Delta Tokens Out |",
        "| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]

    for agent in all_agents:
        base = baseline["per_agent"].get(agent, {})
        exp = experiment["per_agent"].get(agent, {})
        base_duration = base.get("duration_ms")
        exp_duration = exp.get("duration_ms")
        base_tokens_in = base.get("tokens_in")
        exp_tokens_in = exp.get("tokens_in")
        base_tokens_out = base.get("tokens_out")
        exp_tokens_out = exp.get("tokens_out")

        delta_duration = (exp_duration - base_duration) if (exp_duration is not None and base_duration is not None) else ""
        delta_tokens_in = (exp_tokens_in - base_tokens_in) if (exp_tokens_in is not None and base_tokens_in is not None) else ""
        delta_tokens_out = (exp_tokens_out - base_tokens_out) if (exp_tokens_out is not None and base_tokens_out is not None) else ""

        lines.append(
            f"| {agent} | {base.get('status', '')} | {exp.get('status', '')} | "
            f"{'' if base_duration is None else base_duration} | "
            f"{'' if exp_duration is None else exp_duration} | "
            f"{delta_duration} | "
            f"{'' if base_tokens_in is None else base_tokens_in} | "
            f"{'' if exp_tokens_in is None else exp_tokens_in} | "
            f"{delta_tokens_in} | "
            f"{'' if base_tokens_out is None else base_tokens_out} | "
            f"{'' if exp_tokens_out is None else exp_tokens_out} | "
            f"{delta_tokens_out} |"
        )

    output_path = benchmark_dir / "comparison.md"
    output_path.write_text("\n".join(lines) + "\n")
    return output_path


def main() -> int:
    if len(sys.argv) != 4:
        usage()
        return 1

    baseline_run_id = sys.argv[1]
    experiment_run_id = sys.argv[2]
    benchmark_id = sys.argv[3]

    benchmark_dir = Path(f".agentic/bus/artifacts/benchmarks/{benchmark_id}")
    benchmark_dir.mkdir(parents=True, exist_ok=True)

    try:
        baseline = summarize_run(baseline_run_id)
        experiment = summarize_run(experiment_run_id)
    except FileNotFoundError as err:
        print(f"[FAIL] {err}")
        return 1
    except ValueError as err:
        print(f"[FAIL] {err}")
        return 1

    (benchmark_dir / "baseline_run_id.txt").write_text(f"{baseline_run_id}\n")
    (benchmark_dir / "experiment_run_id.txt").write_text(f"{experiment_run_id}\n")

    maybe_copy_report(baseline_run_id, benchmark_dir / "baseline_report.md")
    maybe_copy_report(experiment_run_id, benchmark_dir / "experiment_report.md")
    comparison_path = write_comparison(benchmark_dir, baseline, experiment)

    print(f"Benchmark report written: {comparison_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
