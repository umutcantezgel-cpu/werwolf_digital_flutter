// Ebene 9 · Geräte: Web-Build auf drei Geräteprofilen (Playwright/Chromium).
// Aufruf: node tool/browser/geraete.js <build/web> <ausgabeordner> [drosselung]
// Prüft: Start ohne Konsolenfehler, keine Netzabrufe außer localhost, Bildrate,
// Bildschirmfotos für Paletten-/Blocktest, Tastatur- und Touch-Steuerung.
const { chromium } = require('/opt/node22/lib/node_modules/playwright');
const http = require('http');
const fs = require('fs');
const path = require('path');

const root = path.resolve(process.argv[2] || 'build/web');
const out = path.resolve(process.argv[3] || 'nachtlauf/bilder/geraete');
const drossel = Number(process.argv[4] || 1);
fs.mkdirSync(out, { recursive: true });

const typen = { '.html': 'text/html', '.js': 'text/javascript', '.mjs': 'text/javascript', '.wasm': 'application/wasm', '.json': 'application/json', '.png': 'image/png', '.ttf': 'font/ttf', '.otf': 'font/otf', '.wav': 'audio/wav', '.frag': 'application/octet-stream' };
const server = http.createServer((req, res) => {
  let p = decodeURIComponent(req.url.split('?')[0]);
  if (p.endsWith('/')) p += 'index.html';
  const f = path.join(root, p);
  if (!f.startsWith(root) || !fs.existsSync(f) || fs.statSync(f).isDirectory()) { res.writeHead(404); res.end(); return; }
  res.writeHead(200, { 'Content-Type': typen[path.extname(f)] || 'application/octet-stream' });
  fs.createReadStream(f).pipe(res);
});

const profile = [
  { name: 'desktop', viewport: { width: 1280, height: 720 }, deviceScaleFactor: 1, isMobile: false, hasTouch: false },
  // Handys mit ganzzahligem Pixelverhältnis (1080×2400 bei ×3). Gebrochene Verhältnisse
  // lässt der Browser-Compositor um Bruchteile nachskalieren (siehe FÜR-DEN-NUTZER).
  { name: 'handy-quer', viewport: { width: 800, height: 360 }, deviceScaleFactor: 3, isMobile: true, hasTouch: true },
  { name: 'handy-hoch', viewport: { width: 360, height: 800 }, deviceScaleFactor: 3, isMobile: true, hasTouch: true },
];

const warte = (ms) => new Promise((r) => setTimeout(r, ms));

async function bildrate(page, ms) {
  return page.evaluate((ms) => new Promise((res) => {
    let n = 0; const t0 = performance.now();
    function f() { n++; if (performance.now() - t0 < ms) requestAnimationFrame(f); else res(n * 1000 / (performance.now() - t0)); }
    requestAnimationFrame(f);
  }), ms);
}

async function wischen(cdp, x0, y0, x1, y1, schritte, haltenMs) {
  await cdp.send('Input.dispatchTouchEvent', { type: 'touchStart', touchPoints: [{ x: x0, y: y0, id: 1 }] });
  for (let i = 1; i <= schritte; i++) {
    const t = i / schritte;
    await cdp.send('Input.dispatchTouchEvent', { type: 'touchMove', touchPoints: [{ x: x0 + (x1 - x0) * t, y: y0 + (y1 - y0) * t, id: 1 }] });
    await warte(16);
  }
  await warte(haltenMs);
  await cdp.send('Input.dispatchTouchEvent', { type: 'touchEnd', touchPoints: [] });
}

(async () => {
  await new Promise((r) => server.listen(0, '127.0.0.1', r));
  const port = server.address().port;
  const basis = `http://127.0.0.1:${port}/`;
  const browser = await chromium.launch({ args: ['--use-angle=swiftshader', '--enable-unsafe-swiftshader', '--ignore-gpu-blocklist'] });
  const bericht = [];
  let fehlerGesamt = 0;
  for (const p of profile) {
    const ctx = await browser.newContext({ viewport: p.viewport, deviceScaleFactor: p.deviceScaleFactor, isMobile: p.isMobile, hasTouch: p.hasTouch, locale: 'de-DE' });
    const page = await ctx.newPage();
    const cdp = await ctx.newCDPSession(page);
    if (drossel > 1) await cdp.send('Emulation.setCPUThrottlingRate', { rate: drossel });
    const konsole = [], fremd = [];
    const mess = [];
    page.on('console', (m) => { if (m.text().startsWith('BSMESS')) { mess.push(m.text()); return; } if (m.type() === 'error' || m.type() === 'warning') konsole.push(`${m.type()}: ${m.text()}`); });
    page.on('pageerror', (e) => konsole.push(`pageerror: ${e.message}`));
    page.on('request', (r) => { const u = new URL(r.url()); if (!['127.0.0.1', 'localhost'].includes(u.hostname) && u.protocol !== 'data:' && u.protocol !== 'blob:') fremd.push(r.url()); });
    const start = (p.name === 'desktop' ? '?' : '?bs=erkundung&') + 'bsmess=1';
    await page.goto(basis + start, { waitUntil: 'load' });
    await page.waitForSelector('flutter-view, flt-glass-pane', { timeout: 60000 });
    await warte(5000 * Math.max(1, drossel / 2));
    const fps0 = await bildrate(page, 3000);
    await page.screenshot({ path: path.join(out, `${p.name}_start.png`) });
    if (p.name === 'desktop') {
      // Tastatur: Fokus sichtbar machen, „Allein spielen“ bestätigen, vorwärts gehen, umsehen
      await page.mouse.click(5, 5);
      await page.keyboard.press('ArrowDown');
      await warte(200);
      await page.keyboard.press('Enter');
      await warte(500);
      await page.keyboard.down('KeyW'); await warte(1500); await page.keyboard.up('KeyW');
      await page.keyboard.down('ArrowRight'); await warte(400); await page.keyboard.up('ArrowRight');
      await page.mouse.move(800, 300); await page.mouse.down(); await page.mouse.move(700, 320, { steps: 10 }); await page.mouse.up();
    } else {
      // Touch: Joystick links nach oben ziehen und halten, rechts wischen zum Umsehen
      const w = p.viewport.width, h = p.viewport.height;
      await wischen(cdp, w * 0.2, h * 0.7, w * 0.2, h * 0.7 - 40, 8, 1200);
      await wischen(cdp, w * 0.7, h * 0.5, w * 0.6, h * 0.5, 8, 50);
    }
    await warte(600);
    const fps1 = await bildrate(page, 3000);
    await page.screenshot({ path: path.join(out, `${p.name}_spiel.png`) });
    const zeile = `${p.name} · ${p.viewport.width}x${p.viewport.height} @${p.deviceScaleFactor} · Drosselung ${drossel}× · Bildrate Start ${fps0.toFixed(1)} / Spiel ${fps1.toFixed(1)} · Konsole ${konsole.length} · fremde Abrufe ${fremd.length}`;
    bericht.push(zeile);
    if (mess.length) bericht.push('  ' + mess[mess.length - 1]);
    for (const k of konsole.slice(0, 5)) bericht.push('  ' + k);
    for (const f of fremd.slice(0, 5)) bericht.push('  FREMD ' + f);
    fehlerGesamt += konsole.filter((k) => !k.startsWith('warning')).length + fremd.length;
    await ctx.close();
  }
  await browser.close();
  server.close();
  fs.writeFileSync(path.join(out, 'bericht.txt'), bericht.join('\n') + '\n');
  console.log(bericht.join('\n'));
  process.exit(fehlerGesamt ? 1 : 0);
})();
