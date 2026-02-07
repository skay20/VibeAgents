#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/sync-agents.sh
# Template-Version: 1.0.0
# Last-Generated: 2026-02-07T00:00:00Z
# Ownership: Managed

set -euo pipefail

MODE="write"
PROFILE="default"
GEN_TS="AUTO"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check)
      MODE="check"
      shift
      ;;
    --profile)
      PROFILE="${2:-}"
      if [[ -z "$PROFILE" ]]; then
        echo "[FAIL] --profile requires a value."
        exit 1
      fi
      shift 2
      ;;
    *)
      echo "Usage: scripts/sync-agents.sh [--check] [--profile default|architect|developer]"
      exit 1
      ;;
  esac
done

case "$PROFILE" in
  default|architect|developer) ;;
  *)
    echo "[FAIL] Invalid profile '$PROFILE'. Use default|architect|developer."
    exit 1
    ;;
esac

ROOT="$(pwd)"
SRC_DIR=".ai/source"
OUT_DIR=".ai/context"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

if [[ ! -d "$SRC_DIR" ]]; then
  echo "[FAIL] Missing source directory: $SRC_DIR"
  exit 1
fi

CONTEXT_FILES=(
  "RUNTIME_MIN.md"
  "BOOTSTRAP.md"
  "PROJECT.md"
  "CORE.md"
  "STANDARDS.md"
  "SECURITY.md"
  "TESTING.md"
)

for file in "${CONTEXT_FILES[@]}"; do
  if [[ ! -f "$SRC_DIR/$file" ]]; then
    echo "[FAIL] Missing source context: $SRC_DIR/$file"
    exit 1
  fi
done

write_bootstrap_block() {
  local profile="$1"
  cat <<'EOF'
Bootstrap context:
- `.ai/context/RUNTIME_MIN.md`
- `.ai/context/BOOTSTRAP.md`
- `.ai/context/PROJECT.md`
EOF
  if [[ "$profile" == "architect" ]]; then
    cat <<'EOF'
- `docs/ARCHITECTURE.md` (pointer when planning)
- `docs/ADR/` (pointer when architecture changes)
EOF
  fi
  if [[ "$profile" == "developer" ]]; then
    cat <<'EOF'
- `.ai/context/STANDARDS.md` (pointer for implementation)
- `.ai/context/TESTING.md` (pointer for checks)
- `.ai/context/SECURITY.md` (pointer for risk paths)
EOF
  fi
}

write_universal_inline() {
  cat <<'EOF'
## Compiled Universal Rules (Inline)
- Startup handshake must run in this order: bootstrap context -> orchestrator entrypoint -> PRD ingest -> single calibration -> dispatch -> execution.
- PRD intake is structure-based (not keyword-only) and updates `docs/PRD.md` managed block.
- Always resolve dispatch and write: `tier_decision.md`, `dispatch_signals.md`, `dispatch_resolution.md`, `planned_agents.md`.
- In implementation runs, do not omit `architect`, `qa_reviewer`, or `docs_writer`.
- Planned agents are not execution evidence; executed agents must emit metrics with `ok|blocked|failed`.
- Enforce flow gates with `scripts/enforce-flow.sh <run_id> <tier> pre_release|final`.
EOF
}

generate_agents_md() {
  local target="$1"
  {
    cat <<EOF
---
Managed-By: AgenticRepoBuilder
Template-Source: templates/AGENTS.md
Template-Version: 2.3.0
Last-Generated: $GEN_TS
Ownership: Managed
---

# Codex Instructions

## Shared Rules
Read .agentic/adapters/UNIVERSAL.md.
EOF
    write_bootstrap_block "$PROFILE"
    cat <<'EOF'

Startup handshake (must happen even on fast runs):
- Create `run_id` via `scripts/orchestrator-first.sh` (when automation enabled).
- Detect PRD by structure (not only keyword) and ingest/update `docs/PRD.md` (managed block) before calibration.
- Ask calibration once, including run mode if `AGENTIC_RUN_MODE` is unset.
EOF
    write_universal_inline
    cat <<'EOF'

## Codex-Specific
- Precedence: `AGENTS.override.md` > `AGENTS.md`.
- Directory overrides: nearer `AGENTS.md` wins.
- Tool identifier: set `AGENTIC_TOOL=codex`.
EOF
  } > "$target"
}

generate_gemini_md() {
  local target="$1"
  {
    cat <<EOF
---
Managed-By: AgenticRepoBuilder
Template-Source: templates/GEMINI.md
Template-Version: 2.3.0
Last-Generated: $GEN_TS
Ownership: Managed
---

# Gemini CLI Instructions

EOF
    write_bootstrap_block "$PROFILE"
    echo
    write_universal_inline
    cat <<'EOF'

## Gemini-Specific
- Config: `.gemini/config.yaml`
- Tool identifier: set `AGENTIC_TOOL=gemini`.
EOF
  } > "$target"
}

generate_claude_md() {
  local target="$1"
  {
    cat <<EOF
---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.claude/CLAUDE.md
Template-Version: 2.3.0
Last-Generated: $GEN_TS
Ownership: Managed
---

# Claude Code Instructions

EOF
    write_bootstrap_block "$PROFILE"
    echo
    write_universal_inline
    cat <<'EOF'

## Claude-Specific
- Keep `.claude/rules/prd.md` as PRD supplement.
- Tool identifier: set `AGENTIC_TOOL=claude`.
EOF
  } > "$target"
}

generate_cursor_global() {
  local target="$1"
  {
    cat <<EOF
---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.cursor/rules/00-global.mdc
Template-Version: 2.3.0
Last-Generated: $GEN_TS
Ownership: Managed
description: Global project rules
globs:
alwaysApply: true
---

- Use .agentic/adapters/UNIVERSAL.md as canonical source.
EOF
    write_bootstrap_block "$PROFILE"
    echo
    write_universal_inline
    cat <<'EOF'

- Tool identifier: set `AGENTIC_TOOL=cursor`.
EOF
  } > "$target"
}

generate_windsurf_global() {
  local target="$1"
  {
    cat <<EOF
<!-- Managed-By: AgenticRepoBuilder -->
<!-- Template-Source: templates/.windsurf/rules/00-global.md -->
<!-- Template-Version: 2.3.0 -->
<!-- Last-Generated: $GEN_TS -->
<!-- Ownership: Managed -->

# Global Rules

Use .agentic/adapters/UNIVERSAL.md as canonical source.
EOF
    write_bootstrap_block "$PROFILE"
    echo
    write_universal_inline
    cat <<'EOF'

Windsurf-specific:
- Tool identifier: set `AGENTIC_TOOL=windsurf`.
EOF
  } > "$target"
}

generate_copilot_instructions() {
  local target="$1"
  {
    cat <<EOF
---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.github/copilot-instructions.md
Template-Version: 2.3.0
Last-Generated: $GEN_TS
Ownership: Managed
---

# Copilot Instructions

Use .agentic/adapters/UNIVERSAL.md as canonical source.
EOF
    write_bootstrap_block "$PROFILE"
    echo
    write_universal_inline
    cat <<'EOF'

Copilot-specific:
- Tool identifier: set `AGENTIC_TOOL=copilot`.
EOF
  } > "$target"
}

generate_gemini_styleguide() {
  local target="$1"
  {
    cat <<EOF
---
Managed-By: AgenticRepoBuilder
Template-Source: templates/.gemini/styleguide.md
Template-Version: 2.3.0
Last-Generated: $GEN_TS
Ownership: Managed
---

# Gemini Code Assist Style Guide

Use .agentic/adapters/UNIVERSAL.md as canonical source.
EOF
    write_bootstrap_block "$PROFILE"
    echo
    write_universal_inline
    cat <<'EOF'

Gemini-specific:
- Use `.gemini/config.yaml`.
- Tool identifier: set `AGENTIC_TOOL=gemini`.
EOF
  } > "$target"
}

TARGETS=()

# Compile context files from source.
for file in "${CONTEXT_FILES[@]}"; do
  src="$SRC_DIR/$file"
  dst="$TMP_DIR/$OUT_DIR/$file"
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  TARGETS+=("$OUT_DIR/$file")
done

mkdir -p "$TMP_DIR/.claude" "$TMP_DIR/.cursor/rules" "$TMP_DIR/.windsurf/rules" "$TMP_DIR/.github" "$TMP_DIR/.gemini"
generate_agents_md "$TMP_DIR/AGENTS.md"
generate_gemini_md "$TMP_DIR/GEMINI.md"
generate_claude_md "$TMP_DIR/.claude/CLAUDE.md"
generate_cursor_global "$TMP_DIR/.cursor/rules/00-global.mdc"
generate_windsurf_global "$TMP_DIR/.windsurf/rules/00-global.md"
generate_copilot_instructions "$TMP_DIR/.github/copilot-instructions.md"
generate_gemini_styleguide "$TMP_DIR/.gemini/styleguide.md"

TARGETS+=(
  "AGENTS.md"
  "GEMINI.md"
  ".claude/CLAUDE.md"
  ".cursor/rules/00-global.mdc"
  ".windsurf/rules/00-global.md"
  ".github/copilot-instructions.md"
  ".gemini/styleguide.md"
)

if [[ "$MODE" == "check" ]]; then
  FAIL=0
  for path in "${TARGETS[@]}"; do
    if [[ ! -f "$path" ]]; then
      echo "[FAIL] Missing compiled file: $path"
      FAIL=1
      continue
    fi
    if ! cmp -s "$path" "$TMP_DIR/$path"; then
      echo "[FAIL] Out of sync: $path"
      FAIL=1
    fi
  done
  if [[ $FAIL -eq 1 ]]; then
    echo "[FAIL] sync check failed (profile=$PROFILE). Run scripts/sync-agents.sh --profile $PROFILE"
    exit 1
  fi
  echo "[OK] sync check passed (profile=$PROFILE)."
  exit 0
fi

for path in "${TARGETS[@]}"; do
  mkdir -p "$(dirname "$path")"
  cp "$TMP_DIR/$path" "$path"
done

echo "[OK] compiled context + adapters updated (profile=$PROFILE)."
