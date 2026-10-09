// Kleiner statischer Server für die gebaute Web-Fassung (nur localhost).
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';

const typen = {
  '.html': 'text/html', '.js': 'application/javascript', '.mjs': 'application/javascript', '.json': 'application/json',
  '.wasm': 'application/wasm', '.css': 'text/css', '.png': 'image/png', '.jpg': 'image/jpeg', '.svg': 'image/svg+xml',
  '.ttf': 'font/ttf', '.otf': 'font/otf', '.woff2': 'font/woff2', '.ico': 'image/x-icon', '.bin': 'application/octet-stream',
};

export function starteServer(wurzel, port = 0) {
  const server = http.createServer((req, res) => {
    const url = new URL(req.url, 'http://localhost');
    let datei = path.join(wurzel, decodeURIComponent(url.pathname));
    if (!datei.startsWith(wurzel)) { res.writeHead(403); res.end(); return; }
    if (fs.existsSync(datei) && fs.statSync(datei).isDirectory()) datei = path.join(datei, 'index.html');
    if (!fs.existsSync(datei)) { res.writeHead(404); res.end('nicht gefunden'); return; }
    res.writeHead(200, { 'Content-Type': typen[path.extname(datei)] ?? 'application/octet-stream' });
    fs.createReadStream(datei).pipe(res);
  });
  return new Promise((ok) => server.listen(port, '127.0.0.1', () => ok(server)));
}
