#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/pack-framework.sh
# Template-Version: 1.0.0
# Last-Generated: AUTO
# Ownership: Managed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
STAMP="$(date -u +%Y%m%d-%H%M%SZ)"
OUT="${1:-$REPO_ROOT/.agentic/dist/framework-${STAMP}.tar.gz}"

mkdir -p "$(dirname "$OUT")"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

items=(
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
  "README.md"
  "docs/QUICKSTART.md"
  "docs/STRUCTURE.md"
  "repo_manifest.json"
  "TREE.md"
  "CHANGELOG.md"
)

for item in "${items[@]}"; do
  if [[ -e "$REPO_ROOT/$item" ]]; then
    mkdir -p "$TMP_DIR/$(dirname "$item")"
    tar -C "$REPO_ROOT" -cf - "$item" | tar -C "$TMP_DIR" -xf -
  fi
done

mkdir -p \
  "$TMP_DIR/.agentic/bus/artifacts" \
  "$TMP_DIR/.agentic/bus/metrics" \
  "$TMP_DIR/.agentic/bus/state" \
  "$TMP_DIR/.ai/logs/runs" \
  "$TMP_DIR/.ai/state"
rm -rf \
  "$TMP_DIR/.agentic/bus/artifacts/"* \
  "$TMP_DIR/.agentic/bus/metrics/"* \
  "$TMP_DIR/.agentic/bus/state/"* \
  "$TMP_DIR/.ai/logs/runs/"* \
  "$TMP_DIR/.ai/state/"* 2>/dev/null || true

cat > "$TMP_DIR/.agentic/mode.json" <<'EOF'
{
  "Managed-By": "AgenticRepoBuilder",
  "Template-Source": "templates/.agentic/mode.json",
  "Template-Version": "1.0.0",
  "Last-Generated": "AUTO",
  "Ownership": "Managed",
  "mode": "framework"
}
EOF

tar -C "$TMP_DIR" -czf "$OUT" .
echo "[OK] Framework bundle created: $OUT"
