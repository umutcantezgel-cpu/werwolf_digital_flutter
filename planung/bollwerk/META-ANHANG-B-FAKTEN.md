# META-ANHANG B · Faktenlage (Stand 2026-10-09 ≈ 19:30 UTC – in M1 neu prüfen)

> Erfasst von 8 Lesern und 9 Gegenprüfern der Sitzung f7a52164, jeweils mit Pfad, Commit oder Befehl belegt.
> Alles hier ist **Ausgangsvermutung**. Der Meta-Lauf prüft es in M1 nach. Bei Abweichung gilt der neue Befund, der ins ENTSCHEIDUNGSLOG kommt.

Kürzel:
- `fin` = `origin/finalisierung-schlosskeller`
- `core` = `packages/mordakte_core`
- `K/` = `content/party/schlosskeller/`
- `P/` = `planung/finalisierung-schlosskeller/`

---

## B1 · Linien
Eine Linie ist ein Arbeitsstrang mit eigener Ref oder eigenem Ordner.

| Linie | Ref · SHA | Stand | Vorschlag Klasse |
|---|---|---|---|
| Veröffentlicht | `origin/main` e7e4219 (= `origin/nachtlauf/burgstadt`, = `claude/nifty-gauss-s82y27`) | Der Nachtlauf Burgstadt ist gemergt. Die App startet in `/burgstadt` (`lib/main.dart:73`, `_ => Routes.burgstadt`; einen Schlüssel `burgstadt` gibt es nicht). Der Schlosskeller ist nur über `lib/game/dev/preview_main.dart?party=schlosskeller` erreichbar. | Basis |
| Finalisierung Schlosskeller | `fin`, um 19:25 UTC bei **5b07e09**, **aktiv** | Letzte Commits: F4-ORCH-02 (Hub-Kachel „Partyabend“), F4-TEST-01/02 (Figurenkonsistenz, Karte pfadgleich), F5 (Druckgerüst, `party_druck`). Der Lauf ist auf mehrere Tage angelegt. STATUS meldete zuvor „F4 von F7 · Abnahme 9 von 17 · Aufträge 115 von 175“. Die Freigabe für main kommt in F7: Tag `schlosskeller-1.0` (F-17) oder der PR-Weg. | läuft – Startbedingung B-02 |
| Burgstadt HD | `origin/claude/pensive-gates-ajtp7x`. **Inhaltsstand caf1d61.** Die Spitze trägt nur BOLLWERK-Planungscommits (2eb8175, 6927582, Archiv-Commit) und wird **nie** gemergt. | Pausiert: 49 von 306 Paketen, HZ 0/14. 9 Commits gibt es nur hier (82b5b58 … caf1d61): Lichttabelle v2, HD-Texturen, Formen stuhl/bank/tisch v2, Sprechblasen-Layout mit `ui_test`, Anklage v2. Unfertiges liegt als Patch in `hd/wip/`. merge-base mit main: 96e9e5b. | zusammenführen (nur caf1d61) |
| FEINKORN | `origin/kern-feinkorn` 1145cb9 | Archiviert (E-F021: Nutzerentscheid „Bild-Look + Leben“). Die Bibliothek `package:pixel_engine/feinkorn.dart` hat 37 Tests. Messwerkzeuge in `tool/feinkorn/{bestand.dart,messen.mjs}`. Die Planung umfasst Messbasis, Szenenvertrag, Kanon-Auszug und Bildbestand. Rein additiv auf e7e4219. | zusammenführen (Leben) |
| Nachtlauf | `nachtlauf/` auf main | `belege/abnahme.txt` (Stand 2777e28): 12 von 14, offen sind Z-03 und Z-12. STATUS sagt veraltet „13 von 14“. | eingefroren |
| Krimidinner | `krimidinner/spuk-im-gewoelbe/` auf main | Anderer Fall (Täterin Merle, Burgwart Lüddecke). Welle 0, 0 von 204. `10_kanon/` ist App-Asset. | eingefroren |
| Jules-Optimierung | 41 × `origin/loop/epoch-*` (eine Linie) | Alle Vorfahren von main (Octopus-Merge 7b8dfa0 „ours“ und d92a675). Ihr Code wurde verworfen. | nur archivieren |
| Krimidinner-Kanon-PR | `origin/claude/ecstatic-cerf-7kzi1c` d92a675 | gemergt | nur archivieren |

**Nur im Container der Sitzung f7a52164 (eine neue Sitzung hat sie nicht):**
- lokaler `main` 7b8dfa0, veraltet und nie zu benutzen
- `hd-palette-v2` a389b3d, enthalten in pensive-gates
- Worktrees `/home/user/feinkorn` (= kern-feinkorn), `/home/user/wt/basis` (sauber) und `/home/user/wt/palette` (ungesicherter Diff, patch-id-gleich mit `hd/wip/P1-OPUS-07.patch`)

**Das Scratchpad dieser Sitzung ist gesichert** in `planung/bollwerk/archiv/scratchpad/` auf `origin/claude/pensive-gates-ajtp7x`, mit MANIFEST und sha256.
- Inhalt: 98 Dateien, unter anderem der Burgstadt-HD-Gesamtplan, 37 HD-Briefings, FEINKORN-Briefe und Rohmessungen, alle BOLLWERK-Bestandsnotizen und Gegenprüfer-Befunde.
- Nicht übernommen: Bilder (sie wurden im Chat gezeigt bzw. sind neu erzeugbar), Binärdateien und Probeordner.

**Probe-Merges** (`git merge-tree --write-tree`, ohne Arbeitsbaum):

| Merge in main | Konflikte | Löschungen | Umfang |
|---|---|---|---|
| ← caf1d61 | 0 | 0 | +167 Dateien |
| ← kern-feinkorn | Fast-forward | 0 | +52 Dateien |
| ← fin | Fast-forward | 0 | – |

Zwischen den Linien sind alle Schnittmengen geänderter Dateien leer. Die Party-Dateien von main (`bildprompts.dart`, `textpruefer.dart`) bleiben beim HD-Merge erhalten.

---

## B2 · Spielkern (reines Dart, `core/lib/src/party/`)

Der Spielkern ist schon **rundenbasiert**. Bis F4 war er in `lib/` nicht angeschlossen.

**Ablauf** (`ablauf.dart`)
- `Spiel` mit `PartyPhase` {titel, einrichtung, rollen, intro, gespraeche, entscheidungen, gruppenwahl, bonus, resuemee, anklage, finale, aufloesung, ende}.
- `einrichten(Einstellungen{rollen, detektiv m/w, code, druck, rundendauerMinuten 30})`, `weiter`, `optionen`.
- Optionen werden je Code gemischt: `Rng(code.seed ^ Rng.hashString(eid))`, Zeile 128.
- `waehle` → `List<Aufdeckung>`, `abstimmen`, `anklagen`. Falsche Aufrufe werfen `StateError`.

**Entscheidungen** (`entscheidungen.dart` + `K/entscheidungen.json`)
- 9 Detektiv-Entscheidungen (e1_1 … e3_3) in 3 Runden, je 2–3 Optionen.
- Optionen mit `ziel` {person|gegenstand|raum}.
- 30 Fakten, Regeln R-ENTLASTET und R-UEBERFUEHRT.
- Fakt-Typ `spaetankunft`, 3-mal (z. B. `f_spaet_ahmet`).

**Weitere Bausteine**
- `gruppenwahl.dart`: 60 Wahlen, Sabotage-Fassung. Wahr bei 5·kooperativ ≥ 3·Rollen.
- `K/bonus.json`: 36 Hinweise.
- `enden.dart`:
  - Meister 7–9 (richtige Anklage)
  - Teilerfolg 0–6 (richtige Anklage)
  - Justizirrtum 4–9 (falsche Anklage)
  - Eskalation 0–3 (falsche Anklage)
- `fall_code.dart`: 5 Zeichen, `seed = hashString('schlosskeller:'+code)`, der Pfad ist der erste Zug.
- `erzaehler.dart`: Bausteine. S-1: Vor dem Finale gibt es nur Detektivwissen.
- `tatmatrix.dart`: Pläne 23:50–00:15 mit `PlanSchritt` und `posAm(t)`.
- `raumgraph.dart`: `weg` (A*), `sichtlinie`, `lichtAm`, `karte` → `MapDef`.
- `szenario_export.dart`: `partySzenarioJson`, Palette Zeilen 22–40.

**Prüfen**
- `simulator.dart` + `core/bin/party_simulate.dart --pruefen`: erschöpfend 768 Folgen × 4 Pfade × 4 Anklagen in etwa 0,3 s.
- `core/test/party/determinismus_test.dart`: 1.000 Abende in etwa 1,2 s.
- Bei `fin` liegen 22 Testdateien in `core/test/party/` (228 Tests am F3-Tor).
- Zufälliges Raten bringt im Mittel 4,33 Punkte.

**Kanon** (`K/`, `kanonVersion` 1.0.0; neuester Stand auf `fin`)
- **Räume:** 7 Räume, 43 Orte, 8 Türen (6 quietschen), 53 Einrichtungen, 10 Lichtquellen, eine Ebene.
  - Der Raumgraph ist ein Baum mit dem Buffetsaal (`thekensaal`) als Knoten:
    - Buffetsaal – Vorratsraum
    - Buffetsaal – Durchgang – Kaminsaal (`west_saal`) – Turmgang
    - Buffetsaal – Ostsaal
    - Buffetsaal – Windfang
  - Die Wendeltreppe führt zum WC; der Zusatzweg ist 10 m lang und nicht auf der Karte.
- **Figuren und Spuren:** 4 Täterpfade (ahmet, fatma, olli, can), 20 Rollen in 5 Stufen, dazu der Detektiv (Geburtstagskind, `geburtstagsplatz` im Ostsaal) und Herr Schneider (sitzt mit Kühlpack `hinter_rechtem_buffet`). 28 Gegenstände, 36 Spuren, 33 Beobachtungen, 1.217 Texte, 16 Finaltexte.
- **„In den Keller“:**
  - `K/zeitleiste.json` z_ankunft (18:00, im_windfang): „Die Gäste kommen über die fünf Sandsteinstufen und das Außentor in den Keller.“
  - Außentor und Hoftür sind während der Ermittlung verschlossen; der Bund ist weg, Hinausgehen ist ausgeschlossen.
- **Zeit und Licht:**
  - Runden um 00:30, 01:15 und 02:00, Finale 02:45.
  - Zwischen den Runden liegen 45 Nachtminuten.
  - Strom ist ab 00:00 an, die Kerzen sind seit 23:58:40 aus. Der Detektiv hat ein Handy-Licht.
  - **Widerspruch:** Finalisierung `P/MASTER-PROMPT.md` §7.13 verlangt den Stromausfall-Look mit Nebel des Krieges:
    - 100 % schwarz außerhalb der Sicht
    - radiales Aufblenden in 0,4 s
    - Grundlicht 20–25 % blaugrau
    - warm #FF9329
    - 45°-Schatten
- **Tempo:** `wahrnehmung.json` gibt 1,0 m/s (dunkel), 1,5 m/s (hell) und 2,5 m/s (rennen) an.
- **Sichtbare Handlungen** laut Tatmatrix: gehen, rennen, Haltung (steht, sitzt, kauert, liegt), sprechen, Geräusch, Licht an/aus, Tür öffnen, riechen, fühlen. Dazu Gags an Rüstung und Kamin sowie Seifenblasen.
- **Ausgeschlossen:** Hinausgehen, die Notlaterne, den Kerzenständer nehmen, Gewalt spielbar zeigen.
- **Inventar:** 0 Treffer im Kanon.
- **Kennung ↔ Anzeigename:** leyla Lejla, johanna Joanna, murat Marek, meryem Hana, kaan Wojtek, dilara Azra, enes Damir, selin Sibel, hakan Pawel.

**Kanonregeln** (fall.json, STORY-BIBEL auf `fin`)
- **W-1 (Party):** Nur Entscheidungen des Detektivs schließen aus.
- **D-1:** Falsche Optionen zeigen nie den Schlüsselbeweis.
- **G-1:** Die Gruppenwahl bleibt geheim (dazu E-025).
- **K-1:** Objekte, Marker und Licht sind vor dem Finale in allen Pfaden gleich; der Bund ist nie ein Marker.
- **P-1:** Pflichtgespräche sind pfadneutral.
- **S-1:** siehe Erzähler oben.
- **F-06:** 9 richtige Antworten lassen genau einen Restverdächtigen übrig.
- **F-07:** Determinismus ×1000.
- **§7.7:** „Reines Raten gibt es nicht“; eine falsche Entscheidung deckt Wahres auf, nie Falsches.
- **Abnahme der Finalisierung F-01 … F-17** in `P/ABNAHME.md`, u. a.:
  - F-09 Besetzung 4–20
  - F-10 Druck und Bildschirm wortgleich
  - F-12 Fog, Licht und Rückblende nach §7.13
  - F-13 Farbabstand
  - F-14 Druckspiele gleich Simulator
  - F-16 0 Konsolenfehler und fremde Anfragen, LIZENZEN
  - F-17 Anleitung, Abschlussbericht, main und Tag

---

## B3 · Look und Renderer (`lib/game/**`)

**Aufbau**
- **Projektion:** `iso_math.dart` (64/32/40). Zeichenreihenfolge in `mordakte_game.dart:830–920`: Böden, Bodendekor, Tiefensortierung, Licht, nach Licht, Wetter, Overlays, Vignette.
- **Kamera:** folgt nur der eigenen Figur. Zoom 0,42–2,4 × 0,6–1,8.
- **Cutaway:** hängt an `_playerRoom`.
- **Böden** werden gebacken; Wände, Türen und Möbel liegen als `Picture` vor.
- **Licht:** `lighting.dart`. Tags dämpft eine Tönung (dayAmbient 0,62), nachts gibt es eine Dunkelschicht mit Taschenlampenkegel.
- **Vignette:** 0,38 am Tag, 0,62 nachts.

**Figuren**
- `FigurePainter.standing` mit Gehen in 6 Ansichten, dazu `lying` und die Schattenfigur. Proportionen nach Statur. Kanonfarbe = Mantelfarbe.
- **Es fehlen:** Posen (Tür, Untersuchen, Sitzen, Reden, Zeigen, Kauern), Ruhe-Animationen (die 22 `idleAnimation`-Texte in `K/figuren.json` sind nicht umgesetzt) und Mimik.

**Requisiten** (`prop_painter.dart`)
- 34 Arten, davon 11 genutzt. Umwidmungen: Wendeltreppe als Regal, Teekocher als Herd.
- **Auf Tischen stehen per Zufall grüne Flaschen (#2F4A35). Das verletzt die Inhaltsregel.**

**Datenlücken im Export**
- Der Detektiv ist rot (#b23a48) statt Kanon #B8A48A.
- Herr Schneider steht, statt zu sitzen.
- Hotspots und Items sind leer.
- Es gibt Reste der Vorlage `ravensmoor.json`.
- `playerSpeed` ist 3,2 Kacheln/s gegen 1–1,5 m/s im Kanon.
- Ein Türblatt haben nur L-Türen (2 von 8).

**Bedienung und Ton**
- **Overlays:** `markers.dart` (Zielring, Fortschrittsring, Namensschild, Zielbanner, Sprechblase). UI-Bausteine `TypewriterText`, `PaperCard`, `Stamp`. Schriften SpecialElite und Inter.
- **Steuerung heute:** Echtzeit-Joystick und Aktionsknopf (`lib/game/input/*`, `game_view.dart`; nicht abschaltbar).
- **Folgemodus:** Ohne Eingabe übernimmt der Client die Position der Sitzung (`mordakte_game.dart:482`).
- **Ton:** Das Iso-Spiel hat keinen. Synthese gibt es in `tool/ton` (44 WAV, deterministisch), Ausgabe über `Tonausgabe` (burgstadt_spiel). Haptik über `lib/ui/haptics.dart`.

**Referenz**
- **Referenzbild:** `origin/kern-feinkorn:planung/feinkorn/bilder/k0/vorher_buffetsaal.png`, 1280×720, Tagmodus, Buffetsaal. Es ist genau das Bild, das der Nutzer „gut“ fand.
- **Leistung** (Browser ohne GPU, `origin/kern-feinkorn:planung/feinkorn/MESSBASIS.md`):
  - Vorschau hoch 6–8 B/s, mittel 3–4 B/s, einfach 2–3 B/s
  - Last ≈ 1,0; „ruhig“ kostet so viel wie „bewegt“
  - Vorgebackene Bilder waren etwa 8× schneller (FEINKORN Weg A)

---

## B4 · Steuerung, Sitzung, Mehrspieler

**Sitzung**
- Naht `lib/session/game_session.dart` (`world`, `caseView`, `events`, `move`, `send`). Umsetzungen: `LocalSession`, `OnlineSession`, `FakeSession` und `ScenarioPreviewSession` (Vorlage, `send()` tut nichts).
- F4 plant `PartyKartenSession implements GameSession`.
- `core/lib/src/protocol/commands.dart` ist sealed (15 Befehle) und wird mit `server/` geteilt.

**Bausteine**
- Wegsuche: `core/lib/src/scenario/grid.dart:138–178` (`findPath`, A*), `RaumGraph.weg`.
- Mehrspieler: `packages/room_host` (`RaumSpiel`, `RaumHost` über `dart:io`, im Browser nur Gast).
  - lauscht auf `anyIPv4`
  - unverschlüsseltes WebSocket, 4-Zeichen-Code
  - Wiederverbinden per Token (`raum_host.dart:124–155`)
- Muster in Burgstadt:
  - `BurgstadtRaum`: Gastgeber = Detektiv, Bots für offene Rollen, `wahlFrist` 90 s
  - `FallBots.spieleDurch`
  - `Figur.auftrag`: Entscheidung → Auftrag → Bewegung
  - `PrefsSpielstand` (`lib/burgstadt/spielstand_prefs.dart`)
  - `Optionen` mit Tutorial und „Flackern aus“
- Hintergrund: `LocalSession.didChangeAppLifecycleState` (`lib/session/local_session.dart:90`).

**Plan der Finalisierung**
- F4 (`P/F4-ENTWURF-PARTYSITZUNG.md`):
  - `PartyKarte`, `PartySitzung extends ChangeNotifier`
  - optionale Renderer-Haken `NpcFilter.ansprechbar` und `RaumSicht.sichtbarkeit` über `session is …`
  - Route `/party`, Entwickler-Einstieg `?party=&code=&n=&skript=&dauer=`
  - Bestätigung „Das ist endgültig“
- Die Hub-Kachel ist seit 5b07e09 da.

---

## B5 · Hoheit
Solange der Finalisierungs-Lauf läuft, gilt diese Zuordnung (`P/PLAN.md`, `P/MASTER-PROMPT.md`).

| Pfadmuster | Eigentümer | Was BOLLWERK vor B-02 darf |
|---|---|---|
| `content/party/**` (`texte/` nur über Aufträge), `content/party/schema/**`, `textregeln.json` | Finalisierung | lesen |
| `core/lib/src/party/**`, `core/bin/party_*`, `core/test/party/**` | Finalisierung | importieren und ausführen |
| `lib/party/**`, `tool/e2e/**`, `docs/partykrimi/**`, `P/**` | Finalisierung | nicht anlegen |
| ORCH-Dateien: `pubspec.yaml`, `core/pubspec.yaml`, Barrel `core/lib/mordakte_core.dart`, `lib/l10n/app_de.arb`, `analysis_options.yaml`, `build.sh`, `lib/app/router.dart`, `lib/main.dart`, `lib/ui/screens/hub_screen.dart`, `.gitignore` | Orchestrator der Finalisierung | nicht ändern |
| `lib/game/dev/preview_main.dart`, `lib/game/scene/prop_painter.dart` | Bestand, Party-Teile der Finalisierung (E-016, F4-ORCH-06) | nur lesen |
| `lib/game/mordakte_game.dart` | Bestand; F4 plant Haken | nur lesen |
| main, Tag `schlosskeller-1.0` | Finalisierung (F7) | nie |
| `krimidinner/**`, `nachtlauf/**` | eingefroren | nie |
| Burgstadt-Pakete, `lib/burgstadt/**`, `tool/{abnahme.dart,alle_tests.sh,commit_gruen.sh,browser,ton,layout_pruefsumme.dart,hd_*}` | Nachtlauf / HD | nie (ausführen erlaubt außer `abnahme.dart`) |
| `content/scenarios/**`, `server/**`, Deploy-Dateien | Bestand Mordakte | nie |

**textPfade von Burgstadt** (nie ändern):
- `packages/burgstadt_core/data`
- `packages/burgstadt_spiel/data/texte`
- `packages/pixel_engine/data/figuren`
- `nachtlauf/kanon`
- `krimidinner/spuk-im-gewoelbe/10_kanon`

---

## B6 · Prüfwerkzeuge und Lücken

**Tests**
- 56 Testdateien auf main, nur in reinen Dart-Paketen. 0 Widget-Tests, 0 Golden-Bilder, kein Wurzel-`test/`, kein `flutter_test`.
- Letzter Volllauf `nachtlauf/belege/alle_tests_voll.txt` (Stand 2777e28): 817 bestanden, 1 übersprungen. Verteilung: core 214, pixel_engine 282, burgstadt_core 266, burgstadt_spiel 50, room_host 5; Server-Smoke 63 OK.

**Laufzeiten**
- `tool/alle_tests.sh [schnell]`: schnell 224–280 s, im sauberen Baum mit `hd_commit.sh` heute 3 min 49 s; voll 587–671 s.
- `alle_tests.sh` holt kein `pub get` für `tool/ton` und überspringt die Layout-Prüfsumme **still**, wenn `hd/belege/layout_ausgang.txt` fehlt.
- Ebene 9 des vollen Laufs öffnet die App über `tool/browser/geraete.js` mit `/?bsmess=1` bzw. `?bs=fall&bsmess=1` und **erwartet Burgstadt**. Danach prüft `pixel_pruef.dart` die Palette.

**Prüfskripte**
- `tool/pruefen.sh [schnell|alles|e2e]`:
  - setzt kein PATH und braucht `.werkzeug/env.sh` (fehlt)
  - `dart test` läuft nur für core
  - e2e ist kaputt, weil `tool/e2e/e2e.mjs` nie committet wurde
- `tool/secret_scan.sh`: Ohne `quellen/` (Rohchat) wird die Passagenprüfung übersprungen.
- `tool/hd_commit.sh`: sauberer Worktree, Pfadliste, Schnelllauf. Branch und Sitzung sind fest eingetragen.
- `tool/commit_gruen.sh`: `git add -A`, fest auf `nachtlauf/burgstadt`. **Nie benutzen.**
- `tool/abnahme.dart`:
  - startet `alle_tests.sh` voll und überschreibt `nachtlauf/belege/*`
  - Z-13 kennt nur feste Push-Ziele
  - **nie ausführen**, muss aber weiter analysieren
- `tool/hd_migbeleg.sh` (Bildsatz byte-gleich), `tool/layout_pruefsumme.dart --pruefe` (`--schreibe` verboten), `bin/erkundung.dart` (Türen 134/134).

**Foto und Messung**
- `tool/e2e/foto.mjs`:
  - nur 4 feste Ansichten in 1280×800, kein Bildvergleich
  - ESM-Import ohne `node_modules`, deshalb eine Kopie mit `createRequire('/opt/node22/lib/node_modules/playwright')` nehmen
  - `preview_main.dart` kennt `?phase=night` und `&at=x,y`
  - Ein Vorschau-Build dauerte 46,6 s
- `origin/kern-feinkorn:tool/feinkorn/bestand.dart` (Bestandsprüfsumme) und `messen.mjs` (Chromium mit CPU-Drossel 1×/4×/6×).

**Text- und Sichtprüfung**
- `core/lib/src/party/textpruefer.dart` und `core/bin/party_texte.dart` prüfen 1.217 Texte mit 0 Treffern. Die Regeln stehen in `content/party/textregeln.json`. Freie Varianten prüft es nicht; dafür `Textpruefer(regeln).pruefe(TextQuelle(...))` nutzen.
- `burgstadt_core/bin/leitplanken.dart` prüft `content/party` nicht mehr.
- Eichung der Sichtprüfer (`hd/eichung/AUSWERTUNG.md`): Haiku liegt bei 77,8–88,9 %, die Mehrheit von 3 bei 77,8 %.

**Bekannte Fallen**
- E28: `|| echo` verschluckt rote Tests.
- E31: Das Abnahmewerkzeug endete still.
- E36: Messungen unter Parallellast.
- E52: Vor jedem Web-Build `rm -rf .dart_tool/flutter_build`.
- Zeitabhängige Tests (`simulator_test` < 60 s, `fledermaeuse_test`, `karten_test`, `teile_kleidung_test`) werden unter Last rot.
- Es gibt kein CI (`.github` fehlt), keine CLAUDE.md und keine Tags.

---

## B7 · Wiederverwertbar

**FEINKORN** (`origin/kern-feinkorn`)
- `Physikwelt`: 120 Hz, deterministisch; kein Körper-gegen-Körper; Kontakt nur mit Boden und `Kasten`.
- `Starrkoerper`: `matrix()` liefert die Würfel-Oberseite. Die Kontaktpunkte liegen in der Mitte jedes zweiten Randblocks, sodass Ecken fehlen können.
- Partikel-Pool mit Ablagerung; web-sichere Prüfsumme.
- Materialtabelle (14 Materialien, Klang-Enum mit 8 Familien).
- `Skelett` (FK) und Figurenaufbau als Gelenkgerüst-Konzept für Posen.
- Speicherformat FKB1.
- `IsoAnsicht` (gleich `Iso`).
- Trennungsprüfung.
- Szenenvertrag: `GehtZu`, `Zustand`, `TuerAuf`, `Sicht`, `Angekommen` …
- Bildbestand mit Lückenliste, Kanon-Auszug mit 16 Lücken.
- **Keine Physik-Unit-Tests.**

**HD und Burgstadt**
- `hashTeil` (VM = Web, `packages/pixel_engine/lib/src/kit/werkzeug.dart`).
- Sprechblasen-Layout (`blasen_layout.dart`, nur auf caf1d61; 1.000 Lagen ohne Überlappung).
- Maße und Varianten der Formen.
- Eichbilder-Methode.
- Thread-CPU-Messung (`leistung.dart`, `CLOCK_THREAD_CPUTIME_ID`).
- `Optionen`/`PrefsOptionen`, `PrefsSpielstand`.

**Würfelgröße:** Ein echter Würfel wäre bei Standardzoom kleiner als ein Pixel. Er braucht deshalb eine eigene Bühne bzw. ein Overlay mit eigener Skala.

**Zufall:** Nur `core/lib/src/util/rng.dart` (mulberry32 + FNV-1a `hashString`) ist für Spiellogik zulässig.
- Es gibt keinen eigenen Unit-Test; VM = Web ist nur behauptet.
- Nicht verwenden:
  - `Zufall` (xorshift32; statischer Zähler hängt an der Layout-Prüfsumme)
  - `Lcg` (Golden-Bytes)
  - `_Zufall` (nicht web-sicher)
  - `FeinZufall`
  - `dart:math Random`

---

## B8 · Lehren aus den bisherigen Läufen

**Bewährt**
- Ein einziges Torwerkzeug meldet „ZIEL ERREICHT“; Belege sind an HEAD gebunden.
- Commits nur grün, mit Pfadliste, im sauberen Worktree.
- Maßstäbe stehen im Code statt in den Köpfen der Sichtprüfer; Sichtprüfer werden geeicht.
- Paketvertrag: ≤ 400 Zeilen + Test + Probe; höchstens 2 Nachbesserungen, dann Opus.
- Rollenbriefings mit den 3 häufigsten Fehlern.
- Doppelbau-Regel ★: Schlüsselstellen bauen 2–3 Haiku parallel.
- Abbruchregel für Prüfschleifen.
- PRÜFPUNKT, STATUS, NACHTPROTOKOLL stündlich mit `TZ=Europe/Berlin date`, MORGENBERICHT.
- Früh Bilder zeigen: FEINKORN wurde nach 1 Stunde korrigiert.
- Worktrees vor dem Löschen abgleichen.
- Kürzungsleiter statt stillem Absenken.
- Agentenverbot für Sitzungswerkzeuge: Sichtprüfer riefen `list_sessions` und `interrupt_session` auf (`hd/FEHLER.md`).

**Fehler**
- E28, E31, E36, E52 (siehe B6).
- Agenten schrieben in den Messbaum.
- Z-12 lief 27 Runden ohne Konvergenz; Gestaltungsfragen gehören sofort zum Nutzer.
- Handkorrekturen verschoben Fehler nur.
- Große Pläne wurden von Richtungswechseln überholt: FEINKORN schaffte 7 von 139, HD 49 von 306. Deshalb: **Durchstich zuerst.**

**Durchsatz**
- HD: 15–20 Haiku-Pakete je Stunde bei 4 Plätzen.
- Nachtlauf Burgstadt: etwa 10 h, 75 Commits, 53 Aufträge.

---

## B9 · Umgebung, Kapazität, Berechtigungen

**Maschine**
- 4 Kerne, etwa 16 GB RAM, keine GPU, kein Android-SDK, kein Xcode.
- Platte: 25 GB frei (gemessen).
- Worktree-Größen: nackt 46 MB, mit `pub get` 295 MB, mit Web-Build bis 524 MB.
- Agentenprotokolle in `/tmp/claude-0` belegen bereits 598 MB.

**Werkzeuge:** Flutter 3.47.6 liegt unter `/opt/flutter/bin` (nicht auf PATH; der Shell-Zustand bleibt zwischen Aufrufen nicht erhalten). Node 22 unter `/opt/node22` mit globalem Playwright 1.56.1, Chromium unter `/opt/pw-browsers/chromium-1194`. `flock` ist vorhanden.

**Agenten**
- Ein Workflow lässt höchstens min(16, Kerne − 2) = **2** Agenten gleichzeitig laufen, über die Lebensdauer höchstens 1.000.
- Workflow-Skripte haben keine Uhr (`Date.now()` wirft). `budget.total` ist ohne „+Nk“-Vorgabe null.
- Direkte Hintergrund-Agenten liefen gleichzeitig: am 2026-10-09 erst 8, dann 9, je 8–19 min und 150–345 Tsd. Tokens.
- `claude-haiku-5-5` ist das Standard-Haiku. „Dynamic workflow size“ hat die Stufen small, medium, large und unrestricted.
- `send_later` feuert **einmal**. `create_trigger` kann stündlich in diese Sitzung feuern.

**Berechtigungen** (Plattform-Doku)
- In Cloud-Sitzungen wählt der Nutzer den Modus im Menü neben dem Eingabefeld: Accept edits, Plan oder **Auto**.
- **Auto** führt die meisten Werkzeugaufrufe ohne Nachfrage aus, sofern Organisation und Modell es erlauben.
- „Bypass“ wird nicht angeboten; `bypassPermissions` und `dontAsk` in den Einstellungen werden ignoriert.
- Alternativ: Freigaberegeln in `.claude/settings.json` des Repos (`permissions.allow`), committet. Das entscheidet nur der Nutzer.
- **Eine neue Sitzung startet auf einer frischen Maschine.**

**Deploy:** `netlify.toml` und `vercel.json` bauen über `build.sh`; `railway.toml` baut den Server. Ein Push auf main kann ausliefern; ob die Dienste angebunden sind, ist unbekannt.

---

## B10 · Umfang heute (vorläufig; verbindlich zählt der Nachtlauf in B0 am B-02-Stand)

| Achse | Heute | Art |
|---|---|---|
| Spielbare Spielformen | 0 (F4 baut die erste) | Ziel 3/3 |
| Wertende Entscheidungen | 9 | Wachstum |
| Folgeentscheidungen und Ketten | 0 | Ziel |
| Sichtbare Aktionsarten mit Animation | 1 (gehen) | Wachstum ab Anker |
| Posen und Gesten | 0 | Ziel |
| Ruhe-Animationen | 0 von 22 | Ziel 22/22 |
| Würfeltabellen und Würfelereignisse | 0 | Ziel |
| Räume / Orte | 7 / 43 | Wachstum |
| Genutzte Requisitenarten | 11 von 34 | Wachstum |
| Texte und Bausteine | 1.217 | Wachstum |
| Gags und Nebenhandlungen | 3 | Wachstum |
| Leben-Effekte | 0 | Ziel |
| Unterscheidbare Partieverläufe | 768 × 4 × Codes | nur Matrix, nicht im Index |
| Tests | 228 / 817 | nur Matrix, nicht im Index |
