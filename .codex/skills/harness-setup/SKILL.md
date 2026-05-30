---
name: harness-setup
description: Use when a repository lacks repeatable local setup, one-command startup, documented environment variables, health checks, logs, or agent-safe validation entrypoints.
license: MIT
---

# Harness Setup

## Overview

Make the repository runnable and verifiable by an unattended agent before broad Symphony automation. A useful harness removes guesswork: install, configure, start, health check, validate, inspect logs, and collect evidence should all be explicit.

## When to Use

- A Linear ticket cannot be validated because startup or test commands are unclear.
- `WORKFLOW.md` clone/setup hooks would need hidden local knowledge.
- The project has no `.env.example`, health check, logs path, or documented service dependencies.
- UI or integration work depends on manual startup steps that an agent cannot repeat.

## Output Contract

Add or repair the smallest project-local harness that provides:

- one-command startup: `make start`, `scripts/start-local.sh`, `npm run dev`, or an equivalent command.
- one verification command: `scripts/verify.sh`, `make verify`, `npm test`, or an equivalent command.
- `.env.example` or an operations note that documents required variables, secret sources, and local/CI differences.
- A health check command or endpoint that proves the app is ready before tests run.
- logs discovery: exact file paths or commands for runtime, test, and background service logs.
- An artifact path for evidence, such as `artifacts/harness/` or the project's existing reports directory.

## Steps

1. Inventory existing package scripts, Makefile targets, CI jobs, Docker files, README commands, and operations docs.
2. Try the existing commands first and record failures in the active Workpad.
3. Add the thinnest wrapper around existing behavior; avoid replacing working project conventions.
4. Document environment setup without committing secrets.
5. Add readiness checks before browser, API, or integration validation.
6. Ensure the verification command exits nonzero on failure and prints the evidence path.
7. Update README or `docs/operations/` only when the harness behavior is durable.

## Acceptance

- A fresh workspace can install dependencies, start services, pass the health check, and run the verification command from documented steps.
- Failures point to logs or artifacts instead of requiring interactive diagnosis.
- The Linear Workpad and PR test plan name the harness commands that were run.

## Common Mistakes

- Adding a new script while leaving the old documented command broken.
- Hiding required secrets or accounts in local-only shell history.
- Treating screenshots or logs as optional for UI and integration work.
- Writing a harness that only works on the current machine.
