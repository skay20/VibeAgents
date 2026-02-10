#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/init-project.sh
# Template-Version: 2.0.0
# Last-Generated: AUTO
# Ownership: Managed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TARGET_DIR=""
MODE="project"
FORCE="false"

usage() {
  echo "Usage: scripts/init-project.sh <target_dir> [--mode project|framework] [--force]"
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

TARGET_DIR="$1"
shift || true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      MODE="${2:-}"
      shift 2
      ;;
    --force)
      FORCE="true"
      shift
      ;;
    *)
      echo "[FAIL] Unknown argument: $1"
      usage
      ;;
  esac
done

if [[ "$MODE" != "project" && "$MODE" != "framework" ]]; then
  echo "[FAIL] --mode must be project or framework"
  exit 1
fi

TARGET_DIR="$(cd "$(dirname "$TARGET_DIR")" && pwd)/$(basename "$TARGET_DIR")"

if [[ -d "$TARGET_DIR" ]]; then
  if [[ "$FORCE" != "true" ]] && [[ -n "$(find "$TARGET_DIR" -mindepth 1 -maxdepth 1 2>/dev/null)" ]]; then
    echo "[FAIL] Target directory is not empty: $TARGET_DIR (use --force to continue)"
    exit 1
  fi
else
  mkdir -p "$TARGET_DIR"
fi

copy_items=(
  ".agentic"
  ".ai"
  ".claude"
  ".cursor"
  ".gemini"
  ".windsurf"
  ".github"
  "scripts"
  "AGENTS.md"
  "GEMINI.md"
)

for item in "${copy_items[@]}"; do
  src="$REPO_ROOT/$item"
  if [[ -e "$src" ]]; then
    tar -C "$REPO_ROOT" -cf - "$item" | tar -C "$TARGET_DIR" -xf -
  fi
done

mkdir -p \
  "$TARGET_DIR/docs" \
  "$TARGET_DIR/src" \
  "$TARGET_DIR/.agentic/bus/artifacts" \
  "$TARGET_DIR/.agentic/bus/metrics" \
  "$TARGET_DIR/.agentic/bus/state" \
  "$TARGET_DIR/.ai/logs/runs" \
  "$TARGET_DIR/.ai/state"

# Clean volatile runtime state copied from the source framework.
rm -rf \
  "$TARGET_DIR/.agentic/bus/artifacts/"* \
  "$TARGET_DIR/.agentic/bus/metrics/"* \
  "$TARGET_DIR/.agentic/bus/state/"* \
  "$TARGET_DIR/.ai/logs/runs/"* \
  "$TARGET_DIR/.ai/state/"* \
  "$TARGET_DIR/Debug" 2>/dev/null || true

cat > "$TARGET_DIR/.agentic/mode.json" <<EOF
{
  "Managed-By": "AgenticRepoBuilder",
  "Template-Source": "templates/.agentic/mode.json",
  "Template-Version": "1.0.0",
  "Last-Generated": "2026-02-10T20:25:14Z",
  "Ownership": "Managed",
  "mode": "$MODE"
}
EOF

TARGET_DIR="$TARGET_DIR" MODE="$MODE" python3 - <<'PY'
import json
import os
from pathlib import Path

target = Path(os.environ["TARGET_DIR"])
mode = os.environ["MODE"]
settings_path = target / ".agentic" / "settings.json"
if settings_path.exists():
    data = json.loads(settings_path.read_text(encoding="utf-8"))
    settings = data.setdefault("settings", {})
    runtime = settings.setdefault("runtime", {})
    runtime["mode"] = mode
    paths = settings.setdefault("paths", {})
    paths["agentic_home"] = ".agentic"
    docs = settings.setdefault("docs", {})
    docs["scope_mode"] = "project_only" if mode == "project" else "framework_only"
    docs.setdefault("framework_docs_paths", ["README.md", "docs/QUICKSTART.md"])
    docs.setdefault("project_docs_paths", ["docs/PRD.md", "docs/RUNBOOK.md", "<project_root>/README.md"])
    docs["update_readme_each_iteration"] = True
    docs["enforce_parent_docs_each_iteration"] = False if mode == "project" else True
    settings_path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY

if [[ ! -f "$TARGET_DIR/README.md" ]]; then
  cat > "$TARGET_DIR/README.md" <<'EOF'
# New Project

Generated from Agentic framework runtime.
EOF
fi

if [[ ! -f "$TARGET_DIR/docs/PRD.md" ]]; then
  cat > "$TARGET_DIR/docs/PRD.md" <<'EOF'
# Product Requirements Document

<!-- BEGIN_MANAGED -->
TO_FILL
<!-- END_MANAGED -->
EOF
fi

if [[ ! -f "$TARGET_DIR/docs/RUNBOOK.md" ]]; then
  cat > "$TARGET_DIR/docs/RUNBOOK.md" <<'EOF'
# Runbook

TO_FILL
EOF
fi

echo "[OK] Project initialized at $TARGET_DIR (mode=$MODE)"
