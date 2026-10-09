Du bist Autor im Projekt „Burgstadt HD“. Paket **P0-AUTOR-01 · Layout-Prüfsumme** (HZ-13).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md und /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md und halte dich an die Regeln.

## Ziel
Ein Werkzeug, das beweist: Burgstadt HD verschiebt kein Kartenlayout, keine Kollision, keine Türen, keine Stationen, keine Bewohner. Es läuft in jedem Schnelllauf und vor jedem Commit.

## Auftrag (genau diese Dateien)
1. **Neu** `/home/user/werwolf_digital_flutter/tool/layout_pruefsumme.dart` (reines Dart, nur `dart:io`, `dart:convert`, `package:burgstadt_core/...`; Aufruf aus der Repo-Wurzel: `/opt/flutter/bin/dart run tool/layout_pruefsumme.dart [--pruefe|--schreibe]`).
   - Baut die Welt GENAU wie das Spiel (`packages/burgstadt_spiel/lib/burgstadt_spiel_io.dart`, Funktion `ladeAusRepo`, Zeilen mit `baueWelt(`): alle `*.json` aus `packages/burgstadt_core/data/innenraeume` (Dateiliste nach Pfad SORTIERT), `haeuser` aus `packages/burgstadt_core/data/stadt/haeuser.json`, Seed Standard. Repo-Wurzel über `findeRepoWurzel()` aus `package:burgstadt_core/burgstadt_core_io.dart`.
   - Kanonische Textform je Bereich, Bereiche nach id sortiert: `id`, `innen`, `raumHoehe`, Breite×Tiefe, jede Kartenzeile (`karte`), für jede Kachel `art(x,z).index` und `begehbar(x,z)`, alle `marken` (sortiert, mit Koordinaten), alle `dinge` (sortiert nach z0,x0: zeichen, x0,z0,x1,z1, legende.art, form, hoehe, ziel, zielMarke, verschlossen, offenAbPhase, station, lichtWarm, lichtKalt, lichtWeite), `grundWarm`, `grundKalt`, Wand-/Boden-/Deckentextur.
   - Dazu: Bewohner-/Haus-Zuordnung, falls der Stadtgenerator sie berechnet (prüfe `packages/burgstadt_core/lib/src/welt/stadtgenerator.dart` und `packages/burgstadt_core/lib/src/fall/stadtleben.dart`; nimm auf, was dort deterministisch aus Seed und Daten entsteht, z. B. Hauszuordnung je Bewohner). Wenn nichts dergleichen existiert, schreibe das unter OFFENE FRAGEN.
   - **Zahl der Zufallsaufrufe** beim Bauen der Welt: füge in `packages/burgstadt_core/lib/src/zufall.dart` einen Zähler hinzu: `static int aufrufe = 0;` und in `naechste()` als erste Zeile `aufrufe++;` (sonst nichts an der Datei ändern). Das Werkzeug setzt `Zufall.aufrufe = 0` vor `baueWelt` und liest ihn danach.
   - Prüfsumme: FNV-1a 64 Bit über die UTF-8-Bytes der kanonischen Textform (in Dart auf der VM mit `int`, Multiplikation mit 0x100000001b3, Ergebnis als 16 Hex-Ziffern).
   - Ausgabe immer: `LAYOUT <hash16> · Bereiche <n> · Kacheln <summe> · Dinge <summe> · Zufallsaufrufe <n>`.
   - `--schreibe`: schreibt diese Zeile nach `/home/user/werwolf_digital_flutter/hd/belege/layout_ausgang.txt`.
   - `--pruefe`: vergleicht mit dieser Datei; druckt `LAYOUT GLEICH` (Exit 0) oder `LAYOUT ABWEICHUNG: erwartet …, ist …` (Exit 1). Fehlt die Datei: Meldung und Exit 2.
2. **Neu** `/home/user/werwolf_digital_flutter/packages/burgstadt_core/test/layout_pruefsumme_test.dart`: Fixture-Test, der die kanonische Form für eine winzige, im Test definierte Welt (2 Bereiche über `Bereich.ausJson`) bildet und prüft, dass (a) gleiche Eingabe → gleicher Hash, (b) eine verschobene Tür oder ein geändertes Ding → anderer Hash. Dafür die Funktionen zum Kanonisieren und Hashen in eine **neue** Bibliotheksdatei `packages/burgstadt_core/lib/src/welt/layout_pruefsumme.dart` legen (Funktionen `String kanonischeForm(Map<String, Bereich> welt)` und `String fnv1a64(String text)`), exportiert über `packages/burgstadt_core/lib/burgstadt_core.dart` (eine Zeile `export 'src/welt/layout_pruefsumme.dart';`). Das Werkzeug ruft diese Funktionen.
3. Nach dem Bauen: `cd /home/user/werwolf_digital_flutter && /opt/flutter/bin/dart run tool/layout_pruefsumme.dart --schreibe` und danach `--pruefe` zweimal (muss beide Male `LAYOUT GLEICH` sein, Determinismus).
4. `cd packages/burgstadt_core && /opt/flutter/bin/dart analyze --fatal-infos && /opt/flutter/bin/dart test test/layout_pruefsumme_test.dart test/zufall* 2>/dev/null; /opt/flutter/bin/dart test` – alles grün.
5. **NICHT** `tool/alle_tests.sh` ändern (das macht der Orchestrator).

## Rückgabe
Rückgabeformular laut AUTOR.md (ÄNDERUNGEN, TEST, PROBE = die LAYOUT-Zeile, STILBLATT-CHECK = „entfällt“, KANON-CHECK = „entfällt“, OFFENE FRAGEN, SELBSTPRÜFUNG), letzte Zeile `ENDE PAKET P0-AUTOR-01`.
