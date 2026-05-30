import { defineConfig } from '@playwright/test';

const port = Number(process.env.PORT || 4173);

export default defineConfig({
  testDir: './tests/e2e',
  timeout: 30_000,
  outputDir: './artifacts/harness/playwright-results',
  reporter: [
    ['list'],
    ['html', { outputFolder: 'artifacts/harness/playwright-report', open: 'never' }]
  ],
  use: {
    baseURL: `http://127.0.0.1:${port}`,
    browserName: 'chromium',
    screenshot: 'only-on-failure',
    trace: 'on',
    video: 'on'
  }
});
