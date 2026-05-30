export function getWorkflowSteps() {
  return [
    'local server booted',
    'health check passed',
    'Playwright evidence captured',
    'Linear Workpad rendered',
    'Human Review ready'
  ];
}

export function getWorkflowState() {
  return {
    ticket: process.env.SMOKE_TICKET_ID || 'SMOKE-1',
    state: 'Human Review ready',
    workpadTitle: process.env.WORKPAD_TITLE || '## Codex Workpad',
    steps: getWorkflowSteps()
  };
}

export function renderHomePage() {
  const greeting = process.env.APP_GREETING || 'Symphony harness smoke';
  const steps = getWorkflowSteps()
    .map((step) => `<li>${step}</li>`)
    .join('');

  return `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Symphony Harness Smoke</title>
    <style>
      body { font-family: system-ui, sans-serif; margin: 3rem; color: #182026; background: #f7f9fb; }
      main { max-width: 720px; }
      button { padding: 0.65rem 0.9rem; border: 1px solid #1f6feb; background: #1f6feb; color: white; border-radius: 6px; }
      code, output { background: white; border: 1px solid #d8dee4; border-radius: 6px; padding: 0.2rem 0.35rem; }
    </style>
  </head>
  <body>
    <main>
      <h1>Symphony Harness Smoke</h1>
      <p>${greeting}</p>
      <p>Ticket <code>SMOKE-1</code> proves local server, Playwright evidence, and Linear Workpad handoff.</p>
      <button type="button">Run smoke workflow</button>
      <p>Status: <output data-testid="state">Waiting</output></p>
      <ol>${steps}</ol>
    </main>
    <script>
      document.querySelector('button').addEventListener('click', () => {
        document.querySelector('[data-testid="state"]').textContent = 'Human Review ready';
      });
    </script>
  </body>
</html>`;
}
