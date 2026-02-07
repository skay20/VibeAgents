#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/gates/verify-tech.sh
# Template-Version: 1.0.0
# Last-Generated: AUTO
# Ownership: Managed

set -euo pipefail

RUN_ID="${1:-${AGENTIC_RUN_ID:-}}"
REPORT_PATH="${2:-}"

if [[ -n "$RUN_ID" && -z "$REPORT_PATH" ]]; then
  REPORT_PATH=".agentic/bus/artifacts/${RUN_ID}/tech_verify_report.md"
fi
if [[ -z "$REPORT_PATH" ]]; then
  REPORT_PATH="Debug/tech_verify_report.md"
fi

mkdir -p "$(dirname "$REPORT_PATH")"

TMP_OUT="$(mktemp)"
TMP_ERR="$(mktemp)"
trap 'rm -f "$TMP_OUT" "$TMP_ERR"' EXIT

FAIL=0
RESULTS=()

run_and_capture() {
  local label="$1"
  shift
  local cmd=("$@")
  local status="PASS"

  : >"$TMP_OUT"
  : >"$TMP_ERR"
  if ! "${cmd[@]}" >"$TMP_OUT" 2>"$TMP_ERR"; then
    status="FAIL"
    FAIL=1
  fi

  RESULTS+=("### ${label}")
  RESULTS+=("")
  RESULTS+=("- Command: \`${cmd[*]}\`")
  RESULTS+=("- Status: ${status}")
  RESULTS+=("")
  if [[ -s "$TMP_OUT" ]]; then
    RESULTS+=("#### stdout")
    RESULTS+=("\`\`\`text")
    while IFS= read -r line; do RESULTS+=("$line"); done <"$TMP_OUT"
    RESULTS+=("\`\`\`")
    RESULTS+=("")
  fi
  if [[ -s "$TMP_ERR" ]]; then
    RESULTS+=("#### stderr")
    RESULTS+=("\`\`\`text")
    while IFS= read -r line; do RESULTS+=("$line"); done <"$TMP_ERR"
    RESULTS+=("\`\`\`")
    RESULTS+=("")
  fi
}

find_runner() {
  if [[ -f "pnpm-lock.yaml" ]] && command -v pnpm >/dev/null 2>&1; then
    echo "pnpm"
    return
  fi
  if [[ -f "yarn.lock" ]] && command -v yarn >/dev/null 2>&1; then
    echo "yarn"
    return
  fi
  if [[ -f "bun.lockb" ]] && command -v bun >/dev/null 2>&1; then
    echo "bun"
    return
  fi
  if command -v npm >/dev/null 2>&1; then
    echo "npm"
    return
  fi
  echo ""
}

NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
{
  echo "# Tech Verify Report"
  echo
  echo "- Timestamp: ${NOW}"
  if [[ -n "$RUN_ID" ]]; then
    echo "- Run ID: ${RUN_ID}"
  fi
  echo "- CWD: $(pwd)"
  echo
} >"$REPORT_PATH"

if [[ -f "package.json" ]]; then
  RUNNER="$(find_runner)"
  if [[ -n "$RUNNER" ]]; then
    case "$RUNNER" in
      npm)
        run_and_capture "Node Lint" npm run lint --if-present
        run_and_capture "Node Typecheck" npm run typecheck --if-present
        run_and_capture "Node Test" npm run test --if-present
        run_and_capture "Node Build" npm run build --if-present
        ;;
      pnpm)
        run_and_capture "Node Lint" pnpm run lint
        run_and_capture "Node Typecheck" pnpm run typecheck
        run_and_capture "Node Test" pnpm run test
        run_and_capture "Node Build" pnpm run build
        ;;
      yarn)
        run_and_capture "Node Lint" yarn lint
        run_and_capture "Node Typecheck" yarn typecheck
        run_and_capture "Node Test" yarn test
        run_and_capture "Node Build" yarn build
        ;;
      bun)
        run_and_capture "Node Lint" bun run lint
        run_and_capture "Node Typecheck" bun run typecheck
        run_and_capture "Node Test" bun run test
        run_and_capture "Node Build" bun run build
        ;;
    esac
  else
    RESULTS+=("### Node Checks")
    RESULTS+=("")
    RESULTS+=("- Status: SKIPPED")
    RESULTS+=("- Reason: package.json exists but no package runner found (npm/pnpm/yarn/bun).")
    RESULTS+=("")
  fi
fi

if [[ -f "pyproject.toml" || -f "requirements.txt" ]]; then
  if command -v python3 >/dev/null 2>&1; then
    if command -v pytest >/dev/null 2>&1; then
      run_and_capture "Python Test" pytest -q
    else
      RESULTS+=("### Python Test")
      RESULTS+=("")
      RESULTS+=("- Status: SKIPPED")
      RESULTS+=("- Reason: pytest not installed.")
      RESULTS+=("")
    fi
  else
    RESULTS+=("### Python Checks")
    RESULTS+=("")
    RESULTS+=("- Status: SKIPPED")
    RESULTS+=("- Reason: python3 not found.")
    RESULTS+=("")
  fi
fi

if [[ ${#RESULTS[@]} -eq 0 ]]; then
  RESULTS+=("### Checks")
  RESULTS+=("")
  RESULTS+=("- Status: SKIPPED")
  RESULTS+=("- Reason: no recognized Node/Python project markers found.")
  RESULTS+=("")
fi

for line in "${RESULTS[@]}"; do
  echo "$line" >>"$REPORT_PATH"
done

echo "[OK] wrote ${REPORT_PATH}"
if [[ "$FAIL" -ne 0 ]]; then
  echo "[FAIL] verify-tech found failing checks."
  exit 2
fi
echo "[OK] verify-tech passed."
