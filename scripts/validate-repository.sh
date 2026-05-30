#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "README.md"
  "AGENTS.md"
  "AGENTS.local.md"
  "WORKFLOW.md"
  ".codex/skills/harness-setup/SKILL.md"
  ".codex/skills/harness-verify/SKILL.md"
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
grep -q "name: harness-setup" .codex/skills/harness-setup/SKILL.md
grep -q "one-command startup" .codex/skills/harness-setup/SKILL.md
grep -q "health check" .codex/skills/harness-setup/SKILL.md
grep -q "env.example" .codex/skills/harness-setup/SKILL.md
grep -q "logs" .codex/skills/harness-setup/SKILL.md
grep -q "name: harness-verify" .codex/skills/harness-verify/SKILL.md
grep -q "Playwright" .codex/skills/harness-verify/SKILL.md
grep -q "screenshot" .codex/skills/harness-verify/SKILL.md
grep -q "trace" .codex/skills/harness-verify/SKILL.md
grep -q "## Codex Workpad" .codex/skills/harness-verify/SKILL.md
grep -q "Human Review" .codex/skills/harness-verify/SKILL.md
grep -q "Test-first Evidence" .github/pull_request_template.md

git diff --check
