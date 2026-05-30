# Symphony Harness Smoke

This tiny project tests the full Symphony-ready loop without depending on a real product codebase.

It maps the three harness skills to runnable commands:

- `harness-local-server`: `bash scripts/start-local.sh`, `npm run health`, `bash scripts/stop-local.sh`
- `harness-playwright-evidence`: `npm run e2e` creates screenshot, trace, video, console-ready reports
- `harness-linear-loop`: `npm run linear:workpad` renders a simulated `## Codex Workpad`

## Run

```bash
npm install --no-package-lock
npx playwright install chromium
npm run verify
```

Artifacts are written to `artifacts/harness/`:

- `server.log`
- `screenshot.png`
- Playwright `trace.zip`
- Playwright `.webm` video
- `linear-workpad.md`
- `summary.json`

This example intentionally keeps the app small: one local server, one health endpoint, one browser flow, and one Workpad renderer.
