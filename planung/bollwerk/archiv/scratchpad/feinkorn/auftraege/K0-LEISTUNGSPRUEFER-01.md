K0-LEISTUNGSPRUEFER-01 · Leistungsprüfer · Bauphase K0 · Version 1 · Schwierigkeit 2

## Rollenbriefing (Leistungsprüfer)
- Aufgabe: Bildzeit, Rechenlast, Speicher, Ladezeit, Größe und Testlaufzeiten messen und nachvollziehbar protokollieren.
- Gute Arbeit: jede Zahl mit Befehl, Umgebung und Datum; Wiederholungen statt Einzelwerte; Grenzen der Umgebung klar benannt.
- Häufige Fehler: (1) Zahlen ohne Messweg, (2) Messen, während andere schwere Läufe laufen, (3) Ergebnisse runden oder schönen.
- Unsicherheit: OFFENE FRAGE notieren, nicht raten.

## Aufgabe
Nimm den Teststand der Messbasis auf (alle bestehenden Prüfungen, ihre Laufzeiten und Ergebnisse) und schreibe zusammen mit den unten gelieferten Messwerten den Entwurf von planung/feinkorn/MESSBASIS.md.

## Das Projekt in fünf Sätzen
FEINKORN ist der Ausbau einer bestehenden iOS- und Android-App: Figuren, Gebäude und Gegenstände bestehen aus winzigen Pixel-Blöcken mit Material statt aus Bildern. Jeder Block erfüllt eine Funktion – er bestimmt, wie etwas aussieht, Licht annimmt, klingt, sich bewegt und zerbricht –, und abgelöste Blöcke fliegen als Dreck, Splitter oder Krümel und bleiben liegen. Figuren aus Pixel-Blöcken bewegen sich lebendig mit Skelett, Ruhe-Animationen und nachschwingender Kleidung. Alles baut auf der vorhandenen Technik auf, ändert sie nicht und läuft schonend auf Handys. Erstes Werkstück ist der Schlosskeller des Murder-Mystery-Spiels; jede Arbeit wird gemessen, nach Checkliste geprüft und nur vom Orchestrator integriert.

## Auszug Szenenvertrag/Kanon
Messbasis = gemessener Stand der App vor dem ersten Eingriff (Master-Prompt §6, §8). Arbeitsstand: Worktree /home/user/feinkorn, Branch kern-feinkorn = origin/main e7e4219 (die FEINKORN-Dateien unter packages/pixel_engine/lib/src/feinkorn, tool/feinkorn, lib/game/dev/feinkorn_k0_main.dart, packages/pixel_engine/bin/feinkorn_k0*.dart, planung/feinkorn sind neu und gehören NICHT zur Messbasis).

## Schnittstellen und gelieferte Messwerte (vom Orchestrator, übernimm sie wörtlich in eine Tabelle)
- Web-Build App (flutter build web --release --no-web-resources-cdn): build/web_app_basis 56 MB gesamt, main.dart.js 4,2 MB, canvaskit 37 MB, assets 17 MB (davon assets/assets 13 MB Burgstadt-Klänge). Miss die Größen selbst nach (du -sb) und trage beide Werte ein.
- Browser-Messung der Schlosskeller-Vorschau (tool/feinkorn/messen.mjs, Headless-Chromium ohne GPU, Software-WebGL), Datei /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/feinkorn/mess/basis.json – lies sie und übertrage alle Werte (Klasse, Ansicht, Ladezeit, Bilder/s ruhig/bewegt, p99, Rechenlast, Heap).
- Bestandsbild: dart run tool/feinkorn/bestand.dart (aus /home/user/feinkorn) – führe es aus und schreibe das Ergebnis mit --schreibe planung/feinkorn/messbasis/bestand.txt.

## Eigene Dateien
Nur neu: /home/user/feinkorn/planung/feinkorn/MESSBASIS.md und /home/user/feinkorn/planung/feinkorn/messbasis/bestand.txt.

## Grenzen (Bestandsschutz)
Keine andere Datei ändern; nichts committen, pushen, installieren; keine Sitzungs-, Agenten- oder Remote-Werkzeuge; nur im Ordner /home/user/feinkorn (NIE /home/user/werwolf_digital_flutter); keine Web-Builds (die gibt es schon); keine Browser-Läufe.

## Arbeitsschritte
1. Teststand: führe aus und protokolliere Laufzeit (time) und Ergebnis (Zahl der Tests, bestanden/nicht bestanden): (a) /opt/flutter/bin/flutter analyze im Wurzelordner; (b) /opt/flutter/bin/dart test in jedem Paket unter packages/ (vorher NICHT pub get nötig, ist erledigt); (c) Liste aller Prüfskripte unter tool/ mit einer Zeile Zweck (aus dem Kopfkommentar) – NICHT ausführen außer bestand.dart.
2. Build und CI: halte fest, dass kein .github/ existiert (prüfen), welche Deploy-Dateien es gibt (netlify.toml, vercel.json, railway.toml, build.sh) und was build.sh tut (Kopf lesen).
3. Größen: du -sb der Build-Ordner und Unterordner wie oben.
4. Bestandsbild schreiben (Schritt oben), Zeilenzahl und Bereiche nennen.
5. MESSBASIS.md: Abschnitte Umgebung (CPU aus /proc/cpuinfo, Kerne, kein GPU, Flutter-/Dart-Version), Darstellung heute (verweise auf BESTAND-BILDER.md), Teststand, Build/CI, Größe, Browser-Messung, Bestandsbild, Grenzen der Umgebung (kein Android-SDK, kein Xcode, keine Geräte; Akku/Wärme nicht messbar).

## Abnahmekriterien und Testweg
Jede Zahl mit Befehl; alle Paket-Tests erfasst; bestand.txt existiert und „/opt/flutter/bin/dart run tool/feinkorn/bestand.dart --vergleiche planung/feinkorn/messbasis/bestand.txt“ meldet GLEICH.

## Ausgabeformular
ÄNDERUNGEN · ERGEBNIS (Tabelle Teststand, Größen) · OFFENE FRAGEN · SELBSTPRÜFUNG.

## Selbstprüfung
Nur die zwei Dateien neu? Keine Zahl ohne Messweg? Nichts geschönt?

=== ENDE K0-LEISTUNGSPRUEFER-01 · BEREIT ZUR RÜCKGABE ===
