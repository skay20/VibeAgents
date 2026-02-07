#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/switch-context.sh
# Template-Version: 1.0.0
# Last-Generated: AUTO
# Ownership: Managed

set -euo pipefail

PROFILE="${1:-default}"

case "$PROFILE" in
  default|architect|developer) ;;
  *)
    echo "Usage: scripts/switch-context.sh [default|architect|developer]"
    exit 1
    ;;
esac

scripts/sync-agents.sh --profile "$PROFILE"
echo "[OK] context profile switched to '$PROFILE'."
