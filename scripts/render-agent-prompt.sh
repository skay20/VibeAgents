#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/render-agent-prompt.sh
# Template-Version: 1.0.0
# Last-Generated: 2026-02-06T14:05:00Z
# Ownership: Managed

set -euo pipefail

AGENT_ID="${1:-}"
REQUESTED_VERSION="${2:-auto}"
RUN_ID="${3:-${AGENTIC_RUN_ID:-}}"
SETTINGS_FILE=".agentic/settings.json"

if [[ -z "$AGENT_ID" ]]; then
  echo "Usage: scripts/render-agent-prompt.sh <agent_id> [v1|v2|auto] [run_id]" >&2
  exit 1
fi

if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo "Missing settings file: $SETTINGS_FILE" >&2
  exit 1
fi

read -r DEFAULT_VERSION FALLBACK_VERSION PILOT_ENABLED PILOT_AGENTS WRITE_COMPILED < <(python3 - <<'PY'
import json
from pathlib import Path
data = json.loads(Path(".agentic/settings.json").read_text())
settings = data.get("settings", {})
prompt = settings.get("prompt_resolution", {})
default = prompt.get("default_version", "v1")
fallback = prompt.get("fallback_version", "v1")
pilot_enabled = "true" if prompt.get("pilot_v2_enabled", False) else "false"
pilot_agents = ",".join(prompt.get("pilot_agents", []))
write_compiled = "true" if prompt.get("write_compiled_artifacts", True) else "false"
print(default, fallback, pilot_enabled, pilot_agents, write_compiled)
PY
)

is_pilot_agent="false"
IFS=',' read -r -a pilot_array <<< "$PILOT_AGENTS"
for candidate in "${pilot_array[@]}"; do
  if [[ "$candidate" == "$AGENT_ID" ]]; then
    is_pilot_agent="true"
    break
  fi
done

RESOLVED_VERSION="$REQUESTED_VERSION"
if [[ "$REQUESTED_VERSION" == "auto" ]]; then
  if [[ "$PILOT_ENABLED" == "true" && "$is_pilot_agent" == "true" ]]; then
    RESOLVED_VERSION="v2"
  else
    RESOLVED_VERSION="$DEFAULT_VERSION"
  fi
fi

if [[ "$RESOLVED_VERSION" != "v1" && "$RESOLVED_VERSION" != "v2" ]]; then
  echo "Invalid version '$RESOLVED_VERSION'. Use v1, v2, or auto." >&2
  exit 1
fi

V1_FILE=".agentic/agents/${AGENT_ID}.md"
V2_FILE=".agentic/agents/${AGENT_ID}.v2.md"
CORE_FILE=".agentic/agents/_CORE.md"

compile_v1() {
  if [[ ! -f "$V1_FILE" ]]; then
    return 1
  fi
  cat "$V1_FILE"
}

compile_v2() {
  if [[ ! -f "$CORE_FILE" || ! -f "$V2_FILE" ]]; then
    return 1
  fi
  cat "$CORE_FILE"
  printf "\n"
  sed '/^@_CORE\.md$/d' "$V2_FILE"
}

PROMPT_CONTENT=""
if [[ "$RESOLVED_VERSION" == "v1" ]]; then
  if ! PROMPT_CONTENT="$(compile_v1)"; then
    if [[ "$FALLBACK_VERSION" == "v2" ]] && PROMPT_CONTENT="$(compile_v2)"; then
      RESOLVED_VERSION="v2"
    else
      echo "Missing v1 prompt for agent '$AGENT_ID': $V1_FILE" >&2
      exit 1
    fi
  fi
else
  if ! PROMPT_CONTENT="$(compile_v2)"; then
    if [[ "$FALLBACK_VERSION" == "v1" ]] && PROMPT_CONTENT="$(compile_v1)"; then
      RESOLVED_VERSION="v1"
    else
      echo "Missing v2 prompt for agent '$AGENT_ID': $V2_FILE or $CORE_FILE" >&2
      exit 1
    fi
  fi
fi

if [[ -n "$RUN_ID" && "$WRITE_COMPILED" == "true" ]]; then
  OUT_DIR=".agentic/bus/artifacts/${RUN_ID}/compiled_prompts"
  OUT_FILE="${OUT_DIR}/${AGENT_ID}.md"
  mkdir -p "$OUT_DIR"
  {
    echo "<!-- Compiled Prompt -->"
    echo "<!-- Agent-ID: ${AGENT_ID} -->"
    echo "<!-- Resolved-Version: ${RESOLVED_VERSION} -->"
    echo "<!-- Source-V1: ${V1_FILE} -->"
    echo "<!-- Source-Core: ${CORE_FILE} -->"
    echo "<!-- Source-V2: ${V2_FILE} -->"
    echo
    printf "%s\n" "$PROMPT_CONTENT"
  } > "$OUT_FILE"
fi

printf "%s\n" "$PROMPT_CONTENT"
