# M1-INV-03 · Inventar Tests und Prüfwerkzeuge

Baum (nur lesen): `/tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/wt/fin`
Alle Pfade unten sind relativ zu diesem Baum.

## Tests je Paket

Befehle: `find . -name pubspec.yaml -not -path '*/.dart_tool/*'`; je Paket `find <Paket>/test -name '*_test.dart'` (Root nur `test/`, ohne die Unterpakete); `grep -c 'test('` und `grep -c 'testWidgets('` je Datei, summiert.

| Paket (name) | Pfad | *_test.dart | test( | testWidgets( |
|---|---|---|---|---|
| burgstadt_core | packages/burgstadt_core | 19 | 163 | 0 |
| burgstadt_spiel | packages/burgstadt_spiel | 6 | 48 | 0 |
| mordakte_core | packages/mordakte_core | 31 | 316 | 0 |
| pixel_engine | packages/pixel_engine | 10 | 72 | 0 |
| room_host | packages/room_host | 1 | 5 | 0 |
| mordakte (Root-Paket) | test/ | 11 | 12 | 108 |
| ton_werkzeug | tool/ton | 1 | 8 | 0 |
| mordakte_server | server | 0 | 0 | 0 |

Summe Tests je Paket: 79 Testdateien, 624 `test(`, 108 `testWidgets(`.

Hinweise:
- Root-Paket: `test/` enthält 12 Dateien, davon 11 `*_test.dart`; `test/party_widgets/hilfe.dart` ist kein Test und ist nicht gezählt.
- `tool/ton/test/ton_test.dart` ist in der Tests-Tabelle (Paket ton_werkzeug) und zugleich in der Werkzeug-Tabelle (Pfad unter `tool/**`) gelistet. Die Summen beider Abschnitte sind getrennt zu lesen.
- Gegenprobe: `grep -rho` über alle `*_test.dart` ergibt 624 `test(` und 108 `testWidgets(`, stimmt mit der Summe überein.

## Werkzeuge

Quellen: `tool/**` mit Endung .sh, .dart, .mjs, .py (25 Dateien) und `packages/*/bin/*.dart` direkt in bin/ (37 Dateien). Zeilen per `wc -l`. Zweck = erste Kommentarzeile (bei .py mit Shebang: erste Docstring-Zeile).
Nicht gezählt (Regel `packages/*/bin/*.dart` buchstabengetreu): `packages/burgstadt_spiel/bin/mess/*.dart` (3 Dateien, 241 Zeilen).

| Pfad | Zeilen | Zweck |
|---|---|---|
| tool/abnahme.dart | 257 | Abnahme Z-01 … Z-14 (Nachtlauf „Burgstadt Schartenfels“) |
| tool/alle_tests.sh | 110 | Gesamt-Testlauf aller Ebenen (Nachtlauf); bricht beim ersten Fehler ab |
| tool/commit_gruen.sh | 21 | Commit nur bei grünem Gesamttest (schnell) |
| tool/e2e/e2e.mjs | 452 | E2E-Läufe des Partymodus gegen die gebaute Web-Fassung (F4-BAUMEISTER-07) |
| tool/e2e/foto.mjs | 45 | Bildschirmfotos der Partymodus-Vorschau; Konsolenfehler und Netzaufrufe außerhalb localhost |
| tool/e2e/laeufe.mjs | 52 | Laufliste des E2E-Gerüsts für den Partymodus (F4-BAUMEISTER-07) |
| tool/e2e/probe.mjs | 54 | Automatischer Partyabend mit Fotos an jeder Fotostelle (Probelauf F4-ORCH-01) |
| tool/e2e/raeume.mjs | 54 | Fotos aller Räume auf der Party-Karte (Sichtprüfung F-13) |
| tool/e2e/server.mjs | 23 | Kleiner statischer Server für die gebaute Web-Fassung (nur localhost) |
| tool/hd_abnahme.dart | 396 | Burgstadt HD · Abnahme HZ-01 … HZ-14 (Definition of Done) |
| tool/hd_commit.sh | 111 | Burgstadt HD: Commit nur bei grünem Schnelllauf und unveränderten Spieltexten |
| tool/hd_migbeleg.sh | 50 | Burgstadt HD: Migrationsbeleg (E-035), rendert festen Bildsatz |
| tool/layout_pruefsumme.dart | 76 | Layout-Prüfsumme für Burgstadt HD |
| tool/lib/figurenstand.dart | 66 | Figurenstand (Entscheidung E-039) für die HD-Abnahme |
| tool/mass5a.py | 56 | Bild-Näherung zum Maßstab 5a (E40) für Figurenpaare |
| tool/pruefen.sh | 60 | Gesamtprüfung des Repos (schnell, alles, e2e) |
| tool/quellabgleich.py | 288 | A-Einträge je Person (BRUCHLISTE Teil 3) |
| tool/secret_scan.sh | 51 | Secret-Scan vor jedem Push (Arbeitsstand und Git-Verlauf) |
| tool/ton/erzeuge.dart | 218 | Erzeugt alle Klänge und Musikstücke nach assets/burgstadt/ton/ (A-603a) |
| tool/ton/geraeusche.dart | 400 | Geräusche und Alltagsklänge (Schritte, Türen, Truhe, Rüstung, Papier, Oberfläche) |
| tool/ton/klangwerk.dart | 443 | Synthese-Bausteine für alle Klänge (A-603a) |
| tool/ton/musik.dart | 228 | Drei Musikstücke als Schleifen (je 60 s, 80 BPM, 20 Takte) |
| tool/ton/test/ton_test.dart | 148 | Abnahmetests für die Klangdateien (A-603a, Punkt 9) |
| tool/ton/umgebung.dart | 236 | Umgebungsklänge und Tierrufe |
| packages/burgstadt_core/bin/durchspiel.dart | 31 | Ebene 3/4: Durchspiel mit Bots für N = 4…20 |
| packages/burgstadt_core/bin/erkundung.dart | 45 | Erkundungsbots (A-307a) |
| packages/burgstadt_core/bin/fairness.dart | 56 | Fairness-Werkzeug (A-404a), N = 4…20 |
| packages/burgstadt_core/bin/kanon.dart | 99 | Kanon-Werkzeug, Dart-Gegenstück zu `90_werkzeug/kanon.py` |
| packages/burgstadt_core/bin/leitplanken.dart | 48 | Leitplanken-Scan (A-406) |
| packages/burgstadt_spiel/bin/banding.dart | 238 | Banding-Messung v2 (HZ-02, REP-02) |
| packages/burgstadt_spiel/bin/belegfotos.dart | 347 | Belegfotos; Schwellwert für Aufnahme aus der Schwarzblende |
| packages/burgstadt_spiel/bin/bereichsfotos.dart | 37 | Fotos jedes Bereichs (Ich-Sicht von einer Marke zur Raummitte) |
| packages/burgstadt_spiel/bin/bildschirmfoto.dart | 40 | Rendert Bildschirme headless als PNG in physischer Größe |
| packages/burgstadt_spiel/bin/eichbilder.dart | 381 | Eichbilder (P0-AUTOR-05, HZ-04): 18 Prüfbilder mit bekanntem Befund |
| packages/burgstadt_spiel/bin/flimmer.dart | 384 | Flimmerüberschuss v2 (REP-01, HZ-03) |
| packages/burgstadt_spiel/bin/kontaktbogen.dart | 296 | Kontaktbogen (P0-AUTOR-02, HZ-04/05/07): beschriftete Probebilder |
| packages/burgstadt_spiel/bin/leistung.dart | 170 | Ebene 7 (Z-09): Leistung auf der Dart-VM, hochgerechnet |
| packages/burgstadt_spiel/bin/messung.dart | 33 | Zeit je Spiel-Bild (ohne Bildausgabe) für Hauptmenü und Erkundung |
| packages/burgstadt_spiel/bin/spieltest.dart | 142 | Spielt den Fall headless über Eingaben durch |
| packages/burgstadt_spiel/bin/stadtfotos.dart | 54 | Ansichten der Oberstadt mit Paletten-/Blocktest und Bildzeit |
| packages/burgstadt_spiel/bin/stadtplan.dart | 38 | Stadtplan (Draufsicht) und Zahlen der generierten Oberstadt |
| packages/burgstadt_spiel/bin/szenen_mess.dart | 395 | Szenenmessung (P0-AUTOR-04, HZ-12): Bildkosten je Arbeitsschritt |
| packages/mordakte_core/bin/party_bibel.dart | 48 | Story-Bibel des Partymodus: schreibt oder prüft STORY-BIBEL.md |
| packages/mordakte_core/bin/party_druck.dart | 50 | Druckspiel des Partymodus als PDF-Satz (F5) |
| packages/mordakte_core/bin/party_prompts.dart | 51 | Erzeugt die Bildprompts des Partymodus (F3-BAUMEISTER-02) |
| packages/mordakte_core/bin/party_pruefen.dart | 49 | Plausibilitätsprüfer des Partymodus (F-04) |
| packages/mordakte_core/bin/party_simulate.dart | 60 | Erschöpfender Simulator für den Partymodus (F-06, F-07, F-08) |
| packages/mordakte_core/bin/party_texte.dart | 51 | Textprüfung des Partymodus gegen TON-LEITFADEN §4–§6 (F3-BAUMEISTER-01) |
| packages/mordakte_core/bin/simulate.dart | 84 | Lässt KI-Detektive ganze Fälle durchspielen (Balance-Check) |
| packages/mordakte_core/bin/validate.dart | 58 | Prüft Szenario-Dateien (JSON) |
| packages/pixel_engine/bin/aufstellung.dart | 53 | Figuren-Aufstellung (A-601b) aus karten.json |
| packages/pixel_engine/bin/benchmark.dart | 18 | Go/No-Go-Messung des Software-Rasterers |
| packages/pixel_engine/bin/bewohnerkarten.dart | 173 | Erzeugt die Figurenkarten der Stadtbewohner B01–B44 neu |
| packages/pixel_engine/bin/figurenprobe.dart | 56 | Figuren-Aufstellung als PNG (8 Richtungen + 4 Gehbilder) |
| packages/pixel_engine/bin/pixel_pruef.dart | 83 | Pixelprüfung (Ebene 5) für Bildschirmfotos aus dem Browser |
| packages/pixel_engine/bin/portraetprobe.dart | 55 | Porträt-Bogen (A-601c) |
| packages/pixel_engine/bin/schriftprobe.dart | 25 | Schriftprobe als PNG (×3 vergrößert) |
| packages/pixel_engine/bin/teile_kleidung_probe.dart | 69 | Kontaktbogen der Kleidungs- und Zubehörteile (A-108b) |
| packages/pixel_engine/bin/teile_koepfe_probe.dart | 90 | Kontaktbogen der Kopf-Teile (Frisuren, Bärte, Kopfbedeckungen) |
| packages/pixel_engine/bin/texturprobe.dart | 74 | Kontaktbogen aller Texturen als PNG (×2) |
| packages/pixel_engine/bin/web_bench.dart | 13 | Browser-Variante des Benchmarks (dart2js / wasm) |

Summen Werkzeuge: 62 Dateien (tool/** 25, packages/*/bin 37), Zeilen gesamt 7933 (tool/** 3939, packages/*/bin 3994).

## Summen

| Abschnitt | Dateien | Zeilen bzw. Zähler |
|---|---|---|
| Tests je Paket | 79 *_test.dart | 624 test(, 108 testWidgets( |
| Werkzeuge | 62 | 7933 Zeilen |

## Selbstprüfung

1. Summe Testdateien der Tabelle = 79 (19+6+31+10+1+11+1+0). OK
2. Summe test( der Tabelle = 624 = Gegenprobe grep -rho. OK
3. Summe testWidgets( der Tabelle = 108 = Gegenprobe grep -rho. OK
4. Werkzeug-Dateien in der Tabelle = 62 = Dateiliste (find). OK
5. Werkzeug-Zeilen: Tabellensumme 7933 = wc-Summe über dieselbe Liste 7933. OK

Ergebnis: 5/5.
