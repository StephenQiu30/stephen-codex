const port = Number(process.env.PORT || 4173);
const response = await fetch(`http://127.0.0.1:${port}/healthz`);

if (!response.ok) {
  throw new Error(`health check failed with HTTP ${response.status}`);
}

const body = await response.json();
if (body.ok !== true) {
  throw new Error(`health check body was not ok: ${JSON.stringify(body)}`);
}

console.log(`healthy: ${body.service}`);
