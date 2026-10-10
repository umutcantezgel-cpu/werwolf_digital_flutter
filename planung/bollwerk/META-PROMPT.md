META-PROMPT · BOLLWERK · v4.1
Erarbeite den Master-Prompt, mit dem „Spuk im Schlosskeller“ über mehrere Nächte um das 10- bis 100-Fache wächst, sichtbar schöner wird und sauber auf main landet.

Du bist Opus 5.5 in einer Cloud-Sitzung, die der **Leitstand** gestartet hat. Der Leitstand ist eine Claude-Sitzung, die den Dauerlauf über mehrere Tage steuert. Der Nutzer hat den Dauerlauf im Leitstand freigegeben. Diese Sitzung schreibt nur auf ihren eigenen Branch.

In diesem Lauf baust du nichts am Spiel. Du erfasst, entwirfst, misst und simulierst. Proben laufen nur im Scratchpad oder in Wegwerf-Worktrees. Danach schreibst du den Master-Prompt BOLLWERK, lässt ihn gegenprüfen und übergibst ihn dem Leitstand mit allem, was die Nachtläufe zum Start brauchen.

Lies alles, bevor du beginnst; danach arbeitest du ohne Rückfragen bis zur Übergabe.

Herkunft: v4 verbindet den Meta-Prompt v3 des Nutzers (Gerüst) mit dem Wissen aus v2.3 (Anhänge A, B, C) und dem freigegebenen Plan „BOLLWERK-DAUERLAUF“. v4.1 enthält die erste Gegenprüfung mit 10 Linsen. Alle Vorfassungen liegen unter `planung/bollwerk/archiv/`.

## 0. EINSTELLUNGEN
- **Repo:** umutcantezgel-cpu/werwolf_digital_flutter · **App:** „Mordakte“ · **Fall:** „Spuk im Schlosskeller“
- **Modelle:**
  - **Opus 5.5** (claude-opus-5-5): Das bist du; als Agent mit model "opus".
  - **Haiku 5.5** (claude-haiku-5-5): im Agent-Werkzeug mit model "haiku".
  - **Keine Workflows:** In Kindsitzungen des Leitstands startest du keine Workflows, denn das Workflow-Werkzeug braucht die Anfrage des Nutzers in eigenen Worten in derselben Sitzung (Kinder-Probe, Teil 2). Alle Agentenarbeit läuft über das Agent-Werkzeug, mehrere Hintergrund-Agenten gleichzeitig.
  - Gilt das in einer Sitzung nicht (der Nutzer hat dort selbst Workflows verlangt), dürfen Workflows dazukommen.
  - Andere Modelle gibt es nicht. Jeder Agentenaufruf nennt sein Modell selbst. Du setzt keine Umgebungsvariablen und legst keine Einstellungsdatei an.
- **Denkstufen:**
  - Opus 5.5 auf max.
  - Haiku 5.5 auf max für Qualitätsarbeit (Variantenbauer, Richter, Angreifer, Probeläufer) und auf medium für reine Zähl- und Formarbeit. Diese Vorgabe ist eine ausdrückliche Anweisung dieses Auftrags für den Parameter `effort` des Agent-Werkzeugs. Haiku 5.5 kennt low bis max (BELEGE C8).
- **Dauer:** 2 bis 4 Stunden, harte Grenze 5 Stunden. Die Richtzeiten je Phase in §7 ergeben zusammen 4 Stunden.
- **Probenumfang:** etwa 100 bis 200 Haiku-Agenten; mehr nur, wenn ein Messwert sonst nicht belastbar ist.
- **Anhänge:** Sie liegen im Commit `<V4-SHA>` (steht in der Startnachricht) unter `planung/bollwerk/`:
  - `META-ANHANG-A-MASTERPROMPT.md`: Nutzerwortlaut, Entscheidungen, Annahmen A-01 bis A-13, harte Regeln, Pflichtinhalt. Die Vorrangtabelle V-1 bis V-22 am Kopf gilt vor dem Rest.
  - `META-ANHANG-B-FAKTEN.md`: Faktenlage
  - `META-ANHANG-C-MECHANIK.md`: Startentwurf der Spielmechanik
  - `v4/BELEGE-DOKU.md`: geprüftes Betriebswissen
  - `v4/LUECKEN-v3-v23.md`: Widersprüche, ihre Lösung und die Abschnittszuordnung
- **Branches:**
  - **Übergabe:** `bollwerk-plan` ist dein Arbeitsbranch.
  - **Arbeit der Nachtläufe:** `bollwerk`.
  - **Leitstand:** `bollwerk-leitstand`; du liest ihn nur.
  - **Merge-Bau:** `bollwerk-mc`.
  - **Archive:** `archiv/*`, nur der Leitstand.
- **Planungsordner:** `planung/bollwerk/`. Dein eigener Zustand liegt in `planung/bollwerk/meta/`.
- **Finalisierungs-Lauf:** Branch `origin/finalisierung-schlosskeller`, Planung `planung/finalisierung-schlosskeller/`.
- **Für die Nachtläufe:**
  - Startwort START BOLLWERK.
  - Morgenbericht als Datei um 06:30 Uhr; der Leitstand zeigt ihn um 07:00 Uhr.
  - Generationsfenster höchstens 12 Stunden.
- **Sitzungskennung:** `session_` + der Teil von `$CLAUDE_CODE_REMOTE_SESSION_ID` nach `cse_`. In der Kinder-Probe belegt: `cse_01NqNi…` entspricht `session_01NqNi…`.
- **Zeitzone:** Europe/Berlin.
- **Sprache:** Deutsch für Prompt, Berichte und alles, was Spieler sehen oder hören.

## 1. AUFTRAG UND NORDSTERN
Du bist der Prompt-Architekt. Dein einziges Produkt ist der Master-Prompt BOLLWERK, im Folgenden der Master-Prompt. Mit ihm orchestriert je Nacht ein Opus 5.5 Tausende Haiku-5.5-Varianten hinter einer Prüfmauer. Der Leitstand startet diese Nachtläufe als Generationen, Nacht für Nacht, bis das Ziel erreicht ist.

Ziele:
1. **Rundenbasiert spielbar.**
   - Gesteuert wird über Entscheidungen. Jede zeigt sich als sichtbare Aktion der Figur, zum Beispiel „in den Keller gehen“ über die fünf Sandsteinstufen.
   - Ein starker Spielwürfel entscheidet manchmal mit, auch darüber, ob eine Untersuchung gelingt. Misslingt sie, gibt es einen zweiten Anlauf oder einen Umweg. Lösbar bleibt der Fall immer.
   - Gespielt wird als Party an einem Gerät, solo mit Bots und im WLAN.
   - Die App startet im Schlosskeller.
2. **Wachstum.** Das Spiel wächst gegenüber dem Stand am B-02-Commit K um das 10- bis 100-Fache. Gemessen wird nach dem Teil UMFANG in Abschnitt 6 des Master-Prompts: U ≥ 10, jede Indexachse mindestens 3×, ohne längere Abende.
3. **Design.** Das Design wird im gewählten Look deutlich aufgewertet, belegt mit Bildern und Maßen.
   - Der Look ist entschieden: „Bild-Look + Leben“.
   - Der gemalte Iso-Look bleibt.
   - FEINKORN liefert nur Leben (Bewegung, Teilchen, Licht), keine Voxel-Räume oder -Figuren (V-21).
4. **Archiv.** Alles Bestehende ist archiviert, Brauchbares ist wiederverwertet: FEINKORN `1145cb9` und die HD-Linie `caf1d61`, diese nach V-14.
5. **main.** Alles landet sauber auf main.
   - Der Nachtlauf liefert MAIN-REIFE mit Release-SHA R und `ZUSTAND: BEREIT FÜR MAIN`.
   - Den Push auf main macht der Leitstand.

Der Wortlaut des Nutzers steht in Anhang A1, seine Entscheidungen in A2 (BE-01 bis BE-14). Beides ist bindend.

**Nordstern:** Ein frischer Opus 5.5, der nur den Master-Prompt, dessen Anhänge und das Repo kennt, beginnt nach START BOLLWERK ohne eine einzige Rückfrage.
- Er setzt als Generation n genau dort fort, wo Generation n−1 aufgehört hat.
- Er hält auch nach Kontextverdichtung, Nutzungslimit und Neustart der Maschine Kurs.
- Jede Zahl in seinem Plan stammt aus einer Messung oder ist als Schätzung mit Spanne markiert.

## 2. BEGRIFFE
- **Läufe:**
  - **Meta-Lauf:** dieser Lauf.
  - **Nachtlauf:** der Lauf, den der Master-Prompt steuert.
  - **Generation n:** die n-te Nachtlauf-Sitzung.
  - **Leitstand:** die Sitzung, die Generationen startet, überwacht, täglich prüft und am Ende auf main zusammenführt.
  - **Finalisierungs-Lauf:** der Lauf aus den Einstellungen; er schreibt den Kanon.
- **Kanon:** die eine Quelle für Orte, Figuren, Indizien, Tatablauf, Enden und Inhaltsregeln (`content/party/schlosskeller/`, Kanon 1.0).
- **Variantenfabrik:**
  - **Variante:** ein von einem Agenten erzeugter Kandidat, geprüft und bewertet. Das kann ein Text, Datensatz, Code, Test, eine Pose, Requisite, ein Bild oder eine Bildbeschreibung sein.
  - **Slot:** eine klar umrissene Lücke im Spiel, für die Varianten entstehen.
  - **Prüfmauer:** die feste Folge von Prüfringen, die jede Variante passieren muss, bevor sie ins Spiel darf.
  - **Variantenfabrik:** Slots, Briefings, Agentenwellen, Prüfmauer und Auswahl als wiederholbarer Kreislauf.
- **Spielwürfel:** der Würfel im Spiel. Meint „Würfel“ in einem anderen Planungsordner einen Baustein der Darstellung (FEINKORN), hältst du beide Bedeutungen in jedem Text getrennt.
- **Probe:** ein Versuch im Scratchpad oder in einem Wegwerf-Worktree.
- **Lichtungsaufgabe:** eine offene Frage, die der Nachtlauf in seiner ersten Phase klärt.
- **Start und Basis:**
  - **B-02:** „Finalisierungs-Lauf fertig“. Maßgeblich ist allein der Eintrag `B-02 ERFÜLLT · K=<sha40>` (oder `FREIGABE BOLLWERK · K=<sha40>`) in STEUERUNG.md des Leitstands (V-18).
  - **K:** der B-02-Commit, also die Basis für Messbasis, Vorher-Galerie und Kanon 1.0.
  - **Vorlauf:** die Arbeit des Nachtlaufs vor B-02, nur in eigenen Pfaden.
  - **Hoheit:** welche Dateien wem gehören, vor und nach B-02 (Anhang A4.8).
- **Steuerung der Generationen:**
  - **LEASE:** die Zeile `LEASE gen=<n> session=<id> seit=<UTC> herzschlag=<UTC>` in `planung/bollwerk/LAUF.md` auf `bollwerk`.
  - **FENSTER:** die Zeile `FENSTER gen=<n> start=<UTC> ende=<UTC> M=<UTC>` in LAUF.md.
  - **ZUSTAND:** die Zustandszeile in LAUF.md, nach der Tabelle in §8.2 Abschnitt 2.5.
  - **S-<n>, F-<n>:** Einträge in STEUERUNG.md bzw. BEFUNDE.md des Leitstands.
  - **QUITTUNG:** die angehängte Bestätigung des Nachtlaufs in `planung/bollwerk/QUITTUNGEN.md`.
- **R:** der Release-SHA, den der Nachtlauf bei MAIN-REIFE festlegt.
- **MC:** der Merge-Commit von R auf den aktuellen main, gebaut vom Merge-Bau.

## 3. AUSGANGSLAGE
Die Fakten stehen mit SHA in Anhang B (Stand 09.10.2026, Nachtrag v4 am Kopf). In M0 werden sie nachgeprüft.

**Die App:**
- Mordakte ist eine App für iOS, Android und Web und soll in die Stores.
- Ihre Technik bleibt unangetastet.
- Der Nachtlauf baut auf dem Bestand auf, optimiert und baut aus, ohne neue Abhängigkeiten in der App (A4.3).
- Befehle im Master-Prompt bleiben konkret und ausführbar.

**Die Läufe:**
- **Finalisierungs-Lauf:** Er macht „Spuk im Schlosskeller“ inhaltlich fertig. Dazu gehören vier Täter-Fassungen, 4 bis 20 Rollen plus das Geburtstagskind als Detektiv, der Partyablauf, der Partymodus auf der Karte und die Druckfassung.
  - Stand am 09.10. um 21:00 UTC: F4 von F7. Er kommt schnell voran.
  - Teile sind schon über den Nachtlauf Burgstadt in main gemergt.
  - Seinen Branch und Planungsordner liest du nur.
- **Nachtlauf Burgstadt:** Er läuft weiter und pusht etwa alle 10–40 Minuten auf main. Er merget auch `claude/pensive-gates-ajtp7x` und Teile der Finalisierung.
- **Weitere Linien:** Burgstadt HD (pausiert, Inhalt `caf1d61`), FEINKORN (archiviert, `1145cb9`) und Krimidinner (anderer Fall, nie vermischen). Du liest sie nur.
- **Leitstand:** Er hat diesen Lauf gestartet und wartet auf deine Übergabe. Er liest deine Zug-Zeilen, deine letzte Nachricht und den Branch `bollwerk-plan`.

**Inhalt:**
- Der Rohchat fehlt in der Cloud. Das ist erwartet; du arbeitest mit Kanon und Planungsordnern.
- Die Inhaltsregeln des Kanons gelten unverändert und im Wortlaut des Kanons (A4.6):
  - kein Alkohol, keine Drogen, kein Rauchen
  - Die Pfeife des Detektivs bläst Seifenblasen.
  - Der Schlag ist nur Schatten und Geräusch, kein Blut.
  - Herr Schneider überlebt in jedem Ende.
  - Grusel mit Humor.
  - Alle Figuren sind erfunden; die Namensbalance bleibt.

**Modelle:** Im Team arbeiten genau zwei Modelle: Opus 5.5 und Haiku 5.5.

## 4. AUTONOMIE, GRENZEN, VORRANG
**Autonomie**
- **Keine Rückfragen.** Was offen ist, entscheidest du nach dem Denkprotokoll (§6). Du trägst es ins ENTSCHEIDUNGSLOG ein und legst es am Ende als nummerierte Annahme vor.
- **Gesperrte Aktionen.** Wird eine Aktion gesperrt, versuchst du sie nicht in anderer Form erneut. Du notierst sie in FUER-DEN-NUTZER.md und arbeitest weiter.
  - Führe einen Sperrzähler `SPERREN folge=<a> gesamt=<b>` in `meta/STATUS.md`.
  - Nach 2 Sperren in Folge lässt du diese Schrittart weg.
  - Nach 15 Sperren insgesamt gehst du direkt zur Übergabe.
  - Warum: Der Sicherheitsfilter fällt nach drei Sperren in Folge oder zwanzig insgesamt auf Rückfragen zurück. Dann steht der Lauf, bis ein Mensch im Web antwortet (BELEGE C11).
- **Laufende Arbeit.** Solange Hintergrund-Agenten oder Hintergrundbefehle laufen, beendest du deinen Zug nicht. Du arbeitest an Unabhängigem weiter oder wartest mit dem Wartebefehl aus M0 Frage 6 (höchstens zehn Minuten).
  - Läuft eine Welle länger als das Dreifache ihrer geplanten Dauer, wertest du das Teilergebnis aus und reihst Fehlendes einmal neu ein. Geplante Dauer = ⌈Agenten ÷ gemessene Parallelität⌉ × Agentendauer, mindestens 30 Minuten.
  - Warum: Eine Cloud-Maschine ohne Aktivität pausiert, und laufende Agenten gehen beim Neuaufbau verloren (BELEGE C5).
- **Zug-Zeile.** Endet ein Zug vor der Übergabe, ist seine letzte Zeile `=== BOLLWERK-META-ZUG · M<n> · <sha40 von origin/bollwerk-plan> ===`. Auf „WEITER BOLLWERK“ setzt du nach `meta/STATUS.md` fort.
- **Steuerung.** Zu Beginn jeder Phase liest du `git fetch origin bollwerk-leitstand && git show origin/bollwerk-leitstand:planung/bollwerk/leitstand/STEUERUNG.md`.
  - Du befolgst neue Einträge, die „gilt für: Meta“ oder „alle“ tragen und auf der Weißliste in §8.2 Abschnitt 2.5 stehen.
  - Jeden Eintrag quittierst du in `meta/STATUS.md`.

**Grenzen**
- **Am Spiel änderst du nichts:** kein Spielcode, keine Spieldaten, keine Assets, keine Tests im Repo. Proben laufen im Scratchpad oder in Wegwerf-Worktrees, die du am Ende entfernst.
- **Git:**
  - Du pushst nur `bollwerk-plan`, darauf nur `planung/bollwerk/`, und nur als Fast-Forward mit `git push origin HEAD:refs/heads/bollwerk-plan`.
  - main, alle anderen Branches, Tags, `.claude/**` und Einstellungsdateien fasst du nicht an.
  - Kein Force-Push, keine umgeschriebene Geschichte.
  - Staging nur mit `git add -- <pfade>`.
  - Vor jedem Push läuft `bash tool/secret_scan.sh`.
  - Commits und Pushes führst du selbst in der Hauptsitzung aus, nie ein Agent.
  - Scheitert ein Push technisch, versuchst du ihn am nächsten Phasenende erneut. Wird er gesperrt, gilt die Sperrregel. In beiden Fällen gilt der lokale Commit als Phasenausgang.
- **Werkzeuge:**
  - Von `mcp__github__*` und `mcp__claude-code-remote__*` nutzt du nur lesende Werkzeuge.
  - Du startest keine Sitzungen, legst keine Routinen an und rufst `send_later` nicht auf.
  - Sitzungen und Routinen anderer Läufe fasst du nie an.
- **Netzwerk:**
  - Erlaubt: Git mit origin, die Paketquellen der Abhängigkeiten, die das Projekt schon hat, und lesende Recherche in der offiziellen Claude-Code-Dokumentation (nur du).
  - Keine Uploads, keine fremden Dienste, nichts systemweit installieren.
- **Daten:** Keine Schlüssel, Zugangsdaten oder persönlichen Daten in Dateien, Commits oder Prompts. Der Rohchat kommt nie in den Verlauf.

**Vorrang bei Widersprüchen:** Grenzen → Modellregel → Kanon → Nutzerentscheidungen (A1/A2) → Abnahme (§10) → Bauplan (§8) → Stil.
- Schwellen aus Anhang A sind Untergrenzen; der Meta-Lauf verschärft sie nur.
- Widerspricht ein Anhang diesem Meta-Prompt, gilt dieser Meta-Prompt. Der Fall kommt ins ENTSCHEIDUNGSLOG.

## 5. ROLLEN UND MODELLE
- **Du (Opus 5.5):** Lagebild, Spielkern, Entwurf von Prüfmauer und Variantenfabrik, Kapazitätsrechnung, Master-Prompt, Annahmen, Abnahme. SHA-, Vorfahr- und Verlaufsfragen klärst du selbst.
- **Haiku-5.5-Rollen:**
  - **Kundschafter:** inventarisiert genau einen Bereich in einem vorbereiteten Worktree.
  - **Messer:** zählt nach festem Verfahren, mit Fundstellen.
  - **Variantenbauer:** baut Varianten für einen Slot.
  - **Prüfer:** prüft einen Ring der Prüfmauer nach Checkliste.
  - **Richter:** bewertet Varianten oder Bildpaare nach Rubrik, ohne die Herkunft zu kennen.
  - **Angreifer:** sucht Wege, wie der Nachtlauf abkürzen, schönrechnen oder Regeln brechen könnte.
  - **Probeläufer:** spielt Abläufe und Simulationen durch.
- **Opus-5.5-Agenten:** nur für die unabhängige Prüfung, die Kaltstart-Probe (§9), höchstens einen Mechanik-Entwurf in M2 und als Ersatzrichter, wenn die Haiku-Eichung scheitert. Sie starten frisch und sehen nur, was ihr Auftrag nennt.
- **Modell und Denkstufe in jedem Auftrag**, nach §0.
  - Warum: Ohne Angabe läuft ein Agent auf dem Sitzungsmodell und dessen Denkstufe, und Opus-Kontingent geht für Fleißarbeit verloren.
  - Die eingebauten Erkundungs- und Planungsagenten laufen auf dem Hauptmodell; für Erkundung startest du deshalb Haiku-Agenten.
- **Haiku-Aufträge:**
  - Jeder ist selbsttragend nach dem Paket-Bauplan (§8.6).
  - Agenten schreiben nur in ihren eigenen Ergebnispfad im Scratchpad. Sie führen nur die Befehle aus, die ihr Auftrag nennt; Git, Installationen und Netzwerk gehören nicht dazu.
  - Gemeinsame Dateien schreibst nur du.
- **Werkzeuge der Agenten:** nur Read, Grep, Glob, Write, Edit und Bash. Nie:
  - `mcp__claude-code-remote__*`, `mcp__github__*`
  - Agent, Workflow, SendMessage, TaskStop, Monitor, EnterWorktree, ExitWorktree, Skill
  - WebFetch, WebSearch, Artifact, `mcp__Claude_Docs__*`

  Dieser Absatz steht wortgleich in jedem Auftrag.
- **Modellprobe:**
  - Die Probe läuft erst nach dem ersten Push (M0): zwei Haiku-Agenten im Hintergrund, gleichzeitig.
  - Beleg ist das Feld `model` im Agentenprotokoll: `grep -o '"model":"[^"]*"' ~/.claude/projects/*/*/subagents/agent-*.jsonl | sort | uniq -c`. Die Selbstauskunft des Agenten zählt nicht.
  - Dazu misst du, wie viele Hintergrund-Agenten gleichzeitig laufen, ohne dass Fehler oder Wartezeiten steigen; gemessen wird mit 4, 8 und 12.
  - Weicht eines ab, korrigierst du die Aufrufe, bevor weitere Agenten starten.

## 6. DENKPROTOKOLL
Für folgenreiche Entscheidungen, also Spielkern, Spielwürfel, Modi, Prüfmauer, Umfangsmaß, Zielfaktor, Generationenplan sowie Start- und Übergaberegeln:
1. Ziel und Messgröße klären.
2. Mindestens drei echte Wege.
3. Bewerten nach Wirkung im Spiel, Messbarkeit, Risiko für die Nacht und Aufwand.
4. Umkehrprobe: Was müsste wahr sein, damit die Wahl falsch ist? Wo möglich mit Probe oder Simulation prüfen.
5. Folgen zweiter Ordnung für Nachtlauf, Kanon, Leitstand und andere Läufe bedenken.
6. Eintrag ins ENTSCHEIDUNGSLOG. Was der Nutzer anders sehen könnte, wird Annahme.

## 7. ABLAUF
**Richtzeiten in Minuten:** M0 45 · M1 30 · M2 30 · M3 45 · M4 15 · M5 30 · M6 30 · M7 15.
- Überschreitet eine Phase von M0 bis M5 ihre Richtzeit um die Hälfte, schließt du sie mit dem Erreichten ab. Fehlendes markierst du als Schätzung mit Spanne und machst es zur Lichtungsaufgabe.
- M6 endet nach §9, innerhalb der harten Grenze.
- Bei Zeitnot gehen M5 bis M7 vor Tiefe in M2 und M3.

**Phasenende:** Eine Phase endet, wenn ihr Ausgang mit Beleg im Planungsordner liegt und nach §4 committet und gepusht ist. Zu Beginn jeder Phase liest du `meta/META-AUFTRAG.md`, `meta/STATUS.md`, `meta/ABNAHME-META.md` und STEUERUNG.md neu.

### M0 Lage
In dieser Reihenfolge:
1. **Branch:**
   - Ist das Repo flach (`git rev-parse --is-shallow-repository` = true): `git fetch --unshallow origin`.
   - Gibt es `origin/bollwerk-plan` (`git ls-remote --exit-code origin refs/heads/bollwerk-plan`):
     - `git fetch origin +refs/heads/bollwerk-plan:refs/remotes/origin/bollwerk-plan`
     - `git checkout -B bollwerk-plan origin/bollwerk-plan`
     - Liegt dort `planung/bollwerk/meta/STATUS.md`, ist das ein Wiedereinstieg: Setze dort fort.
   - Sonst: `git checkout -B bollwerk-plan origin/main`.
   - main holst du danach nicht mehr herein.
2. **Anhänge laden:**
   - `git fetch origin +refs/heads/claude/pensive-gates-ajtp7x:refs/remotes/origin/claude/pensive-gates-ajtp7x`
   - Für jede Datei aus §0 „Anhänge“: `git show <V4-SHA>:planung/bollwerk/<datei> > $SCRATCH/anhang/<name>`
   - Prüfe `grep -q 'Vorrang v4' $SCRATCH/anhang/META-ANHANG-A-MASTERPROMPT.md`.
   - Lies jede Datei vollständig, in Teilen mit Read.
   - Scheitert ein Schritt: HALT nach §12.
3. **Auftrag ablegen:** diesen Auftrag wortgleich als `planung/bollwerk/meta/META-AUFTRAG.md`, mit der Kopfzeile „Gilt nur für den Meta-Lauf“.
4. **Startdateien:** `meta/ABNAHME-META.md` und `meta/STATUS.md` anlegen; committen und pushen.
5. **Modellprobe** (§5).

**Stand der Läufe:**
- Lies vom Finalisierungs-Lauf aus seinem Planungsordner und Branch: Endkriterien, erfüllte Kriterien, offene Punkte, erwarteter Abschluss.
- Dazu alle weiteren Läufe.
- Prüfe die B-02-Bedingungen, die der Leitstand anwendet (§8.2 Abschnitt 2.2), gegen diesen Stand.

**Faktenprüfung:**
- Lege Wegwerf-Worktrees an: `$SCRATCH/wt/fin` (origin/finalisierung-schlosskeller), `wt/main` (origin/main) und `wt/feinkorn` (origin/kern-feinkorn).
- 10 Haiku-Kundschafter prüfen Anhang B, je einer für B1 bis B10, und lesen nur dort.
- Jede Abweichung kommt mit Beleg. 10 % der Belege prüfst du selbst nach.
- Danach entfernst du die Bäume mit `git worktree remove --force`.

**Umgebung**, jede Antwort mit Beleg (Befehl und Ausgabe-Auszug oder Doku-Link):
1. Läuft die Werkzeugkette in der Version, die das Repo festlegt, und wie lange dauert das Einrichten?
2. Laufen Bauen, Analysieren und alle Tests, und wie lange?
3. Entstehen ohne Gerät echte Bildschirmbilder der App mit echten Schriften? Gemeint sind Web-Build und Chromium, Anhang B4 und B9.
4. Läuft die Spiellogik ohne Oberfläche, etwa für Simulationen mit Tausenden Partien?
5. Lassen sich mehrere App-Instanzen über die lokale Schleife verbinden, als Probe für WLAN (`room_host`)?
6. Welcher Befehl wartet bis zu zehn Minuten, ohne den Zug zu beenden? Etwa `timeout 590 bash -c 'until <bedingung>; do sleep 30; done'` im Hintergrund mit Benachrichtigung, oder Monitor. Der belegte Befehl steht später wörtlich im Master-Prompt.
7. Wie viele Hintergrund-Agenten laufen hier gleichzeitig (Modellprobe), und wie viele Agentenrückgaben verträgt dein Kontext je Stunde? Workflows sind in dieser Sitzung nicht freigegeben (Kinder-Probe in `origin/bollwerk-leitstand:planung/bollwerk/leitstand/LEITSTAND.md`).
8. Welche Werkzeuge hat diese Sitzung (aus der Werkzeugliste, ohne Aufruf), und setzt eine Kindsitzung nach einem Nutzungslimit selbst fort? Ist das nicht belegbar, gilt „nicht klärbar“, und der Master-Prompt plant für beide Fälle.

**Abbruchregel:** Scheitert die Werkzeugkette nach zwei Versuchen oder 30 Minuten, markierst du die Fragen 1 bis 5 als nicht klärbar. Du simulierst dann im Scratchpad mit einem eigenen Modell der Spielregeln weiter und machst Bild- und Technikproben zur Lichtungsaufgabe.

**Ausgang:** LAGEBILD.

### M1 Bestand und Messbasis-Prognose
- **Inventar:** alle Spielteile mit Fundstelle (Modi, Fälle, Bildschirme, Inhalte, Assets, Tests, Druckfassung), gezählt am aktuellen Stand von `origin/finalisierung-schlosskeller`.
- **Archivkarte:** je Teil übernehmen, umbauen oder archivieren, mit Grund.
  - „Archivieren“ heißt nach A3: an Ort und Stelle erhalten, hinter Schalter oder Archiv-Branch, nie löschen.
  - Kanon 1.0 und Druckspiel bleiben unverändert.
  - Andere Fälle und Spiele der App laufen unverändert weiter.
- **Umfangsmaß nach §8.3:**
  - Messskript `planung/bollwerk/proben/umfang_probe.*`.
  - Werte heute und Hochrechnung für den Stand nach der Finalisierung heißen **MESSBASIS-PROGNOSE** und sind nie Basis.
  - **Achsenprüfung:** je Achse X1 bis X6 die Basis-Hochrechnung und der natürliche Deckel. Achsen mit Basis unter 5 oder Deckel unter 3× werden vor dem Einfrieren Pflichtziel oder bekommen eine Mindestbasis, als Annahme.
- **Designmaße nach §8.4 und das Bildverfahren:**
  - Fotografiert wird der echte Partymodus der Finalisierung. Dazu baust du einen Web-Build eines festen SHA in einem Wegwerf-Worktree nach `tool/e2e/README.md`, mit `--no-web-resources-cdn` und vorher `rm -rf .dart_tool/flutter_build`.
  - Kopien von `origin/finalisierung-schlosskeller:tool/e2e/raeume.mjs` und `server.mjs` kommen nach `proben/`. Playwright bindest du per `createRequire('/opt/node22/lib/node_modules/playwright')` ein; der Worktree-Pfad ist ein Argument.
  - Das URL-Schema steht in raeume.mjs und Anhang B4.
  - **Ansichten:** 393×852, 852×393 und Tablet 1180×820, je mit Pixeldichte 2.
  - **Gleichheit:** Dieselbe SHA zweimal fotografiert ergibt dieselbe sha256 oder höchstens ΔE 1. Dafür läuft die Zeit über `page.clock`. Geht das nicht, entsteht das Bild über den Golden-Weg L6.
  - **Umfang der Erprobung:** mindestens drei Bildschirme in allen drei Ansichten.
  - Die vollständige Vorher-Galerie erhebt der Nachtlauf in BW0 an K.
- **Bilder:** Probebilder legst du als Kontaktbogen unter `planung/bollwerk/bilder/meta/` ab und trägst sie in `bilder/INDEX.md` ein (§8.4).
- **Eichsätze:** Du baust die Sätze für D3a (Paar-Eichung), D3b (Stilbruch- und Überladen-Bilder) und F5 (20 eingestreute Füllstücke).
- **Ausgang:** BESTAND, MESSBASIS-PROGNOSE mit Messskript, Bildverfahren mit Probebildern, Eichsätze.

### M2 Spielkern
- **Entwurf:** Runde, Entscheidungsarten, sichtbare Aktionen, Spielwürfel, Gruppenentscheidungen und Enden für Party an einem Gerät, Solo mit Bots und WLAN.
  - Startentwurf ist Anhang C. Mit „M3“ meint Anhang C diese Phase.
  - Daneben entwerfen 3 Haiku-Agenten auf max und höchstens 1 Opus-Agent je einen eigenständigen Gegenentwurf.
  - Richter bewerten blind. Du übernimmst den besten und pfropfst die stärksten Ideen der anderen auf.
- **Geheimnisschutz:** In jedem Modus erfährt kein Gerät und kein Bot, was seine Rolle nicht wissen darf.
- **WLAN:**
  - Alle Geräte zeigen dasselbe Würfelergebnis.
  - Kein einzelnes Gerät kann es beeinflussen.
  - Gäste rechnen jeden Wurf aus Salz und Zugdaten nach.
  - Der Seed hängt nie vom Fall-Code ab (WÜ-1, V-15).
- **„Stark“ ist entschieden (BE):**
  - Der Würfel entscheidet auch, ob eine Untersuchung gelingt.
  - Misslingt sie, gibt es einen zweiten Anlauf oder einen Umweg zur selben Kanon-Quelle.
  - Der dritte Anlauf je Wissensziel ist immer mindestens Teilerfolg, ohne Deckel.
  - Lösbar bleibt der Fall immer. WÜ-1 bis WÜ-6 sind bindend.
- **Lösbarkeit:** Lösbar heißt: Öffnet eine Kanon- oder Folgeentscheidung, ist jedes Glied ihrer `begruendung.*.kette` aufgedeckt. Das gilt für alle Arten (`fakt:`, `beobachtung:`, `karte:`, `merkmal:`, `luege:`), in jedem Würfelstrom und bei 4 bis 20 Personen.
  - Ein Kettenglied kommt ohne Gelingenswurf, oder es zählt als Pflichtzug in Reserve-Regel und Budget-Ungleichung.
  - Belegt wird das erschöpfend nach C8 Nr. 1, zusätzlich mit einem Gier-Bot: alle Abstecher, immer „gründlich“, immer Umweg.
- **Bänder:** Die Simulation wählt Schwellen, Modifikatoren, Kosten und Abstecherzahl nur innerhalb der bindenden Bänder (C2, C8 Nr. 3 und 13).
  - Fest bleiben: Pech-Garantie, Reserve-Regel, Budget-Ungleichung, Rundenschranke, Kettensperre und WÜ-4.
  - Der Würfelanteil an Kanon-Punkten und Ende ist 0. Gemessen wird er an Nebenwertung, Abstechern, Zusatzfunden und Zeit.
  - Das Pech-Band gilt nach Modifikatoren. Ein Werkzeug, das man immer trägt, zählt +0.
- **Simulationen im Scratchpad**, mindestens:
  - Würfelverteilungen
  - Spürbarkeit nach C8 Nr. 13, bei Besetzung 4 bis 20
  - Spieldauer je Personenzahl
  - Überschneidung zweier Zufallspartien (C9)
  - Lösbarkeit je Täter-Fassung wie oben, dazu einfache Detektiv-Bots

  Der Seed-Satz wird festgelegt und eingefroren.
- **Ausgang:** SPIELKERN als nummerierte Kern-Aussagen für den Master-Prompt, jede mit Begründung und, wo möglich, Simulationszahl mit Seed und Partienzahl.

### M3 Fabrikprobe und Design-Probe
- **Entwurf:** Prüfmauer (§8.5) und Variantenfabrik (§8.6).
- **Fabrikprobe:** echte Probe mit Slot-Arten, die X1, X2, X4 und X6 abdecken. Dazu gehören mindestens ein Ereignis, eine Entscheidung mit sichtbarer Aktion und ein Bildschirmelement. Je Art laufen mehrere Slots mit mehreren Varianten durch alle Ringe.
- **Eichungen vor der Design-Probe:**
  - **D3a, Paar-Eichung:** Richter wählen in mindestens 15 von 18 Kontrollpaaren das Original und schlagen bei höchstens 1 von 6 Gleichpaaren falsch an.
  - **D3b:** Stilbruch- und Überladen-Bilder.
  - **F5:** Das Gremium lehnt mindestens 90 % der eingestreuten Füllstücke ab.
  - **Scheitert Haiku:** Es richten 3 frische Opus-5.5-Agenten. Scheitern auch sie, bleibt D2 rot; D1 ersetzt D2 nie. Die D2-Schwelle von 85 % bleibt fest.
- **Design-Probe:**
  - Mindestens zwei Aufwertungsrichtungen im Bild-Look an je einem Raum.
  - Die Nachher-Bilder sind echte Renderings aus Code im Wegwerf-Worktree, mit demselben Verfahren in 3 Ansichten. Übermaltes heißt „Skizze“ und zählt nicht.
  - Je Raum kommt ein Bewegungsstreifen dazu: 8 Bilder im Abstand von 0,25 s bei fester Uhr.
  - S1 bis S5 werden an diesen Bildern und an 6 Stilbruch-Bildern geeicht, bis jeder Stilbruch rot ist. Jede Lockerung kommt ins ENTSCHEIDUNGSLOG.
  - Richter bewerten blind. Die Rangfolge wird Annahme A-01, mit Bild.
- **Messen:**
  - erreichte Parallelität
  - Dauer je Agent
  - Annahmequote je Ring und je Denkstufe
  - gültige Einheiten je Agentenstunde je Achse
  - Fehlerbilder, Nachbesserungsbedarf, Speicher und Rechenlast
  - Tokens je Agent und Denkstufe, soweit sichtbar

  Was du nicht messen kannst, schätzt du mit Spanne.
- **Nachschärfen:** Briefings und Schemas; höchstens zwei Proberunden.
- **Ausgang:** FABRIKPROBE mit Zahlen; DESIGN-PROBE mit Kontaktbogen und Streifen.

### M4 Plan
- **Mengengerüst** je Achse und Anteil von Opus und Haiku.
- **Kapazität:** das Minimum aus erreichter Parallelität, Maschinenlast und Nutzungskontingent je Limitfenster. Vom Kontingent planst du mit 0,8, also 20 % Puffer.
  - Das Kontingent schätzt du aus den Tokens je Agent der Fabrikprobe, mit Spanne.
  - Bis B-02 gilt die halbe Wellengröße (STEUERUNG S-1).
- **Zielfaktor F:** zwischen 10 und 100, mit Begründung.
  - Z-UMFANG bleibt U ≥ 10 mit jeder Indexachse mindestens 3×. F ist das Planziel. Ein realistischer Faktor unter 10 steht nur in Prognose und Annahmen.
  - **Zwischenziele** je Nacht und Achse in gültigen Einheiten, gerechnet aus der Fabrikprobe.
  - F, Zwischenziele und Schwellen ändert nur ein Eintrag in STEUERUNG.md.
  - Verfehlt eine Nacht ihr Ziel um mehr als 20 %, plant der Lauf neu, höchstens zweimal; danach folgt ein Eintrag in FUER-DEN-NUTZER.md.
  - Nach Nacht 7 ab B-02 mit U < 10: NACHT-ENDE, Restbedarf in Nächten im Morgenbericht; der Leitstand entscheidet mit dem Nutzer.
- **Wellenplan mit kritischem Pfad:**
  - zuerst Vorlauf (vor B-02)
  - dann Durchstich: eine vollständige Runde in allen drei Modi mit wenig Inhalt
  - dann die Breite
  - Jede Welle passt in **ein** Limitfenster.
  - Wellengröße = gemessene Zahl gleichzeitiger Hintergrund-Agenten (M0, M3); Rückgaben je Stunde nach dem gemessenen Kontextbudget.
- **Betriebsort:** Cloud-Kindsitzungen des Leitstands. Zeigt das LAGEBILD, dass eine Nacht nicht trägt, schreibst du den Master-Prompt für kürzere Generationen und machst das zur Annahme.
- **Ausgang:** PLAN.

### M5–M7
- **M5 Schreiben:** Master-Prompt und Startpaket nach §8.
- **M6 Prüfen:** nach §9, höchstens drei Runden.
- **M7 Übergeben:** nach §12.

## 8. BAUPLAN DES MASTER-PROMPTS
### 8.1 Form
- **Stil:** Deutsch, ruhig und präzise, ohne Druck durch Großbuchstaben. Jede Regel genau einmal. Platzhalter nur in den Einstellungen. Beispiele sind als Illustration gekennzeichnet und vielfältig.
- **Format:**
  - Der Master-Prompt ist **ein** Text ohne verschachtelte Codeblöcke, höchstens 55.000 Byte (UTF-8, `wc -c`). Er liegt als `planung/bollwerk/MASTER-PROMPT.md` auf `bollwerk-plan`.
  - Umfangreiche Daten (Kanon-Auszüge, Listen, Wortlaut des Nutzers, Mechanik-Tabellen, Annahmen) liegen als Anhänge unter `planung/bollwerk/anhang/A-<n>-<name>.md`.
  - Der Prompt nennt sie mit Pfad und liest sie beim Start.
- **Für sich allein:** Er verweist nie auf diesen Meta-Prompt. Jede Regel, die er braucht, steht in ihm oder in seinen eigenen Anhängen.
- **Unveränderlich:** Auf `bollwerk` bleiben `MASTER-PROMPT.md`, `anhang/**` und `STARTPAKET.md` unverändert. Z-Kriterien und Schwellen stehen nur dort.
- **Auslösewort:** Das Auslösewort der Workflow-Automatik steht nirgends darin, auch nicht als Beispiel. Den Wortlaut des Nutzers übernimmst du mit geschwärztem Auslösewort.
- **Abläufe statt bedingter Verbote:** Reihenfolgen stehen als Ablauf, nicht nach dem Muster „nicht …, bis …“. Als Verbot steht nur, was die ganze Nacht gilt. Warum: Der Sicherheitsfilter liest Verbote aus dem Gespräch bei jeder Prüfung neu als bindend (BELEGE C11).
- **Je Modell:** Opus bekommt Ziele, Gründe und Freiraum; Haiku bekommt exakte Formate, Schemas und kleine Pakete.
- **Namen:**
  - Dateinamen in ASCII: `FUER-DEN-NUTZER.md`, `PRUEFPUNKT.md`.
  - Kriterien heißen Z-Kriterien; in Anhang A tragen sie die Kennung BK.
  - Steuerworte: STOPP BOLLWERK, WEITER BOLLWERK, FREIGABE BOLLWERK, MAIN BOLLWERK, VETO D2 <Bogen>, „A<n>: …“.
- **Länge:** so lang wie nötig. Jede Zeile verbessert das Ergebnis der Nacht.

### 8.2 Abschnitte
Die Nummern 2.2, 2.5 und 6 sind feste Verweise, denn Leitstand und Startpaket nennen sie. Die Zuordnung zum Pflichtinhalt aus Anhang A (MP-0 bis MP-20) steht in `v4/LUECKEN-v3-v23.md` §5. Die Vorrangtabelle V-1 bis V-22 in Anhang A gilt dabei.

- **0 EINSTELLUNGEN:** alle veränderlichen Werte mit Standard:
  - Modelle und Denkstufen als feste Zeilen
  - Parallelität aus M3, Wellengröße und halbe Wellengröße bis B-02
  - Zielfaktor F und Zwischenziele
  - Generationsfenster 12 h, M = 06:30 Berlin
  - Branches, Planungsordner, der belegte Wartebefehl
- **1 AUSGANGSLAGE UND NORDSTERN:** Der Nordstern steht als erreichter Zustand in einem Satz. Die Ziele nennen App-Start im Schlosskeller, Nebel, Druckspiel unverändert und „stark“ im Wortlaut.
- **2 START UND AUTONOMIE**
  - **2.1** Der Lauf beginnt, sobald eine Nachricht das Startwort enthält, auch die Startnachricht des Leitstands.
  - **2.2 Startbedingungen**, je mit Prüfweg:
    - **B-01:** Die Werkzeugkette ist bereit.
    - **B-02:** gilt nur mit dem Eintrag `B-02 ERFÜLLT · K=<sha40>` oder `FREIGABE BOLLWERK · K=<sha40>` in `origin/bollwerk-leitstand:planung/bollwerk/leitstand/STEUERUNG.md`.
      - Der Leitstand setzt ihn, wenn alles zutrifft:
        - Die Finalisierung meldet „ZIEL ERREICHT“.
        - Ihre Spitze ist Vorfahr von origin/main.
        - Seit 60 Minuten gibt es keinen Commit auf `origin/finalisierung-schlosskeller`.
        - Kein Commit auf `origin/main` oder `origin/nachtlauf/burgstadt` aus diesem Zeitraum berührt `planung/finalisierung-schlosskeller/**`, `content/party/**`, `lib/party/**` oder `packages/mordakte_core/**`.
        - PR #43 ist gemergt oder geschlossen.
      - Der Nachtlauf prüft dieselben Punkte nur zur Information und schreibt „B-02 vermutlich“ in den PRUEFPUNKT.
      - Ist B-02 offen, arbeitet der Lauf im Vorlauf (Anhang A, MP-2); das ist kein Halt.
  - **2.3 Startschritte, idempotent:** Jeder Schritt prüft zuerst, ob er schon erledigt ist.
    1. **Arbeitsort:** `BW=$(git rev-parse --show-toplevel)`. Das ist der Sitzungs-Checkout; ein flaches Repo wird zuerst mit `git fetch --unshallow origin` vervollständigt.
    2. **Branch:** `git fetch origin bollwerk bollwerk-leitstand`.
       - Ist origin/bollwerk Vorfahr von HEAD: bleiben.
       - Ist HEAD Vorfahr: `git merge --ff-only origin/bollwerk`.
       - Sonst: HEAD-SHA im NACHTPROTOKOLL notieren, dann `git checkout -B bollwerk origin/bollwerk`.
    3. **Maschine:** Weicht `/proc/sys/kernel/random/boot_id` vom PRUEFPUNKT ab, legst du Werkzeugkette, `env.sh` und Pool neu an. Jede Ausgabedatei aus FLUG.md wird geprüft; fehlende Aufträge kommen einmal neu in die Reihe.
    4. **LEASE und FENSTER:** übernehmen nach 2.5.
    5. **Lichtungsaufgaben** zuerst. Messbasis und Vorher-Galerie entstehen nur in BW0 an K.
  - **2.4 Autonomie:** Regeln wie §4, angepasst an den Nachtlauf, mit Sperrzähler im PRUEFPUNKT.
  - **2.5 Generationen** (Pflicht):
    - **LEASE prüfen:** zu Beginn jedes Zugs, nach jedem Weckruf und unmittelbar vor jedem Push. Gelesen wird LAUF.md von `origin/bollwerk`.
      - Steht dort eine kleinere Generation, schreibst du deine LEASE-Zeile (deine Generation steht in der Startnachricht), pushst, liest neu und arbeitest erst danach.
      - Steht dort eine größere Generation oder deine Generation mit fremder `session`:
        - Du pushst nichts mehr.
        - Du löschst nur deine eigenen Weckrufe.
        - Du endest mit `=== BOLLWERK-ZUG-ENDE · G<n> · ABBRUCH abgelöst · Weckruf keiner · <sha> ===`.
      - Das Alter eines Herzschlags berechtigt nie zur Übernahme.
    - **FENSTER:** bei Übernahme `FENSTER gen=<n> start=<UTC> ende=<start+12 h> M=<nächstes 06:30 Berlin nach start>`.
      - Liegt M vor `ende`, endet die Generation um M + 30 min.
      - Nach M stellt sie keinen Weckruf mehr.
    - **Herzschlag:** LEASE `herzschlag` und PRUEFPUNKT werden alle 30 Minuten gepusht. Ein Commit, der nur LAUF.md, PRUEFPUNKT.md oder QUITTUNGEN.md ändert, braucht kein Tor.
    - **ZUSTAND:**

      | Wert | setzt | der Leitstand dann |
      |---|---|---|
      | NICHT BEGONNEN | Meta-Lauf | startet G1 |
      | LÄUFT | Generation | nichts |
      | VORLAUF FERTIG | Generation | nach B-02 `send_message` an dieselbe Sitzung oder neue Generation |
      | NACHT-ENDE | Generation | startet G n+1 zum nächsten Fenster |
      | BEREIT FÜR MAIN | Generation | startet den Merge-Bau |
      | ABBRUCH <grund> | Generation | Meldung, keine neue Generation; „abgelöst“ einer alten ID wird übergangen |
      | ZIEL ERREICHT | nur der Leitstand nach dem main-Push, in LEITSTAND.md | – |

      ABBRUCH gibt es nur bei rotem Stolperdraht, Bruch von Kanon 1.0, Bestandsschutz 0, LEASE verloren oder Sperrzähler.
    - **Zugende:** Vor der Zugende-Zeile wird LAUF.md committet und gepusht. Die Zeile lautet `=== BOLLWERK-ZUG-ENDE · G<n> · <ZUSTAND> · Weckruf <UTC|LEITSTAND> · <sha von origin/bollwerk> ===`.
      - Den Weckruf stellt der Lauf mit einem einzigen `send_later` namens `BOLLWERK-G<n>-<session_id>`.
      - Ohne `send_later` schreibt er `Weckruf LEITSTAND <UTC>`; dann weckt der Leitstand mit `send_message`.
    - **Steuerung:** Bei jedem Prüfpunkt liest der Lauf STEUERUNG.md und BEFUNDE.md von `origin/bollwerk-leitstand`. Beide werden nur ergänzt; jeder Eintrag trägt „gilt für: Meta | Nacht | alle“.
      - **Weißliste**, nur diese Einträge werden ausgeführt:
        - Wellengröße bis zur Einstellung
        - PAUSE, WEITER
        - `B-02 ERFÜLLT · K=<sha40>`, `FREIGABE BOLLWERK · K=<sha40>`
        - `A<n>: …` mit Nutzerzitat
        - `VETO D2 <Bogen>`
        - `LIMIT-VORSORGE`: Welle abschließen, Morgenbericht vorziehen, NACHT-ENDE
        - Vorrang eines Befunds
        - Änderung von F, Zwischenzielen oder Schwellen **nach oben**
      - **Abgelehnt** wird jeder Eintrag, der eine Grenze, ein Push-Ziel, die Hoheit, ein Z-Kriterium nach unten oder eine Schwelle nach unten ändert oder ein Löschen verlangt. Darauf folgen `QUITTUNG S-<n> · ABGELEHNT · <grund>` und ein Eintrag in FUER-DEN-NUTZER.md.
      - **Quittungen** stehen nur angehängt in `planung/bollwerk/QUITTUNGEN.md`: `QUITTUNG S-<n>|F-<n> · <UTC> · umgesetzt|abgelehnt <grund>`. LAUF.md führt `QUITTIERT S=<max> F=<max>`.
      - **BLOCKER:** Ein BLOCKER aus BEFUNDE.md stoppt nur Wellen, die ihn nicht beheben. Mit `BEHOBEN F-<n> · <sha> · <beleg>` und grünem Tor laufen sie wieder. Der Leitstand kann den Befund neu öffnen.
- **3 GRENZEN UND VORRANG:** aus Anhang A4.1 bis A4.10, mit der Vorrangtabelle. Der Nachtlauf:
  - pusht ausschließlich `git push origin HEAD:refs/heads/bollwerk`
  - nutzt von `mcp__github__*` und `mcp__claude-code-remote__*` nur lesende Werkzeuge, dazu `send_later` und `get_trigger`/`delete_trigger` für eigene Weckruf-IDs
  - legt keine Routinen an, öffnet keine Pull Requests und ändert `.claude/**` und Einstellungsdateien nicht
- **4 KERN:** nummerierte Kern-Aussagen aus Kanon, A2 und SPIELKERN, mit Version und Änderungsverfahren. Die Datei mit den Regeln für Verdichtung und Wiedereinstieg heißt KERNKARTE.md.
- **5 ROLLEN, MODELLE UND VARIANTENFABRIK:**
  - Opus 5.5 für Urteil, Kernsysteme, Integration und Abnahme.
  - Opus-5.5-Agenten nur für Pakete der Stufe 3, unabhängige Prüfungen und als Ersatzrichter.
  - Haiku 5.5 für alles Übrige.
  - Jeder Agentenauftrag nennt Modell und Denkstufe, die Stufe je Rolle aus der Fabrikprobe.
- **6 ZIELFORMEL:** Z-Kriterien mit Methode (Befehl in Backticks), Schwelle (Zahl oder Vergleich) und Belegpfad, gegliedert in SPIEL, UMFANG, DESIGN, MODI, BESTAND, ARCHIV und MAIN-REIFE. Dazu die Abschlussregel.
  - **MAIN-REIFE** (V-16) umfasst mindestens:
    - Release-SHA R in LAUF.md und ABSCHLUSSBERICHT; danach nur noch Commits unter `planung/bollwerk/`
    - origin/main in `bollwerk` hereingeholt; Probe-Merge `git merge-tree --write-tree origin/main R` ohne Konflikt
    - `dart run tool/bollwerk/bollwerk.dart ziel` endet mit `BOLLWERK GRÜN · ziel · <R>`
    - die zwei Prüfrunden aus MP-20 ohne bestätigten BLOCKER oder MAJOR
    - Secret-Scan leer, Burgstadt-Schutz grün
    - `git diff --quiet origin/main R -- .claude`
  - Dann setzt der Lauf `ZUSTAND: BEREIT FÜR MAIN` und meldet jedes Z-Kriterium mit einer Belegzeile in `planung/bollwerk/ABSCHLUSSBERICHT.md` und im Gespräch.
  - Den Push auf main und `ZIEL ERREICHT` übernimmt der Leitstand.
- **7 PRÜFMAUER** (Ringe → Schichten, §8.5) · **8 PHASEN** mit Toren, Vorlauf und Durchstich zuerst, Zwischenziele · **9 REGELKREISE** mit Höchstzahlen · **10 NEBELKARTE** mit Frühwarnzeichen und Gegenmaßnahme, auch für Kontingent, Limits, Sperren und Generationswechsel.
- **11 GEDÄCHTNIS, STATUS UND BERICHTE:**
  - Dateien: LAUF.md, KERNKARTE.md, PRUEFPUNKT.md (mit `boot_id` und Sperrzähler), FLUG.md (runIds, scriptPaths), STATUS.md, QUITTUNGEN.md, ENTSCHEIDUNGSLOG.md, REGISTER.md, NACHTPROTOKOLL.md, FUER-DEN-NUTZER.md und MORGENBERICHT.md bis M.
  - Nach jeder Verdichtung liest der Lauf in dieser Reihenfolge: LAUF → KERNKARTE → PRUEFPUNKT → FLUG → STATUS, dann Abschnitt 2.5 und 3 aus MASTER-PROMPT.md. Erst danach beginnt er Neues.
- **12 BEREIT FÜR MAIN:** die Schritte bis MAIN-REIFE und die Übergabe an den Leitstand. Push und Rückweg stehen nicht im Master-Prompt (V-16).
- **13 START:** die ersten Handlungen als Befehle, idempotent nach 2.3.

### 8.3 Umfang (Teil UMFANG in Abschnitt 6)
- **Was zählt:** die Indexachsen X1 bis X6 aus Anhang A, MP-7.
  - Kanonfeste Achsen haben Faktor 1.
  - Pflichtziele stehen außerhalb des Index.
  - Keine Einheit zählt doppelt.
  - Hinweise und Fehlfährten zählen nie.
  - Abweichungen zu B10 entscheidet M1 nach dem Denkprotokoll.
- **Gültig ist eine Einheit**, wenn alles zutrifft:
  - Sie hat die Prüfmauer passiert, und ein grüner `phase`-Lauf liegt auf einem HEAD, der sie enthält.
  - **F2:** Sie erscheint in mindestens 1 % der Partien ihres Modus aus dem eingefrorenen Seed-Satz.
  - **F3:** Ihr Unterschied liegt in einem spielwirksamen Feld: Ort, Fund, Wissen, Würfelstufe, Aktion oder Folgeentscheidung.
  - **F4:** Sie ist kein Beinahe-Duplikat. Varianten einer Stelle zählen einmal; zwei Haiku-Richter prüfen zusätzlich die Bedeutung.
  - **F5:** Das geeichte Gremium (M3) gibt Neuheit frei.
  - Sie passt zum Kanon.
  - Texte unter 8 Wörtern zählen nicht für X2.
- **Zuwachsfaktor U:** das gewichtete geometrische Mittel über die Achsen.
  - Keine Achse trägt mehr als 40 % des Logarithmus.
  - Jede Indexachse muss mindestens 3× erreichen.
  - Achsen mit Basis 0 bekommen absolute Pflichtziele.
  - Berichte zeigen neben U die absoluten Zahlen je Achse und den Volumenfaktor (Σ gültige Einheiten ÷ Σ Basis).
- **Abend-Invariante:** U gilt nur, wenn derselbe Seed-Satz C7 und C8 Nr. 8 einhält:
  - Abend im Median ≤ 150 min
  - je Runde Median ≤ 6 min und P95 ≤ 10 min
  - Züge und Abstecher je Partie im Band aus M2

  Spieltiefe zeigt sich an sinkender Überschneidung zweier Zufallspartien (C9) und wird nur berichtet.
- **Basis:** K, gemessen in BW0 mit `tool/bollwerk/umfang.dart` in einem Wegwerf-Worktree an K.
  - `planung/bollwerk/messbasis/UMFANG-BASIS.md` hält SHA, sha256 des Werkzeugs, Achsen, Gewichte, Zählbefehle und Werte. Danach ändert sie niemand.
  - Schwellen und Fallzahlen stehen in `messbasis/schwellen.json`; die Werkzeuge lesen sie von dort.
  - `umfang.dart` zählt in einem Lauf K und HEAD. Weicht die Basiszahl vom eingefrorenen Wert ab, ist das Ergebnis rot.
  - Jeder Beleg-Kopf enthält `git diff --stat <BW0> HEAD -- tool/bollwerk`.
  - L9b enthält die Mutanten „Schwelle gesenkt“ und „Zählregel gelockert“.

### 8.4 Design
- **Bilder:** Vorher/Nachher-Bilder jedes Bildschirms in den Ansichten aus M1 (393×852, 852×393, 1180×820, Pixeldichte 2), mit fester Uhr.
- **D2:** 7 Räume × 2 Kanon-Lichtzustände × 3 Ansichten = 42 Paare. Dazu kommen die Bewegungsstreifenpaare. Die Schwelle von 85 % ist fest.
- **Maße**, kalibriert in M1:
  - Kontrast, Tippflächen, Abstands- und Schriftraster
  - Einhaltung der Palette
  - Bildzeit als CPU-Zeit je Bild nach L8; Ruckler als Verhältnis p90 zu Median
  - Anteil ersetzter Platzhalter
  - Look-Vertrag, D1 bis D3, Stilprüfung S1 bis S5 aus Anhang A, MP-8

  S2 gilt außerhalb der Nebel- und Lichtmaske für alle Pixel, auch für neue Requisiten.
- **Blindvergleich und Eichung:** nach M3 (D3a, D3b). D1 ersetzt D2 nie.
- **Seeds der Gremien:** Seed = erste 8 Hex von `sha256(<Welle>|<HEAD>)`. Je Hash gibt es genau ein Gremium; jeder Lauf liegt in `belege/gremium/`, auch verworfene.
- **Look:** „Bild-Look + Leben“ (BE-01); FEINKORN nur nach V-21.
- **Herkunft:** Bilder entstehen nur mit Mitteln ohne fremde Dienste. Was ein Mensch mit einem Bildgenerator erzeugen müsste, landet als fertige Bildbeschreibung in FUER-DEN-NUTZER.md.
- **Ablage:**
  - Kontaktbögen als JPEG oder WebP, höchstens 2.400 px breit und 1,5 MB.
  - Vorher/Nachher-Bögen mit höchstens 6 beschrifteten Paaren.
  - Bewegungsstreifen zusätzlich als animiertes WebP, höchstens 3 MB.
  - Alles unter `planung/bollwerk/bilder/<datum>/`, mit einer Zeile in `bilder/INDEX.md`: Zeit, Pfad, sha256, Inhalt, Ansicht.
  - Rohbilder bleiben im Scratchpad.
  - Der Leitstand zeigt jeden neuen Bogen dem Nutzer, denn der will Bilder immer im Chat sehen.

### 8.5 Prüfmauer – Mindestringe, billig vor teuer
| Ring | Prüfung | Schichten des Torwerkzeugs |
|---|---|---|
| 1 Form | Schema, Pflichtfelder, Kennungen, Länge, Sprache, keine Platzhalter | `varianten.dart`, F1 |
| 2 Regeln | Inhaltsregeln, Sperrliste, Namensbalance, Spoiler- und Geheimnisschutz, keine echten Personen oder Marken | L5, L0.4 |
| 3 Kanon und Logik | Kanon 1.0 bytegleich; Lösbarkeit nach M2 (Kette beim Öffnen, Gier-Bot); Bot-Quote im Band; Budget-Ungleichung und Kettenprüfung statisch | L0.3, L4 (C8 Nr. 1, 2, 7, 13) |
| 4 Technik | Bauen, Analysieren, Tests, Bildschirmbilder, Leistungs- und Größenbudget, keine fremden Server, Burgstadt-Schutz | L0 ganz, L1, L2, L3, L6, L8 |
| 5 Spiel | in Simulationen erreichbar, keine Sackgasse, Balance im Band, alle drei Modi | L4, L7 |
| 6 Neuheit | kein Beinahe-Duplikat | F4 |
| 7 Qualität | Rubrik mit unabhängigen Richtern. Weichen sie um mehr als 2 von 10 Punkten ab, urteilen zwei weitere, und der Median zählt | F5, L10, D1–D3, S1–S5 |
| 8 Stichprobe | je Welle zufällig (Seed nach §8.4) mindestens 10 % und mindestens 20 Einheiten, geprüft von Opus, bei großen Wellen von einem frischen Opus-5.5-Agenten. Ein Fehler bei Kanon, Inhalt oder Lösbarkeit oder sonst mehr als 5 % Fehler schickt die Welle zurück | L10 |
| 9 Mutanten und Rot-Proben | für neuen Code | L9a, L9b |

- Jeder Ring hat Messgröße, Schwelle, Werkzeug und eine Statistik je Welle.
- Die Schichten gehören zum Torwerkzeug `tool/bollwerk/bollwerk.dart [schnell|phase|nacht|ziel]` (Anhang A, MP-14).
- Teure Ringe laufen gebündelt je Welle. Warum: Die Cloud-Maschine hat 4 Kerne.
- Budget-Ungleichung und Kettenprüfung laufen statisch schon im Tor `schnell`, in jeder Welle.

### 8.6 Variantenfabrik
- **Slots und Auswahl:** Slots kommen aus dem Plan. Je Slot entstehen mehrere Varianten mit unterschiedlicher Vorgabe; die Auswahl folgt einer dokumentierten Regel.
- **Rückgabe:** Jeder Agent schreibt seine Variante in einen eigenen Pfad und gibt nur eine Zeile zurück: `KURZ · <Kennung> · <gruen|teil|rot> · Varianten <n> · Selbstprüfung <m>/<n> · Datei <pfad>`. Warum: Jede Rückgabe landet im Kontext von Opus, und der muss eine ganze Generation reichen.
- **Code-Aufträge:** in Pool-Kopien ohne Git (A4.9); den Patch erzeugt Opus.
- **Was Agenten nicht dürfen:** weder Git noch Installationen noch Netzwerk. Sie rufen nur die Werkzeuge und Prüfskripte auf, die ihr Paket nennt. Warum: Der Sicherheitsfilter zählt Sperren.
- **Nachbesserung:** Abgelehnte Varianten bekommen höchstens zwei Runden mit Befund; danach übernimmt Opus oder schneidet den Slot neu.
- **Gleiche Welle:** Agenten einer Welle teilen Modell, Denkstufe, Werkzeuge und Schema, damit sie den Zwischenspeicher mitlesen.
- **Ins Spiel:** Angenommene Varianten führt ein Skript ins Spiel zusammen, das Opus ausführt.
- **Register:** eine kompakte Tabelle mit Kennung, Slot, Status, Ringergebnissen und Punkten. Opus liest Statistiken und Stichproben, keine Rohtexte.
- **Paket-Bauplan für Haiku**, 12 Teile in fester Reihenfolge:
  1. Kopfzeile: Kennung · Rolle · Modell · Denkstufe · Welle · Kern-Version · Umfang · Schwierigkeit 1 bis 3
  2. Rollenbriefing
  3. Aufgabe in einem Satz
  4. das Projekt in fünf Sätzen, wortgleich in jedem Paket
  5. Kern-Auszug
  6. Qualitätsmaßstab
  7. Grenzen, mit dem Werkzeugabsatz aus §5 wortgleich
  8. nummerierte Schritte mit Mengen
  9. Muster als Illustration
  10. Ausgabeschema
  11. Selbstprüfung
  12. als letzte Zeile `=== ENDE [Kennung] · BEREIT ZUR RÜCKGABE ===`

  Pakete der Stufe 3 gehen an Opus.
- **Zufall:** Startwerte bekommt jeder Agent in seinem Paket; selbst würfelt er nie.

### 8.7 Betrieb über mehrere Nächte
- **Wellen:** Eine Welle sind gleichzeitig gestartete Hintergrund-Agenten (Agent-Werkzeug), höchstens so viele wie in M0 gemessen. Jede Welle passt in ein Limitfenster. Jeder Agent bekommt 10 bis 25 Varianten je Auftrag, damit wenige Rückgaben viele Varianten tragen.
- **Nutzungslimit:** Ein Limit ist nie ein Grund für eine neue Generation.
  - Der Lauf wartet selbst und setzt fort, oder er steht, bis der Leitstand nach dem Zurücksetzen „WEITER BOLLWERK“ schickt.
  - Bei `LIMIT-VORSORGE` aus STEUERUNG (Wochenlimit) schließt er die Welle ab, zieht den Morgenbericht vor und setzt NACHT-ENDE.
- **Laufende Arbeit:** Solange Hintergrundarbeit läuft, beendet der Lauf seinen Zug nicht. Er wartet mit dem belegten Wartebefehl (höchstens zehn Minuten).
  - Eine Welle, die länger als das Dreifache ihrer geplanten Dauer läuft, bricht er ab und wertet das Teilergebnis aus.
- **Wiederaufnahme:** nach 2.3 Schritt 3. Hintergrund-Agenten überleben keinen Neuaufbau der Maschine; deshalb prüft der Lauf jede Ausgabedatei aus FLUG.md und reiht Fehlendes einmal neu ein.
- **Sicherung:** Mindestens stündlich Commit und Push von `bollwerk`; jeder Code-Commit baut und testet grün. LEASE und PRUEFPUNKT werden alle 30 Minuten gepusht.
- **main-Stand:** Nach B-02 holt der Lauf an jedem Phasentor origin/main in `bollwerk`, nach der Konfliktregel aus Anhang A, MP-16. Die Konfliktzahl kommt in den Bericht.
- **Generationsende:** nach FENSTER oder bei erreichtem Nachtziel.
  - `ZUSTAND: NACHT-ENDE`, sichern, Morgenbericht, Zugende-Zeile.
  - Die nächste Generation startet der Leitstand.
- **Platte:**
  - Nur die zwei jüngsten `basis-<sha7>` behalten.
  - Logs und Varianten abgeschlossener Wellen nach dem REGISTER-Eintrag löschen.
  - Unter 8 GB frei: keine neuen Worktrees.
- **Morgenbericht:** bis M (06:30 Uhr) als `planung/bollwerk/MORGENBERICHT.md` mit Kontaktbögen. Der Leitstand prüft ab 06:00 und zeigt um 07:00.

### 8.8 Startpaket (für den Leitstand)
- **Startnachricht je Generation:**
  - Kopfzeile `Generation <n> · LEASE nach 2.5 · Leitstand <leitstand_id> · Master-Prompt aus <sha40 von bollwerk-plan>`
  - dann der vollständige Master-Prompt-Text
  - dann `START BOLLWERK`

  Passt der Text nicht in eine Nachricht, verweist die Kopfzeile auf `git show <sha40>:planung/bollwerk/MASTER-PROMPT.md`, und der Lauf liest ihn von dort.
- **Parameter für `create_session`:**
  - Repo-URL
  - `source_revision: bollwerk`
  - `outcome_branch: bollwerk`
  - `model: claude-opus-5-5`
  - `permission_mode: auto`
  - Titel `BOLLWERK G<n>`
  - Tag `bollwerk`

  Der Leitstand sucht vorher mit `list_sessions` nach einer laufenden `BOLLWERK G<n>`. Den Branch `bollwerk` legt er für G1 auf den Übergabe-SHA von `bollwerk-plan`. LAUF.md schreibt er nie.
- **Gebrauchsanleitung für den Nutzer**, höchstens zehn Zeilen:
  - was der Loop tut
  - die Steuerworte
  - was nur Menschen tun können
  - eine ehrliche Erwartung zu Dauer, Faktor und Kosten
- **Prüfliste für den Leitstand** in dieser Reihenfolge:
  1. `failed`
  2. `rate_limit_info` (das letzte Ereignis ist ein Limitfehler, das gilt auch bei `failed`)
  3. `blocked`: Nur der Nutzer im Web kann das lösen, denn `send_message` gilt nicht als Zustimmung (C15). Der Leitstand meldet den Wortlaut.
  4. Zugende-Zeile mit SHA = origin/bollwerk
  5. Hänger: kein Limit, Weckruf + 30 min überschritten und LEASE-Herzschlag älter als 90 Minuten

  Für jeden ZUSTAND nennt die Prüfliste eine Handlung nach der Tabelle in 2.5.
- **Keine Sperrdatei, keine Umgebungsvariablen.** Warum:
  - Die Umgebung „Default“ teilen mehrere Läufe.
  - Ob `availableModels` aus der Repo-Datei in der Cloud wirkt, ist nicht belegt (C14).
  - Eine Sperrdatei nur mit Verboten ist Annahme A-13 (Standard: keine).

  Die Modellreinheit sichern die Modellangabe je Aufruf und der Protokollbeleg.

## 9. PRÜFUNG DES MASTER-PROMPTS
**Rubrik** mit 0, 1 oder 2 Punkten je Prüfung:

| Nr. | Prüfung |
|---|---|
| P1 | Ziel |
| P2 | Kontext |
| P3 | Ende: Kriterien mit Methode, Schwelle und Beleg |
| P4 | Steuerung: Regelkreise mit Ausgang und Höchstzahl |
| P5 | Widerspruchsfreiheit, auch gegenüber den Anhängen |
| P6 | Grenzen konkret und abhakbar |
| P7 | Umgebungstreue: nur Funktionen, die die Umgebung wirklich hat; Unsicheres markiert |
| P8 | Ausführbarkeit ohne Rückfrage |
| P9 | Robustheit gegen frühen Stopp, Endlosschleife, Abdriften und Schönrechnen |
| P10 | Dichte |
| P11 | Modellgerechtheit |
| P12 | Startbarkeit und Generationswechsel |
| P13 | Modellreinheit |

- **Freigabe** ab 23 von 26 Punkten ohne eine 0.
- **Bewertung:** Ein frischer Opus-5.5-Agent bewertet, der die Entstehung nicht gesehen hat.
  - Er bekommt die Rubrik, Master-Prompt, Anhänge, Startpaket, LAGEBILD sowie §1, §3, §8 und §11 dieses Auftrags.
  - Sein Urteil nennt die `sha256sum` von Prompt und Anhängen; jede spätere Änderung macht es ungültig.
- **Linsen:** Danach prüfen 10 Haiku-Gegenprüfer mit je einer Linse: Ausführbarkeit, Sicherheit und Hoheit, Spiel und Würfel, Durchhalten, Messbarkeit, Look, Umfang und Füllstoff, main-Reife und Archiv, Widerspruch, Loop-Schnittstelle.
  - Jeder Befund hat Schwere, Beleg und Ersatztext.
  - BLOCKER gehen an je 3 Skeptiker; ein BLOCKER gilt bei 2 von 3 Stimmen.
  - Offene MAJOR stehen mit Folge in den Annahmen.
- **Schriftprüfung:**
  - `grep -nE 'refs/heads/main|refs/tags/|git tag|create_trigger|--force|create_session' MASTER-PROMPT.md anhang/*.md` trifft nur Nie-Listen.
  - Das Auslösewort hat 0 Treffer.
  - `proben/kriterien.sh` findet je Z-Zeile einen Befehl in Backticks, eine Schwelle mit Zahl oder Vergleich und einen Belegpfad: 0 Mängel.

**Proben**, jede mit Befund und Folge im PRUEFBERICHT:
1. **Probelauf:** Was tut der Nachtlauf in seinen ersten drei Schritten nach START BOLLWERK?
2. **Rotes Team:** Drei Haiku-Angreifer suchen unabhängig, wie der Nachtlauf abkürzen, Einheiten doppelt zählen, Tests umgehen, Schwellen still senken, die Steuerung missbrauchen oder die Hoheit verletzen könnte. Jede gefundene Lücke wird geschlossen.
3. **Stopp-Probe:** Wo könnte der Lauf zu früh aufhören oder auf eine Antwort warten, die nie kommt?
4. **Schleifen-Probe:** Hat jeder Kreis eine Höchstzahl?
5. **Drift-Probe:** Was hält den Lauf nach zwölf Stunden und in Generation 5 auf Kurs?
6. **Fremdleser-Probe:** Versteht ein Mensch ohne Vorwissen, was der Prompt will?
7. **Umgebungs-Probe:** Jede genannte Funktion gegen LAGEBILD, BELEGE und §11.
8. **Modell-Probe:** Prompt und Startpaket nach Modellnamen durchsuchen; erlaubt sind nur Opus 5.5 und Haiku 5.5.
9. **Kaltstart-Probe:** Ein frischer Opus-5.5-Agent bekommt nur den Master-Prompt, dessen Anhänge und einen Wegwerf-Worktree von `bollwerk-plan`.
   - Du legst je Durchgang unter `$SCRATCH/kalt/<d>/` Stellvertreter an: `origin-bollwerk/…/LAUF.md`, `origin-leitstand/STEUERUNG.md`, `BEFUNDE.md` und `limit.txt`. Der Agent bekommt die Zuordnung zu den echten Ref-Pfaden; Fetch und Push beschreibt er als gelungen.
   - Durchgänge:
     1. B-02 offen
     2. B-02 ERFÜLLT mit K
     3. Generation 2 findet LEASE gen=1, einen offenen Eintrag S-<n> und ein gerade abgelaufenes Limit vor
   - Jeder Durchgang geht bis zum ersten Phasentor, nur mit lesenden Befehlen und höchstens 20 Minuten lang.
   - Der Agent listet jede Stelle, an der er hätte fragen müssen. Bestanden bei null blockierenden Fragen.
10. **Verdichtungs-Probe:** Du legst LAUF, KERNKARTE, PRUEFPUNKT, FLUG und STATUS eines gedachten Zwischenstands um 03:00 Uhr in Generation 2 an.
    - Ein frischer Haiku-Agent bekommt nur diese Dateien und muss sagen, wo der Lauf steht und was als Nächstes kommt.
    - Bestanden, wenn beides mit dem Plan übereinstimmt.

Höchstens drei Prüfrunden; danach lieferst du mit offen benannter Schwäche.

## 10. ABNAHME DES META-LAUFS
Lege die Kriterien in M0 als `meta/ABNAHME-META.md` an und hake nur mit Beleg ab. Je Zeile stehen Befehl, Ausgabeauszug und SHA.

| Nr. | Kriterium | Abnahme |
|---|---|---|
| M-01 | Lage | Alle acht Fragen aus M0 sind beantwortet oder als nicht klärbar markiert, je mit Folge. Die Faktenprüfung von Anhang B ist abgeschlossen; die Abweichungen stehen im LAGEBILD. |
| M-02 | Läufe | `proben/b02.sh` prüft die B-02-Bedingungen aus 2.2 und ist heute gelaufen; die Ausgabe steht im LAGEBILD. Stand und erwarteter Abschluss aller Läufe sind dokumentiert. |
| M-03 | Messbasis-Prognose | Das Messskript liefert in zwei Durchläufen dieselben Zahlen. Eine Gegenzählung von 20 Einheiten durch einen Haiku-Messer stimmt überein. Die Achsenprüfung ist erledigt. |
| M-04 | Bestand und Nutzerwille | Jedes Spielteil hat Fundstelle und Schicksal. In der Anforderungsmatrix ist jeder Satz aus A1 und jede Entscheidung aus A2 einer Stelle im Master-Prompt zugeordnet: 0 Lücken. |
| M-05 | Spielkern | Kern-Aussagen zu Runde, Entscheidungen, sichtbaren Aktionen, Spielwürfel, Party, Solo, WLAN, Salz und Geheimnisschutz liegen vor. Alle Schwellen aus C8 Nr. 1 bis 13 und C9 sind mit Seed und Partienzahl erfüllt. Die gewählten Werte stehen als Annahme; die Bänder sind bindend. |
| M-06 | Design | Das Bildverfahren ist erprobt: drei Bildschirme, drei Ansichten, Gleichheit bei gleicher SHA. Die Designmaße haben Basiswerte. D3a ≥ 15/18 mit ≤ 1/6 Fehlalarm; D3b und S1 bis S5 sind geeicht. |
| M-07 | Fabrik | Die Slot-Arten für X1, X2, X4 und X6 liefen durch alle Ringe, je Ring mit Befehl. Was nicht lief, ist als „nur beschrieben“ markiert. Erfasst sind Parallelität, Annahmequoten, Dauern, gültige Einheiten je Agentenstunde, Tokens oder ihre Schätzung und Fehlerbilder. |
| M-08 | Plan | Mengengerüst, Kapazitätsrechnung mit Faktor 0,8, F mit Begründung, Zwischenziele je Nacht und Achse, Wellenplan mit Vorlauf, Durchstich und kritischem Pfad. |
| M-09 | Master-Prompt | Vollständig nach §8; ein Text ohne verschachtelte Codeblöcke, höchstens 55.000 Byte. Die Schriftprüfung aus §9 ist bestanden. Jeder Agentenauftrag nennt Modell und Denkstufe. Die Verweise auf 2.2, 2.5 und Abschnitt 6 stimmen. Jede Schicht L0 bis L10 hat Befehl, Fallzahl je Modus und Budget. |
| M-10 | Prüfung | Rubrik mindestens 23 von 26 ohne 0, mit sha256 gebunden. Alle zehn Proben stehen mit Befund und Folge im PRUEFBERICHT. 0 bestätigte BLOCKER offen. |
| M-11 | Startpaket | Startnachricht, Parameter, Gebrauchsanleitung mit höchstens zehn Zeilen und Prüfliste für den Leitstand. |
| M-12 | Übergabe | `git diff --stat origin/main...origin/bollwerk-plan` zeigt nur `planung/bollwerk/`. Das Push-Protokoll nennt nur `bollwerk-plan`. Die Wegwerf-Worktrees sind entfernt. Die letzte Nachricht folgt §12. |
| M-13 | Loop-Schnittstelle | LEASE, FENSTER, ZUSTAND-Tabelle, Zugende-Zeile, Weckruf, Weißliste, QUITTUNGEN, B-02 über STEUERUNG, MAIN-REIFE mit R und Generationsfenster stehen im Master-Prompt. Kaltstart-Durchgang 3 ist bestanden. |

**Abschlussregel:**
- Erledigt ist, was mit Beleg abgehakt ist. Kriterien sinken nie still.
- Ist eines von M-01 bis M-08 unerreichbar, steht es mit Grund und bester Ersatzlösung in den Annahmen.
- M-09 bis M-11 und M-13 haben keine Ersatzlösung.
- Für M-12 gibt es genau eine: Ist der Push nachweislich unmöglich, stehen Master-Prompt und Startpaket vollständig in der letzten Nachricht und der Grund in FUER-DEN-NUTZER.md.

## 11. BETRIEBSWISSEN
Stand 9. Oktober 2026, geprüft gegen die offizielle Claude-Code-Dokumentation (Zitate und Links in `v4/BELEGE-DOKU.md`) und die Kinder-Probe des Leitstands. Unsicheres prüfst du in M0 nach.

**Maschine und Einstellungen**
- **Maschine:** Cloud-Sitzungen laufen auf einer frischen Ubuntu-Maschine mit etwa 4 Kernen, 16 GB Speicher und 30 GB Platte. Kindsitzungen klonen flach (Tiefe 50), auf den Branch aus `source_revision`. (C1, Kinder-Probe)
- **Einstellungen:** Eine Cloud-Sitzung mit genau einem Repo liest dessen `.claude/settings.json`, aber keine Benutzer- oder lokalen Einstellungen. Den Auto-Modus wählt man im Modus-Menü oder beim Erzeugen der Sitzung. (C2)
- **Git-Proxy:** Er lehnt Tag-Pushes und Branch-Löschungen ab; Branch-Pushes lässt er zu. GraphQL ist gesperrt, `gh pr` scheitert daher. (C3)

**Befehle und Agenten**
- **Befehlsdauer:** Im Vordergrund standardmäßig 2 Minuten, höchstens 10, danach bis zu 30 weitere Minuten im Hintergrund. Ein direkt im Hintergrund gestarteter Befehl hat bis zu 2 Stunden. Befehle, die mit `sleep` beginnen, werden nicht verschoben. (C4)
- **Pausen:** Ohne Aktivität pausiert die Maschine nach wenigen Minuten. Bei einem Neuaufbau sind laufende Agenten, Befehle und /loop-Weckrufe verloren. Laufende Hintergrund-Agenten gehen verloren; Dateien außerhalb von Git auch. (C5)
- **Workflows:** nur, wenn der Nutzer sie in derselben Sitzung selbst verlangt; in Kindsitzungen also nicht (Kinder-Probe). Grenzen, wo sie gelten: 1.000 Agenten je Lauf, 2 gleichzeitig auf dieser Maschine. (C6, C10)
- **Hintergrund-Agenten:** Das Agent-Werkzeug startet Agenten im Hintergrund, ohne Rückfrage; in der Leitstand-Sitzung liefen 10 gleichzeitig. Jede Rückgabe kommt als Benachrichtigung in den Kontext.
- **Modellwahl:** Angabe im Aufruf → Agentendefinition → `CLAUDE_CODE_SUBAGENT_MODEL` → Sitzungsmodell. Erkundungs- und Planungsagenten laufen auf dem Hauptmodell. (C7)
- **Denkstufen:** Opus 5.5 und Haiku 5.5 kennen low bis max. `CLAUDE_CODE_EFFORT_LEVEL` überschreibt jede Angabe. (C8)

**Auto-Modus und Freigaben**
- **Auto-Modus:** Pushes auf jeden Branch sind erlaubt. Gesperrt sind Force-Push, `git reset --hard` auf fremden Stand, neue Remotes und ein PR-Merge ohne Mensch. Nach drei Sperren in Folge oder zwanzig insgesamt fragt er wieder. Grenzen aus dem Gespräch liest der Filter bei jeder Prüfung neu. (C11)
- **Zustimmung:** Der Prompt einer Routine, eine Nachricht einer anderen Sitzung und die Startnachricht einer Kindsitzung gelten nicht als Zustimmung (C15). Die Kinder-Probe zeigt: Eine Kindsitzung führt einen harmlosen Auftrag auf ihrem eigenen Branch aus. Deshalb pusht der Nachtlauf nur `bollwerk`, und main pusht der Leitstand.

**Werkzeuge und Limits**
- **/goal:** Der Nachtlauf braucht es nicht. (C12)
- **Nutzungslimit:** Für interaktive Sitzungen mit Abo gilt Warten und Fortsetzen, höchstens zweimal in Folge. Für Cloud-Kindsitzungen ist das nicht dokumentiert. Ein Wochenlimit startet kein Warten. (C13)
- **Modellsperre:** `availableModels` gibt es. Ob die Repo-Datei sie in der Cloud durchsetzt, ist nicht belegt. (C14)
- **In der Kindsitzung vorhanden** (Kinder-Probe): Agent, SendUserFile und `send_later`; Workflow ist sichtbar, aber ohne Nutzeranfrage nicht freigegeben. Ein Haiku-Agent lief ohne Rückfrage, es entstand kein automatischer Pull Request, und die Startnachricht gilt der Kindsitzung als automatischer Auftrag, den sie auf ihrem eigenen Branch ausführt.

## 12. GEDÄCHTNIS, STATUS, ÜBERGABE
- **Planungsordner** `planung/bollwerk/` auf `bollwerk-plan`:
  - **Zustand des Meta-Laufs** unter `meta/`: META-AUFTRAG, STATUS (mit Sperrzähler und Quittungen), ABNAHME-META.
  - **Ergebnisse:** LAGEBILD, BESTAND, MESSBASIS-PROGNOSE mit Messskript, SPIELKERN, FABRIKPROBE, DESIGN-PROBE, PLAN, ENTSCHEIDUNGSLOG, ANNAHMEN, PRUEFBERICHT, FUER-DEN-NUTZER.
  - **Übergabe:** MASTER-PROMPT.md, `anhang/A-<n>-<name>.md`, STARTPAKET.md.
  - **Startdateien der Nachtläufe:**
    - `LAUF.md` mit `LEASE gen=0`, `ZUSTAND: NICHT BEGONNEN` und `QUITTIERT S=0 F=0`
    - PRUEFPUNKT.md, STATUS.md, QUITTUNGEN.md (leer)
  - **Probeskripte** unter `proben/`.
  - **Bilder** unter `bilder/meta/` mit `bilder/INDEX.md`.
- **STATUS** hält Phase, abgehakte Kriterien, Quittungen, Sperrzähler und nächsten Schritt. Nach einer Kontextverdichtung liest du zuerst META-AUFTRAG, STATUS und ABNAHME-META.
- **Statuszeile:** Jede Antwort beginnt mit `STAND · Meta-Phase M[n] von M7 · Abnahme [a] von 13 · Agenten aktiv [x] · nächster Schritt: […]`
- **Die letzte Nachricht** enthält in dieser Reihenfolge:
  1. **Annahmen**, nummeriert, A-01 bis A-13 aus Anhang A2a plus neue: Entscheidung · Standard · Folge, wenn der Nutzer sie kippt.
  2. **Prognose:** erwarteter Zuwachsfaktor mit Spanne, Zahl der Nächte, die drei größten Risiken.
  3. **Master-Prompt:** Pfad, Größe in Byte und sha256.
  4. **Startpaket:** Startnachricht, Parameter, Gebrauchsanleitung, Prüfliste.
  5. **Bilder:** alle Kontaktbögen mit Pfad aus `bilder/INDEX.md`.
  6. **Was nur Menschen tun können.**
  7. **Stand von M-01 bis M-13**, je mit einem Beleg.

  Die letzte Zeile lautet `=== BOLLWERK-META-ENDE · <BEREIT|HALT> · Runde <k> · <Commit-SHA mit 40 Zeichen> ===`.
  - BEREIT nur, wenn M-09 bis M-13 erfüllt sind und `git ls-remote origin refs/heads/bollwerk-plan` genau diesen SHA zeigt.
  - Auf diesen SHA legt der Leitstand `bollwerk`.
- **Danach** bleibt die Sitzung offen. Schickt der Leitstand Befunde (höchstens eine Nachbesserungsrunde), arbeitest du sie ein, prüfst die betroffenen Teile nach §9 und übergibst neu.

## 13. START
Beginne sofort mit M0 in der dort genannten Reihenfolge:
1. Statuszeile
2. Branch
3. Anhänge laden
4. META-AUFTRAG, ABNAHME-META und STATUS
5. Commit und Push
6. Modellprobe
7. Lagebild

Danach arbeitest du alle Phasen ohne Rückfragen bis zur Übergabe ab.
