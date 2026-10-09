HEAD e95840f

# Gegenprüfung Inhalt, Runde 19 (Auftrag A-702q, ID gegenpruefer_inhalt_19)

Geprüfter Stand: `HEAD e95840f`, nach `git merge --ff-only nachtlauf/burgstadt` (d92a675..e95840f, Fast-Forward). Worktree sauber. Keine Daten geändert, kein Commit, kein Push, kein Build. Durch `dart pub get --offline` entstand nur der ignorierte Ordner `packages/burgstadt_core/.dart_tool/`. Hilfsdateien liegen im Scratchpad-Unterordner `gegenpruefer_inhalt_19`.

## 1. Befundübersicht

| Nr | Schwere | Thema | Ort |
|---|---|---|---|
| M1 | mittel | R04 zeigt im Bild keinen Strickpullover (Kanontreu, Punkt 15) | `figuren_lager.dart`, `karten.json` (R04) |
| M2 | mittel | Eigentumsmarke mit bosnischem Nachnamen als Verdachtsindiz gegen R01 (Grenzfall Leitplanke, widerspricht E43/E44 mit neuem Grund) | Stablampe BSO-03, H-28, GL-19, D1-1 |
| G1 | gering | „Schatten im Nebel“ im Hof-Zitat, Zusammenspiel mit K-002 | R20-ÖFFENTLICH |
| G2 | gering | Wortwahl „Herkunft“ für Wachs und Schrei | `faehigkeiten.json` (R17, R01) |
| G3 | gering | „Burgweg“ für zwei verschiedene Stellen | K-002, BSO-11, H-02 |
| G4 | gering | Oberfläche „Klassische Fälle“ mit Gift- und Todestexten (außerhalb Burgstadt) | `lib/l10n/app_de.arb` |

Hoch: 0 · Mittel: 2 · Gering: 4

## 2. Befunde im Einzelnen

### M1 · mittel · Kanontreu (Punkt 15) · R04 trägt im Bild keinen Strickpullover

- Datei und Stelle: `packages/pixel_engine/data/figuren/karten.json` (R04, `teile`); `packages/burgstadt_spiel/lib/src/figuren_lager.dart`, Zeilen 52 bis 69 (Zuordnung Kleidungstyp zu Teil); `packages/pixel_engine/lib/src/figur/teile_basis.dart`, Zeile 51.
- Zitat (Kanon, O): „olivgrüner grober Strickpullover über dem karierten Hemd“ (K2-ROLLEN-KERN, @R04-STAMM, Kleidung) und „olive green chunky knit sweater over a checked shirt“ (K9-LOOKBIBEL, @LF-R04).
- Befund: `rollen.json` hat für R04 richtig `oberteil.typ = pullover`. Die Zuordnung kennt für `pullover` aber keinen Körperteil. Nur bei darunterliegendem Hemd wird `oberteil-hemdkragen` ergänzt, eine Kragenscheibe von 0,06 × 0,025 × 0,06 in der Hemdfarbe. Die Karte von R04 hat deshalb als Oberteil nur diese Kragenscheibe. Der Strickpulli-Körperteil `oberteil-strickpulli-rolli` existiert und wird für Bewohner verwendet (`bewohner_karten.dart`, Zeilen 250 bis 251, `case 'Pullover'`), für R04 nicht. Das Aussehen aus Kanon v1.0 ist im Bild damit nicht umgesetzt. E41 hat nur die Typ-Angabe und den Wechsel auf `oberteil-hemdkragen` vorgenommen.
- Regel: Kanontreu, O-Aussehen R04; Auftrag Punkt 15.
- Vorschlag: `pullover` bei den Rollen-Figuren auf einen sichtbaren Strickteil abbilden (etwa `oberteil-strickpulli-rolli`), Karte R04 neu erzeugen, danach Sichtprüfung und `karten_test` wiederholen (Verwechslung mit R03 und anderen dunkelgrünen Figuren).

### M2 · mittel · Leitplanke, Grenzfall · Eigentumsmarke mit Nachnamen als Verdachtsindiz (widerspricht E43/E44)

- Datei und Stelle: K1-GRUNDWAHRHEIT.md, @BSO-03 [O] („Schwarze Stablampe mit Klebeband „HODŽIĆ VT · 3““); K3-HINWEISE.md, @H-28 [O]; K8-STILBLATT.md, @GL-19 [O]; K5-ENTSCHEIDUNGEN-DETEKTIV.md, @D1-1 [O] (Option A). Figur: K2-ROLLEN-KERN.md, @R01-STAMM [O] („Name: Adnan Hodžić … Wurzeln: bosnisch“); `packages/burgstadt_core/data/rollen/faehigkeiten.json`, rollen[0].beruf („Hodžić Veranstaltungstechnik“).
- Regel: „Herkunft ist nie Motiv, Indiz oder Pointe“ (Auftrag, Punkt 4). Nach dem Wortlaut ist die Regel nicht eindeutig verletzt, weil das Indiz ein Eigentumsmerkmal ist. Deshalb ist es ein Grenzfall.
- Abwägung E43/E44: „Der Name ist kein Herkunftsindiz; die Fährte läuft über das Gerät, nicht über die Herkunft.“ Neuer Grund, warum das nicht trägt: Die Zuordnung der Lampe zu Adnan läuft über den Nachnamen, aber nicht allein. Der Code-Zettel trägt Adnans Handschrift und ein „A.“ (K3-HINWEISE.md, @H-24 [O]). Eine Marke „A. · VT · 3“ würde dieselbe Zuordnung leisten. Damit ist der Nachname ein vermeidbares Herkunftsmerkmal in einem Verdachtsindiz gegen den Bewohner mit bosnischen Wurzeln. Das ist der Musterverdacht, den E38 bei den Familienfeldern beanstandet hat.
- Vorschlag: Die Eigentumsmarke ohne Nachnamen gestalten (etwa „A. · VT · 3“), in BSO-03, H-28 und GL-19 gleichzeitig. Die Lösungskette gehört zur Kanon-Verantwortung; die Änderung ist an die Kanon-Autoren zu melden.

### G1 · gering · Zusammenspiel mit Kanon v1.0 · „Schatten im Nebel“ im Hof-Zitat

- Datei und Stelle: K2-ROLLEN-13-20.md, @R20-ÖFFENTLICH [O], Comedy-Beteiligung: „flüstert eine Gruselgeschichte … in den Hof hinaus … („Schatten im Nebel. Physik.“)“.
- Regel: K1-GRUNDWAHRHEIT.md, @K-002 [O] (v1.0): „Über der Burg ist der Himmel klar“; Eisnebel nur im Tal und auf dem unteren Burgweg. E43 hat Nebel aus den Stadt- und Ortstexten entfernt, dieser O-Satz blieb. Es handelt sich um das Zitat einer Gruselgeschichte, nicht um eine Wetterangabe.
- Vorschlag: Begriffsersetzung im Overlay, ERSETZE-23 „Schatten im Nebel“ durch „Schatten im Qualm“ (passt zum Kamin-Qualm um 23:48 in LISTE-ZEITEN). Kanon-Datei unverändert.

### G2 · gering · Wortwahl · „Herkunft“ für Material und Schall

- Datei und Stelle: `packages/burgstadt_core/data/rollen/faehigkeiten.json`, rollen[16].sichtschicht.zeigt („Herkunft und Konsistenz“ beim Bienenwachs, sichtbar im Spiel); rollen[1].spoilerfrei_weil („die Herkunft des Schreis um Mitternacht“, Entwicklertext).
- Regel: Die Leitplanke bezieht sich auf Menschen. Hier nicht verletzt, aber das Wort in einer Leitplanke ist unglücklich gewählt.
- Vorschlag: „Art und Konsistenz“ bzw. „Quelle des Schreis“.

### G3 · gering · Begriff · „Burgweg“ für zwei Stellen

- Datei und Stelle: K1-GRUNDWAHRHEIT.md, @K-002 [O] („auf dem unteren Burgweg liegt dichter Eisnebel“); K1-GRUNDWAHRHEIT.md, @BSO-11 [O] und K3-HINWEISE.md, @H-02 [O] („draußen vor dem Tor auf dem Burgweg … unberührter Reif“).
- Befund: Kein Widerspruch (unten und vor dem Tor), aber derselbe Name für zwei Abschnitte der Zufahrt.
- Vorschlag: „Zufahrt“ bzw. „Vorplatz vor dem Burgtor“.

### G4 · gering · Bestand außerhalb des Burgstadt-Spiels · Gift- und Todestexte

- Datei und Stelle: `lib/l10n/app_de.arb` (`effect_poisoned` „Vergiftet“, `effect_poisoned_desc` „Ein Gegengift hilft.“, `item_antidote` „Gegengift“, `toast_died_me` „Du bist gestorben …“, `accuse_dead` „tot“); Verwendung in `lib/ui/overlays/accusation.dart`, Zeile 390, und `event_feed.dart`, Zeile 121. Erreichbar über „Klassische Fälle“ (`lib/burgstadt/burgstadt_seite.dart`).
- Befund: Keine Verstöße gegen die Wortliste, und im Burgstadt-Spiel nicht verwendet. Der Scanner-Bestand enthält die Texte trotzdem, und E14a bezeichnet die Klassischen Fälle als leitplankenkonform. Ob Gift- und Todesbegriffe dort bleiben sollen, ist eine Entscheidung des Nutzers.

## 3. Geprüft ohne Befund

- Scanner (`dart run bin/leitplanken.dart --burgstadt`, Dart 3.13.5 aus `/opt/flutter/bin`, nach `dart pub get --offline`): 119 Dateien geprüft, 0 Treffer, 0 Fehler, 0 Warnungen.
- Alkohol und Drogen: keine Begriffe außer Punsch. Jede Stelle mit Trinken ist alkoholfrei (ERSETZE-19 bis -21, K8 GL-14, FÜNF-SÄTZE, `erzaehler.json`). „Kater“ nur als Haustier (Ausnahmenliste). Gaststätten sind Teestube, Bäckerei, Pension.
- Blut, Verletzung, Tod: Der Burgwart hat Beule, „benommen“ und Kühlpack. Der Rohkanon „bewusstlos“ wird per ERSETZE-17 ersetzt. Keine Leiche, kein Blut in den Burgstadt-Texten.
- Hexen, Walpurgis, Teufel, Film-Vampire: nicht gefunden. Im Kanon bezeichnet „Gespenst“ das Laken-Kostüm, „Nebelriese“ die Legende.
- Herkunft: Die Familienfelder von R01, R05 bis R09, R12 bis R16, R18 und R19 sind per Overlay vollständig ersetzt. R20 mit „Masurische Seen“ bleibt bewusst (E38). In Stadt-, Haus- und Bewohnertexten keine Herkunft als Motiv oder Pointe, keine verallgemeinernden Aussagen über Alters-, Geschlechts- oder Herkunftsgruppen.
- Täterin: Die Kanon-Spuren (O) sind bewusst (E27, Auftrag 9a). In Stadt- und Bewohnertexten kein Hinweis auf R03; die einzige Nennung ist eine Beziehung im Beruf eines Bewohners.
- Overlay und Kanon v1.0 (Punkt 15): Die App lädt Kanon und ANPASSUNG zur Laufzeit (`lib/burgstadt/daten_laden.dart`); die ERSETZE-Regeln greifen. Geprüft wurden:
  - LISTE-ZEITEN: Das Overlay übernimmt alle neuen v1.0-Zeiten. Einzige Abweichung ist 00:01 zu „kurz nach Mitternacht“ (E44, bewusst, mit allen anderen Zeiten vereinbar).
  - Zeiten der Figuren (23:52 Merle und Adnan, 23:56, 00:01 bis 00:05) in OA-02, H-17, H-49, D2-2 und D3-2 sind konsistent.
  - Begriffe „Osterode“, „Harz“, „Oberharz“, „Brockengespenst“, „bewusstlos“, „Punsch“, „Nationalpark“ werden durch ERSETZE-03 bis -22 ersetzt; in den geprüften Texten keine Rohbegriffe.
  - Wetter: Stadt- und Ortstexte zeigen Frost und Raureif, Nebel nur im Tal und als Legende (`bewohner.json`, `haeuser.json`).
  - Stollen: BSO-01 und H-06 (Absatz ohne Stollen) passen zum Gitterrost in OA-02 und zu den gleichen Wanderstiefeln.
  - R03-Aussehen: `rollen.json` und `karten.json` stimmen mit K9 @LF-R03 und K2 @R03-STAMM überein (dunkelgrüne Zopf-Strickjacke, weiße Bluse, blaue Jeans, Wanderstiefel, Spange, Sommersprossen, kein Notizbuch).
  - L-Zeilen wurden nur zur Widerspruchsprüfung herangezogen und nicht zitiert; keine Widersprüche zu O-Zeilen.
- Plagiat: Stichwortprüfung auf bekannte Figuren, Titel, Zitate und Lieder (u. a. Dracula, Nosferatu, Holmes, Watson, Mausefalle, Cluedo, Hogwarts, Happy Birthday, Hoch soll er leben, Stille Nacht) ohne Treffer. Generische Wörter (Detektiv, Tatort, Kommissar, Inspektor als Polizeirang) sind Alltagsbegriffe.

## 4. Abwägungen E23 bis E44

- Bestätigt und nicht als Befund gezählt: E23 und E29 (benommen statt bewusstlos), E27 H1 (Fähigkeit von R03 nur für R03), E27 H2 (LISTE-ORTE nur Farbe), E27 G3 („Einspruch!“), E27 M2 (Teile im Code), E29 B3 (Stadtzeiten in LISTE-ZEITEN), E34 B-1 (Zeitangaben als Aussagen), E38 B1 (Familienfelder per Overlay), E38 B2 (Wanderstiefel aus zwei Teilen), E39 B-10 und B-11 (ungenutzte Teile), E41 (Feldkonflikt LISTE-ZEITEN), E44 (kurz nach Mitternacht).
- Widersprochen mit neuem Grund: E43 und E44 zu „HODŽIĆ VT · 3“ (M2).

## 5. Prüfumfang und Grenzen

- Zeilengenau gelesen: `nachtlauf/kanon/ANPASSUNG.md` (vollständig), `LEITPLANKEN-AUSNAHMEN.md`, `VERSION.md`, Entscheidungslog E23 bis E44, Scanner-Kern (`lib/src/pruef/leitplanken.dart`), alle 58 geänderten O-Zeilen des Diffs 659d3ed..HEAD, die O-Zeilen von K6 und K7, die Begriffszeilen GL-01 bis GL-21 aus K8, die Datensätze R03 und R04 in `rollen.json` und `karten.json`, die Teil-Definitionen für Oberteile.
- Nicht zeilengenau gelesen, nur über das Stichwortraster aller 119 Dateien und Stichproben: `bewohner.json` (1.561 Texte), `stadt/haeuser.json` (1.070), `innenraeume/haeuser.json` (1.454), `innenraeume/fallorte.json` (576), `rollen/faehigkeiten.json` (262, teils), `teile_*.json`, die übrigen unveränderten O-Zeilen von K1, K3, K5 und K9, die Dart-Oberflächentexte. Für diese Bestände stützt sich das Urteil auf Raster und Stichproben. Vor der Abnahme ist eine zeilengenaue Nachlese dieser Dateien empfohlen.

## 6. Urteil

Leitplanken eingehalten: ja (Grenzfall M2) · Kanontreu: nein (wegen M1) · Plagiatsfrei: ja

Leitplanken eingehalten: ja · Kanontreu: nein · Plagiatsfrei: ja
