#!/usr/bin/env bash
# Managed-By: AgenticRepoBuilder
# Template-Source: templates/scripts/verify.sh
# Template-Version: 1.6.0
# Last-Generated: 2026-02-03T22:23:54Z
# Ownership: Managed

set -euo pipefail

FAIL=0

fail() {
  echo "[FAIL] $1"
  FAIL=1
}

# 1) Managed header checks for all managed files
MANAGED_FILES=$(python3 - <<'PYCODE'
import json
from pathlib import Path
m=json.loads(Path('repo_manifest.json').read_text())
for f in m['files']:
    print(f['path'])
PYCODE
)

for f in $MANAGED_FILES; do
  if [[ ! -f "$f" ]]; then
    fail "Missing managed file: $f"
    continue
  fi
  if ! grep -q "Managed-By" "$f"; then
    fail "Missing Managed-By header in $f"
  fi
  if ! grep -q "Template-Version" "$f"; then
    fail "Missing Template-Version in $f"
  fi
  if ! grep -q "Last-Generated" "$f"; then
    fail "Missing Last-Generated in $f"
  fi
 done

# 2) Placeholder check (TO_CONFIRM) with allowlist
ALLOWLIST=("docs/PRD.md" "docs/RUNBOOK.md")
for f in $MANAGED_FILES; do
  skip=0
  for a in "${ALLOWLIST[@]}"; do
    if [[ "$f" == "$a" ]]; then
      skip=1
      break
    fi
  done
  if [[ $skip -eq 1 ]]; then
    continue
  fi
  if grep -q "TO_CONFIRM" "$f"; then
    fail "Placeholder TO_CONFIRM found in $f"
  fi
 done


# 2b) PRD managed block check
if [[ -f "docs/PRD.md" ]]; then
  if ! grep -q "BEGIN_MANAGED" "docs/PRD.md" || ! grep -q "END_MANAGED" "docs/PRD.md"; then
    fail "docs/PRD.md missing BEGIN_MANAGED/END_MANAGED block"
  fi
fi



# 2c) PROJECT managed block check
if [[ -f ".ai/context/PROJECT.md" ]]; then
  if ! grep -q "BEGIN_MANAGED" ".ai/context/PROJECT.md" || ! grep -q "END_MANAGED" ".ai/context/PROJECT.md"; then
    fail "PROJECT.md missing BEGIN_MANAGED/END_MANAGED block"
  fi
fi

# 3) Adapter coherence (bootstrap)
ADAPTERS=(
  "AGENTS.md"
  "GEMINI.md"
  ".gemini/styleguide.md"
  ".claude/CLAUDE.md"
  ".cursor/rules/00-global.mdc"
  ".windsurf/rules/00-global.md"
  ".github/copilot-instructions.md"
)
for f in "${ADAPTERS[@]}"; do
  if [[ -f "$f" ]]; then
    for ref in BOOTSTRAP.md PROJECT.md; do
      if ! grep -q "$ref" "$f"; then
        fail "Adapter $f missing reference to $ref"
      fi
    done
  fi
 done

# 4) Agent Spec v2 structural checks
python3 - <<'PYCODE'
import glob, re, sys
required = [
    '## Scope', '## Inputs', '## Outputs', '## Decision Matrix', '## Operating Loop',
    '## Quality Gates', '## Failure Taxonomy', '## Escalation Protocol', '## Verification',
    '## Anti-Generic Rules', '## Definition of Done', '## Changelog'
]
fail = False
for path in glob.glob('.agentic/agents/*.md'):
    text = open(path, encoding='utf-8').read()
    if 'Prompt-ID:' not in text or 'Version:' not in text:
        print(f"[FAIL] Missing Prompt-ID or Version in {path}")
        fail = True
    for sec in required:
        if sec not in text:
            print(f"[FAIL] Missing section {sec} in {path}")
            fail = True
    if not re.search(r'`[^`]+/[^`]+`', text):
        print(f"[FAIL] No explicit file paths in {path}")
        fail = True
if fail:
    sys.exit(1)
PYCODE
if [[ $? -ne 0 ]]; then
  FAIL=1
fi

# 5) Anti-genericity lint (outside Anti-Generic section)
python3 - <<'PYCODE'
import glob, re, sys
banned = ['best practices','consider','could','might','maybe','it depends','depende']
fail = False
for path in glob.glob('.agentic/agents/*.md'):
    text = open(path, encoding='utf-8').read()
    parts = text.split('## Anti-Generic Rules')
    if len(parts) > 1:
        before = parts[0]
        after = parts[1]
        after_split = re.split(r'\n## ', after, maxsplit=1)
        remainder = ''
        if len(after_split) == 2:
            remainder = '## ' + after_split[1]
        text = before + '\n' + remainder
    lower = text.lower()
    for pat in banned:
        if re.search(pat, lower):
            print(f"[FAIL] Vague pattern '{pat}' in {path}")
            fail = True
            break
if fail:
    sys.exit(1)
PYCODE
if [[ $? -ne 0 ]]; then
  FAIL=1
fi

if [[ $FAIL -ne 0 ]]; then
  exit 1
fi

echo "[OK] verify.sh completed"
