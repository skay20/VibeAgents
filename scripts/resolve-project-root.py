#!/usr/bin/env python3
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/resolve-project-root.py
# Template-Version: 1.0.0
# Last-Generated: 2026-02-07T00:00:00Z
# Ownership: Managed

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
from typing import Iterable


def _iter_outputs_written(metrics_dir: Path) -> Iterable[str]:
    for p in sorted(metrics_dir.glob("*.json")):
        if p.name == "events.jsonl":
            continue
        try:
            payload = json.loads(p.read_text(encoding="utf-8"))
        except Exception:
            continue
        outputs = payload.get("outputs_written", [])
        if isinstance(outputs, list):
            for item in outputs:
                if isinstance(item, str) and item.strip():
                    yield item.strip()


def _is_repo_internal_path(rel: Path) -> bool:
    # Ignore framework internal noise when trying to detect generated-project roots.
    if rel.parts and rel.parts[0].startswith("."):
        return True
    if rel.parts and rel.parts[0] in {"docs", "scripts", "Research"}:
        return True
    return False


def _detect_root(repo_root: Path, outputs: list[Path]) -> Path | None:
    markers = [
        "package.json",
        "pyproject.toml",
        "requirements.txt",
        "Cargo.toml",
        "go.mod",
    ]
    lockfiles = [
        "package-lock.json",
        "pnpm-lock.yaml",
        "yarn.lock",
        "Cargo.lock",
        "poetry.lock",
    ]

    candidate_scores: dict[Path, int] = {}

    for rel in outputs:
        if rel.is_absolute():
            # Never treat machine-local absolute paths as valid roots.
            continue
        if _is_repo_internal_path(rel):
            continue
        abs_path = (repo_root / rel).resolve()
        if not abs_path.exists():
            continue

        # Candidate root: directory containing a marker file, walking up from the output path.
        for parent in [abs_path] + list(abs_path.parents):
            if parent == repo_root or repo_root not in parent.parents:
                break
            if parent.is_file():
                parent = parent.parent
            score = 0
            for m in markers:
                if (parent / m).exists():
                    score += 10
            for l in lockfiles:
                if (parent / l).exists():
                    score += 2
            # Also weight by how many outputs fall under this prefix.
            if score > 0:
                candidate_scores[parent] = candidate_scores.get(parent, 0) + score

    if not candidate_scores:
        return None

    # Pick highest score. If tie, pick the shallowest (shorter path) to avoid overly-nested roots.
    best = sorted(candidate_scores.items(), key=lambda kv: (-kv[1], len(str(kv[0]))))[0][0]
    return best


def main() -> int:
    ap = argparse.ArgumentParser(description="Resolve generated project root for a run_id.")
    ap.add_argument("run_id")
    ap.add_argument("--repo-root", default=".", help="Repo root (default: .)")
    ap.add_argument("--write-artifact", action="store_true", help="Write artifacts/<run_id>/project_root.txt")
    ap.add_argument("--print-relative", action="store_true", help="Print root relative to repo root (default)")
    args = ap.parse_args()

    repo_root = Path(args.repo_root).resolve()
    metrics_dir = repo_root / ".agentic" / "bus" / "metrics" / args.run_id
    art_dir = repo_root / ".agentic" / "bus" / "artifacts" / args.run_id

    if not metrics_dir.is_dir():
        raise SystemExit(f"[FAIL] Missing metrics dir: {metrics_dir}")
    outputs = [Path(p) for p in _iter_outputs_written(metrics_dir)]
    root = _detect_root(repo_root, outputs)

    if root is None:
        # No detected project root. Print empty string so callers can treat as "skip".
        print("")
        return 0

    rel = os.path.relpath(str(root), str(repo_root))
    print(rel if args.print_relative else str(root))

    if args.write_artifact:
        art_dir.mkdir(parents=True, exist_ok=True)
        (art_dir / "project_root.txt").write_text(rel + "\n", encoding="utf-8")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

