#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ARTIFACT_DIR="$ROOT/${ARTIFACT_DIR:-artifacts/harness}"

cd "$ROOT"
mkdir -p "$ARTIFACT_DIR"

cleanup() {
  bash "$ROOT/scripts/stop-local.sh" || true
}
trap cleanup EXIT

npm test
bash "$ROOT/scripts/start-local.sh"
npm run health

if ! node -e "import('@playwright/test')" >/dev/null 2>&1; then
  echo "Missing @playwright/test. Run: npm install --no-package-lock && npx playwright install chromium" >&2
  exit 1
fi

npm run e2e
npm run linear:workpad

echo "workflow smoke passed; artifacts in $ARTIFACT_DIR"
