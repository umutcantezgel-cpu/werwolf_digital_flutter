# META-ANHANG A · Was der Master-Prompt enthalten muss

> Dieser Anhang ist die Spezifikation des Master-Prompts BOLLWERK.
> - **A1–A3:** gehen inhaltlich unverändert in den Master-Prompt.
> - **A4:** sind die harten Regeln; sie gehen vollständig hinein.
> - **A5:** Lehren aus früheren Läufen.
> - **A6:** beschreibt Abschnitt für Abschnitt (MP-0 bis MP-20), was der Master-Prompt mindestens enthält.
>
> Im Master-Prompt gilt die Abschnittszuordnung aus META-PROMPT v4 §8.2 und `v4/LUECKEN-v3-v23.md` §5 (u. a. MP-7 → Abschnitt 6 UMFANG, MP-14 → 7, MP-12 → 8, MP-16 → 12 „BEREIT FÜR MAIN“); „MP-n“ ist nur die Kennung in diesem Anhang. Kürzel und §-Nummern des Finalisierungs-Laufs werden mit „F:“ zitiert (z. B. F:F-06, F:§7.7, F:§7.13). Kanonregeln behalten ihre Namen ohne Präfix (W-1, S-1, D-1, G-1, K-1, P-1). Die Umfangsachsen heißen X1–X6. `P/` steht für `planung/finalisierung-schlosskeller/` auf `origin/finalisierung-schlosskeller`; B1–B10 sind Abschnitte von Anhang B, C1–C8 von Anhang C.


> **Vorrang v4 (gilt vor jeder Stelle dieses Anhangs).** Dieser Anhang stammt aus v2.3. Für den Dauerlauf mit Leitstand gelten diese Änderungen; sie gehen so in den Master-Prompt ein (META-PROMPT v4 §8.2):
>
> | # | Thema | gilt jetzt |
> |---|---|---|
> | V-1 | main | Der Nachtlauf pusht nie auf main. Er endet mit `ZUSTAND: BEREIT FÜR MAIN` (MAIN-REIFE nach v4 §8.2 Abschnitt 6). MP-16 „Push auf main“ ist das Verfahren des **Leitstands** und des Merge-Baus (`bollwerk-mc`). |
> | V-2 | Tags | Der Git-Proxy lehnt Tags ab (BELEGE C3). Es gibt keine Tags. Archive (`archiv/<linie>-<sha7>`, `archiv/vor-bollwerk`) sind **Branches** und gehören dem Leitstand. `bollwerk-1.0` wird als fertiger Befehl unter FUER-DEN-NUTZER notiert. |
> | V-3 | Push-Ziel | Der Nachtlauf pusht ausschließlich `git push origin HEAD:refs/heads/bollwerk`. |
> | V-4 | B-02 | ohne Tag, nach v4 §8.2 Abschnitt 2.2; K (Kanon-1.0-Bezug, L0.3) ist der B-02-Commit, notiert in LAUF.md. „FREIGABE BOLLWERK“ kommt nur als Eintrag in STEUERUNG.md. |
> | V-5 | Herzschlag | Der Nachtlauf legt **keine** Routine an (`create_trigger` nie). Er weckt sich nur mit `send_later` (Name `BOLLWERK-G<n>-<session_id>`). Die stündliche Routine gehört dem Leitstand. |
> | V-6 | Lauf-Sperre | statt „Orchestrator … · Herzschlag“ gilt LEASE `gen=<n> session=<id> herzschlag=<UTC>` in `planung/bollwerk/LAUF.md`; die höhere Generation gewinnt. |
> | V-7 | Steuerung | Bei jedem Prüfpunkt `origin/bollwerk-leitstand:planung/bollwerk/leitstand/STEUERUNG.md` und `BEFUNDE.md` lesen und quittieren. „A<n>: …“ des Nutzers kommt über STEUERUNG.md. |
> | V-8 | Bilder | Kontaktbögen als Dateien unter `planung/bollwerk/bilder/<datum>/`; der Leitstand zeigt sie im Chat. SendUserFile im Nachtlauf nur zusätzlich. |
> | V-9 | Ende | Zugende-Zeile `=== BOLLWERK-ZUG-ENDE · <ZUSTAND> · Weckruf <UTC> ===`; Generationsfenster ≤ 12 h; Morgenbericht als Datei bis 06:30. |
> | V-10 | Einstellungen | Keine Sperrdatei, keine Umgebungsvariablen, keine Änderung an `.claude/**`. Jeder Agentenaufruf nennt sein Modell. |
> | V-11 | Autostart | Den Autostart aus v2.3 gibt es nicht mehr; Generationen startet der Leitstand. |
> | V-12 | Altregeln entfallen | MP-18 „90-min-Übernahme“, MP-11 „Routine + 30-min-Kette“, der Name `BOLLWERK-SL-…`, MP-19 Schritte „Herzschlag stellen“ und „worktree add“, MP-2 Weg (c) und das Tor `phase` als MAIN-Kriterium. Es gilt nur LEASE nach v4 §8.2 Abschnitt 2.5; das Alter eines Herzschlags berechtigt nie zur Übernahme. |
> | V-13 | Stolperdraht | Erwartet und nur ins NACHTPROTOKOLL: Vorwärtsbewegungen von `bollwerk-leitstand` (nur `planung/bollwerk/leitstand/**`), die neuen Refs `archiv/*`, `bollwerk-mc`, `bollwerk-plan`, `bollwerk-probe`, `bollwerk-rueckweg`, Commits des Nachtlaufs Burgstadt und der Finalisierung. „Eigene Tags“ entfällt. |
> | V-14 | HD-Linie | `caf1d61` wird im Vorlauf **nicht** gemergt. Gemergt wird sie erst, wenn im Wegwerf-Worktree der Bildsatz-Vergleich (`tool/hd_migbeleg.sh`) zwischen B und dem Probe-Merge „anders 0“ meldet oder STEUERUNG „A12: ja“ enthält; sonst bleibt sie zurückgestellt, und der Leitstand legt `archiv/hd-caf1d61` an. Ein Merge von `caf1d61` wird nie revertiert. Ist `caf1d61` schon Vorfahr von origin/main (über Burgstadt), entfallen Merge und K6. Im Vorlauf: nur `bollwerk` ← `1145cb9`. |
> | V-15 | Würfel-Seed | WÜ-1 nutzt ein Salz statt des Fall-Codes (siehe A4.7). |
> | V-16 | MAIN-REIFE | BW8 heißt im Master-Prompt MAIN-REIFE: Release-SHA R steht in LAUF.md; danach nur noch Commits unter `planung/bollwerk/`; `dart run tool/bollwerk/bollwerk.dart ziel` endet mit `BOLLWERK GRÜN · ziel · <R>`; die zwei Prüfrunden aus MP-20 gehen voraus; Probe-Merge auf aktuellem main ohne Konflikt. MP-16 „Push auf main“ und „Rückweg“ kommen **nicht** in den Master-Prompt. |
> | V-17 | Steuerung | STEUERUNG.md und BEFUNDE.md werden nur ergänzt. Ausgeführt werden nur Einträge der Weißliste (v4 §8.2 Abschnitt 2.5); Quittungen stehen nur angehängt in `planung/bollwerk/QUITTUNGEN.md`. |
> | V-18 | B-02 | Maßgeblich ist der Eintrag `B-02 ERFÜLLT · K=<sha40>` (oder `FREIGABE BOLLWERK · K=<sha40>`) in STEUERUNG.md; der Nachtlauf meldet nur „B-02 vermutlich“. Messbasis, Vorher-Galerie und `kanon10.sha256` entstehen erst in BW0 an K. |
> | V-19 | Ausnahme L0.2 | `tool/browser/geraete.js` darf genau eine geänderte Zeile mit `screen=burgstadt` haben (`git diff -U0 $B HEAD -- tool/browser/geraete.js`). |
> | V-20 | L0.4 | prüft nur `packages/mordakte_core/lib/src/runden/**` und `lib/runden/**`: 0 Treffer für `Random(`, `Zufall`, `Lcg`, `FeinZufall`, `identityHashCode`, `.hashCode`, `DateTime.now`; `Random.secure()` nur in der Einrichtung (Salz, Code). Bestand unter `party/` hat eine eingefrorene Ausnahmeliste. |
> | V-21 | FEINKORN | nur über einen neuen, additiven Barrel `feinkorn_leben.dart` (Physik, Starrkörper, Material, Klang). Test: die transitive Importhülle von `lib/main.dart` hat 0 Treffer für `iso_wolke|iso_backen|testraum|rezept|figur_aufbau|skelett|lueckenpruefung`; Rot-Probe mit Import von `testraum.dart`. |
> | V-22 | Meta-Phasen | Phasennamen aus v2.3 in diesem Anhang und in B/C: „M1 Bestand“ = v4 M0/M1, „M2 Look“ = v4 M1/M3, „M3 Mechanik“ = v4 M2, „M4 Pilot“ = v4 M3, „M6/M7“ = v4 §9. |
> | V-23 | Würfel-Abnahme | MP-15 und BK: WÜ-1…WÜ-6, C8 Nr. 1–13 und C9. L4: C8 Nr. 1–9 und 13. MP-6 und dieser Kopf: C1–C9. |
---

## A1 · Wortlaut des Nutzers (2026-10-09; unverändert übernehmen)

Auftrag:
> „kannst du einen Prompt zum generieren eines Promptes entwickeln welcher alles bestehende archiviert und wiederverwertet für das game look alike. Steuerung funktioniert über rundenbasierte folgen von entscheidungen welche den Charakter entsprechende aktionen durchführen lässt wie in den keller gehen sowie ein Luck (Würfel) System für den effekt der entscheidungen manchmal. Der Prompt der dein Prompt entwickeln soll soll dich über Stunden beschäftigt halten so das du die ganze nacht mit tausenden Haikiu 5.5 Varianten in Ulttracode ein Bollwerk schaffen kannst um das game zu finalisieren!“

Präzisierung:
> „erstelle einfach den Prompt zum entwickeln des Prompts um nach seinen arbeiten das Spiel um den Faktor 10X-100X zu erweitern und das Design signifikant aufzuwerten sowie alles sauber auf main zusammenzuführen und bestehende arbeiten wiederzuverwerten mit dem design wofür wir uns jetzt entschieden hatten“

Gewählte Optionen (die Texte stammen aus der Auswahl, die Claude angeboten hat):

| Frage | Gewählte Option |
|---|---|
| Würfel | **„Stark“**: „Der Würfel entscheidet auch, ob eine Untersuchung gelingt. Misslingt sie, gibt es einen zweiten Anlauf oder einen Umweg; lösbar bleibt der Fall.“ |
| Spielformen | **Party an einem Gerät, Solo mit Bots, WLAN-Mehrspieler** |
| App-Start | **„Schlosskeller als Start“**: „Die App öffnet das Schlosskeller-Rundenspiel. Burgstadt und die klassischen Fälle bleiben über ein Menü erreichbar.“ |
| Look (früher) | **„Bild-Look + Leben“** (E-F021) |

Weitere Aussagen des Nutzers:
- „starte alle agenten gleichzeitig“
- „zeig mir die bilder immer im chat wenn du welche machst“

---

## A2 · Feste Entscheidungen BE-01 … BE-14

| Nr. | Entscheidung |
|---|---|
| BE-01 | **Bild-Look + Leben.** Der Look des Referenzbilds bleibt (B3). Räume und Figuren werden nie aus Pixel-3D-Blöcken gebaut. FEINKORN-Technik dient nur als Leben (Physik, Teilchen mit Ablagerung, Material, Klangfamilien) und als Gelenkgerüst-Konzept für Posen im gezeichneten Stil. Pixel-Teilchen ≤ 3 px nur für Splitter und Staub. |
| BE-02 | **Nach dem Finalisierungs-Lauf.** Der Hauptlauf beginnt erst, wenn die Startbedingung (MP-2) erfüllt ist. Vorher arbeitet der Nachtlauf im Vorlauf V. |
| BE-03 | **Umfang 10–100×** über den Umfangsindex U (MP-7), gemessen gegen die Basis am B-02-Commit. |
| BE-04 | **Design deutlich sichtbar aufwerten** im Rahmen von BE-01. Nachweis: Strukturmaße, Stilprüfung, blinder Paarvergleich (MP-8). |
| BE-05 | **Alles sauber auf main.** Jede Linie der Klasse *zusammenführen* oder *teilweise übernehmen* kommt grün auf main. Jede Linie steht mit Ref und SHA in ARCHIV.md. Kein Branch wird gelöscht, nichts geht verloren (MP-16). |
| BE-06 | **Würfel stark** nach A1, mit Pech-Garantie und unantastbarer Kanon-Wertung (WÜ-1 … WÜ-6). |
| BE-07 | **Drei Spielformen:** Party an einem Gerät, Solo mit Bots, WLAN über das vorhandene `room_host`. |
| BE-08 | **App-Start Schlosskeller.** Burgstadt und die klassischen Fälle bleiben über ein Menü erreichbar. Ein Schalter stellt den Start zurück auf `/burgstadt`; er bleibt auch nach der Abnahme. |
| BE-09 | **Bilder:** Jedes erzeugte Bild geht in den Chat, gebündelt als Kontaktbogen (≤ 48 Kacheln). Höchstens 6 Bögen je Stunde. Nur Opus sendet. |
| BE-10 | **Keine Rückfragen, kein Warten.** Opus entscheidet per Denkprotokoll und trägt ins `ENTSCHEIDUNGSLOG.md` ein. Gestalterisches, das der Nutzer entscheiden sollte, kommt sofort nach `FUER-DEN-NUTZER.md` (Frage, Standardwahl, Folge), und die Arbeit geht mit der Standardwahl weiter. Haiku entscheidet nichts: Es schreibt OFFENE FRAGE, Opus entscheidet. |
| BE-11 | **Gleichzeitig:** Unabhängige Agenten starten gemeinsam, aber nie über die gemessene Kapazität hinaus. |
| BE-12 | **Druckspiel bleibt** Kanon-1.0-Schicht ohne Würfel, wortgleich (F:F-10, F:F-14). |
| BE-13 | **Licht und Nebel.** Nebel des Krieges nach F:§7.13 (`P/MASTER-PROMPT.md`) ist Pflicht (B2); auf `fin` ist er seit F4 gebaut. Für den Lichtzustand der Runden gilt der Kanon vor dem Look. Den Widerspruch „Strom an ab 00:00“ gegen „Stromausfall-Look“ legt M1 mit Standardwahl in ANNAHMEN.md (Standard: Kanon). |
| BE-14 | **Kanon-1.0 unantastbar.** Wachstum nur als Schicht in `content/runden/schlosskeller/` (MP-7). Keine neuen Bereiche außerhalb der 7 Räume (C5). |

---


### A2a · Annahmen (Standardwahl, kippbar mit „A<n>: …“)
| Nr. | Entscheidung | Standard |
|---|---|---|
| A-01 | Design-Richtung | beste Richtung aus der Design-Probe (mit Bild) |
| A-02 | Lichtzustand der Runden | Kanon |
| A-03 | Würfel und Kanon-Punkte | Würfel kostet nie Kanon-Punkte |
| A-04 | neue Fälle | nur Schichten, keine neuen Fälle oder Täterpfade |
| A-05 | Spieldauern | Abend Median ≤ 150 min, Runde Median ≤ 6 min |
| A-06 | Joystick | im Partymodus aus, sonst unverändert |
| A-07 | WLAN-Host | Gerät des Detektivs |
| A-08 | Musik | keine |
| A-09 | Gewichte g | 3, 2, 1, 1, 1, 2 (aus v2.3, in M1 geprüft) |
| A-10 | Design und Umfang | gleichrangig |
| A-11 | Zwischenziel je Nacht | ja, je Achse in Einheiten |
| A-12 | HD-Linie `caf1d61` | nur mergen, wenn die Burgstadt-Bilder bytegleich bleiben; sonst zurückgestellt bis „A12: ja“ |
| A-13 | Sperrdatei mit Verboten (`.claude/settings.json`, nur `permissions.deny`) auf `bollwerk` | keine (die Modellangabe je Aufruf gilt); mit „A13: ja“ legt der Leitstand sie an |

## A3 · Begriffe und Deutung (verbindlich)

**Wörter des Nutzers**

| Wort | Bedeutung |
|---|---|
| „game look alike“ | Der Look des Referenzbilds `origin/kern-feinkorn:planung/feinkorn/bilder/k0/vorher_buffetsaal.png`. **Das Bild ist der Anker, nicht seine Beschreibung.** Iso 2:1, gezeichnete Figuren, Steinboden, Holzwände, dunkler Rand. Er wird weiterentwickelt, nicht ersetzt. Joystick und Aktionsknopf gehören nicht zum Look. |
| „Design signifikant aufwerten“ | Deutlich sichtbar, nicht statistisch. Belegt durch D1 Strukturmaße + D2 blinder Paarvergleich + D3 Eichung (MP-8), ohne Stilbruch (Stilprüfung S1–S5). |
| „rundenbasierte Folgen von Entscheidungen“ | Spieler steuern über Entscheidungen je Runde. Ketten: Ein Ergebnis öffnet Folgeentscheidungen. Die 9 Kanon-Entscheidungen bleiben die einzigen wertenden. Alles andere wächst als nichtwertende Folgeentscheidungen und Abstecher. Der Echtzeit-Joystick ist nicht mehr die Spielsteuerung; ob er als Zusatz bleibt, ist Annahme A-06. |
| „Aktionen … wie in den Keller gehen“ | Jede Entscheidung löst eine sichtbare Aktion der Figur aus (C1, C5): Weg über A*, Pose, Licht, Fundkarte. „In den Keller gehen“ zeigt wörtlich der Abstieg über die fünf Sandsteinstufen im Intro, dazu der Abstecher über die Wendeltreppe und die Raumwechsel. |
| „Luck (Würfel) … manchmal“ + „Stark“ | Bei 30–60 % der Züge einer Partie fällt ein offener Wurf. Er entscheidet über das Gelingen jedes Anlaufs; Pech heißt zweiter Anlauf oder Umweg. Die Kanon-Wertung (Punkte, Ende) bleibt unberührt (WÜ-4). Der Fall bleibt garantiert lösbar (WÜ-3). |
| „10X–100X erweitern“ | Umfangsindex U ≥ 10 (Streckziel 100) über Wachstumsachsen, dazu absolute Pflichtziele für Achsen mit Basis 0 oder Obergrenze. Kanonfeste Achsen haben Faktor 1 (MP-7). Umfang heißt Breite und Wiederspielwert, **nicht** längere Abende. Nie Füllstoff (Füllstoffprüfung F1–F5). |
| „alles bestehende archiviert und wiederverwertet“ | Jede Linie steht mit Ref und SHA in ARCHIV.md. Archiviert wird an Ort und Stelle; nichts wird verschoben. Wiederverwertung belegt je Linie ein Übernahme-Commit `aus <ref>@<sha>:<pfad>` oder eine begründete Absage. |
| „alles sauber auf main zusammenführen“ | MP-16: echte Merges mit `--no-ff`, nie `-s ours`, nie Squash, Rebase oder Cherry-pick ganzer Linien. Voller Prüflauf grün, Vorfahrtests, Burgstadt-Schutz, kein Force-Push. |
| „Bollwerk“ | Ein großes, belastbares Gesamtwerk für das Spiel: (1) eine breite Variantenproduktion, aus der nur Geprüftes ins Spiel kommt; (2) eine Prüfmauer mit dem Torwerkzeug `tool/bollwerk/bollwerk.dart` (MP-14). Die Mauer wächst mit dem Spiel. Ab BW1 gehen höchstens 20 % der Agentenaufrufe in Prüfwerkzeuge. |
| „tausende Haiku 5.5 Varianten“ | Zwei Zähler: Haiku-Agentenaufrufe und Varianten. Ziel für beide: vierstellig je Nacht. Liegt die gemessene Kapazität darunter, nutzt der Lauf die Hebel aus MP-11; sonst nennt der Morgenbericht die ehrliche Zahl und den Grund. |
| „die ganze Nacht“ | Kein Leerlauf von Start bis Morgenbericht. Morgenbericht zur Zeit M = spätere von 07:00 Berlin und T0 + 8 h. |

**Begriffe des Laufs**

| Begriff | Bedeutung |
|---|---|
| Variante | Ein Kandidat, den ein Agent erzeugt hat und der ein Urteil hat: verworfen durch das Filterskript oder bepunktet durch das Gremium. „Übernommen“ heißt: im Code oder in den Daten. |
| Linie | Ein Arbeitsstrang mit eigener Ref oder eigenem Ordner (B1). Die 41 `loop/epoch-*` zählen als eine Linie. Klassen: *Basis* (`origin/main`; die Finalisierung gilt bis B-02 als *läuft*, danach als Basis) · *zusammenführen* · *teilweise übernehmen* · *nur archivieren* · *eingefroren* (für BOLLWERK unantastbar, kann für sich selbst weiterlaufen, z. B. der Nachtlauf Burgstadt). |
| Hoheit | Über einen Pfad hat Hoheit, wer ihn als Einziger ändern darf. |
| Vorlauf V | Arbeit vor erfüllter Startbedingung, nur in eigenen Pfaden. |
| Hauptlauf | Phasen BW0 bis BW8 nach erfüllter Startbedingung. |
| T0 | Startzeit des Nachtlaufs (echte Uhrzeit im PRUEFPUNKT). |
| M | Zeit des Morgenberichts: die spätere von 07:00 Berlin und T0 + 8 h. |
| B-02 | Die Startbedingung des Hauptlaufs (Befehl in MP-2). Der Name stammt aus BE-02. |
| MC | Der Merge-Commit, der auf main soll (MP-16). |

---

## A4 · Harte Regeln (vollständig in MP-4; sie werden nie abgewogen)

### A4.1 Git und Push
- **Verboten** sind Force-Push, umgeschriebene Geschichte auf geteilten Branches, gelöschte Remote-Branches und überschriebene Tags. Das schließt ein: `--force`, `--force-with-lease`, `+ref`, `--all`, `--mirror`, `--tags`, `--follow-tags`, `--delete` bzw. `:ref`, gelöschte oder verschobene Tags.
- **Push-Ziele (abschließende Liste):**
  - `refs/heads/bollwerk`: jederzeit
  - Nachtlauf: nur `refs/heads/bollwerk` (V-3)
  - Leitstand: `refs/heads/archiv/*` (neu, nie verschoben), `refs/heads/bollwerk-leitstand`, am Ende `refs/heads/main` nach MP-16 (V-1, V-2)
  - Tags gibt es nicht (V-2)
- **Form:** `git push origin <sha>:refs/heads/<ziel>`. Nie ein Push auf `finalisierung-schlosskeller`, `kern-feinkorn`, `claude/*`, `nachtlauf/*` oder `loop/*`.
- **Abgelehnter Push:** „Lehnt origin einen Push ab, weil jemand anderes gepusht hat: holen, zusammenführen, alles neu testen, erneut pushen. Höchstens drei Anläufe.“ Für `bollwerk` heißt „alles neu testen“: das Tor der laufenden Phase (`bollwerk.dart schnell` bzw. `phase`). Für main gilt nur MP-16 Schritt 5.
- **Schutzregel:** „Erzwingt eine Schutzregel Pull Requests, pushst du den Arbeitsbranch und öffnest einen Pull Request mit dem Abschlussbericht.“ Der Hinweis „nur Merge-Commit, kein Squash oder Rebase“ steht darin. Es gibt keinen Tag, und der Lauf endet mit BEREIT ZUR INTEGRATION.
- **Staging** nur mit `git add -- <pfade>`. Nie `-A`, `.`, `-u`, `-f`, `commit -a`.
- **Commits:** „Jeder Commit baut und testet grün.“ Commits laufen über `tool/bollwerk/commit.sh` (Muster `tool/hd_commit.sh`): Branch-Prüfung, Pfadliste, Schutzpfade, Schnelltor im sauberen Worktree, Secret-Scan, Push mit ausdrücklichem Ziel. `tool/commit_gruen.sh` (`git add -A`, fest auf `nachtlauf/burgstadt`) wird nie benutzt.
- **Fremde Linien** werden nur in `bollwerk` hereingeholt, nie umgekehrt. Einzige Ausnahme ist der Merge-Commit MC für main (MP-16).
- **Arbeitsorte:** nur `$BW` (der Sitzungs-Checkout auf `bollwerk`) und die Worktrees, die dieser Lauf angelegt hat. Nur lesbar sind jeder andere Checkout und jeder andere Worktree.
- **Lokaler `main`** wird nie benutzt. Maßgeblich ist immer `origin/main` nach `git fetch`.

### A4.2 Werkzeuge
- **Haiku-Agenten** benutzen nur Read, Grep, Glob, Write, Edit und Bash. Write und Edit nur in den Dateien ihres Auftrags.
  - Nie, auch nicht zum Ausprobieren: `mcp__claude-code-remote__*`, `mcp__github__*`, Agent, Workflow, SendMessage, TaskStop, Monitor, EnterWorktree, ExitWorktree, Skill, WebFetch, WebSearch, Artifact, `mcp__Claude_Docs__*`.
  - Nie `git`: Pool-Plätze haben kein Git (A4.9).
  - Kein `flutter build`, kein Commit, kein Push.
- **Opus** nutzt:
  - Agent und Workflow für eigene Aufträge
  - **Herzschlag:**
    - **Nachtlauf (V-5):** keine Routine. Weckruf nur mit `send_later`, Name `BOLLWERK-G<n>-<session_id>`. (Die frühere Routinen-Regel gilt nur noch für den Leitstand.)
    - Die ID kommt sofort aus dem Ergebnis in den PRUEFPUNKT.
    - `update_trigger` und `delete_trigger` nur für IDs aus dem PRUEFPUNKT, und nur, wenn `get_trigger` genau diesen Namen zeigt.
    - Nie anhand von `list_triggers` ändern oder löschen. Im Zweifel stehen lassen und in FUER-DEN-NUTZER eintragen.
  - `list_triggers` und `get_trigger` nur lesend
  - im PR-Weg genau einmal einen Pull Request
  - SendUserFile für Kontaktbögen
- **Nie** (auch Opus nicht):
  - `push_files`, `create_or_update_file`, `delete_file`, `create_branch`, `merge_pull_request`, `enable_pr_auto_merge`, `update_pull_request_branch`
  - `create_session`, `send_message`, `interrupt_session`, `archive_session`, `fire_trigger`, `update_trigger` für fremde Routinen, `watch_url`, `add_repo`
  - fremde Routinen oder Sitzungen ändern, feuern, unterbrechen, archivieren oder löschen. `delete_trigger` löscht auch Sitzungen, die eine Routine gestartet hat.
- Änderungen am Repo laufen nur über `git` im Worktree, mit Secret-Scan.
- Dieser Absatz steht wortgleich in Teil 8 jeder Auftragsvorlage.

### A4.3 Bestandsschutz
- „Diese Einstellungen fasst du nicht an: Build, Signatur, Store-Einträge, Berechtigungen, App-Kennung und Versionsnummer.“ Die Version `0.1.0+1` bleibt.
- „Du lädst nichts in die Stores hoch.“
- „In die App kommen keine neuen Abhängigkeiten.“ Keine neue Zeile unter `dependencies`, `dev_dependencies` oder `dependency_overrides` in `pubspec.yaml`, `packages/*/pubspec.yaml` und `server/pubspec.yaml`. L0 prüft das mit `git diff -U0 $B HEAD -- <diese Dateien>` (B aus L0.2). Golden-Tests laufen im eigenen Paket `tool/bollwerk/look_anker/` (MP-14).
- Werkzeug-Pakete gibt es nur in `tool/bollwerk/**`, und nur, wenn Paket und Version schon in einer `pubspec.lock` des Repos stehen (dann kein neuer Download). Sonst weglassen und in FUER-DEN-NUTZER eintragen. Jede Übernahme steht mit Begründung im ENTSCHEIDUNGSLOG und in `planung/bollwerk/LIZENZEN.md`.
- „Die App verbindet sich mit nichts Neuem; bestehende Verbindungen bleiben, wie sie sind.“ „Zur Laufzeit lädt das Spiel nichts von fremden Servern.“ Web-Builds immer mit `--no-web-resources-cdn`.
- „Bestehende Funktionen, Daten und Speicherstände bleiben erhalten. Was du ersetzt, bleibt über einen Schalter erreichbar, bis die Abnahme bestanden ist.“
- „Werkzeuge, Prüfstand und Modellschau erscheinen nie in der veröffentlichten App.“
- Netzwerk nur für Git mit dem bestehenden `origin` und zum Installieren der Abhängigkeiten, die das Projekt schon hat. Keine neuen Remotes, kein Deployment, kein Hochladen zu fremden Diensten.
- „Du arbeitest nur im Repo-Ordner und installierst nichts systemweit“: kein `npm -g`, kein `pip install`, kein `pub global`. `build.sh` wird nie lokal ausgeführt.
- Schriften, Bilder und Klänge liegen im Projekt.

### A4.4 Umgehungsverbot und Kriterien
- „Ginge etwas nur gegen die Grenzen oder wird eine Aktion blockiert, lässt du sie weg, notierst sie unter FÜR-DEN-NUTZER und arbeitest am Rest weiter.“
- **Keine Umgehung:** kein `dangerouslyDisableSandbox`. Keine Änderung an `.claude/**`, `settings*.json`, `CLAUDE.md`, Git-Konfiguration oder Hooks. Keine Skills, die Einstellungen schreiben. Kein Ausweichen auf die GitHub-API.
- „Kein Kriterium wird still abgesenkt.“ Kriterien und Schwellen ändert der Nachtlauf nie. Kürzen nur über die Kürzungsleiter (MP-12), mit Eintrag.
- **Vergleichsstände** entstehen einmal (in BW0) und werden nie neu geschrieben, um ein Tor grün zu machen. Das gilt für `layout_pruefsumme.dart --schreibe`, `hd/belege/layout_ausgang.txt`, `bestand.dart --schreibe`, `--update-goldens` und die Simulator-Sollwerte.
- **Eingefroren ab dem BW0-Commit** (SHA im PRUEFPUNKT) sind `planung/bollwerk/messbasis/**`, `planung/bollwerk/BESTAND-AUSNAHMEN.txt` und die D3-Lösung. `belege/rotproben.tsv` bekommt nur neue Zeilen. L0.2 prüft `git diff <BW0> HEAD -- <diese Pfade>` (bei `rotproben.tsv` nur entfernte Zeilen).
- Eine neue Bestandsausnahme oder eine „gewollte HD-Änderung“ gilt erst nach der Antwort „A<n>: ja“ des Nutzers; bis dahin ist das Kriterium rot.
- Neue Look-Anker nur in einem eigenen Commit, mit Vorher/Nachher-Bogen im Chat und Eintrag im Log.
- Kein Test wird gelöscht, mit `skip` oder Tag ausgeblendet oder mit `|| true` bzw. `|| echo` entschärft.
- `analysis_options.yaml`, `textregeln.json`, Leitplanken und TON-LEITFADEN werden nur strenger.
- „Eine 0 beim Bestandsschutz heißt: Die Änderung wird sofort zurückgenommen.“

### A4.5 Rohchat und Geheimnisse
- „Vor jedem Push läuft ein Secret-Scan (`bash tool/secret_scan.sh`). Schlüssel, Zugangsdaten, .env-Dateien und der Rohchat kommen nie in den Verlauf.“
- Der Rohchat liegt unter `quellen/schlosskeller-teamchat.txt`. `quellen/` bleibt in `.gitignore`.
- Der Scan zeigt nicht an, dass er die Passagenprüfung überspringt. Vor jedem Push zusätzlich: `test -f quellen/schlosskeller-teamchat.txt || echo "Passagenprüfung übersprungen"`. Bei „übersprungen“: einmal je Sitzung Vermerk im ENTSCHEIDUNGSLOG und in FUER-DEN-NUTZER; gepusht wird, wenn der Scan mit „Secret-Scan: sauber“ endet. Übernommen wird dann nur, was dieser oder ein früherer Lauf selbst geschrieben hat; nichts mit Chat-Kopfzeilen, „teamchat“ oder „quellen/“.

### A4.6 Inhalt
Wortlaut aus `origin/finalisierung-schlosskeller:planung/finalisierung-schlosskeller/TON-LEITFADEN.md` §1–§10 als Anhang. `VERBOTE-LEITPLANKEN.md` (Krimidinner-Fall) wird **nicht** angehängt. Von dort gilt nur: „Erfinde nichts Lösungsrelevantes; fehlt etwas, schreibe OFFENE FRAGE.“

**Verbote**
- Kein Alkohol, keine Drogen, kein Rauchen, auch nicht als Witz, Andeutung oder Redewendung.
- Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser und Säfte.
- Keine Klischees, keine Fachbegriffe, keine Zungenbrecher.
- Keine echten Personen, keine Marken, nichts aus bestehenden Spielen, kein Minecraft-Look.

**Figuren und Gewalt**
- Herr Schneider überlebt in jedem Ende. Der Schlag ist nur als Schatten und Geräusch angedeutet, kein Blut.
- Die Pfeife des Detektivs bleibt eine Silhouette und bläst Seifenblasen.
- Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe.

**Sprache und Erzähler**
- Sätze im Mittel ≤ 14 Wörter, keiner über 25. Die Runde wird mit „ihr“ angesprochen, Einzelne mit „du“, nie gesiezt.
- Zur Laufzeit nur feste, geprüfte Bausteine; das Spiel erzeugt keinen Text.
- „Das Spiel lügt nie mit eigener Stimme.“
- „Eine falsche Entscheidung deckt Wahres auf, das weniger hilft – nie Falsches.“
- Der Erzähler sagt nie, ob ein Hinweis stimmt (TON §2, E-024).

**Bilder, Requisiten, Klänge**
- Die Inhaltsregeln gelten auch hier. Die Negativliste aus TON §9 gilt für jeden Maler.
- Licht nur aus Kanon-Lichtquellen, Farben nur aus der Palette.
- Keine Flaschen, Stielgläser oder Fässer im Schlosskeller: In BW0 bekommen `prop_painter.dart` (`_table`) und `markers.dart` (`_salts`, Z. 238) einen neuen Parameter `ohneFlaschen` (Standard `false`), den die Partysitzung setzt; ersetzt wird durch Teekannen oder Krüge, bei gleichem Zufallsverbrauch. Klassische Fälle und Burgstadt bleiben bytegleich.
- Keine roten Teilchen an Kerzenständer, Opferplatz oder Vorratsraum-Boden.
- Pech-Szenen nach C6.

**Kanon**
- Nur der Schlosskeller-Kanon (`content/party/schlosskeller/`).
- `krimidinner/` und `nachtlauf/kanon` sind ein anderer Fall und werden nie vermischt.
- Sperrliste (Treffer = rot): Merle, Lüddecke, Rojda, Adnan, Kunibert, Burgwart, Speisekammer, Wehrgang, Torhaus, Hofebene, Turm-Fuß, Eisentür, Bienenwachs, benommen, Apfel-Zimt-Punsch, Ayran.
- Die Textregeln der Schicht bekommen die Liste `gewalt`: blut, blutig, blutet, wunde, verletzt, verletzung, schmerz. Der Textprüfer liest jede Datei der Schicht.

### A4.7 Würfel (WÜ-1 … WÜ-6)
- **WÜ-1 Quelle:** Würfe kommen nur aus `Rng` (`packages/mordakte_core/lib/src/util/rng.dart`):
  - Seed `Rng(Rng.hashString('wuerfel:<salz>:<entscheidungsId|abstecherId>:<anlauf>'))`. Das `salz` hängt nicht vom Fall-Code ab: Im WLAN schickt jedes Gerät in der Lobby eine Zufallszahl (`Random.secure()`), der Host mischt sie per FNV und zeigt allen das Ergebnis vor der ersten Entscheidung; in Party und Solo entsteht es beim Einrichten. `salz` steht im Spielstand. Der Mitschnitt enthält vor dem Finale 0-mal den Fall-Code oder einen daraus berechneten Wert.
  - nie eine laufende Wurfnummer, nie `FallCode.rng()`
  - nie `dart:math`, `Zufall`, `Lcg` oder `FeinZufall` in der Spiellogik
  - nur der Host würfelt; ein Tischwurf ist nur Darstellung
- **WÜ-2 Offen:** Chancen in Prozent stehen vor dem Wurf fest. Jeder Wurf ist sichtbar und protokolliert.
- **WÜ-3 Stark, aber lösbar:** Wahl vor Wurf, zwei Zustände (`aufgedeckt` und `gewaehlt`), Stufen, zweiter Anlauf oder Umweg zur selben Kanon-Quelle, Pech-Garantie mit Reserve-Regel, Budget-Ungleichung, Rundenschranke und Kettensperre (C2). Belegt wird das mit einem erschöpfenden Beweis (C8 Nr. 1).
- **WÜ-4 Wertung unantastbar:**
  - Ein Wurf deckt nie Falsches auf.
  - Er ändert nie: Tatmatrix, Pfad, Fakten, gewählte Option, Kanon-Punkte (0–9), Restverdächtige, Bonus-Qualität, Gruppenwahl-Wertung, Ende, Rückblende, Schneiders Überleben.
  - Die Nebenwertung (Seifenblasen-Marken, Glücksbilanz) erscheint getrennt.
- **WÜ-5 Pfadgleichheit:** wie in C3.
- **WÜ-6 Determinismus:** Gleicher Code + gleiche Eingaben + gleiche Würfe ergeben dasselbe Protokoll, 1.000-mal, auf VM und Node (MP-14 L3).
  - Im Würfel- und Partycode gibt es 0 Treffer für `.hashCode`, `identityHashCode`, `dart:math`, `DateTime.now` und `Stopwatch`.

### A4.8 Dateihoheit
**Nie ändern (vor und nach B-02):**
- `krimidinner/**`, `nachtlauf/**`, `hd/**`
- `tool/hd_*`, `tool/abnahme.dart` (wird nie **ausgeführt**: es überschreibt `nachtlauf/belege/*`), `tool/commit_gruen.sh`, `tool/layout_pruefsumme.dart`
- Schutzwerkzeuge: `tool/secret_scan.sh`, `tool/lib/**`, `tool/quellabgleich.py`, `tool/mass5a.py`, `tool/browser/**` (außer der einen Zeile in `geraete.js`, MP-9)
- bestehende Dateien in `tool/ton/**` (neue Dateien sind erlaubt; `erzeuge.dart` läuft nur mit ausdrücklichem Ziel unter `assets/runden/`)
- `assets/burgstadt/**`, `assets/fonts/**`
- die 5 textPfade (B5)
- `packages/burgstadt_core/**`, `packages/burgstadt_spiel/**`, `lib/burgstadt/**`
- `content/scenarios/**`
- gemeinsamer Kern von App und Server: `packages/mordakte_core/lib/src/{engine,model,protocol,runtime,scenario,util}/**` (darunter `util/rng.dart`) und `packages/mordakte_core/bin/{validate,simulate}.dart`; im Barrel `mordakte_core.dart` nur neue `export`-Zeilen
- `server/**`, `netlify.toml`, `vercel.json`, `railway.toml`, `build.sh`
- `android/**`, `ios/**`, `web/index.html`, `web/manifest.json`
- `planung/finalisierung-schlosskeller/**`, `planung/feinkorn/**`
- Tag `schlosskeller-1.0`: BOLLWERK setzt oder pusht ihn nie.

**Nur ergänzen, nichts Bestehendes ändern:**
- `packages/pixel_engine/**` (FEINKORN-Übernahme samt Trennungsprüfung)
- `packages/room_host/**` (`RaumSpiel` nur umsetzen)

`tool/alle_tests.sh` und `tool/pruefen.sh` werden nur aufgerufen. Eigene Läufe liegen unter `tool/bollwerk/**`.

**Zufall:** `Zufall` und `Lcg` werden nie geändert und aus neuem Code nie aufgerufen; ihr Zähler gehört zur Layout-Prüfsumme.

**Vor B-02:** zusätzlich die Liste in B5 sowie `lib/game/**`, `lib/session/**` und `pubspec.yaml`/`.lock`. BOLLWERK schreibt dann nur in:
- `planung/bollwerk/**`, `tool/bollwerk/**`
- `content/runden/**`
- `packages/mordakte_core/lib/src/runden/**`, `packages/mordakte_core/test/runden/**`
- `lib/runden/**`

**Nach B-02** gehen an BOLLWERK über:
- `content/party/**`: Die Kanon-1.0-Wahrheit bleibt Byte für Byte; das prüft L0.3.
- `packages/mordakte_core/lib/src/party/**`, `packages/mordakte_core/bin/party_*`, `packages/mordakte_core/test/party/**`
- `lib/party/**`, `tool/e2e/**`, `docs/partykrimi/**`
- die ORCH-Dateien außer `build.sh`
- `lib/game/**`, `lib/session/**`: Eingriffe nur über optionale Haken `session is …` und neue Parameter mit unverändertem Standard.
- Nachzügler-Commits des anderen Laufs holt BOLLWERK herein und ändert sie nie zurück.

**Merge:** Eine Linie per Merge zusammenzuführen ist kein Ändern; dafür gelten MP-16 und der Burgstadt-Schutz. L0.2 lässt in Nie-Pfaden nur Inhalte zu, die unverändert aus einer zugelassenen Linie stammen; von „nur ergänzen“ sind diese Merge-Commits ausgenommen; ihr `git diff --stat` kommt ins Log, sichtbare Änderungen gehen nach K6.

**Code im Vorlauf:** Code unter `runden/` darf die Party-Teile von `mordakte_core` und `lib/game/**` importieren, ändert sie aber nicht.

### A4.9 Agenten
- Haiku-Agenten haben nur Werkzeuge nach A4.2. Jeder Auftrag nennt absolute Pfade.
- **Pool-Plätze sind Kopien ohne Git:** höchstens 6 Plätze `/home/user/bw/01…06`, jeder in FLUG.md eingetragen. Das Skript liest `$BW` und `$POOL` aus `env.sh` (Standard `/home/user/bollwerk` und `/home/user/bw`), damit der Meta-Trockenlauf beides umlenken kann.
  - Anlegen und Zurücksetzen nur mit `bash $BW/tool/bollwerk/pool_reset.sh <NN> <sha>`. Das Skript bricht ab, wenn `<NN>` nicht `01`–`06` ist oder der Platz nicht in FLUG.md steht. Es führt aus: `rm -rf /home/user/bw/<NN> && mkdir -p /home/user/bw/<NN> && git -C /home/user/bollwerk archive <sha> | tar -x -C /home/user/bw/<NN>`, danach `pub get --offline` in allen 8 Paketen des Repos (Wurzel, 5 Pakete, `server`, `tool/ton`) und in `tool/bollwerk/look_anker`.
  - Daneben liegt je SHA eine schreibgeschützte Basis `/home/user/bw/basis-<sha7>` (gleich angelegt, dann `chmod -R a-w`).
  - Haiku ruft nie `git` auf. Den Patch erzeugt Opus: `diff -ruN -x .dart_tool -x build -x '.flutter-plugins*' /home/user/bw/basis-<sha7> /home/user/bw/<NN> > /home/user/bw-varianten/<welle>/<kennung>.patch`. Vor `git apply --check` in `/home/user/bollwerk` prüft Opus, dass der Patch nur die Dateien des Auftrags berührt.
  - Teil 8 jeder Auftragsvorlage enthält wortgleich: „Du führst nie `git` aus und betrittst nie `$BW` oder einen anderen Checkout.“
  - `git reset --hard`, `git clean` und `git checkout -- <pfad>` laufen nur mit `-C <eigener Wegwerf-Worktree>` (Mutanten, Rot-Proben), nie ohne `-C`.
- Text-, Daten- und Urteilsaufträge bekommen keinen Worktree. Workflow-Option `isolation: 'worktree'` wird nicht benutzt.
- **Ergebnis als Datei, Kurzurteil an Opus:**
  - Varianten schreibt der Agent als JSONL nach `/home/user/bw-varianten/<welle>/<kennung>.jsonl`, Code als Patch nach `…/<kennung>.patch`.
  - Die Rückgabe ist eine Zeile plus Endmarke:
    `KURZ · <Kennung> · <gruen|teil|rot> · Varianten <n> · Selbstprüfung <m>/<n> · Datei <pfad> · Frage <ja|nein>`
    `=== ENDE <Kennung> · BEREIT ZUR RÜCKGABE ===`
  - Berichte mit bis zu 1.800 Wörtern gibt es nur bei Aufträgen der Art „Bericht“.
- „Platzhalter wie ‚usw.‘, ‚analog‘ oder ‚weitere folgen‘ sind verboten und führen zur Ablehnung.“
- „Du simulierst niemals Haiku-Ergebnisse und schreibst vergebene Pakete nicht nebenbei selbst.“ Ausnahme: Ein Paket scheitert zweimal (MP-10).
- „Die vollständige Lösung bekommen nur Pakete, die sie zwingend brauchen.“
- „Unteragenten unterliegen denselben Grenzen; jeder Auftrag nennt sie.“
- Keine Backticks in Heredocs (L-01).
- Mutanten und Rot-Proben laufen nur in Wegwerf-Worktrees und werden nie committet.
- **Stolperdraht nach jeder Welle:** `git ls-remote origin` mit dem Bild der letzten Welle vergleichen. Rot ist er nur bei:
  - einem gelöschten Ref
  - einem Ref, dessen alter Stand kein Vorfahr des neuen ist
  - `refs/heads/bollwerk` ≠ letzter eigener Push (außer eine höhere LEASE steht darin: dann gilt v4 2.5)
  - einem neuen Ref außer den in V-13 genannten
  - einem fremden Ref, dessen neue Commits `tool/bollwerk`, `content/runden`, `lib/runden`, `packages/mordakte_core/lib/src/runden` oder `planung/bollwerk` ändern, ausgenommen `planung/bollwerk/{leitstand,v4,archiv}/**` und `planung/bollwerk/META-*`
  Bei Rot: keine neue Welle, Ursache ins NACHTPROTOKOLL, FUER-DEN-NUTZER. Alles andere ist erwartet (V-13) und kommt nur ins NACHTPROTOKOLL.
- Entfernt werden nur Worktrees, die dieser Lauf angelegt hat (Liste in FLUG.md). Vorher wird der Diff als Patch gesichert. Nie `git worktree prune` oder `git clean -x` außerhalb eigener Bäume.

### A4.10 Rechenlast
- **Container:** 4 Kerne, etwa 16 GB RAM, keine GPU.
- **Schwerlast-Slot:** `flock /tmp/bw-schwer.lock <befehl>`, höchstens 1 zugleich. Dazu gehören: voller Testlauf, Web-Build, Chromium, Leistung (L8), Mutanten (L9b), die Nachttiefe.
- **Zwei Leichtlast-Plätze:** `flock /tmp/bw-leicht-1.lock` bzw. `-2.lock`. Jeder Agentenlauf von `dart test`, `dart analyze`, `pub get` und `flutter test` belegt einen davon. Getestet wird nur gezielt (`dart test test/<datei>`).
- **Lastgrenze:** Liegt die Last über 6 oder der freie Speicher unter 3 GB, und das 10 Minuten lang, startet kein neuer Code-Auftrag mehr, bis die Last unter 4 liegt.
- **Plattenwache** (`df -BG --output=avail /home/user`):
  - unter 8 GB: keine neuen Worktrees; `build/` und `.dart_tool/flutter_build` im Pool leeren
  - unter 4 GB: nur noch Übernahme und BW8
- **Messen:** Leistung nur in Thread-CPU-Zeit, nie unter Parallellast. Agenten schreiben nie in einen Baum, in dem gemessen oder getestet wird.
- **PATH:** Jeder Bash-Befehl beginnt mit `source $BW/tool/bollwerk/env.sh &&` ($BW = Sitzungs-Checkout auf `bollwerk`). Die Datei setzt `PATH=/opt/flutter/bin:/opt/node22/bin:$PATH` und `BW` (Standard `/home/user/bollwerk`); Pfade in MP-0 und MP-19 laufen über `$BW`, damit der Trockenlauf (Meta M7) sie umlenken kann.

---

## A5 · Lehren aus den bisherigen Läufen (in MP-10 und MP-17)
Inhalt: B8.

Zusätzlich übernommen:
- **Durchstich vor Breite:** Im Hauptlauf kommt Breite erst nach dem BW1-Tor. Im Vorlauf zuerst ein Vorlauf-Durchstich in ≤ 2 h (Abstecher-Karte → Posenfolge → Würfelbühne, als Bild in den Chat), dann Breite, nur in den Vorlauf-Pfaden.
- **Doppelbau-Regel ★:** An Schlüsselstellen bauen 2–3 Haiku parallel; Opus wählt nach dokumentierten Kriterien.
- **Kürzungsleiter statt stilles Absenken.**
- **Gestaltungsfragen** gehen sofort nach FUER-DEN-NUTZER, nie in weitere Prüfrunden.
- **Worktrees vor dem Löschen abgleichen.**

---

## A6 · Pflichtinhalt MP-0 … MP-20

Rahmen:
- Der Hauptteil (MP-0 bis MP-20) hat höchstens **7.000 Wörter**, gezählt mit `wc -w` ohne Anhänge.
- Anhänge liegen unter `planung/bollwerk/anhang/A-<n>-<name>.md`:
  - Wortlaut A1
  - JSON-Schemas, Beispielrunden
  - Rollenbriefings, Auftragsvorlage
  - Auftragsvorrat (Schablonen)
  - Weißliste
  - Kanon-Auszüge (Kennung ↔ Anzeigename, Ketten)
  - TON-LEITFADEN §1–§10
  - Glossar der Kürzel
- Verwiesen wird mit „→ A-n“. Jede Regel steht an genau einer Stelle; andere Stellen verweisen mit „siehe §n“.
- Jedes Kürzel wird beim ersten Auftreten in einem Halbsatz erklärt. Jede Quelle steht mit Ref und Pfad.

### MP-0 · KERN und EINSTELLUNGEN
- **KERN (≤ 400 Wörter, steht ganz oben):**
  - die unverletzlichen Regeln (Kurzfassung A4)
  - der Wiedereinstieg nach einer Verdichtung (MP-18)
  - die Pfade aller Zustandsdateien
- **Einstellungen (Nutzer):**
  - neue Sitzung
  - Ultracode an
  - `/config` → „Dynamic workflow size“ auf `unrestricted` oder `large`
  - Berechtigungsmodus **„Auto“** im Menü neben dem Eingabefeld. Sonst hält die erste Nachfrage den Lauf bis zum Morgen an. Gibt es Auto nicht, liegt eine Vorschlagsliste in `planung/bollwerk/VORSCHLAG-FREIGABEN.md`; der Nutzer entscheidet selbst darüber.
- **Startnachricht:** schreibt der Leitstand (v4 §8.8); der Master-Prompt selbst enthält keine.
- **Weitere Befehle des Nutzers während der Nacht:**
  - „HALT BOLLWERK“: keine neuen Aufträge, laufende fertig, grün committen, `bollwerk` pushen, kein main, Morgenbericht sofort
  - „WEITER BOLLWERK“
  - „FREIGABE BOLLWERK“: B-02 gilt als erfüllt
  - „A<n>: …“: Annahme kippen; umgesetzt am nächsten PRUEFPUNKT, betroffene Arbeit über Schalter zurück
  - Eine Nachricht des Nutzers geht allen Aufträgen vor.
- **Budget:**
  - Tokenrahmen der Nacht aus `DURCHSATZ.md` × 1,2 (Haiku und Opus getrennt)
  - ab 70 %: nur Aufträge, die ein BK-Kriterium voranbringen
  - ab 90 %: keine neue Welle; Sicherung und Morgenbericht
- **Nutzungslimit:**
  - Ergebnisse sichern, PRUEFPUNKT schreiben, `bollwerk` pushen.
  - Den nächsten Herzschlag (`send_later`) auf die Freigabezeit plus 5 min verlegen: die offene Erinnerung löschen und neu stellen, nie eine zweite daneben.
  - „Jede neue Sitzung liest zuerst diese Dateien und setzt exakt dort fort, auch nach einem Nutzungslimit.“ Vorher gilt die Lauf-Sperre (MP-18).
  - Nach 3 Limits in Folge die Gleichzeitigkeit halbieren.

### MP-1 · NORDSTERN UND ZIELBILD
- A1 (→ Anhang), A2, A3
- Referenzbilder je Raum aus M2
- **„Fertig heißt …“:**
  - spielbar aus main im Web-Build und in der App
  - alle BK-Kriterien grün über `bollwerk.dart ziel`
  - Version `0.1.0+1` unverändert
- **„Fertig heißt nicht Store.“** Der Morgenbericht listet „Bis zum Store fehlt“:
  - Release-Signatur (heute Debug)
  - Datenschutzerklärung (WLAN, lokale Speicherung)
  - Angaben zum Altersfragebogen (Gewalt nur angedeutet, kein Blut, Würfel ohne Einsatz und ohne Kauf, lokales WLAN ohne Chat)
  - Bildschirmfotos
  - `web/manifest.json` (Text „kooperatives Murder-Mystery“, `portrait-primary`)
  - Tests auf echten Geräten
- Sprache: nur Deutsch.

### MP-2 · STARTBEDINGUNG UND VORLAUF
**B-02 als Befehl:**
1. `git fetch origin --tags`
2. `git ls-remote --exit-code --tags origin refs/tags/schlosskeller-1.0` liefert T.
3. `git merge-base --is-ancestor T^{commit} origin/main` ist wahr.
4. `git show origin/main:planung/finalisierung-schlosskeller/STATUS.md` oder `…/ABSCHLUSSBERICHT.md` enthält „ZIEL ERREICHT“.
5. `origin/finalisierung-schlosskeller` hat seit ≥ 30 min keinen neuen Commit, und kein Commit auf `origin/main` oder `origin/nachtlauf/burgstadt` der letzten 30 min berührt `planung/finalisierung-schlosskeller/**`, `content/party/**`, `lib/party/**` oder `packages/mordakte_core/**` (der Nachtlauf Burgstadt pusht unabhängig weiter auf main).

Andere Signale reichen nicht: ein Merge ohne Tag, ein Tag nur auf dem Arbeitsbranch, ein offener PR. Einzige Ausnahme ist „FREIGABE BOLLWERK“. B-02 wird stündlich im Herzschlag geprüft.

**FREIGABE-Weg** („FREIGABE BOLLWERK“, auch als Zusatz zur Startnachricht):
1. Prüfe, dass `origin/finalisierung-schlosskeller` seit ≥ 30 min keinen Commit hat. Sonst bleibst du im Vorlauf, prüfst stündlich neu und schreibst in FUER-DEN-NUTZER: „Bitte die Finalisierungs-Sitzung anhalten.“
2. Setze S_F = `git rev-parse origin/finalisierung-schlosskeller` und trage S_F im PRUEFPUNKT ein.
3. BW0 beginnt mit `git merge --no-ff S_F -m "Merge finalisierung-schlosskeller@<sha7> (FREIGABE)"`, danach `bollwerk` ← `origin/main`. S_F ist der B-02-Commit.
4. Überall, wo `schlosskeller-1.0` steht (K in L0.3, MP-16 Schritt 7), gilt S_F. Den Tag `schlosskeller-1.0` setzt oder pusht BOLLWERK nie, und unter `planung/finalisierung-schlosskeller/**` schreibt es nie. Fehlende F-Teile baut BOLLWERK nur in eigenen Pfaden und den nach B-02 übergegangenen (A4.8).
5. Offene F:F-Kriterien aus `P/ABNAHME.md` werden Aufträge in BW0. Was nicht fertig wird, steht im Morgenbericht.
6. Kommen danach noch Commits auf `origin/finalisierung-schlosskeller`: Aufträge in übergegangenen Pfaden sofort anhalten, die Commits nach der Konfliktregel (MP-16) hereinholen und in FUER-DEN-NUTZER schreiben: „Die Finalisierungs-Sitzung schreibt noch – bitte anhalten.“ Bis 60 min Ruhe schreibt BOLLWERK wieder nur in Vorlauf-Pfaden.

**Vorlauf V**
- Schreiben nur in den Vorlauf-Pfaden (A4.8).
- Inhalte:
  - BW0-Vorbereitung: Torwerkzeug, Füllstoff-, Stil-, Umfangs- und Variantenwerkzeug, `look_anker`-Paket
  - Würfelkern und Simulator-Erweiterung in `runden/`
  - Posen-, Leben- und Würfelbühnen-Bibliothek in `lib/runden/` (liest `lib/game/**`, ändert es nicht)
  - Texte und Varianten für die Schicht `content/runden/`
  - der Durchstich als Probe im eigenen Namensraum auf einer Kopie der Kanondaten
  - Tests und Simulationen
- **Merges im Vorlauf** sind hoheitsfrei, weil die Dateien disjunkt sind: `bollwerk` ← `origin/kern-feinkorn@1145cb9` ← `origin/claude/pensive-gates-ajtp7x@caf1d61` (MP-16). Nie `origin/finalisierung-schlosskeller` oder `origin/main` in `bollwerk`, nichts nach main.
- **Ruhender Lauf:** Ruht der andere Lauf (6 h kein Commit), steht das im NACHTPROTOKOLL und in FUER-DEN-NUTZER. Seine Arbeit übernimmt BOLLWERK nie von selbst.
- **Später Start:** siehe Zeitplan MP-12.
- **Vorlauf-Tor:** Bis `bollwerk.dart` abgenommen ist (Rot-Probe und grüner Lauf), committet nur Opus, nur in Vorlauf-Pfaden, nach `dart analyze` und `dart test` der berührten Pakete und Secret-Scan. Danach gilt `bollwerk.dart schnell --vorlauf`: L0 ohne L0.1 und L0.3, L0.2 nach MP-14, dazu L2, L3, L4 und L5 für `runden/`. L6 und L8 erst ab BW0.
- **B-02 nie erfüllt:** Der Lauf endet mit „VORLAUF FERTIG“; alles ist grün auf `bollwerk` gepusht, nichts auf main. Der Morgenbericht bietet drei Wege:
  - (a) Standard: warten und erneut „START BOLLWERK“ senden.
  - (b) „FREIGABE BOLLWERK“: FREIGABE-Weg (oben).

### MP-3 · AUTONOMIE UND DENKPROTOKOLL
- BE-10.
- **Denkprotokoll** als Fragen:
  1. Was will ich erreichen, woran messe ich es?
  2. Welche drei Wege gibt es mindestens?
  3. Wie schneidet jeder ab?
  4. Was spricht gegen meine Wahl?
  5. Was folgt daraus später?
  6. Wahl, mit Eintrag ins ENTSCHEIDUNGSLOG.
- **Dateien:** `ENTSCHEIDUNGSLOG.md`, `FUER-DEN-NUTZER.md`, `ANNAHMEN.md`. Für Dateinamen gilt ASCII.

### MP-4 · GRENZEN UND VORRANG
- A4 vollständig.
- **Vorrang:** Harte Regeln (A4, alle BK-Schwellen) werden nie abgewogen. Für alle anderen Zielkonflikte gilt: Lösbarkeit und Fairness › Look-Treue (Stil-Konstanten) › Handyleistung (nie unter Messbasis) › Design-Aufwertung und Umfang (gleichrangig; jede Welle abwechselnd) › sonstige Politur.
- Widersprechen sich zwei harte Regeln, wählst du die sicherere und trägst das in FUER-DEN-NUTZER ein.

### MP-5 · ARCHIV UND WIEDERVERWERTUNG
- Tabelle aus `ARCHIV.md` (M1).
- Übernahme nur per Commit mit Vermerk `aus <ref>@<sha>:<pfad>`. Nichts wird gelöscht oder verschoben.
- Archiv-Branches `archiv/<linie>-<sha7>` (V-2, angelegt vom Leitstand auf Bitte in STEUERUNG/FUER-DEN-NUTZER) für Linien der Klasse *nur archivieren*, die nicht schon Vorfahr von main sind.
- **Wiederverwertung belegt:** Jede Zeile der Klasse *zusammenführen* oder *teilweise übernehmen* hat einen Übernahme-Commit oder eine begründete Absage. Die Liste steht im Morgenbericht.
- Das Scratchpad-Archiv `planung/bollwerk/archiv/scratchpad/` (MANIFEST mit sha256) wird mitgeführt.

### MP-6 · SPIELENTWURF
- `SPIELMECHANIK.md` aus M3, auf Grundlage von Anhang C, mit allen bindenden Punkten aus C1–C8.
- JSON-Schemas (→ Anhang) für Entscheidung, Kette, Abstecher, Aktion, Wurf, Protokoll und Spielstand.
- Drei durchgespielte Beispielrunden, darunter der Abstieg in den Keller.
- Kanon-Lücken aus `KANON-LUECKEN.md` (M1). Vorrang: Inhaltsregel › Kanon › Look-Vertrag.
  - Grüne Flaschen raus, nur im Schlosskeller (Parameter `ohneFlaschen`, A4.6; Pflicht).
  - Detektivfarbe #B8A48A, Schneider sitzend und Gehtempo nach Kanon, über Parameter des Partymodus. Burgstadt und die klassischen Fälle bleiben unverändert.
- **Barrierefreiheit (Pflicht):**
  - Systemschrift bis 200 % ohne Abschneiden; Golden-Bilder bei 100 % und 200 %
  - nie nur Farbe: Würfelstufen mit Wort und Symbol; Simulation von Protanopie, Deuteranopie und Tritanopie; F:F-13
  - einhändige Bedienung im unteren Drittel, Tippflächen ≥ 48 × 48 dp, keine Zwei-Finger-Geste
  - „Flackern aus“ und „Bewegung reduzieren“ (auch aus `MediaQuery.disableAnimations`)
  - Kontrast ≥ 4,5 : 1, auch nachts
  - `Semantics` an Karten und Würfelergebnis
  - Vorbild: Burgstadt `Optionen`/`PrefsOptionen`
- **Klang und Haptik:**
  - Klang je Aktionsart, Würfelklang je Stufe, Türquietschen nach Kanon (6 von 8), Atmosphäre je Raum
  - Klänge nur aus neuen Erzeugern unter `tool/ton/` (bestehende Dateien dort bleiben unverändert), Ausgabe nur nach `assets/runden/`, abgespielt über die vorhandene `Tonausgabe`; eigenes Werk in LIZENZEN; neue Klänge zusammen ≤ 3 MB
  - Haptik nur über `lib/ui/haptics.dart`
  - Optionen: Lautstärke 0–10, Haptik an/aus
  - Musik: Standard keine (Annahme A-08)
  - im Web vor der ersten Geste keine Konsolenfehler durch Ton

### MP-7 · UMFANG 10–100×
**Kanonfeste Achsen** (Faktor 1, nicht im Index): Täterpfade 4, wertende Entscheidungen 9, Runden 3, Fakten 30, Enden 4, Räume 7 mit 8 Türen.

**Indexachsen** (Zählbefehl je Achse in `UMFANG-BASIS.md`):
- X1 Entscheidungen samt nichtwertender Folgeentscheidungen und Abstecher (Basis 9)
- X2 Spieltexte und Bausteine (1.217)
- X3 begehbare Ziele und Orte innerhalb der 7 Räume (43)
- X4 Gags und Nebenhandlungen (3)
- X5 Weißlisten-Zusatzfunde (Zahl am B-02-Commit)
- X6 sichtbare Aktionsarten mit Animation (Zahl am B-02-Commit; F4 bringt schon einige)

**Formel**
- f_i = Wert nach Füllstoffprüfung ÷ Basis am B-02-Commit, gedeckelt bei 100.
- U = exp(Σ g_i · ln f_i / Σ g_i).
- Die Gewichte legt der Meta-Lauf in M1 fest, mit Begründung (Startwert g = 3, 2, 1, 1, 1, 2: sichtbare Aktionen hoch, Weißlisten-Funde kanongebunden niedrig). Danach ändert sie niemand.
- Beispiel, das U ≥ 10 erfüllt: X1 20× (≈ 180), X2, X3 und X5 je 3×, X4 30× (≈ 90 Gags), X6 30× ergibt U ≈ 10,6 bei eingehaltener 40-%-Regel.
- **Umfangsplan** (aus M4): welche Kombination f_1 … f_6 U ≥ 10 erfüllt und wie viele Aufträge und Stunden (Vorlauf und Hauptlauf) sie braucht. Vorlauf-Ware in `content/runden/` zählt, sobald sie nach B-02 F1–F5 besteht. Reicht eine Hauptlauf-Nacht nicht, setzt der Master-Prompt je Nacht ein Zwischenziel aus diesem Plan (Annahme A-11). Das BK-Kriterium bleibt U ≥ 10; nichts wird still gesenkt.

**Schwellen**
- U ≥ 10, Streckziel 100.
- Jede Indexachse ≥ 3×.
- Keine Achse trägt mehr als 40 % von ln U.

**Pflichtziele (statt Index)**
- Spielformen 3/3
- Ruhe-Animationen 22/22
- Posen ≥ 24
- Mimik ≥ 4 Ausdrücke je Figur
- Würfeltabelle je Entscheidung mit Wurf
- Leben-Effektarten ≥ 6
- Requisitenarten ≥ 30/34
- je Pflichtentscheidung ≥ 1 Kette

**Nur berichtet:** Partieverläufe (nur inhaltlich unterscheidbare Szenenfolgen) und Tests.

**Werkzeug:** `dart run tool/bollwerk/umfang.dart` → Exit 1 bei U < 10 oder einer Achse < 3×.

**Kanon-Erweiterungsregel**
- Kanon 1.0 bleibt Byte für Byte unverändert (L0.3 gegen K, MP-14).
- Die Schicht liegt in `content/runden/schlosskeller/` mit `schichtVersion` und `basisKanon: "1.0.0"`.
- Ein neues Stück ist nicht lösungsrelevant:
  - in allen 4 Pfaden wortgleich
  - keine Faktquelle, kein Kettenglied
  - kein neues Wissen über 23:50–00:15
  - Restmenge nie geändert
- Gespräche erfüllen P-1 und `party_pruefen`.
- Nebenhandlungen nur für Stufe II–V und nur außerhalb 23:50–00:15.
- Neue Orte nur innerhalb der 7 Räume (C5).
- Ob auch neue Fälle oder Täterpfade dazukommen, ist Annahme A-04 (Standard: nur Schichten).

**Füllstoffprüfung** (`dart run tool/bollwerk/fuellstoff.dart`; ein Stück zählt nur bei F1–F5 grün)
- F1 Schema und Inhaltsprüfer: 0 Treffer.
- F2 Erreichbarkeit: in ≥ 1 L4-Protokoll (bestes Spiel, zufällig, erste Option); 100 %.
- F3 Wirkung:
  - Optionen unterscheiden sich paarweise in ≥ 1 Protokollfeld.
  - Ein Text ist an genau einer Stelle verdrahtet.
- F4 keine Dublette:
  - Texte: Jaccard der Wort-3-Gramme < 0,5.
  - Entscheidungen und Aktionen: Tupel eindeutig.
  - Posen und Bilder: Silhouetten-IoU < 0,9 nach `bewohner_karten.dart` `vergleiche`.
- F5 Gremium:
  - Stichprobe 5 % je Welle, mindestens 20, per Seed.
  - 3 Linsen: Kanon, Ton, Spaß.
  - Die Welle zählt, wenn ≥ 90 % der Stichprobe von ≥ 2 Stimmen ≥ 7/10 bekommen.
- Die Ausschussquote steht stündlich im NACHTPROTOKOLL.

**Spieldauer:** C7. Was die Dauer sprengt, zählt nicht für den Umfang.

### MP-8 · DESIGN-AUFWERTUNG
**Look-Vertrag**
- *Stil-Konstanten* (nie ändern):
  - Iso 64/32/40, Kamera und Zoombereich, Zeichenreihenfolge
  - gezeichnete Figuren mit heutigen Proportionen und Strich
  - keine Pixel-3D-Blöcke, Farbfamilie der Palette
- *Qualitätsstufe* (soll aufgewertet werden):
  - Licht und Schatten, Nebel (BE-13)
  - Mimik und Gesten, Detaildichte
  - Bedien-Optik: Karten, Würfelbühne, Übergänge
  - Leben-Schicht
- Erweiterungen nur additiv: eine neue Sitzungsklasse; Abfragen `if (session is …)`, ohne die alles gleich läuft; neue Maler in neuen Dateien; Flutter-Overlays im Noir-Stil; Posen als optionale Parameter.

**D1 Strukturmaße** (`tool/bollwerk/design_mass.dart`, jedes mit Golden)
- Ruhe-Animationen 22/22
- Posen ≥ 24, je Aktionsart ≥ 1
- Mimik ≥ 4 je Figur
- Requisitenarten ≥ 30/34, 0 Umwidmungen, 0 Flaschen
- Leben-Effektarten ≥ 6
- Übergänge ≥ 5
- Würfelbühne und Entscheidungskarten

**D2 Blinder Paarvergleich**
- 28 Paare: 7 Räume × Tag/Nacht × hoch/quer, gleiche Kamera, fester Zeitpunkt.
- Jedes Paar zweimal (A/B, B/A, Reihenfolge per Seed). Die Dateinamen sind Hashes.
- 5 Haiku-Stimmen plus eine Opus-Stichprobe von 7 Paaren.
- Bestanden bei ≥ 85 % „nachher besser“ und Mehrheit in jedem Raum.
- Alle Paare gehen als Kontaktbogen an den Nutzer. Ein Nutzer-Veto macht D2 rot.

**D3 Eichung** (vor jedem Gremium)
- 18 Eichbilder, 12 davon mit bekanntem Fehler. Typen: Pixel-3D-Block, Fremdfarbe, Lichtrichtung, Iso-Winkel, abgeschnittene Figur, Textüberlauf.
- Die Lösung wird erst nach dem Lauf eingecheckt.
- Das Gremium gilt, wenn die Mehrheit 2/3 ≥ 15/18 richtig liegt und ≤ 1 von 6 einwandfreien Bildern fälschlich meldet.
- Sonst entscheiden die Strukturmaße allein, und Opus ist Pflichtstimme.

**Stilprüfung** (`python3 tool/bollwerk/stil.py`; Pillow und numpy sind vorhanden). Sie misst Stiltreue, nicht Gleichheit. Verglichen wird dieselbe Szene mit derselben Kamera im selben Lichtzustand am B-02-Commit. Der Renderer gibt Masken für Nebel, Licht und Effekte, neue oder ersetzte Requisiten, Figuren und Overlays mit aus; diese Flächen sind ausgeschlossen.
- S1: Kanten der Stil-Konstanten-Schicht (Böden, Wände, Türen) ≥ 92 % innerhalb ±1 px.
- S2: ≥ 97 % der Pixel außerhalb der Nebelmaske liegen mit ΔE2000 ≤ 10 an einer Palettenfarbe.
- S3: neue Kanten ≥ 85 % innerhalb ±3° von 0°, 90° oder ±26,57°.
- S4: Luminanz ±15 % und Vignette ±0,05, nur im Sichtkegel.
- S5: Importregel BE-01, Teilchen ≤ 3 px.
- Die Zahlen aus M2 (an den Proben geeicht) ersetzen diese Startwerte einmal vor M5 und stehen danach genau einmal im Master-Prompt.
- Gremium ≥ 2/3 „selber Stil“, geeicht mit 6 zusätzlichen Stilbruch-Bildern.

**Leistung und Akku**
- Beim Warten auf eine Entscheidung ≤ 10 Bilder/s und keine Physik. Physik läuft nur beim Würfeln und bei Splittern.
- Qualitätsstufen einfach, mittel, hoch. Liegt die Bildzeit 5 s lang über 50 ms, geht es automatisch eine Stufe tiefer. „Einfach“ hat keine Teilchen.
- Gemessen wird nach L8.

### MP-9 · ARCHITEKTUR UND DATEIPLAN
- Neue Dateien und Ordner (Namensraum `runden`), Hoheitskarte vor und nach B-02 (A4.8).
- **App-Start nach BE-08 in BW4:**
  - Zuerst bekommt `lib/main.dart` additiv `'burgstadt' => Routes.burgstadt`.
  - `tool/browser/geraete.js` startet mit `?screen=burgstadt&…`. Das ist die einzige erlaubte Änderung dort, belegt mit einer Rot-Probe.
  - `pixel_pruef` wird nie abgeschwächt.
  - Der Schlosskeller-Start bekommt eine eigene E2E-Prüfung (L7).
- Schalter und Rückfallweg.
- Werkzeuge erscheinen nie im Release (L0.6).
- Neue Bedientexte stehen nur in `content/runden/schlosskeller/texte/ui-runden.json`, nie im Code und nie in `content/party/**`. F:`story_text_ausserhalb_test` gilt auch hier.

### MP-10 · ROLLEN UND AUFTRÄGE
**Rollen:** Opus (Orchestrator, Prüfer, Integrator) plus mindestens 14 Haiku-Rollen:
- Regelwerker, Kartenschreiber, Kettenbauer, Aktionsanimator, Posenmaler, Requisitenmaler, Lebenbauer
- Würfelmeister, Simulant, Testschreiber, Szenenprüfer, Kanonwächter, Sprachprüfer
- Bestandswächter, Leistungsprüfer, Gegenprüfer, Advocatus (Mutanten)

Je Rolle ein Briefing mit den drei häufigsten Fehlern (→ Anhang).

**Auftragsvorlage in 13 Teilen:**
1. Kopfzeile
2. Rollenbriefing
3. Aufgabe in einem Satz
4. Projekt in fünf Sätzen (wortgleich)
5. Kanon-Auszug mit der Tabelle Kennung ↔ Anzeigename
6. Schnittstellen
7. eigene Dateien
8. Grenzen, mit dem Werkzeugabsatz A4.2 wortgleich
9. Arbeitsschritte
10. Abnahme und Testweg
11. Ausgabeformular
12. Selbstprüfung
13. Endmarke

Lernvermerke: die aus der Auftragsvorlage des Finalisierungs-Laufs (`P/AUFTRAGSVORLAGE.md`: eine Rückgabe je Nachricht, ≤ 1.800 Wörter, `checkout --detach`, Briefing wortgleich), dazu FEINKORN L-01 (keine Backticks in Heredocs) und die Lehren aus B8.

**Paketvertrag:** ≤ 400 Zeilen plus Test (mit Rot-Probe) plus Probe.

**Paketprüfung:** 5 × 0/1/2 Punkte (Funktion, Kanon, Look, Bestandsschutz, Inhalt), Abnahme ab 8/10 ohne eine 0.
- Höchstens 2 Nachbesserungen, danach übernimmt Opus.
- Opus übernimmt höchstens 2 gescheiterte Pakete je Stunde; der Rest geht mit Befund zurück in den Vorrat.

### MP-11 · ORCHESTRIERUNG UND SKALIERUNG
**Muster**
- Varianten-Turnier: N Haiku-Varianten → Filterskript → Gremium mit 3 Linsen → Opus wählt und führt zusammen → Tests.
- Pipeline, Schleife bis Ruhe, gegnerische Prüfung, Vollständigkeitskritiker.

**Kapazität je Auftragstyp (T Text/Daten · C Code · B Bild · U Urteil)** aus `DURCHSATZ.md`
- Kapazität = 0,7 × min(E, F, U, O, S, P, K):

| Kürzel | Glied |
|---|---|
| E | Erzeugung |
| F | Filter |
| U | Urteil |
| O | Opus-Ereignisbudget |
| S | Schwerlast |
| P | Platte |
| K | Token |

- Zeitfenster:
  - T, C und B ab T0 + 20 min.
  - Im Vorlauf nur in den Vorlauf-Pfaden (A4.8). B rendert dort über `tool/bollwerk/look_anker/` oder über einen Vorschau-Build eines festen SHA von `origin/finalisierung-schlosskeller` im Pool-Worktree (nie committet). Jedes Bild geht in einen Kontaktbogen (BE-09).
  - Im Hauptlauf berühren C und B Pfade der Finalisierung erst nach dem BW1-Tor.
  - Ende der Auftragstypen: siehe Zeitplan MP-12.

**Hebel** (in dieser Reihenfolge)
1. 10–25 Varianten je Aufruf
2. mehrere Workflows gleichzeitig, aber nie mehr als im Pilot gemessen; je Workflow höchstens 20 Agenten (nach Anzahl bemessen, nie nach Zeit oder `budget`)
3. direkte Hintergrund-Agenten (`model: "haiku"`)
4. `effort: 'low'` für Mechanisches
5. Skripte filtern, Gremien bewerten nur den Rest

**Opus liest Varianten nie roh**
- `dart run tool/bollwerk/varianten.dart --welle <w>` prüft Schema, Inhalt, Leitplanken und Ähnlichkeit, zählt und gibt die besten ≤ 10 je Welle aus.
- Ereignisbudget: Rückgaben je Stunde ≤ 0,25 × 3.600 s ÷ gemessene Opus-Sekunden je Rückgabe (Startwert 40).
- Workflows geben nur Zähler, Pfade und die besten 5 zurück (≤ 300 Wörter).
- Test-, Analyse- und Build-Ausgaben gehen nach `/home/user/bw-logs/<zeit>-<schritt>.txt`. Opus liest nur `tail -n 20` und die Ergebniszeile.

**Zähler** in der STAND-Zeile und stündlich im NACHTPROTOKOLL.

**Drossel**
- Ausfälle (null, 429, Überlast) über 10 % in einer Welle → Gleichzeitigkeit halbieren. Nach 30 ruhigen Minuten wieder um 25 % erhöhen.
- Verwertbar-Quote eines Typs 2 Wellen lang unter 30 % → Typ stoppen, Briefing einmal überarbeiten, sonst streichen.

**Wiederaufnahme**
- **FLUG.md** wird **vor** jedem Start geschrieben. Je Zeile: Kennung, Typ, agentId bzw. runId + scriptPath, Start (echte Uhrzeit), erwartetes Ende, Ausgabedatei, Worktree.
- Nach einer Verdichtung: Laufende Workflows mit `resumeFromRunId` fortsetzen. Bei leerem Ergebnis zuerst `journal.jsonl` lesen. Verlorene Aufträge (Ende um > 100 % überschritten, keine Ausgabe): Worktree sichern und entfernen, Auftrag einmal neu einreihen.

**Weckruf und Herzschlag des Nachtlaufs** (die stündliche Routine gehört dem Leitstand)
- Höchstens ein offener `send_later` mit Name `BOLLWERK-G<n>-<session_id>`; er ist der angekündigte Weckruf der Zugende-Zeile. Aufgeräumt wird nur über die eigene ID.
- Jeder Zugbeginn und jeder Weckruf prüft zuerst die LEASE (v4 2.5).
- **Herzschlag-Zug:**
  1. KERNKARTE, PRUEFPUNKT und FLUG lesen.
  2. `uptime`, `free -g` und `df` prüfen.
  3. B-02 prüfen.
  4. Weniger Agenten als geplant und Vorrat nicht leer: nachstarten.
  5. Hänger (> 2 × Dauer-Median): stoppen und einmal neu einreihen.
  6. NACHTPROTOKOLL-Zeile mit `TZ=Europe/Berlin date`.
- **Leerlaufverbot:** Bis M − 1,5 h endet kein Zug mit 0 laufenden Agenten und Workflows. Ist der Vorrat leer, erzeugt derselbe Zug Nachschub.
- Am Ende werden nur die eigenen IDs gelöscht.

### MP-12 · BAUPHASEN MIT TOREN UND ZEITPLAN
| Phase | Inhalt |
|---|---|
| **V** | Vorlauf (MP-2) |
| **BW0** | `bollwerk` ← `origin/main`; Hoheit übernehmen; Basis neu am B-02-Commit (Umfang, Messbasis L8, `bestand.txt`, `kanon10.sha256`, Look-Anker); Flaschen ersetzen; Torwerkzeug grün |
| **BW1** | Durchstich im echten Spiel: eine Entscheidung → sichtbare Aktion → Würfelwurf. Bild an den Nutzer (nicht warten); volles Tor |
| **BW2** | Regelkern (WÜ-1 … WÜ-6), Ketten, Abstecher, Lösbarkeitsbeweis |
| **BW3** | Aktionen, Posen, Leben und die zwei bestbewerteten Aufwertungsrichtungen aus M2, mit Vorher/Nachher je Raum |
| **BW4** | Spielformen Party, Solo, WLAN; App-Start; Fortsetzen; Einstieg; Barrierefreiheit; volles Tor |
| **BW5** | Umfang-Wellen bis U ≥ 10 und die übrigen Aufwertungsrichtungen |
| **BW6** | Umfang und Design bis zum Streckziel |
| **BW7** | Härtung, `bollwerk.dart nacht`, Leistung; volles Tor |
| **BW8** | MAIN-REIFE (V-16): Release-SHA R, Tor `ziel` grün, `ZUSTAND: BEREIT FÜR MAIN`; den main-Push macht der Leitstand |

**Zeitplan** (einzige Stelle; M = Morgenbericht-Zeit, T_B02 = erste Herzschlag-Zeit, zu der B-02 wahr ist, steht im PRUEFPUNKT)
- Bis M − 2 h: Aufträge aller Typen.
- M − 2 h bis M − 1,5 h: nur T- und U-Aufträge, die Laufendes prüfen oder abschließen.
- Ab M − 1,5 h: nur BW8 bzw. Sicherung und Morgenbericht.
- BW1-Tor spätestens T_B02 + 2 h, sonst Kürzungsleiter Stufe 1.
- Später Start: T_B02 ≤ M − 4 h → voller Plan; T_B02 bis M − 2,5 h → BW0–BW2 bis M − 1,5 h, kein BW8; später → nur BW0 ohne Code-Aufträge, dann Sicherung.
- Nach M: nur Abschluss, spätestens M + 2 h Schluss.

**Kürzungsleiter** (jede Stufe ins Log)
1. Streckziel streichen
2. BW6 kürzen
3. Umfang 10× nur in den stärksten Achsen
4. nur BW0–BW4 und BW8

**Tore:** Schnelltor je Sammel-Commit (höchstens 1 je 15 min). Volles Tor (`bollwerk.dart phase`) nach BW1, BW4 und BW7. Die Nachttiefe läuft einmal, nach BW5 bzw. spätestens bei M − 3 h. Summe im Schwerlast-Slot ≤ 70 % der Nachtzeit, gerechnet in `DURCHSATZ.md`.

### MP-13 · AUFTRAGSVORRAT UND NACHSCHUB
- **Vorrat:** Auftragsschablonen mit Parameterlisten (z. B. `KARTE-<raum>-<entscheidung>`, `POSE-<figur>-<haltung>`), je mit Kennung, Typ, Rolle, Hoheit vor und nach B-02, Prüfung und Parametern.
- **Abdeckung je Typ:** Σ Schablonen × Parameter ≥ 1,5 × Nachtkapazität in Aufträgen.
- **Eigener Vorlauf-Vorrat** ≥ 8 h Kapazität.
- `dart run tool/bollwerk/vorrat.dart naechste --typ <T|C|B|U> --n <k>` gibt die nächsten Aufträge aus und trägt sie in FLUG.md ein.
- **Nachschub** aus Umfangslücken (Zählbefehle MP-7), roten Tests, überlebenden Mutanten und Befunden. Fällt der Vorrat eines Typs unter 1 h, kommt im selben Zug Nachschub. Der Vollständigkeitskritiker ergänzt nur.

### MP-14 · BOLLWERK (Prüfschichten)
**Torwerkzeug** `dart run tool/bollwerk/bollwerk.dart [schnell|phase|nacht|ziel]`

| Modus | Budget | Inhalt |
|---|---|---|
| schnell | ≤ 9 min | L0; betroffene Paket-Tests; L2 mit 500 Fällen je Eigenschaft; L3 auf Node; L4 mit 200 Partien je Pfad × Strategie; L5; L6 |
| phase | ≤ 55 min, Schwerlast-Slot | zusätzlich `alle_tests.sh` voll und `pruefen.sh alles`; L4 mit 2.000; L7; L8; L9 |
| nacht | ≤ 4 h CPU | L4 mit 10.000 und „immer Pech“; L2 mit 10.000; L9 voll |
| ziel | – | nacht + L10 + Abnahmetabelle |

- **Belege** `planung/bollwerk/belege/L<n>.txt` beginnen mit `HEAD <sha40> · <Berlin-Zeit> · <modus> · Exit <c> · <s>`. Ein Beleg gilt nur bei `git diff --quiet <sha> HEAD -- . ':!planung/bollwerk'` und zusätzlich `git diff --quiet <sha> HEAD -- planung/bollwerk/messbasis planung/bollwerk/BESTAND-AUSNAHMEN.txt`.
- **Fehlerschutz:** `set -euo pipefail`; 0 Treffer für `|| echo`/`|| true` um Prüfbefehle (Selbstprüfung); Timeout je Schicht = 2 × Budget.
- **Endzeile:** genau `BOLLWERK GRÜN · <modus> · <sha>` (Exit 0) oder `BOLLWERK ROT · <schichten>` (Exit 1). Fehlt sie, gilt rot.
- In BW0 wird das Werkzeug abgenommen: Rot-Probe (absichtlich roter Test ⇒ Exit 1) und ein grüner `schnell`-Lauf in ≤ 9 min.

**L0 Fundament**
- `pub get` in allen Paketen; `analyze`; Secret-Scan.
- **L0.1** `tool/bollwerk/bestand.dart`, übernommen aus `kern-feinkorn@1145cb9`. Basis am B-02-Commit. Abweichungen nur laut `planung/bollwerk/BESTAND-AUSNAHMEN.txt` (eingefroren ab BW0, A4.4).
- **L0.2** Schutzpfade: Nach `git fetch` gilt `B=$(git merge-base HEAD origin/main)`. Für jede Datei `p` aus `git diff --name-only $B HEAD -- <A4.8 Nie-Liste>` muss der Blob `HEAD:p` gleich `caf1d61:p`, `1145cb9:p` oder (FREIGABE-Weg) `S_F:p` sein, sonst rot; die Linie wird dann nach der Konfliktregel behandelt. Vor B-02 gilt dasselbe für die Hoheitsliste. Dazu die eingefrorenen Pfade aus A4.4. Die Nie-Liste wird nie gekürzt; `B` wird nie von Hand gesetzt.
- **L0.3** Kanon 1.0 = alle Dateien aus `git ls-tree -r K -- content/party/`, bytegleich und ohne Ausnahme. K = `schlosskeller-1.0^{commit}`; beim FREIGABE-Weg der im PRUEFPUNKT notierte S_F. `messbasis/kanon10.sha256` entsteht in BW0 aus K; eine neue Datei unter `content/party/schlosskeller/` ist rot. MP-16 Schritt 7 prüft K.
- **L0.4** Würfelquelle (WÜ-1/WÜ-6): 0 verbotene Aufrufe.
- **L0.5** `lib/game/**` importiert aus `pixel_engine` nur `feinkorn.dart`.
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
  - Katalog `tool/bollwerk/mutanten/*.patch`, mindestens 40 Mutanten (Seed aus `FallCode.rng`, Pech-Garantie weg, Wurf ändert Fakt, Pech-Szene pfadabhängig, Stufe verschoben, Ruhemodus aus, Maler 1 px, Wortliste gekürzt, `|| true` im Tor, Release importiert `dev/`).
  - Tötungsrate 100 % für Würfel, Lösbarkeit, Wahrheit, Inhalt und Bestandsschutz; ≥ 90 % gesamt.
  - Überlebende Mutanten werden Aufträge. Budget ≤ 40 min, nie parallel zu L8.

**L10 Gremien**
- Urteile stehen in `belege/gremium/<id>.json`: sha256 jedes gezeigten Bilds oder Texts, HEAD, Modell, Briefing-Hash, Eichlauf.
- Ändert sich ein Hash, verfällt das Urteil.

### MP-15 · ABNAHMEKRITERIEN (BK-01 …)
- Jedes Kriterium hat Methode (Befehl in Backticks), Schwelle (Zahl, Vergleich, „0“, „100 %“ oder „bytegleich“) und Beleg.
- Die Wörter „signifikant“, „deutlich“, „angemessen“, „ausreichend“, „sinnvoll“, „hochwertig“ und „schön“ stehen nie ohne Maß im selben Satz.

**Mindestens:**
- Steuerung über Entscheidungen; Sichtbarkeit (C8 Nr. 9)
- WÜ-1 … WÜ-6; C8 Nr. 1–12
- drei Spielformen spielbar (L7); App-Start nach BE-08
- Fortsetzen; Einstieg; Barrierefreiheit
- Spieldauer (C7)
- Look-Treue: Stilprüfung + Golden + iso-/Reihenfolge-Test
- Design D1–D3
- Umfang: U ≥ 10 + Pflichtziele
- Leistung L8; Bestand L0
- Inhaltsregeln L5
- Archiv und Wiederverwertung (MP-5)
- main (MP-16)

**Regression:** Alle Kriterien F:F-01 … F:F-17 gelten weiter. F:F-01, 03, 05, 06, 07, 08, 09, 10, 11, 12, 13, 16 werden auf die erweiterte Struktur hochgerechnet. F:F-14 bleibt Regression des Druckspiels. F:F-17 wird zum Kriterium „main“.

**Glossar:** K-1 wörtlich: „Objekte, Marker und Licht auf der Karte sind vor dem Finale in allen Pfaden gleich.“

### MP-16 · ZUSAMMENFÜHRUNG AUF MAIN
**Linien und Klassen** (Standard, M1 bestätigt)
- FEINKORN `1145cb9`: zusammenführen (rein additiv, Leben).
- HD: nur `caf1d61` zusammenführen. Die Spitze mit den BOLLWERK-Commits wird nie gemergt; `hd/wip/*.patch` bleibt unangewendet.
- Finalisierung: kommt über `origin/main`.
- Nachtlauf und Krimidinner: eingefroren.
- loop: nur archivieren (schon Vorfahr).

**Kriterien je Linie (K1–K7)**
- K1: Jeder Commit hat sein Paket-Tor bestanden.
- K2: Der Probe-Merge `git merge-tree --write-tree` endet mit Exit 0.
- K3: Danach `alle_tests.sh` voll und `bollwerk.dart schnell` grün.
- K4: Burgstadt-Schutz grün.
- K5: Nichts aus `lib/game/dev/**`, `bin/**` oder `tool/**` liegt im Importgraph von `lib/main.dart`.
- K6: Jede sichtbare Bestandsänderung geht als Vorher/Nachher nach FUER-DEN-NUTZER. Standard: hinter einem Schalter mit altem Standard. Geht kein Schalter (HD-Merge in Nie-Pfaden), wird daraus Annahme A-12 mit Vorher/Nachher-Bogen. `caf1d61` wird nur gemergt, wenn `hd_migbeleg` bytegleich bleibt oder „A12: ja“ vorliegt; sonst wird die Linie nur archiviert.
- K7: FEINKORN nur als Leben (Test: `lib/**` nutzt nichts aus `iso_wolke.dart`, `blockkoerper.dart` oder `figur_aufbau.dart`).

**Reihenfolge (fest)**
1. Im Vorlauf: `bollwerk` ← `1145cb9` ← `caf1d61`, je `git merge --no-ff <sha> -m "Merge <ref>@<sha>"`.
2. In BW0: `bollwerk` ← `origin/main`.
3. In BW8: `origin/main` ← `bollwerk`.

Je Linie gilt genau eine Art: echter Merge **oder** Kopie mit Vermerk plus Archiv-Tag. Nie `-s ours`, Squash, Rebase oder Cherry-pick ganzer Linien.

**Konfliktregel**
- Die Liste aus `git merge-tree --write-tree --name-only` kommt vorab ins Log.
- Konflikte in Kanon, textPfaden oder `layout_ausgang.txt` löst niemand per Hand: `git merge --abort`, die Linie wird nur archiviert.
- Status- und Belegdateien: Seite der Linie, danach den Beleg neu erzeugen.
- Code löst nur Opus; danach ein voller Lauf, und `git diff --cc` kommt ins Log.
- Bei mehr als 5 Konfliktdateien oder mehr als 30 min wird die Linie nur archiviert (FUER-DEN-NUTZER).

**Push auf main** (Verfahren des **Leitstands** und des Merge-Baus, V-1; der Nachtlauf führt es nie aus; Tags entfallen nach V-2, `archiv/vor-bollwerk` ist ein Branch; jede Ausgabe geht nach `planung/bollwerk/belege/main.txt`):
1. `git fetch origin`; `V=$(git rev-parse origin/main)`. Ist `bollwerk` kein Nachfahre von V, zuerst `bollwerk` ← V nach den BW0-Regeln.
2. `git -C /home/user/bollwerk worktree add --detach /home/user/bw-int $V`, dann `git -C /home/user/bw-int merge --no-ff <bollwerk-sha> -m "Merge bollwerk@<sha7> (BOLLWERK)"`. Das ergibt MC. Prüfe `test "$(git -C /home/user/bw-int rev-parse HEAD^1)" = "$V"`.
3. An MC: B-02 erfüllt, BW4 bestanden, `bollwerk.dart phase` meldet „BOLLWERK GRÜN · phase · <MC>“. Unfertige Teile sind hinter Schaltern mit altem Standard.
4. An MC: `rm -rf .dart_tool/flutter_build`, `pub get` in allen Paketen, `alle_tests.sh` voll („ALLE TESTS GRÜN“, mit Server-Smoke und Release-Web-Build), `pruefen.sh alles` (Exit 0), Burgstadt-Schutz, Bestand (nur Ausnahmen), voller Secret-Scan.
5. **Leitstand:** `git fetch origin`. Hat sich main bewegt (V′), baut er MC′ = Merge von R auf V′ in einem frischen Worktree. Gilt `git diff MC MC′` = `git diff V V′`, laufen `bollwerk.dart schnell` und der Burgstadt-Schutz an MC′; sonst das volle Tor. Höchstens 3 Anläufe, dann BEREIT ZUR INTEGRATION und Bitte um ein Merge-Fenster.
6. **Leitstand:** `git push origin MC′:refs/heads/main` (Fast-Forward, ohne `--atomic`, ohne Tag). Erst nach Erfolg und Nachprüfung, und nur falls er fehlt: `git push origin MC′^1:refs/heads/archiv/vor-bollwerk`. Ein vorhandener Archiv-Branch bleibt.
7. **Leitstand, Nachprüfung:** `git ls-remote origin refs/heads/main` = MC′; `git merge-base --is-ancestor` gilt für V, R, K, `1145cb9` und `caf1d61` (falls gemergt) gegen MC′. Schlägt sie fehl: kein weiterer Push, kein Revert; Meldung ganz oben.
8. Tags entfallen (V-2). `bollwerk-1.0` steht als fertiger Befehl unter FUER-DEN-NUTZER.

Sonst endet der Lauf mit BEREIT ZUR INTEGRATION: nur `bollwerk` wird gepusht, auch kurz vor M.

**Hinweis:** Ein Push auf main kann die Web-App über Netlify und Vercel (`build.sh`) und den Server über Railway ausliefern (`railway.toml`, `watchPatterns` mit `packages/mordakte_core/**` und `content/**`). Der Lauf ruft nie Deploy-Befehle, Deploy-Hooks oder deren APIs auf; der Morgenbericht sagt, was ausgeliefert werden könnte.

**Rückweg** (nur auf Anweisung des Nutzers): `git revert -m 1 <MC>` (Elternteil 1 = alter main) auf dem neuen Branch `bollwerk-rueckweg`; gepusht wird nur dorthin, nie Force-Push. Dazu der Schalter für den App-Start.

### MP-17 · NEBELKARTE
Mindestens 20 Risiken mit Frühzeichen und Gegenmaßnahme, darunter:
- Startbedingung hängt; der andere Lauf ruht
- Kollision mit Nachzüglern des anderen Laufs
- Berechtigungsnachfrage hält an
- Nutzungs- oder Ratenlimit
- Ereignisstau bei Opus; Kontextverdichtung; Herzschlag reißt
- CPU, RAM, Platte; Agentenprotokolle füllen die Platte
- Haiku-Qualität; Füllstoff; Glücksfrust
- Look-Bruch; Leistung
- WLAN im Browser nur als Gast
- Merge-Konflikte mit HD
- Kanon-Verwechslung; Pfad-Leck über Chancen und Gags
- main liefert aus

### MP-18 · STATUS, WIEDEREINSTIEG, DISZIPLIN
**STAND-Zeile:**
`STAND · Phase [V|BW0…BW8] · Abnahme [a] von [N] · Umfang U [u]× · Aufträge [f] von [g] · Varianten [v] (übernommen [ü]) · Agentenaufrufe [n] · Agenten aktiv [k] · Token [t] von [T] · Bildzeit mittel [ms CPU/Bild, Stand <sha7>] · nächster Schritt: […]`

**Zustandsdateien**
- **KERNKARTE.md** (≤ 1.500 Wörter): Vorrang, harte Verbote, Schleifen, Drossel, Ereignisbudget, Pfade.
- **PRUEFPUNKT.md**: spätestens alle 30 min und bei jedem Tor. Inhalt: laufende Phase, nächster Schritt, Startbild der fremden Checkouts, Herzschlag-IDs, Liste der eigenen Worktrees.
- **FLUG.md** (MP-11), STATUS, NACHTPROTOKOLL (stündlich, echte Uhrzeit).

**Lauf-Sperre:** LEASE in `planung/bollwerk/LAUF.md` nach v4 §8.2 Abschnitt 2.5 (V-6, V-12).

**Nach jeder Verdichtung**
1. KERNKARTE lesen, dann PRUEFPUNKT, dann FLUG.
2. Je FLUG-Zeile die Ausgabe prüfen.
3. Abgebrochene Workflows fortsetzen.
4. Erst dann Neues starten.

**MORGENBERICHT** zur Zeit M (Vorbild `nachtlauf/MORGENBERICHT.md`), in Alltagssprache:
1. Kurz gesagt
2. Zuerst ansehen (Startbefehl)
3. Vorher/Nachher-Kontaktbogen je Raum
4. Die Nacht in Zahlen (U je Achse, Abnahme, Varianten, Aufrufe, Token)
5. Was auf main liegt, mit SHA und Tags
6. Was auf Standardwahlen beruht, mit der Folge beim Kippen
7. Was nicht lief
8. Rückweg
9. Bis zum Store fehlt
10. Nächster Schritt

**Dokumente**
- `docs/bollwerk/ANLEITUNG.md`: Start, drei Spielformen, Würfel, Fortsetzen, WLAN, Optionen
- `planung/bollwerk/ABSCHLUSSBERICHT.md`: ein Beleg je BK
- `planung/bollwerk/SPIELTEST.md`: Ablauf eines echten Testabends mit Fragebogen

### MP-19 · START
Die ersten 10 Handlungen, jede als Befehl:
1. Wurzel `BW=$(git rev-parse --show-toplevel)` (der Sitzungs-Checkout auf `bollwerk`, v4 2.3). Dann `tool/bollwerk/env.sh` anlegen (vorher `export PATH=/opt/flutter/bin:/opt/node22/bin:$PATH`); ab dann gilt A4.10.
2. `planung/bollwerk/PRUEFPUNKT.md` lesen und die Lauf-Sperre prüfen (MP-18): Steht dort `PHASE: NICHT BEGONNEN`, ist es ein Neustart; sonst Wiedereinstieg nach MP-18. Startbild aufnehmen.
3. LEASE übernehmen (v4 2.5).
4. B-02 prüfen.
5. Vorrat laden.
6. Pool anlegen.
7. Erste T-Welle starten.
8. Torwerkzeug-Bau starten (im Vorlauf) oder BW0 beginnen (nach B-02).
9. STAND ausgeben.
10. Zug beenden mit der Zugende-Zeile (v4 2.5).

### MP-20 · ENDE
- **„ZIEL ERREICHT“** nur über `bollwerk.dart ziel`: alle BK-Kriterien und die letzten 2 Prüfrunden ohne bestätigten BLOCKER oder MAJOR.
- **Prüfrunde im Nachtlauf:** 10 Gegenprüfer (Linsen wie Meta-Prompt M6, ohne Vollständigkeitskritiker) auf den Diff seit B-02 und die Abnahmetabelle; 3 Skeptiker je BLOCKER und MAJOR, ein Befund gilt bei 2 von 3; Ergebnis in `belege/pruefrunde/<n>.json` mit HEAD. `bollwerk.dart ziel` liest die letzten zwei und verlangt `git diff --quiet <sha> HEAD -- . ':!planung/bollwerk'`. Höchstens 4 Runden; ab M − 3 h keine neue.
- **Sonst** „BEREIT ZUR INTEGRATION“ mit Restliste, oder „VORLAUF FERTIG“ (MP-2).
- Danach: Herzschlag-IDs löschen, eigene Worktrees abgleichen und entfernen, Morgenbericht senden.
