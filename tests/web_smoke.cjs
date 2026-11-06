// Optional browser check; Playwright and Chromium are supplied by the cloud runtime.
const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const browser = await chromium.launch({
    executablePath: '/usr/bin/chromium', headless: true,
    args: ['--no-sandbox', '--use-angle=swiftshader', '--enable-unsafe-swiftshader'],
  });
  const errors = [];
  try {
    const context = await browser.newContext({
      viewport: { width: 393, height: 873 }, deviceScaleFactor: 1,
      isMobile: true, hasTouch: true,
    });
    const page = await context.newPage();
    page.on('console', message => {
      if (message.type() === 'error') errors.push(message.text());
    });
    page.on('pageerror', error => errors.push(error.message));
    await page.goto(process.argv[2] || 'http://127.0.0.1:8765/', {
      waitUntil: 'networkidle', timeout: 60000,
    });
    await page.waitForFunction(() => !document.getElementById('status') &&
      document.querySelector('canvas')?.width > 0, null, { timeout: 60000 });
    const before = await page.screenshot({ path: 'build/web-ready.png' });
    const canvas = await page.locator('canvas').boundingBox();
    if (!canvas || canvas.width < 300 || canvas.height < 500) throw Error('Game canvas not visible');
    // One native touch on the primary launch control, then inspect the result frame.
    const scale = Math.min(canvas.width / 540, canvas.height / 960);
    const contentHeight = 960 * scale;
    const top = canvas.y + (canvas.height - contentHeight) / 2;
    await page.touchscreen.tap(canvas.x + canvas.width * 0.5, top + contentHeight * 0.885);
    await page.waitForTimeout(2800);
    const after = await page.screenshot({ path: 'build/web-after-touch.png' });
    if (before.equals(after)) throw Error('Touch did not change the rendered game');
    const result = { canvas, javascriptErrors: errors, touchInjected: true };
    fs.writeFileSync('build/web-browser-result.json', JSON.stringify(result, null, 2) + '\n');
    if (errors.length) throw Error(errors.join('\n'));
    console.log('Web build loaded, touch dispatched, screenshots captured; no JavaScript errors.');
  } finally {
    await browser.close();
  }
})().catch(error => { console.error(error); process.exitCode = 1; });
