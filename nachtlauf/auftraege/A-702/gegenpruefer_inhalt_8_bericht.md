HEAD 9097217

# Gegenprüfung Inhalt, Runde 8 (Auftrag A-702i)

**Ergebnis:** Leitplanken eingehalten: nein · Kanontreu: nein · Plagiatsfrei: ja
**Befunde:** hoch 0 / mittel 1 / gering 4 · Hinweise (kein Befund): 10

## 1. Stand, Schritte, Umfang

- Schritt 0: `git merge --ff-only nachtlauf/burgstadt`. Der Worktree stand danach auf 9097217 (70 Commits vorgerückt, vorher fb0ec24). Versionierte Dateien sind unverändert (`git status` und `git diff` leer).
- Testbefehl: `dart pub get --offline` (ok; `pubspec.lock` unverändert, `.dart_tool` ist git-ignoriert) und `dart run bin/leitplanken.dart --burgstadt`: 119 Dateien, 0 Treffer, 0 Fehler, 0 Warnungen.
- Vollständig gelesen:
  - `nachtlauf/kanon/ANPASSUNG.md`, `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md`, `krimidinner/spuk-im-gewoelbe/10_kanon/FORMAT.md`.
  - `nachtlauf/ENTSCHEIDUNGSLOG.md`, Abschnitte E23, E27, E29, E31, E33, E34, E35.
  - `packages/burgstadt_core/data/stadt/bewohner.json` (44 Bewohner), `stadt/haeuser.json` (160 Häuser), `rollen/faehigkeiten.json` (20 Rollen).
  - `packages/burgstadt_core/data/innenraeume/fallorte.json` (12 Räume, komplett inklusive Gitter und Legende) und `innenraeume/haeuser.json` (30 Räume; Legenden und Stationen gelesen, das ASCII-Gitter nur über die Legende).
  - `packages/burgstadt_spiel/data/texte/erzaehler.json` und `tutorial.json`.
  - `packages/pixel_engine/data/figuren/karten.json` (66 Karten) und `rollen.json` (21 Figuren) komplett. Bei `teile_kleidung.json` und `teile_koepfe.json` wurden ID, Art, Form, Knochen und Material gelesen; Geometriewerte (Koordinaten, Größen) nicht einzeln, weil sie keinen Textbezug haben.
- Kanon-Maßstab: alle 223 O-Zeilen der K-Dateien (K1, K2 in drei Dateien, K3-HINWEISE, K5 Detektiv und Mechanik, K6, K7, K8, K9) und `ANPASSUNG.md`. L-Zeilen wurden nur zur Widerspruchsprüfung herangezogen und nicht zitiert.
- Ergänzend, nur lesend: `pixel_engine/lib/src/palette.dart`, `figur/teile_basis.dart`, `figur/bewohner_karten.dart`, `pixel_engine/lib/src/figur/portraet.dart`, `burgstadt_core/lib/src/kanon/kanon.dart`, `burgstadt_spiel/lib/src/bildschirme/erkundung.dart`, sowie die Tests `pixel_engine/test/karten_test.dart` und `rollen_daten_test.dart`.
- Nicht geöffnet: `nachtlauf/auftraege/A-702/` (keine früheren Berichte). Angelegt: nur diese Berichtsdatei. Kein Commit, kein Push, keine Datendatei geändert.

## 2. Befunde

### B1 · mittel · Signaturstück von R19 (roter Kameragurt) fehlt im Bild

- Datei: `packages/pixel_engine/data/figuren/karten.json`, Zeile 22 (R19). Quelle: `packages/pixel_engine/data/figuren/rollen.json`, Zeile 388 (merkmale).
- Stelle: `teile` = frisur-kurz, bart-kinnbart, oberteil-arbeitsjacke, oberteil-hemdkragen, schuhe-arbeitsschuhe, kamera. Kein Material von R19 liegt auf Rampe 3 (rot). Das Teil „kamera“ ist laut `packages/pixel_engine/lib/src/figur/teile_basis.dart`, Zeile 84, ein Quader von 0,05 × 0,035 × 0,03 m im Material „handy“ (dunkel). Einen Gurt gibt es nicht.
- Zitat: K2-ROLLEN-13-20.md, Zeile 61 (R19-STAMM [O]): „Signaturstück: ein breiter roter Kameragurt quer über der Brust“. K9-LOOKBIBEL.md, Zeile 84 (LF-R19 [O]): „a wide red camera strap across his chest“.
- Regel: Kanon-Maßstab (O-Datensatz R19-STAMM, Konsistenzanker LF-R19). Das Signaturstück ist im Kanon nach Farbe und Breite festgelegt.
- Vorschlag: Gurt als Teil ergänzen (schmales Band quer über die Brust, Material Rampe 3). Wird das in 2,5D nicht umgesetzt, die Ausnahme wie E27/M1 (Armbanduhr) ins Entscheidungslog eintragen.

### B2 · gering · Verallgemeinerungen über Altersgruppen (Leitplanke „keine Klischees über andere Gruppen“)

- Datei: `packages/burgstadt_core/data/stadt/bewohner.json`
  - Zeile 303 (B05, gerede): „…aber die Kinder erfinden alles, sobald es dunkel wird.“
  - Zeilen 913–914 (B15, saetze): „…die Alten schlafen fest.“ und „Meine Schützlinge schlafen wie Kinder, wenn man sie lässt.“
  - Zeile 1755 (B29, saetze): „…frag die Alten.“
- Regel: Leitplanken, verbindlich: „keine Klischees … über … irgendeine andere Gruppe“. E34/B-2 hat Altersgruppen-Verallgemeinerungen bereits als Befund behandelt und auf konkrete Personen umgestellt. Diese drei Stellen gehören zur selben Kategorie.
- Vorschlag: auf konkrete Figuren beziehen. Beispiele: B29 „Frag Frau Teutsch, die sitzt nachts am Fenster.“ (B13 ist 00:25–02:15 am Fenster wach). B15: „wie Kinder“ streichen und „die Alten“ durch „Frau Lang“ ersetzen. B05: die Verallgemeinerung streichen oder an eine genannte Person binden.

### B3 · gering · Orte, die nicht in LISTE-ORTE stehen

- Datei: `packages/burgstadt_core/data/stadt/bewohner.json`
  - Zeile 1696 (B28, saetze): „Hast du die Glockenhalle gesehen? …“
  - Zeile 528 (B09, Nachtplan, Feld „tut“): „…hört im Nebel ein Bellen aus der Gasse am Untertor.“
- Regel: `nachtlauf/kanon/ANPASSUNG.md`, Zeile 64 (LISTE-ORTE [O]): „Was nicht in einer Liste steht, darf in Spieltexten nicht als Ort … auftauchen.“ „Glockenhalle“ und „Gasse am Untertor“ stehen weder in LISTE-ORTE noch in der Stadtdatei. Dort gibt es „Glockenhaus der Gießerei“ (H-047) und das Stadttor „Untertor“.
- Vorschlag: „Glockenhalle“ durch „Glockenhaus der Gießerei“ ersetzen. „Gasse am Untertor“ auf eine Gasse der Stadtdatei umstellen oder in LISTE-ORTE ergänzen. Prüfen, ob der Nachtplan-Text im Spiel angezeigt wird.

### B4 · gering · Stationsnamen nennen Objekte, die im Raum fehlen

- Datei: `packages/burgstadt_core/data/innenraeume/fallorte.json`
  - Zeile 651 (innen-baeckerei): Station „vor dem Kachelofen“. Die Legende hat nur „Backofen“.
  - Zeile 745 (innen-rathaus): Station „vor der Bürgermeistertafel“. Die Legende hat keine Tafel, nur „Wappen an der Wand“.
  - Zeile 830 (innen-bibliothek): Station „am Archivpult“. Die Legende hat „Lesepult“ und „Archivschrank“, aber kein Archivpult.
- Regel: `ANPASSUNG.md`, Zeile 116 (H-S16 [O]): „Der Kachelofen wird mit Holz geheizt …“, und Zeile 120 (H-S17 [O]): „Im Rathaus hängt eine Tafel mit allen Bürgermeistern …“. Stationsnamen erscheinen im Spiel als Meldung (`burgstadt_spiel/lib/src/bildschirme/erkundung.dart`, Zeile 374: „<Name>: Hier lohnt ein genauer Blick.“).
- Vorschlag: Stationsnamen an die vorhandenen Objekte angleichen (am Backofen, am Wappen, am Lesepult) oder die fehlenden Objekte (Kachelofen, Bürgermeistertafel) in die Legende aufnehmen.

### B5 · gering · Kopfhörer von R02 fehlt

- Datei: `packages/pixel_engine/data/figuren/karten.json`, Zeile 5 (R02). Quelle: `rollen.json`, Zeile 65 (merkmale „großer Kopfhörer um den Hals“, zubehoer leer).
- Stelle: `teile` = frisur-locken-lang, oberteil-hoodie, schuhe-sneaker-hell. Kein Kopfhörer-Teil.
- Zitat: K2-ROLLEN-KERN.md, Zeile 16 (R02-STAMM [O]): „Kleidung: schwarzer Hoodie, weiße Turnschuhe mit glatter Sohle, Kopfhörer um den Hals“. K9-LOOKBIBEL.md, Zeile 67 (LF-R02 [O]): „large headphones around her neck“.
- Regel: Kanon-Maßstab (Kleidung). Das Zubehör-Vokabular ist eingefroren (`pixel_engine/test/rollen_daten_test.dart`, A-601a) und kennt keinen Kopfhörer, deshalb steht er nur im Text.
- Vorschlag: Teil „kopfhoerer“ (Bügel über dem Hals, zwei Muscheln) ergänzen und das Vokabular erweitern. Alternativ die Abweichung im Log festhalten.

## 3. Hinweise (kein Befund)

H1. Kleine Kanon-Details ohne Teil (2,5D-Grenze): R01 Multitool; R03 Haarspange; R05 Kugelschreiber im Revers; R07 Anstecker; R08 Ohrringe (Vokabel „ohrringe“ vorhanden, aber kein Teil); R10 Bleistift; R11 Saturn-Aufnäher und Rotlicht-Stirnlampe; R12 Zollstock; R13 rote Granatapfel-Brosche; R14 Tischlerbleistift; R15 Einstecktuch; R16 Manschettenknöpfe; R18 Anstecker „Einspruch!“; R20 Fuchs-Silhouetten. Bereits entschieden sind die Armbanduhr von R04 (E27/M1) und die Feder von R17 (E34). Vorschlag: die übrigen Items im Log ausdrücklich als nicht darstellbar führen.

H2. Sohle R03/R04: karten.json, Zeilen 6–7, haben Stiefel plus „schuhe-arbeitsschuhe“. Der Kommentar in `pixel_engine/test/karten_test.dart`, Zeile 12, nennt „Stiefel mit Arbeitsschuh-Sohle“. Der Kanon (K3-HINWEISE.md, Zeile 35, H-15 [O]) unterscheidet bei Merle und Jonas einen Stollen und bei Adnan ein Kreuzprofil. Im Bild ist das nicht unterscheidbar. Kommentar angleichen.

H3. Typnäherungen: R05 „Cordblazer“ als Uniformjacke; R07 und R19 „Lederjacke“ als Arbeitsjacke; R13, R15 und R16 Hosenanzug, Blazer und Sakko als Uniformjacke; R17 „Lederhut“ als Filzhut (E29/B9 entschieden).

H4. Farbton: R16 „anthrazitfarbenes Sakko“ liegt auf Neutral Stufe 4 (karten.json, Zeile 19), R12 „anthrazitfarbene Steppweste“ auf Stufe 3 (Zeile 15). Gleicher Kanonwert, zwei Töne. R05 „Jeans“ ist dunkelgrau (Stufe 3); der Kanon nennt keinen Farbwert.

H5. Anklänge ohne Regelverstoß: „einen Lappen über den Hauseingang gehängt“ (haeuser.json, Zeile 1044, H-082; Nähe zum Laken-Motiv). „Kehrbesen“ (bewohner.json, Zeile 1006, Schornsteinfeger-Attribut, kein Hexenmotiv). „Gebetsstreifen“ (haeuser.json, Zeile 1430, H-113; ungeklärter Brauch ohne Gruppenbezug, neutral formulieren oder streichen). „Die Arbeit sieht keiner.“ (bewohner.json, Zeile 2113, B35; Selbstbild, nahe an einem Gruppenklischee). „Kindern, die sich vor alten Gegenständen nicht fürchten“ (bewohner.json, Zeile 1355, B23; Grenzfall zu B2). „Eine Fliege im Bernstein …“ (B25; gemeinfreies Motiv, kein Zitat).

H6. Widerspruch in der Figur B29: Die Aussage „Ich war um Mitternacht im Bett“ (bewohner.json, Zeile 1755) steht gegen den eigenen Nachtplan (00:25–01:00 „am Fenster … wach“). Der Nachtplan wird nicht angezeigt (E27/G7), die Aussage schon.

H7. Arbeitsorte: B15 arbeitet in H-019 („Haus zum Lindenbaum“, betretbar: false, ohne Hinweis auf eine Pflegeeinrichtung). B35 ist „Reinigungskraft im Rathaus“, hat aber arbeitshaus: null (Rathaus = H-030).

H8. Stil: In 40 von 44 „gerede“-Texten steht derselbe Satzbau („Man sagt/erzählt/munkelt, der Nebelriese …“). Kein Regelverstoß, aber eintönig.

H9. Zubehör bei Bewohnerfiguren: Notizbuch und Laterne werden laut `bewohner_karten.dart` bewusst nicht gezeichnet. Ohne Teil fehlen daher auch Ölkanne (B02), Mehlsieb (B03) und Fernglas (B05). Dokumentiert, kein Befund.

H10. Außerhalb des Prüfumfangs: Im Entwurfsordner `10_kanon/entwuerfe/` ordnen Entwürfe Herkunftsgruppen belastete Funktionen zu. Das ist nicht Maßstab und wurde nicht bewertet. Falls ein solcher Entwurf in den Kanon oder in Spieltexte übernommen wird, greift die Herkunfts-Leitplanke.

## 4. Entscheidungen aus dem Log

Geprüft und übernommen:
- E23/E29 (bewusstlos zu benommen): Die Ersetzung ist umgesetzt (`burgstadt_core/lib/src/kanon/kanon.dart`; ERSETZE-17 in ANPASSUNG.md, Zeile 28; `burgstadt_core/test/kanon_test.dart`, Zeile 214, erwartet 17 Ersetzungen). In Daten und Spieltexten steht kein „bewusstlos“.
- E27/M5 (Kanon-Spuren zeigen auf die Täterin): O-Spuren bleiben. Die Stadttexte legen keine Rolle als Täterin nahe.
- E27/H1 (Fähigkeit von R03 nur für R03 sichtbar), E27/G3 („Einspruch!“, Zeile 204), E27/G4 (Kopftuch ungenutzt), E27/M2 (Teile im Code), E27/G7 (Nachtplan-Zeiten nicht als Text): übernommen.
- E27/M1 (Armbanduhr nicht darstellbar): übernommen. Die Ausnahme gilt nur für die Uhr (siehe H1).
- E29/B2, B3, B4–B8 und B9 (Lederhut/Filzhut): übernommen. Die Gasse „Gasse am Untertor“ aus B4–B8 fehlt aber in LISTE-ORTE (B3).
- E31 (B35 „früh am Morgen“, B38 fädelt): verifiziert.
- E33 (Stollen zu Schacht, Kerzenlaternen, Schuhmacher ohne Sohle): übernommen.
- E34/B-1 (Zeitangaben in Aussagen gehören zu LISTE-ZEITEN): gedeckt. Die vorkommenden Zeiten stehen in LISTE-ZEITEN oder sind Aussagen (z. B. 22:05, 23:50, 23:51, 21:20).
- E34/B-2 (Altersgruppen): nicht vollständig umgesetzt, siehe B2.
- E34 (Taschenuhr B02, Feder R17): übernommen.
- E35 (Hund, Gemüsefass, Wehrgang): übernommen.
- `LEITPLANKEN-AUSNAHMEN.md`: alle Einträge sind Regelzitate oder Negativanweisungen. Keine neue Ausnahme nötig.

## 5. Einzelprüfung Leitplanken

- Alkohol, Drogen, Rausch: keine Treffer. „Punsch“ kommt einmal vor, als alkoholfrei (`erzaehler.json`, Zeile 119).
- Verletzung: nur „Beule“, „benommen“ (ERSETZE-17 wirksam), „Kühlpack“. „keine offene Wunde“ (`faehigkeiten.json`, Zeile 142) verneint den Kanon-Wortlaut und beschreibt keine Verletzung.
- Blut, Leiche, Hexen, Walpurgis, Teufel, Film-Vampir: keine Treffer.
- Herkunft: nie Motiv, Indiz oder Pointe. Herkunft kommt nur als Hintergrund vor (Wurzeln, Herkunft des Wachses, Herkunft des Schreis). Keine Bezüge zu Rumänien oder Roma.
- Täterin: keine Stadttexte, die eine Rolle nahelegen.
- Klischees: B2 (Altersgruppen).

## 6. Einzelprüfung Kanon

- Orte: ORT-01 bis ORT-12 stimmen mit den Häusern (H-026, H-027, H-028, H-058, H-104, H-084, H-029, H-137, H-030, H-105, H-138, H-106) und den zwölf fallorte-Räumen in Name und Viertel überein. Abweichungen: B3 und B4.
- Zeiten: siehe Abschnitt 4.
- Bewohner: alle 44 Wohn- und Arbeitshäuser existieren. Die Berufe passen zu den Ortshinweisen (z. B. Apotheker B04 und H-S22, Nachtpförtner B20 und H-S17/H-S18, Teestube B07 und H-S13/H-S14). Abweichung: H7.
- Stadt-Hinweise H-S01 bis H-S24: Aussagen passen zu Häusern und Personen.
- Figuren: Name und Alter stimmen mit K2 überein. Größen sind erfunden (E30); nur R12 „groß“ ist kanonisch und eingehalten. Kleidungsfarben aus K2 stimmen mit der Palette überein (Rampen aus `palette.dart`), Ausnahmen siehe H4. Haarfarben entsprechen den K9-Ankern. Grün nur bei R03 und R04 (K9 §8, Fließtext). Abweichungen: B1 und B5.

## 7. Plagiat

Geprüft auf Figurennamen, Ortsnamen, Zitate, Liedanfänge und Anspielungen auf Film-, Serien-, Spiel-, Buch- und Märchenfiguren in allen Datendateien und den O-Zeilen. Keine Treffer. Bloße Anklänge siehe H5.

Leitplanken eingehalten: nein · Kanontreu: nein · Plagiatsfrei: ja
