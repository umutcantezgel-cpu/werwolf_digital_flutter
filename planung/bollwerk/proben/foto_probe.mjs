// Bildverfahren BOLLWERK (Probe des Meta-Laufs). Fotografiert den Partymodus eines Web-Builds
// mit fester Uhr (page.clock) in drei Ansichten. Herkunft: Kopie von
// origin/finalisierung-schlosskeller:tool/e2e/raeume.mjs, Playwright über createRequire.
// Aufruf: node foto_probe.mjs <worktree> <ausgabeOrdner> [stellen=buffetsaal,kaminsaal,ostsaal] [zusatz=pfad=ahmet&n=12]
import { createRequire } from 'node:module';
import path from 'node:path';
import fs from 'node:fs';
import crypto from 'node:crypto';
import { starteServer } from './server.mjs';
const require = createRequire('/opt/node22/lib/node_modules/playwright/');
const { chromium } = require('/opt/node22/lib/node_modules/playwright');

const [wt, ausArg, stellenArg, zusatzArg] = process.argv.slice(2);
if (!wt || !ausArg) { console.error('Aufruf: node foto_probe.mjs <worktree> <aus> [stellen] [zusatz]'); process.exit(2); }
const aus = path.resolve(ausArg); fs.mkdirSync(aus, { recursive: true });
const zusatz = zusatzArg ?? 'pfad=ahmet&n=12';
const alle = { buffetsaal: '14.5,13.5', vorratsraum: '14.5,4.5', durchgang: '8.5,9.5', kaminsaal: '5.5,13.5',
  turmgang: '2.5,4.5', ostsaal: '21.5,12.5', windfang: '14.5,20.5' };
const stellen = (stellenArg ?? 'buffetsaal,kaminsaal,ostsaal').split(',');
const ansichten = [['hoch', 393, 852], ['quer', 852, 393], ['tablet', 1180, 820]];
const START = new Date('2026-10-10T00:30:00Z');
const STREIFEN = Number(process.env.STREIFEN ?? 0); // >0: Bewegungsstreifen mit so vielen Bildern im Abstand 0,25 s (nur erste Ansicht)

const server = await starteServer(path.join(path.resolve(wt), 'build/web'));
const port = server.address().port;
const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
const fremd = [], fehler = [], zeilen = [];
for (const name of stellen) for (const [ansicht, w, h] of ansichten) {
  const page = await browser.newPage({ viewport: { width: w, height: h }, deviceScaleFactor: 2 });
  await page.clock.install({ time: START });
  page.on('request', (r) => { const u = new URL(r.url());
    if (!['127.0.0.1', 'localhost'].includes(u.hostname) && !['data:', 'blob:'].includes(u.protocol)) fremd.push(r.url()); });
  page.on('console', (m) => { if (m.type() === 'error') fehler.push(`${name}/${ansicht}: ${m.text()}`); });
  page.on('pageerror', (e) => fehler.push(`${name}/${ansicht}: ${e.message}`));
  let bereit = false;
  page.on('console', (m) => { if (m.text().startsWith('PARTY foto=entscheidungen')) bereit = true; });
  await page.goto(`http://127.0.0.1:${port}/?party=schlosskeller&${zusatz}&bis=entscheidungen&at=${alle[name]}&zoom=1.05`, { waitUntil: 'load' });
  for (let i = 0; i < 600 && !bereit; i++) { await page.clock.runFor(100); await page.waitForTimeout(20); }
  await page.clock.runFor(3500);
  await page.waitForTimeout(300);
  const datei = path.join(aus, `${name}_${ansicht}.png`);
  await page.screenshot({ path: datei });
  if (STREIFEN > 0 && ansicht === 'quer') {
    for (let k = 1; k <= STREIFEN; k++) {
      await page.clock.runFor(250); await page.waitForTimeout(60);
      await page.screenshot({ path: path.join(aus, `${name}_streifen_${String(k).padStart(2, '0')}.png`) });
    }
  }
  const sha = crypto.createHash('sha256').update(fs.readFileSync(datei)).digest('hex');
  zeilen.push(`${sha}  ${path.basename(datei)}  bereit=${bereit}`);
  await page.close();
}
await browser.close(); server.close();
fs.writeFileSync(path.join(aus, 'SHA256.txt'), zeilen.join('\n') + '\n');
console.log(zeilen.join('\n'));
console.log(`Fremde Netzaufrufe: ${fremd.length} · Konsolenfehler: ${fehler.length}`);
for (const f of fehler.slice(0, 5)) console.log('  ', f);
