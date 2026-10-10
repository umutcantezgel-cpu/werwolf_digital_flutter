# ENTSCHEIDUNGSLOG · Meta-Lauf BOLLWERK

Jede folgenreiche Entscheidung nach dem Denkprotokoll (Ziel · Wege · Bewertung · Umkehrprobe · Folgen · Wahl). Was der Nutzer anders sehen könnte, steht zusätzlich in ANNAHMEN.md.

## E-M0-01 · Werkzeugkette außerhalb des Repos (21:25 UTC)
- **Ziel:** Fragen 1–5 aus M0 beantworten; Messgröße: Flutter 3.47.6 läuft.
- **Wege:** (a) aus der Quelle von `build.sh` in den Scratchpad laden; (b) als nicht klärbar markieren und modellieren; (c) Agenten bauen lassen.
- **Wahl:** (a). Gleiche Quelle wie `build.sh` und wie der Finalisierungs-Lauf (`P/BESTAND.md`); nichts systemweit, kein Repo-Pfad. `chown -R` auf das eigene Scratchpad statt `git config --global` (Git-Konfiguration bleibt unberührt).
- **Umkehrprobe:** Wäre der Download gesperrt, gälte die Abbruchregel; er lief in 70 s.
- **Folge:** Der Master-Prompt richtet die Werkzeugkette repo-lokal in `.werkzeug/` (gitignored) ein, mit genau diesen Befehlen.

## E-M0-02 · Werkzeugverbot technisch nicht erzwungen (21:40 UTC)
- **Befund:** 2 von 14 Haiku-Agenten riefen verbotene MCP-Lesewerkzeuge (über ToolSearch).
- **Wege:** (a) nur Prompt-Verbot; (b) ToolSearch zusätzlich verbieten + Audit nach jeder Welle, Ergebnis eines Verstoßes verwerfen; (c) Sperrdatei `.claude/settings.json` mit `permissions.deny`.
- **Bewertung:** (a) belegt unzureichend (14 %). (c) wirkt technisch, ändert aber `.claude/**` (Grenze; A-13 Standard „keine“). (b) ist im Rahmen und messbar.
- **Wahl:** (b); (c) bleibt Annahme A-13 für den Nutzer.
- **Umkehrprobe:** Ein Agent könnte ein schreibendes Werkzeug (`interrupt_session`, `delete_trigger`) rufen, bevor das Audit läuft. Gegenmaßnahme: Audit läuft je Rückgabe (nicht erst je Welle); ein schreibender Verstoß ist ABBRUCH-Grund und wird in FUER-DEN-NUTZER gemeldet. Restrisiko bleibt → Annahme A-13 mit Folge.
- **Folge:** Ring 0 „Werkzeug-Audit“ vor Ring 1; `proben/werkzeug_audit.sh` wird `tool/bollwerk/werkzeug_audit.sh`.

## E-M1-01 · Umfangsachsen, Mindestbasen und X5 (22:05 UTC)
- **Ziel:** U ≥ 10 messbar, nicht schönrechenbar, mit jeder Indexachse ≥ 3×.
- **Wege:** (a) alle sechs Achsen wie A MP-7, Basis roh; (b) Achsen mit Basis < 5 bekommen Mindestbasis, X5 mit Deckel < 3× wird Pflichtziel; (c) X4 und X5 ganz aus dem Index.
- **Bewertung:** (a) X4 mit Basis 3 würde mit 300 Gags 100× liefern und U verzerren; X5 mit Basis 0 ist undefiniert. (c) verliert Gags als Wachstumsachse. (b) hält alle Achsen messbar, ehrlich und gedeckelt.
- **Wahl:** (b): X4 Mindestbasis 10, X6 Mindestbasis 5, X5 Pflichtziel (≥ 14 Zusatzfunde), g = 3, 2, 1, 1, 2.
- **Umkehrprobe:** Falsch, wenn die Weißliste deutlich mehr als 30 pfadgleiche Zusatzfunde trägt; dann wäre X5 eine echte Achse. Prüfweg: BW0 zählt die Weißliste; Änderung nur per STEUERUNG nach oben.
- **Folge:** Abschnitt 6 UMFANG des Master-Prompts nennt Mindestbasen und Pflichtziel; `umfang.dart` liest sie aus `messbasis/schwellen.json`.

## E-M1-02 · Bildgleichheit über ΔE statt sha256 (22:03 UTC)
- **Befund:** Zwei Läufe gleicher SHA mit fester Uhr sind nicht bytegleich; ΔE (CIE76) im Mittel 0,005–0,100, p99 ≤ 1,7; einzelne Pixel bis 66 (bewegte Seifenblasen bzw. Rasterung).
- **Wahl:** Gleichheit = ΔE-Mittel ≤ 1,0 je Bild (`proben/bildgleich.py`). Bytegleiche Goldens nur über den Golden-Weg L6 (PictureRecorder).
- **Folge:** D2-Paare nutzen den Browser-Weg; L6 bleibt bytegleich.

## E-M2-01 · Würfelparameter innerhalb der Bänder (22:00 UTC)
- **Ziel:** C8 Nr. 1, 2, 3, 13 und Gerätezeit erfüllen.
- **Wege:** sechs Parametersätze simuliert (sim1–sim6, `proben/wuerfel_sim.py`).
- **Ergebnis:** Satz 6 erfüllt alle Bänder bei 10.000 Partien je Form × Besetzung; Details in SPIELKERN.md.
- **Lockerungen:** keine. Zwei Werte liegen knapp am Bandrand (Wurfanteil Party n=4 0,587 ≤ 0,60; Solo 0,31 ≥ 0,30) → Annahme mit Folge.

## E-M5-00 · Unbeabsichtigter Push auf `bollwerk` (≈ 22:57 UTC)
- **Befund:** `cat … <<EOF` ohne Anführungszeichen führte Backtick-Inhalte aus, darunter `git push origin HEAD:refs/heads/bollwerk`. `origin/bollwerk` = f84715d (= bollwerk-plan zu diesem Zeitpunkt).
- **Wege:** (a) Branch löschen – Grenze (kein Löschen; Proxy lehnt Löschungen ab); (b) überschreiben – Force-Push verboten; (c) stehen lassen, melden, Leitstand setzt per Fast-Forward.
- **Wahl:** (c). Eintrag in FUER-DEN-NUTZER §1, STATUS, Übergabe. Abnahme M-12 („Push-Protokoll nennt nur bollwerk-plan“) ist damit nicht vollständig erfüllt und wird so gemeldet.
- **Folge:** Harte Regel im Master-Prompt: Heredocs nur mit `<<'EOF'`, Texte mit Backticks nur über Write.

## E-M2-02 · Würfelmodell neu: nur Suchen würfeln (22:45 UTC, ersetzt E-M2-01)
- **Befund:** Satz 6 aus E-M2-01 ließ Befragungen bei unbesetzten Rollen würfeln und gab Helfer-Fachgebieten +1. Beides hing am Pfad: Die Chance unterschied sich je Option und verriet die richtige Wahl.
- **Wege:** (a) Helfer- und Befragungswürfe behalten und je Entscheidung angleichen; (b) nur Suchen würfeln, Helfer nur Darstellung; (c) jede Entscheidung würfelt, gleiche Chance für alle.
- **Bewertung:** (a) braucht je Entscheidung einen Ausgleich, fehleranfällig. (c) macht Befragungen zufällig, gegen den Kanon-Ton. (b) ist pfadgleich und hält die Bänder (sim7–sim10).
- **Wahl:** (b), mit Schwellen 9 / 7–8 / ≤ 6 (K-05…K-07).
- **Umkehrprobe:** Falsch, wenn der Wurfanteil unter 30 % fällt; L4 misst das jede Welle.

## E-M6-01 · Prüfrunde 2: Würfelregeln geschärft (23:30 UTC)
- **Befund (L03):** Die Reserve-Regel ließ den Pech-Zuschlag (+3 min) eines Abstechers außer Acht. Offen war, ob Folgeentscheidungen und Abstecher würfeln. Die Modifikatorliste war uneinheitlich (Stimmkreis-Bonus in K-19, Nochmal +1 in K-10). Runde 1 konnte ohne Wurf bleiben. Z-04 war zu eng gefasst. Folgeentscheidungen mit `fakt:`-Gliedern hätten Lösbarkeit gekostet. Das WLAN-Salz war vor dem ersten Zug offen, sodass Würfe vorab berechenbar waren.
- **Wahl:**
  - Reserve mit −3 min.
  - Würfelregel nach Ziel: Gegenstand, Raum oder Ort. Eine solche Entscheidung würfelt für alle Optionen.
  - Abschließende Modifikatorliste: Werkzeug +1, gründlich +2, Marke +1.
  - Auftakt-Suche in Runde 1, 0 Nachtminuten.
  - Z-04 prüft alle Wertungsgrößen an der Engine.
  - 0 `fakt:`-Glieder in Folgeentscheidungen und Abstechern (Z-11).
  - Salz als sha256-Zusage, aufgedeckt in der Auflösung.
- **Beleg:** sim11 mit 313.344 erschöpfenden Läufen ohne Abweichung. Jede Runde enthält ≥ 1 Wurf (100 %). Alle Bänder halten. Zahlen stehen in A-4 im Nachtrag M6.

## E-M6-02 · Verworfene Prüfbefunde (23:30 UTC)
- ROT-2 „Leitstand baut keinen MC“ → verworfen: widerspricht V-16 und PLAN (der MC-Bau gehört dem Leitstand).
- „Kürzungsleiter streichen“ → ersetzt durch „gekürzt = rot bis A<n>: ja“; die Leiter bleibt als Notweg.
- Werkzeug-Audit meldete grep-Muster als Befehle → Audit entfernt zitierte Teile vor dem Abgleich. Die 2 echten Verstöße aus M0 (vor dem ToolSearch-Verbot) bleiben gemeldet.

## E-M7-01 · Runde 4 nach Leitstand-Befund F-1 (≈ 01:05 UTC)
- **Befund:** Leitstand-Rubrik 21/26 mit 12 Mängeln, darunter unerfüllbare Tor-Budgets und Herzschlagsperre (Ablösung mitten im Tor), Design ohne Regelkreis und mehrdeutiges Z-14.
- **Wahl:** alle Ersatztexte aus F-1 übernehmen; Tore im Worktree `bw-tor` als einzige Ausnahme zu `commit.sh`; Wandzeit-Budgets aus der Schichtensumme; D2-Zwischenziele 50/65/85 %.
- **Umkehrprobe:** Falsch, wenn L-1 in G1 deutlich kürzere Schichtzeiten misst. Dann werden die Budgets über SCHWELLEN-NACHTRAG strenger.

# Nachtlauf · Generation 1 (10.10.2026)

## E-G1-01 · Lichtung L-8 · Weg der Sitzungskennung (02:00 UTC)
- `mcp__claude-code-remote__get_session` ohne `session_id` lieferte `id = session_01J12w9BSCysBqiSdn143rRF`, `parent_session_id = session_01Aix28JmFAfTMVcF4Z8bgqP` (= Leitstand) und `rate_limit_info.resetsAt`. Der Weg über `$CLAUDE_CODE_REMOTE_SESSION_ID` wurde nicht gebraucht.
- Folge: Weckruf-Name `BOLLWERK-G1-session_01J12w9BSCysBqiSdn143rRF`; die Herkunft der Startnachricht ist über `parent_session_id` belegt.

## E-G1-02 · Werkzeugkette und Messwerte der Maschine (02:00 UTC)
- B-01: `flutter --version` meldet 3.47.6 / Dart 3.13.5 (sha256 des Archivs geprüft, Download 16 s). `pub get` in allen 8 Paketen 39 s.
- Maschine: 4 Kerne, 15 GB RAM, 30 GB frei unter /home/user.

## E-G1-03 · Befund F-2 (lange Tore) · Umsetzung ohne Master-Prompt-Änderung (02:00 UTC)
- **Ziel:** Tore `phase`/`nacht`/`ziel` überleben die 2-h-Grenze der Bash-Hintergrundbefehle; `bw-tor`-Stand überlebt den Generationswechsel.
- **Wege:** (a) Tor als Bash-Hintergrundbefehl (bricht nach 2 h ab); (b) abgekoppelt mit `setsid nohup` + Wartebefehl auf die Endzeile; (c) immer in Schichtgruppen < 100 min.
- **Bewertung:** (b) ist am einfachsten und hält die Tor-Semantik; ob der Prozess > 2 h lebt, ist nicht belegt. (c) ist sicher, aber teilt jeden Lauf.
- **Wahl:** (b) mit `tool/bollwerk/tor_start.sh`; Probe L-9 (`setsid nohup sleep 7500`, PID 694, Start 01:56Z) wird ab 04:01Z geprüft. Scheitert sie, wird `--gruppe <k>` im Torwerkzeug Pflicht (c).
- **Tor-Rest:** `tool/bollwerk/tor_rest.sh sichern <gen> <phase>` schreibt `planung/bollwerk/tor-rest/G<n>.patch` (Zeile `TOR-REST` im PRUEFPUNKT); `anwenden <gen>` legt den Tor-Worktree an und wendet ihn mit `--index` an.
- **Umkehrprobe:** Wenn die Cloud-Maschine selbst nach 2 h Inaktivität pausiert, hilft keins von beiden; dagegen hält der Herzschlag alle 30 min die Sitzung aktiv.

## E-G1-04 · Lichtung L-1 · voller Testlauf auf dieser Maschine (02:12 UTC)
- `bash tool/alle_tests.sh` (voll, Schwerlast-Slot, ohne Parallellast außer einem Simulatorlauf): **621 s, „ALLE TESTS GRÜN“**, Exit 0. Damit passt L1 (Budget ≤ 12 min) knapp; für `phase` (≤ 190 min) bleibt reichlich Luft.

## E-G1-05 · Würfelkern und Simulator-Port (02:05 UTC)
- **Ziel:** Kern in `packages/mordakte_core/lib/src/runden/` und `tool/bollwerk/runden_simulate.dart` mit „gleichen Zahlen am gleichen Seed-Satz“ wie `proben/wuerfel_sim.py`.
- **Wege:** (a) eigenes Modell im Simulator (verboten, MP §6); (b) Kern mit Würfelquelle als Schnittstelle, Strategien im Simulator, Strategie-Zufall über einen bitgenauen Nachbau von Pythons `random.Random` (MT19937, randbelow, shuffle, choice, sample) nur im Werkzeug; (c) Gleichheit nur statistisch (Bänder ±1 %).
- **Wahl:** (b). Belegt: erschöpfend 313.344 Läufe, alle Zähler 0 und gleich Python (18 s statt Minuten); Bänder bei 1.000 Partien je Form × Besetzung **0 von 200 Kennzahlen abweichend** gegenüber einem frischen Python-Lauf.
- **Befund an der Vorlage:** `proben/wuerfel_sim.py` hat heute sha256 `8a8d1ec3…`, nicht den in A-4 genannten `7f568495…`; `proben/sim-voll-ergebnis.json` stimmt bei den Bändern nicht mehr mit der heutigen Vorlage überein (der erschöpfende Teil schon). Maßgeblich für den Port ist die eingecheckte Vorlage; nachgereicht wird die Bandprüfung (Z-05) an den Schwellen, nicht an der alten JSON.
- **Port-Treue, bewusst übernommen und als Kern-Frage offen:** Die Vorlage zählt mit `marken` die *eingesetzten* Seifenblasen-Marken (≤ 3 je Partie) und vergibt eine Marke nur bei Pech in der Auftakt-Suche; K-10 verlangt „Glück im Unglück (Marke + wahrer Satz)“ bei jedem Pech. Eine Änderung verschiebt die Bänder und ist ein „KERN 1.1“-Schritt nach Denkprotokoll (Prüfbericht PRUEF-KERN-1 abwarten).
- **Umkehrprobe:** Bitgleichheit beweist nur Port-Treue, nicht Regeltreue; deshalb unabhängige Opus-Prüfung PRUEF-KERN-1 gegen WÜ-1…6 und K-01…K-26.

## E-G1-06 · Torwerkzeug und Rot-Probe (02:11 UTC)
- `tool/bollwerk/bollwerk.dart` führt Schichten mit Budget und Timeout (2 × Budget), schreibt Belege mit HEAD-Kopf, prüft sauberen Baum vor und nach dem Lauf, kennt `--gruppe <k>` (F-2) und meldet fehlende Schichten als `OFFEN` (rot).
- `schnell --vorlauf` an 2764671: L0 grün (8 s), L2 grün, L4 grün (39 s), L3 und L5 OFFEN → rot, Wandzeit 50 s.
- **Rot-Probe** (Wegwerf-Worktree, Patch in /home/user/bw-archiv/rotprobe/): absichtlich roter Test in `test/runden/` → L2 rot; `import 'dart:math'` in der Zugschicht → L0 (L0.4 und Analyse) rot; Endzeile `BOLLWERK ROT · L0 L2 L3 L5`, Exit 1. Dabei gefunden und behoben: L2 lief nur die Eigenschaftsdatei; jetzt alle Tests unter `test/runden/`.
- `commit.sh` fährt das volle Tor erst ab `TOR-SHA` im PRUEFPUNKT; davor Aufbauprüfung (Analyse mit `--fatal-infos` und Rundentests).

## E-G1-07 · Abnahme des Torwerkzeugs im Vorlauf (02:20 UTC)
- `dart run tool/bollwerk/bollwerk.dart schnell --vorlauf` an `30fadff`: L0 7 s, L2 1 s (500 Fälle je Eigenschaft), L3 9 s (1.000 Codes VM = Node = Soll-Liste), L4 40 s (erschöpfend 313.344 Läufe, Wertung, Bänder 200 Seeds), L5 1 s (0 Einheiten) → `BOLLWERK GRÜN · schnell · 30fadff…`, Wandzeit ≈ 60 s (Budget ≤ 9 min).
- Rot-Proben: roter Test → L2 rot; `dart:math` im Kern → L0 rot; drei Probe-Einheiten → L5 mit 10 Befunden rot (Alkohol, Sperrliste, Gewalt, Platzhalter, fehlende Stufen, keine Folge, `fakt:`-Glied, Dublette).
- **TOR-SHA = 30fadff64ac5625bdfe7e1e6494677ce493b22a7.** Ab hier fährt `commit.sh` vor jedem Code-Commit das volle `schnell`-Tor (vor B-02 mit `--vorlauf`).
- **Lücken, bewusst offen:** `schwellen.dart` (Schwellen maschinell aus MP §6) fehlt noch; L4 hat noch keine Modi `fairness` und `dauer` (im Vorlauf-Schnelltor nicht verlangt, in `phase` als rot gemeldet); `belege/rotproben.tsv` entsteht mit L9.

## E-G1-08 · Reparaturen an geschützten Werkzeugen nach TOR-SHA (02:22–02:34 UTC)
- `commit.sh`: Das Tor lief im Wegwerf-Baum auf vorgemerkten, nicht committeten Änderungen und meldete „Baum nicht sauber“ – jeder Code-Commit wäre gesperrt gewesen. Reparatur: Probe-Commit nur im losgelösten Wegwerf-Baum vor dem Tor (nie gepusht). Keine Lockerung: Das Tor läuft jetzt erst wirklich. Rot-Probe: Datei mit `dart:math` unter `lib/src/runden/` → „TOR ROT – kein Commit“ (L0.4, 2 Treffer).
- `archiv_pruefen.sh` (nicht geschützt): `git log | grep -q` lieferte unter `pipefail` falsch-negativ (Pipe-Abbruch); jetzt über eine Variable.

## E-G1-09 · L4-Modus fairness, schwellen.dart, Archiv, FEINKORN-Merge (02:28–02:33 UTC)
- **fairness (Z-06):** |ρ(Chance, richtig)| = 0,045 (≠ 0, weil Suchen zwei, Befragungen drei Optionen haben; je Entscheidung ist die Chance gleich), Geiz-Bot (billigste = erste Option, keine Abstecher) 4,0 Punkte im Mittel, Pfad-Maximum 5, Pfadgleichheit des Würfelprotokolls 0 Verstöße. Gruppenwahl ändert das Würfelprotokoll per Bau nie (die Zugschicht nimmt keine Gruppenwahl-Eingabe an).
- **schwellen.dart:** 87 Schwellen in 27 Z-Zeilen, sha256 §6 `e80278137fed90a7…`; Bänder, Brüche („15/18“), strikte und ±-Schwellen; Besetzungsangaben und die Meta-Blindprobe werden nicht als Schwelle gelesen. `--pruefe` macht eine lockernde Nachtragszeile rot (Rot-Probe). `messbasis/schwellen.json` schreibt erst BW0 an K.
- **ARCHIV.md / archiv_pruefen.sh:** Z-29 grün (10 Linien, alle Refs auf origin). Z-30 offen: HD `caf1d61` zurückgestellt (Merge nur, wenn danach L1 grün ist – das prüft erst `phase`), Meta-Archiv (107 Dateien) braucht vor der Übernahme eine Durchsicht auf Rohchat-Spuren (A-2 A4.5).
- **FEINKORN:** `Merge kern-feinkorn@1145cb9` im Tor-Worktree (52 neue Dateien, 0 Konflikte), dazu `packages/pixel_engine/lib/feinkorn_leben.dart` (exportiert Skelett, Schattenkarte, Material, Physikwelt, Starrkörper; nicht FeinZufall, nicht die Sperrnamen). pixel_engine: 323 Tests grün, Analyse sauber; Tor `schnell --vorlauf` grün an e1e1f9d, gemergt als 022cfa7.

## E-G1-10 · Prüfbericht PRUEF-KERN-1 (Opus max, unabhängig) · 9 MAJOR, 5 MINOR (02:37 UTC)
Bericht: `planung/bollwerk/berichte/G1/PRUEF-KERN-1.md` (Werkzeug-Audit 0 Verstöße). Eine Stimme, keine Skeptiker-Runde; jeden Befund habe ich an Code und A-4 nachvollzogen.
- **Behoben in 19570f9 (ohne Folgen für die Port-Gleichheit):** #3 Kettensperre prüft vor jeder Änderung (vorher verlor `waehle` bei Fehlern Züge; Runden nur der Reihe nach, Auftakt einmal); #6 Wertung vergleicht Punkte, Restverdächtige je Runde, Fakten und das Ende jeder Anklage (vorher nur Punkte); #7 Referenz ohne Würfel aus den Wahlen in Kanon-Reihenfolge (vorher war der „Neutralwurf“ der Lauf „immer Pech, n = 4“) – Rot-Probe: Mutant „Aufdecken entfernt“ überlebte vorher L2 und L4, jetzt L2 rot und L4 rot (313.344 Abweichungen); #11 Bänder: Runde ohne Wurf und Sackgassen rot, Standard 10.000 Seeds; #14 schlechtester Pflichtzug aus zweit/dritt/umweg statt 2 × umweg (heute gleicher Wert 14).
- **Kern-Frage für G2 („KERN 1.1“, Denkprotokoll vor dem Ändern):** #1 Marken: Vorlage und Kern zählen eingelöste Marken und vergeben nur bei Auftakt-Pech eine – K-07/K-10 verlangen Marke bei jedem Pech, ≤ 1 je Wurf, ≤ 2 je Wissensziel, ≤ 3 je Partie; #2 „gründlich“ im Abstecher kostet in der Vorlage nichts (K-07: +2 min) und fehlt in der Reserve-Regel; #4 Würfelstrom und Bot-Wahl teilen in der Vorlage denselben Seed (Korrelation Wahl ↔ erster Würfel); #5 C8 1a ist im Port nur die Ungleichung, nicht der erschöpfende Folgenbeweis (E, T, PE, PT, PPE, PPT × Tischruf × gründlich); #9 kein Test tötet „Würfel-Id = Option statt Entscheidung“ (L4 nutzt `SalzWuerfel` nie). #1, #2 und #4 verschieben die gemessenen Bänder (Pech im 1. Anlauf lag bei bis zu 34,0 %, Grenze 35 %); sie werden zusammen umgesetzt und neu gemessen, die Python-Vorlage bleibt als Referenz des Meta-Stands.
- **#8** (fairness/dauer OFFEN) ist für fairness erledigt (e71664c); der Geiz-Bot wählt bei pauschalen Kosten (C1) die erste Option – ein Bot, der Wegkosten sieht, kommt mit den Abstecher-Karten. `dauer` wartet auf das Zeitmodell (L-2, BW0). **#10, #12, #13** (Vorschau, Bilanz, Abstecher-Karte) gehören zum Ausbau in BW1/BW2.

## E-G1-11 · Lichtung L-3 · Orte am Raumgraph (02:38 UTC)
Bericht: `planung/bollwerk/berichte/G1/L3-TEILORTE.md` (Haiku max, Audit 0 Verstöße). 43 Orte in 7 Räumen, alle innerhalb ihres Rechtecks, 0 auf blockierter Kachel, alle Räume erreichbar; 19 Ziele der Entscheidungen zugeordnet.
- **Frage des Kundschafters:** zählt `wc` („auf der Toilette oben im Turm“, Koordinate gleich `wendeltreppe_fuss`)? **Ziel:** X3 ehrlich zählen. **Wege:** (a) 43 roh; (b) 42 – `wc` liegt nicht in einem der 7 Kellerräume und ist nach der Dublettenregel (< 1 Kachel im selben Raum) eine Dublette; (c) 45 mit Raum-Zielen. **Wahl:** (b) 42, weil A-8 nur Orte innerhalb der 7 Kellerräume zählt und `wc` oben im Turm liegt; dieselbe Regel gilt später für neue Orte. **Umkehrprobe:** Eine kleinere Basis erhöht f_X3 (42 statt 43: +2,4 %); das ist kein Schönrechnen, weil die Regel symmetrisch an K und HEAD gilt, aber der Morgenbericht nennt beide Werte. Verbindlich ist allein die maschinelle Zählung in BW0 an K (UMFANG-BASIS.md).
- Dublettenschwelle bleibt „< 1 Kachel“ (A-8 Nachtrag M6 wörtlich).

## E-G1-12 · Lichtung L-4 · Weißliste am Kanon (02:40 UTC)
Bericht: `planung/bollwerk/berichte/G1/L4-WEISSLISTE.md` (Haiku max, Kanonwächter, Audit 0 Verstöße).
- Bleiben (10): b_baran_rufe, b_hana_wachs, b_serkan_tor, b_pawel_schneider, spur_wachs_boden, spur_steckdose_verschmort, spur_laterne_unberuehrt, spur_torte, lacher_ruestung, lacher_kamin.
- Fallen heraus: b_schneider_erinnerung und b_tim_gesicht (belasten nach dem Bericht Can), lacher_verlaufen und die 12 neutralen Bonus-Sätze (A-4 Abweichung 6), `spur_stirnlampe` (Tatzeit 23:59:40, nicht sichtbar). Bedingter Ersatz: `spur_handykorb` (`entstehtWenn: immer`, in keiner Kette).
- **Befund:** Z-11 verlangt ≥ 14 Weißlisten-Zusatzfunde; der Kanon trägt sicher 10, mit `spur_handykorb` 11. Es fehlen 3–4.
- **Wege:** (a) Z-11 über die Kürzungsleiter senken (nur mit „A<n>: ja“); (b) die zwei Täter-Befunde (Schneider, Tim) noch einmal selbst prüfen – eine Haiku-Stimme reicht für ein Herausnehmen nicht; (c) neue pfadgleiche, nicht lösungsrelevante Zusatzfunde der Schicht (z. B. Zustand von Teekocher, Torte, Handykorb), die nur Wahres über Dinge sagen, die in allen 4 Pfaden gleich sind, vom Kanonwächter je Fund geprüft.
- **Wahl (Standard bis zur Nutzerantwort):** (b) in G2 durch Opus, dann (c) für den Rest; (a) nie still. Frage mit Standardwahl in FUER-DEN-NUTZER §G1-2.

## E-G1-13 · Lichtung L-9 · abgekoppelter Prozess über 2 h (04:02 UTC) – unentschieden
- Probe wie in F-2 vorgegeben: `setsid nohup sleep 7500 > /dev/null 2>&1 < /dev/null &` (PID 694, Start 01:56:06Z). Beobachtet lebend bei 117 min (03:53:24Z), weg bei 126 min (04:02:24Z). Das natürliche Ende von `sleep 7500` lag bei 125 min (04:01:06Z).
- **Ergebnis:** unentschieden – die 2-h-Grenze (03:56Z) fällt in die Beobachtungslücke, und ohne Endstempel lässt sich natürliches Ende nicht von einem Abbruch trennen. Fehler im Aufbau: Die Probe selbst endete fast genau zum Prüfzeitpunkt.
- **Folge bis zur Klärung:** Lange Tore laufen in Schichtgruppen < 100 min (`bollwerk.dart <modus> --gruppe <k>`), wie F-2 für den Fehlschlag vorsieht – die sichere Wahl.
- **Neue Probe für G2 (früh im Fenster starten):** `setsid nohup bash -c 'echo start $(date -u +%T); sleep 9000; echo ende $(date -u +%T)' > /home/user/bw-logs/l9.log 2>&1 < /dev/null &` und Prüfungen bei 115, 125 und 135 min (`pgrep` plus Log). Lebt er bei 135 min oder steht „ende“ nach 150 min im Log, ist L-9 bestanden.

## E-G2-00 · Start G2 (04:41 UTC)
- Neue Maschine (boot_id 956fc6b8…): Werkzeugkette neu (Flutter 3.47.6, sha256 geprüft, pub get 8/8). FLUG von G1 vollständig fertig, nichts neu einzureihen. Repo war flach → entflacht; Übergabe-Stand P gleich.
- Rohchat fehlt weiter: Secret-Scan „sauber“, Passagenprüfung übersprungen (Vermerk wie G1-1).
- L-9b gestartet 04:41:08Z (`sleep 9000` mit Start-/Endstempel, PID 679); Prüfungen bei 115/125/135 min.

## E-G2-01 · KERN 1.1 (Denkprotokoll, 05:00 UTC)
- **Ziel und Messgröße:** Würfelkern deckt sich mit K-07/K-10/K-12 und C7 (Bot-Strom ≠ Würfelstrom); Messgröße: Befunde PRUEF-KERN-1 #1, #2, #4 geschlossen, Bänder Z-05 und Fairness Z-06 grün mit 10.000 Partien je Form × Besetzung.
- **Wege:** (a) Kern bleibt 1.0, Spielkern-Text anpassen – verworfen, K-07/K-10 sind Nutzer-nahe Kernaussagen („Glück im Unglück: Marke“), A-1 verlangt sie; (b) Kern 1.1 nach A-4 umsetzen und neu messen; (c) Kern 1.1 umsetzen, aber Marken nur bei Auftakt-Pech wie im Meta-Simulator – verworfen, widerspricht K-10 wörtlich; (d) wie (b), zusätzlich „gründlich“ im Abstecher verbieten statt bepreisen – verworfen, K-07 nennt „gründlich“ ohne Ausnahme.
- **Wahl (b):** #1 jedes Pech (Auftakt, Abstecher, Anlauf) bringt eine Marke in den Bestand; eingelöst wird nur aus dem Bestand, ≤ 1 je Wurf, ≤ 2 je Wissensziel, ≤ 3 je Partie, und nur wenn sie wirkt (Modifikator ohne Marke < +2), damit keine Marke verfällt. #2 „gründlich“ im Abstecher (nur mit Wurf) kostet +2 min und steht in der Reserve-Regel. #4 Simulator würfelt mit `SalzWuerfel('meta:<seed>')` bzw. `('geiz:<seed>')`, getrennt vom Bot-Strom. Zusätzlich aus PRUEF-KERN-1: #10 `vorschau()` (WÜ-2) und Tischruf im Ereignisprotokoll; #12 Seifenblasen-Bilanz (`restJeRunde`, `abstecherZahl`, `seifenblasenBilanz`, getrennt von `wertung`).
- **Umkehrprobe:** Würfelstrom oder Markenregel ändern nie `gewaehlt`, Fakten oder Wertung (Z-03/Z-04 laufen unverändert gegen die echte Engine). Der Modus `meta-gleich` ist ab Kern 1.1 nicht mehr bitgleich zur Python-Vorlage (gewollt); die Gleichheit an Kern 1.0 bleibt durch G1 (TOR-SHA 30fadff, E-G1-07) belegt.
- **Folgen:** L3-Soll-Liste ändert sich mit dem Protokoll: neue Datei `determinismus_soll_k11.g.dart` (VM = Node geprüft), die Kern-1.0-Liste bleibt unverändert liegen (Regel „Vergleichsstände nie neu schreiben“). Briefings der Variantenwellen ab W1 schreiben: Marke bei jedem Pech, Personen geben nie ein Plus (K-06; die Fabrikprobe hatte noch „Joanna leuchtet, +1“), Stufentexte ohne Minuten- und Pluszahlen (die Zeit rechnet der Kern). Neue Tests `test/runden/kern11_test.dart` (8 Tests).

## E-G2-02 · Verschärfung Torwerkzeug: Bänder und Fairness mit 10.000 Partien in jedem Modus (05:20 UTC)
- **Befund:** Das Schnelltor maß Z-05 mit 200 Partien je Form × Besetzung (50 je Pfad, weniger als A-5 „200 Partien je Pfad“). Seit Kern 1.1 liegt Pech im 1. Anlauf bei 33,4–33,9 % (10.000 Partien), 1,1 Punkte unter der Grenze; mit 200 Partien kippten 4 von 10 Kombinationen zufällig über 35 % bzw. unter 25 % im Quartil (Commit-Versuch an acf8135 rot), mit 800 noch eine.
- **Wege:** (a) Bot-Strategie so drehen, dass die Messung weiter weg von der Grenze liegt – verworfen, das wäre Schönrechnen; (b) Fallzahl im Schnelltor auf die Fallzahl von Z-05 (10.000) heben – Verschärfung, gleiche Schwellen, kostet 10 s (Bänder) bzw. 7 s (Fairness); (c) Parameter im Band nachstellen (A-17) – nicht nötig, die Bänder halten bei 10.000.
- **Wahl (b):** `tool/bollwerk/bollwerk.dart` (geschützt seit TOR-SHA) setzt `seeds` für alle Modi auf 10.000. Nur Verschärfung: mehr Fälle, keine Schwelle verändert.
- **Rot-Probe** (Wegwerf-Worktree `/home/user/bw-arbeit/rot`, danach entfernt): Mutant `teilerfolgAb = 8` → `L4 baender ROT` in allen 10 Kombinationen (pech1); Mutant „Pech bringt keine Marke“ → `kern11_test.dart` 4 von 8 Tests rot. Beides als Zeilen für `belege/rotproben.tsv` vorgemerkt (die Datei schreibt nur das Torwerkzeug, L9).
- **Risiko (Nebelkarte 17):** Pech im 1. Anlauf hat 1,1 Punkte Abstand zur Grenze. Neue Würfel-Quellen (Werkzeug-Abstecher, Marken-Einsatz der Bots) können ihn verschieben; jede Kern-Änderung misst neu.

## E-G2-03 · Weißliste: Nachprüfung der zwei Täter-Befunde durch Opus (G1-2 Weg b, 05:40 UTC)
- `b_schneider_erinnerung` (Erzähler): Beleg „sehen can, leuchten/erkannt/umriss, 23:58:09–23:58:13“ und „fühlen can“, Feld `belastet: [can]`. `b_tim_gesicht` (Pflichtgespräch Tim, auch in bonus.json 4×): Beleg „sehen can, leuchten, 23:58:00–23:59:30“, `belastet: [can]`.
- **Urteil:** beide bleiben außerhalb der Weißliste. Gründe: C4 „kein Nebendelikt einer Kernperson, keine falsche Fährte“ (das leuchtende Gesicht ist Cans Nebendelikt bzw. eine Fährte), A-8 „kein neues Wissen über 23:50–00:15“, und `b_tim_gesicht` ist Bonus-Material (E-025). Die Haiku-Stimme aus L-4 ist damit bestätigt.
- **Folge:** Weißliste = 10 sichere + `spur_handykorb` = 11 (so in `varianten.dart`). Für Z-11 (≥ 14) gilt die Standardwahl G1-2 (c): drei oder mehr neue pfadgleiche Kleinigkeiten der Schicht, je Fund vom Kanonwächter geprüft; Auftrag folgt als eigener Slot `ZUSATZ-<n>` (Opus prüft am Kanon).
