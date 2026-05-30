import assert from 'node:assert/strict';
import test from 'node:test';
import { getWorkflowState, renderHomePage } from '../../src/app.mjs';

test('workflow state is ready for review', () => {
  const state = getWorkflowState();

  assert.equal(state.state, 'Human Review ready');
  assert.equal(state.workpadTitle, '## Codex Workpad');
  assert.ok(state.steps.includes('Playwright evidence captured'));
});

test('home page exposes smoke workflow controls', () => {
  const html = renderHomePage();

  assert.match(html, /Symphony Harness Smoke/);
  assert.match(html, /Run smoke workflow/);
  assert.match(html, /data-testid="state"/);
});
