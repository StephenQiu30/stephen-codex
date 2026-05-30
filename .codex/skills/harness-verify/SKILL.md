---
name: harness-verify
description: Use when validating a ticket or pull request through the project harness, especially before Human Review or when UI work needs screenshots, traces, logs, or reproducible evidence.
license: MIT
---

# Harness Verify

## Overview

Use the project harness as the evidence engine for Symphony-ready delivery. Validation should be reproducible, tied to acceptance criteria, and ready to paste into `## Codex Workpad` and the PR.

## When to Use

- A ticket is approaching `Human Review`.
- A PR needs a test plan with concrete commands and evidence.
- UI, web, or frontend behavior needs Playwright, screenshot, trace, or recording proof.
- A previous run failed and the next attempt needs comparable evidence.

## Evidence Contract

Every validation pass should produce:

- Command: exact command, working directory, and relevant env flags.
- Result: pass/fail status, exit code, and short output summary.
- Evidence: logs, screenshots, Playwright trace, test report, API response, build output, or recording path.
- Mapping: which acceptance criterion each command proves.
- Destination: update `## Codex Workpad`, PR test plan, and Linear/PR attachments when the toolchain supports it.

## Steps

1. Read the ticket acceptance criteria and current Workpad validation checklist.
2. Prefer the repository's documented verification command over ad hoc checks.
3. If UI is touched, run Playwright or the project's browser test harness and preserve screenshot and trace artifacts.
4. For API or service work, include health check output, request/response samples, and relevant logs.
5. For docs-only work, run repository docs or markdown validation and cite changed paths.
6. If validation fails, keep the artifact path, explain the failure in the Workpad, fix, then rerun the same command.
7. Before moving to Human Review, confirm all ticket-provided `Validation`, `Test Plan`, or `Testing` items are covered.

## Workpad Snippet

```md
### Validation

- [x] `npm test` from repo root: passed, exit 0.
- [x] `npx playwright test`: passed; screenshot `artifacts/harness/home.png`; trace `artifacts/harness/trace.zip`.

### Notes

- Evidence maps to acceptance criteria 1-3. No outstanding actionable PR comments.
```

## Common Mistakes

- Reporting "works locally" without command output and evidence paths.
- Moving to `Human Review` while UI artifacts are missing.
- Running a different command after a failure, making evidence impossible to compare.
- Leaving generated traces or screenshots in untracked locations without documenting them.
