# VORLAGE PHASE-ROLLE · v1 · Karten einer Rolle in einer Phase

## AUFGABE
Schreibe für Rolle {{ROLLE}} ({{ROLLENNAME}}) in Phase {{PHASE}} die drei Gesprächsauftragskarten, alle {{N_SPIEGEL}} Spiegelstück-Karten ({{SPIEGEL_LISTE}}), die Entscheidungskarte und, falls im Auszug vorhanden, die Meldekarte.

## STIL
- Du-Form an die spielende Person, kurze klare Sätze, die Sprechweise der Rolle aus STAMM in den eigenen Worten der Karten spürbar.
- Gesprächsauftrag (50–90 Wörter): Kopf „AUFTRAG <Kennung> · Phase {{PHASE}} · Rolle {{ROLLE}} {{ROLLENNAME}}“. Dann „WENN du mit <Name> (Rolle NN) sprichst UND <Bedingung>, DANN erfährst du <Thema der Antwort, ohne die Antwort selbst>.“ Die Frage steht wörtlich in „…“. Dazu ein Satz „Achte darauf: …“. Hat der Auftrag ein Ersatzziel, folgt in derselben Karte: „[NUR WENN ROLLE NN NICHT BESETZT] Sprich stattdessen mit <Ersatzname> (Rolle MM) UND <Ersatz-Bedingung> …“ mit der Ersatz-Frage wörtlich, dann „[ENDE BEDINGUNG]“.
- Spiegelstück (40–80 Wörter): Kopf „SPIEGEL <Kennung> · Phase {{PHASE}} · Rolle {{ROLLE}} {{ROLLENNAME}}“. Dann „WENN <Name> (Rolle NN) dich anspricht UND <Bedingung>, DANN sagst du: „<Antwort wörtlich>“.“ Je nach Antwortart folgt genau einer dieser Sätze: wahr → „Du darfst hier nicht lügen.“ · ausweichend → „Du weichst aus, lügst aber nicht.“ · gelogen → „Du darfst hier lügen. Gegenbeweis: <Gegenbeweis aus deinem Datensatz LÜGE>. Wird er dir vorgelegt, gibst du zu, was er zeigt.“
- Ersatzfall-Spiegelstück: Bist du in einem Gespräch das Ersatzziel, beginnt die Karte mit der Zeile „[NUR WENN ROLLE NN NICHT BESETZT]“ (NN = reguläres Ziel) und endet mit „[ENDE BEDINGUNG]“. Du verwendest die Ersatz-Felder.
- Entscheidungskarte (120–200 Wörter): Kopf „ENTSCHEIDUNG E{{PHASE}}-NN“, „Lage:“ (2–3 Sätze), dann jede Option als „Option k · <Kurzname>: <Text> → Folge: <Folge wörtlich nach dem Datensatz>“.
- Meldekarte: Kopf „MELDEKARTE · Phase {{PHASE}} · Rolle {{ROLLE}}“, dann „In der Lagerunde liest du laut vor:“ und der Text wörtlich, dann „Diese Karte ist Pflicht.“

## VERBOTE
- Fragen und Antworten in „…“ übernimmst du wortgleich aus dem Auszug. Du fügst keine Tatsachen hinzu.
- Auf einer Auftragskarte steht nie die Antwort, nur das Thema.
- Keine weiteren Karten, Gespräche, Personen oder Uhrzeiten erfinden.
- Lügen nur dort, wo die Antwortart „gelogen“ ist.

## SCHRITTE
1. Lies alle G-Datensätze im Auszug. Die mit „Von: {{ROLLE}}“ sind deine drei Aufträge. Die mit „Ziel: {{ROLLE}}“ oder „Ersatz: {{ROLLE}}“ sind deine Spiegelstücke.
2. Schreibe je Auftrag eine Auftragskarte. Nutze Bedingung und Frage. Das Thema der Antwort leitest du aus dem zugehörigen Hinweis (H-…) ab, ohne seinen Inhalt zu verraten.
3. Schreibe je Spiegelstück eine Spiegelkarte. Ist {{ROLLE}} das reguläre Ziel, nutzt du Bedingung, Frage, Antwort und Antwortart. Ist {{ROLLE}} das Ersatzziel, nutzt du die Ersatz-Felder und setzt die Besetzungsbedingung.
4. Schreibe die Entscheidungskarte aus dem E-Datensatz. Fehlt er im Auszug, schreibe „ENTSCHEIDUNGSKARTE: fehlt im Auszug“ und eine OFFENE FRAGE.
5. Schreibe die Meldekarte, wenn ein MK-Datensatz im Auszug steht; sonst „MELDEKARTE: keine“.
6. Zähle, fülle die Selbstprüfung aus, setze die Endmarke.

## MUSTER
M-07, M-08, M-09, M-10, M-20

## FORMULAR
    KENNUNG: {{ID}}
    ROLLE: {{ROLLE}} · {{ROLLENNAME}} · Phase {{PHASE}}
    AUFTRÄGE:
    [A1] <Karte>
    [A2] <Karte>
    [A3] <Karte>
    SPIEGELSTÜCKE:
    [S1] <Karte>
    … bis [S{{N_SPIEGEL}}]
    ENTSCHEIDUNGSKARTE:
    <Karte>
    MELDEKARTE:
    <Karte oder „keine“>
    OFFENE FRAGEN: …

## SELBSTPRUEFUNG
    SELBSTPRÜFUNG:
    - Auftragskarten: [Zahl] (Soll 3)
    - Spiegelkarten: [Zahl] (Soll {{N_SPIEGEL}}), davon Ersatzfälle mit Besetzungsbedingung: [Zahl]
    - Jede Frage und jede Antwort wortgleich aus dem Auszug: ja/nein
    - Keine Auftragskarte verrät die Antwort: ja/nein
    - Wortspannen eingehalten (Auftrag 50–90, Spiegel 40–80, Entscheidung 120–200): ja/nein
    - Kein Alkohol, kein Siezen, keine Klischees, keine Platzhalter: ja/nein
    - Offene Fragen: [Anzahl]
