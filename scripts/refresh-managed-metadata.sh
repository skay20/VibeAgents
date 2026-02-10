#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/refresh-managed-metadata.sh
# Template-Version: 1.0.0
# Last-Generated: AUTO
# Ownership: Managed

set -euo pipefail

MODE="write"
if [[ "${1:-}" == "--check" ]]; then
  MODE="check"
elif [[ -n "${1:-}" ]]; then
  echo "Usage: scripts/refresh-managed-metadata.sh [--check]"
  exit 1
fi

MODE="$MODE" python3 - <<'PY'
import json
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

mode = os.environ["MODE"]
repo_root = Path(".").resolve()
settings_path = repo_root / ".agentic" / "settings.json"
manifest_path = repo_root / "repo_manifest.json"

if not settings_path.exists():
    print("[FAIL] Missing settings file: .agentic/settings.json")
    sys.exit(1)
if not manifest_path.exists():
    print("[FAIL] Missing repo_manifest.json")
    sys.exit(1)

settings = json.loads(settings_path.read_text(encoding="utf-8")).get("settings", {})
runtime_mode = str(settings.get("runtime", {}).get("mode", "framework"))
hygiene = settings.get("framework_hygiene", {})

enforce = bool(hygiene.get("enforce_last_generated", True))
mode_scope = str(hygiene.get("mode_scope", "framework_only"))
allow_auto = set(str(path).strip() for path in hygiene.get("allow_auto_last_generated", []) if str(path).strip())
grace_seconds = int(hygiene.get("stale_grace_seconds", 120))

if not enforce:
    print("[OK] framework_hygiene disabled")
    sys.exit(0)

if mode_scope == "framework_only" and runtime_mode != "framework":
    print("[OK] framework_hygiene skipped (runtime.mode is project)")
    sys.exit(0)

manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
managed_files = []
for entry in manifest.get("files", []):
    path = str(entry.get("path", "")).strip()
    ownership = str(entry.get("ownership", "Managed"))
    if not path or ownership == "Human":
        continue
    managed_files.append(path)

managed_set = set(managed_files)

def get_modified_paths() -> set[str] | None:
    try:
        subprocess.run(
            ["git", "rev-parse", "--is-inside-work-tree"],
            cwd=repo_root,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
    except Exception:
        return None

    result = subprocess.run(
        ["git", "status", "--porcelain", "--untracked-files=normal"],
        cwd=repo_root,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    paths = set()
    for raw_line in result.stdout.splitlines():
        line = raw_line.rstrip("\n")
        if not line:
            continue
        payload = line[3:] if len(line) >= 4 else ""
        if " -> " in payload:
            payload = payload.split(" -> ", 1)[1]
        payload = payload.strip()
        if payload:
            paths.add(payload)
    return paths

modified = get_modified_paths()
if modified is None:
    target_paths = sorted(managed_set)
else:
    target_paths = sorted(path for path in managed_set if path in modified)

if not target_paths:
    print("[OK] No modified managed files to refresh")
    sys.exit(0)

yaml_like_re = re.compile(
    r'(?m)^(\s*(?:#\s*|<!--\s*)?Last-Generated:\s*)([^\n<]*?)(\s*(?:-->)?\s*)$'
)
json_re = re.compile(r'("Last-Generated"\s*:\s*")([^"]*)(")')

def parse_header(text: str):
    match = json_re.search(text)
    if match:
        return {"kind": "json", "match": match, "value": match.group(2).strip()}
    match = yaml_like_re.search(text)
    if match:
        return {"kind": "yaml", "match": match, "value": match.group(2).strip()}
    return None

def parse_ts(value: str):
    if not value:
        return None
    normalized = value.replace("Z", "+00:00")
    try:
        timestamp = datetime.fromisoformat(normalized)
    except Exception:
        return None
    if timestamp.tzinfo is None:
        timestamp = timestamp.replace(tzinfo=timezone.utc)
    return timestamp.astimezone(timezone.utc)

now = datetime.now(timezone.utc)
now_text = now.strftime("%Y-%m-%dT%H:%M:%SZ")
stale_items = []
updated_items = []

for rel_path in target_paths:
    path = repo_root / rel_path
    if not path.exists() or not path.is_file():
        continue
    text = path.read_text(encoding="utf-8", errors="ignore")
    parsed = parse_header(text)
    if parsed is None:
        continue

    value = parsed["value"]
    stale = False
    reason = ""

    if value.upper() == "AUTO":
        if rel_path not in allow_auto:
            stale = True
            reason = "auto_not_allowlisted"
    else:
        header_ts = parse_ts(value)
        if header_ts is None:
            stale = True
            reason = "invalid_timestamp"
        else:
            mtime = datetime.fromtimestamp(path.stat().st_mtime, tz=timezone.utc)
            if (mtime - header_ts).total_seconds() > grace_seconds:
                stale = True
                reason = "stale_timestamp"

    if not stale:
        continue

    stale_items.append((rel_path, reason))
    if mode == "write":
        match = parsed["match"]
        if parsed["kind"] == "json":
            replacement = f'{match.group(1)}{now_text}{match.group(3)}'
        else:
            replacement = f"{match.group(1)}{now_text}{match.group(3)}"
        new_text = text[:match.start()] + replacement + text[match.end():]
        if new_text != text:
            path.write_text(new_text, encoding="utf-8")
            updated_items.append(rel_path)

if mode == "check":
    if stale_items:
        print("[FAIL] Stale Last-Generated metadata detected:")
        for rel_path, reason in stale_items:
            print(f"- {rel_path} ({reason})")
        sys.exit(2)
    print("[OK] Last-Generated freshness check passed")
    sys.exit(0)

if updated_items:
    print("[OK] Refreshed Last-Generated metadata:")
    for rel_path in updated_items:
        print(f"- {rel_path}")
else:
    print("[OK] No Last-Generated refresh needed")
PY
