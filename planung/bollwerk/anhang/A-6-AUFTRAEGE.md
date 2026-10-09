# A-6 · Aufträge: Paket-Bauplan, Rollen, Vorrat

## 1. Paket-Bauplan für Haiku (12 Teile, feste Reihenfolge)
1. **Kopfzeile:** `<Kennung> · <Rolle> · haiku · <Denkstufe> · Welle <w> · Kern <version> · Umfang <n Varianten> · Schwierigkeit <1|2>`
2. **Rollenbriefing** (Abschnitt 3 dieses Anhangs, mit den drei häufigsten Fehlern)
3. **Aufgabe in einem Satz**
4. **Projekt in fünf Sätzen** – wortgleich in jedem Paket:
   > Mordakte ist eine Flutter-App (iOS, Android, Web) mit Krimi-Fällen; der Fall „Spuk im Schlosskeller“ ist ein Partykrimi in 7 Kellerräumen mit 4 Täterfassungen, 9 Detektiv-Entscheidungen in 3 Runden und einem festen Kanon unter content/party/schlosskeller/. Der Spielkern liegt als reines Dart in packages/mordakte_core/lib/src/party/, die Darstellung als gezeichnetes Iso-Spiel in lib/game/** und lib/party/**. BOLLWERK macht das Spiel rundenbasiert mit Würfel, Party/Solo/WLAN, deutlich größer und schöner; neue Inhalte liegen als Schicht unter content/runden/schlosskeller/. Kanon 1.0 bleibt Byte für Byte unverändert; Inhaltsregeln: kein Alkohol, keine Drogen, kein Rauchen, kein Blut, Herr Schneider überlebt, Grusel mit Humor. Du arbeitest nur in den Pfaden deines Auftrags und meldest Fakten mit Pfad und Zeile.
5. **Kern-Auszug:** `anhang/A-3-KANON-AUSZUG.md` wörtlich im Paket (Text-, Daten-, Urteilsaufträge) bzw. als Kopie im Pool-Platz (Code-Aufträge), dazu nur die Kern-Aussagen, die der Slot braucht
6. **Qualitätsmaßstab** (A-8 §1.2: spürbare Folge, Bild/Witz/Grusel, konkrete Stufentexte, keine neuen Spuren)
7. **Grenzen**, mit diesem Absatz wortgleich:
   > Werkzeuge der Agenten: nur Read, Grep, Glob, Write, Edit und Bash. Nie: `mcp__claude-code-remote__*`, `mcp__github__*`; Agent, Workflow, SendMessage, TaskStop, Monitor, EnterWorktree, ExitWorktree, Skill; WebFetch, WebSearch, Artifact, `mcp__Claude_Docs__*`; nie ToolSearch. Du führst nie `git` aus und betrittst nie `$BW` oder einen anderen Checkout. Du schreibst nur die Dateien deines Auftrags. Keine Installation, kein Netzwerk. Heredocs nur mit `<<'EOF'`. Würfle nie selbst; Startwerte stehen im Auftrag.
8. **Nummerierte Schritte mit Mengen**
9. **Muster** (als Illustration gekennzeichnet; vielfältig; nie kopieren)
10. **Ausgabeschema** (JSONL nach `/home/user/bw-varianten/<welle>/<kennung>.jsonl`, Code als Datei im Pool-Platz)
11. **Selbstprüfung** (zählbar)
12. Letzte Zeile: `=== ENDE <Kennung> · BEREIT ZUR RÜCKGABE ===`

Rückgabe genau: `KURZ · <Kennung> · <gruen|teil|rot> · Varianten <n> · Selbstprüfung <m>/<n> · Datei <pfad> · Frage <ja|nein>` plus Endzeile. Berichte bis 1.800 Wörter nur bei Aufträgen der Art „Bericht“. Pakete der Stufe 3 gehen an Opus.

## 2. Ausgabeschema der Schicht-Varianten (erprobt in der Fabrikprobe)
`{"kennung","slot","art":"abstecher|folgeentscheidung|text|gag|aktion|element","raum","ort","runde","titel"(≤ 6 Wörter),"text"(8–40 Wörter),"aktion":{"art","weg":[orte],"pose","licht","klang","dauer_s":4–12},"wurf":bool,"stufen":{"erfolg","teil","pech"}|null,"folge":"<zeit±|marke|folge_abstecher|zusatz|helfer|gag>","zusatz":"<weißliste>|null","kanonbezug":[kennungen]}`; Bildschirmelemente zusätzlich `layout` (A-8 §1.3, Ring 4 statisch).

## 3. Rollen (Denkstufe aus der Fabrikprobe) und ihre drei häufigsten Fehler
| Rolle | Modell · Stufe | Häufigste Fehler |
|---|---|---|
| Variantenbauer (Abstecher, Folgeentscheidungen, Gags, Texte) | haiku · max (Gags auch medium) | Wirkung fehlt; Kennungen erfunden; neue Spuren an Kanon-Orten |
| Kartenschreiber (Entscheidungs- und Würfelkarten) | haiku · max | Chancen je Option verschieden; Fachwörter; Sätze > 25 Wörter |
| Kettenbauer (Folgeentscheidungen mit Ketten) | haiku · max | lösungsrelevante Andeutung; Kette ohne Abschluss; Pfadunterschied |
| Aktionsanimator / Posenmaler | haiku · max (Daten), Opus (Maler-Code, Stufe 3) | Pose nicht im gezeichneten Stil; liegen/stürzen; Iso-Winkel gebrochen |
| Requisitenmaler | haiku · max | Flaschen/Fässer; Umwidmung; Fremdfarbe |
| Lebenbauer (Teilchen, Licht, Klang) | haiku · max | Teilchen > 3 px; Flamme; Physik im Ruhezustand |
| Würfelmeister (Würfeltabellen) | haiku · max | Chance korreliert mit „richtig“; Modifikator an Option; Band verlassen |
| Simulant / Probeläufer | haiku · max | eigener Zufall statt Seed; Zählweise unklar; Ergebnis ohne Partienzahl |
| Testschreiber | haiku · max | Test ohne Rot-Probe; `skip`; zeitabhängig unter Last |
| Szenenprüfer / Sichtprüfer | haiku · max | Bild nicht geöffnet; Dateiname als Hinweis; Dunkelheit als Fehler |
| Kanonwächter | haiku · max | Weißliste mit Kettenglied verwechselt; Tatzeit übersehen; Kennung ↔ Anzeigename vertauscht |
| Sprachprüfer | haiku · medium | Satzlänge nicht gezählt; Siezen übersehen; Fachwort übersehen |
| Messer / Kundschafter | haiku · medium (Zählen), max (Fakten) | schätzen statt zählen; Fundstelle fehlt; falscher Baum |
| Richter (Ring 7, D2, D3) | haiku · max | alles 6–7; Füllstoff durchwinken; Linse vergessen |
| Angreifer / Gegenprüfer | haiku · max | Befund ohne Beleg; Schwere übertrieben; Ersatztext fehlt |
| Bestandswächter / Leistungsprüfer | haiku · medium | unter Parallellast messen; Basis neu geschrieben; Ausnahme ohne „A<n>: ja“ |
| Advocatus (Mutanten) | haiku · max | Mutant kompiliert nicht; nur triviale Mutanten; Mutant committet |

## 4. Auftragsvorrat (Schablonen mit Parametern; Abdeckung ≥ 1,5 × Nachtkapazität)
| Schablone | Typ | Parameter | Hoheit vor / nach B-02 | Prüfung |
|---|---|---|---|---|
| `ABST-<raum>-<runde>-<nn>` | T | 7 Räume × 3 Runden × je 12 Varianten | `content/runden/` / dto. | Ringe 0–8 |
| `FOLGE-<entscheidung>-<nn>` | T | 9 Pflichtentscheidungen × je 12 | dto. | Ringe 0–8 |
| `GAG-<raum>-<nn>` | T | 7 Räume × je 12 je Welle, `nn` fortlaufend bis der Planzuwachs (PLAN §1, +397) gedeckt ist | dto. | Ringe 0–8 |
| `TEXT-<ort>-<stufe>` | T | 43+ Orte × 3 Stufen | dto. | Ringe 0–8 |
| `ORT-<raum>-<nn>` | T | 7 Räume × je 12 Teilorte je Welle, `nn` fortlaufend bis +129 gedeckt ist | dto. (Koordinaten prüft Opus am Raumgraph) | Ringe 0–8, L4 |
| `POSE-<figur>-<haltung>` | B/C | 22 Figuren × 8 Haltungen | `lib/runden/` / dto. | Ring 4, L6, Ring 7 (Aktions-Rubrik) |
| `AKTION-<art>` | C (Stufe 3 an Opus) | 45 Aktionsarten | `lib/runden/` | Ring 4, L6, L8 |
| `REQ-<art>` | B/C | 23 ungenutzte Requisitenarten | nach B-02 `lib/game/scene/` nur additiv | Ring 4; Stil über L12 |
| `TEST-<baustein>` | C | je neuer Datei | `test/runden/` | L9a Rot-Probe |
| `MUT-<bereich>` | C | ≥ 40 | `tool/bollwerk/mutanten/` | L9b |
| `RICHTER-<linse>-<welle>` | U | 3–5 je Stapel ≤ 100 | – | F5-Eichung |
| `ANGRIFF-<linse>` | U | 10 Linsen | – | Prüfrunde |

`dart run tool/bollwerk/vorrat.dart naechste --typ <T|C|B|U> --n <k>` gibt die nächsten Aufträge aus und trägt sie in FLUG.md ein. Fällt der Vorrat eines Typs unter 1 h, kommt im selben Zug Nachschub aus Umfangslücken, roten Tests, überlebenden Mutanten und Befunden.

## 5. Wellen
- Eine Welle = gleichzeitig gestartete Hintergrund-Agenten (Agent-Werkzeug, `run_in_background`), höchstens 12 (bis B-02: 6). Agenten einer Welle teilen Modell, Denkstufe, Werkzeuge und Schema.
- Je Bauer 10–25 Varianten; je Richter Stapel bis 100 Bausteine.
- FLUG.md wird **vor** jedem Start geschrieben: Kennung, Typ, agentId (aus dem Startergebnis), Start (echte Uhrzeit), erwartetes Ende, Ausgabedatei, Pool-Platz.
- Nach jeder Rückgabe: Werkzeug-Audit (Ring 0), dann Ringe 1–6 als Skript, Ring 7 je Stapel, Ring 8 je Welle.
- Drossel: Ausfälle > 10 % einer Welle → Gleichzeitigkeit halbieren; nach 30 ruhigen Minuten +25 %. Annahmequote eines Typs 2 Wellen lang < 30 % → Briefing einmal überarbeiten (Vorbild Fabrikprobe: 18 % → 58 %), sonst Typ streichen.
- Opus übernimmt höchstens 2 gescheiterte Pakete je Stunde; sonst zurück in den Vorrat mit Befund.
