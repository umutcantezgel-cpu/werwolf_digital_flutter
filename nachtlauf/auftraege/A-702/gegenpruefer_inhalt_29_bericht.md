HEAD e7e4219

# Gegenprüfung Inhalt · Auftrag A-702u · Prüfer gegenpruefer_inhalt_29

Geprüfter Stand: `git merge --ff-only nachtlauf/burgstadt` war ein No-op (HEAD und nachtlauf/burgstadt beide e7e4219). Arbeitsbaum vor und nach den Prüfläufen sauber; kein Commit, kein Push, kein Build, keine Daten geändert.

## Verfahren und Prüfumfang

- Werkzeuge: `dart pub get --offline` (Testbefehl, `.dart_tool` ist ignoriert), `bin/leitplanken.dart --burgstadt`: 125 Dateien, 0 Treffer, 0 Fehler, 0 Warnungen. `bin/kanon.dart --pruefe`: Original 1211 Datensätze, 0 Befunde; wirksam 1276 Datensätze, 0 Befunde. `--wirksam` und `--diff` ausgewertet. Hilfsdateien im Scratchpad-Unterordner gp29.
- Vollständig gelesen: `nachtlauf/kanon/ANPASSUNG.md` (205 Zeilen); `nachtlauf/ENTSCHEIDUNGSLOG.md` E23 bis E54 (Zeilen 147 bis 653); alle geänderten [O]-Datensätze des Kanon-Diffs (`git diff 659d3ed HEAD -- krimidinner/spuk-im-gewoelbe/10_kanon/K*.md`, 22 Dateien, 216 Einfügungen, 212 Löschungen); alle DW-Ergebnistexte (DW1-1 bis DW3-3) im wirksamen Kanon; LISTE-*, ORT-*, H-S/HW-S, BW-STAMM, LF-R03, LF-R04, R02/R03/R11/R17-STAMM; die Haustexte H-036, H-056, H-122, H-125, H-139; Stadtbewohner B12, B15, B32, B35, B39, B41 vollständig.
- Maschinell gesichtet (Schlüsselwortscan über alle Strings): wirksamer Kanon (O, G, L); `bewohner.json` (44 Einträge, Auszug Geschlecht, Alter, Beruf, Frisur, Kopfbedeckung, Kleidung); `stadt/haeuser.json`; `innenraeume/haeuser.json` und `fallorte.json`; `rollen/faehigkeiten.json`; `pixel_engine/data/figuren/*.json`; `texte/erzaehler.json` und `texte/tutorial.json` (stichprobenartig). Die 75 neuen G-Zeilen und 58 neuen L-Zeilen des Kanon-Diffs wurden auf Leitplanken-Wörter und Widersprüche gesichtet.
- Nicht einzeln gelesen: jede Zeile von `stadt/haeuser.json` und `innenraeume/*.json`. Diese Dateien wurden per Schlüsselwort und an den Fundstellen gelesen.
- Der Ordner `nachtlauf/auftraege/A-702/` wurde nicht durchsucht, keine anderen Prüfberichte gelesen. Dieser Bericht ist die einzige Datei, die angelegt wurde.

## Befunde

### B1 · hoch · Haarfarben-Muster entlang der Namensgruppen bleibt bestehen (E54 unvollständig)
- Stelle: `packages/pixel_engine/data/figuren/rollen.json` (Feld `haar`); Look-Anker LF-R01 bis LF-R19 im wirksamen Kanon (ERSETZE-34 bis -38).
- Zitat: Die zwölf Rollen mit türkisch, bosnisch oder kurdisch klingendem Namen (R01, R02, R06, R07, R08, R11, R12, R13, R15, R16, R18, R19) haben nach E54 dunkles Haar in neun Fällen: R01 holz 2, R02 neutral 2, R06 neutral 0, R08 holz 1, R11 neutral 0, R13 neutral 2, R15 holz 2, R16 neutral 2, R18 neutral 2. Hell sind nur R07 (holz 5), R12 (bernstein 4) und R19 (holz 6). Die übrigen acht Rollen haben dunkles Haar nur bei R14 (holz 2) und R17 (neutral 2).
- Regel: Leitplanke 4 (keine Klischees über irgendeine Gruppe); Punkt 19 und Punkt 21 (b).
- Begründung: E54 hat „helles und dunkles Haar je Herkunftsgruppe“ gemischt. Das misst nur die Mischung innerhalb jeder Gruppe, nicht das Verhältnis zwischen den Gruppen. Dieses Verhältnis liegt jetzt bei 9 zu 3 (75 Prozent dunkel) gegen 2 zu 6 (25 Prozent dunkel). Die Gruppenzuordnung kommt allein aus den Namen; Namen gelten nach Punkt 19 nicht als Herkunftsangabe, die Verteilung der Haarfarben über die Namensgruppen ist aber genau das Stereotyp, das die Leitplanke verbietet. Die Figuren sind im Spiel sichtbar. Dies ist ein neuer Grund gegen die Abwägung in E54.
- Vorschlag: Haarfarben über alle 20 Rollen mischen statt je Gruppe. Mindestens vier der neun dunklen Rollen aus der Gruppe (R01, R02, R06, R08, R11, R13, R15, R16, R18) aufhellen und im Gegenzug zwei helle Rollen der übrigen Gruppe dunkler setzen. Danach Kartentest und neue Sichtprüfung (Z-03). Behält der Nutzer das Muster als realistisch, ist das seine Entscheidung; die Gegenprobe aus E50 trägt sie nicht.

### B2 · mittel · „bordeauxroter Blazer“ in den Spieltext-Figurendaten (R15)
- Stelle: `packages/pixel_engine/data/figuren/rollen.json`, Zeile 312, Feld `merkmale` von R15.
- Zitat: „bordeauxroter Blazer“
- Regel: Leitplanke Alkohol („auch nicht als Andeutung“); Maßstab aus E50 („kein Weinname als Farbe“); Punkt 17 (Figurendaten sind Spieltext).
- Begründung: ERSETZE-32 und -33 ersetzen „bordeauxroter Blazer“ im wirksamen Kanon, nicht aber in `rollen.json`. Dort bleibt der Weinname. Der Leitplanken-Scanner meldet ihn nicht, weil „bordeaux“ nicht in seiner Wortliste steht.
- Vorschlag: `merkmale` auf „dunkelroter Blazer“ ändern; die Farbe (Rampe 3, Stufe 3) bleibt unverändert. Die Wortliste des Scanners um bordeaux, Burgunder und Weinrot ergänzen.

### B3 · gering · Nachtplan und Kleidung widersprechen sich bei B12 (Martina Auer)
- Stelle: `packages/burgstadt_core/data/stadt/bewohner.json`, B12, `nacht[3].tut`.
- Zitat: „Sie legt sich für eine Stunde hin, das Glasmaß noch in der Schürze.“ Kleidung laut Datensatz: Hemd, Hose.
- Regel: Punkt 21 (Stimmigkeit der neuen Texte). E54 hat denselben Fehler bei B35 korrigiert, bei B12 aber übersehen.
- Vorschlag: „das Glasmaß noch in der Hand“. Oder die Schürze in die Kleidung aufnehmen; das braucht dann eine neue Sichtprüfung.

### B4 · gering · Kein Arbeitshaus bei B35 (Reinigungskraft im Rathaus)
- Stelle: `bewohner.json`, B35, Feld `arbeitshaus: null`.
- Zitat: „Reinigungskraft im Rathaus“. Das Rathaus ist H-030 („Rathaus Schartenfels“); dort arbeiten B20 und B42 mit `arbeitshaus: H-030`.
- Regel: Stimmigkeit der Stadtdaten (Punkt 21).
- Vorschlag: `arbeitshaus` auf H-030 setzen, wenn B35 dort geführt werden soll; prüfen, ob die Simulation das Feld liest. Weil viele Bewohner kein Arbeitshaus haben, nur gering.

### B5 · gering · „grantig“ und „brummt“ als Grundzug des 71-jährigen Burgwarts (Kanon)
- Stelle: wirksamer Kanon, BW-STAMM („Art: stur, grantig, gerecht …“), OA-24 („Der Burgwart brummt“), BW-ZUSTAND („grantig-komisch“), PF-3 („grantig-komisch“), GS-2 („grantig-warm“), R18-ÖFFENTLICH („brummte“), G2-07 („Der Alte hat gebrummt“).
- Regel: Punkt 21 (keine „brummig“-Wesen über Ältere). E54 hat „brummig“ bei B08, B14 und B28 entfernt. Dasselbe Muster bleibt bei einem älteren Mann in den O- und G-Datensätzen.
- Begründung: Es ist ein Charakterzug einer Kanon-Figur, der mit Wärme endet. Darum nur Hinweis. Entscheidung bei den Kanon-Autoren oder dem Nutzer. Möglich wäre ein Overlay-Ersatz („brummt“ durch „sagt knapp“).

### B6 · gering · Dokumentationsabweichung zur Jeans von R03
- Stelle: `nachtlauf/ENTSCHEIDUNGSLOG.md`, E41 („Aussehen aus Kanon v1.0“), im Vergleich zu `rollen.json` und `karten.json`.
- Zitat: E41 nennt „blau [6,4]“. Die Daten haben `unterteil` jeans Rampe 6, Stufe 3 (rollen.json) und `hose` [6,3] (karten.json).
- Begründung: Die Daten stimmen untereinander überein, nur das Log weicht ab. Das Log korrigieren.

## Geprüft ohne Befund

- Punkt 15, Kanon-Diff und Overlay: Die geänderten [O]-Datensätze (u. a. K-002, K-004, BSO-01, BSO-11, BW-AUSSAGE-2 und -3, H-02, H-06, H-11, H-14, H-17, H-49, H-50, D1-2, D2-2, D3-2, ZM-1 bis -4, LR-3, GL-21, LF-R03, LF-R04, LISTE-ZEITEN, R03-, R04- und R11-ÖFFENTLICH, R04-STAMM, IF-5) stimmen mit Overlay und Stadtdaten überein. LISTE-ZEITEN (23:52, 23:54, 23:56, 23:58, Mitternacht) passt zu STADT-01 und STADT-05, zu H-S15 und H-S19 sowie zu den Aussagen. Die Kanon-Zeit „00:01“ ist im Overlay bewusst durch „kurz nach Mitternacht“ ersetzt (E44).
- R04 Pullover: LF-R04, R04-STAMM, rollen.json (`pullover`, Rampe 5, Stufe 4), karten.json (`oberteil-strickpulli`, [5,4]) und teile_kleidung.json stimmen überein. R03: Notizbuch aus LF-R03, rollen.json (`zubehoer` leer) und karten.json entfernt; Strickjacke, Bluse und Wanderstiefel passen zum Kanon.
- Familienfelder: R02, R03, R11 und R17 nennen keine Herkunftsorte. Bei den übrigen Rollen entfernt das Overlay „Wurzeln“ und ersetzt die Herkunftsorte. Im wirksamen Kanon gibt es kein „Wurzel“ mehr. R20 („an einen See“) und R04 („Die Eltern leben in …“) sind konsistent.
- Ersetzungsreste: Keine Treffer für Harz, Osterode, Brocken, bewusstlos oder „Herkunft des Schreis“ in O-, G- und DW-Datensätzen. „Hodžić“ bleibt im Namen und in der Aussprache (E48, Punkt 19). ERSETZE-22 („fällt ihr das Handy“) passt zu R02-WISSEN und den übrigen Stellen mit einer weiblichen Figur.
- Punsch: Alle Stellen sind alkoholfrei, auch in Z-0005 und DW1-3. „Punschkessel“ als Gerätebezeichnung bleibt (E50).
- Lampenmarke: „VT · 3“ steht konsistent in LISTE-GEGENSTÄNDE, E1-01, DW1-1, GL-19 (Aussprache „fau-te drei“) und in der Beruf-Zeile von R01 („selbstständiger Veranstaltungstechniker (eine Ein-Mann-Firma mit Transporter)“).
- Haarfarben: Look-Anker, rollen.json und karten.json stimmen für alle 20 Rollen und den Burgwart überein. Die Bewertung der Verteilung steht in B1.
- DW-Ergebnisse: Punsch alkoholfrei (DW1-3), Strickpullover bei DW2-3 konsistent. DW3-3 nennt nach der richtigen Entscheidung keine Täterin und keinen Täter, nur die Sohle (E54). Adnan und Rojda erscheinen nur als Träger anderer Sohlen.
- Punkt 19 (Herkunft): Im wirksamen Kanon (O, G, DW) und in den Stadt-, Spiel- und Figurendaten gibt es keine Herkunft als Motiv, Indiz oder Pointe. Keine Herkunftsgruppe, kein Ort und keine Sprache werden genannt (geprüft: bosnisch, kurdisch, türkisch, Tuzla, Zenica, Opole, Masur, Wigilia, Pita, Pierogi u. a.). Die Treffer „stammt“ sind das Verb.
- Punkt 21 (Stadtbewohner): 21 Frauen und 23 Männer, wie E54 angibt. Der Geschlechtertausch (B15, B35, B41 männlich; B12, B32, B39 weiblich) ist in Pronomen und Haustexten konsistent (H-036, H-056, H-122, H-125, H-139). Dutt: B09 (44), B13 (88), B27 (31), B38 (73). Haube: B03 (51), B13 (88). Glatze: B06 (46), B08 (81), B18 (66), B28 (84). B14 und B40 haben kurzes graues Haar. Keine „brummig“-Wesen, keine „die Alten“, keine „Schützlinge“, keine Hörrohr- oder Schwerhörigkeitsmotive in bewohner.json. Der Großvater mit gutem Gehör bei R07 ist eine positive Einzelangabe, kein Altersklischee.
- Alkohol, Drogen, Blut, Mythos: Keine Andeutung. Vorkommen: „alkoholfrei“, „Kräutertee“, „Melisse“, „Kräuterregal“ (unbedenklich); „Beule“, „benommen“, „keine offene Wunde“; keine Hexe, kein Walpurgis, kein Teufel, kein Vampir.
- Plagiat: Keine übernommenen Film-, Serien-, Buch- oder Liedsätze gefunden (Schlüsselwörter und Stichprobe). „Einspruch!“ und „Geisterstunde“ sind allgemeine Wörter (E27, E45). „Tatort“ steht nur als Begriff für den Tatort.
- Übrige Spieltexte (texte/erzaehler.json, texte/tutorial.json): Schlüsselwortscan ohne Befund.

## Abwägungen aus Punkt 9a (nicht erneut als Befund gezählt)

Ohne neuen Grund nicht gezählt: FM-1 als Projektregel in der Kanon-Quelle und als [L]-Datensatz (E45); H-15 mit dem Absatz von Merle als Schluss S-5 (E50, E54); Kanon-Spuren gegen die Täterin (E27 M5); Fähigkeit von R03 nur für R03 (E27 H1); „Einspruch!“ (E27 G3); „Stollen“ und „Schacht“ (E33); Hodžić und Öztürk als Namen (E48); „Herkunft: Schartenfels, Bergland“ beim Burgwart als Ort der Spielwelt (E48, E50); Rest-Geschlechtermuster in Dienstberufen (Verkäuferin, Friseurin, Schneiderin, Bäckerin gegen Ratsdiener, Briefträger, Nachtpförtner), an den Nutzer gegeben (E44); Großmutter-Motive (E38, E39); Biikebrennen und regionale Bräuche (E38); der Name Kunibert (E44); Partytexte unter content/party (Punkt 22).

## Urteil

- Leitplanken eingehalten: nein. Grund: B1 (Haarfarben-Klischee, hoch). Die übrigen Befunde sind gering oder mittel und für sich nicht Leitplankenverstoß; B2 ist eine Lücke in der Wortliste.
- Kanontreu: ja. Overlay und Kanon-Diff sind konsistent; die Abweichungen (Haarfarben nach ERSETZE-34 bis -38, Familienfelder, Herkunftsbereinigung) sind im Overlay dokumentiert und von Nutzerentscheidungen gedeckt. B2 betrifft Figurendaten, nicht den Kanon.
- Plagiatsfrei: ja.

Leitplanken eingehalten: nein · Kanontreu: ja · Plagiatsfrei: ja
