#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
PORT="${PORT:-4173}"
ARTIFACT_DIR="$ROOT/${ARTIFACT_DIR:-artifacts/harness}"
STATE_DIR="$ROOT/.harness"
PID_FILE="$STATE_DIR/server.pid"

mkdir -p "$ARTIFACT_DIR" "$STATE_DIR"

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  echo "Server already running with pid $(cat "$PID_FILE")"
else
  PORT="$PORT" node "$ROOT/src/server.mjs" >"$ARTIFACT_DIR/server.log" 2>&1 &
  echo "$!" >"$PID_FILE"
fi

for _ in $(seq 1 40); do
  if PORT="$PORT" node "$ROOT/scripts/health-check.mjs" >/dev/null 2>&1; then
    echo "health check passed on http://127.0.0.1:$PORT/healthz"
    exit 0
  fi
  sleep 0.25
done

echo "health check failed; see $ARTIFACT_DIR/server.log" >&2
exit 1
