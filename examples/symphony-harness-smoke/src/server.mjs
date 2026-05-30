import http from 'node:http';
import { getWorkflowState, renderHomePage } from './app.mjs';

const port = Number(process.env.PORT || 4173);

export function createServer() {
  return http.createServer((request, response) => {
    const url = new URL(request.url || '/', `http://${request.headers.host || '127.0.0.1'}`);

    if (url.pathname === '/healthz') {
      response.writeHead(200, { 'content-type': 'application/json' });
      response.end(JSON.stringify({ ok: true, service: 'symphony-harness-smoke' }));
      return;
    }

    if (url.pathname === '/api/workflow-state') {
      response.writeHead(200, { 'content-type': 'application/json' });
      response.end(JSON.stringify(getWorkflowState()));
      return;
    }

    response.writeHead(200, { 'content-type': 'text/html; charset=utf-8' });
    response.end(renderHomePage());
  });
}

if (import.meta.url === `file://${process.argv[1]}`) {
  const server = createServer();
  server.listen(port, '127.0.0.1', () => {
    console.log(`symphony-harness-smoke listening on http://127.0.0.1:${port}`);
  });
}
