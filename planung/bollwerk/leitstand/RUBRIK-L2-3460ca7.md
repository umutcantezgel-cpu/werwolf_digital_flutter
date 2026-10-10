Bewertet: MASTER-PROMPT.md sha256 234292126f70a2929c410cc1d051aa5f0a348b420cccb693bb9389839e57b116 (Worktree /home/user/bw-review, Commit 3460ca7e708f, 54.843 Byte)

# Rubrik-Prüfung BOLLWERK · unabhängiger Prüfer (Opus 5.5, frisch)

Gelesen: MASTER-PROMPT.md (vollständig), A-1 bis A-9, STARTPAKET.md, LAGEBILD.md; zum Abgleich DESIGN-PROBE.md, PRUEFBERICHT.md, PLAN.md, proben/werkzeug_audit.sh, proben/b02.sh sowie META-PROMPT.md v4.1 §1, §3, §8, §11. Fundstellen ohne Pfad meinen `planung/bollwerk/`; „MP“ = MASTER-PROMPT.md.

## Ergebnis

**Summe 21/26 · Nullen: 0 · Urteil: NACHBESSERN** (Schwelle 23)

| P | Punkte | Kurzbegründung |
|---|---|---|
| P1 Ziel | 2 | Der Nordstern steht in einem Satz als erreichter Zustand (MP:22). Die Ziele 1–9 (MP:25–33) decken Rundenspiel, „Stark“ im Wortlaut, drei Formen, App-Start, Umfang, Design, Druckspiel, Archiv und main-Übergabe ab. |
| P2 Kontext | 2 | Ausgangslage mit SHAs (MP:35), LAGEBILD mit geprüften Refs und Umgebungsmessungen, Wortlaut und Entscheidungen in A-1, Kanon-Auszug in A-3. Kontext ist vollständig und belegt. |
| P3 Ende | 1 | 35 Z-Zeilen mit Befehl, Schwelle und Beleg sowie eine klare Abschlussregel (MP:193). Gerade das wichtigste Designkriterium Z-14 hat aber keine eindeutige Zählregel, und seine Methode erzeugt die Stimmen nicht selbst (Mängel 3, 5). Z-19 „wirkt“ hat keine Zahl. |
| P4 Steuerung | 1 | 15 Regelkreise, jeder mit Höchstzahl. Es fehlt aber ein Regelkreis für die Design-Aufwertung, obwohl die Probe nur 31 % „nachher besser“ ergab (Mangel 2). Außerdem führt der Ausgang von „Tor rot“ in BW1, BW2 und BW4 in einen undefinierten Zustand (Mangel 8). |
| P5 Widerspruchsfreiheit | 1 | Es gibt vier echte Widersprüche: Tor-Budgets (Mangel 1), wer `belege/**` schreibt (Mangel 4), Z-11 „Würfeltabelle 9/9“ gegen K-05 (Mangel 5) und Vorlauf-Merge gegen Erlaubnisprüfung (Mangel 6). Dazu kommen ein unklarer Vorrang zwischen A-2 und dem Haupttext (Mangel 11) und kleinere Begriffsreste. |
| P6 Grenzen | 2 | Push als exakte Befehlskette (MP:90), abschließende Werkzeug-, Lösch- und Hoheitslisten (MP:91–100, A-2), alles abhakbar. Kleiner Rest: `gh` (CLI) ist nicht ausdrücklich geregelt (siehe Mangel 10). |
| P7 Umgebungstreue | 2 | Agent mit `run_in_background`, `model` und `effort`, außerdem `send_later`, `get_trigger`, SendUserFile und der Wartebefehl sind gemessen (LAGEBILD §5, §7; Meta §11 Kinder-Probe). Unsicheres ist markiert (A-9 §9, MP:16). Kleiner Rest: Die Schritte bei Nutzungslimit (MP:86) setzen voraus, dass das Modell dann noch handeln kann; L-7 deckt das nur als Beobachtung. |
| P8 Ausführbarkeit | 1 | Der Start ist schrittweise und idempotent. Ein frischer Opus kann aber Teile nicht regelkonform ausführen: Das phase-Budget von 55 min ist unerfüllbar und darf nur strenger werden (Mangel 1). A-2:216 verbietet die Protokollablage, die Z-10, Z-14, Z-15 und Z-34 brauchen (Mangel 4). Der Ablauf der D2/D3-Wellen an R fehlt (Mangel 3). Eine verschärfte Schwelle lässt sich gar nicht einspielen (Mangel 7). |
| P9 Robustheit | 1 | Gegen Schönrechnen gibt es starke Sicherungen: TOR-SHA, Schwellen-Hash, Mutanten „Schwelle gesenkt“, F5- und D3-Eichung, Ring 8. Es gibt aber einen eingebauten Frühabbruch: Während langer Tore wird kein Push und kein Herzschlag erlaubt, und der Hänger-Schwellwert des Leitstands liegt bei 90 min (Mangel 1). Hinzu kommen ein falsches „kein Fortschritt“ im Vorlauf (Mangel 9), Lücken im Audit (Mangel 10) und eine nicht erzwungene Bindung von Z-03, Z-05 und Z-06 an die echte Engine (Mangel 12). |
| P10 Dichte | 2 | Kein Füllstoff, jede Zeile trägt eine Regel. Hinweis: Mit 54.843 von 55.000 Byte (Meta §8.1) bleiben 157 Byte Luft, die Nachbesserung braucht also Kürzungen (siehe unten). |
| P11 Modellgerechtheit | 2 | Opus bekommt Ziele, Vorrang, Denkprotokoll und Freiraum (MP:54, :102). Haiku bekommt den 12-teiligen Bauplan, ein Schema, Rollen mit Fehlerbildern und einen wortgleichen Werkzeugabsatz (A-6). Lücke: Ein Antwortschema für D2-Richter fehlt (in Mangel 3 mitbehoben). |
| P12 Start und Generationswechsel | 2 | Auslöser, Generationsprüfung, LEASE, FENSTER, Zugende-Zeile, Weckruf mit Rückfall und STARTPAKET mit `create_session`-Parametern sind konsistent. Kaltstart 3b war grün. Die Fehlauslösung „Hänger“ ist unter P9 gezählt; „zum nächsten Fenster“ (STARTPAKET:43) nennt keine Uhrzeit. |
| P13 Modellreinheit | 2 | Es kommen nur `claude-opus-5-5` und `claude-haiku-5-5` vor (MP:6). Jeder Agentenaufruf nennt `model` und `effort` (MP:6), kein anderer Modellname taucht auf. Kleiner Rest: Die Skeptiker in A-9:70 haben keine Rollenzeile mit Modell. |

## Gezielte Prüffragen

1. **Läuft der Lauf ohne Workflows?** Ja. Alle Agentenarbeit läuft über das Agent-Werkzeug mit `run_in_background: true` (MP:8, A-2:25, A-6 §5); 12 gleichzeitige Agenten sind gemessen (LAGEBILD §5 Nr. 7). Workflow-Reste sind harmlos (A-2:169 „isolation: 'worktree' wird nicht benutzt“). Eine echte Lücke gibt es: `node tool/bollwerk/gremium.mjs d2|d3` (MP:154–155, A-5:37) kann selbst kein Modell aufrufen. Die Haiku-Stimmen müssen also aus einer Agent-Welle kommen, und dieser Ablauf ist nicht beschrieben (Mangel 3). `TaskStop` ist ordentlich als unbelegt markiert (A-9:81).
2. **Ist der main-Push ausgeschlossen?**
   - Für die Opus-Hauptsitzung im Text ja: Es gibt genau eine Push-Kette auf `HEAD:refs/heads/bollwerk` (MP:90, A-2:7). §12 enthält keinen main-Push, und MP:33, :193, :257 übertragen ihn ausdrücklich dem Leitstand.
   - Technisch ist er nicht gesperrt: Der Auto-Modus erlaubt Pushes auf jeden Branch (Meta §11 C11), und eine Sperrdatei gibt es nur nach A-13 (Standard keine).
   - Für Haiku-Agenten gelten Verbot und nachträgliches Audit. Die Audit-Regex in `proben/werkzeug_audit.sh:18` erkennt aber `git -C <pfad> push …` und `gh …` nicht (Mangel 10).
   - Nachträglich würde der Stolperdraht einen bollwerk-Inhalt auf main als „fremden Ref mit tool/bollwerk-Änderung“ rot melden (A-2:188). Das stoppt aber nur Wellen und bricht den Lauf nicht ab.
3. **Sind „starker“ Würfel und Lösbarkeit bindend?** Ja, weitgehend.
   - „Stark“ steht im Wortlaut als Ziel (MP:26), dazu der Kern (MP:104–113) und Z-02 bis Z-06 mit harten Schwellen: Wurfanteil 30–60 %, Pech im ersten Anlauf 20–35 %, Pech-Folge ≤ 2, Median ≥ 2/≥ 2, Quartil ≥ 25 %, 0 Sackgassen, 0 Faktabweichungen.
   - Lösbarkeit steht im Zielkonflikt-Vorrang ganz oben (MP:102). L9b verlangt 100 % Tötung bei Würfel und Lösbarkeit (A-5:116).
   - Schwach sind zwei Stellen: Nur Z-04 ist ausdrücklich „gegen die echte Spiel-Engine“, Z-03, Z-05 und Z-06 nicht (Mangel 12). Und Z-11 verlangt „Würfeltabelle 9/9“, obwohl nur 5 Pflichtentscheidungen würfeln (Mangel 5).
4. **Ist die Design-Aufwertung messbar und erzwungen?**
   - Messbar ja: D1 (Z-13), D2 ≥ 85 % (Z-14), D3-Eichung (Z-15), S1–S6 (Z-16), Look-Anker (Z-17).
   - Erzwungen nur am Ende: über die Abschlussregel und ab dem `nacht`-Tor in BW7, denn D2 und D3 laufen erst in `nacht` und `ziel` (A-5:126). Vorher gibt es keinen D2-Zwischenstand, kein Zwischenziel und keinen Regelkreis.
   - Die Ausgangslage ist dabei schwach: Die Meta-Probe erkannte die Aufwertung nur in 25/36 Fällen und wertete nur 11/36 (31 %) als „nachher besser“ (DESIGN-PROBE §2). Diese Zahl steht nicht einmal im Master-Prompt.
   - Damit droht, dass der Lauf erst in BW7 bemerkt, dass Z-14 unerreichbar ist (Mangel 2). Zusätzlich ist die Zählregel von Z-14 mehrdeutig (Mangel 3).

## Mängel nach Wirkung (müssen für sicher ≥ 23 behoben werden)

**Nebenbedingung für alle Ersatztexte:** MP hat 54.843 Byte bei einer Grenze von 55.000. Die Ersatztexte unten fügen etwa 2,5 KB hinzu. Ausgleich, ohne Regeln zu verlieren:
- MP:212 (Lichtungsaufgaben, 823 B) wird zu „Lichtungsaufgaben L-1…L-8: A-9 §10 (erste Arbeit der ersten Generation, Ergebnis ins ENTSCHEIDUNGSLOG).“, der Text kommt als neuer Abschnitt A-9 §10.
- MP:242 (Tokenrahmen, 728 B) geht nach A-9 §3 Nr. 26 und wird ersetzt durch: „Kontingent, Tokenrahmen, Ereignisbudget: A-9 §3 Nr. 26.“
- MP:125 (Fabrikprobe-Erfahrung, 231 B) geht nach A-6 §5.
- MP:248 (Bilder, 468 B) geht nach A-9 §4a, dafür: „Kontaktbögen nach A-9 §4a; der Leitstand zeigt sie im Chat.“

Das spart etwa 2,1 KB. Den Rest liefert eine Kürzung von MP:35 auf „Ausgangslage: LAGEBILD.md (geprüft 09.10.2026); Wortlaut und Entscheidungen des Nutzers: A-1 (bindend).“

1. **Tor-Budgets unerfüllbar, Herzschlagsperre führt zur Ablösung** (P5, P8, P9)
   - Fundstellen: MP:94, MP:196, MP:214, MP:229; A-5:39 und A-5:47–49 gegen die Schichtbudgets in A-5:26–37; STARTPAKET:41.
   - `phase` ist auf ≤ 55 min begrenzt, die Schichtbudgets summieren sich aber auf ≈ 185 min (L1 12 + L4 15 + L7 25 + L8 15 + L9 40 + L12 60 + …). Allein der serielle Schwerlast-Slot braucht ≥ 140 min.
   - MP:94 verbietet zwischen Code-Commit und grünem Tor jeden Push, auch den Herzschlag. Der Leitstand erklärt nach 90 min ohne Herzschlag einen Hänger und startet eine neue Generation. Die laufende Generation wird dann mitten im Tor abgelöst.
   - Budgets gelten als Schwellen (MP:19) und dürfen nur strenger werden, legal lässt sich das also nicht auflösen.
   - Ersatz MP:94: „- Code, dessen Tor `phase` oder `nacht` ist, und ungeprüfte Merges (BW0, Hereinholen von main) committest du in einem eigenen Worktree `/home/user/bw-arbeit/tor` auf dem lokalen Branch `bw-tor`; dort läuft das Tor. Nach grünem Tor: `git -C $BW merge --no-ff bw-tor -m "Tor grün · <modus> · <sha>"`, dann Push (der Unterschied liegt nur unter `planung/bollwerk/`, der Beleg bleibt gültig). Herzschlag und Zustands-Commits auf `bollwerk` laufen währenddessen alle 30 min weiter. Code mit Tor `schnell` geht direkt über `commit.sh`.“
   - Ersatz in MP:196 statt „mit Budgets ≤ 9 min, ≤ 55 min, ≤ 4 h CPU“: „mit Wandzeit-Budgets `schnell` ≤ 9 min, `phase` ≤ 190 min, `nacht` ≤ 5 h (Summe der Schichtbudgets aus A-5 bei seriellem Schwerlast-Slot; L-1 misst sie in G1); ein überschrittenes Budget ist ein Befund in NACHTPROTOKOLL und FUER-DEN-NUTZER, kein Rot“. Dieselben Werte gehören in A-5:39 und A-5:47–49.
   - Ersatz im Satz zu BW8 in MP:214: „BW8 beginnt spätestens E − 10 h (phase, Hereinholen, zwei Prüfrunden, R, D2/D3-Wellen an R, `ziel` spätestens E − 5,5 h gestartet); reicht das Fenster nicht, endet die Generation mit NACHT-ENDE und `BW8-REST <schritt> an R` im PRUEFPUNKT, und die nächste Generation setzt an demselben R fort, solange `git merge-tree --write-tree origin/main R` konfliktfrei ist.“

2. **Design-Aufwertung ohne Regelkreis und ohne Zwischenstand** (P4, P9)
   - Fundstellen: MP §9 (Tabelle MP:222–239), MP:102, A-5:126, A-8 Teil 1, PLAN §4 (einzige Design-Zeile „N5 … Design D2“).
   - D2 läuft erst im `nacht`-Tor von BW7. Die Meta-Probe ergab 11/36 = 31 % „nachher besser“ bei einer Schwelle von 85 %.
   - Neue Zeile in MP §9 vor „Drossel“: „| D2-Probe (nach BW3 und nach jeder zweiten Design-Welle: 2 Räume × 3 Ansichten, beide Reihenfolgen, Zählregel Z-14) | Zwischenziel aus A-8 §1.6 erreicht; sonst nächste Design-Welle mit stärkerer Dosis der besten Richtung (A-01), Bogen nach FUER-DEN-NUTZER; nach 2 Proben ohne +10 Punkte Richtung wechseln | 4 je Generation |“
   - Neuer Abschnitt A-8 §1.6: „### 1.6 Design-Zwischenziele (D2-Probe, Zählregel Z-14)\nMeta-Probe: 11/36 = 31 % „nachher besser“ (DESIGN-PROBE §2). Zwischenziele: nach BW3 ≥ 50 %, nach der ersten BW5-Design-Welle ≥ 65 %, vor BW7 ≥ 85 %. Unter dem Zwischenziel gehen zwei von drei Wellen an Design; unter 85 % beginnt BW7 nicht.“
   - Ergänzung in MP:102 nach „gleichrangig, Wellen abwechselnd“: „(unter dem D2-Zwischenziel aus A-8 §1.6 zwei von drei Wellen Design)“.

3. **Z-14/Z-15: Zählregel mehrdeutig, Stimmenerzeugung und Ablauf an R fehlen** (P3, P8, P11)
   - Fundstellen: MP:154, MP:155, MP:255–256, A-5:37, A-5:124.
   - Mehrdeutig ist: ob Paare oder Darbietungen gezählt werden, ob beide Reihenfolgen übereinstimmen müssen, wie groß der Nenner mit oder ohne Queransicht ist (Lücke BW6) und was „Mehrheit in jedem Raum“ heißt.
   - `gremium.mjs` kann kein Modell rufen. Die Stimmen verfallen bei jedem neuen Bild-Hash (A-5 L10), §12 ordnet die Welle an R aber nicht an.
   - Ersatz der Schwellenspalte von Z-14: „49 Paare = 7 Räume × 2 Kanon-Lichtzustände × 3 Ansichten (393×852, 852×393, 1180×820, Pixeldichte 2) + 7 Bewegungsstreifenpaare; jedes Paar in beiden Reihenfolgen (per Seed) als eigene, zufällig benannte Kopien gleicher Größe ohne Metadaten; je Darbietung 5 Haiku-Stimmen (`model: "haiku"`, `effort: "max"`, Antwort `{paar, besser: A|B|gleich, sicherheit: 1–5}`), Stimmen mit Sicherheit 1 zählen nicht; ein Paar ist „nachher besser“, wenn in beiden Reihenfolgen die Mehrheit der gültigen Stimmen „nachher“ wählt; ≥ 85 % der 49 Paare und in jedem Raum ≥ 4 seiner 7 Paare; kein `VETO D2` offen“.
   - Ersatz der Methodenspalte von Z-14 und Z-15: „`node tool/bollwerk/gremium.mjs d2` (bzw. `d3`; zählt nur Stimmen aus `belege/gremium/protokolle/` zu Bildern mit sha256 an HEAD; ruft nie selbst ein Modell auf)“.
   - Neuer Schritt in MP §12 nach Schritt 4: „4a. An R: Web-Build und Fotos nach A-8 §1.3, `node tool/bollwerk/gremium.mjs vorbereiten --an R` (Paare, Eichsatz, Lösung außerhalb des Stapels), dann D3- und D2-Welle als Haiku-Agenten über das Agent-Werkzeug, Protokollauszüge mit `bollwerk.dart gremium-import <welle>`; erst danach Schritt 5.“

4. **Widerspruch: Wer schreibt `belege/**`?** (P5, P8)
   - Fundstellen: A-2:216 („schreibt nur das Torwerkzeug“) gegen A-5:20 und A-5:124 (Opus kopiert Protokollauszüge nach `belege/gremium/protokolle/`), A-9:70/72 (`belege/pruefrunde/<n>.json`), MP:146 (Z-10) und MP:190 (Z-34).
   - Hält Opus die harte Regel ein (A-2 hat Vorrang), werden Z-10, Z-14, Z-15 und Z-34 nie grün.
   - Ersatz für den ersten Satz von A-2:216: „- `planung/bollwerk/belege/**` schreibt nur das Torwerkzeug; Ausnahmen, nur als neue Dateien: `belege/gremium/**` über `dart run tool/bollwerk/bollwerk.dart gremium-import <welle>` (Auszüge nach A-5 L11) und `belege/pruefrunde/<n>.json` über `dart run tool/bollwerk/bollwerk.dart pruefrunde --schreibe <n>`.“
   - In A-5:124 und A-9:72 heißt es dann jeweils „über `bollwerk.dart gremium-import` bzw. `pruefrunde --schreibe`“.

5. **Z-11 „Würfeltabelle 9/9“ widerspricht K-05 und MP §4.2** (P5, P3)
   - Fundstelle: MP:147 gegen MP:107, A-4 K-05 und A-8:69 („je Entscheidung mit Wurf“). Nur e2_1, e2_2, e2_3, e3_1 und e3_2 würfeln.
   - Ersatz in MP:147 für „Würfeltabelle 9/9“: „Würfeltabelle je würfelnder Entscheidung (Pflicht 5/5: e2_1, e2_2, e2_3, e3_1, e3_2; dazu jede würfelnde Folge-, Abstecher- und Auftakt-Entscheidung), 0 an Befragungen“.

6. **Vorlauf-Merge von `1145cb9` verstößt gegen die Erlaubnisprüfung** (P5, P8)
   - Fundstellen: MP:201 und MP:182 (Z-30 „Merge … nur im Vorlauf“) gegen A-2:205 (vor B-02 nur eigene Pfade, „Merges zugelassener Linien“ erst nach B-02). Das `schnell --vorlauf`-Tor (L0 mit L0.2) würde rot.
   - Ersatz A-2:205 ab „vor B-02 nur …“: „vor B-02 nur `planung/bollwerk/**` (ohne MASTER-PROMPT, anhang, STARTPAKET), `tool/bollwerk/**`, `content/runden/**`, `packages/mordakte_core/lib/src/runden/**`, `packages/mordakte_core/test/runden/**`, `lib/runden/**`, `assets/runden/**`, `test/runden/**`, `docs/bollwerk/**` sowie Dateien aus den Vorlauf-Merges von `1145cb9` und (nur nach A-2 Definitionen) `caf1d61`, deren Blob gleich dem der Linie ist; nach B-02 zusätzlich die übergegangenen Pfade aus A4.8 und Merges zugelassener Linien.“

7. **„Schwelle strenger über STEUERUNG.md“ ist nicht umsetzbar** (P5, P8)
   - Fundstellen: MP:19 und MP:82 gegen MP:99. Abschnitt 6 ist unveränderlich, `messbasis/schwellen.json` ist ab BW0 eingefroren, und jedes Tor prüft beide Hashes.
   - Ersatz des letzten Satzes von MP:19: „Geändert wird eine Schwelle nur in Richtung „strenger“ (≥-Schwellen steigen, ≤-Schwellen sinken), über STEUERUNG.md: du hängst `<Z-Nr> · <Schwelle> · <neuer Wert> · S-<n>` an `planung/bollwerk/SCHWELLEN-NACHTRAG.tsv` an; das Torwerkzeug nimmt je Schwelle den strengeren Wert aus `schwellen.json` und Nachtrag und ist rot, wenn eine Nachtragszeile lockert.“

8. **Regelkreis „Tor rot“ endet in einem undefinierten Zustand** (P4)
   - Fundstelle: MP:229. Die Kürzungsleiter betrifft nur den Umfang. Für ein rotes BW1-, BW2- oder BW4-Tor bleibt offen, was danach geschieht. 2 h reichen bei realer `phase`-Dauer für keinen zweiten Lauf.
   - Ersatz MP:229: „| Tor rot (jede Stufe) | grün; sonst `TOR-ROT <phase> <schichten>` in NACHTPROTOKOLL und FUER-DEN-NUTZER, Phase bleibt gesperrt, weiter mit Aufträgen, die dieses Tor nicht berühren; betrifft es Umfang oder Design, zusätzlich nächste Stufe der Kürzungsleiter; die nächste Generation beginnt mit diesem Tor | 3 Reparaturen oder 4 h je Tor und Generation |“

9. **Falsches „kein Fortschritt“ im Vorlauf** (P9)
   - Fundstelle: MP:218 (letzter Satz). Vor BW0 gibt es kein U, und Z-Kriterien wachsen kaum. Zwei Vorlauf-Generationen (PLAN: 1–2 Vorlauf-Nächte) lösen deshalb einen Stopp aus, der bis zu einem „WEITER“ des Nutzers hält.
   - Ersatz: „Ab BW0: zwei Generationen in Folge ohne Zuwachs bei U und ohne neues grünes Z-Kriterium → NACHT-ENDE „kein Fortschritt“ in FUER-DEN-NUTZER und Morgenbericht. Im Vorlauf stattdessen: zwei Generationen ohne neuen grünen Vorlauf-Beleg und ohne neue Vorrat-Einheiten → `ZUSTAND: VORLAUF FERTIG`.“

10. **Lücken im Werkzeug-Audit: `git -C`, `gh`, Zugriffe auf `$BW`** (P6, P9; main-Push)
    - Fundstellen: proben/werkzeug_audit.sh:18 (Vorlage für `tool/bollwerk/werkzeug_audit.sh`, MP:263) gegen MP:98, das „git … Zugriffe auf `$BW`“ zusagt.
    - Die Regex `git +(push|…)` erkennt `git -C <pfad> push` nicht, ebenso keine `gh`-Aufrufe und keine Bash-Schreibzugriffe nach `$BW`.
    - Ersatz in proben/werkzeug_audit.sh:18: Der erste Teil von `bash_rot` wird zu `(^|[;&|( ]) *git( +-[cC] +[^ ]+| +--[a-z-]+(=[^ ]+)?)* +(commit|push|reset|checkout|switch|merge|rebase|tag|worktree|update-ref|branch +-[dDmM])`, angehängt wird `|(^|[;&|( ]) *gh +`. Dazu kommt eine Prüfung vor dem Entfernen der Anführungszeichen: `grep -E '/home/user/werwolf_digital_flutter'` → Verstoß. Jedes Muster bekommt eine Rot-Probe.
    - Ergänzung in MP:91 nach „Pull Requests.“: „`gh` nur lesend (nie `gh pr`, `gh release`, `gh repo`, `gh api` mit `-X`/`--method` außer GET).“

11. **Vorrang zwischen A-2 und Haupttext ist mehrdeutig** (P5)
    - Fundstelle: MP:102 („Grenzen (A-2) → …“ und zugleich „Widerspricht ein Anhang diesem Text, gilt dieser Text“).
    - Beispiel: MP:79 sieht ABBRUCH nur bei „schreibendem“ Werkzeugverstoß vor, A-2:21 bei „schreibendem oder steuerndem“.
    - Ersatz für den letzten Satz von MP:102: „Widerspricht ein Anhang diesem Text, gilt dieser Text – außer bei Grenzen: dort gilt von A-2 und Abschnitt 3 jeweils die strengere Fassung (z. B. ABBRUCH auch bei steuerndem Werkzeugverstoß, A-2 A4.2); zwischen Anhängen: Nachtrag vor älterem Teil, Teil 1 vor Teil 2, sonst der strengere Wert.“

12. **Lösbarkeit und „Stark“ nicht ausdrücklich an die echte Engine gebunden** (P9)
    - Fundstellen: MP:135, MP:137, MP:138 (Z-03, Z-05, Z-06). Nur Z-04 (MP:136) sagt „gegen die echte Spiel-Engine“. Der Restpunkt L03#1 aus PRUEFBERICHT §2 (Simulator führt `alle_aufgedeckt` fest) bleibt so offen.
    - Ergänzung am Ende von MP:128: „Alle L4-Modi (Z-03…Z-07, Z-12) laufen gegen den Würfelkern unter `packages/mordakte_core/lib/src/runden/` und die echte Spiel-Engine, nie gegen ein eigenes Modell; die L9b-Mutanten „Pech-Garantie weg“, „Wurf ändert Fakt“ und „Stufe verschoben“ werden am Kern angewandt und machen die zugehörige Z-Zeile rot.“

## Kleinere Punkte (nicht nötig für ≥ 23, aber billig)
- A-9:70: „3 Skeptiker“ → „3 Skeptiker (`model: "haiku"`, `effort: "max"`)“ (P13).
- A-9:78 Glossar: L0–L10 → L0–L12, F1–F5 → F1–F6, S1–S5 → S1–S6; Leitstand, Tor, Slot und Welle ergänzen (MP:17 verweist darauf). A-1:41 „OFFENE FRAGE“ gegen MP:54 „Frage ja“ angleichen. A-9:16 `SPERREN folge=…` → `SPERREN gen=<n> folge=<a> gesamt=<b>` (wie MP:55).
- Z-19 (MP:159): „„Bewegung reduzieren“ wirkt“ → „mit „Bewegung reduzieren“ 0 Teilchen, 0 Kamerafahrten und Szenen ≤ 1 s“.
- STARTPAKET:43: „G n+1 zum nächsten Fenster“ mit Uhrzeit festlegen, z. B. „sofort, außer zwischen 07:00 und 19:00 Berlin, dann um 19:00“.
- MP:86: Den Satz zum Nutzungslimit als „nicht belegt, L-7“ kennzeichnen. Wenn die Hauptsitzung selbst im Limit steht, greifen nur der 60-min-Weckruf und der Leitstand.
