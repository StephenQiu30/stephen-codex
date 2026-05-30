#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "README.md"
  "AGENTS.md"
  "AGENTS.local.md"
  "WORKFLOW.md"
  ".codex/skills/harness-local-server/SKILL.md"
  ".codex/skills/harness-playwright-evidence/SKILL.md"
  ".codex/skills/harness-linear-loop/SKILL.md"
  "examples/symphony-harness-smoke/README.md"
  "examples/symphony-harness-smoke/package.json"
  "examples/symphony-harness-smoke/.env.example"
  "examples/symphony-harness-smoke/src/server.mjs"
  "examples/symphony-harness-smoke/scripts/verify.sh"
  "examples/symphony-harness-smoke/scripts/render-workpad.mjs"
  "examples/symphony-harness-smoke/tests/e2e/harness.spec.mjs"
  "examples/symphony-harness-smoke/playwright.config.mjs"
  ".github/pull_request_template.md"
  "docs/README.md"
  "docs/TEMPLATE.md"
  "docs/prd/README.md"
  "docs/plans/README.md"
  "docs/design/README.md"
  "docs/acceptance/README.md"
  "docs/operations/README.md"
  "openspec/config.yaml"
)

for file in "${required_files[@]}"; do
  test -f "$file"
done

grep -q "## Test-First PR 提交规范" AGENTS.md
grep -q "test: add failing tests for xxx" AGENTS.md
grep -q "impl: make xxx tests pass" AGENTS.md
grep -q "中间产物" AGENTS.md
grep -q "npm test" AGENTS.md
grep -q "## Symphony-ready 编排原则" AGENTS.md
grep -q "Linear ticket" AGENTS.md
grep -q "## Codex Workpad" AGENTS.md
grep -q "Human Review" AGENTS.md
grep -q "Rework" AGENTS.md
grep -q "Playwright" AGENTS.md
grep -q "tracker:" WORKFLOW.md
grep -q "kind: linear" WORKFLOW.md
grep -q "project_slug" WORKFLOW.md
grep -q "## Codex Workpad" WORKFLOW.md
grep -q "Human Review" WORKFLOW.md
grep -q "name: harness-local-server" .codex/skills/harness-local-server/SKILL.md
grep -q "bootable" .codex/skills/harness-local-server/SKILL.md
grep -q "health check" .codex/skills/harness-local-server/SKILL.md
grep -q "env.example" .codex/skills/harness-local-server/SKILL.md
grep -q "logs" .codex/skills/harness-local-server/SKILL.md
grep -q "name: harness-playwright-evidence" .codex/skills/harness-playwright-evidence/SKILL.md
grep -q "Playwright" .codex/skills/harness-playwright-evidence/SKILL.md
grep -q "video start" .codex/skills/harness-playwright-evidence/SKILL.md
grep -q "video stop" .codex/skills/harness-playwright-evidence/SKILL.md
grep -q "trace" .codex/skills/harness-playwright-evidence/SKILL.md
grep -q "name: harness-linear-loop" .codex/skills/harness-linear-loop/SKILL.md
grep -q "Linear API" .codex/skills/harness-linear-loop/SKILL.md
grep -q "## Codex Workpad" .codex/skills/harness-linear-loop/SKILL.md
grep -q "upload video evidence" .codex/skills/harness-linear-loop/SKILL.md
grep -q "Human Review" .codex/skills/harness-linear-loop/SKILL.md
grep -q "harness-local-server" examples/symphony-harness-smoke/README.md
grep -q "harness-playwright-evidence" examples/symphony-harness-smoke/README.md
grep -q "harness-linear-loop" examples/symphony-harness-smoke/README.md
grep -q "## Codex Workpad" examples/symphony-harness-smoke/scripts/render-workpad.mjs
grep -q "video: 'on'" examples/symphony-harness-smoke/playwright.config.mjs
grep -q "trace: 'on'" examples/symphony-harness-smoke/playwright.config.mjs
grep -q "Test-first Evidence" .github/pull_request_template.md

bash examples/symphony-harness-smoke/scripts/validate-structure.sh

git diff --check
