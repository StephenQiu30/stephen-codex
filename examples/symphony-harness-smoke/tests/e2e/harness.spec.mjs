import path from 'node:path';
import { expect, test } from '@playwright/test';

test('browser flow reaches Human Review ready with evidence', async ({ page, request }) => {
  await page.goto('/');
  await expect(page.getByRole('heading', { name: 'Symphony Harness Smoke' })).toBeVisible();

  await page.getByRole('button', { name: 'Run smoke workflow' }).click();
  await expect(page.getByTestId('state')).toHaveText('Human Review ready');

  const status = await request.get('/api/workflow-state');
  expect(status.ok()).toBeTruthy();
  await expect(await status.json()).toEqual(expect.objectContaining({ state: 'Human Review ready' }));

  await page.screenshot({
    path: path.join(process.cwd(), 'artifacts/harness/screenshot.png'),
    fullPage: true
  });
});
