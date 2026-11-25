const { chromium } = require(process.env.HOME + '/.local/share/playwright/node_modules/playwright');
const fs = require('fs');
(async () => {
  const b = await chromium.launch({ chromiumSandbox: true });
  const p = await b.newPage({ viewport: { width: +process.argv[4] || 2560, height: +process.argv[5] || 1600 } });
  const svg = fs.readFileSync(process.argv[2], 'utf8');
  await p.setContent(`<html><body style="margin:0;background:#000">${svg}</body></html>`);
  await p.waitForTimeout(500);
  await p.screenshot({ path: process.argv[3], fullPage: false });
  await b.close();
})();
