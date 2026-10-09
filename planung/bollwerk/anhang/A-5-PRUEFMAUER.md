# A-5 · Prüfmauer und Torwerkzeug (Ringe und Schichten L0–L10)

Teil 1 legt Ringe, Schichten, Befehle, Fallzahlen und Budgets fest (geht vor). Teil 2 ist MP-14 aus Anhang A.

## Teil 1 · Ringe → Schichten, billig vor teuer

| Ring | Prüfung | Schicht / Werkzeug | Messgröße · Schwelle | Statistik je Welle |
|---|---|---|---|---|
| 0 Werkzeug | Werkzeug-Audit jeder Rückgabe | `tool/bollwerk/werkzeug_audit.sh` | verbotene tool_use · 0 | Verstöße je Agent |
| 1 Form | Schema, Pflichtfelder, Kennungen, Länge, Sprache, keine Platzhalter | `dart run tool/bollwerk/varianten.dart --welle <w> --ring 1`, F1 | Fehler · 0 | grün/gesamt |
| 2 Regeln | Inhaltsregeln, Sperrliste, Gewalt, Bildregeln, Namensbalance, Spoiler- und Geheimnisschutz, keine echten Personen oder Marken | L5, L0.4 | Treffer · 0 | Treffer je Liste |
| 3 Kanon und Logik | Kanon 1.0 bytegleich; keine neue Spur an Kanon-Orten; Lösbarkeit würfelbezogen (K-14); Budget-Ungleichung und Kettensperre statisch | L0.3, L4 (C8 Nr. 1, 2, 7, 13) | Abweichung · 0 | Verstöße |
| 4 Technik | Bauen, Analysieren, Tests, Golden, Leistung, Größe, keine fremden Server, Burgstadt-Schutz | L0, L1, L2, L3, L6, L8 | rot · 0 | Laufzeit, Exit |
| 5 Spiel | erreichbar in Simulationen (F2 ≥ 1 % der Partien), keine Sackgasse, Balance im Band, alle drei Formen | L4, L7 | Sackgassen · 0; F2 ≥ 1 % | Erreichbarkeit je Einheit |
| 6 Neuheit | kein Beinahe-Duplikat | F4 (Jaccard < 0,5; Tupel eindeutig; Silhouetten-IoU < 0,9) | Dubletten · 0 | Dublettenquote |
| 7 Qualität | 3 Linsen-Richter + bei Spreizung > 2 zwei weitere, Median; F5 mit 20 Füllstücken | F5, L10, D1–D3, S1–S5 | angenommen ≥ 2 × ≥ 7; F5 ≥ 18/20 abgelehnt | Annahmequote je Slot und Denkstufe |
| 8 Stichprobe | je Welle per Seed ≥ 10 % und ≥ 20 Einheiten, Opus; bei Wellen > 200 Einheiten ein frischer Opus-5.5-Agent | L10 | 1 Kanon-/Inhalts-/Lösbarkeitsfehler, > 5 % Fehler oder > 2 % Füllstoff (keine Wirkung oder Dublette) → Welle zurück | Fehlerquote |
| 9 Mutanten | für neuen Code | L9a, L9b | Tötungsrate 100 % (Würfel, Lösbarkeit, Wahrheit, Inhalt, Bestand), ≥ 90 % gesamt | überlebende Mutanten |

Seed jedes Gremiums und jeder Stichprobe: erste 8 Hex von `sha256(<Welle>|<Inhalts-Hash>)`, Inhalts-Hash = sha256 der Merge-Eingaben der Welle (nie HEAD; Herzschlag- und Zustands-Commits gehen nicht ein; gilt auch für Ring 8); ändert sich der Inhalt, entsteht eine neue Prüfung, die im Beleg auf die alte verweist; die Stichprobenliste steht vor dem Ansehen in REGISTER.md; je Hash genau ein Gremium; jeder Lauf liegt in `planung/bollwerk/belege/gremium/`, auch verworfene.

## Schichten mit Befehl, Fallzahl je Modus und Budget

| Schicht | Befehl (im Torwerkzeug) | schnell | phase | nacht | Budget |
|---|---|---|---|---|---|
| L0 Fundament | `pub get` in 8 Paketen, `dart analyze`, `flutter analyze`, `bash tool/secret_scan.sh`, L0.1 `dart run tool/bollwerk/bestand.dart --pruefe`, L0.2 Schutzpfade, L0.3 Kanon gegen K, L0.4 Würfelquelle, L0.5 Importregel, L0.6 Release | ja | ja | ja | ≤ 3 min |
| L1 Bestand | `bash tool/alle_tests.sh schnell` bzw. voll; `bash tool/pruefen.sh alles`; Burgstadt-Schutz | betroffene Pakete | voll | voll | ≤ 12 min |
| L2 Eigenschaften | `(cd packages/mordakte_core && dart test test/runden/eigenschaften_test.dart)` | 500 Fälle je Eigenschaft | 2.000 | 10.000 | ≤ 2 min / 8 / 40 |
| L3 Determinismus | `dart test -p vm` und `-p node` (`determinismus_web_test`) | 1.000 Codes VM+Node | + Chrome | + Chrome | ≤ 3 min |
| L4 Simulation | `dart run tool/bollwerk/runden_simulate.dart --modus <m>` (Port von `proben/wuerfel_sim.py`) | 200 Partien je Pfad × Strategie + erschöpfend 768 × 4 × {Pech, Erfolg} | 2.000 + erschöpfend × Besetzung 4–20 | 10.000 je Form × Besetzung + „immer Pech“ | ≤ 3 / 15 / 60 min |
| L5 Inhalt | `dart run tool/bollwerk/fuellstoff.dart` (F1–F4) + Textprüfer der Schicht | geänderte Dateien | alle | alle | ≤ 2 min |
| L6 Golden | `flutter test tool/bollwerk/look_anker/` | 7 Räume × 2 Lichtzustände × hoch/quer | dto. | dto. | ≤ 60 s |
| L7 E2E | `node tool/bollwerk/e2e.mjs` | – | Party 4/12/20, Solo, WLAN (VM-Host + 3 VM-Gäste + 1 Browser-Gast) × 4 Pfade | dto. | ≤ 25 min |
| L8 Leistung | L8a PictureRecorder + Thread-CPU, L8b `messen.mjs` A/B | – | 300 Bilder je Raum; 5 × 20 s | dto. | ≤ 15 min |
| L9 Mutanten | `bash tool/bollwerk/mutanten.sh` | – | 10 % Rot-Proben | ≥ 40 Mutanten | ≤ 40 min |
| L10 Gremien | Gremium-Belege prüfen (Hashes, Modell, Eichlauf) | – | ja | ja | ≤ 1 min |
| L12 Design | `dart run tool/bollwerk/design_mass.dart` (D1) · `python3 -I tool/bollwerk/stil.py --alle` (S1–S6) · `node tool/bollwerk/gremium.mjs d2\|d3` | – | D1, S1–S6 | alles | ≤ 60 min (Schwerlast-Slot) |

Budgets: `schnell` ≤ 9 min, `phase` ≤ 55 min (Schwerlast-Slot), `nacht` ≤ 4 h CPU, `ziel` = `nacht` + L10 + L11 (die Befehle aller Z-Zeilen aus Master-Prompt §6 außer Z-31…Z-34; jeder schreibt `belege/<Z-Nr>.txt` mit HEAD-Kopf; die Abnahmetabelle ist Master-Prompt §6). `ziel` liest R aus LAUF.md, prüft vor und nach dem Lauf `git diff --quiet R HEAD -- . ':!planung/bollwerk'` (Herzschlag-Commits erlaubt) und schreibt die Endzeile mit R. Endzeile genau `BOLLWERK GRÜN · <modus> · <sha>` oder `BOLLWERK ROT · <schichten>`.

## Teil 2 · MP-14 aus Anhang A
### MP-14 · BOLLWERK (Prüfschichten)
**Torwerkzeug** `dart run tool/bollwerk/bollwerk.dart [schnell|phase|nacht|ziel]`

| Modus | Budget | Inhalt |
|---|---|---|
| schnell | ≤ 9 min | L0; betroffene Paket-Tests; L2 mit 500 Fällen je Eigenschaft; L3 auf Node; L4 mit 200 Partien je Pfad × Strategie; L5; L6 |
| phase | ≤ 55 min, Schwerlast-Slot | zusätzlich `alle_tests.sh` voll und `pruefen.sh alles`; L4 mit 2.000; L7; L8; L9 |
| nacht | ≤ 4 h CPU | L4 mit 10.000 und „immer Pech“; L2 mit 10.000; L9 voll |
| ziel | – | nacht + L10 + L11 (alle Z-Befehle außer Z-31…Z-34) + L12 |

- **Belege** `planung/bollwerk/belege/L<n>.txt` beginnen mit `HEAD <sha40> · <Berlin-Zeit> · <modus> · Exit <c> · <s>`. Ein Beleg gilt nur bei `git diff --quiet <sha> HEAD -- . ':!planung/bollwerk'` und zusätzlich `git diff --quiet <sha> HEAD -- planung/bollwerk/messbasis planung/bollwerk/BESTAND-AUSNAHMEN.txt`.
- **Fehlerschutz:** `set -euo pipefail`; 0 Treffer für `|| echo`/`|| true` um Prüfbefehle (Selbstprüfung); Timeout je Schicht = 2 × Budget.
- **Endzeile:** genau `BOLLWERK GRÜN · <modus> · <sha>` (Exit 0) oder `BOLLWERK ROT · <schichten>` (Exit 1). Fehlt sie, gilt rot.
- In BW0 wird das Werkzeug abgenommen: Rot-Probe (absichtlich roter Test ⇒ Exit 1) und ein grüner `schnell`-Lauf in ≤ 9 min.

**L0 Fundament**
- `pub get` in allen Paketen; `analyze`; Secret-Scan.
- **L0.1** `tool/bollwerk/bestand.dart`, übernommen aus `kern-feinkorn@1145cb9`. Basis am B-02-Commit. Abweichungen nur laut `planung/bollwerk/BESTAND-AUSNAHMEN.txt` (eingefroren ab BW0, A4.4).
- **L0.2** Schutzpfade: Nach `git fetch` gilt `B=$(git merge-base HEAD origin/main)`. Für jede Datei `p` aus `git diff --name-only $B HEAD -- <A4.8 Nie-Liste>` muss der Blob `HEAD:p` gleich `caf1d61:p`, `1145cb9:p` oder (FREIGABE-Weg) `K:p` sein, sonst rot; die Linie wird dann nach der Konfliktregel behandelt. Vor B-02 gilt dasselbe für die Hoheitsliste. Dazu die eingefrorenen Pfade aus A4.4. Die Nie-Liste wird nie gekürzt; `B` wird nie von Hand gesetzt.
- **L0.3** Kanon 1.0 = alle Dateien aus `git ls-tree -r K -- content/party/`, bytegleich und ohne Ausnahme. K = `der B-02-Commit aus STEUERUNG.md (V-18)`; beim FREIGABE-Weg ebenso K aus LAUF.md. `messbasis/kanon10.sha256` entsteht in BW0 aus K; eine neue Datei unter `content/party/schlosskeller/` ist rot. Der Leitstand prüft K vor dem main-Push.
- **L0.4** Würfelquelle (WÜ-1/WÜ-6): 0 verbotene Aufrufe.
- **L0.5** `lib/game/**` importiert aus `pixel_engine` nur `feinkorn_leben.dart`; Sperrnamen aus `planung/bollwerk/messbasis/sperrnamen.txt` (A-2 Definitionen).
- **L0.6** Release:
  - Der Importgraph ab `lib/main.dart` enthält 0 Dateien aus `lib/game/dev/**`, `tool/**` und `test/**`.
  - Im Phasentor: Release-Web-Build nach `rm -rf .dart_tool/flutter_build`; danach 0 Treffer für `Prüfstand|Modellschau|preview_main|look_anker` in `main.dart.js`.

**L1 Bestand:** `alle_tests.sh` und `pruefen.sh`.
- **Burgstadt-Schutz** (Diffs gegen `B` aus L0.2):
  - `layout_pruefsumme.dart --pruefe` meldet „LAYOUT GLEICH“; Diff leer auf `hd/belege/layout_ausgang.txt`, `tool/layout_pruefsumme.dart` und `packages/burgstadt_core/lib/src/welt/layout_pruefsumme.dart`
  - textPfade unverändert
  - `git diff --quiet $B HEAD -- assets/burgstadt assets/fonts`
  - `packages/burgstadt_core/bin/erkundung.dart`: Türen 134/134, 0 Steckenbleiber
  - `hd_migbeleg` bytegleich; eine gewollte HD-Änderung gilt erst nach „A12: ja“ (A4.4, MP-16 K6)

**L2 Eigenschaften:** Invarianten des Zugmodells. Generator über `Rng`; bei einem Fehler wird der Seed gemeldet.

**L3 Determinismus**
1. `kanon_einbetten.dart` erzeugt `packages/mordakte_core/test/web/kanon_eingebettet.g.dart`.
2. `determinismus_web_test` kommt ohne `dart:io` aus: 1.000 Codes, FNV über die kanonische JSON-Zeile je Zug.
3. Läufe: `dart test -p vm` und `PATH=/opt/node22/bin:$PATH dart test -p node`. Beide gleich und gleich der eingecheckten Liste.
4. Chrome nur im Phasentor, über `dart_test.yaml` mit `override_platforms` → `/opt/pw-browsers/chromium-1194/chrome-linux/chrome` und `--no-sandbox`.

**L4 Simulation:** C8 Nr. 1–9. Außerdem F:F-06 erschöpfend für die 9 Pflichtentscheidungen (< 60 s) und die Invariante „Restmenge je Zahl richtiger Pflichtentscheidungen unabhängig von Folgeentscheidungen, Abstechern und Würfen“.

**L5 Inhalt:**
- `textpruefer` für jede Datei der Schicht (Listen `gewalt`, `sperrliste`)
- Spoilerprüfung
- Füllstoff F1–F4
- Bild-Strukturtest: Requisitenarten, Teilchenfarben

**L6 Golden** im Paket `tool/bollwerk/look_anker/`
- Aufbau: `flutter_test: sdk`, `mordakte: path`.
- Schriften per FontLoader; Kanon per `dart:io`.
- Snapshot-Sitzung ohne Timer und Stopwatch; 120 × `game.update(1/60)`, dann Rendern in einen PictureRecorder, 1280×720 und 720×1280.
- Vergleich bytegleich, Laufzeit ≤ 60 s.
- Rot-Probe (1 px).
- `--update-goldens` führt nur Opus aus (A4.4).

**L7 E2E**
- Party (4/12/20), Solo und WLAN (Host-VM, 3 VM-Gäste, 1 Browser-Gast) × 4 Pfade, vom Titel bis zur Auflösung.
- 0 Konsolenfehler, 0 Anfragen außer localhost, ein Foto je Entscheidung.
- WLAN-Mitschnitt (C7).
- Neues `tool/bollwerk/e2e.mjs` mit `createRequire('/opt/node22/lib/node_modules/playwright')`.

**L8 Leistung** (CPU-Zeit je Bild, nie Bilder/s)
- **L8a:** 300 Bilder je Raum per PictureRecorder, Thread-CPU per `ffi`. Median ≤ 1,15 × Basis.
- **L8b:** `messen.mjs`, Klasse mittel (4×), 5 × 20 s im Wechsel A/B/A/B gegen den Basis-Build. Median ≤ 1,10 ×, p90 ≤ 1,20 ×.
- **Ruhemodus:** Last ≤ 0,15 nach ≥ 5 s Warten.
- Basis am B-02-Commit in `planung/bollwerk/messbasis/`.

**L9 Rot-Proben und Mutanten**
- **L9a:** `belege/rotproben.tsv` deckt 100 % der neuen Testdateien ab. Im Phasentor laufen 10 % davon erneut.
- **L9b Mutanten:**
  - Katalog `tool/bollwerk/mutanten/*.patch`, mindestens 40 Mutanten (Seed aus `FallCode.rng`, Pech-Garantie weg, Wurf ändert Fakt, Pech-Szene pfadabhängig, Stufe verschoben, Ruhemodus aus, Maler 1 px, Wortliste gekürzt, `|| true` im Tor, Release importiert `dev/`, Schwelle gesenkt je Messwerkzeug, Zählregel gelockert F2–F5 je einzeln).
  - Tötungsrate 100 % für Würfel, Lösbarkeit, Wahrheit, Inhalt und Bestandsschutz; ≥ 90 % gesamt.
  - Überlebende Mutanten werden Aufträge. Budget ≤ 40 min, nie parallel zu L8.

**L10 Gremien**
- Urteile stehen in `belege/gremium/<id>.json`: sha256 jedes gezeigten Bilds oder Texts, HEAD, Modell, Briefing-Hash, Eichlauf.
- Ändert sich ein Hash, verfällt das Urteil.


**L11 Abnahme** (nur `ziel`): je Z-Zeile aus Abschnitt 6 des Master-Prompts Befehl, Schwelle und Belegdatei aus `tool/bollwerk/abnahme.tsv` (maschinell aus der Tabelle erzeugt); jede fehlende oder rote Zeile macht `ziel` rot. L10 zählt Gremium-Stimmen aus den Agentenprotokollen (`~/.claude/projects/*/*/subagents/agent-<id>.jsonl`, agentId aus FLUG.md) nach.

**L12 Design** (`phase`: D1 und S1–S6; `nacht` und `ziel`: dazu D2 und D3): Belege schreibt nur das Torwerkzeug mit HEAD-Kopfzeile nach `belege/D1.txt`, `belege/S.txt`, `belege/D2.txt`, `belege/D3.txt`. Die Werkzeuge entstehen in BW0: `design_mass.dart` als Port von `proben/designmass.py`, `foto.mjs` aus `proben/foto_probe.mjs`, Eichsatz aus `proben/eichsatz.py`, Gleichheit aus `proben/bildgleich.py`; `stil.py` und `gremium.mjs` neu, je mit Rot-Probe. D- und S-Tests laufen nicht in Ring 7.
