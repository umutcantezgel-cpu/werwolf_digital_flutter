# P0-PROBE-03 · Browserlauf und gelieferte Bilder/s

Projekt „Burgstadt HD“. Repo `/home/user/werwolf_digital_flutter`, Branch `claude/pensive-gates-ajtp7x`, HEAD `677d423` (zum Laufzeitpunkt). Nichts committet, nichts gepusht.

## Ergebnis

- Lauf: **ja** (Build EXIT 0, beide Browserläufe EXIT 0).
- Bildraten (Browser-rAF-Zählung, `tool/browser/geraete.js:35-41`, Dauer je 3000 ms):

| Profil | ohne Drosselung (Start / Spiel) | Drosselung 4 (Start / Spiel) |
|---|---|---|
| desktop 1280×720 @1 | 20.0 / 11.9 | 13.2 / 9.0 |
| handy-quer 800×360 @3 | 8.8 / 7.9 | 8.0 / 7.5 |
| handy-hoch 360×800 @3 | 4.7 / 6.7 | 1.8 / 5.5 |

- Gelieferte Weltbilder werden von `geraete.js` **nicht** gezählt (Antwort zu 3).

## Befehle und Dauer

1. Build (Repo-Wurzel, `PATH=/opt/flutter/bin:$PATH`):
   `flutter build web --release --no-web-resources-cdn`
   Dauer: 87 s, EXIT 0. Log: `scratchpad/probe03/build.log`.
   Letzte Zeilen des Logs (wörtlich):
   ```
   Woah! You appear to be trying to run flutter as root.
   Compiling lib/main.dart for the Web...                             84.0s
   ✓ Built build/web
   EXIT 0 DAUER 87 s ENDE 2026-10-09T15:51:31+00:00
   ```
   `build/web/main.dart.js` (4394976 Byte, 15:51) und `build/web/index.html` neu erzeugt.

2. Browserlauf ohne Drosselung:
   `PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers node tool/browser/geraete.js build/web /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/probe03/geraete`
   Dauer: 93 s, EXIT 0. Ausgabe: `scratchpad/probe03/lauf1.log`.

3. Browserlauf mit Drosselung 4 (eigener Ordner, damit die Bilder aus 2 erhalten bleiben):
   `PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers node tool/browser/geraete.js build/web /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/probe03/geraete-drossel4 4`
   Dauer: 113 s, EXIT 0. Ausgabe: `scratchpad/probe03/lauf4.log`.

Playwright 1.56.1 (`/opt/node22/lib/node_modules/playwright`) startete Chromium aus `/opt/pw-browsers/chromium-1194` ohne Fehler. An `geraete.js` wurde nichts geändert, `playwright install` wurde nicht ausgeführt.

## Ausgabezeilen wörtlich

### ohne Drosselung (Drosselung 1×)
```
desktop · 1280x720 @1 · Drosselung 1× · Bildrate Start 20.0 / Spiel 11.9 · Konsole 0 · fremde Abrufe 0 · Gamepad wirkt
  BSMESS Welt 320x180 ×4 · UI 640x360 ×2 · Spiel 35.23 ms · RGBA+Übergabe 1.45 ms · Weg asynchron · verworfen 2
handy-quer · 800x360 @3 · Drosselung 1× · Bildrate Start 8.8 / Spiel 7.9 · Konsole 0 · fremde Abrufe 0
  BSMESS Welt 400x180 ×6 · UI 800x360 ×3 · Spiel 38.22 ms · RGBA+Übergabe 2.10 ms · Weg asynchron · verworfen 1
handy-hoch · 360x800 @3 · Drosselung 1× · Bildrate Start 4.7 / Spiel 6.7 · Konsole 0 · fremde Abrufe 0
  BSMESS Welt 180x400 ×6 · UI 360x800 ×3 · Spiel 44.88 ms · RGBA+Übergabe 2.35 ms · Weg asynchron · verworfen 2
```

### mit Drosselung 4×
```
desktop · 1280x720 @1 · Drosselung 4× · Bildrate Start 13.2 / Spiel 9.0 · Konsole 0 · fremde Abrufe 0 · Gamepad wirkt
  BSMESS Welt 320x180 ×4 · UI 640x360 ×2 · Spiel 84.12 ms · RGBA+Übergabe 5.03 ms · Weg asynchron · verworfen 13
handy-quer · 800x360 @3 · Drosselung 4× · Bildrate Start 8.0 / Spiel 7.5 · Konsole 0 · fremde Abrufe 0
  BSMESS Welt 400x180 ×6 · UI 800x360 ×3 · Spiel 77.79 ms · RGBA+Übergabe 11.96 ms · Weg asynchron · verworfen 2
handy-hoch · 360x800 @3 · Drosselung 4× · Bildrate Start 1.8 / Spiel 5.5 · Konsole 0 · fremde Abrufe 0
  BSMESS Welt 180x400 ×6 · UI 360x800 ×3 · Spiel 103.20 ms · RGBA+Übergabe 10.09 ms · Weg asynchron · verworfen 5
```

Die BSMESS-Zeile ist jeweils die letzte des Profils (`geraete.js:121`). Konsolenfehler und -warnungen: 0 in allen Profilen und beiden Läufen. Fremde Abrufe: 0. Gamepad-Simulation am Desktop: „wirkt“ in beiden Läufen (`geraete.js:108` setzt den Wert, `:119` zählt „OHNE WIRKUNG“ als Fehler).

## Bildschirmfotos

Bleiben im Scratch-Ordner, nicht nach `hd/bilder/` kopiert:

- Ohne Drosselung: `/tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/probe03/geraete/`
  - `desktop_start.png`, `desktop_spiel.png`, `handy-quer_start.png`, `handy-quer_spiel.png`, `handy-hoch_start.png`, `handy-hoch_spiel.png`
- Drosselung 4: `/tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/probe03/geraete-drossel4/`
  - gleiche sechs Dateien

Sichtprüfung: `desktop_spiel.png` und `handy-hoch_spiel.png` (Drossel 4) zeigen die Spielszene „Kamin-Gewölbe“ mit Fallakte-Boxen und Tutorial-Text; das Spiel läuft also im Browser.

## Antwort zu 1: Messung und Werte

**Bildrate (`tool/browser/geraete.js`)**
- `:35-41` `bildrate(page, ms)`: startet in der Seite eine `requestAnimationFrame`-Schleife, zählt die Aufrufe `n` und liefert `n * 1000 / Dauer`.
- `:76` Aufruf „Start“ (3000 ms), `:116` Aufruf „Spiel“ (3000 ms).
- `:118` Ausgabe `Bildrate Start … / Spiel …`.
- Gemessen werden also Browser-rAF-Aufrufe der Seite, nicht Flutter-Takte und nicht gelieferte Weltbilder.

**Konsole**
- `:69` `page.on('console')`: Texte mit Präfix `BSMESS` gehen in `mess`, Konsolenfehler und -warnungen in `konsole`.
- `:118` zählt `konsole.length`; `:121` hängt die letzte `BSMESS`-Zeile an den Bericht; `:122` listet bis zu 5 Konsolenzeilen.

**Start-Parameter**
- `:72` `?bs=fall&bsmess=1` (Handys) bzw. `?bsmess=1` (Desktop).
- `lib/burgstadt/burgstadt_seite.dart:14` liest `bs`; `lib/burgstadt/burgstadt_ansicht.dart:52` liest `bsmess`.

**Was der Spiel-Code liefert**
- Einzige Konsolenausgabe für die Messung: `lib/burgstadt/burgstadt_ansicht.dart:119-120`, `debugPrint('BSMESS $s · Spiel … ms · RGBA+Übergabe … ms · Weg ${_welt.weg} · verworfen ${_welt.verworfen}')`.
- Zeitmessung je Takt: `lib/burgstadt/burgstadt_ansicht.dart:103-105` (Spiel), `:110-117` (RGBA und Übergabe); Mittelwert über 120 Takte, Ausgabe bei `:118` (`++_messBilder == 120`).
- Aktivierung: `lib/burgstadt/burgstadt_ansicht.dart:50-56` (`_messen` nur bei Query `bsmess`).
- `_welt.weg` liefert `lib/burgstadt/frame_sink.dart:42`, `verworfen` ist `frame_sink.dart:11`, Zählung in `:29`.
- `debugPrint` ist nicht an `kDebugMode` gebunden: Standard ist `debugPrintThrottled` (`/opt/flutter/packages/flutter/lib/src/foundation/print.dart:50`), Ausgabe per `print()` (`:105`), Drosselung 12 KB pro Sekunde (`:88`, Standard-Pfad `debugPrintThrottled`). Die BSMESS-Zeile erscheint also auch im Release-Build, wenn `bsmess` gesetzt ist.
- Fensterwerte: **keine**. Suche in `lib/burgstadt`, `packages/burgstadt_spiel/lib` und `packages/pixel_engine/lib` nach `window.`, `dart:js`, `js_interop`, `package:web`, `globalThis`: kein Treffer im Messpfad (einziger Treffer außerhalb: `lib/session/token_store_web.dart`, nicht Messung).

## Antwort zu 3: Gelieferte Weltbilder

**Nein.** `geraete.js` zählt keine gelieferten Weltbilder. Die einzige Spiel-Angabe ist `verworfen` in der BSMESS-Zeile; das ist ein kumulativer Zähler ohne Zeitbezug, und `geraete.js` behält nur die letzte BSMESS-Zeile (`:121`).

Im Web-Build läuft `FrameSink` immer asynchron: `lib/burgstadt/frame_sink.dart:16` schaltet den synchronen Pfad mit `!kIsWeb` ab; alle BSMESS-Zeilen zeigen `Weg asynchron`.

Ein fertiges Weltbild entsteht im Callback `lib/burgstadt/frame_sink.dart:34-39`; dort wird `fertig()` in `:38` gerufen. Mögliche Abgriffe für einen Zähler „Weltbilder fertig“, ohne etwas zu ändern:
- `lib/burgstadt/frame_sink.dart:38`: unmittelbar vor `fertig()` das Zählfeld der Instanz erhöhen. Der sync-Pfad `:21-22` gilt nur für Nicht-Web.
- `lib/burgstadt/burgstadt_ansicht.dart:112`: `_welt.liefere(_weltRgba!, s.weltW, s.weltH, _neu)`. Der Callback `_neu` (`:127-129`) wird von `_welt` und `_ui` gemeinsam genutzt (`:113`), daher zählt ein Zähler in `_neu` auch UI-Bilder mit. Für Welt-only: eigener Closure bei `:112` oder Zähler pro Instanz in `frame_sink.dart:7-11`.
- Zeitbasis für eine Rate ist vorhanden: `lib/burgstadt/burgstadt_ansicht.dart:47` (`_uhr`, Stopwatch); die Ausgabe könnte in `:119-120` ergänzt werden.

## OFFENE FRAGEN

1. Die BSMESS-Zeile enthält keine Zeitangabe und erscheint nur alle 120 Takte (`burgstadt_ansicht.dart:118`). Aus den vorhandenen Zeilen lässt sich keine Weltbilder/s ableiten.
2. `verworfen` (`frame_sink.dart:29`) zählt verworfene Bilder; ob „Takte minus verworfen“ die gelieferten Bilder genau ergibt, ist nicht belegt, weil die Taktzahl pro Zeile nicht ausgegeben wird.
3. `geraete.js` gibt nur die letzte BSMESS-Zeile aus (`:121`); frühere Zeilen gehen verloren.
4. Ob die rAF-Zählung (`geraete.js:35-41`) dieselbe Rate wie der Flutter-Takt (`_takt`, `burgstadt_ansicht.dart:95`) misst, ist nicht belegt.
5. Der Auftrag nannte für den Drosselungslauf den Ordner `<ordner>`; gewählt wurde `geraete-drossel4`, damit die Bilder des ersten Laufs nicht überschrieben werden.
6. Flutter meldet „Woah! You appear to be trying to run flutter as root.“ (build.log). Der Build lief trotzdem fehlerfrei durch.

ENDE PAKET P0-PROBE-03
