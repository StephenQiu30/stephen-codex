#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

test -f "$ROOT/.env.example"
test -f "$ROOT/src/server.mjs"
test -f "$ROOT/scripts/start-local.sh"
test -f "$ROOT/scripts/stop-local.sh"
test -f "$ROOT/scripts/health-check.mjs"
test -f "$ROOT/scripts/render-workpad.mjs"
test -f "$ROOT/tests/e2e/harness.spec.mjs"
test -f "$ROOT/playwright.config.mjs"

grep -q "health check" "$ROOT/scripts/start-local.sh"
grep -q "Human Review" "$ROOT/scripts/render-workpad.mjs"
grep -q "screenshot.png" "$ROOT/tests/e2e/harness.spec.mjs"
grep -q "trace: 'on'" "$ROOT/playwright.config.mjs"
grep -q "video: 'on'" "$ROOT/playwright.config.mjs"

node --check "$ROOT/src/app.mjs"
node --check "$ROOT/src/server.mjs"
node --check "$ROOT/scripts/health-check.mjs"
node --check "$ROOT/scripts/render-workpad.mjs"
