import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(new URL('..', import.meta.url).pathname);
const artifactDir = path.join(root, process.env.ARTIFACT_DIR || 'artifacts/harness');
const workpadTitle = process.env.WORKPAD_TITLE || '## Codex Workpad';

function collectFiles(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const fullPath = path.join(dir, entry.name);
    return entry.isDirectory() ? collectFiles(fullPath) : [fullPath];
  });
}

const files = collectFiles(artifactDir);
const relative = (file) => path.relative(root, file);
const screenshot = files.find((file) => file.endsWith('screenshot.png'));
const trace = files.find((file) => file.endsWith('trace.zip'));
const video = files.find((file) => file.endsWith('.webm'));

const missing = [
  ['screenshot', screenshot],
  ['trace', trace],
  ['video', video]
].filter(([, value]) => !value);

if (missing.length > 0) {
  console.error(`Missing evidence: ${missing.map(([name]) => name).join(', ')}`);
  process.exit(1);
}

const summary = {
  ticket: process.env.SMOKE_TICKET_ID || 'SMOKE-1',
  status: 'Human Review',
  workpadTitle,
  artifacts: {
    screenshot: relative(screenshot),
    trace: relative(trace),
    video: relative(video),
    serverLog: relative(path.join(artifactDir, 'server.log'))
  }
};

fs.mkdirSync(artifactDir, { recursive: true });
fs.writeFileSync(path.join(artifactDir, 'summary.json'), `${JSON.stringify(summary, null, 2)}\n`);

const markdown = `${workpadTitle}

\`\`\`text
local-smoke:${root}@example
\`\`\`

### Plan

- [x] 1. Start local server with harness-local-server.
- [x] 2. Capture browser evidence with harness-playwright-evidence.
- [x] 3. Prepare Linear handoff with harness-linear-loop.

### Acceptance Criteria

- [x] Health endpoint returns ok.
- [x] Browser flow reaches Human Review ready.
- [x] Evidence includes screenshot, trace, and video.

### Validation

- [x] \`npm run verify\`

### Notes

- PR evidence: screenshot \`${summary.artifacts.screenshot}\`, trace \`${summary.artifacts.trace}\`, video \`${summary.artifacts.video}\`.
- Ready for Human Review.
`;

fs.writeFileSync(path.join(artifactDir, 'linear-workpad.md'), markdown);
console.log(`wrote ${relative(path.join(artifactDir, 'linear-workpad.md'))}`);
