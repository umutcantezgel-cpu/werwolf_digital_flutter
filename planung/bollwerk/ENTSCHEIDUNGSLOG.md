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
