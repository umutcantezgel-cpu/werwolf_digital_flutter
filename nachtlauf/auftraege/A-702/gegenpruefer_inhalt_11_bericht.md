HEAD 3092813

# Gegenprüfung Inhalt, Runde 11 (Auftrag A-702l)

Geprüfter Stand: HEAD 3092813. Schritt 0 war ein Fast-Forward von fb0ec24 auf nachtlauf/burgstadt; der Worktree war davor und danach sauber. Keine Daten geändert, kein Commit, kein Push, kein Build. Hilfsdateien liegen nur im Scratchpad unter gp11/.

## 1. Ergebnis in Kürze

- Befunde: hoch 0 · mittel 0 · gering 7
- Der Scanner meldete 0 Treffer. Die manuelle Lektüre ergab sieben geringe Befunde zu Altersklischees, einer Gruppensprache, einer Inkonsistenz zu E39 B-07 und zwei Formulierungen mit Fehlspur- bzw. Ritual-Anklang.
- Keine Verstöße gegen Alkohol, Drogen, Blut, Hexen, Teufel oder Herkunft als Motiv. Keine erkennbaren Kopien.

## 2. Werkzeuge und Testbefehl

- `dart` steht nicht im PATH. Verwendet: `/opt/flutter/bin/cache/dart-sdk/bin/dart` (Dart 3.13.5), im Verzeichnis packages/burgstadt_core.
- `dart pub get --offline`: ok. packages/burgstadt_core/pubspec.lock nach dem Lauf byte-gleich zur Sicherung.
- `dart run bin/leitplanken.dart --burgstadt`: Geprüfte Dateien 119, Summe 0 Treffer (0 Fehler, 0 Warnungen), Exit 0.
- Funktionsprobe des Scanners mit einer Hilfsdatei im Scratchpad: Wein, Blut, Hexe, Dracula und Teufel als FEHLER erkannt, Gasthaus als Warnung. Der Scanner arbeitet.
- Ausnahmen aus nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md gegen den Kontext geprüft: In K8 und K9 nur als englische Negativ-Anweisungen („no wine, no beer, no drinks, no witches“). In K2-ROLLEN-13-20 und ANPASSUNG nur als Haustier („alten Kater namens Paşa“). In K4-GESPRAECHE-P2 nur als Vergleich („quietscht wie ein hungriger Kater“). Zulässig.
- Grenze des Scanners: Er erkennt weder Andeutungen noch Kopien. Beides ist durch Lektüre und gezielte Suchen geprüft (Abschnitt 5).

## 3. Umfang und Abnahme

- Vollständig gelesen (Textwerte): packages/burgstadt_core/data/stadt/bewohner.json (44 Bewohner), stadt/haeuser.json (160 Häuser), innenraeume/fallorte.json, innenraeume/haeuser.json (Raum- und Legendennamen), rollen/faehigkeiten.json; packages/burgstadt_spiel/data/texte/erzaehler.json und tutorial.json; packages/pixel_engine/data/figuren/rollen.json (alle Felder außer Farbindizes), karten.json (Teilelisten aller 66 Figuren), teile_kleidung.json und teile_koepfe.json (Teil-IDs und Primitivformen); nachtlauf/kanon/ANPASSUNG.md (160 Zeilen); LEITPLANKEN-AUSNAHMEN.md.
- Maßstab: alle [O]-Datensätze (223 Zeilen) aus K1, K2 (drei Dateien), K3-HINWEISE.md, K5-ENTSCHEIDUNGEN-DETEKTIV, K5-MECHANIK, K6, K7, K8 und K9. Die Phasendateien K3-P*, K4-P* und K5-P* enthalten keine [O]-Zeilen (gezählt) und wurden nur zur Widerspruchsprüfung herangezogen. L-Zeilen wurden nur zur Widerspruchsprüfung gelesen und nicht zitiert.
- Entscheidungslog E23, E27, E29, E31, E33, E34, E35, E37, E38 und E39 vollständig gelesen.
- Frühere Berichte in nachtlauf/auftraege/A-702/ nicht gelesen.
- Einschränkungen der Abnahme: Die ASCII-Raster (Felder karte in innenraeume/*.json) wurden nicht zeichenweise gelesen, nur die Legendennamen. Geometrische Zahlen der Figurenteile wurden nicht gelesen, nur IDs und Primitivformen (Kegel, Spitze). Farbpalettenindizes (rampe, stufe, materialien) sind nicht in Farbnamen übersetzt; Farbtreue ist Aufgabe der Sichtprüfung (A-605).

## 4. Befunde

Schwere gering (7). Keine Befunde hoch oder mittel.

### G1 · gering · Altersklischee · packages/burgstadt_core/data/stadt/bewohner.json, Zeilen 978 und 925

- Stelle: B16 Irmgard Roth, Feld gerede und beruf.
- Zitat: „Man erzählt, Irmgard habe den Nebelriesen gerufen, aber sie ruft nur ihre Katze, und die kommt nie.“ · beruf: „Witwe und Nachbarin“.
- Regel: Leitplanke „keine Klischees über ... irgendeine andere Gruppe“. E34 und E37 haben Altersverallgemeinerungen an konkrete Personen gebunden; die Pointe selbst bleibt aber das Klischee der einsamen alten Frau mit Katze.
- Vorschlag: Pointe ohne Tier und ohne Altersbild formulieren. Das Feld beruf ohne Statusbegriff: „Witwe“ ist kein Beruf, z. B. „Nachbarin“ oder ein konkreter Erwerb.

### G2 · gering · Altersklischee-Muster · bewohner.json, Zeilen 1945 bis 1995 (B33); haeuser.json, Zeile 1392 (H-110)

- Stelle: B33 Elfriede Ahrens. beruf „Witwe“ (Zeile 1945). wesen „Freundlich und langsam, sie hat eine Stimme wie Honig …“ (1948). zubehoer „Häkelbeutel“ (1966). tut „… die Decke mit den Häkelkanten über den Beinen.“ (1975). saetze „… wie ein Kuchen unter Schnee. Heute Nacht war er ohne Zucker.“ (1995). Dazu H-110: „seine Witwe pfeift noch immer jeden Abend“.
- Muster: Dutt-Frisur bei allen sieben Bewohnerinnen B01, B05, B13, B33, B35, B38 und B43 (Feld frisur „dutt“). Zusammen mit Häkeln, Honig, Kuchen und Witwenstatus entsteht das Bild der Großmutter als Klischee.
- Regel: wie G1. E37 hat die Generalisierung zwar konkretisiert, die Figur trägt aber das Gruppenbild weiter.
- Vorschlag: beruf auf einen Erwerb umstellen, z. B. „Rentnerin, früher Apothekenhelferin“. Häkel- und Kuchenbilder streichen, „langsam“ durch ein neutrales Wesensmerkmal ersetzen. Bei den Dutt-Figuren mindestens eine Frisur variieren (Sichtprüfung).

### G3 · gering · Inkonsistenz zu E39 B-07 · bewohner.json, Zeilen 2640 und 2583 (B43)

- Zitat: „Man sagt, die alte Schöning lese dem Nebelriesen aus den Büchern vor, …“ (2640). wesen „Hellwach im Kopf und langsam im Gang“ (2583).
- Regel: E39 B-07 hat „die Alte“ bei B16 und B33 entfernt. Bei B43 steht dieselbe Formulierung weiter.
- Vorschlag: „Frau Schöning“. Die Wendung „langsam im Gang“ streichen oder neutral fassen.

### G4 · gering · Gruppensprache · bewohner.json, Zeile 2118 (B35)

- Zitat: „Im Rathaus flüstert man, die Putzfrau habe den Nebelriesen beim Wischen gesehen …“
- Der Datensatz führt im Feld beruf selbst „Reinigungskraft im Rathaus“. E38 hat „Hausfrau“ zu „Hausherrin“ vereinheitlicht; diese Stelle bleibt außen vor.
- Vorschlag: „die Reinigungskraft“.

### G5 · gering · Altersklischee in Hausbeschreibungen · packages/burgstadt_core/data/stadt/haeuser.json, Zeilen 1116 (H-088) und 1454 (H-115)

- H-088: „Eine ältere Dame zählt die Stufen seit Jahren laut, und sie hat sich noch nie verzählt.“
- H-115: „Die Großmutter kocht daraus ein Mus, das gegen jede Erkältung helfen soll, und niemand widerspricht ihr.“
- Vorschlag: H-088 ohne Altersangabe, z. B. „Jemand aus dem Haus zählt …“. In H-115 den Schluss „und niemand widerspricht ihr“ streichen.

### G6 · gering · Fehlspur-Risiko · haeuser.json, Zeile 1690 (H-134)

- Zitat: „Er sagt, er könne jeden Stein im Dunkeln erkennen, und das hat er heute Nacht auch getan.“
- Problem: Die Stelle behauptet eine nächtliche Aktivität einer Bewohnerperson ohne Bezug zu Kanon oder Stadt-Hinweisen. Das ist eine ungedeckte Spur. Für neue Stadt-Angaben gilt laut ANPASSUNG nur Farbe, entlastend oder bestätigend.
- Vorschlag: „… und das kann er auch ohne Licht.“

### G7 · gering · Begriff mit Ritual-Anklang · packages/burgstadt_core/data/innenraeume/fallorte.json, Zeile 959

- Stelle: Name „Opfertisch mit Kerzen“ (Raum innen-kirche).
- Problem: „Opfer“ ist im Krimi der Verletzte. Der Begriff evoziert zudem einen Ritus und verwechselt sich mit dem Burgwart als Opfer; das passt nicht zur Linie „Gänsehaut mit Humor“.
- Vorschlag: „Gabentisch mit Kerzen“.

## 5. Geprüft, ohne Befund

- Alkohol und Drogen: keine Treffer in den Textdateien. Der Punsch wird ausdrücklich alkoholfrei beschrieben (erzaehler.json: „Der Punsch im Gewölbe ist warm und alkoholfrei.“). Die Stadt kennt als Verkaufs- und Aufenthaltsorte nur Teestube, Bäckerei, Apotheke, Pension und Läden. H-116 „Herberge der Bergleute“ ist historisch und ohne Ausschank.
- Blut und Verletzung: nur Beule, benommen (ERSETZE-17) und Kühlpack. Kein Blut und keine Platzwunde. „bewusstlos“ kommt in den Daten nicht mehr vor.
- Hexen, Walpurgis, Teufel: keine Texte. Figuren: kopf-hut und kopf-filzhut sind Krempen mit Kopfteil (Zylinder), keine Spitzen. Keine Horn- oder Fangteile. oberteil-cape-kurz ist ungenutzt, umhang-tuch ist ein Tuch (B13, B43).
- Herkunft: nirgends als Motiv, Indiz oder Pointe. Familienfelder bleiben im Overlay (E38).
- Täterin: keine Zusatztexte, die R03 nahelegen. Geprüft auf Stollen, Stiefel, Wehrgang, Dunkelangst, Taler, Schlüssel, Laken, Stablampe, Sicherung und Eichentür. Nur generische Verweise (Dunkel, Wehrgang der Kirchenburg).
- Kanon-Gegenstände (Schlüssel, Taler, Laken, Stablampe, Kerzenständer, Blechdose, Sicherungskasten, Bienenwachs): nur in den Listen oder als Farbe.
- Kanontreu (Querprüfung):
  - R01 bis R20: Beruf, Kleidung, Zubehör, Frisur, Bart und Brille in rollen.json und karten.json stimmen mit K2-STAMM und K9-LF überein. Abweichungen sind im Datensatz als Näherung markiert (R12, R14, R20 als Weste).
  - Zeiten: Uhrturm 00:25, 01:30, 03:00, 04:30; Stadttore 22:00; Knall 23:58; Bäckerei 03:00. Diese stimmen mit LISTE-ZEITEN und den STADT-Zeilen überein. Nachtplan-Zeiten stehen nur im Datenfeld, nicht im Spieltext (E27 G7).
  - Orte: Stadtorte und Hausnamen laufen unter LISTE-ORTE (als Farbe).
  - Overlay: Silberhau, Bergland, Herkunft des Burgwarts und das Stadtwerk sind konsistent. Keine Reste der ersetzten Begriffe (Harz, Brocken, Silberhauer) in den Daten.
- Plagiat: Keine Figuren, Namen oder Sätze aus Filmen, Serien, Spielen, Büchern oder Liedern gefunden. Geprüft wurden über 100 Namen, Titel und Liedanfänge (u. a. Dracula, Holmes, Cluedo-Figuren, Columbo, Harry Potter, Tolkien, Nosferatu, Kinderlieder). Ohne Treffer mit Bezug: „Tatort“ (allgemeines Wort, auch im Kanon) und „mustard“ (Farbangabe in K9). Ohne Netz-Abgleich.

## 6. Entschiedene Abwägungen (Punkt 9a): geprüft, nicht als Befund gezählt

- E23 M5 (Kanon-Spuren zeigen auf die Täterin): bleibt. Die Zusatztexte sind frei von Täterhinweisen (Abschnitt 5).
- E23 und E29 B1 (bewusstlos zu benommen über ERSETZE-17): wirksam, in den Daten kein „bewusstlos“ mehr.
- E27 H1 (Fähigkeit R03 nur für R03): bestätigt. faehigkeiten.json, R03: Wirkung nur für die Spielerin von R03.
- E27 M2 (Teile im Code): kopf-hut und kopf-haube als Formen geprüft (Abschnitt 5).
- E27 G3 („Einspruch!“ bei R18): Kanon-Wortlaut, nicht gezählt.
- E27 H2 (LISTE-ORTE als Farbe): bestätigt.
- E29 B2 (Angst-Muster): bestätigt. Nur „wenn sie Angst hat“ (bewohner.json, Zeile 1696), generisch.
- E33 (Stollen zu Schacht, Laternen als getragenes Licht): bestätigt. „Stollen“ kommt in den Daten nicht vor.
- E34 B-1 (Uhrzeiten als Aussagen): nicht gezählt. E34 B-2 (Altersgruppen): Restbestände als G1 bis G5 mit neuem Grund.
- E35 (B09 Hund, Wehrgang): bestätigt. bewohner.json: „Der Hund wollte heute nur nicht allein sein.“
- E37 (offene Teile R19 Kameragurt, R02 Kopfhörer): umgesetzt in karten.json.
- E38 B1 (Familienfelder per Overlay): In den betroffenen Rollen sind alle Feste, Speisen und Instrumente im Familienfeld ersetzt. R10 (Biikebrennen) und R20 (Masurische Seen) bleiben wie entschieden. Nicht gezählt.
- E38 B2 (Wanderstiefel aus zwei Teilen): karten.json, nur R03 und R04 tragen beide Teile. Nicht gezählt.
- E38 Talg und Bienenwachs: bestätigt (haeuser.json, H-108 Kerzen aus Talg).
- E39 B-03 (Knöpfe nur im Kostümfundus): bestätigt (haeuser.json, H-104; ANPASSUNG H-S10).
- E39 B-07 (B16 und B33 ohne „die Alte“): bestätigt, aber B43 bleibt. Siehe G3.
- E39 B-08 (Großmutter lebt im Haushalt und lenkt die Familie): Nach dem Kriterium von E39 bleibt nur R05, dort ohne ausdrückliche Lenkung („die drei Frauen am Küchentisch“, ANPASSUNG, Zeile 72). R13 wohnt zwei Straßen weiter, R18 ruft nur an. Die Entscheidung trägt. Ein Restmuster (Großmutter als Haushalts- oder Fallinstanz bei R13 und R18) notiere ich als Beobachtung, nicht als Befund, da kein neuer Grund vorliegt.
- E39 B-10 (frisur-afro und kopf-kopftuch ungenutzt): bestätigt, karten.json enthält beide nicht.
- E39 B-11 (Teil-Kennungen als Formen): nicht gezählt.

## 7. Urteil

- Leitplanken eingehalten: ja. Keine Verstöße hoch oder mittel. Die sieben geringen Befunde G1 bis G7 sind Verbesserungsvorschläge zu Altersklischees, Gruppensprache und Formulierungen.
- Kanontreu: ja. Keine Widersprüche zwischen den Zusatzdaten und den O-Datensätzen gefunden.
- Plagiatsfrei: ja, mit der Einschränkung, dass kein Netz-Abgleich erfolgt ist.

Leitplanken eingehalten: ja · Kanontreu: ja · Plagiatsfrei: ja
