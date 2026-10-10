6eb7a606433d0abf524992e2dc329272510bff2e98eeac93632ebafc25298a40

# Rubrik Leitstand R4 · MASTER-PROMPT BOLLWERK (Worktree bw-review, Commit 2094a67)

Ich habe Folgendes geprüft: MASTER-PROMPT.md (54.822 Byte, 273 Zeilen), A-1 bis A-9, STARTPAKET.md, LAGEBILD.md, die Proben `werkzeug_audit.sh` und `b02.sh` sowie die Abschnitte §1, §3, §8 und §11 des Meta-Prompts v4.1. Im Repo habe ich nichts geändert.

## Bewertung

| P | Punkte | Begründung |
|---|---|---|
| P1 Ziel | 2 | Der Nordstern ist ein erreichter Zustand in einem Satz (MP:22). Die neun Ziele (MP:25–33) decken den ganzen Nutzerwillen ab: Runden mit sichtbarer Aktion, „Stark“ im Wortlaut, drei Spielformen, Start im Schlosskeller, 10–100×, Bild-Look + Leben, Druckspiel, Archiv, main über den Leitstand. |
| P2 Kontext | 2 | LAGEBILD liefert geprüfte Refs, B-02-Probe und Umgebung. A-1 gibt Wortlaut und Entscheidungen, A-3 den Kanon, BESTAND §2 die Linien. Werkzeugkette und Pfade sind konkret (MP:14, MP:265). |
| P3 Ende | 2 | Z-01 bis Z-35 haben je Befehl, Zahlenschwelle und Belegpfad. Dazu kommen der Belegkopf mit HEAD und tree, Gültigkeit nur bei unverändertem Baum, L11 aus `abnahme.tsv` und eine eindeutige Abschlussregel (MP:193). |
| P4 Steuerung | 2 | §9 führt 15 Regelkreise, jeden mit Ausgang und Höchstzahl. Hinzu kommen Kürzungsleiter, „kein Fortschritt“ über zwei Generationen und eine Weißliste mit Quittung. Kleine Unschärfen (Drossel ohne Zahl, D2-Probe ohne Ausgang nach der 4. Probe) wiegen nicht schwer. |
| P5 Widerspruchsfreiheit | 1 | Es bleiben mehrere Widersprüche zwischen Prompt und Anhängen. Die Vorrangregel (MP:102) löst die meisten auf, aber nicht alle eindeutig: Tor-Rot endet in MP:229 mit „weiter“, in A-9:98 mit „NACHT-ENDE“. Die Merges in `bw-tor` (MP:94) fallen nicht unter die „einzige Ausnahme“ in A-2:12. `commit.sh` in MP:265 hat kein `--tor`. `belege/` gilt in A-2:12 als Zustandsdatei, fehlt aber in der torfreien Liste MP:66. |
| P6 Grenzen | 2 | Push-Kette mit Branch-Test und festem Refspec (MP:90), abschließende Verbotsliste für Werkzeuge (MP:91), Hoheits- und Erlaubnislisten (A-2 A4.8 und Zusatz), Löschregel (MP:100). Alles ist einzeln abhakbar. |
| P7 Umgebungstreue | 1 | Vieles ist belegt (Wartebefehl, 12 Agenten, Modellprobe) oder als unbelegt markiert (L-7, L-8, A-9 §9). Es fehlt aber die bekannte Grenze von höchstens 2 h für Bash-Hintergrundbefehle (Standard 30 min). Die Budgets `phase` ≤ 190 min, `nacht` ≤ 5 h und `ziel` > 5 h (MP:196, A-5:39) sind so nicht ausführbar, und der Prompt sagt weder, wie man sie abkoppelt, noch markiert er das als unbelegt. |
| P8 Ausführbarkeit | 2 | Startbefehle, Werkzeugbau, Pool, Patchweg und Merge sind wörtlich da, Kaltstart 3b ging ohne Rückfrage. Die offenen Stellen (abgekoppelter Torlauf, Belege-Commit) kann Opus selbst entscheiden. |
| P9 Robustheit | 2 | Früher Stopp: „Laufende Arbeit“, Weckruf alle 30 min auf +60 min, Herzschlag. Schleifen: Höchstzahlen und „kein Fortschritt“. Abdriften: KERNKARTE und Lesen aus P. Schönrechnen: eingefrorene Messbasis, Belege nur vom Torwerkzeug, Mutanten „Schwelle gesenkt“ und „Zählregel gelockert“, Stimmen nur aus Protokollauszügen, `ziel` prüft am Ende alles neu. |
| P10 Dichte | 2 | Der Text ist sehr dicht und fast frei von Füllstoff. Die Doppelungen (§2.3/§13, Kurzfassung von A-2) sind gewollt und haben eine Vorrangregel. Nachteil: Mit 54.822 von 55.000 Byte bleibt fast kein Platz für Nachbesserungen, und einzelne Absätze bündeln zu viele Regeln (MP:19, MP:43). |
| P11 Modellgerechtheit | 2 | Opus bekommt Ziele, das Denkprotokoll, Kernhoheit und freie Pakete der Stufe 3. Haiku bekommt den 12-teiligen Bauplan, ein festes Schema, eine Rückgabezeile, Rollen mit Fehlerbildern und eine Denkstufe je Rolle (A-6). |
| P12 Startbarkeit und Generationswechsel | 1 | Der Start ist schlüssig: Auslöser, P-Prüfung, LEASE, FENSTER, Zugende, Weckruf, STARTPAKET, Hänger-Kriterium. Aber Code, der in `bw-tor` noch nicht gemergt ist, liegt nur lokal. Die Sicherung nach `/home/user/…` (MP:63, MP:100) überlebt keinen Maschinenwechsel, und lange Tore haben keine Startgrenze vor E. Die Regel „die nächste Generation beginnt mit diesem Tor“ (MP:229) ist dann nicht ausführbar. |
| P13 Modellreinheit | 2 | Es kommen nur Opus 5.5 und Haiku 5.5 vor (MP:6). Jeder Agentenaufruf nennt `model` und `effort` (MP:6, MP:118, A-6 §3, A-8 §1.7, A-9 §6). Die Zuordnung `model: "opus"` ist als unbelegt markiert und hat eine Prüfung (A-9:89). |

### Mängel unter 2 mit Ersatztext

**P5-a · Ausgang von Tor-Rot widersprüchlich.** A-9-BETRIEB.md:98 schreibt „Nach 4 h TOR-ROT ohne Grün: `ZUSTAND: NACHT-ENDE`“, MASTER-PROMPT.md:229 schreibt „weiter mit Aufträgen, die dieses Tor nicht berühren“.
Ersatz für den letzten Satz von A-9-BETRIEB.md:98:
> Nach 3 Reparaturen oder 4 h TOR-ROT ohne Grün gilt Master-Prompt §9: weiter mit Aufträgen, die dieses Tor nicht berühren; TOR-ROT steht mit Grund im Morgenbericht, und die nächste Generation beginnt mit diesem Tor.

**P5-b · `commit.sh` und Merges in `bw-tor`.** In MASTER-PROMPT.md:265 ist der Branch in `commit.sh` fest auf `bollwerk` gesetzt und `--tor` fehlt. MASTER-PROMPT.md:94 legt Merges mit Tor `schnell` (BW0) in `bw-tor`. A-2-HARTE-REGELN.md:12 nennt als „einzige Ausnahme“ aber nur Code mit Tor `phase` oder `nacht`.
Ersatz für die Klammer zu `commit.sh` in MASTER-PROMPT.md:265:
> (Branch `bollwerk`, Pfadliste, Secret-Scan, Tor der Phase, Zustands-Commits ohne Tor nach 2.5, Push nur `HEAD:refs/heads/bollwerk`; Modus `--tor <modus>` nach A-2 A4.1: nur Branch `bw-tor` im Worktree `/home/user/bw-arbeit/tor`, gleiche Prüfungen, kein Push; Merges dort mit `git merge --no-ff --no-commit <ref>`, danach `commit.sh --tor <modus>`)

Ersatz in A-2-HARTE-REGELN.md:12:
> Einzige Ausnahme: Code, dessen Tor `phase` oder `nacht` ist, und ungeprüfte Merges (Vorlauf-Merges, BW0, Hereinholen von main) committest du im Tor-Worktree auf `bw-tor` mit `commit.sh --tor <modus>`

**P5-c · Belege nicht torfrei.** In MASTER-PROMPT.md:66 fehlt `belege/`. Wörtlich gelesen verlangt der Commit der `ziel`-Belege dann wieder ein `ziel`-Tor.
Ersatz in MASTER-PROMPT.md:66 für „…, KERNKARTE, bilder/)“:
> …, KERNKARTE, bilder/, belege/ (nur so, wie Torwerkzeug, `gremium-import` und `pruefrunde --schreibe` sie geschrieben haben), tor-rest/)

**P7 · Lange Tore über der 2-h-Grenze.** Betroffen sind MASTER-PROMPT.md:15 und :196 sowie A-5-PRUEFMAUER.md:39. Neue Zeile nach MASTER-PROMPT.md:15:
> - Lange Befehle: Ein Bash-Hintergrundbefehl endet nach höchstens 2 h (Standard 30 min). Tore `phase`, `nacht`, `ziel` und jeder Befehl mit Budget > 100 min laufen abgekoppelt: `setsid nohup flock /tmp/bw-schwer.lock dart run tool/bollwerk/bollwerk.dart <modus> > /home/user/bw-logs/tor-<modus>-<sha7>.log 2>&1 < /dev/null &`; PID und Logpfad in den PRUEFPUNKT; gewartet wird mit dem Wartebefehl auf `grep -qE '^BOLLWERK (GRÜN|ROT)' <log>`. Nicht belegt, ob der abgekoppelte Prozess länger als 2 h lebt: Lichtungsaufgabe L-9 prüft es in G1 mit `setsid nohup sleep 7500 > /dev/null 2>&1 &` (lebt er nach 125 min noch?). Scheitert L-9, läuft jedes Tor in Schichtgruppen unter 100 min (`bollwerk.dart <modus> --gruppe <k>` am selben HEAD; die Endzeile schreibt erst die letzte Gruppe).

**P12 · `bw-tor`-Stand geht beim Generationswechsel verloren.** Betroffen sind MASTER-PROMPT.md:63, :100 und :229 sowie A-2-HARTE-REGELN.md:170. Neue Zeile nach MASTER-PROMPT.md:94:
> - Tor und Fensterende: Ein Tor in `bw-tor` startest du nur, wenn es nach seinem Budget vor E − 30 min endet. Ist `bw-tor` bei Generationsende nicht gemergt, sicherst du ihn im Repo: `git -C /home/user/bw-arbeit/tor diff --binary bollwerk...bw-tor > $BW/planung/bollwerk/tor-rest/G<n>.patch`, Secret-Scan, Zustands-Commit, Zeile `TOR-REST G<n> · <phase> · <sha256>` im PRUEFPUNKT. Die nächste Generation legt den Tor-Worktree neu an, wendet den Patch mit `git -C /home/user/bw-arbeit/tor apply --index` an, committet mit `commit.sh --tor <modus>` und beginnt mit diesem Tor. Patches unter `/home/user/` überleben keinen Maschinenwechsel.

Platzhinweis: Der Prompt hat noch 178 Byte Luft, die Ersatztexte für P7 und P12 brauchen etwa 1,3 KB. Ich schlage vor, beide als neuen Abschnitt A-9 §12 abzulegen und im Prompt nur zu verweisen: „Lange Tore und Tor-Rest: A-9 §12“. Zum Ausgleich kann die Klammer in MASTER-PROMPT.md:95 entfallen, weil derselbe Satz schon in A-2 A4.9 steht.

## Gezielte Prüfungen

1. **Ohne Workflows:** Ja. MP:8, A-2:25 und A-1:112 regeln das, die Wellen laufen über das Agent-Werkzeug mit `run_in_background` (A-6:67). Auch die D2- und D3-Wellen laufen über das Agent-Werkzeug (MP:257), und FLUG führt `agentId` statt `runId` (A-9:20). A-2:171 erwähnt die Workflow-Option `isolation` noch, aber nur als Verbot. Das schadet nicht.
2. **main-Push ausgeschlossen:** Ja. Die Push-Kette prüft den Branch und hat einen festen Refspec (MP:90). Die Liste der Push-Ziele ist abschließend (A-2:7). Dazu kommen MP:12, :33 und :193. Ein Steuereintrag, der das Push-Ziel ändert, wird abgelehnt (MP:83). Den main-Push macht nur der Leitstand (STARTPAKET:29, :43).
3. **„Würfel stark“ und Lösbarkeit bindend:** Ja. „Stark“ steht im Wortlaut in MP:26. Es folgen Kern K-2 bis K-6 (MP:107–111), WÜ-3 als harte Regel (A-2:110), die Schwellen Z-03, Z-05 und Z-06 und Lösbarkeit an erster Stelle im Vorrang (MP:102). Die L9b-Mutanten „Pech-Garantie weg“, „Wurf ändert Fakt“ und „Stufe verschoben“ machen das Tor rot (MP:128).
4. **Messbarer Regelkreis für das Design:** Ja. Die D2-Probe (MP:239) misst nach der Zählregel Z-14 (A-8 §1.7) gegen die Zwischenziele 50/65/85 % (A-8 §1.6). Verfehlt sie das Ziel, steigt die Dosis; nach zwei Proben ohne +10 Punkte wechselt die Richtung; höchstens 4 Proben je Generation. Unter dem Zwischenziel gehen zwei von drei Wellen an Design (MP:102), unter 85 % beginnt BW7 nicht. Kleine Lücke: Was nach der 4. Probe einer Generation geschieht, steht nicht ausdrücklich da.
5. **Lange Tore ohne falsche Hänger-Meldung:** Für den Leitstand ja. Der Herzschlag läuft während des Tors in `bw-tor` alle 30 min weiter (MP:94, :66), und der Weckruf rückt bei jedem Prüfpunkt auf +60 min (MP:80). Das Hänger-Kriterium verlangt beides zugleich (STARTPAKET:41). Es entsteht aber ein **falsches Rot**: Ein Torprozess, der länger als 2 h als Hintergrundbefehl läuft, wird abgebrochen. Ohne Endzeile gilt das Tor als rot (siehe P7).
6. **Letzte zwei BLOCKER:** Beide sind behoben.
   - Für `bw-tor`-Commits nennt A-2:12 jetzt ausdrücklich `commit.sh --tor <modus>` mit Merge- und Konfliktregel.
   - `feinkorn_leben.dart` ist vor B-02 erlaubt (A-2:148, Zusatz Erlaubnisprüfung A-2:207, MP:201).
   - Reste, nur MINOR: siehe P5-b. Außerdem ist die „Liste in B5“ (A-2:143) nicht Teil der Anhänge, und die Blob-Regel in A-5:60 („vor B-02 dasselbe für die Hoheitsliste“) könnte die neue Datei treffen, wenn `pixel_engine` zur Hoheitsliste gezählt wird.

## Ergebnis

Summe 23/26 · Nullen 0 · Urteil FREIGABE

Die Freigabe liegt genau auf der Schwelle. Die Mängel 1 und 2 greifen erst ab BW1, also nach B-02, weil der Vorlauf nur `schnell --vorlauf` mit ≤ 9 min nutzt. Ich empfehle, sie in einer neuen Übergabe P zu beheben, bevor B-02 eintritt.

## Verbleibende Mängel (nach Wirkung)

1. **MAJOR** · Tore über der 2-h-Grenze für Hintergrundbefehle: `phase`, `nacht` und `ziel` werden abgebrochen, das Tor ist ohne Endzeile rot, und spätestens nach 4 h folgt NACHT-ENDE (A-9:98). So wären BW7 und BW8 nicht erreichbar. Fundstellen MP:15, :196, A-5:39; Ersatz unter P7.
2. **MAJOR** · Nicht gemergter `bw-tor`-Code und Patch-Sicherungen unter `/home/user/` gehen beim Generationswechsel verloren. Lange Tore haben keine Startgrenze vor E (MP:214 begrenzt nur Aufträge und `ziel`). Fundstellen MP:63, :100, :229, A-2:170; Ersatz unter P12.
3. **MINOR** · Der Merge von `bw-tor` nach `bollwerk` behauptet „der Unterschied liegt nur unter planung/bollwerk/, der Beleg bleibt gültig“ (MP:94), ohne das zu prüfen. Laufen während eines 190-min-Tors `schnell`-Code-Commits auf `bollwerk`, ist der Phasenbeleg nach dem Zusammenführen ungültig. Die Endabnahme schützt `ziel`. Ersatz für die Klammer in MP:94: „(vorher `git -C /home/user/bw-arbeit/tor merge bollwerk` nach A-2 A4.1 und `git -C /home/user/bw-arbeit/tor diff --quiet <tor-sha> HEAD -- . ':!planung/bollwerk'`; schlägt das fehl, läuft das Tor am neuen SHA erneut)“.
4. **MINOR** · Der Ausgang von Tor-Rot widerspricht sich: weiterarbeiten (MP:229) gegen NACHT-ENDE nach 4 h (A-9:98). Ersatz unter P5-a.
5. **MINOR** · Die Commit-Regel ist an zwei Stellen nicht deckungsgleich: `commit.sh` hat in MP:265 kein `--tor`, und die Merges in `bw-tor` mit Tor `schnell` (MP:94) liegen außerhalb der „einzigen Ausnahme“ in A-2:12. Ersatz unter P5-b.
6. **MINOR** · `belege/` fehlt in der torfreien Zustandsliste (MP:66), obwohl A-2:12 Belege als Zustandsdateien behandelt. Wörtlich gelesen entsteht beim Commit der `ziel`-Belege ein Zirkel. Ersatz unter P5-c.
7. **MINOR** · Der Prompt hat nur noch 178 Byte Luft bis zur Obergrenze von 55.000 Byte. Jede Nachbesserung muss deshalb in die Anhänge verlagert oder an anderer Stelle eingespart werden (siehe Platzhinweis).
8. **MINOR** · Kleinere Abweichungen:
   - Die P-Prüfung in STARTPAKET:8 lässt `STARTPAKET.md` aus, MP:19 schließt es ein.
   - Abnahme des Torwerkzeugs: in BW0 (A-5:55) gegen im Vorlauf (MP:99).
   - L0.5 prüft nur `lib/game` (A-5:63), A-2:212 nennt `lib/game` und `lib/party`.
   - „committe nur LAUF.md“ (MP:60) gegen „LAUF.md und KERNKARTE.md“ (MP:266).
   - „OFFENE FRAGE“ (A-1:41) gegen „Frage ja“ (MP:54).
