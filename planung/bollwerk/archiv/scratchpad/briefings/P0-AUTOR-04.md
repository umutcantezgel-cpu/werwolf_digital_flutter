Du bist Autor im Projekt „Burgstadt HD“. Paket **P0-AUTOR-04 · Szenenmessung** (HZ-12).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md und /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md und halte dich an die Regeln.

## Ziel
Ein Messwerkzeug für die echte Spielszene (nicht die Demo), das die Bildkosten nach Arbeitsschritten aufschlüsselt. Damit wird entschieden, ob die Stufe „scharf“ (4-fache Pixelzahl) tragbar ist und wo optimiert werden muss.

## Auftrag
**Neu** `/home/user/werwolf_digital_flutter/packages/burgstadt_spiel/bin/szenen_mess.dart`. Aufruf aus `packages/burgstadt_spiel`: `dart run bin/szenen_mess.dart [breite höhe] [--welt BxH] [--bilder N]` (Standard 1280×720, N = 120).
- Welt und Fall wie in `bin/leistung.dart` (`ladeAusRepo`, `starteFall`, `Erkundung(sitzung: s)`, Phase 2), damit Figuren und Bewohner vorhanden sind.
- `--welt BxH` erzwingt eine Weltpuffergröße unabhängig von der Skalierung (für „640×360 erzwungen“): lege dafür nach `spiel.groesse(...)` einen eigenen `PixelBuffer(B, H)` und `Renderer(buffer, spiel.licht, spiel.texturen)` an und rendere die Szene über eine KOPIE der Schritte aus `Spiel.zeichneBereich` (Datei `lib/src/spiel.dart`), damit du die Zeiten je Schritt messen kannst. `lib/` nicht ändern.
- 4 feste Szenen: Oberstadt Marktplatz (Marke `b` in `stadt`, Blick die längste Gasse entlang – Funktion `sichtweite` aus `bin/belegfotos.dart` kopieren), Oberstadt zweite Stelle (eine andere Marke mit weitem Blick), ein Innenraum (größter Fall-Ort aus fallorte.json), Burghof. Je Szene dreht sich die Kamera in N Bildern einmal um 360°.
- Schritte je Bild getrennt messen (Stopwatch, Mikrosekunden): (1) `begin`+Himmel/clear, (2) Meshes, (3) Sprites (Figuren), (4) Fledermäuse (nur stadt), (5) Blickfilter (einmal je Szene mit blick=true messen, zusätzlich), (6) Umwandlung nach RGBA (`toRgba` in einen vorhandenen Puffer).
- Zählwerte aus `renderer.stats` (Meshes gezeichnet/eingereicht, Dreiecke gezeichnet/eingereicht, Sprites, geschriebene Pixel) und daraus die **Überdeckungsquote** = geschriebene Pixel / Weltpixel (wie oft im Mittel ein Pixel überschrieben wird).
- **Kosten je Weltpixel**: (Summe Schritte 1–4 + 6) / Weltpixel in Nanosekunden.
- **Dreieckskosten**: Zeit Schritt 2 aufgeteilt in fixen Anteil je gezeichnetem Dreieck und Anteil je Pixel – schätze per linearer Regression über alle Bilder (Zeit = a·Dreiecke + b·Pixel); gib a (µs/Dreieck) und b (ns/Pixel) aus.
- Aufwärmen: 60 Bilder vorab ohne Messung (JIT).
- Ausgabe je Szene eine Zeile `SZENE <name> · Welt BxH · Bild <ms> · Himmel <ms> · Meshes <ms> · Sprites <ms> · Fledermäuse <ms> · RGBA <ms> · Blickfilter <ms> · Meshes <g>/<e> · Dreiecke <g>/<e> · Überdeckung <q> · ns/Pixel <n>`; am Ende `SZENENMESSUNG Mittel Bild <ms> · ns/Pixel <n> · Überdeckung <q> · a <µs/Dreieck> · b <ns/Pixel>`.
- Optional `--json <pfad>` schreibt alle Zahlen maschinenlesbar.

Läufe (Pflicht, Ergebnisse in die Rückgabe): (a) Standard 1280×720 (Qualität mittel → Welt 320×180), (b) `--welt 640x360`. Sieh dir dabei an, ob die Zahlen plausibel sind (z. B. Bild (b) ≈ 2–4× Bild (a)).

`cd packages/burgstadt_spiel && /opt/flutter/bin/dart analyze --fatal-infos` grün. Probe: ein PNG der Szene „Marktplatz“ bei 640×360 nach `/home/user/werwolf_digital_flutter/hd/bilder/proben/P0-AUTOR-04_markt_640.png` (PNG-Schreiben wie in `bin/bildschirmfoto.dart`); ansehen mit Read, ein Satz Beschreibung.

## Rückgabe
Rückgabeformular laut AUTOR.md; unter PROBE die vollständigen Ausgaben beider Läufe wörtlich. Letzte Zeile `ENDE PAKET P0-AUTOR-04`.
