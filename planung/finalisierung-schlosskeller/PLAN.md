# PLAN · alle Aufträge bis F7

**Kennungen:** F<Phase>-<ROLLE>-<Nr>. Rollen:
- ORCH (Orchestrator, Stufe 3)
- KUNDSCHAFTER, BAUMEISTER, AUTOR, KONT (Kontinuitätsprüfer), SENS (Sensibilitätsleser), TEST (Testschreiber), FALL (Fallrechner), SPIEL (Spieltester), SICHT (Sichtprüfer), DRUCK (Druckprüfer), GEGEN (Gegenprüfer), DOKU (Dokumentar)

**Status:** offen · läuft · abgenommen · nachbessern · übernommen (ORCH) · verworfen.

**Dateihoheit:** Gleichzeitige Aufträge berühren nie dieselbe Datei. Gemeinsame Werte schreibt nur ORCH:
- Raumgraph
- Tatmatrix
- Indizien
- Entscheidungs- und Endenmodell
- Schwellen
- Schlüssel der Textsammlung

**Orte:** Kanon `content/party/schlosskeller/` · Logik `packages/mordakte_core/lib/src/party/` · Tests `packages/mordakte_core/test/party/` · UI `lib/party/` · E2E `tool/e2e/`.

**Eigentümer geteilter Dateien (nur ORCH ändert):** `pubspec.yaml`, `packages/mordakte_core/pubspec.yaml`, `packages/mordakte_core/lib/mordakte_core.dart` (Barrel), `lib/l10n/app_de.arb`, `analysis_options.yaml`, `build.sh`, `lib/app/router.dart`, `lib/main.dart`, `lib/ui/screens/hub_screen.dart`, `.gitignore`, alle Kanon-Dateien außer `texte/*.json`. Party-UI-Texte stehen in `texte/ui.json` (Kanon), nicht in ARB.

**Isolation (E-013):** Baumeister, die Code ändern oder bauen, laufen mit `isolation: worktree`. ORCH übernimmt das Ergebnis per Diff. Commits nur mit expliziter Pfadliste, nie `git add -A`. Web-Builds je Lauf mit eigenem `-o`-Verzeichnis.

**Regeln aus der Plan-Schleife (E-013):**
- W-1: Ein wahrer Bonus-Hinweis entlastet nie allein.
- S-1: Resümees nur aus dem Wissen des Detektivs; bei Restmenge 1 kein Name.
- D-1: 0-Punkt-Optionen zeigen keinen Schlüsselbeweis und kein Zusatzindiz.
- G-1: Sabotage der Täterrolle zählt netto −1, sichtbar ist nur die Qualität.
- Karte vor dem Finale in allen Pfaden gleich.
- Pflichtgespräche geben nur pfadneutrales Wissen preis.
- W-1 scharf (E-014): Bonus-Hinweise schließen niemanden aus; Ausschlüsse nur aus Detektiv-Entscheidungen.
- Neuprüfung (E-014): Jede Kanon-Änderung nach F3 löst Textlint und KONT-Prüfung der betroffenen Texte aus.
- Prüfaufträge mit Längengrenze und `effort: high`; breite Aufträge teilen (E-017).

## F0 – Bestandsaufnahme und Gesamtplan
| Kennung | Rolle | Gegenstand | Eigene Dateien | Abhängig | Status |
|---|---|---|---|---|---|
| F0-ORCH-01 | ORCH | Branch, .gitignore, Quelldatei, Werkzeugkette, Messbasis | `.gitignore`, `.werkzeug/` | – | abgenommen |
| F0-KUNDSCHAFTER-01 | Kundschafter | Renderer-Bausteine für den Partymodus | – (Bericht) | – | abgenommen |
| F0-KUNDSCHAFTER-02 | Kundschafter | Web-Start, Netzquellen, Testbestand, Browser-Schnittstellen | – (Bericht) | – | abgenommen |
| F0-KONT-01 | KONT | Figurenabgleich Detektiv, Schneider, Rollen 1–10 | – (Bericht) | – | abgenommen (Bericht aus Verlauf wiederhergestellt, L-01) |
| F0-KONT-02 | KONT | Figurenabgleich Rollen 11–20, Räume, Uhrzeiten | – (Bericht) | – | abgenommen |
| F0-ORCH-02 | ORCH | Planungsordner, BESTAND, BRUCHLISTE Teil 3 | `planung/finalisierung-schlosskeller/*` | Kundschaft | abgenommen |
| F0-GEGEN-01 | GEGEN | Plan angreifen: Lösbarkeit, Spoiler, Fair Play | – (Bericht) | F0-ORCH-02 | abgenommen (17 Befunde, E-013) |
| F0-GEGEN-02 | GEGEN | Plan angreifen: Machbarkeit, Dateihoheit, Reihenfolge, Werkzeug | – (Bericht) | F0-ORCH-02 | abgenommen (16 Befunde, E-013) |
| F0-GEGEN-03 | GEGEN | Runde 2: Sind die Befunde aus Runde 1 im Plan gelöst? Neue Lücken? | – (Bericht) | E-013 | abgenommen (03a/03b nach Neustart, E-014, E-017) |
| F0-ORCH-04 | ORCH | Werkzeug und Konfiguration: `tool/pruefen.sh` (pub get zuerst, analyze, Tests, Web-Build ohne CDN), `tool/secret_scan.sh`, `build.sh` mit `--no-web-resources-cdn` | `tool/pruefen.sh`, `tool/secret_scan.sh`, `build.sh` | F0-ORCH-02 | abgenommen (Secret-Scan Stufe 4 seit E-014) |
| F0-ORCH-03 | ORCH | Plan-Schleife (≤ 3 Runden), festschreiben, Tor-Commit, Probe-Push | Planungsordner | GEGEN, F0-ORCH-04 | abgenommen (2 Runden, Tor-Commit, Push 918cb38 und folgende) |

## F1 – Kanon und Tatmatrix (Tor F-01 bis F-05)
| Kennung | Rolle | Gegenstand | Eigene Dateien | Abhängig | Status |
|---|---|---|---|---|---|
| F1-ORCH-01 | ORCH | Raumkanon und Raumgraph (Maße, Türen, Licht, Luftzug, Geräuschwege) | `raeume.json`, `party/raumgraph.dart` | F0 | abgenommen (Raumgraph, 43 Orte, Licht, Luftzug; E-015) |
| F1-ORCH-02 | ORCH | Kanon-Schema, Loader, Validator, Verweisprüfung | `content/party/schema/*`, `party/kanon/*` | F1-ORCH-01 | abgenommen (Schemas für 10 Dateien, Lader, Verweise inkl. alter Namen) |
| F1-ORCH-03 | ORCH | Brüche B-01..B-17, V-01..V-32, A-xx entscheiden | BRUCHLISTE, ENTSCHEIDUNGSLOG | F1-ORCH-01 | abgenommen (82 Brüche entschieden, E-019) |
| F1-ORCH-04 | ORCH | Figuren-Übernahme (JSON-Feldnamen behalten), Herkunft und Namensbalance (E-007), Farbpalette (B-10) | `figuren.json`, `besetzung.json` | F1-ORCH-03 | abgenommen (figuren, besetzung; E-020) |
| F1-ORCH-05 | ORCH | Gegenstände und Indizien je Pfad, Setting, gemeinsame Zeitleiste | `gegenstaende.json`, `setting.json`, `zeitleiste.json` | F1-ORCH-03 | abgenommen (gegenstaende, setting, zeitleiste) |
| F1-ORCH-06 | ORCH | Tatmatrix Ahmet, Fatma, Olli, Can (23:55–0:05, 15 s) | `tatmatrix/*.json` | F1-ORCH-05 | abgenommen (Pläne je Pfad, 0 Verstöße) |
| F1-ORCH-07 | ORCH | Wahrnehmungsregeln, Beobachtungen, Plausibilitätsprüfer | `wahrnehmung.json`, `beobachtungen.json`, `party/tatmatrix.dart`, `party/wahrnehmung.dart`, `party/plausibilitaet.dart` | F1-ORCH-06 | abgenommen (Regeln, 30 Beobachtungen, Prüfer; E-015) |
| F1-ORCH-08 | ORCH | Quellabgleich-Liste (jedes Quellelement → Kanon oder verworfen) | `quellabgleich.json` | F1-ORCH-04..07 | abgenommen (542 Einträge, tool/quellabgleich.py) |
| F1-ORCH-10 | ORCH | Besetzungsreihenfolge 4–20 (Geschlechterwechsel je Platz, Stufen als Ordnung) | `besetzung.json` | F1-ORCH-04 | abgenommen (besetzung.json, Bilanz ≤ 1 ab 5 Rollen) |
| F1-ORCH-11 | ORCH | Spike: Karte aus dem Raumgraph über eine Party-Sitzung im vorhandenen Renderer, eine Figur, Licht, Playwright-Probelauf mit Netzprüfung, PDF-Probeseite | `lib/party/spike/*` (wird in F4 ersetzt oder übernommen) | F1-ORCH-01 | abgenommen (Karte im Renderer, Playwright 0/0; PDF-Probe offen; E-016) |
| F1-TEST-03 | TEST | Farbabstand ΔE2000 je Startraum (≥ 10) und Beweisfarbe (≥ 20) | `test/party/farbabstand_test.dart` | F1-ORCH-04 | abgenommen (10/10, E-018) |
| F1-BAUMEISTER-01 | Baumeister | Story-Bibel-Generator (CLI + Aktualitätstest) | `bin/party_bibel.dart`, `party/bibel.dart`, `test/party/story_bibel_test.dart` | F1-ORCH-02 | abgenommen (9/10, E-018) |
| F1-TEST-01 | TEST | Tests Schema, Verweise, Räume (F-01, F-03) | `test/party/kanon_schema_test.dart`, `raum_test.dart` | F1-ORCH-02 | übernommen (ORCH: kanon_schema_test) |
| F1-TEST-02 | TEST | Tests Plausibilität und Beweise (F-04, F-05), Figurenabgleich (F-02) | `test/party/plausibilitaet_test.dart`, `beweise_test.dart`, `figuren_abgleich_test.dart` | F1-ORCH-07 | übernommen (ORCH: plausibilitaet_test, beweise_test, figuren_abgleich_test) |
| F1-KONT-01..04 | KONT | je ein Pfad: Tatmatrix, Beobachtungen, Indizien gegen Zeitleiste und Raumgraph | – (Bericht) | F1-ORCH-07 | offen |
| F1-GEGEN-01 | GEGEN | Körperlichkeit und Exklusivität der Schlüsselbeweise (F-05) | – (Bericht) | F1-ORCH-07 | offen |
| F1-SENS-01 | SENS | Cast, Herkunftsmatrix, Kopftuch, Motive, Etiketten, Namensklang | – (Bericht) | F1-ORCH-04 | offen |
| F1-ORCH-09 | ORCH | Befunde einarbeiten, Tor F-01..F-05, Commit, Push | Kanon | alle F1 | offen |

## F2 – Mechanik und Simulation (Tor F-07; F-06, F-08 mit Platzhaltern)
| Kennung | Rolle | Gegenstand | Eigene Dateien | Abhängig | Status |
|---|---|---|---|---|---|
| F2-ORCH-01 | ORCH | Entscheidungsmodell: 9 Handlungen, Optionen, Wertung je Pfad, Begründungsketten | `entscheidungen.json`, `party/entscheidungen.dart` | F1 | offen |
| F2-ORCH-02 | ORCH | Gruppenwahl, Dilemmata (Struktur), Schwellen, Bonus-Wirkungen (36), Kanon-Feld `sabotage` je Kernrolle (E-014) | `gruppenwahl.json`, `bonus.json`, `party/gruppenwahl.dart` | F2-ORCH-01 | offen |
| F2-ORCH-03 | ORCH | Restverdächtige, Endmatrix, Fall-Code, Ablauf-Zustandsautomat, Erzähler-Bausteinwahl | `party/restverdaechtige.dart`, `enden.dart`, `fall_code.dart`, `ablauf.dart`, `erzaehler.dart`, `enden.json`, `erzaehler.json` | F2-ORCH-02 | offen |
| F2-ORCH-04 | ORCH | Simulator-Kern (erschöpfend, faktorisiert) und CLI | `party/simulator.dart`, `bin/party_simulate.dart` | F2-ORCH-03 | offen |
| F2-TEST-01 | TEST | Schwellen 4–20 (Grenzwerte), Gruppenwahl-Struktur | `test/party/gruppenwahl_test.dart` | F2-ORCH-02 | offen |
| F2-TEST-02 | TEST | Enden-Matrix, Determinismus ×1000 | `test/party/enden_test.dart`, `determinismus_test.dart` | F2-ORCH-03 | offen |
| F2-TEST-03 | TEST | Simulator-Kriterien F-06 als Test (inkl. „0 richtige, 3 wahre Hinweise → ≥ 2“, Rate-Enden getrennt, D-1) | `test/party/simulator_test.dart` | F2-ORCH-04 | offen |
| F2-ORCH-06 | ORCH | Ersatzpartner-Tabelle und Begründungsketten je Personenzahl 4–20 (vorgezogener Teil von F-09) | `besetzung.json`, `party/besetzung.dart` | F2-ORCH-01 | offen |
| F2-TEST-04 | TEST | Gruppenwahl-Dominanz: jede Option mit Kosten/Nutzen, jeder der 36 Hinweise erreichbar, Sabotage −1 | `test/party/gruppenwahl_dilemma_test.dart` | F2-ORCH-02 | offen |
| F2-FALL-01 | FALL | Simulator fahren: Verteilungen je Pfad, Abkürzungen, Schwierigkeit | – (Bericht) | F2-ORCH-04 | offen |
| F2-GEGEN-01 | GEGEN | Modell angreifen: Abkürzungen, Spoiler, Täterwahl erkennbar, Raten | – (Bericht) | F2-ORCH-04 | offen |
| F2-ORCH-05 | ORCH | Befunde einarbeiten, Tor, Commit, Push | – | alle F2 | offen |

## F3 – Inhalte (Tor F-06 mit Texten, F-08, F-10, F-11, F-15)
Autoren schreiben nur in `content/party/schlosskeller/texte/<datei>.json` mit den von ORCH vorgegebenen Schlüsseln. Jeder Stapel durchläuft den Textprüfer, dann KONT und SENS.

| Kennung | Rolle | Gegenstand | Eigene Dateien | Abhängig | Status |
|---|---|---|---|---|---|
| F3-ORCH-00 | ORCH | Schlüsselschema der Textsammlung (alle Schlüssel mit Zweck, Länge, Sichtbarkeit vor/nach Finale) und leere Textdateien je Autor | `texte/*.json` (Gerüst), `texte/SCHLUESSEL.md` | F2 | offen |
| F3-BAUMEISTER-01 | Baumeister | Textprüfer (Satzlängen, Fachwort-, Alkohol-, Drogen-, Rauchliste, Ziffern im Vorlesetext) und Textlint (Uhrzeiten, Orte, Gegenstände gegen Kanon) | `party/textpruefer.dart`, `test/party/textpruefer_test.dart`, `test/party/textlint_test.dart` | F3-ORCH-00 | offen |
| F3-AUTOR-01..05 | Autor | Dossiers „wer ich bin / was ich weiß / was ich verberge / mein Ziel“ je Viererblock (Rollen 1–4, 5–8, 9–12, 13–16, 17–20) | `texte/dossier-blockN.json` | F3-BAUMEISTER-01 | offen |
| F3-AUTOR-06..09 | Autor | Täterfassungen Ahmet, Fatma, Olli, Can (Tarngeschichte, Tatwissen) | `texte/taeter-<name>.json` | F3-AUTOR-01 | offen |
| F3-AUTOR-10 | Autor | Detektiv-Bogen m und w | `texte/detektiv.json` | F2 | offen |
| F3-AUTOR-11..25 | Autor | Pflichtgespräche je Runde und Viererblock (5 Blöcke × 3 Runden) | `texte/gespraeche-rR-blockN.json` | F3-AUTOR-01..05 | offen |
| F3-AUTOR-26..29 | Autor | Rundenwahl-Texte der Blöcke 2–5 (Kernblock nur über Dilemma-Dateien) | `texte/wahl-blockN.json` | F3-AUTOR-01..05 | offen |
| F3-AUTOR-31..33 | Autor | Bonus-Hinweise je Runde (4 Pfade × 3 Qualitäten) | `texte/bonus-rR.json` | F2 | offen |
| F3-AUTOR-34..35 | Autor | Indiztexte (Fundtexte, Ergebnistexte der Detektiv-Entscheidungen) | `texte/indizien.json`, `texte/entscheidungen.json` | F2 | offen |
| F3-AUTOR-36..38 | Autor | Intro, 3 Varianten (Varianten-Regel) | `texte/intro-vN.json` | F2 | offen |
| F3-AUTOR-39..41 | Autor | Resümee-Fächer je Runde | `texte/resuemee-rR.json` | F2 | offen |
| F3-AUTOR-42 | Autor | Anklage und Eingrenzung | `texte/anklage.json` | F2 | offen |
| F3-AUTOR-43..46 | Autor | 4 Finaltexte je Pfad (16) und Rückblende je Pfad (4) | `texte/finale-<pfad>.json` | F2 | offen |
| F3-AUTOR-47..48 | Autor | Auflösung je Rolle (20) | `texte/aufloesung-1.json`, `-2.json` | F3-AUTOR-01..05 | offen |
| F3-AUTOR-49..56 | Autor | Varianten-Regel: 4 Schlüsselbeweise (je 2 Autoren) | `texte/beweis-<pfad>-vN.json` | F2 | offen |
| F3-AUTOR-57..64 | Autor | Varianten-Regel: Gruppenwahl-Dilemmata der 4 Kernrollen (je 2 Autoren) | `texte/dilemma-<name>-vN.json` | F3-AUTOR-01, F3-AUTOR-06..09 | offen |
| F3-BAUMEISTER-02 | Baumeister | Bildprompt-Generator aus Kanon-Feldern + Test | `party/bildprompts.dart`, `bin/party_prompts.dart`, `bildprompts.json`, `test/party/bildprompt_test.dart` | F1 | offen |
| F3-KONT-01..10 | KONT | Stapelprüfung gegen Kanon und Tatmatrix | – (Bericht) | Autoren | offen |
| F3-SENS-01..05 | SENS | Stapelprüfung Ton, Inhalt, Klischee, Namensbalance | – (Bericht) | Autoren | offen |
| F3-TEST-01 | TEST | Dossier-, Erzähler-, Spoiler-Tests (F-10, F-11; Spoiler über alle Bausteine vor dem Finale × 4 Pfade, S-1) | `test/party/dossier_test.dart`, `erzaehler_test.dart`, `spoiler_test.dart` | F3-AUTOR-* | offen |
| F3-ORCH-01 | ORCH | Variantenwahl, Integration, Tor, Commit, Push | Textsammlung | alle F3 | offen |

## F4 – Spiel und Bild (Tor F-12, F-13)
| Kennung | Rolle | Gegenstand | Eigene Dateien | Abhängig | Status |
|---|---|---|---|---|---|
| F4-ORCH-01 | ORCH | PartyGame-Kern: Karte aus Raumgraph, Figuren, Indizien je Pfad, Interaktionen, Licht/Fog/Stromausfall, Taschenlampe | `lib/party/spiel/*` | F2 | offen |
| F4-ORCH-02 | ORCH | Party-Sitzung (Zustand, Spoilerschutz), Router, Dev-Einstieg `?party=`, `?semantik=1`; Hub-Kachel als letzter F4-Schritt nach dem Holen von origin | `lib/party/sitzung.dart`, `lib/app/router.dart`, `lib/main.dart`, Hub-Kachel | F4-ORCH-01 | offen |
| F4-BAUMEISTER-01 | Baumeister | Einrichtung (Personenzahl, Namen, Detektiv-Geschlecht, Fall-Code/Zufall, Bildschirm/Druck, Rundendauer) | `lib/party/bildschirme/einrichtung.dart` | F4-ORCH-02 | offen |
| F4-BAUMEISTER-02 | Baumeister | Verdeckte Rollenvergabe und Dossieransicht | `lib/party/bildschirme/rollen.dart` | F4-ORCH-02 | offen |
| F4-BAUMEISTER-03 | Baumeister | Rundenzentrale mit Uhr, Pflichtgesprächs-Übersicht | `lib/party/bildschirme/runde.dart` | F4-ORCH-02 | offen |
| F4-BAUMEISTER-04 | Baumeister | Gruppenwahl reihum verdeckt | `lib/party/bildschirme/gruppenwahl.dart` | F4-ORCH-02 | offen |
| F4-BAUMEISTER-05 | Baumeister | Erzählerfeld mit lokaler Stimme (abschaltbar, Wortgleich-Prüfung) | `lib/party/erzaehler_ausgabe.dart`, `lib/party/stimme_web.dart`, `stimme_stub.dart` | F4-ORCH-02 | offen |
| F4-BAUMEISTER-06 | Baumeister | Anklage, Finale mit Rückblende-Steuerung, Auflösung für alle | `lib/party/bildschirme/anklage.dart`, `finale.dart`, `aufloesung.dart` | F4-ORCH-02 | offen |
| F4-BAUMEISTER-07 | Baumeister | E2E-Gerüst (playwright@1.56.1, `PLAYWRIGHT_BROWSERS_PATH`, Netz- und Konsolenprüfung, Fotos, verkürzte Rundendauer per Dev-Parameter) | `tool/e2e/*` | F4-ORCH-02 | offen |
| F4-BAUMEISTER-08 | Baumeister | Titel-, Intro- (mit Lacher-Rückblicken) und Resümee-Bildschirm | `lib/party/bildschirme/titel.dart`, `intro.dart`, `resuemee.dart` | F4-ORCH-02 | offen |
| F4-BAUMEISTER-09 | Baumeister | NPC-Karte (Befragung unbesetzter Gäste) | `lib/party/bildschirme/npc_karte.dart` | F4-ORCH-02 | offen |
| F4-ORCH-06 | ORCH | Party-Tafel und Möbel im Renderer: Tische ohne Flaschen und Messingleuchter (Teekanne, Tassen, Karaffe, elektrische Teelichter), Teekocher, Kaffeemaschine, Wendeltreppe, Detektiv-Look (E-016) | `lib/game/scene/prop_painter.dart` (optional, nur Partymodus) | F1-ORCH-11 | offen |
| F4-ORCH-05 | ORCH | Spielleitung: Täter für Testläufe festlegen; Pfeife mit Seifenblasen; Gags an Rüstung und Kamin | `lib/party/spiel/*` | F4-ORCH-01 | offen |
| F4-ORCH-03 | ORCH | Rückblende (Zeitraffer der Tatmatrix), Ruhe-Animationen, Integration; Rückblende-Schnittstelle schon mit F4-ORCH-01 festgelegt | `lib/party/spiel/rueckblende.dart` | F4-BAUMEISTER-* | offen |
| F4-TEST-02 | TEST | Karte vor dem Finale pfadgleich (Objektliste, Marker, Licht) und Widget-Tests je Bildschirm | `test/party/karte_pfadgleich_test.dart`, `test/party_widgets/*` | F4-ORCH-01 | offen |
| F4-SPIEL-01..03 | SPIEL | Durchläufe Pfade × Enden × {4, 7, 12, 16, 20}, Fotos, Befunde | – (Bericht) | F4-ORCH-03 | offen |
| F4-SICHT-01..02 | SICHT | Fotos gegen Bild-Checkliste (Erkennbarkeit, Fog, Licht, Indizien-Orte) | – (Bericht) | F4-SPIEL | offen |
| F4-TEST-01 | TEST | Figurenkonsistenz Spiel/Dossier/Bildprompt (F-13) | `test/party/figuren_konsistenz_test.dart` | F1 | offen |
| F4-ORCH-04 | ORCH | Befunde einarbeiten, Tor, Commit, Push | – | alle F4 | offen |

## F5 – Druck und Besetzung (Tor F-09, F-14)
| Kennung | Rolle | Gegenstand | Eigene Dateien | Abhängig | Status |
|---|---|---|---|---|---|
| F5-ORCH-01 | ORCH | NPC-Karten im Druck; Druck-Datenmodell mit neutralen Codes; Kernrollen-Fassungen versiegelt mit Schlüsselkarte; Ermittlungsbogen mit Ausschlussregeln; Stimmkarten-Auszählung | `party/druck/modell.dart` | F3 | offen |
| F5-BAUMEISTER-01..03 | Baumeister | PDF-Layouts: Spielleitungsheft, Detektivbogen, Rollenhefte · Indiz- und Stimmkarten · Umschläge und versiegeltes Auflösungsheft | `party/druck/<teil>.dart` | F5-ORCH-01 | offen |
| F5-BAUMEISTER-04 | Baumeister | CLI `party_druck` und App-Download | `bin/party_druck.dart`, `lib/party/druck_download.dart` | F5-BAUMEISTER-01..03 | offen |
| F5-TEST-01 | TEST | Besetzungsprüfer 4–20 (F-09) | `test/party/besetzung_test.dart` | F5-ORCH-01 | offen |
| F5-TEST-02 | TEST | Druck gegen Simulator (100 Spiele), Überlaufmessung, Wortgleichheit (F-14, F-10) | `test/party/druck_test.dart` | F5-BAUMEISTER-04 | offen |
| F5-DRUCK-01..02 | DRUCK | gerenderte Seiten prüfen | – (Bericht) | F5-BAUMEISTER-04 | offen |
| F5-ORCH-02 | ORCH | Befunde, Tor, Commit, Push | – | alle F5 | offen |

## F6 – Härtung (Tor F-16, alle Kriterien erneut)
| Kennung | Rolle | Gegenstand | Eigene Dateien | Abhängig | Status |
|---|---|---|---|---|---|
| F6-GEGEN-01..03 | GEGEN | Logik/Abkürzungen · Spoiler (Bildschirm, Druck, Erzähler) · Ton und Klischee am fertigen Spiel | – (Bericht) | F5 | offen |
| F6-SPIEL-01..02 | SPIEL | vollständige Durchläufe, Lesung wie ein Gast | – (Bericht) | F5 | offen |
| F6-TEST-01 | TEST | „kein Story-Text außerhalb des Kanons“, Netz- und Konsolenprüfung im E2E | `test/party/story_text_ausserhalb_test.dart`, `tool/e2e/netz.spec.*` | F5 | offen |
| F6-ORCH-01 | ORCH | Fehlerbehebung, Regression Bestand, Tor, Commit, Push | – | alle F6 | offen |

## F7 – Übergabe (Tor F-17)
| Kennung | Rolle | Gegenstand | Eigene Dateien | Abhängig | Status |
|---|---|---|---|---|---|
| F7-DOKU-01 | DOKU | Anleitung: Einrichtung, Spielablauf, Druck, Fall-Code, Spielleitung, Prüfwerkzeuge | `docs/partykrimi/ANLEITUNG.md` | F6 | offen |
| F7-ORCH-01 | ORCH | Abschlussbericht mit Beleg je F-Kriterium | `planung/.../ABSCHLUSSBERICHT.md` | F7-DOKU-01 | offen |
| F7-ORCH-02 | ORCH | origin holen, zusammenführen, alles testen, Secret-Scan, lokales main per `--ff-only` auf origin/main, Merge, Push, Tag; bei Schutzregel PR (Master §3) | – | F7-ORCH-01 | offen |

**Summe:** 169 Aufträge, davon 34 ORCH (gezählt mit Bereichen wie F3-AUTOR-01..05 = 5). Puffer: 20 % für Nachbesserungen, das sind etwa 34 Läufe.
