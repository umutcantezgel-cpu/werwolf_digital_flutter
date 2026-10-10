Du bist Probeläufer im Projekt „Burgstadt HD“. Paket **P0-PROBE-03 · Browserlauf und gelieferte Bilder/s** (HZ-12).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md und /home/user/werwolf_digital_flutter/hd/rollen/PROBELAEUFER.md und halte dich an die Regeln.

## Hintergrund
`tool/browser/geraete.js` startet den Web-Build in Chromium (Playwright) in drei Profilen (desktop 1280×720, handy-quer 800×360 ×3, handy-hoch 360×800 ×3) und misst u. a. eine Bildrate. Chromium liegt unter `/opt/pw-browsers` (Umgebungsvariable `PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers`; nicht `playwright install` ausführen). Wichtig für Burgstadt HD ist die Zahl der **gelieferten Weltbilder pro Sekunde** (wie oft tatsächlich ein neues Weltbild fertig wird), nicht die Zahl der requestAnimationFrame-Aufrufe.

## Auftrag (Repo `/home/user/werwolf_digital_flutter`, PATH mit `/opt/flutter/bin` voran)
1. Lies `tool/browser/geraete.js` vollständig und beschreibe: wie die Bildrate gemessen wird (Datei:Zeile), welche Konsolenausgaben/Fensterwerte der Spiel-Code dafür liefert (suche in `lib/` der App und `packages/burgstadt_spiel/lib` nach den verwendeten Namen).
2. Web-Build: `flutter build web --release --no-web-resources-cdn` (in der Repo-Wurzel; dauert einige Minuten; im Hintergrund mit langem timeout starten). Danach `node tool/browser/geraete.js build/web /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/probe03/geraete` mit `PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers`. Läuft es nicht: Fehlermeldung wörtlich, Ursache suchen (Pfad zu Playwright in Zeile 5 ist `/opt/node22/lib/node_modules/playwright` – prüfe, ob er existiert, sonst `npm root -g`), und NUR über Umgebungsvariablen oder Aufrufparameter lösen, die Datei nicht ändern. Wenn eine Dateiänderung unvermeidbar ist: nicht ändern, sondern unter OFFENE FRAGEN genau beschreiben.
3. Ermittle, ob geraete.js gelieferte Weltbilder zählt. Wenn nicht: beschreibe genau, wo im Spiel-Code (Dart, App-Hülle `lib/`) ein Zähler „Weltbilder fertig“ abgegriffen werden könnte (Datei:Zeile), ohne etwas zu ändern.
4. Lauf mit Drosselung 4 (`node tool/browser/geraete.js build/web <ordner> 4`) zusätzlich.
5. Schreibe `/home/user/werwolf_digital_flutter/hd/laeufe/P0-PROBE-03.md`: Befehle, Dauer, alle Ausgabezeilen je Profil wörtlich (ohne/mit Drosselung), gemessene Bildraten je Profil, Pfade der Bildschirmfotos, Antwort zu 1 und 3, OFFENE FRAGEN, letzte Zeile `ENDE PAKET P0-PROBE-03`.
Die Bildschirmfotos bleiben im Scratch-Ordner; nenne die Pfade.

## Rückgabe
Kurz: lief ja/nein, Bildraten je Profil (ohne/mit Drosselung), ob gelieferte Weltbilder schon gezählt werden, Pfad der Datei.
