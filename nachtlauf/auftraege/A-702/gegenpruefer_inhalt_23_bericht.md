HEAD d4b5953

# Gegenprüfung Inhalt 23 · Auftrag A-702s · Burgstadt Schartenfels

Prüfer: gegenpruefer_inhalt_23 · Worktree: wf_12ff3921-fcf-1 · Schritt 0: `git merge --ff-only nachtlauf/burgstadt` (d92a675 → d4b5953, Fast-forward) · `git rev-parse --short HEAD` = d4b5953

## 1. Ergebnis

- Befunde: hoch 2 · mittel 2 · gering 5
- Leitplanken: nein. Ursache sind die Befunde 1 und 2: Verdacht, Schuld und Färbungen folgen im Kanon der Herkunft. Das Spiel übernimmt diese Struktur aus den unveränderten Kanon-Dateien.
- Kanontreu: ja. Der wirksame Stand gibt Kanon und Overlay getreu wieder. Eine Ergänzung im Stadt-Layer ist nicht gedeckt (Befund 3).
- Plagiatsfrei: ja. Kein Satz, keine Figur und kein Name aus einem bekannten Werk erkannt (Befund 9 ist nur ein Prüfhinweis).

## 2. Lauf und Werkzeuge

- Leitplanken-Scanner (`dart run bin/leitplanken.dart --burgstadt`): 119 Dateien, 0 Treffer, 0 Fehler, 0 Warnungen.
- Kanon-Werkzeug `--pruefe`: Original 1211 Datensätze, wirksam 1276 (65 neu, 69 geändert, 25 ERSETZE), 0 Befunde.
- Kanon-Werkzeug `--wirksam` und `--diff` ausgewertet: O 264, G 559, L 453 Datensätze.
- `git diff 659d3ed HEAD -- krimidinner/spuk-im-gewoelbe/10_kanon/K*.md`: 58 geänderte O-Zeilen gelesen.
- Musterprüfung über 7.947 Textquellen (Stadt-, Spiel- und Figurendaten, ANPASSUNG.md, wirksame O- und G-Datensätze).
- `dart pub get --offline` ausgeführt. Der Worktree blieb danach unverändert.

## 3. Befunde

### Befund 1 · hoch · Verdacht und Schuld folgen der Herkunft im wirksamen Kanon

- Datei: nachtlauf/kanon/ANPASSUNG.md, Zeile 101 (FM-1, Funktionsmatrix ohne Herkunft). Wirksamer Stand: O-Datensätze R01-STAMM (Z. 89), R02-STAMM (Z. 91), R03-STAMM (Z. 93), R04-STAMM (Z. 95), Feld „Wurzeln“. L-Datensatz Z-2358a.
- Zitat: „R01 Hauptverdächtiger ohne Vergehen (falsche Fährte über Lampe und Code-Zettel); R02 Hauptzeugin mit eigenem Streich-Geheimnis“. Wurzeln: R01 „bosnisch“, R02 „kurdisch“, R03 und R04 „deutsch“. Z-2358a: „Rojda legt den Hauptschalter um.“
- Regel: Leitplanke 2 („Herkunft ist nie Motiv, Indiz oder Pointe“) und Leitplanke 3 (keine Klischees über irgendeine andere Gruppe). Die Begründung von FM-1 selbst schließt „Ordnungsmerkmal der Lösung“ aus.
- Befund: Die Täterin (R03) und der echte Vergeher (R04) sind deutsch markiert. Die falsche Fährte (R01) und der Streich am Hauptschalter (R02) sind bosnisch bzw. kurdisch markiert. Die Umordnung nach Rollen-IDs (E43) ändert an dieser Zuordnung nichts, weil die Wurzeln im selben wirksamen Stand stehen. Die Aussage in E46, Herkunft sei „weder sichtbar noch Teil einer Spur“, trifft nur das Feld Wurzeln. Name und Aussprache werden angezeigt („Adnan Hodžić“, „Derya Öztürk“, „Selin Aksoy“) und tragen die Herkunft in die Wahrnehmung der Spielenden.
- Neuer Grund gegen E42, E43, E45 und E46: siehe Abschnitt 4.
- Vorschlag: Die Verdachtsrolle (falsche Fährte) und den Streich nicht an Herkunftsgruppen binden. Die Kanon-Autoren entscheiden (FÜR DEN NUTZER). Der Nachtlauf ändert die Kanon-Dateien nicht.

### Befund 2 · hoch · Geld- und Gewalt-Färbungen nur bei nichtdeutsch markierten Rollen

- Datei: krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-05-12.md und K2-ROLLEN-13-20.md (unverändert, im wirksamen Stand als G-Datensätze übernommen). Stellen: wirksam_G, @R05-GEHEIM (Z. 1), @R06-GEHEIM (Z. 5), @R13-GEHEIM (Z. 33), @R14-GEHEIM (Z. 37), @R15-GEHEIM (Z. 41), @R16-GEHEIM (Z. 45), Feld „Motiv“ mit „Scheinbare Färbung“.
- Zitate:
  - R13 (türkisch): „Sie drängt hart auf ihr Geld und wirkt dadurch kalt und berechnend.“
  - R15 (türkisch): „… und wirkt, als denke sie nur in Beträgen.“
  - R14 (polnisch): „Er grummelt laut, der Burgwart wolle Adnan abzocken, und wirkt dadurch, als hege er einen Groll gegen den Burgwart.“
  - R05 (polnisch): „… und wirkt dabei rachsüchtig.“ (Mietgeld)
  - R16 (bosnisch): „Durch ihn wird Jonas' Geldnot greifbar … und die wirkt wie ein Tatmotiv.“
  - R06 (kurdisch): „… weiß als Sanitäter genau, wie man jemanden kurz benommen macht …“
- Befund: Alle fünf Geld- und Berechnungs-Färbungen liegen bei nichtdeutsch markierten Rollen (R05, R13, R14, R15, R16). Die drei Rollen mit Bank-, Versicherungs- und Immobilienberuf (R13, R15, R16) sind nichtdeutsch markiert. Die einzige deutsch markierte Rolle mit Geldmotiv ist der echte Vergeher R04, und dessen Geldbezug ist kein Färbungsfeld. Die Gewalt-Färbung trifft die kurdisch markierte Rolle mit Sanitäterberuf (R06). Dazu kommt das Berufsbild: Tischler und Koch sind bei polnisch markierten Rollen (R14, R09) das Grundmuster („rechnet alles in Arbeitsstunden“). Dieses Muster ist im Kanon angelegt und wird im Spiel ausgeliefert. E38 hat es nicht geprüft, weil dort nur Familienfelder und Berufe betrachtet wurden.
- Regel: Leitplanke 3 (keine Klischees über irgendeine andere Gruppe) und Leitplanke 2 (Herkunft nie Motiv oder Indiz).
- Vorschlag: Die Färbungen der betroffenen Rollen auf persönliche, herkunftsneutrale Züge umstellen. Geldbezug und Gewaltwissen nicht an nichtdeutsch markierte Rollen binden, oder beide Gruppen gleich verteilen. Die Kanon-Autoren entscheiden. Eine Umsetzung im Overlay (G-Felder) ist technisch möglich.

### Befund 3 · mittel · Übernachtung der Clique in der Pension ohne Kanon-Grundlage

- Datei: nachtlauf/kanon/ANPASSUNG.md, Zeile 62 (ORT-03). Wirksamer Stand: wirksam_L, HW-S06.
- Zitat: „Rolle im Fall: Farbe (Übernachtung der Clique; …)“ und „Die Pension „Zum Uhrturm“ ist die Übernachtung der Clique (ORT-03)“.
- Gegenstelle: K-010 (wirksam_O Z. 42): „In der Burg sind in dieser Nacht nur die Festgesellschaft … und der Burgwart.“ Außerdem schließt das Burgtor ab 23:00.
- Regel: Kanontreu. Neue Tatsachen brauchen eine Grundlage im Kanon. Die Stadt-Ergänzung darf nur Farbe, Entlastung oder Bestätigung liefern (ANPASSUNG Z. 9).
- Befund: Der Kanon nennt keine Übernachtung der Clique. Die Aussage passt nicht zum Setting des Abends, ohne dass dies begründet wird.
- Vorschlag: Satz streichen oder auf eine Ortsbeschreibung beschränken.

### Befund 4 · mittel · Der Satz „Ein KI-Erzähler liest alle Texte vor“ widerspricht E46

- Datei: krimidinner/spuk-im-gewoelbe/10_kanon/K8-STILBLATT.md, Datensatz @FÜNF-SÄTZE [O] (wirksam_O Z. 195). Ebenso Datensätze AK-3 (Z. 165) und AK-4 (Z. 166): „Der Erzähler liest den Anklagetext.“ / „Der Erzähler liest das passende Ende …“
- Zitat: „Ein KI-Erzähler liest alle Texte wortgetreu vor; nur die neun Entscheidungen des Detektivs bringen Punkte.“
- Gegenstelle: E46: „Die App liest nichts vor, sie zeigt alle Texte als Karten an.“ Im Code gibt es keine Sprachausgabe (Suche nach Sprachausgabe, Vorlesen und Speak in lib/ und packages/ ohne Treffer).
- Regel: Konsistenz des Spieltexts mit dem tatsächlichen Verhalten des Spiels. Die Ziffern-Entscheidung in E46 stützt sich auf die Annahme, die App lese nicht vor.
- Befund: E46 hat die Tatsache richtig festgestellt, die O-Texte beschreiben aber das Gegenteil. Die Ziffern-Entscheidung ist mit dem Spieltext nicht in Einklang.
- Vorschlag: Spieltext angleichen („zeigt“ oder „führt durch“) oder die Ziffern-Entscheidung neu bewerten, falls eine Sprachausgabe geplant ist.

### Befund 5 · gering · Overlay-Datensatz K-010 enthält noch „Osterode“

- Datei: nachtlauf/kanon/ANPASSUNG.md, Zeile 42.
- Befund: Der Overlay-Datensatz nennt „Osterode“. ERSETZE-18 korrigiert das im wirksamen Stand (wirksam_O Z. 42: „unten im Tal“). Im wirksamen Stand gibt es keinen Treffer mehr. Das Spiel ist nicht betroffen.
- Vorschlag: Wortlaut im Overlay-Datensatz bereinigen.

### Befund 6 · gering · Einstufung „Farbe“ bei Hinweisen, die den Ursprung des Lakens eingrenzen

- Datei: nachtlauf/kanon/ANPASSUNG.md, Zeile 64 (ORT-05). Wirksamer Stand: wirksam_O H-S05 (Z. 245), H-S09 (Z. 249); wirksam_L HW-S05, HW-S09.
- Zitat HW-S09: „Im Fundus fehlt kein Laken; das Gespensterlaken stammt nicht aus der Volksbühne …, sondern aus der Burgwäsche (Z-2140).“ HW-S05: „… die Pension hat damit nichts zu tun.“
- Regel: ANPASSUNG Z. 9 (nur Farbe, entlastend oder bestätigend). Diese Hinweise sind entlastend bzw. bestätigend. E42 („kein Stadt-Hinweis stützt eine Schlussfolgerung“) trifft deshalb nicht zu.
- Vorschlag: Einstufung auf „entlastend“ (Pension, Volksbühne) bzw. „bestätigend“ (Burgwäsche) setzen.

### Befund 7 · gering · Stadt-Ergänzung verneint die Reparatur der Sicherung

- Datei: nachtlauf/kanon/ANPASSUNG.md, Zeile 46 (STADT-04). Wirksamer Stand: wirksam_O H-S12 (Z. 252), HW-S12.
- Zitat STADT-04: „Die Ersatzsicherungen aus dem Torhaus passen nicht in den alten Hauptverteiler …“
- Gegenstelle: OA-21 (wirksam_O Z. 33): „Hauptsicherung durchgebrannt, Ersatz liegt im Torhaus.“ R01-WISSEN (wirksam_G): „Ersatz im Torhaus.“
- Befund: Kein direkter Widerspruch. Der Kanon legt aber einen Reparaturweg nahe, den die Stadt-Ergänzung verschließt.
- Vorschlag: Kanon-Autoren klären, ob ein Reparaturweg gewollt ist. Sonst OA-21 und R01-WISSEN angleichen.

### Befund 8 · gering · Datenrest bei R04

- Datei: packages/pixel_engine/data/figuren/karten.json, Eintrag R04, materialien.weste [5, 3].
- Befund: Die Weste steht weder in rollen.json noch im Kanon (R04-STAMM, LF-R04) noch in den Teilen (teile). Sie ist unsichtbar, aber ein Datenrest.
- Vorschlag: Eintrag entfernen.

### Befund 9 · gering · Prüfhinweis zum Titel „Geisterstunde“

- Stellen: GL-13 (wirksam_O Z. 186), H-08 (Z. 111), BSO-08 (Z. 51). Track-Titel im Spiel.
- Befund: Der Ausdruck ist gebräuchlich. Ich habe kein konkretes Lied oder Werk mit diesem Titel erkannt, kann das ohne Recherche aber nicht ausschließen. Kein Kopiebefund, nur eine Prüfung vor der Abnahme.
- Vorschlag: Titel gegen gleichnamige Werke prüfen oder neutral umbenennen.

## 4. Abwägungen E23 bis E46 (Auftrag Punkt 9a)

- E23 (M5 bewusstlos bleibt im Kanon): akzeptiert. ERSETZE-17 wirkt im wirksamen Stand.
- E27 (Kanon-Spuren als Rätsel; R03-Fähigkeit nur für R03; „Einspruch!“; Kopftuch-Teil; LISTE-ORTE nur Farbe): akzeptiert. „Einspruch!“ ist ein allgemeines Gerichtswort und kein Befund.
- E29 (B1 ERSETZE-17, B2 Angst, B3 LISTE-ZEITEN): akzeptiert. Die Angabe „Uhrturm 00:25“ ist durch E42 auf 00:30 korrigiert und stimmt mit STADT-05 und LISTE-ZEITEN überein.
- E31, E33, E34, E35, E37: akzeptiert. Die genannten Stellen sind geprüft, keine Reste gefunden.
- E38 B1 (Familienfelder): akzeptiert, soweit das Folklore-Muster entfernt wurde. Die Aussage „Kopplung Herkunft → Beruf: kein Muster“ widersprochen (Befund 2).
- E38 B2 (Wanderstiefel aus zwei Teilen): akzeptiert.
- E39, E40 (Großmutter, Teile, Frisur, Abbruchregel): akzeptiert.
- E41 (Kanon v1.0, LISTE-ZEITEN, Aussehen R03 und R04, Z-12) und Klarstellung in E45 (O und G sind Spieltext, L nur Widerspruchsprüfung): akzeptiert und so angewandt.
- E42: Laken „Schartenfels 7“, Phasenbeginn 00:30, „unten im Tal“, Großmutter bei R18: akzeptiert. Widersprochen: „Einstufung Farbe, kein Stadt-Hinweis stützt eine Schlussfolgerung“ (Befund 6), und FM-1 als „Vorsichtsmaßnahme gegen Klischees und kein Klischee“ (Befund 1).
- E43: Himmel, Teestube, Punsch, Familienfelder R05, R12, R18, Wärter B06, B13 und B33: akzeptiert. Widersprochen: „FM-1 ohne Herkunft“ (Befund 1). Die Abwägung zu HODŽIĆ ist durch E46 überholt.
- E44: akzeptiert. Die Gleichsetzung „Tomasz hat kochen gelernt“ als bewusste Entscheidung wird unter Befund 2 mitgeprüft.
- E45: R04-Pullover, Ortsliste, Wortwahl: akzeptiert. FM-1 in der Quelle als Nutzerentscheidung: widersprochen (Befund 1). Ein Nutzerentscheid bleibt wirksam, aber die Begründung ist neu (Abschnitt 4 und Befund 1).
- E46: Lampenmarke „VT · 3“ ohne Nachnamen, „Quelle des Schreis“: akzeptiert. Die Begründung ist nachvollziehbar, weil der Nachname kein Zuordnungsmerkmal mehr braucht (der Firmenname „Hodžić Veranstaltungstechnik“ ist ohnehin öffentlich). Widersprochen: „Herkunft ist nirgends sichtbar“ (Befund 1, Name und Aussprache sind sichtbar). Widersprochen: „Die App liest nichts vor“ in Bezug auf die O-Texte (Befund 4). FM-1 als Nutzerentscheidung: widersprochen (Befund 1).

## 5. Punkte 15 und 18 (Kanon-Diff, Overlay, wirksamer Kanon)

- Kanon-Diff 659d3ed bis HEAD (58 O-Zeilen): H-17 („acht vor zwölf“), D2-2 („sieben nach zwölf“), D3-2, H-49, H-50 und LISTE-ZEITEN stimmen mit der Zeitleiste überein (Z-2352a und b, Z-2356d, Z-2358a). Die Phase-1-Zeit 00:30 ist in STADT-05, LISTE-ZEITEN und den Nachtplänen gleich.
- Begriffsersetzungen: Im wirksamen O-, G- und L-Stand gibt es keine Treffer mehr für Brocken, Harz, Oberharz, Osterode, bewusstlos, HODŽIĆ, „Herkunft des Schreis“ und Silberhauer. Die neuen ERSETZE-23 bis -25 wirken: „VT · 3“ in GL-19, LISTE-GEGENSTÄNDE, BSO-03, H-28, DW1-1; „Quelle des Schreis“ in R02-LÜGE und LR-7.
- Familienfelder: wie in ANPASSUNG Z. 77 bis 95 beschrieben im wirksamen Stand umgesetzt. Die Wurzeln bleiben unverändert (siehe Befund 1).
- Aussehen R03 und R04: Kanon (R03-STAMM, R04-STAMM, LF-R03, LF-R04), rollen.json und karten.json stimmen überein. R03: dunkelgrüne Strickjacke mit Zopfmuster über weißer Bluse, blaue Jeans, braune Wanderstiefel, Notizbuch entfernt. R04: olivgrüner Strickpullover, kariertes Hemd, Jeans, braune Wanderstiefel, Armbanduhr (nicht gezeichnet, E45). Rest: Befund 8.

## 6. Geprüft ohne Befund

- Alkohol und Drogen: nur Fehlalarme (bar als Bargeld, schenken, Zapfen, Krug, Wachsspritzer, Pupillen, Gras). Punsch ist überall alkoholfrei oder bezeichnet nur den Kessel, und der Kanon legt den Kessel als alkoholfrei fest (OA-04, GL-14). Gaststätten sind Teestube und Bäckerei.
- Blut und Verletzung: nur Beule, benommen, Kühlpack, „keine offene Wunde“. Keine Leiche, kein Blut im Detail. Die Friedhofsbemerkung über die Toten ist ohne Gewalt.
- Hexen, Walpurgis, Teufel: nicht vorhanden. Gespenst, Nebelriese und Spuk sind erlaubt.
- Nebel: nur unten im Tal (Stadtdaten, Erzähler-Stimmung). Die Oberstadt ist klar und frostig (K-002, E43).
- Täterinnen-Nahelegung in Stadt- und Figurendaten: keine Laken-, Stiefel- oder Strickjackenhinweise. Die Kanon-Spuren (Stollen, Wanderstiefel, Laken) sind nach E27 Rätselspuren.
- Stadtzeiten (22:00, 00:30, 01:30, 03:00, 04:30) stimmen mit LISTE-ZEITEN überein.
- Bewohner der Stadt: alle 44 mit deutschen Namen und Berufen. Keine Gruppenzuschreibung.
- Erzähler- und Tutorialtexte: unauffällig, außer Befund 4.
- Feldname „Herkunft“ bei BW-STAMM (Schartenfels, Bergland) ist unkritisch.

## 7. Prüfumfang und Grenzen

- Vollständig gelesen: ANPASSUNG.md; alle 264 wirksamen O-Datensätze; der Overlay-Diff (147 Zeilen); E23 bis E46; erzaehler.json; tutorial.json; LEITPLANKEN-AUSNAHMEN.md; FORMAT.md; die Werkzeuge leitplanken.dart und kanon.dart; rollen.json und karten.json (R03, R04); bewohner.json (Namen, Berufe, Wesen aller 44 Einträge); die 16 Scheinfärbungen aus den G-Datensätzen.
- Musterprüfung über alle 7.947 Quellen: Alkohol, Drogen, Hexen und Teufel, Blut und Verletzung, Herkunfts- und Klischeebegriffe, Geschlechts- und Altersklischees, Filmfiguren, Täterinnenbezüge.
- Nicht vollständig im Einzelnen gelesen (nur Muster und Stichproben): haeuser.json (83 KB), innenraeume/haeuser.json und fallorte.json (zusammen 89 KB), rollen/faehigkeiten.json (21 KB, Auszüge), die übrigen G-Datensätze (WISSEN, VERBINDUNGEN, LÜGE, Geheimnis) und die Figuren-JSON (nur Textfelder). GESAMT-KANON.md wird vom Scanner und vom Kanon-Werkzeug nicht gelesen und wurde nicht als Maßstab verwendet. Dart-Quelltext (lib/) war nicht Auftragsgegenstand.
- Die Urteile „Kanontreu ja“ und „Plagiatsfrei ja“ gelten für den gelesenen Umfang. Die Befunde 1 bis 4 beruhen auf vollständig gelesenen Stellen.
- Keine Berichte anderer Prüfer gelesen. Der Ordner nachtlauf/auftraege/A-702/ wurde nur als Zielordner für diesen Bericht genutzt.
- Keine Daten geändert, kein Commit, kein Push, kein Build.

## 8. Urteil

Leitplanken: nein. Befunde 1 und 2 zeigen ein Klischeemuster, das Herkunft mit Verdacht, Schuld und Geldgier verbindet. Kanontreu: ja, mit Befund 3 als Kanon-Kohärenz. Plagiatsfrei: ja.

Leitplanken eingehalten: nein · Kanontreu: ja · Plagiatsfrei: ja
