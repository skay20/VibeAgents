#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/check-project-meta.sh
# Template-Version: 1.0.0
# Last-Generated: 2026-02-06T16:43:23Z
# Ownership: Managed

set -euo pipefail

PROJECT_META_DIR="${1:-project_meta}"
ROOT_SETTINGS=".agentic/settings.json"

if [[ ! -d "$PROJECT_META_DIR" ]]; then
  echo "[FAIL] Missing project_meta directory: $PROJECT_META_DIR"
  exit 1
fi

if [[ ! -f "$ROOT_SETTINGS" ]]; then
  echo "[FAIL] Missing root settings: $ROOT_SETTINGS"
  exit 1
fi

ROOT_SETTINGS="$ROOT_SETTINGS" PROJECT_META_DIR="$PROJECT_META_DIR" python3 - <<'PY'
import json
import os
import re
import sys
from pathlib import Path

root_settings = Path(os.environ["ROOT_SETTINGS"])
project_meta_dir = Path(os.environ["PROJECT_META_DIR"])

settings = json.loads(root_settings.read_text())
meta = settings.get("settings", {}).get("project_meta", {})
if not meta.get("enforce_compatibility", True):
    print("[OK] Project meta compatibility enforcement disabled.")
    sys.exit(0)

required_files = meta.get("required_files", [])
min_versions = meta.get("min_template_versions", {})

failures = []
info = []

def parse_semver(version: str):
    m = re.match(r"^(\d+)\.(\d+)\.(\d+)$", version.strip())
    if not m:
        return None
    return tuple(int(x) for x in m.groups())

def extract_template_version(path: Path):
    text = path.read_text(encoding="utf-8")
    patterns = [
        r"Template-Version:\s*\"?([0-9]+\.[0-9]+\.[0-9]+)\"?",
        r"\"Template-Version\"\s*:\s*\"([0-9]+\.[0-9]+\.[0-9]+)\"",
    ]
    for pattern in patterns:
        match = re.search(pattern, text)
        if match:
            return match.group(1)
    return None

for file_name in required_files:
    path = project_meta_dir / file_name
    if not path.exists():
        failures.append(f"Missing required file: {path}")
        continue
    required_version = min_versions.get(file_name)
    if required_version:
        current_version = extract_template_version(path)
        if current_version is None:
            failures.append(f"Missing Template-Version in {path}")
            continue
        current_semver = parse_semver(current_version)
        required_semver = parse_semver(required_version)
        if current_semver is None or required_semver is None:
            failures.append(f"Invalid semver in {path}: current={current_version} required={required_version}")
            continue
        if current_semver < required_semver:
            failures.append(
                f"Outdated template in {path}: current={current_version} required>={required_version}"
            )
        else:
            info.append(f"{file_name} template version OK ({current_version})")

project_settings_path = project_meta_dir / "settings.json"
if project_settings_path.exists():
    try:
        project_settings = json.loads(project_settings_path.read_text())
        s = project_settings.get("settings", {})
        checks = [
            ("run_mode.preferred", s.get("run_mode", {}).get("preferred")),
            ("startup.profile", s.get("startup", {}).get("profile")),
            ("automation.run_scripts", s.get("automation", {}).get("run_scripts")),
            ("flow_control.required_agents.standard", s.get("flow_control", {}).get("required_agents", {}).get("standard")),
            ("prd_intake.detect_without_keyword", s.get("prd_intake", {}).get("detect_without_keyword")),
        ]
        missing = [k for k, v in checks if v is None]
        if missing:
            failures.append(
                "Missing required project_meta settings keys: " + ", ".join(missing)
            )
    except Exception:
        failures.append(f"Invalid JSON in {project_settings_path}")

universal_path = project_meta_dir / "UNIVERSAL.md"
if universal_path.exists():
    text = universal_path.read_text(encoding="utf-8")
    if "Startup Handshake" not in text:
        failures.append(f"Missing Startup Handshake in {universal_path}")
    if "structure" not in text and "keyword" not in text:
        failures.append(f"Missing structure-driven PRD detection rule in {universal_path}")

if failures:
    print("[FAIL] Project meta compatibility check failed:")
    for failure in failures:
        print(f"- {failure}")
    sys.exit(2)

print("[OK] Project meta compatibility check passed.")
for line in info:
    print(f"- {line}")
PY
