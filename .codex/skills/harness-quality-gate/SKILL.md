---
name: harness-quality-gate
description: Use when a Symphony or WORKFLOW-driven ticket must follow Harness + Superpowers quality gates—planning, TDD, execution, E2E evidence, and review-ready verification.
license: MIT
---

# Harness + Superpowers Quality Gate

## Purpose

Bind [Harness engineering](https://openai.com/index/harness-engineering/) (repeatable start, verify, evidence) with [obra/superpowers](https://github.com/obra/superpowers) skills so unattended agents do not skip TDD or end-to-end proof.

User rules in `AGENTS.md` / `WORKFLOW.md` take precedence over Superpowers when they conflict.

## When to use

- Any `Todo` / `In Progress` Linear ticket run via `WORKFLOW.md`.
- Before moving to `Human Review` or marking validation complete.

## Skill stack (order)

| Phase | Skill path | Outcome |
|-------|------------|---------|
| Session start | `.codex/skills/using-superpowers/SKILL.md` | Load applicable skills before acting |
| Plan | `.codex/skills/writing-plans/SKILL.md` | Workpad plan + acceptance + test strategy |
| Linear loop | `.codex/skills/harness-linear-loop/SKILL.md` | Status, `## Codex Workpad`, PR linkage |
| Red (TDD) | `.codex/skills/test-driven-development/SKILL.md` | Failing test or documented exception; `test:` commit |
| Implement | `.codex/skills/executing-plans/SKILL.md` | Minimal `impl:` / `feat:` commits from plan |
| Debug | `.codex/skills/systematic-debugging/SKILL.md` | When reproduction or CI fails unexpectedly |
| Harness run | `.codex/skills/harness-local-server/SKILL.md` | App/runtime up for validation |
| E2E evidence | `.codex/skills/harness-playwright-evidence/SKILL.md` | UI flows: screenshot/trace/video in Workpad |
| Pre-handoff | `.codex/skills/verification-before-completion/SKILL.md` | No “done” without command output proof |
| Review prep | `.codex/skills/requesting-code-review/SKILL.md` | PR ready for human review |
| Git | `commit` → `push` → `pull` → `land` skills | Typed commits and PR body per template |

## TDD + commit contract

1. Follow `test-driven-development` for red → green → refactor.
2. Map phases to commits: `test:` (red) → `impl:` / `feat:` (green) → optional `refactor:` / `docs:` / `chore:`.
3. Record red/green commands in Workpad `Test-first Evidence` and PR `Test-first Evidence`.

## End-to-end bar

1. Unit/integration: project verify command (document in Workpad `Validation`).
2. UI/runtime: `harness-local-server` then `harness-playwright-evidence` when the ticket touches UI or user flows.
3. `verification-before-completion`: re-run checks after the last change; paste failing/passing output in Workpad `Notes`.

## Human Review gate

Do not move to `Human Review` until:

- [ ] Superpowers TDD red + green evidence recorded
- [ ] Harness validation commands green on latest commit
- [ ] E2E evidence attached or linked when UI/app-touching
- [ ] `verification-before-completion` checklist satisfied
- [ ] PR body matches test-first template (`push` skill)

## Exceptions

Docs-only, CI-only, or non-scriptable work: document substitute validation in Workpad and PR; still run `verification-before-completion` for what *is* scriptable.
