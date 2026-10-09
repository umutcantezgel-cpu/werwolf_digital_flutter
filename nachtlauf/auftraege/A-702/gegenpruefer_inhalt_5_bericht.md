# Gegenprüfung Inhalt, Runde 5 (A-702f)

- Auftrag: A-702f, Gegenprüfer Inhalt, fünfte unabhängige Runde (Z-12)
- Worktree: /home/user/werwolf_digital_flutter/.claude/worktrees/agent-a1118b59d64ab0c05
- Stand: HEAD 3999fc9, nach `git merge --ff-only nachtlauf/burgstadt`
- Datum: 2026-10-09
- Vorgaben: keine früheren Berichte in nachtlauf/auftraege/A-702/ gelesen, kein Commit, kein Push, kein Build, keine Datenänderung.

## Urteil

- Befunde: hoch 0 · mittel 0 · gering 1 (B-1)
- Leitplanken: eingehalten. Keine verbotenen Inhalte in Spieltexten, Daten oder lib/.
- Kanontreu: nicht eingehalten. Eine Dauerangabe in R06 weicht vom O-Wortlaut ab (B-1). Die Korrektur ist ein Wort.
- Plagiat: keine Treffer außer einem Gattungswort.
- Das Urteil richtet sich nach den Befunden. Der Z-12-Zähler (ENTSCHEIDUNGSLOG, Zeile 183) ist dafür nicht maßgeblich.

## Prüfumfang

Vollständig gelesen:
- packages/burgstadt_core/data/: stadt/bewohner.json (B01–B44), stadt/haeuser.json, innenraeume/haeuser.json, innenraeume/fallorte.json, rollen/faehigkeiten.json
- packages/burgstadt_spiel/data/texte/: erzaehler.json, tutorial.json
- packages/pixel_engine/data/figuren/: karten.json, rollen.json, teile_kleidung.json, teile_koepfe.json
- nachtlauf/kanon/ANPASSUNG.md
- krimidinner/spuk-im-gewoelbe/10_kanon/: alle K*.md (K1 bis K9 mit Teildateien). Maßstab sind nur die [O]-Zeilen. L-Zeilen dienen der Widerspruchsprüfung und werden hier nicht zitiert.
- nachtlauf/ENTSCHEIDUNGSLOG.md: E23, E27, E29, E31 sowie die Zeile zu Z-12.
- Nicht Maßstab: 10_kanon/entwuerfe/ (nur per Suche berührt).

Scanner: `/opt/flutter/bin/dart run bin/leitplanken.dart --burgstadt` in packages/burgstadt_core (nach `pub get --offline`). Ergebnis: Geprüfte Dateien 119, Summe 0 Treffer · 0 Fehler · 0 Warnungen, Exit 0. Der Scanner erfasst auch die Dart-Texte in lib/burgstadt, lib/ui, lib/game, lib/l10n/app_de.arb und packages/burgstadt_spiel/lib. Grenze: Das Wort „bewusstlos“ steht nicht in der Scanner-Liste (siehe H-9).

Methode: Scanner, vollständige Lektüre, Stichwortsuche über alle Prüfdateien mit Kontrolle jedes Treffers im Zusammenhang, Abgleich jeder Spielaussage mit dem wirksamen Kanon (ANPASSUNG-Overlay).

## Befunde

### B-1 · gering · Kanontreu
- Datei: packages/burgstadt_core/data/rollen/faehigkeiten.json, R06, Feld wirkung.details, Zeile 142
- Stelle und Zitat: „… eine Beule am Hinterkopf, keine offene Wunde, eine Weile benommen, nach Mitternacht wieder wach und orientiert …“
- Regel: O-Zeile BW-ZUSTAND (K2-ROLLEN-KERN.md, Zeile 54): „Kurz bewusstlos, kurz nach Mitternacht wieder wach, ansprechbar und orientiert.“ Wirksam nach @ERSETZE-17 (ANPASSUNG.md, Zeile 28): „Kurz benommen …“. E29 B1 (Zeile 217) nennt diesen wirksamen Stand ausdrücklich. Die Dauer „eine Weile“ widerspricht „kurz“.
- Einordnung: E23 M5 (Zeile 149) hat nur das Wort „benommen“ gegen die Wortliste der Leitplanken bestätigt, nicht die Dauer. Das ist daher nicht als entschieden zu zählen. Das Log ordnet dasselbe Feld widersprüchlich ein (E23 M5: Spieltext; E27 H1: Entwicklertext). Der Code liest „details“ nicht (kein Treffer in packages/**/*.dart). Das sichtbare Feld sichtschicht.zeigt (Zeile 149) nennt keine Dauer. Deshalb gering.
- Vorschlag: „kurz benommen, kurz nach Mitternacht wieder wach und orientiert“.

## Hinweise (keine Befunde)

Die Priorität ist eine Empfehlung. Wo eine enge Lesart einen Befund ergäbe, ist das angegeben.

**H-1 · Priorität hoch · Schuhmacher, Anklang an den Schuh-Beweis**
- Datei und Stelle: packages/burgstadt_core/data/stadt/bewohner.json, B32, Zeilen 1929, 1933, 1934
- Zitat: „Er klebt einen Absatz fest und lauscht, ob der Wind die Gasse entlangschiebt.“ · „Du willst einen Schuh reparieren? Dann gib her, aber sag mir, wo du gewesen bist. Schuhe erzählen das auch.“ · „Die Sohle, die ich heute Nacht klebe, hat schon mehr Gassen gesehen als ich.“
- Bezug: H-06 (K3-HINWEISE.md, Zeile 26, O): „Teilabdruck eines Absatzes mit Stollenprofil“. H-15 (K3-HINWEISE.md, Zeile 35, O): Sohlenkarten.
- Einordnung: Keine Person wird genannt, die Täterin-Regel ist nicht verletzt. Der Text greift aber das Absatz- und Sohlenmotiv des Falls auf, bevor die Sohlenkarten ausgegeben werden. Bei enger Lesart von LISTE-ORTE (ANPASSUNG Zeile 64: Werkstatthäuser „nur Farbe“, nie Ort eines lösungsrelevanten Gegenstands) ein Befund (mittel).
- Vorschlag: Absatz, Sohle und „wo du gewesen bist“ streichen oder neutral formulieren („Er flickt einen Schuh.“).

**H-2 · Priorität mittel · Zeugenaussage ohne Kanon-Stütze**
- Datei und Stelle: bewohner.json, B16 (Witwe Roth), Zeile 975
- Zitat: „Die Schritte unten waren schnell, wie von jemandem, der nicht bleiben will. Mehr kann ich dir nicht sagen.“
- Einordnung: Keine O-Zeile nennt schnelle oder fliehende Schritte (Suche in K1–K9: kein Treffer). ANPASSUNG Zeile 9 verlangt für neue Stadt-Hinweise die Einstufung Farbe, entlastend oder bestätigend. Ob Bewohnerzeilen darunter fallen, ist im Log nicht entschieden (E27 M5 nennt sie nur für die Täterin-Regel). Falls ja, ein Befund (mittel).
- Vorschlag: Zuständigkeit klären. Entweder als Farbe umschreiben („Unten knarrt eine Tür.“) und „Mehr kann ich dir nicht sagen.“ streichen, oder als Hinweis mit Einstufung registrieren.

**H-3 · Priorität mittel · Lichtquellen außerhalb des Katalogs STADT-02**
- Maßstab: STADT-02 (ANPASSUNG Zeile 36, O): „Es leuchten nur Kerzen, Handylichter, Notleuchten mit Batterie, das Geleucht im Burghof und der Mond.“
- Stellen: „Laterne“ als getragenes Licht in bewohner.json bei B06 (Zeile 355), B09 (535), B12 (708), B15 (902), B20 (1209), B27 (1622), B36 (2162), B41 (2497). „nimm die Laterne mit“ bei B01 (51) und B02 (119). „… nur die Lampe des Nachbarn sieht.“ bei B08 (482). „… zählt, wie viele Lichter in der Gasse erloschen sind.“ bei B07 (408).
- Einordnung: Eine Laterne kann eine Kerzenlaterne sein und ist dann durch „Kerzen“ gedeckt. Der Katalog ist aber mit „nur“ abschließend formuliert. Bei enger Lesart ein Befund (gering).
- Vorschlag: „Kerzenlaterne“, „Kerze“ oder „Notleuchte“ schreiben, oder die Laterne in STADT-02 ergänzen (Kanon-Redaktion).
- Geprüft ohne Befund: Keine beleuchteten Fenster in der Nacht (keine Treffer). Die Teestube-Laterne ist seit dem Ausfall aus (bewohner.json, Zeilen 436, 2511; haeuser.json, Zeile 182).

**H-4 · Priorität mittel · Ton**
- Datei und Stelle: bewohner.json, B44 (Seiler), Zeile 2695
- Zitat: „Du willst einen Strick? Nein? Dann sag mir wenigstens, wo du dich festhältst. Ein guter Griff ist alles in dieser Nacht.“
- Einordnung: Anspielung auf Erhängen in einem Spiel mit Mitspielern. Keine Leitplanke nennt das ausdrücklich. Geschmacksfrage, Ton ist „Gänsehaut mit Humor“.
- Vorschlag: Satz streichen oder ohne Anspielung umformulieren (z. B. „Du willst ein Kletterseil?“).

**H-5 · Priorität gering · Zinnen-Zählung als Anklang an einen Burg-Fall-Ort**
- Datei und Stelle: packages/burgstadt_core/data/stadt/haeuser.json, „Haus an der Zinne“, Zeile 766
- Zitat: „Die Hausfrau zählt sie jeden Morgen beim Kaffee, weil sie seit dem Umbau eine mehr zu haben scheinen.“
- Bezug: Die dritte Zinne ist ein Fall-Ort der Burg (ANPASSUNG Zeile 64, O). Das Zählmotiv „eine mehr“ klingt nach diesem Ort.
- Einordnung: Das Haus ist kein Fall-Ort und trägt keinen Hinweis. „Eine mehr“ ist aber kein reiner Farbton im Sinne von LISTE-ORTE (nur Farbe). Bei enger Lesart ein Befund (gering).
- Vorschlag: „eine mehr“ streichen.

**H-6 · Priorität gering · Homonym „Stollen“**
- Sohlenprofil (O): H-06 und H-15 in K3-HINWEISE.md (Zeilen 26, 35).
- Bergbau-„Stollen“ in der Stadt: haeuser.json, Zeilen 1750 („Hauerhaus an der Stollengasse“), 1765 (Inschrift „Ein Stollen führt tief, ein Weg führt hoch · 1798“), 1800–1802 („Speicher am Stollenmund“, „zugemauerten Stolleneingang“), 1848–1850 („Haus zum Stollenhof“, „alten Stollenausgang“). bewohner.json, Zeile 491 (B08, Gerede: „… den alten Stollen entlanggelaufen …“).
- Einordnung: Keine Regelverletzung. Dieselbe Wortform kann den Sohlenbeweis auf eine falsche Spur bringen.
- Vorschlag: Bergbau-Begriffe ändern („Gang“, „Strecke“), damit „Stollen“ nur das Sohlenprofil bezeichnet.

**H-7 · Priorität gering · Doppelung im Uhrturm-Satz**
- bewohner.json, B01, Zeile 50: „… und der Uhrturm schlug, als wäre nichts gewesen“. haeuser.json, H-026 (Uhrturm, Fall-Ort ORT-01), Zeile 338: „Der Turm schlägt die Nachtphasen an, als wäre nichts geschehen.“ ANPASSUNG, H-S01 (O, Zeile 72): „… als hätte es nie einen Stromausfall gegeben.“
- Einordnung: Stilistische Doppelung, keine Regel.
- Vorschlag: Eine der Formulierungen variieren.

**H-8 · Priorität gering · Datenkonsistenz**
- haeuser.json, Zeile 1752 (H-139): „Die Enkelin wohnt heute dort und zählt abends die Lampen am Berg.“ bewohner.json, B08 (Otto Stern, 81), ist als einziger Bewohner mit wohnhaus H-139 eingetragen.
- Vorschlag: Enkelin als Bewohnerin eintragen oder „wohnt heute dort“ umformulieren („besucht ihn abends“).

**H-9 · Priorität gering · Entwicklerfeld und Scanner-Lücke**
- faehigkeiten.json, Zeile 156 (R06, spoilerfrei_weil): „Keine Minutenangabe zur Bewusstlosigkeit …“. Das Feld wird im Code nicht gelesen. ERSETZE-17 erfasst nur die Kleinschreibung „bewusstlos“. Der Scanner kennt „bewusstlos“ nicht. Die Leitplanke „Verletzung nur Beule, benommen, Kühlpack“ wird daher nicht automatisch geprüft.
- Vorschlag: „zur Benommenheit“. Scanner-Wortliste um „bewusstlos“ ergänzen (Entwicklung).

**H-10 · Priorität gering · Herkunftsfarbe im Kanon (nicht im Spiel)**
- K2-ROLLEN-KERN.md, Zeile 7 (R01): „… sonntags gibt es bei den Eltern Pita und lange Telefonate mit der Verwandtschaft.“
- K2-ROLLEN-05-12.md, Zeile 7 (R05): „… Pierogi …“. Zeile 34 (R08): „… Tufahije …“. Zeile 70 (R12): „Kaffee aus der Džezva und eine lange Diskussion …“
- K2-ROLLEN-13-20.md, Zeile 25 (R15): „Sonntags macht der Vater zum Frühstück Menemen …“
- Einordnung: Warme Familienfarbe nach K8 Tonregel §3.6 („nur als warme Farbe, nie als Witz über die Herkunft“). Keine Pointe. Die Begriffe kommen in packages/** nicht vor. Ob „lange Telefonate mit der Verwandtschaft“ als Klischee gilt, ist eine Redaktionsfrage, kein Befund.
- Vorschlag: Kanon-Redaktion entscheidet.

**H-11 · Priorität gering · Kanon-Ort außerhalb des Harz-Ersatzes**
- ANPASSUNG Zeile 34 (K-010, O): „Seine Frau Gerda ist bei ihrer Schwester in Osterode.“ Zeile 43 (BW-STAMM, O): „… bei ihrer Schwester in Osterode.“
- Einordnung: Osterode ist eine reale Stadt am Harz. ERSETZE-01 bis 17 erfasst den Ort nicht. In den Spieldaten kommt er nicht vor, ebenso wenig Gerda. Kein Befund.
- Vorschlag: Kanon-Redaktion wählt einen fiktiven Ort, falls der Harz-Bezug ganz entfallen soll.

**H-12 · Priorität gering · Fluchtmotiv**
- bewohner.json, B09 (Dörte Wagner), Zeile 528: „Sie sitzt am Fenster, die Tasche gepackt, und hört im Nebel ein Bellen aus der Gasse am Untertor.“
- Einordnung: STADT-01 und STADT-03 verbieten das Verlassen der Oberstadt vor dem Morgengrauen. Die Figur geht nicht. Keine Verletzung, aber ein Fluchtanklang.
- Vorschlag: Vorbereitung auf den Morgen erkennbar machen oder „die Tasche gepackt“ streichen.

## Geprüft, kein Befund

- Alkohol und Drogen, auch als Andeutung: keine Treffer in Spieltexten, Daten und lib/ (Treffer nur in Scanner- und Testcode). Punsch ist „alkoholfrei“ (erzaehler.json, Zeile 119). „bar“ nur als Zahlungsart (faehigkeiten.json, Zeilen 116, 123, 376, 383). Keine Gasthaus-, Taverne- oder Kneipen-Treffer.
- Blut, Leiche, Verletzung: keine Treffer. Verletzung in Spieltexten als „Beule“ und „benommen“ (einzige Ausnahme B-1).
- Hexen, Walpurgis, Teufel, Film-Vampire: keine Treffer.
- Herkunft und Klischees (Rumänien, Roma, Sinti, Zigeuner, kurdisch, bosnisch, polnisch, türkisch): keine Treffer in Daten und lib/. Herkunft ist in den Spieldaten weder Motiv, Indiz noch Pointe.
- Täterin-Regel in Stadt-, Bewohner- und Häusertexten (E27 M5): keine Nennung von Merle, Jonas, Stiefeln, Strickjacke, Laken, Handschuh, Taler, Bund, Eisentür, Speisekammer oder Gespenst. Ausnahmen sind H-1 und H-6.
- Stadttore und Burgzugang: keine Figur verlässt die Oberstadt (STADT-01, STADT-03). Tore kommen nur als Ort vor (bewohner.json, Zeilen 355, 528, 2055). Keine Figur betritt die Burg nach 23:00 (K-010).
- Uhrturm: Schläge und Zustand passen zu STADT-02 und STADT-05 (haeuser.json, Zeile 338; bewohner.json, Zeilen 50, 1693).
- Grün (K9): Nur R03 (karten.json, Zeile 6, Oberteil [5,2]) und R04 (Zeile 7, [5,4]) tragen Rampe 5 als Oberteil (rollen.json, Zeilen 78, 97). Die Bewohnerkleidung schließt Grün aus (pixel_engine/lib/src/figur/bewohner_karten.dart, Zeile 152). „grün“ im Bewohnertext betrifft Tee (bewohner.json, Zeile 2509).
- Silberhau: erfundenes Bergstädtchen laut K-001 (ANPASSUNG Zeile 31, O). ERSETZE-02 erfasst nur „Silberhauer“, das ist so gewollt.
- Reale Städte in den Rollen (Braunschweig, Wolfsburg, Göttingen, Gifhorn, Salzgitter, Tuzla, Opole): in K2-Herkunftszeilen (O) und in faehigkeiten.json (Zeilen 112, 321, 398, 451). Kein Widerspruch.
- Inschriften mit Hinweistext (H-026 Uhrturm ORT-01, H-058 ORT-04, H-104 ORT-05) sind an Fall-Orten und deshalb zulässig.
- Plagiat (Methode): Suche nach rund 40 Namen und Phrasen aus Filmen, Serien, Büchern und Liedern (u. a. Dracula, Nosferatu, Holmes, Watson, Potter, Hogwarts, Winnetou, Pippi, Asterix, Batman, Star Wars, „Der Mond ist aufgegangen“, „Guten Abend, gut' Nacht“, „Stille Nacht“, „Hänschen klein“, „Die Gedanken sind frei“, „Lili Marleen“, „Erlkönig“, „Lorelei“, „Hasta la vista“, „Möge die Macht“, „Der Pate“, „Elementar“, „Tatort“). Einziger Treffer: „Tatort“ als Gattungswort in faehigkeiten.json, Zeile 225 („nicht als Tatort“). Grenze: kein Abgleich mit externen Textdatenbanken. Die Prüfung ist Stichwort-basiert plus Lektüre.
- Entschieden, nicht als Befund gezählt (ENTSCHEIDUNGSLOG): E23 M5 (ohne die Dauer, siehe B-1), E27 H1 (R03 sichtbar nur für R03), E27 H2 (LISTE-ORTE nur Farbe; Grundlage für H-1 und H-5), E27 M2 (Teile im Code), E27 M5 (Täterin-Regel für Stadt-, Bewohner- und Häusertexte), E27 G3–G5 und G12, E29 B1 und B2 (B09: „Der Hund hatte nur Angst vor dem Dunkel“), E29 B9, E31 (B38).

## Nebenwirkungen

- `dart pub get --offline` hat packages/burgstadt_core/.dart_tool/ angelegt (ignoriert). Kein Build, keine Tests ausgeführt.
- `git status --short`: nur diese Berichtsdatei ist neu. HEAD 3999fc9. Kein Commit, kein Push, keine Datenänderung.

## Hinweise an den Aufrufer

- Für das Urteil zählt nur die Befundliste. Der Zähler Z-12 (ENTSCHEIDUNGSLOG, Zeile 183: „ja · ja · ja“) hat keinen Einfluss. Die Schlusszeile folgt dem Auftragsformat mit Beschriftung.
- Offene Frage zu H-2: Gilt ANPASSUNG Zeile 9 („Neue Stadt-Hinweise tragen nur die Einstufung Farbe, entlastend oder bestätigend“) auch für Bewohnerzeilen?
- Dieser Bericht gilt für den Stand 3999fc9.

Leitplanken eingehalten: ja · Kanontreu: nein · Plagiatsfrei: ja
