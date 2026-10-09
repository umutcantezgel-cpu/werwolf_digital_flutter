# Gegenprüfung Inhalt, vierte unabhängige Runde · Bericht A-702e

- Auftrag: A-702e (Z-12), Rolle Gegenprüfer Inhalt (Leitplanken, Kanon, Plagiat).
- Stand: Worktree `agent-a086c1396c5265d80`, HEAD `efc34fe`. Schritt 0 (`git merge --ff-only nachtlauf/burgstadt`) war ein reines Fast-Forward über 52 Commits.
- Datum: 09.10.2026.
- Unabhängigkeit: keine früheren Berichte unter `nachtlauf/auftraege/A-702/` gelesen.

## 1. Ergebnis in Kürze

Die Spieltexte halten die Leitplanken ein und sind plagiatsfrei. Kanontreu ist nicht erfüllt. Eine Stadtbewohnerin (B38) trägt im Nachtplan eine Saum-Zeile und eine Knopf-Zeile. Die Saum-Andeutung sollte laut Entscheidungslog (E27/M4, E29/B2) bereits gestrichen sein. Dazu kommt eine kleinere Zeitangabe außerhalb der geschlossenen Liste.

Befunde: hoch 0 · mittel 1 · gering 1. Hinweise ohne Befund: 11.

## 2. Umfang und Methode

- Scanner: `dart run bin/leitplanken.dart --burgstadt` im Paket `burgstadt_core`. Ergebnis: 119 Dateien geprüft, 0 Treffer, Exit 0.
- Abweichung vom Testbefehl: `dart pub get --offline` wurde von der Sicherheitsprüfung des Worktrees abgelehnt und nicht ausgeführt. Der Scanner lief trotzdem ohne Fehler. Das Repo blieb unverändert (`git status` sauber).
- Vollständig gelesen (Abnahme):
  - `packages/burgstadt_core/data/stadt/bewohner.json`: alle 44 Einträge, je Eintrag vollständig ausgegeben.
  - `packages/burgstadt_core/data/stadt/haeuser.json`: alle 160 Häuser.
  - `packages/burgstadt_core/data/innenraeume/haeuser.json`: alle 30 Vorlagen mit Namen und Legenden. Die Raster wurden gegen die Legenden geprüft. Nur Wand `#`, Boden `.` und das Strukturzeichen `t` sind nicht in der Legende definiert.
  - `packages/burgstadt_core/data/innenraeume/fallorte.json`: alle 12 Vorlagen mit Namen und Legenden, Raster wie oben.
  - `packages/burgstadt_core/data/rollen/faehigkeiten.json`: alle 20 Rollen.
  - `packages/burgstadt_spiel/data/texte/erzaehler.json` und `tutorial.json`: vollständig.
  - `packages/pixel_engine/data/figuren/karten.json` (66 Karten) und `rollen.json` (21 Figuren): vollständig. `teile_kleidung.json` (35 Teile) und `teile_koepfe.json` (38 Teile): Kennungen, Namen und Struktur gelesen. Die Geometriezahlen enthalten keinen Spieltext und wurden nicht einzeln gelesen.
  - `nachtlauf/kanon/ANPASSUNG.md`: vollständig. Die `HW-S`-Zeilen (L) wurden nur zur Prüfung der Einstufung gelesen, nicht zitiert.
  - `nachtlauf/ENTSCHEIDUNGSLOG.md`: E23, E27 und E29, dazu die Einträge E24 bis E28 im selben Abschnitt.
- Maßstab Kanon: alle `[O]`-Zeilen aus `krimidinner/spuk-im-gewoelbe/10_kanon/K1` bis `K9` (223 Zeilen) und aus `ANPASSUNG.md` (74 Zeilen). L-Zeilen wurden nicht zitiert.
- Gezielte Suche über alle Dateien: Alkohol und Gaststätten, Drogen, Herkunft und Volksgruppen, Hexen, Teufel und Vampir, Blut und Verletzung, fremde Titel und Figuren, Kanonbegriffe aus dem Harz, Zeitangaben, Merkmale der Täterin (R03).
- Keine Daten verändert, kein Commit, kein Push. Ein Hilfsskript im Scratchpad außerhalb des Worktrees wurde nach Gebrauch wieder entfernt.

Schwere: **hoch** = Leitplankenverstoß oder Kanonverstoß mit Spielwirkung auf Lösung oder Inhalt. **mittel** = sichtbare Abweichung von einer Stadt- oder Listenregel oder von einer beschlossenen Korrektur. **gering** = formaler Verstoß ohne Falllogik.

## 3. Befunde

### Befund 1 · mittel · Kanontreu

- Datei und Stelle: `packages/burgstadt_core/data/stadt/bewohner.json`, Zeile 2296 (B38 Hildegard Mosch, Nachtplan 04:00 bis 05:00, Feld `tut`) und Zeile 2309 (B38, Feld `saetze`).
- Zitat 1: „Sie steht auf und näht im Halbdunkel einen Saum, weil der Gedanke an eine Hochzeit sie nicht loslässt.“
- Zitat 2: „Den Knopf habe ich heute Nacht zweimal angenäht, weil die Hand vor Kälte nicht ruhig war.“
- Spielwirkung: `bewohnerErzaehlt` (`packages/burgstadt_core/lib/src/fall/simulation.dart`, Z. 218 bis 219) gibt das Feld `tut` beim Ansprechen zur Falluhr aus. Die Felder `saetze` und `gerede` zählen laut `stadtdaten_test.dart` (Z. 93 bis 107) ebenfalls zu den Spieltexten. Der Satz ist also im späten Abschnitt von Phase 3 (04:00 bis 04:30) und danach hörbar.
- Regel und Quelle:
  - Entscheidung E27/M4 (`ENTSCHEIDUNGSLOG.md`, Z. 190): „Die Saum-Andeutung ist gestrichen; es geht jetzt um einen Knopf.“ Entscheidung E29/B2 (Z. 220): „Der Saum bei H-S10/HW-S10 und H-104 ist gestrichen (Knöpfe).“ B38 ist in keinem der beiden Einträge erfasst. Die Korrektur ist unvollständig.
  - Kanon (O): Der Saum des Bettlakens hat einen fehlenden Streifen (K1 `BSO-06`, Z. 197; K3 `H-13`, Z. 33). Laut ANPASSUNG `ORT-05` (O, Z. 56) stammt das Gespensterlaken aus der Pension. Die Stadtzeile verbindet den Saum-Zustand mit einer Bewohnerin, die im Kanon nicht vorkommt, und eröffnet damit eine zweite, nicht vorgesehene Spur zum Laken.
  - Listenregel: `FORMAT.md`, Z. 24: „Was nicht in einer Liste steht, darf in Spieltexten nicht als Ort, lösungsrelevanter Gegenstand oder Zeitpunkt auftauchen.“ Der Knopf steht nicht in `LISTE-GEGENSTÄNDE` (K1, Z. 28). Nach E27/M4 soll der Knopf den Hinweis tragen, den der Saum vorher trug.
  - ANPASSUNG, Z. 9: Neue Stadt-Hinweise tragen nur die Einstufung Farbe, entlastend oder bestätigend. Hier fehlt jede Einstufung.
- Vorschlag: Beide Zeilen streichen oder neutral umformulieren. Beispiel für `tut`: „Sie steht auf und näht im Halbdunkel an einem Brautkleid, weil der Gedanke an eine Hochzeit sie nicht loslässt.“ Beispiel für `saetze`: „Die Nadel habe ich heute Nacht zweimal neu eingefädelt, weil die Hand vor Kälte nicht ruhig war.“ Danach E27/M4 und E29/B2 im Log präzisieren, damit die Umsetzung nachvollziehbar bleibt.
- Begründung der Schwere: eine einzelne Zeile, aber solutionsnah, spielbar und Wiederholung einer ausdrücklich beschlossenen Korrektur.

### Befund 2 · gering · Listenregel (Zeitpunkt)

- Datei und Stelle: `packages/burgstadt_core/data/stadt/bewohner.json`, Zeile 2095 (B35 Anneliese Gruber, Nachtplan 00:25 bis 03:00, Feld `tut`).
- Zitat: „… weil sie morgens um sieben im Rathaus sein muss.“
- Regel: `FORMAT.md`, Z. 24, und `LISTE-ZEITEN` (K1, Z. 29; ANPASSUNG, Z. 65). Die Uhrzeit 07:00 steht in keiner dieser Listen.
- Vorschlag: „… weil sie früh am Morgen im Rathaus sein muss.“
- Begründung: keine Falllogik berührt, aber formal außerhalb der geschlossenen Zeitliste.

## 4. Hinweise ohne Befund

- H1, `haeuser.json`, Z. 850 (H-066, Pulverkammer): „… Einmachgläser mit Deckeln in einer einzigen Handschrift.“ Das klingt an BSO-04 an (zwei Handschriften, K1, Z. 195). Kein Täterbezug. Empfehlung: Schriftmotiv in Stadttexten vermeiden.
- H2, `bewohner.json`, Z. 1933 bis 1934 (B32 Matthias Gerlach): „Schuhe erzählen das auch.“ Das spiegelt die Sohlen-Logik (K5-MECHANIK `IF-3`, K3 `H-15`), ohne Gegenstands- oder Täterbezug.
- H3, `haeuser.json`, Z. 666 (H-051, Scherenschleifer): Dieser Beruf ist historisch mit Roma-Klischees verknüpft. Hier ist er neutral und ohne Zuschreibung. Beim Ausbau nichts Fahrendes oder Herkunftsbezogenes ergänzen.
- H4, Stablampe „HODŽIĆ VT · 3“ (K1 `BSO-03`, Z. 194; K3 `H-28`, Z. 48): Der Name identifiziert den Eigentümer. Daraus wird keine Herkunftsaussage gezogen. Grenzfall, aber kein Befund.
- H5, `rollen/faehigkeiten.json`, Z. 142 (R06, Feld `details`): „eine Weile benommen“ weicht vom wirksamen Kanon „Kurz benommen“ (ERSETZE-17) ab. Das Feld wird nicht angezeigt. `packages/burgstadt_core/lib/src/fall/faehigkeiten.dart`, Z. 45, nutzt nur Sichtschicht und Zeigt-Text. Bei künftiger Anzeige auf „kurz“ anpassen.
- H6, Kanon-intern (nicht App): K1 `@K-011` [O] (Z. 65) trägt die Notiz „Das wissen anfangs nur Adnan und der Burgwart“, obwohl der Datensatz als öffentlich klassifiziert ist. Hinweis an den Kanon-Autor.
- H7, `haeuser.json`, Haus H-139: Dort wohnt laut Beschreibung eine Enkelin, im Datensatz ist nur B08 als Bewohner geführt. Konsistenz, kein Befund.
- H8, Geschlechtermuster: Angst- und Schreckwörter kommen bei Frauen und Männern etwa gleich selten vor und meist nicht bei der Figur selbst. Das Muster aus E29/B2 ist nicht mehr erkennbar. Gossip-Zuschreibungen („neugierig“, „Kaffee“, „Kuchenrunde“) finden sich bei B16, B33, B29 und B38, Gegenstücke bei Männern bei B04, B24 und B39. Das sind Einzelfiguren, kein systematisches Klischee.
- H9, Kulturdetails in den Kanonzeilen (K2, K9: u. a. Pierogi, Newroz, Bağlama, Sevdalinke) sind an Einzelpersonen gebunden und keine Gruppenaussagen.
- H10, Figur R03 und R04: `schuhe-stiefel` und `schuhe-arbeitsschuhe` zusammen sind beabsichtigt. Der Wanderstiefel ist ein Stiefel mit Arbeitsschuh-Sohle (`packages/pixel_engine/test/karten_test.dart`, Z. 13). Kein Befund.
- H11, unbenutzte Teile `kopf-kopftuch` und `frisur-afro`: nur definiert, keine Figurenkarte verwendet sie. Entspricht E27/G4.

## 5. Bereits entschiedene Abwägungen (Auftrag Punkt 9a)

| Eintrag | Stand |
|---|---|
| E23/M5 und E29/B1: „bewusstlos“ wird zu „benommen“ (ERSETZE-17) | umgesetzt (ANPASSUNG, Z. 28), nicht gezählt |
| E27/H1: „Spur verwischen“ nur für R03 | nicht gezählt |
| E27/M5: Kanon-Spuren; die Täterinnen-Regel gilt für Zusatztexte | nicht gezählt. Geprüft: Stadttexte enthalten keine Merkmale von R03 (Haarspange, Strickjacke, Wanderstiefel, Stollen, Sommersprossen). Keine Treffer. |
| E27/M2 (Teile im Code), G3 („Einspruch!“), H2 (Stadtnamen in LISTE-ORTE) | nicht gezählt |
| E27/M3 (Nachtpläne B03, B07, B10) | umgesetzt, geprüft |
| E27/M4 (Saum zu Knopf) | **nicht umgesetzt**, siehe Befund 1 |
| E27/G10 und G12; E29/B2 (Angst), B3, B4 bis B8 | umgesetzt, geprüft (keine „verlaufen/verirren“-Echos, kein „Wirtin“, LISTE-ZEITEN ergänzt) |

## 6. Leitplanken, Kanon und Plagiat im Einzelnen

- Alkohol und Drogen: keine Treffer. Der Punsch ist durchgehend alkoholfrei (`erzaehler.json`, K8 `GL-14`). „Krautfass“ im Gemüseladen (`innenraeume/haeuser.json`) meint Sauerkraut, kein Befund.
- Herkunft: keine Herkunftsangabe in den Stadt- und Spieltexten, keine Nationalitätsbegriffe (keine Treffer für Rumän, Roma, Sinti, Zigeun, Türk, Kurd, Bosn, Polen). Die Herkunft der Clique (K2) wird in den Spieltexten nicht als Motiv, Indiz oder Pointe verwendet (siehe H4).
- Klischees: keine Gruppenklischees gefunden (siehe H3, H8, H9).
- Verletzung und Blut: nur Beule, benommen, Kühlpack und die verneinte „offene Wunde“. Keine Blutdarstellung.
- Hexen, Walpurgis, Teufel, Vampir: keine Treffer.
- Kein Text, der die Täterin vor der Auflösung nahelegt: Stadttexte ohne Merkmale der Täterin (siehe Abschnitt 5). Befund 1 betrifft keine Täterin.
- Original statt Kopie: keine Figuren, Titel oder Zitate aus Filmen, Serien, Spielen, Büchern oder Liedern gefunden. Geprüft per Stichwortliste, u. a. Harry Potter, Sherlock Holmes, Poirot, Frodo, Asterix, Pumuckl, Winnetou, Struwwelpeter, Dracula, Nosferatu, Happy Birthday, Tatort, Cluedo. „Nebelriese“ ersetzt das Brockengespenst (ERSETZE-04 ff.). „Glück auf“ ist ein gemeinfreier Bergmannsgruß.
- Ton: kein Befund.

## 7. Verdikt

- Leitplanken: eingehalten. Der Befund 1 berührt sie nicht.
- Kanon: nicht eingehalten, wegen Befund 1 (mittel). Nach dessen Korrektur ist die Kanontreue gegeben. Befund 2 (gering) ändert das Urteil nicht.
- Plagiat: keines gefunden.

Leitplanken eingehalten: ja · Kanontreu: nein · Plagiatsfrei: ja
