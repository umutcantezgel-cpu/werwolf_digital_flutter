# Gegenprüfung Inhalt, dritte unabhängige Runde (A-702d, Z-12)

**Worktree:** /home/user/werwolf_digital_flutter/.claude/worktrees/agent-a4c8410f3df11c8fa
**Stand:** HEAD 505a473 (= nachtlauf/burgstadt, per `git merge --ff-only` übernommen). Keine Daten geändert, kein Commit, kein Push.
**Frühere Berichte** unter nachtlauf/auftraege/A-702/: nicht gelesen.

## 1. Umfang und Abnahme

Vollständig gelesen:

- packages/burgstadt_core/data/stadt/bewohner.json (2703 Z.), stadt/haeuser.json (2013 Z.), innenraeume/fallorte.json (992 Z.), innenraeume/haeuser.json (2580 Z.), rollen/faehigkeiten.json (532 Z.)
- packages/burgstadt_spiel/data/texte/erzaehler.json und tutorial.json
- packages/pixel_engine/data/figuren/karten.json, rollen.json, teile_kleidung.json, teile_koepfe.json
- nachtlauf/kanon/ANPASSUNG.md (139 Z.)

Maßstab: alle 223 Datensätze mit Sichtklasse O in krimidinner/spuk-im-gewoelbe/10_kanon/K*.md sowie die O-Zeilen der ANPASSUNG.md. L- und G-Zeilen wurden nur zur Widerspruchsprüfung herangezogen und nicht zitiert. K2-ROLLEN-KERN.md wurde Zeile 1 bis 60 vollständig gelesen.

Entscheidungslog: E4, E14, E14a, E23 und E27 gelesen. Werkzeug: bin/leitplanken.dart und lib/src/pruef/leitplanken.dart (Wortlisten, Ausnahmen, Überspringregel) gelesen.

Testbefehl: `dart pub get --offline` erfolgreich. `dart run bin/leitplanken.dart --burgstadt`: 119 geprüfte Dateien, Summe 0 Treffer, 0 Fehler, 0 Warnungen. Das Werkzeug findet die unten genannten Stellen nicht (siehe Abschnitt 3, Methode).

## 2. Befunde

Zusammenfassung: hoch 1 · mittel 2 · gering 6

### B1 · hoch · „bewusstlos“ verletzt die Verletzungs-Leitplanke; E23-M5 hier mit neuem Grund widersprochen

- **Stelle, öffentlich (Sichtklasse O):**
  - krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md Z. 52 (OA-20): „In der Speisekammer liegt der Burgwart bewusstlos zwischen Kartoffeln und Konserven …“
  - krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-KERN.md Z. 54 (BW-ZUSTAND): „Kurz bewusstlos, kurz nach Mitternacht wieder wach …“
  - K1 Z. 8 (Erläuterung ohne @): „Der Burgwart ist nur kurz bewusstlos.“
- **Gegenstück im Spieltext:** packages/burgstadt_core/data/rollen/faehigkeiten.json Z. 142 (R06): „… eine Weile benommen …“
- **Regel:** Verletzung nur „Beule“, „benommen“, „Kühlpack“ (Auftrag, Leitplanke 4). „bewusstlos“ steht nicht in der Scanner-Wortliste und wird deshalb nicht gemeldet.
- **Warum E23-M5 hier nicht trägt (neuer Grund):**
  1. E23 begründet die Entscheidung mit „der Kanon ist verbindlich“. E4 sieht aber ausdrücklich vor, dass der Kanon per Overlay angepasst wird (feldweises Mergen, Ersetzungstabelle). Ein Overlay-Eintrag verändert den Kanon nicht im Sinne von E4. Keine S-1…S-7-Zeile enthält das Wort (geprüft), die Lösungslogik bleibt also unberührt.
  2. Der Widerspruch bleibt im Spiel bestehen. Die öffentlichen O-Zeilen OA-20 und BW-ZUSTAND behalten „bewusstlos“. K8 (FÜNF-SÄTZE, Z. 129) verlangt: „Ein KI-Erzähler liest alle Texte wortgetreu vor.“ Die App lädt die Kanon-Dateien samt Overlay (lib/burgstadt/daten_laden.dart Z. 12–18; repo.dart Z. 34–35). Der Erzähler sagt also „bewusstlos“, während die Fähigkeit des R06 „benommen“ sagt.
  3. Die Begründung „hält sich an die Wortliste der Leitplanken“ gilt nur für den Spieltext. Die öffentlichen Kanonzeilen, die denselben Zustand beschreiben, halten sich nicht daran.
- **Vorschlag:** In nachtlauf/kanon/ANPASSUNG.md eine Ersetzung anlegen: `@ERSETZE-17 [O] | Von: bewusstlos | Nach: benommen`. Sie wirkt auf OA-20, BW-ZUSTAND und K1 Z. 8. Danach den Satz „Kurz benommen, kurz nach Mitternacht wieder wach …“ lesen. Die Gedächtnislücke aus BW-ZUSTAND bleibt inhaltlich gleich. Die K-Dateien selbst bleiben unverändert.

### B2 · mittel · Stadt- und Bewohnertexte legen eine weibliche Täterin nahe (Verdacht, mehrere Stellen)

- **Regel:** kein Text, der vor der Auflösung die Täterin nahelegt. E27 wendet diese Regel auf Stadt-, Bewohner- und Hausdaten an. Die Täterinrolle ist weiblich (aus L-Zeilen, nicht zitiert). Öffentlich bekannt ist über die Figur R03 nach K2-ROLLEN-KERN.md Z. 26 (R03-ÖFFENTLICH): „… seit einer Geisterbahnfahrt als Kind Angst im Dunkeln hat.“
- **Beobachtung:** „Angst“ als Zustand einer Person steht in den Stadttexten nur bei weiblichen Figuren (B15, B21, B38, B41). Bei männlichen Figuren kommt das Wort nicht als persönlicher Zustand vor (B28 meint die Stadt). Dazu kommen Dunkel-/Licht-Motive und ein Saum-Motiv, das das Bettlaken-Indiz berührt.
- **Stellen:**
  - a. packages/burgstadt_core/data/stadt/bewohner.json Z. 2511 (B41 Nora Stahl, w): „Die Laterne über der Theke ist meine Lieblingslampe. Heute Nacht habe ich sie nicht angezündet, weil ich Angst hatte.“ Das deckt sich mit dem öffentlichen Merkmal Angst im Dunkeln.
  - b. bewohner.json Z. 2309 (B38 Hildegard Mosch, w): „… weil die Hand nicht ruhig war. Das passiert, wenn man Angst hat.“
  - c. bewohner.json Z. 542 (B09 Dörte Wagner, w): „… bis der Puls sich beruhigt.“ (Grenzfall)
  - d. bewohner.json Z. 913 (B15, w) und Z. 1282 (B21, w): allgemeine Angst-Sätze (Grenzfall)
  - e. nachtlauf/kanon/ANPASSUNG.md Z. 96 (@H-S10, O, Ort Kostümfundus): „Die Schneiderin flickt abends die Säume …“. Im Spiel liegt daneben das Bettlaken-Indiz (K1 Z. 197, BSO-06: „am Saum fehlt ein Streifen“). Dieselbe Aussage steht als Hausgeschichte in stadt/haeuser.json Z. 1320 (H-104). Die Schneiderin B38 wohnt in H-101 (stadt/haeuser.json Z. 1278).
  - f. stadt/haeuser.json Z. 182 (H-014 „Haus zur Laterne“, ohne zugeordnete Figur): „Heute Nacht war sie dunkel, und die Bewohnerin fand das weniger beunruhigend als den Rest der Stadt.“
- **Bewertung:** Jede Stelle für sich ist schwach. Zusammen ergibt sich ein weibliches Verdachtsmuster (Angst, Dunkel, Lampe, Saum, Schneiderin), das zum öffentlichen Merkmal der Täterin passt. Die Kanon-Spuren selbst sind nicht Teil dieses Befunds (E27-M5).
- **Vorschlag:** Angst- und Unruhe-Motive auf gemischte Figuren verteilen oder streichen. B41: etwa „… weil es im Dachzimmer so zog“. B38: den Hand-Satz streichen. H-S10 und H-104: den Saum-Satz streichen oder das Flicken ohne Bezug zum Stoffsaum formulieren. H-014: „die Bewohnerin“ durch eine zugeordnete Figur oder neutral ersetzen.

### B3 · mittel · Zeitpunkte außerhalb LISTE-ZEITEN (Kanon-Format)

- **Regel:** Was nicht in einer geschlossenen Liste steht, darf in Spieltexten nicht als Ort, lösungsrelevanter Gegenstand oder Zeitpunkt auftauchen (K-Format, Abschnitt Listen). LISTE-ZEITEN (K1 Z. 29) nennt 17:40 bis „kurz nach Mitternacht“, aber keine Stadtzeiten.
- **Stellen:**
  - ANPASSUNG.md Z. 34 (STADT-01, O): „… um 22:00 ab.“
  - ANPASSUNG.md Z. 38 (STADT-05, O): Phase 1 ab 00:25, Schlag 01:30, Phase 2 bis 03:00, Phase 3 bis 04:30
  - ANPASSUNG.md Z. 112 (H-S15, O): „… um drei Uhr angeheizt …“
  - ANPASSUNG.md Z. 124 (H-S19, O): „… um zehn Uhr ab.“
  - stadt/haeuser.json Z. 1726 (H-137): „… um drei Uhr angeheizt …“
  - bewohner.json Z. 166 (B03): „… dass um drei der Ofen angeheizt wird.“ und Z. 422 (B07): „… die drei Schläge des Uhrturms …“
- **Hinweis:** Die von/bis-Zeiten der Nachtpläne sind Daten und werden laut E27-G7 nicht als Text ausgegeben. Sie fallen deshalb nicht darunter.
- **Vorschlag:** LISTE-ZEITEN im Overlay um die öffentlichen Stadtzeiten ergänzen (Stadttore 22:00, Phasenschläge 00:25, 01:30, 03:00, 04:30, Ofen 03:00). Alternativ die Zeitangaben in den Spieltexten streichen.

### B4 · gering · „Pensionswirtin“ (Team-Regel E27-G12 nicht durchgehalten)

- packages/burgstadt_core/data/stadt/bewohner.json Z. 9 (B01, beruf): „Pensionswirtin“
- **Regel:** E27-G12 hat „Wirtin“ zu „Inhaberin“ gemacht und die Scanner-Ausnahmen entfernt. Der Scanner erkennt nur das ganze Wort „wirtin“, nicht Komposita.
- **Vorschlag:** „Pensionsinhaberin“.

### B5 · gering · Gassennamen außerhalb der Listen

- bewohner.json Z. 528 (B09, nacht): „… ein Bellen aus der Untertorgasse.“
- bewohner.json Z. 1460 (B24, saetze): „… als auf der Hauptgasse.“
- **Regel:** LISTE-ORTE (ANPASSUNG Z. 63, K1 Z. 27): Gassen nur aus der Stadtdatei. Beide Namen fehlen in LISTE-ORTE und in stadt/haeuser.json.
- **Vorschlag:** In der Stadtdatei als Gasse führen und in LISTE-ORTE aufnehmen, oder umformulieren („die Gasse am Untertor“, Untertor ist gelistet).

### B6 · gering · Weinbau-Andeutung „Rebhänge“

- stadt/haeuser.json Z. 886 (H-069 „Haus zum Wehrgang“): „… auf die Rebhänge, die es hier nicht mehr gibt.“
- **Regel:** Alkohol, auch nicht als Andeutung (Leitplanke). Der Scanner erkennt das nicht.
- **Vorschlag:** „Obsthänge“ oder „Streuobstwiesen“.

### B7 · gering · Geschlecht der Bewohnerin bei H-078

- stadt/haeuser.json Z. 994 (H-078 „Haus zum Ofenrohr“): „Die Bewohnerin bäckt im Sommer darauf Äpfel …“
- Zugeordnet ist B06 Jürgen Hahn (bewohner.json Z. 309: `"geschlecht": "m"`).
- **Vorschlag:** „Der Bewohner“ oder die Zuordnung korrigieren. Relevant für B2.

### B8 · gering · Uhrzeiten als Ziffern in einem angezeigten Sichtschicht-Text

- packages/burgstadt_core/data/rollen/faehigkeiten.json Z. 98 (R04, zeigt): „… Eichentür 17:40, Begrüßung 20:30, Ultimatum 22:45 …“
- **Regel:** FORMAT: In Spieltexten werden Uhrzeiten in Worten geschrieben.
- **Vorschlag:** „siebzehn Uhr vierzig, zwanzig Uhr dreißig, zweiundzwanzig Uhr fünfundvierzig“.

### B9 · gering · Hutart: Lederhut im Kanon, Filzhut im Figurenteil

- Kanon: K2-ROLLEN-13-20.md Z. 43 (R17-STAMM): „ein brauner Lederhut“; K9-LOOKBIBEL.md Z. 82 (LF-R17): „brown leather hat“.
- Spieltext: packages/pixel_engine/data/figuren/rollen.json Z. 350 („brauner Lederhut“).
- Figurenteil: packages/pixel_engine/data/figuren/karten.json Z. 20 (R17: `kopf-filzhut`), teile_koepfe.json Z. 206 (`kopf-filzhut`).
- **Vorschlag:** Teilname auf Lederhut ändern oder die Look-Angabe im Overlay auf Filzhut. Nur eine Benennung, optisch kaum relevant.

## 3. Geprüft, nicht als Befund gezählt

- **E27-H1** (Fähigkeit R03 „Spur verwischen“ nur für R03 sichtbar): nicht gezählt.
- **E27-M5** (Kanon-Spuren zur Täterin, etwa der Toilettengang in OA-14, H-17, H-43, H-47 und die Stablampe mit dem Namenszug in BSO-03 und H-28): nicht gezählt. Der Name auf der Lampe ist ein Besitzhinweis, kein Herkunftsindiz.
- **E27-M2** (Teil-IDs im Code): nicht gezählt. Teile wie `frisur-kurz` oder `bart-kurz` in karten.json stehen nicht in teile_koepfe.json und sind laut E27 im Code. Das habe ich nicht nachgeprüft.
- **E27-G3** („Einspruch!“, R18, aus dem Kanon): nicht gezählt.
- **E27-G4** (Kopftuch-Teil): geprüft. `kopf-kopftuch` ist in karten.json und rollen.json keiner Figur zugewiesen. Kein Befund.
- **E27-G5, G7, G11**: nicht gezählt.
- **E27-H2** (LISTE-ORTE um Häuser, Gassen und Inschriften erweitert): geprüft, bis auf B5 gedeckt.
- **Kanon-Folklore, Grenzfall** (Team-Prüfung empfohlen, kein Befund): K2-ROLLEN-KERN.md Z. 7 (R01: „Pita und lange Telefonate mit der Verwandtschaft“), K2-ROLLEN-05-12.md Z. 7 (R05: „Pierogi“), K2-ROLLEN-05-12.md Z. 70 (R12: „Kaffee aus der Džezva und eine lange Diskussion …“). Die Details sind warm-komisch, nicht abwertend, und Herkunft wird nicht als Motiv verwendet.
- **Herkunft:** Keine Herkunftsangabe in den Spieltexten dient als Motiv, Indiz oder Pointe. Die Wurzeln aus dem Kanon stehen nur als Biografie. Keine Klischees über Rumänien, Roma oder andere Gruppen (Wortsuche und Lektüre).
- **Alkohol und Drogen:** keine Treffer. Punsch ist überall alkoholfrei (erzaehler.json Z. 119; K1 OA-04; K8 GL-14; K9 LA-02). Die Gaststätten sind Teestube, Bäckerei, Apotheke.
- **Verletzung und Blut:** nur „Beule“, „Kühlpack“ und „benommen“ außer dem Befund B1. Keine Blutdetails.
- **Hexen, Walpurgis, Teufel, Film-Vampire:** keine Treffer.
- **Plagiat:** Stichwortprüfung nach Filmen, Serien, Büchern, Liedern und bekannten Figuren ohne Treffer. „Lindenbaum“ (Hausname H-019, Gerede B15) ist ein gängiger Hausname, kein Befund. Keine übernommenen Sätze erkennbar.
- **Harz-Bezüge:** ERSETZE-01 bis -16 decken alle sichtbaren Harz-, Silberhauer- und Brockengespenst-Stellen in O- und Spieltextzeilen ab (per Suche geprüft).
- **Stadt-Hinweise H-S01 bis H-S24:** alle Einstufungen sind Farbe, entlastend oder bestätigend (ANPASSUNG Z. 9). Keine falsche Fährte, nichts stützt S-1…S-7.
- **Bewohner und Häuser:** alle 44 Bewohner sind mit ihrem Haus konsistent (bewohner.json ↔ stadt/haeuser.json), bis auf B7. Die Stadt-Hinweise stimmen mit Stadtdatei und Kanon überein (Stadttore, Teestube, Bäckerei, Apotheke, Rathaus).
- **Figuren:** Kleidung und Merkmale der Karten stimmen mit den O-Zeilen überein, bis auf B9.
- **Methode, Scannerlücken:** Der Scanner prüft Wortlisten. Er erkennt keine Komposita (B4), keine Andeutungen (B6), keine Zeitpunkte, Ortsnamen, Geschlechtsmuster oder Täterinnen-Nahelegung (B2, B3, B5). Zeilen mit „- Kein Alkohol“ oder „Verboten sind“ überspringt er. In den geprüften Dateien kommt dieser Zeilenbeginn nicht vor.

## 4. Urteil

Die Verletzungs-Leitplanke ist verletzt (B1). Die Täterin-Regel ist gefährdet (B2). Kanontreu ist nicht gegeben: B1 weicht der öffentliche Kanonsatz vom Spieltext ab, B3 betrifft das Zeitformat der Listen, B9 die Hutart. Keine erkennbaren Übernahmen aus fremden Werken.

Leitplanken eingehalten: nein · Kanontreu: nein · Plagiatsfrei: ja
