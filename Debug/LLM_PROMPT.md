# Debug Sweep Review (Do Not Invent)

You are reviewing a run Debug package created by `agentic-debug-audit`.

## What You Must Do
- Use `Debug/audit_summary.md` as the primary source.
- Cross-check with copied evidence under `Debug/.agentic/` and `Debug/.ai/` when needed.
- Confirm whether agent concatenation worked:
  - Planned agents vs executed agents (metrics-based).
  - Tier/dispatch artifacts present.
  - Enforcement results (pre_release/final) and why.
- Identify the minimal, highest-leverage fixes for the next iteration.

## Output Format
1. Verdict: `OK` or `BROKEN`
2. Evidence (bullet list of file paths you used)
3. Root cause (1-3 bullets)
4. Fix plan (3-7 bullets, minimal changes first)
5. Optional: Suggested improvement to the debug sweep if it is misconfigured
