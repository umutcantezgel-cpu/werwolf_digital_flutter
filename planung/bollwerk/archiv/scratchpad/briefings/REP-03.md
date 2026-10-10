Du bist Autor im Projekt „Burgstadt HD“. Paket **REP-03 · Szenenmessung v2** (HZ-12). Reparaturpaket zu P0-AUTOR-04 nach Gegenprüfung P0-GEGEN-01.

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md und /home/user/werwolf_digital_flutter/hd/gegen/P0-GEGEN-01.md (Befunde S-01…S-05).

## Problem
`packages/burgstadt_spiel/bin/szenen_mess.dart` misst Wanduhrzeit (streut unter Last 5–18 ms, S-01), die Regression ohne Mesh-Term trägt nicht (S-03), Figuren sind kaum im Bild (S-04).

## Änderungen (genau so)
1. **Prozessorzeit des Threads** statt Wanduhr: übernimm die Funktion `_threadCpuUhr()` aus `packages/burgstadt_spiel/bin/leistung.dart` (Zeilen ~152–170, dart:ffi, clock_gettime CLOCK_THREAD_CPUTIME_ID) in eine NEUE Datei `packages/burgstadt_spiel/bin/mess/cpu_uhr.dart` (öffentliche Funktion `double Function()? threadCpuUhr()`), und miss alle Schritte damit. Wenn sie null liefert (kein Linux), Wanduhr mit Hinweis.
2. **Wiederholung und Median:** jede Szene R = 3 Mal komplett messen; je Schritt der **Median** der drei Szenenmittel. Zusätzlich die Spanne (max − min) der Bildzeit in % drucken.
3. **Regression** mit drei Termen ohne Achsenabschnitt: Zeit(Meshes-Schritt) = a·Dreiecke + b·Pixel + c·gezeichnete Meshes; gib a (µs/Dreieck), b (ns/Pixel), c (µs/Mesh) und das Bestimmtheitsmaß R² aus. Lösung über die 3×3-Normalgleichungen (Gauß), deterministisch.
4. **Figurenszene:** neue fünfte Szene „Figuren“: Oberstadt-Marktplatz, Kamera fest (keine Drehung), 8 Figuren (Rollenkarten der Sitzung) in 3–9 m Abstand gleichmäßig im Blickfeld platzieren und je Bild mit `renderer.drawSprite` zeichnen (Bilder über `s.figuren.bild(...)` wie in `lib/src/spiel.dart` `zeichneBereich`); so werden Sprite-Kosten messbar. Vor der Messung alle 8 Figuren einmal backen (Aufwärmen).
5. **Handylicht:** Option `--handylicht an|aus` (Standard `an` wie bisher; in der Kopfzeile drucken).
6. Ausgabeformat wie bisher plus `· Spanne <p> %` je Szene und am Ende `SZENENMESSUNG v2 Mittel Bild <ms> · ns/Pixel <n> · Überdeckung <q> · a <µs/Dreieck> · b <ns/Pixel> · c <µs/Mesh> · R² <r> · Uhr <Thread-CPU|Wanduhr>`.
7. Die Datei darf 400 Zeilen nicht überschreiten: lagere die Szenen-Wahl (sichtweite usw.) oder anderes in `packages/burgstadt_spiel/bin/mess/szenen.dart` aus (NEU, nur von dir). `lib/` nicht ändern. Die Dateien `bin/mess/hilfen.dart` und `bin/mess/banding_hilfen.dart` gehören anderen Paketen – nicht anlegen, nicht ändern.

## Pflichtläufe (Ausgaben wörtlich in die Rückgabe)
- `cd /home/user/werwolf_digital_flutter/packages/burgstadt_spiel && /opt/flutter/bin/dart analyze --fatal-infos` grün (Infos aus fremden Dateien nur nennen)
- `dart run bin/szenen_mess.dart` (320×180) und `dart run bin/szenen_mess.dart --welt 640x360`
- Gib je Lauf die Spanne der Bildzeit an; Ziel ≤ 15 % (die Maschine ist durch andere Agenten belastet – nenne die Last aus `cat /proc/loadavg` vor dem Lauf).

## Rückgabe
Rückgabeformular laut AUTOR.md, letzte Zeile `ENDE PAKET REP-03`.
