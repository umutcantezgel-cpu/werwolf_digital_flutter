# BESTAND und ARCHIVKARTE · Meta-Lauf BOLLWERK (M1)

Gezählt am Stand `origin/finalisierung-schlosskeller` = 5c8324298bd774f2c07e91ff2fb98bd1f909e3c7 (09.10.2026 21:12 UTC). Rohinventare mit jeder Fundstelle: `bestand/INV-01.md` (Routen, Bildschirme, Fälle, Modi), `bestand/INV-02.md` (95 Kanon-Dateien), `bestand/INV-03.md` (Tests, 62 Werkzeuge), `bestand/INV-04.md` (Assets, Druck, Renderer, 34 Requisitenarten). Faktenprüfung von Anhang B: `bestand/faktenpruefung/`.

„Archivieren“ heißt hier immer: an Ort und Stelle erhalten, hinter einem Schalter oder auf einem Archiv-Branch des Leitstands, nie löschen. Kanon 1.0 und Druckspiel bleiben unverändert; andere Fälle und Spiele laufen unverändert weiter.

## 1. Inventar mit Schicksal

| Nr | Teil | Fundstelle | Zahl | Schicksal | Grund |
|---|---|---|---|---|---|
| T01 | App-Start `/burgstadt` | lib/main.dart:78 | 1 | umbauen | BE-08: Start im Schlosskeller; `'burgstadt' => Routes.burgstadt` additiv, Schalter zurück bleibt |
| T02 | Router, 9 Routen | lib/app/router.dart:54–62 | 9 | übernehmen | Route `/party` trägt den Partymodus; neue Routen nur additiv |
| T03 | Hub und 6 Solo-Bildschirme | lib/ui/screens/** | 7 | übernehmen | klassische Fälle bleiben über das Menü erreichbar |
| T04 | Klassische Fälle blue_palm, nachtexpress, ravensmoor | content/scenarios/*.json | 3 | übernehmen (Nie-Pfad) | laufen unverändert weiter |
| T05 | Solo-Modi story/random/daily | lib/ui/screens/cases_screen.dart:306–308 | 3 | übernehmen | unverändert |
| T06 | Burgstadt (Modul, Pakete, Nachtlauf-Inhalte) | lib/burgstadt/**, packages/burgstadt_* | 11 Dateien + 2 Pakete | übernehmen (eingefroren) | Nie-Pfade; Burgstadt-Schutz |
| T07 | Partymodus Schlosskeller | lib/party/** (27 Dateien, 12 Bildschirme) | 27 | übernehmen und ausbauen (nach B-02) | Basis des Rundenspiels; Hoheit geht nach B-02 über |
| T08 | Spielkern Party | packages/mordakte_core/lib/src/party/** | – | übernehmen, nur importieren | Würfelschicht liegt in `…/src/runden/**` |
| T09 | Kanon 1.0 | content/party/schlosskeller/** (95 Dateien, 925.771 Byte) | 95 | übernehmen, bytegleich | L0.3 |
| T10 | Druckfassung (8 PDF) | packages/mordakte_core/bin/party_druck.dart; lib/src/party/druck/satz.dart:50–66 | 8 | übernehmen unverändert | BE-12 |
| T11 | Renderer Iso | lib/game/** (Maler, Licht, Nebel, SzenenErweiterung) | – | übernehmen; Erweiterungen nur additiv | Look-Vertrag |
| T12 | Requisitenmaler | lib/game/scene/prop_painter.dart | 34 Arten, 11 genutzt | übernehmen, ausbauen | Pflichtziel ≥ 30/34 |
| T13 | Joystick und Aktionsknopf | lib/game/input/*, sichtbar im Partymodus (Bildprobe) | 1 | archivieren hinter Schalter (Partymodus aus) | A-06 |
| T14 | Generische Ruhe-Bewegung | lib/game/mordakte_game.dart:1298; lib/party/karte_session.dart:300 | 1 | umbauen | 22 Kanon-Ruhe-Animationen einzeln (Pflichtziel 22/22) |
| T15 | Vorschau/Showcase | lib/game/dev/** | 3 | übernehmen, nie im Release | L0.6 |
| T16 | Online-Server | server/** | 1 Paket | übernehmen (Nie-Pfad) | unverändert |
| T17 | room_host | packages/room_host/** | 5 Tests | ausbauen nur ergänzend | WLAN über `RaumSpiel` |
| T18 | Tests | 79 Dateien, 624 `test(` + 108 `testWidgets(` | 732 | übernehmen; nie löschen oder abschwächen | Regression |
| T19 | Prüfwerkzeuge | tool/** 25 Dateien, packages/*/bin 37 Dateien | 62 | übernehmen; `abnahme.dart` und `commit_gruen.sh` nie ausführen | A4.8 |
| T20 | E2E Partymodus | tool/e2e/{e2e,raeume,foto,laeufe,probe,server}.mjs | 84 Läufe | übernehmen (Hoheit nach B-02) | Grundlage L7 |
| T21 | Assets | assets/burgstadt/ton (44 WAV), assets/fonts (4) | 49 | übernehmen (Nie-Pfad) | neue Klänge nur unter assets/runden/ |
| T22 | Tonerzeuger | tool/ton/** | – | übernehmen; nur neue Dateien | MP-6 |
| T23 | Krimidinner | krimidinner/** (128 Dateien) | 1 Linie | eingefroren | anderer Fall, nie vermischen |
| T24 | Nachtlauf-Belege | nachtlauf/** | – | eingefroren | Nie-Pfad |
| T25 | HD-Belege | hd/** | – | eingefroren | Nie-Pfad |
| T26 | Planung Finalisierung | planung/finalisierung-schlosskeller/** | – | nur lesen | Nie-Pfad |

## 2. Archivkarte der Linien

| Linie | Ref · SHA | Klasse | Art der Übernahme | Archiv-Branch (Leitstand) |
|---|---|---|---|---|
| main (Basis) | origin/main · 47611d8 | Basis | – | `archiv/vor-bollwerk` vor dem main-Push |
| Finalisierung | origin/finalisierung-schlosskeller · 5c83242 | läuft → Basis ab B-02 | kommt über origin/main (B-02) | nicht nötig (Vorfahr von main ab B-02) |
| FEINKORN | origin/kern-feinkorn · 1145cb9 | zusammenführen (nur Leben, V-21) | `git merge --no-ff 1145cb9` im Vorlauf | `archiv/feinkorn-1145cb9` falls Merge abgesagt |
| Burgstadt HD | origin/claude/pensive-gates-ajtp7x · Inhalt caf1d61 | zusammenführen nur nach V-14 | Merge erst bei `hd_migbeleg` „anders 0“ oder „A12: ja“; sonst zurückgestellt | `archiv/hd-caf1d61` |
| Nachtlauf Burgstadt | origin/nachtlauf/burgstadt = main | eingefroren | kommt über main | – |
| Krimidinner | krimidinner/** auf main | eingefroren | – | – |
| Jules-Optimierung | 41 × origin/loop/epoch-* | nur archivieren (schon Vorfahr) | – | nicht nötig |
| Krimidinner-Kanon-PR | origin/claude/ecstatic-cerf-7kzi1c · d92a675 | nur archivieren (gemergt) | – | nicht nötig |
| Kinder-Probe | origin/bollwerk-probe | nur archivieren | – | bleibt liegen |
| Meta-Archiv | planung/bollwerk/archiv/** auf pensive-gates | mitführen | Kopie mit Vermerk `aus <ref>@<sha>:<pfad>` | – |

Probe-Merges am 09.10. 21:40 UTC: main ← caf1d61, main ← 1145cb9, main ← fin, caf1d61 × 1145cb9: je Exit 0, 0 Konflikte (`git merge-tree --write-tree`).

## 3. Wiederverwertung (Kandidaten für Übernahme-Commits)

| Baustein | Quelle | Ziel im Spiel |
|---|---|---|
| Physikwelt 120 Hz, Partikel mit Ablagerung, Material- und Klangtabelle | 1145cb9:packages/pixel_engine (feinkorn.dart) | Würfelbühne, Seifenblasen, Staub (Leben) |
| Skelett/Gelenkgerüst (nur Konzept) | 1145cb9 | Posen im gezeichneten Stil |
| Bestandsprüfsumme, `messen.mjs` | 1145cb9:tool/feinkorn/ | L0.1, L8b |
| Sprechblasen-Layout (1.000 Lagen ohne Überlappung) | caf1d61:blasen_layout.dart | Gesprächsblasen im Rundenspiel |
| Thread-CPU-Messung | leistung.dart (CLOCK_THREAD_CPUTIME_ID) | L8a |
| `Optionen`/`PrefsOptionen`, `PrefsSpielstand` | lib/burgstadt/** | Optionen, Fortsetzen (Muster, keine Änderung) |
| `RaumHost`/`RaumClient` | packages/room_host | WLAN |
| E2E-Gerüst und Foto-Schema | tool/e2e/*.mjs | L7, Vorher/Nachher-Galerie |
| Würfel-Simulator der Meta-Probe | planung/bollwerk/proben/wuerfel_sim.py | Vorlage für `runden/`-Simulator in Dart |
