HEAD d4b5953

# Gegenprüfung Inhalt A-702s/24 · Schwerpunkt wirksamer Kanon (Punkt 15 und 18)

Prüfer: gegenpruefer_inhalt_24 · Worktree wf_12ff3921-fcf-2 · geprüfter Stand d4b5953 (nach `git merge --ff-only nachtlauf/burgstadt`, vorher d92a675)

## Ergebnis

Befunde: hoch 1 · mittel 1 · gering 1. Die Leitplanke „keine Klischees über irgendeine andere Gruppe“ ist durch die Funktionsverteilung im wirksamen Kanon verletzt (Befund 1). Kanontreu und Plagiatsfrei ohne Befund.

## Prüfmittel und Stand

- `git merge --ff-only nachtlauf/burgstadt` und `git rev-parse --short HEAD`: d4b5953. Arbeitsbaum danach sauber, keine Daten geändert.
- `dart pub get --offline` in packages/burgstadt_core, dann `dart run bin/leitplanken.dart --burgstadt`: 119 Dateien, 0 Treffer, Exit 0.
- `dart run bin/kanon.dart --pruefe`: Original 1211 Datensätze, wirksam 1276 (65 neu, 69 geändert, 25 ERSETZE), alle Proben 0 Befunde.
- `dart run bin/kanon.dart --wirksam`: 264 O, 559 G, 453 L. Davon 823 O/G (Spieltext nach Punkt 17).
- `git diff 659d3ed HEAD -- krimidinner/spuk-im-gewoelbe/10_kanon/K*.md`: 22 Dateien, +216 / −212. 103 geänderte O/G-Zeilen, jede Einfügung und Entfernung einzeln gelesen.

## Befunde

### 1. hoch · Funktionsverteilung FM-1 hängt an der Herkunft

- Regel: „Herkunft ist nie Motiv, Indiz oder Pointe“ und „keine Klischees über … irgendeine andere Gruppe“ (Auftrag Punkt 4).
- Datei und Stelle: `nachtlauf/kanon/ANPASSUNG.md`, Abschnitt „Funktionsmatrix ohne Herkunft“ (FM-1); O-Datensätze R01-STAMM und R02-STAMM im wirksamen Kanon; R01 beruf in `packages/burgstadt_core/data/rollen/faehigkeiten.json`, Zeile 6.
- Zitat wirksam: FM-1 „R01 Hauptverdächtiger ohne Vergehen (falsche Fährte über Lampe und Code-Zettel); R02 Hauptzeugin mit eigenem Streich-Geheimnis“. R01-STAMM „Name: Adnan Hodžić … Wurzeln: bosnisch“. R02-STAMM „Wurzeln: kurdisch“. R01 beruf „selbstständiger Veranstaltungstechniker („Hodžić Veranstaltungstechnik“ …)“.
- Zitat Original (`krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md`, Zeile 80): „bosnisch – Hauptverdächtiger ohne Vergehen (R01); kurdisch – Hauptzeugin (R02); polnisch und türkisch – keine belastete Funktion“. Begründung: „damit keine Minderheitsgruppe mit Schuld oder Betrug verbunden wird“.
- Befund: Die falsche Fährte (R01) und die Lügnerin mit dem Streich (R02) haben nichtdeutsche Wurzeln. Die Täterin (R03) und der Mietbetrüger (R04) sind deutsch. Der Kanon wollte genau das vermeiden, seine eigene Zuordnung verletzt es. R02 hat den Hauptschalter umgelegt und lügt darüber (Z-Records [L]; E43 bestätigt die Lüge).
- Neue Gründe gegen E42, E43, E45 und E46 (Punkt 9a):
  - E42 behauptet „keine andere Gruppe trägt eine belastete Funktion“. FM-1 widerlegt das selbst: R01 ist Hauptverdächtiger, R02 Hauptzeugin mit Streich-Geheimnis.
  - E46 behauptet „Ohne Herkunftsangabe und ohne sichtbare Herkunft im Spiel ist sie kein Herkunftsmuster mehr“. Das trifft für den wirksamen Kanon nicht zu. „Wurzeln“ steht in den O-Datensätzen aller 20 Rollen. Punkt 17 zählt O-Datensätze zum Spieltext, auch wenn ein Feld nicht angezeigt wird. Zudem zeigt das Spiel Name und Beruf an (E46 nennt beide), und dort steht der Nachname.
  - E43 und E46 haben die Begründung umformuliert, nicht die Zuordnung. Die Zuordnung ist aber das, was der Spieler im Fall vorfindet.
- Gegenargument, gewertet: Die Täterin ist deutsch, und der Verdacht gegen R01 hängt an einem Gegenstand, nicht an der Herkunft. Das stimmt. Die scheinbaren Färbungen (Motiv „scheinbar“) sind aber über alle Herkünfte verteilt, auch bei R10 und R17 (deutsch). Der Befund betrifft nur die belasteten Funktionen in FM-1, und dort bleibt das Muster bestehen.
- Vorschlag (Kanon-Verantwortung, Nutzerentscheidung): FM-1 neu besetzen, so dass falsche Fährte und Streich nicht an einer Herkunftsgruppe hängen. Bis dahin als Overlay-Option das Feld Wurzeln für R01 und R02 löschen. Der Namens- und Berufsmarker bleibt bis zur Entscheidung über Befund 2. Die Kanon-Dateien ändert der Nachtlauf nicht.

### 2. mittel · Eigentumsmarke bleibt über den Nachnamen an R01 gebunden

- Regel: Herkunft nie Indiz (Punkt 4); die Abwägung in E46 ist zu prüfen.
- Stelle: BS-03, H-28, DW1-1 (Ergebnis A), GL-19; R01 beruf in `faehigkeiten.json`, Zeile 6, und R01-STAMM.
- Befund: E46 kürzt die Lampenmarke auf „VT · 3“ und begründet das damit, dass „VT“ für R01s Firma steht und der Nachname nicht gebraucht wird. Die Firma heißt aber „Hodžić Veranstaltungstechnik“, und der Beruf wird angezeigt. Der Weg von „VT · 3“ zu R01 führt damit über den Nachnamen. Die Kürzung ist kosmetisch. Der `kanon_test` prüft nur den Lampentext und ist deshalb grün.
- Vorschlag: den angezeigten Firmennamen ohne Nachnamen führen (Overlay, Feld Beruf von R01). „VT“ als Eigentumsmarke bleibt. Entscheidung der Kanon-Autoren, weil Name und Beruf Kanon-Fakten sind.

### 3. gering · Punsch ohne „alkoholfrei“ in L-Datensätzen

- Regel: „Punsch immer alkoholfrei“ (Punkt 4).
- Stelle: Z-0005 [L] „ein Becher noch warmer Punsch“; DW1-3 [L] „Ergebnis B: Der Punsch ist noch warm und duftet nach Zimt.“
- Einordnung: L ist nach Punkt 17 kein Spieltext. Ergebnistexte könnten aber später in die Spieloberfläche gelangen. Im Code (`packages/**`) findet sich der Satz derzeit nicht (0 Treffer). Die ERSETZE-Zeilen 19 bis 21 erfassen diese Stellen nicht.
- Vorschlag: ERSETZE-Zeilen ergänzen: „ein Becher noch warmer Punsch“ → „ein Becher noch warmer, alkoholfreier Punsch“; „Der Punsch ist noch warm“ → „Der alkoholfreie Punsch ist noch warm“.

## Hinweise (kein Befund)

- Scanner-Lücke: Die Wortliste (`packages/burgstadt_core/lib/src/pruef/leitplanken.dart`, Zeilen 257 bis 292) kennt keine Punsch-Regel und keine Strukturregel für Herkunft. Der Scanner liest die Rohdateien (K*.md und ANPASSUNG.md, Zeilen 363 bis 365), nicht den wirksamen Kanon nach ERSETZE. Die Befunde 1 bis 3 erfasst er deshalb nicht. Vorschlag: Scanner auf `kanon.dart --wirksam` ausrichten und die Punsch-Regel aufnehmen.
- Auftrag widersprüchlich: Punkt 15 nennt G-Zeilen nur „auf Widersprüche“, Punkt 5 nennt nur O, Punkt 17 (E45) macht O und G zum Spieltext. Geprüft nach Punkt 17.
- Punkt 9a: E23, E27, E29, E33, E34, E35, E37, E38, E39, E40, E41, E44 und E45 gelesen. Ohne neuen Grund nicht als Befund gewertet. Die Befunde 1 und 2 greifen E42, E43, E45 und E46 mit neuen Gründen an.

## Geprüft ohne Befund

- Kanontreu: keine Widersprüche zwischen wirksamen O/G-Daten und Kanon-Diff sowie Overlay gefunden. Die Overlay-Ersetzungen sind dokumentiert (LISTE-ZEITEN, Begriffe, Punsch, Lampenmarke, FM-1).
- Harz-Reste: 0 Treffer im wirksamen Kanon für Harz, Brocken, Osterode, Silberhauer, Oberharz, Harzer; ebenso in den Stadtdaten. Die Artikel nach den Ersetzungen stimmen („das Bergland“, „im Bergland“, „dem Nebelriesen“).
- „bewusstlos“: 0 im wirksamen Kanon. „kurz benommen“ ist in BW-ZUSTAND, in der R06-Fähigkeit und in R06-GEHEIM konsistent.
- LISTE-ZEITEN gegen K1 v1.0: einzige Abweichung „00:01 … kommt zu sich“ → „kurz nach Mitternacht … kommt zu sich“ (Overlay, E44). Die übrigen Zeiten stimmen mit den R-, E- und Z-Records überein.
- Familienfelder: keine Feste, Speisen oder Instrumente mehr als Familienmerkmal (Wigilia, Newroz, Pita u. a.: 0 Treffer). Die Großmutter-Angaben bei R05, R13 und R18 sind widerspruchsfrei; kein L-Record stützt eine Großmutter im Haushalt.
- R03/R04-Aussehen: Die Kleidung in den STAMM-Records gleicht `packages/pixel_engine/data/figuren/rollen.json` (R03: Strickjacke mit Zopf, Bluse, Jeans, Wanderstiefel, Haarspange; R04: Pullover, kariertes Hemd, Jeans, Wanderstiefel). LF-R03 und LF-R04 enthalten kein Notizbuch und keine Fleecejacke mehr. Armbanduhr: rollen.json führt „zubehoer: uhr“, aber kein gezeichnetes Teil (teile_*.json enthält nur taschenuhr-kette). Durch E27 gedeckt.
- Alkohol: Alle Punsch-Stellen in O und G sind „alkoholfrei“ oder meinen den Kessel (Punschkessel, E46).
- Blut und Verletzung: keine Verletzungsdetails; nur Beule, benommen, Kühlpack und Schlag.
- Hexen, Walpurgis, Teufel, Film-Vampire: 0 Treffer.
- Gaststätten: nur Teestube, Bäckerei, Pension, Apotheke. Keine Kneipe, Wirt oder Bar („bar“ nur als Barzahlung).
- Stadtdaten (bewohner.json, haeuser.json, innenraeume/*.json, faehigkeiten.json, erzaehler.json, tutorial.json): Muster-Suche ohne Treffer außer „bar“ und „alkoholfrei“. Die rund 20 Nebelriesen-Gerüchte in bewohner.json stehen in keinem Bezug zu Strom, Schlüssel, Lampe oder Schrei.
- Nebel: nur im Tal und auf dem unteren Burgweg (K-002, OA-27, LA-01).
- Plagiat: 382 eindeutige wörtliche Zitate (12 bis 140 Zeichen) aus O und G gelesen, dazu Muster für Lieder, Filmfiguren und bekannte Franchise-Namen (u. a. Holmes, Dracula, Harry): keine Kopie erkennbar.

## Abnahme

- Vollständig gelesen: Auftrag A-702s, ENTSCHEIDUNGSLOG E23 bis E46, FORMAT.md, VERSION.md, LEITPLANKEN-AUSNAHMEN.md, ANPASSUNG.md, kanon.dart, leitplanken.dart, Kanon-Diff (103 O/G-Zeilen), Overlay-Diff, R03- und R04-Records, LISTE-ZEITEN.
- Nicht zeilenweise gelesen: die 823 O/G-Zeilen des wirksamen Kanons, bewohner.json (93 KB), haeuser.json (83 KB) und innenraeume/*.json. Geprüft nach Mustern, Suchbegriffen und Stichproben (u. a. B24 Dieter Krämer). Damit ist Punkt 10 des Auftrags für diese Teile nicht erfüllt; das ist als Lücke zu nennen.

Leitplanken eingehalten: nein · Kanontreu: ja · Plagiatsfrei: ja
