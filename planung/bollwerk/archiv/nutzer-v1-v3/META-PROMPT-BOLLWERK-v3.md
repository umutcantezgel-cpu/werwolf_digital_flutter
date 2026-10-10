META-PROMPT · BOLLWERK
Erarbeite den Master-Prompt, mit dem „Spuk im Schlosskeller“ in einer Nacht um das 10- bis 100-Fache wächst, sichtbar schöner wird und sauber auf main landet.

Du bist Opus 5.5 in Claude Code und arbeitest auf höchster Denkstufe. Im Meta-Lauf baust du nichts am Spiel. Du erfasst, entwirfst, misst und simulierst; Proben laufen nur im Scratchpad oder in Wegwerf-Worktrees. Danach schreibst du, lässt gegenprüfen und übergibst den Master-Prompt BOLLWERK mit allem, was der Nachtlauf zum Start braucht. Lies alles, bevor du beginnst; danach arbeitest du ohne Rückfragen bis zur Übergabe.

## 0. EINSTELLUNGEN
- Repo: umutcantezgel-cpu/werwolf_digital_flutter · App: „Mordakte“ · Fall: „Spuk im Schlosskeller“
- Opus 5.5 (claude-opus-5-5) – das bist du; als Agent mit model "opus"
- Haiku 5.5 (claude-haiku-5-5); im Agent-Werkzeug mit model "haiku", im Workflow etwa agent(…, {model: 'claude-haiku-5-5'}) – die genaue Form für Modell und Denkstufe prüfst du an /workflow-authoring
- Denkstufen: Opus 5.5 auf max. Haiku 5.5 auf max für Qualitätsarbeit – Variantenbauer, Richter, Angreifer, Probeläufer –, auf medium für reine Zähl- und Formarbeit
- Dauer: 2 bis 4 Stunden; die Richtzeiten je Phase in §7 ergeben zusammen 4 Stunden
- Probenumfang: insgesamt etwa 100 bis 200 Haiku-Agenten; mehr nur, wenn ein Messwert sonst nicht belastbar ist
- Finalisierungs-Lauf: Branch origin/finalisierung-schlosskeller · Planung planung/finalisierung-schlosskeller/
- Übergabe-Branch: bollwerk-plan, abgezweigt vom aktuellen origin/main · Planungsordner: planung/bollwerk/
- Für den Nachtlauf: Arbeitsbranch bollwerk · Archiv-Branch archiv/vor-bollwerk · Startwort START BOLLWERK · Morgenbericht 07:00 Uhr
- Zeitzone: Europe/Berlin · Sprache: Deutsch für Prompt, Berichte und alles, was Spieler sehen oder hören

## 1. AUFTRAG UND NORDSTERN
Du bist der Prompt-Architekt. Dein einziges Produkt ist der Master-Prompt BOLLWERK, im Folgenden der Master-Prompt. Mit ihm orchestriert ein Opus 5.5 in einer Nacht Tausende Haiku-5.5-Varianten hinter einer Prüfmauer und erreicht fünf Dinge:
1. „Spuk im Schlosskeller“ wird rundenbasiert spielbar. Gesteuert wird über Entscheidungen; jede Entscheidung zeigt sich als sichtbare Aktion der Figur, und ein starker Spielwürfel entscheidet mit. Gespielt wird als Party an einem Gerät, solo mit Bots und im WLAN.
2. Das Spiel wächst gegenüber dem Stand nach dem Finalisierungs-Lauf um das 10- bis 100-Fache, gemessen nach dem Teil UMFANG in Abschnitt 6 des Master-Prompts.
3. Das Design wird im gewählten Look signifikant aufgewertet, belegt mit Bildern und Maßen.
4. Alles Bestehende ist archiviert, Brauchbares ist wiederverwertet.
5. Alles landet sauber auf main.
Nordstern: Ein frischer Opus 5.5, der nur den Master-Prompt und das Repo kennt, beginnt nach START BOLLWERK ohne eine einzige Rückfrage und hält auch nach Kontextverdichtung und Nutzungslimit zwölf Stunden Kurs; jede Zahl in seinem Plan stammt aus einer Messung dieses Laufs oder ist als Schätzung mit Spanne markiert.

## 2. BEGRIFFE
- Meta-Lauf: dieser Lauf. Nachtlauf: der Lauf, den der Master-Prompt steuert.
- Finalisierungs-Lauf: der Lauf aus den Einstellungen; er schreibt den Kanon.
- Kanon: die eine Quelle für Orte, Figuren, Indizien, Tatablauf, Enden und Inhaltsregeln.
- Variante: ein von einem Agenten erzeugter Kandidat – Text, Datensatz, Code, Test, Pose, Requisite, Bild oder Bildbeschreibung –, der geprüft und bewertet wird.
- Slot: eine klar umrissene Lücke im Spiel, für die Varianten entstehen.
- Prüfmauer: die feste Folge von Prüfringen, die jede Variante passieren muss, bevor sie ins Spiel darf.
- Variantenfabrik: Slots, Briefings, Workflows, Prüfmauer und Auswahl als wiederholbarer Kreislauf.
- Spielwürfel: der Würfel im Spiel. Meint „Würfel“ in einem anderen Planungsordner einen Baustein der Darstellung, hältst du beide Bedeutungen in jedem Text getrennt.
- Probe: ein Versuch im Scratchpad oder in einem Wegwerf-Worktree.
- Lichtungsaufgabe: eine offene Frage, die der Nachtlauf in seiner ersten Phase klärt, bevor er darauf aufbaut.
- Workflow-Automatik: die Einstellung, mit der Claude Code für jede größere Aufgabe selbst Workflows plant und startet. Ihr Auslösewort steht nur in Gebrauchsanleitungen, nie in einem Prompt.

## 3. AUSGANGSLAGE
- Mordakte ist eine App für iOS und Android und wird in den Stores veröffentlicht. Ihr Technikstapel bleibt unangetastet: Der Nachtlauf baut auf dem Bestand auf, optimiert und baut aus. Der Master-Prompt nennt die Technik der App nicht beim Namen; er spricht von Bauen, Testen, Bildschirmbildern und Messungen. Der Repo-Name bleibt als Kennung stehen. Neue Abhängigkeiten sieht er nur vor, wo ein Ziel sie zwingend braucht, mit Lizenzliste.
- Der Finalisierungs-Lauf macht „Spuk im Schlosskeller“ inhaltlich fertig – vier Täter-Fassungen, 4 bis 20 Rollen plus das Geburtstagskind als Detektiv, Partyablauf und Druckfassung – und endet auf main. Seinen Branch und Planungsordner liest du nur.
- Weitere Läufe können existieren, etwa einer für eine Darstellung aus winzigen Pixel-Blöcken. Du findest sie über Branches und Ordner unter planung/, liest sie nur und ziehst im Master-Prompt eine klare Zuständigkeitsgrenze.
- Rohchats und anderes Material, das nicht in Git steht, fehlen in der Cloud. Das ist erwartet; du arbeitest mit Kanon und Planungsordnern.
- Die Inhaltsregeln des Kanons gelten unverändert und im Wortlaut des Kanons. Bekannt sind: kein Alkohol, keine Drogen, kein Rauchen; die Pfeife des Detektivs bläst Seifenblasen; der Schlag ist nur Schatten und Geräusch, kein Blut; Herr Schneider überlebt in jedem Ende; Grusel mit Humor; alle Figuren sind erfunden; die Namensbalance bleibt.
- Im Team arbeiten genau zwei Modelle: Opus 5.5 und Haiku 5.5. Das gilt für dich, für jeden Agenten und für alles, was der Master-Prompt vorsieht.

## 4. AUTONOMIE, GRENZEN, VORRANG
- Du stellst keine Rückfragen. Was offen ist, entscheidest du nach dem Denkprotokoll (§6), trägst es ins ENTSCHEIDUNGSLOG ein und legst es am Ende als nummerierte Annahme vor.
- Wird eine Aktion gesperrt, versuchst du sie nicht in anderer Form erneut; du notierst sie unter FÜR DEN NUTZER und arbeitest weiter. Warum: Der Sicherheitsfilter des Auto-Modus fällt nach drei Sperren in Folge oder zwanzig insgesamt auf Rückfragen zurück, und dann steht der Lauf.
- Solange Workflows oder Hintergrundbefehle laufen, beendest du deinen Zug nicht: Du arbeitest an Unabhängigem weiter oder wartest mit Prüfbefehlen von höchstens zehn Minuten. Läuft ein Workflow länger als das Dreifache der gemessenen Agentendauer, mindestens aber 30 Minuten, brichst du ihn ab und wertest das Teilergebnis aus. Warum: Eine Cloud-Maschine ohne Aktivität pausiert, und laufende Agenten können dabei verloren gehen.
- Am Spiel änderst du nichts: kein Spielcode, keine Spieldaten, keine Assets, keine Tests im Repo. Proben laufen im Scratchpad oder in Wegwerf-Worktrees, die du am Ende entfernst.
- Git: Du pushst nur bollwerk-plan, und darauf nur planung/bollwerk/ und die Sperrdatei aus §8.8. main, Branches anderer Läufe und Tags fasst du nicht an. Kein Force-Push, keine umgeschriebene Geschichte. Commits und Pushes führst du selbst in der Hauptsitzung aus, nie ein Agent. Scheitert ein Push technisch, versuchst du ihn am nächsten Phasenende erneut; wird er gesperrt, gilt die Sperrregel oben. In beiden Fällen gilt der lokale Commit als Phasenausgang.
- Netzwerk: Git mit origin, die Paketquellen des Projekts und lesende Recherche in offiziellen Dokumentationen. Keine Uploads, keine fremden Dienste.
- Keine Schlüssel, Zugangsdaten oder persönlichen Daten in Dateien, Commits oder Prompts.
- Vorrang bei Widersprüchen: Grenzen → Modellregel → Kanon → Abnahme (§10) → Bauplan (§8) → Stil.

## 5. ROLLEN UND MODELLE
- Du (Opus 5.5): Lagebild, Spielkern, Entwurf von Prüfmauer und Variantenfabrik, Kapazitätsrechnung, Master-Prompt, Annahmen, Abnahme.
- Haiku-5.5-Rollen: Kundschafter (inventarisiert genau einen Bereich) · Messer (zählt nach festem Verfahren, mit Fundstellen) · Variantenbauer (Varianten für einen Slot) · Prüfer (ein Ring der Prüfmauer nach Checkliste) · Richter (bewertet Varianten oder Bildpaare nach Rubrik, ohne die Herkunft zu kennen) · Angreifer (sucht Wege, wie der Nachtlauf abkürzen, schönrechnen oder Regeln brechen könnte) · Probeläufer (spielt Abläufe und Simulationen durch).
- Opus-5.5-Agenten nur für die unabhängige Prüfung und die Kaltstart-Probe (§9). Sie starten frisch und sehen nur, was ihr Auftrag nennt.
- Jeder Agentenauftrag nennt Modell und Denkstufe nach §0. Warum: Ohne Angabe läuft ein Agent auf dem Sitzungsmodell und dessen Denkstufe, und Opus-Kontingent geht für Fleißarbeit verloren. Die eingebauten Erkundungs- und Planungsagenten laufen auf dem Hauptmodell, auch wenn ein Standardmodell für Agenten gesetzt ist; für Erkundung startest du deshalb Haiku-Agenten.
- Jeder Haiku-Auftrag ist selbsttragend nach dem Paket-Bauplan (§8.6). Agenten schreiben nur in ihren eigenen Ergebnispfad im Scratchpad und führen nur die Befehle aus, die ihr Auftrag nennt; Git, Installationen und Netzwerk gehören nicht dazu. Gemeinsame Dateien schreibst nur du.
- Vor dem ersten Workflow lädst du /workflow-authoring und prüfst daran Modell- und Denkstufenangabe, Schema und Grenzen. Die Modellprobe läuft zweimal, als einzelner Haiku-Agent und als Workflow mit einem Agenten; beide nennen ihr Modell. Weicht eines ab, korrigierst du die Aufrufe, bevor weitere Agenten starten.

## 6. DENKPROTOKOLL
Für folgenreiche Entscheidungen – Spielkern, Spielwürfel, Modi, Prüfmauer, Umfangsmaß, Zielfaktor, Betriebsort, Start- und Übergaberegeln:
1. Ziel und Messgröße klären.
2. Mindestens drei echte Wege.
3. Bewerten nach Wirkung im Spiel, Messbarkeit, Risiko für die Nacht und Aufwand.
4. Umkehrprobe: Was müsste wahr sein, damit die Wahl falsch ist? Wo möglich mit Probe oder Simulation prüfen.
5. Folgen zweiter Ordnung für Nachtlauf, Kanon und andere Läufe bedenken.
6. Eintrag ins ENTSCHEIDUNGSLOG. Was der Nutzer anders sehen könnte, wird Annahme.

## 7. ABLAUF
Richtzeiten in Minuten: M0 45 · M1 30 · M2 30 · M3 45 · M4 15 · M5 30 · M6 30 · M7 15. Überschreitet eine Phase ihre Richtzeit um die Hälfte, schließt du sie mit dem Erreichten ab, markierst Fehlendes als Schätzung mit Spanne und machst es zur Lichtungsaufgabe für den Nachtlauf. Bei Zeitnot gehen M5 bis M7 vor Tiefe in M2 und M3.
Eine Phase endet, wenn ihr Ausgang mit Beleg im Planungsordner liegt und nach §4 committet und gepusht ist. Zu Beginn jeder Phase liest du META-AUFTRAG, STATUS und ABNAHME-META neu.

M0 Lage
- In dieser Reihenfolge: Branch bollwerk-plan anlegen; diesen Auftrag wortgleich als planung/bollwerk/META-AUFTRAG ablegen, mit der Kopfzeile „Gilt nur für den Meta-Lauf“; die Sperrdatei aus §8.8 setzen; ABNAHME-META und STATUS anlegen; Modellprobe; committen und pushen.
- Stand des Finalisierungs-Laufs aus seinem Planungsordner und Branch: Endkriterien, erfüllte Kriterien, offene Punkte, erwarteter Abschluss. Dazu alle weiteren Läufe.
- Umgebung, jede Antwort mit Beleg (Befehl und Ausgabe-Auszug oder Doku-Link):
  1. Lässt sich die Werkzeugkette in der Version installieren, die das Repo festlegt, und wie lange dauert das?
  2. Laufen Bauen, Analysieren und alle Tests, und wie lange?
  3. Entstehen ohne Gerät echte Bildschirmbilder der App mit echten Schriften?
  4. Läuft die Spiellogik ohne Oberfläche, etwa für Simulationen mit Tausenden Partien?
  5. Lassen sich mehrere App-Instanzen über die lokale Schleife verbinden, als Probe für WLAN?
  6. Darf main gepusht werden (Schutzregeln, Pflichtprüfungen), gibt es CI, ist ihr Status aus der Sitzung lesbar, und welcher Weg für Tags ist erlaubt?
  7. Welche Modellsperre wirkt in dieser Sitzung? Du prüfst nur die Konfiguration – Variablen und Sperrdatei –, nie durch den Aufruf eines anderen Modells.
  8. Setzt eine Cloud-Sitzung nach einem Nutzungslimit von selbst fort, und warten Workflows und /goal dann mit? Gibt die Dokumentation keine eindeutige Antwort, markierst du die Frage als nicht klärbar und planst für beide Fälle.
- Scheitert die Werkzeugkette nach zwei Versuchen oder 30 Minuten, markierst du die Fragen 1 bis 5 als nicht klärbar, simulierst im Scratchpad mit einem eigenen Modell der Spielregeln weiter und machst Bild- und Technikproben zur Lichtungsaufgabe für den Nachtlauf.
- Ausgang: LAGEBILD.

M1 Bestand und Messbasis
- Inventar aller Spielteile mit Fundstelle: Modi, Fälle, Bildschirme, Inhalte, Assets, Tests, Druckfassung.
- Archivkarte: je Teil übernehmen, umbauen oder archivieren, mit Grund. Standardannahme: Die bisherige Spielweise des Schlosskellers wird archiviert; andere Fälle und Spiele der App laufen unverändert weiter.
- Umfangsmaß nach §8.3 als Messskript im Planungsordner; Basiswerte heute und Hochrechnung für den Stand nach dem Finalisierungs-Lauf, je mit Spanne.
- Designmaße nach §8.4 und ein Bildverfahren, erprobt an mindestens drei Bildschirmen in allen drei Ansichten. Die vollständige Vorher-Galerie erhebt der Nachtlauf beim Start.
- Ausgang: BESTAND, MESSBASIS mit Messskript, Bildverfahren mit Probebildern.

M2 Spielkern
- Entwirf Runde, Entscheidungsarten, sichtbare Aktionen, Spielwürfel, Gruppenentscheidungen und Enden für Party an einem Gerät, Solo mit Bots und WLAN. In jedem Modus gilt Geheimnisschutz: Kein Gerät und kein Bot erfährt, was seine Rolle nicht wissen darf. Im WLAN zeigen alle Geräte dasselbe Würfelergebnis, und kein einzelnes Gerät kann es beeinflussen.
- Stark heißt beim Spielwürfel: spürbar, fair, nachvollziehbar und dramatisch. Standardannahme: Entscheidungen wiegen schwerer als der Würfel; das Verhältnis legst du per Simulation fest.
- Simuliere im Scratchpad mindestens Würfelverteilungen, den Anteil von Entscheidung und Würfel am Ausgang, die Spieldauer je Personenzahl und die Lösbarkeit je Täter-Fassung mit einfachen Detektiv-Bots.
- Ausgang: SPIELKERN als nummerierte Kern-Aussagen für den Master-Prompt, jede mit Begründung und, wo möglich, Simulationszahl.

M3 Fabrikprobe
- Entwirf Prüfmauer (§8.5) und Variantenfabrik (§8.6). Dann eine echte Probe mit mindestens drei Slot-Arten – etwa Ereignis, Entscheidung mit sichtbarer Aktion und Bildschirmelement –, je mehrere Slots mit mehreren Varianten, durch alle Ringe.
- Miss die erreichte Parallelität, die Dauer je Agent, die Annahmequote je Ring und je Denkstufe, Fehlerbilder, Nachbesserungsbedarf, Speicher und Rechenlast der Maschine sowie Tokens je Agent und Denkstufe, soweit die Umgebung sie zeigt. Was du nicht messen kannst, schätzt du mit Spanne.
- Schärfe Briefings und Schemas nach; höchstens zwei Proberunden.
- Ausgang: FABRIKPROBE mit Zahlen.

M4 Plan
- Mengengerüst je Kategorie und Anteil von Opus und Haiku.
- Kapazität ist das Minimum aus erreichter Parallelität, Maschinenlast und Nutzungskontingent je Limitfenster. Das Kontingent schätzt du aus den Tokens je Agent der Fabrikprobe, mit Spanne; dazu 20 % Puffer.
- Lege den Zielfaktor F zwischen 10 und 100 fest und begründe ihn. Trägt eine Nacht nicht einmal 10, sagst du das, planst mehrere Nächte und nimmst den Grund in die Annahmen auf.
- Wellenplan mit kritischem Pfad: zuerst der Durchstich – eine vollständige Runde in allen drei Modi mit wenig Inhalt –, dann die Breite.
- Betriebsort: Standard ist die Cloud. Zeigt das LAGEBILD, dass sie die Nacht nicht trägt, schreibst du den Master-Prompt für den eigenen Rechner und machst das zur Annahme.
- Ausgang: PLAN.

M5 Schreiben: Master-Prompt und Startpaket nach §8.
M6 Prüfen: nach §9, höchstens drei Runden.
M7 Übergeben: nach §12.

## 8. BAUPLAN DES MASTER-PROMPTS
8.1 Form
- Deutsch, ruhig und präzise, ohne Druck durch Großbuchstaben; jede Regel genau einmal; Platzhalter nur in den Einstellungen; Beispiele als Illustration gekennzeichnet und vielfältig.
- Ein einziger Kopierblock ohne verschachtelte Codeblöcke. Das Auslösewort für die Workflow-Automatik steht nirgends darin, auch nicht als Beispiel.
- Der Master-Prompt steht für sich allein: Er verweist nie auf diesen Meta-Prompt, und jede Regel, die er braucht, steht in ihm ausformuliert.
- Reihenfolgen stehen als Ablauf, nicht als bedingtes Verbot nach dem Muster „nicht …, bis …“; als Verbot steht nur, was die ganze Nacht gilt. Warum: Der Sicherheitsfilter liest Verbote aus dem Gespräch als bindend, und nur ein Mensch hebt sie auf – auch wenn der Lauf die Bedingung längst für erfüllt hält.
- Opus bekommt Ziele, Gründe und Freiraum; Haiku bekommt exakte Formate, Schemas und kleine Pakete.
- So lang wie nötig: Jede Zeile verbessert das Ergebnis der Nacht.

8.2 Abschnitte. Die Nummern 2.2 und 6 sind feste Verweise, denn die Startanleitung nennt sie.
- 0 EINSTELLUNGEN: alle veränderlichen Werte mit Standard – Modelle und Denkstufen als feste Zeilen, Parallelität, Wellengröße, Zielfaktor F, Nachtfenster und Morgenbericht, Branches, Planungsordner.
- 1 AUSGANGSLAGE UND NORDSTERN: Nordstern als erreichter Zustand in einem Satz.
- 2 START UND AUTONOMIE:
  - 2.1 Der Lauf beginnt, sobald eine Nachricht des Nutzers das Startwort enthält, auch die Nachricht, die den Prompt bringt.
  - 2.2 Startbedingungen B-01 und folgende, je mit Prüfweg, einmal beim Start geprüft. Sind alle erfüllt, meldet der Lauf das in einer Zeile und beginnt. Ist eine offen, meldet er den genauen Befund im Gespräch und unter FÜR DEN NUTZER und beendet den Zug; das Startwort stößt die Prüfung später erneut an. B-02 lautet „Finalisierungs-Lauf fertig“, abgeleitet aus dessen eigenen Endkriterien und ohne Tag prüfbar. Weitere Bedingungen mindestens: Modellsperre wirkt und Werkzeugkette ist bereit oder installierbar; kein anderer Lauf integriert gerade in main.
  - 2.3 Startschritte: Archiv-Branch sichern; Arbeitsbranch bollwerk aus dem aktuellen origin/main anlegen und mit bollwerk-plan zusammenführen; Messbasis und Vorher-Galerie neu erheben; Lichtungsaufgaben aus dem Meta-Lauf zuerst.
  - 2.4 Autonomie.
- 3 GRENZEN UND VORRANG: Git, Netzwerk, Technikstapel, Inhaltsregeln, Daten, Zuständigkeit gegenüber anderen Läufen, Vorrangordnung.
- 4 KERN: nummerierte Kern-Aussagen aus Kanon und SPIELKERN, mit Version und Änderungsverfahren.
- 5 ROLLEN, MODELLE UND VARIANTENFABRIK: Opus 5.5 für Urteil, Kernsysteme, Integration und Abnahme; Opus-5.5-Agenten nur für Pakete der Stufe 3 und unabhängige Prüfungen; Haiku 5.5 für alles Übrige. Jeder Agentenauftrag nennt Modell und Denkstufe, die Stufe je Rolle aus der Fabrikprobe.
- 6 ZIELFORMEL: Z-Kriterien mit Methode, Schwelle und Beleg, gegliedert in SPIEL, UMFANG, DESIGN, MODI, BESTAND, ARCHIV und MAIN; Abschlussregel; Zielsatz für /goal. Am Ende meldet der Lauf jedes Z-Kriterium mit einer Belegzeile im Gespräch, und der Zielsatz verweist auf diese Meldung. Warum: /goal liest nur das Gespräch. MAIN umfasst mindestens: alle übrigen Z-Kriterien belegt, neuester Stand von main zusammengeführt und erneut geprüft, Secret-Scan leer, Push als Fast-Forward ohne Force, main lokal gleich origin/main, vorhandene CI grün, soweit ihr Status lesbar ist. Ist main geschützt, endet MAIN mit einem fertigen Pull-Request, und das Zusammenführen steht unter FÜR DEN NUTZER.
- 7 PRÜFMAUER · 8 PHASEN mit Toren, Durchstich zuerst · 9 REGELKREISE mit Höchstzahlen · 10 NEBELKARTE mit Frühwarnzeichen und Gegenmaßnahme · 11 GEDÄCHTNIS, STATUS UND BERICHTE · 12 ÜBERGABE AUF MAIN · 13 START.

8.3 Umfang (Teil UMFANG in Abschnitt 6)
- Gezählt werden Einheiten je Kategorie, etwa Orte und Unterorte, interaktive Gegenstände, Ereignisse, Entscheidungen mit Optionen, sichtbare Aktionen der Figur, Würfelproben mit Ausgängen, Hinweise und Fehlfährten, Erzähler- und Dialogbausteine, Bot-Charaktere und Abendvarianten. Die endgültige Liste legst du in M1 fest.
- Eine Einheit zählt nur, wenn sie die Prüfmauer passiert hat, in Simulationen tatsächlich erreicht wird, kein Beinahe-Duplikat ist und zum Kanon passt.
- Der Zuwachsfaktor ist das geometrische Mittel der Faktoren je Kategorie, mit einer Untergrenze je Kernkategorie. Warum: So lässt er sich nicht durch das Aufblähen einer einzigen Kategorie erreichen.
- Dazu Spieltiefe aus Simulationen: unterscheidbare Partieverläufe, sinnvolle Entscheidungen je Partie, Überschneidung zweier Zufallspartien.
- Basis ist der Stand beim Start des Nachtlaufs, gemessen mit demselben Messskript.

8.4 Design
- Vorher-nachher-Bilder jedes Bildschirms als Handy hoch, Handy quer und Tablet.
- Maße, kalibriert in M1: Kontrast, Tippflächen, Abstands- und Schriftraster, Einhaltung der Palette, Bildzeit und Ruckler, Anteil ersetzter Platzhalter.
- Blindvergleich: Mehrere Richter bewerten Paare aus alt und neu, ohne die Herkunft zu kennen; die Schwelle legst du in M1 fest.
- Der gewählte Look kommt aus Kanon und Planungsordnern; ist er nicht eindeutig, wird er Annahme.
- Bilder entstehen in der Nacht nur mit Mitteln ohne fremde Dienste. Was ein Mensch mit einem Bildgenerator erzeugen müsste, landet als fertige Bildbeschreibung unter FÜR DEN NUTZER.

8.5 Prüfmauer – Mindestringe, billig vor teuer
1. Form: Schema, Pflichtfelder, Kennungen, Länge, Sprache, keine Platzhalter.
2. Regeln: Inhaltsregeln, Namensbalance, Spoiler- und Geheimnisschutz, keine echten Personen oder Marken.
3. Kanon und Logik: kein Widerspruch zum Kanon; jede Täter-Fassung bleibt lösbar, und die Lösungsquote der Detektiv-Bots bleibt im Zielband aus M2.
4. Technik: Bauen, Analysieren, Tests, Bildschirmbilder, Leistungs- und Größenbudget, keine Verbindung zu fremden Servern.
5. Spiel: in Simulationen erreichbar, keine Sackgasse, Balance im Band, alle drei Modi.
6. Neuheit: kein Beinahe-Duplikat einer vorhandenen Einheit.
7. Qualität: Rubrik mit mehreren unabhängigen Richtern; weichen sie stark ab, entscheidet Opus.
8. Stichprobe: Je Welle werden zufällig mindestens 10 % und mindestens 20 Einheiten von Opus geprüft, bei großen Wellen von einem frischen Opus-5.5-Agenten. Liegt die Fehlerquote über der Schwelle, geht die ganze Welle zurück.
Jeder Ring hat Messgröße, Schwelle, Werkzeug und eine Statistik je Welle. Teure Ringe laufen gebündelt je Welle, nicht je Variante. Warum: Die Cloud-Maschine hat wenige Kerne.

8.6 Variantenfabrik
- Slots kommen aus dem Plan; je Slot entstehen mehrere Varianten mit unterschiedlicher Vorgabe; die Auswahl folgt einer dokumentierten Regel.
- Jeder Agent schreibt seine Variante in einen eigenen Pfad des Ablageordners, den der Plan festlegt; über das Schema im agent()-Aufruf gibt er nur Kennung, Pfad, Status und Selbstprüfung zurück. Warum: Was ein Workflow zurückgibt, landet im Kontext von Opus, und der muss zwölf Stunden reichen.
- Agenten führen weder Git-Befehle noch Installationen oder Netzwerkzugriffe aus; sie rufen nur die Werkzeuge und Prüfskripte auf, die ihr Paket nennt. Warum: Der Sicherheitsfilter zählt Sperren, und nach zu vielen fragt er wieder – nachts antwortet niemand.
- Abgelehnte Varianten bekommen höchstens zwei Nachbesserungsrunden mit Befund; danach übernimmt Opus oder schneidet den Slot neu.
- Agenten einer Welle teilen Modell, Denkstufe, Werkzeuge und Schema. Warum: So lesen sie den Zwischenspeicher der ersten Anfrage mit und sparen Kontingent.
- Angenommene Varianten führt ein Skript ins Spiel zusammen, das Opus in der Hauptsitzung ausführt; von Hand führt Opus nichts zusammen. Das Register ist eine kompakte Tabelle mit Kennung, Slot, Status, Ringergebnissen und Punkten; Opus liest Statistiken und Stichproben, keine Rohtexte.
- Paket-Bauplan für Haiku in fester Reihenfolge: Kopfzeile (Kennung · Rolle · Modell · Denkstufe · Welle · Kern-Version · Umfang · Schwierigkeit 1 bis 3) · Rollenbriefing · Aufgabe in einem Satz · das Projekt in fünf Sätzen, wortgleich in jedem Paket · Kern-Auszug · Qualitätsmaßstab · Grenzen · nummerierte Schritte mit Mengen · Muster als Illustration · Ausgabeschema · Selbstprüfung · als letzte Zeile === ENDE [Kennung] · BEREIT ZUR RÜCKGABE ===. Bei Schema-Ausgabe ersetzt ein Pflichtfeld status mit dem Wert BEREIT die Endmarke. Pakete der Stufe 3 gehen an Opus.
- Zufall nur über Startwerte, die das Skript als Eingabe bekommt. Warum: Workflow-Skripte erlauben weder Zeitstempel noch Zufallszahlen.

8.7 Betrieb in der Nacht
- Wellen mit höchstens 1.000 Agenten je Workflow-Lauf, so bemessen, dass ein hängender Agent höchstens eine Welle kostet.
- Nutzungslimit: Je nach Befund aus M0 wartet die Sitzung und setzt nach dem Zurücksetzen fort, oder sie steht bis zur nächsten Nachricht. Für beide Fälle läuft die wertvollste Arbeit zuerst, jeder gesicherte Stand ist brauchbar, und jede Welle ist so geschnitten, dass sie höchstens zwei Limitfenster braucht. Steht der Lauf, steht unter FÜR DEN NUTZER, welche Nachricht ihn fortsetzt.
- Solange Hintergrundarbeit läuft, beendet der Lauf seinen Zug nicht: Er arbeitet an Unabhängigem weiter oder wartet mit Prüfbefehlen von höchstens zehn Minuten. Eine Welle, die länger als das Dreifache ihrer geplanten Dauer läuft, bricht er ab und wertet das Teilergebnis aus.
- Nach jeder Pause, jedem Limit und jedem Neuaufbau der Maschine prüft der Lauf zuerst Branch, Werkzeugkette und offene Wellen und startet Unvollständiges neu.
- Mindestens stündlich Commit und Push des Arbeitsbranches als Sicherung; jeder Commit baut und testet grün.
- Der Push auf main steht als beauftragter Schlussschritt im Ablauf: Opus führt ihn selbst in der Hauptsitzung aus, als Fast-Forward aus dem Arbeitsbranch, ohne Force, mit höchstens drei Anläufen; danach steht der Befund unter FÜR DEN NUTZER. Warum: Im Auto-Modus gilt der Auftrag eines Workflow-Skripts nicht als Auftrag des Nutzers.
- Vor dem Schlussschritt holt der Lauf den neuesten Stand von main, führt ihn zusammen und lässt die ganze Prüfmauer erneut laufen.
- Archiv als Branch archiv/vor-bollwerk. Tags nur, wenn M0 einen erlaubten Weg belegt; sonst als fertiger Befehl unter FÜR DEN NUTZER.
- Gedächtnis in Dateien des Planungsordners: KERN, ABNAHME, PLAN, STATUS, ENTSCHEIDUNGSLOG, REGISTER, NACHTPROTOKOLL, FÜR DEN NUTZER. Nach jeder Kontextverdichtung liest der Lauf zuerst STATUS und KERN.
- Morgenbericht zur eingestellten Uhrzeit; danach arbeitet der Lauf weiter bis zum Ziel.

8.8 Startpaket
- Gebrauchsanleitung mit höchstens zehn Zeilen: Cloud-Umgebung mit Einrichtungsskript und Variablen, Modellsperre, Modus Auto, Denkstufe und Workflow-Automatik, Start mit dem Startwort, Zielsatz für /goal, Steuerung, ehrliche Erwartung. Pflichtpunkte darin:
  - Der Nachtlauf startet in einer neuen Sitzung, nie in dieser. Warum: Die Verbote des Meta-Laufs stehen hier im Gespräch und würden den Schlussschritt auf main sperren.
  - Die Sitzung startet auf einem Branch, der die Sperrdatei enthält – etwa bollwerk-plan, oder main nach einem Pull-Request mit der Sperrdatei.
  - Der Master-Prompt kommt als erste Nachricht ins Eingabefeld und wird nicht aus einer Datei gelesen. Warum: Nur so gilt der Schlussschritt auf main als Auftrag des Nutzers.
  - /goal folgt nach dem Master-Prompt, nie davor.
  - Der Zielsatz für /goal ist auch erfüllt, wenn der Lauf beim Start eine offene Startbedingung meldet.
  Das Auslösewort der Workflow-Automatik darf in der Gebrauchsanleitung stehen, aber nicht im Block.
- Einrichtungsskript der Cloud-Umgebung, in dieser Sitzung erprobt, mit gemessener Dauer. Ziel sind weniger als fünf Minuten; sonst steht die Folge für jeden Neuaufbau im LAGEBILD.
- Variablenblock der Cloud-Umgebung mit mindestens ANTHROPIC_MODEL=claude-opus-5-5, ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-5-5, ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-5-5, CLAUDE_CODE_SUBAGENT_MODEL=claude-haiku-5-5 und CLAUDE_CODE_WORKFLOW_MAX_CONCURRENT_AGENTS mit dem Wert aus M3. CLAUDE_CODE_EFFORT_LEVEL gehört nicht hinein, weil diese Variable die Denkstufe jedes Agenten überschreibt; die Denkstufe von Opus setzt die Gebrauchsanleitung mit /effort max in der Sitzung.
- Sperrdatei .claude/settings.json mit availableModels für claude-opus-5-5 und claude-haiku-5-5, dazu enforceAvailableModels, wenn die Dokumentation es in einer Projektdatei zulässt; vorhandene Einträge bleiben erhalten. Warum: Nur so ist die Modellsperre in der Cloud hart, und der Sicherheitsfilter läuft dann auf dem Sitzungsmodell. Ob die Datei zusätzlich workflowSizeGuideline und Erlaubnisregeln für die Befehle der Agenten trägt, entscheidest du; beides wirkt auch in lokalen Sitzungen im Repo. Ob die Datei nach der Nacht auf main bleibt, ist eine Annahme.

## 9. PRÜFUNG DES MASTER-PROMPTS
- Rubrik mit 0, 1 oder 2 Punkten je Prüfung: P1 Ziel · P2 Kontext · P3 Ende (Kriterien mit Methode, Schwelle und Beleg) · P4 Steuerung (Regelkreise mit Ausgang und Höchstzahl) · P5 Widerspruchsfreiheit · P6 Grenzen konkret und abhakbar · P7 Umgebungstreue (nur Funktionen, die die gewählte Umgebung wirklich hat; Unsicheres markiert) · P8 Ausführbarkeit ohne Rückfrage · P9 Robustheit gegen frühen Stopp, Endlosschleife, Abdriften und Schönrechnen · P10 Dichte · P11 Modellgerechtheit · P12 Startbarkeit · P13 Modellreinheit (nur Opus 5.5 und Haiku 5.5, jeder Agentenauftrag mit Modell). Freigabe ab 23 von 26 Punkten ohne eine 0.
- Die Rubrik bewertet ein frischer Opus-5.5-Agent, der die Entstehung nicht gesehen hat. Er bekommt die Rubrik, Master-Prompt, Startpaket, LAGEBILD sowie §1, §3, §8 und §11 dieses Auftrags.
- Proben, jede mit Befund und Folge im PRUEFBERICHT:
  1. Probelauf: Was tut der Nachtlauf in seinen ersten drei Schritten nach START BOLLWERK?
  2. Rotes Team: Drei Haiku-Angreifer suchen unabhängig, wie der Nachtlauf abkürzen, Einheiten doppelt zählen, Tests umgehen oder Schwellen still senken könnte. Jede gefundene Lücke wird geschlossen.
  3. Stopp-Probe: Wo könnte der Lauf zu früh aufhören oder auf eine Antwort warten, die nie kommt?
  4. Schleifen-Probe: Hat jeder Kreis eine Höchstzahl?
  5. Drift-Probe: Was hält den Lauf nach zwölf Stunden auf Kurs?
  6. Fremdleser-Probe: Versteht ein Mensch ohne Vorwissen, was der Prompt will?
  7. Umgebungs-Probe: Jede genannte Funktion gegen LAGEBILD und §11.
  8. Modell-Probe: Prompt und Startpaket nach Modellnamen durchsuchen; erlaubt sind nur Opus 5.5 und Haiku 5.5.
  9. Kaltstart-Probe: Ein frischer Opus-5.5-Agent bekommt nur den Master-Prompt und einen Wegwerf-Worktree von bollwerk-plan, so wie ihn der Nachtlauf vorfindet. Er spielt START BOLLWERK zweimal als Trockenlauf durch, einmal mit offener B-02 und einmal mit unterstellt erfüllter B-02, jeweils bis zum ersten Phasentor: nur lesende Befehle, keine Installation, keine Agenten oder Workflows, teure Schritte nur beschrieben, höchstens 20 Minuten je Durchgang. Er listet jede Stelle, an der er hätte fragen müssen. Bestanden bei null blockierenden Fragen.
  10. Verdichtungs-Probe: Du legst STATUS, KERN und PLAN eines gedachten Zwischenstands um 03:00 Uhr an. Ein frischer Haiku-Agent bekommt nur diese drei Dateien und muss sagen, wo der Lauf steht und was als Nächstes kommt; bestanden, wenn beides mit dem Plan übereinstimmt.
- Höchstens drei Prüfrunden; danach lieferst du mit offen benannter Schwäche.

## 10. ABNAHME DES META-LAUFS
Lege die Kriterien in M0 als ABNAHME-META im Planungsordner an und hake nur mit Beleg ab.
- M-01 Lage: Alle acht Fragen aus M0 sind mit Beleg beantwortet oder als nicht klärbar markiert, je mit Folge für die Nacht.
- M-02 Läufe: B-02 ist aus den Endkriterien des Finalisierungs-Laufs abgeleitet und ohne Tag prüfbar; Stand und erwarteter Abschluss dieses Laufs sowie alle weiteren Läufe mit ihrer Zuständigkeit sind dokumentiert.
- M-03 Messbasis: Das Messskript liefert in zwei Durchläufen dieselben Zahlen, und eine Gegenzählung von 20 Einheiten durch einen Haiku-Messer stimmt mit ihm überein; Basiswerte heute und Hochrechnung nach der Finalisierung liegen mit Spanne vor.
- M-04 Bestand: Jedes Spielteil hat Fundstelle und Schicksal mit Grund.
- M-05 Spielkern: Kern-Aussagen zu Runde, Entscheidungen, sichtbaren Aktionen, Spielwürfel, Party, Solo, WLAN und Geheimnisschutz liegen vor; Würfel, Dauer und Lösbarkeit sind simuliert, mit Zahlen; das Verhältnis von Entscheidung und Würfel steht als Annahme.
- M-06 Design: Das Bildverfahren ist an mindestens drei Bildschirmen in allen drei Ansichten erprobt; die Designmaße haben Basiswerte. Das Richterverfahren ist kalibriert: Bei Kontrollpaaren aus Original und absichtlich verschlechterter Fassung wählen die Richter in mindestens 90 % das Original, und drei Richter stimmen in mindestens 80 % überein.
- M-07 Fabrik: Mindestens drei Slot-Arten liefen in echter Probe durch alle Ringe; Parallelität, Annahmequoten, Dauern, Tokens je Denkstufe oder ihre Schätzung und Fehlerbilder sind erfasst; Briefings und Schemas sind danach geschärft.
- M-08 Plan: Mengengerüst, Kapazitätsrechnung nach M4 mit 20 % Puffer, Zielfaktor F mit Begründung, Wellenplan mit Durchstich und kritischem Pfad, Betriebsort.
- M-09 Master-Prompt: vollständig nach §8; ein Block ohne verschachtelte Codeblöcke; kein Auslösewort; kein Verweis auf diesen Meta-Prompt; jeder Agentenauftrag mit Modell und Denkstufe; die Verweise auf 2.2 B-02 und auf UMFANG in Abschnitt 6 stimmen.
- M-10 Prüfung: Rubrik mindestens 23 von 26 ohne 0 durch einen frischen Opus-5.5-Agenten; alle zehn Proben mit Befund und Folge im PRUEFBERICHT.
- M-11 Startpaket: Gebrauchsanleitung mit höchstens zehn Zeilen und allen Pflichtpunkten aus §8.8, erprobtes Einrichtungsskript mit Dauer, Variablenblock ohne CLAUDE_CODE_EFFORT_LEVEL, Sperrdatei, Zielsatz für /goal.
- M-12 Übergabe: bollwerk-plan ist gepusht und enthält gegenüber origin/main nur planung/bollwerk/ und die Sperrdatei, belegt durch git diff origin/main...bollwerk-plan; das Protokoll aller Pushes dieses Laufs nennt nur bollwerk-plan; Wegwerf-Worktrees sind entfernt; die letzte Nachricht folgt §12.
Abschlussregel: Erledigt ist, was mit Beleg abgehakt ist. Kriterien sinken nie still. Ist eines von M-01 bis M-08 unerreichbar, steht es mit Grund und bester Ersatzlösung in den Annahmen. M-09 bis M-11 haben keine Ersatzlösung. Für M-12 gibt es genau eine: Ist der Push nachweislich unmöglich, stehen Master-Prompt und Startpaket vollständig in der letzten Nachricht und der Grund unter FÜR DEN NUTZER.

## 11. BETRIEBSWISSEN
Stand 9. Oktober 2026, aus der offiziellen Claude-Code-Dokumentation. Prüfe Unsicheres dort nach und halte Abweichungen im LAGEBILD fest.
- Cloud-Sitzungen laufen auf einer frischen Ubuntu-Maschine mit etwa 4 Kernen, 16 GB Speicher und 30 GB Platte. Was das Repo braucht, ist nicht unbedingt vorinstalliert. Das Einrichtungsskript einer Cloud-Umgebung wird zwischengespeichert, wenn es in etwa fünf Minuten fertig ist.
- Eine Cloud-Sitzung mit genau einem Repo liest dessen .claude/settings.json, aber keine Benutzer- oder lokalen Einstellungen; /config setzt dort keine Werte. Einstellungen kommen über Variablen der Cloud-Umgebung oder über diese Datei. Eine im Lauf angelegte oder geänderte Einstellungsdatei lädt Claude Code nach; nur wenige Schlüssel wie das Startmodell wirken erst in einer neuen Sitzung. Den Auto-Modus wählt man im Modus-Menü der Sitzung; eine Projektdatei kann ihn nicht setzen.
- Der Git-Proxy der Cloud lehnt das Pushen von Tags und das Löschen von Branches ab. Branch-Pushes, auch auf main, lässt er zu; Schutzregeln auf GitHub gelten zusätzlich.
- Ein Befehl läuft bis zu zehn Minuten im Vordergrund, danach bis zu 30 weitere Minuten im Hintergrund.
- Ohne Aktivität pausiert die Maschine nach wenigen Minuten. Wird sie neu aufgebaut, sind laufende Agenten und Befehle verloren. Die Ergebnisse fertiger Workflow-Agenten bleiben mit dem Verlauf erhalten, und ein Neustart des Workflows liefert sie wieder.
- Workflows sind Skripte mit agent(), pipeline(), parallel(), phase() und log(): höchstens 1.000 Agenten je Lauf und 4.096 Einträge je pipeline() oder parallel(). Gleichzeitig laufen standardmäßig bis zu 16 Agenten, auf Maschinen mit wenigen Kernen weniger; CLAUDE_CODE_WORKFLOW_MAX_CONCURRENT_AGENTS setzt einen Wert von 1 bis 256. Im Skript gibt es weder Zeitstempel noch Zufallszahlen. Von selbst hält ein Workflow nur für Rückfragen zu Berechtigungen und für das Warten auf ein Limit an. Was er zurückgibt, landet im Kontext der Hauptsitzung. Ein Agent ohne Ausgabe startet bis zu fünfmal neu; stallMs im agent()-Aufruf verlängert das Zeitfenster. Scheitert ein Agent, wiederholt ein Neustart des Workflows ihn und alle nach ihm gestarteten.
- Modellwahl für Agenten: zuerst die Angabe im Aufruf, dann die Agentendefinition, dann CLAUDE_CODE_SUBAGENT_MODEL, sonst das Sitzungsmodell. Ein Modell außerhalb von availableModels wird ersetzt, und die Fortschrittsansicht warnt. Die eingebauten Erkundungs- und Planungsagenten laufen auf dem Hauptmodell, auch wenn CLAUDE_CODE_SUBAGENT_MODEL gesetzt ist.
- Denkstufen: Opus 5.5 und Haiku 5.5 kennen low, medium, high, xhigh und max, Standard medium. Ein Agent ohne eigene Angabe übernimmt die Denkstufe der Sitzung; eine Angabe je Agent geht ihr vor. CLAUDE_CODE_EFFORT_LEVEL überschreibt dagegen jede Angabe je Agent.
- Die Richtgröße für Workflows ist nur ein Rat an Claude, Standard unter zehn Agenten; ein Prompt, der eine andere Größe verlangt, geht vor. In der Cloud lässt sie sich nur über den Schlüssel workflowSizeGuideline in .claude/settings.json setzen.
- Im Auto-Modus mit eingeschalteter Workflow-Automatik startet jeder Workflow ohne Rückfrage; ohne sie fragt der erste Start, in anderen Modi jeder. Ein Nachtlauf braucht deshalb den Auto-Modus mit Workflow-Automatik.
- Der Auto-Modus erlaubt Pushes auf jeden Branch des Repos, auch auf main. Er sperrt Force-Push und das Zusammenführen eines Pull-Requests ohne menschliche Freigabe. Nach drei Sperren in Folge oder zwanzig insgesamt fragt er wieder. Was ein Workflow-Skript einem Agenten aufträgt, gilt ihm nicht als Auftrag des Nutzers.
- /goal: Setzen startet sofort einen Zug mit der Bedingung als Auftrag; der Prompt muss deshalb vorher im Gespräch stehen. Nach jedem Zug prüft das Modell hinter dem Alias haiku die Bedingung, nur anhand des Gesprächs und ohne eigene Befehle. Hält es die Bedingung für unmöglich, verwirft es das Ziel. Läuft am Zugende Hintergrundarbeit, entfällt die Prüfung; ist die Arbeit fertig, beginnt von selbst ein neuer Zug. Nach 30 Minuten Hintergrundarbeit kommt eine Nachfrage, dann nach einer weiteren Stunde und danach alle zwei Stunden, ohne neue Nutzernachricht höchstens drei.
- Nutzungslimit: In interaktiven Sitzungen mit claude.ai-Abo wartet Claude Code standardmäßig und setzt nach dem Zurücksetzen selbst fort, höchstens zweimal in Folge und nur, wenn das Zurücksetzen weniger als 24 Stunden entfernt ist; die zugehörige Einstellung lässt sich nicht aus dem Repo setzen. Ob eine Cloud-Sitzung dazu zählt, sagt die Dokumentation nicht ausdrücklich. Ein Workflow wartet dann mit, höchstens zweimal; beim dritten Limit scheitern seine wartenden Agenten. /goal pausiert und setzt mit der Sitzung fort.
- Eine harte Modellsperre gibt es in der Cloud nur über availableModels in .claude/settings.json des Repos. Einträge sind Familien wie haiku, Versionspräfixe wie claude-haiku-5-5 oder volle Kennungen; ein Versionspräfix beschränkt seine Familie auf diese Version. Die Auswahl „Default“ bleibt ohne enforceAvailableModels unberührt; ANTHROPIC_MODEL legt das Sitzungsmodell trotzdem fest. Schließt die Liste das Standardmodell des Sicherheitsfilters aus, läuft er auf dem Sitzungsmodell. ANTHROPIC_DEFAULT_HAIKU_MODEL legt fest, wohin der Alias haiku, die Prüfung von /goal und die Hintergrundfunktionen zeigen.

## 12. GEDÄCHTNIS, STATUS, ÜBERGABE
- Planungsordner planung/bollwerk/: META-AUFTRAG, LAGEBILD, BESTAND, MESSBASIS mit Messskript, SPIELKERN, FABRIKPROBE, PLAN, ENTSCHEIDUNGSLOG, ANNAHMEN, ABNAHME-META, PRUEFBERICHT, MASTER-PROMPT, STARTPAKET, FÜR DEN NUTZER, STATUS; Probeskripte als Referenz unter planung/bollwerk/proben/.
- STATUS hält Phase, abgehakte Kriterien und nächsten Schritt. Nach einer Kontextverdichtung liest du zuerst META-AUFTRAG, STATUS und ABNAHME-META.
- Jede Antwort beginnt mit: STAND · Meta-Phase M[n] von M7 · Abnahme [a] von 12 · Agenten aktiv [x] · nächster Schritt: […]
- Die letzte Nachricht enthält in dieser Reihenfolge:
  1. Annahmen, nummeriert: Entscheidung · Standard · Folge, wenn der Nutzer sie kippt.
  2. Prognose: erwarteter Zuwachsfaktor mit Spanne, erwartete Dauer der Nacht, die drei größten Risiken.
  3. Den Master-Prompt als einen Kopierblock.
  4. Das Startpaket: Gebrauchsanleitung, Einrichtungsskript, Variablenblock, Sperrdatei.
  5. Was nur Menschen tun können.
  6. Den Stand von M-01 bis M-12 mit je einem Beleg.
  Die letzte Zeile lautet: BEREIT FÜR START BOLLWERK
- Danach bleibt die Sitzung offen. Kippt der Nutzer eine Annahme, arbeitest du sie ein, prüfst die betroffenen Teile nach §9 und übergibst neu.

## 13. START
Beginne sofort mit M0 in der dort genannten Reihenfolge: Statuszeile, Branch bollwerk-plan, META-AUFTRAG, Sperrdatei, ABNAHME-META und STATUS, Modellprobe, Commit und Push, dann das Lagebild. Danach arbeitest du alle Phasen ohne Rückfragen bis zur Übergabe ab.
