HEAD e13255f

# Gegenprüfung Inhalt A-702v/33 (gegenpruefer_inhalt_33)

**Auftrag:** A-702v, Schwerpunkt Leitplanke 4 (Herkunft, Klischees über Gruppen, Geschlecht, Alter) über alle Spieltexte, dazu übrige Leitplanken, Kanontreu und Plagiat.
**Stand:** HEAD e13255f (Fast-Forward nachtlauf/burgstadt, vorher e7e4219). Keine Daten geändert, kein Commit, kein Push, kein Build. `dart pub get --offline` und die Scanner liefen ohne Änderung an versionierten Dateien (git status sauber). Hilfsdateien im Scratchpad-Unterordner gegenpruefer_inhalt_33. Berichte anderer Prüfer nicht gelesen.

**Ergebnis:** Befunde hoch 2 / mittel 9 / gering 5. Leitplanke 4 ist verletzt (Befunde 1 bis 11, 15 und 16). Zusätzlich berühren Befund 8 und 13 die Leitplanke „keine Hexen, kein Walpurgis, kein Teufel“, Befund 14 die Täter-Leitplanke. Kanontreu und Plagiat sind eingehalten.

## 1. Geprüft

- **Vollständig gelesen:** Auftrag A-702v; ENTSCHEIDUNGSLOG E23–E55 (E1–E22 zur Einordnung); kanon/ANPASSUNG.md; FÜR-DEN-NUTZER.md; alle 44 Bewohner (bewohner.json); alle 160 Häuser mit Inschrift und Geschichte (haeuser.json); Rollen-Stammzeilen R01–R20 (wirksamer Kanon); Look-Anker LF; alle DW-Ergebnisse; alle Geheimnis- und Färbungstexte R01–R20; faehigkeiten.json; erzaehler.json; tutorial.json; rollen.json und karten.json (Hautton, Haar, Größe).
- **Stichwortscan über alle Spieltexte** (Herkunft, Geschlecht, Alter, Alkohol/Drogen, Blut/Gewalt, Hexen/Magie, Fremdwerke; wirksamer Kanon O/G/DW, Stadt- und Rollendaten). Jede Fundstelle geprüft.
- **Scanner:** `leitplanken.dart --burgstadt`: 0 Treffer, 125 Dateien. `kanon.dart --wirksam`: 1276 Datensätze.
- **Nur gefiltert gelesen:** Kanon-Diff 659d3ed..HEAD (geänderte O-Zeilen mit Leitplanken-Begriffen); innenraeume/*.json und fallorte.json (Stichwortscan); G- und E-Datensätze außerhalb der Färbungstexte (Stichwortscan, jede Treffer-Zeile geprüft).
- **Plagiat-Websuche:** „Kunibert“ führt zu einer Folge der Serie „Nonstop Nonsens“ (1978, „Didi in der Ritterzeit“) mit einem Ritter Kunibert auf einer Burg, siehe [TheTVDB, Nonstop Nonsens, Episodenliste](https://www.thetvdb.com/series/nonstop-nonsens/episodes/433804). „Ich zähle die Stunden, nicht die Schuld“ ergab keinen Treffer.

Herkunft der Rollen (Wurzeln) stammt aus dem Rohkanon (K2-ROLLEN), weil das Feld im Overlay gelöscht ist. Sie dient nur der Analyse und wird nicht als Spieltext zitiert. L-Datensätze wurden nur auf Widersprüche gesichtet, nicht zitiert.

## 2. Befunde

### 1 · hoch · Hautton folgt der Namensherkunft

- **Datei:** packages/pixel_engine/data/figuren/karten.json (materialien.haut); rollen.json (Feld „erfunden“ nennt „Hautton“ bei allen Rollen).
- **Stelle:** Hautwerte R01–R20.
- **Zitat:** deutsch benannt (Wurzeln deutsch): R03 `"haut":[7,5]`, R04 `[7,4]`, R10 `[7,6]`, R17 `[7,6]`. Nichtdeutsch benannt (16): R01, R06, R12, R16, R18 `[7,3]`; R09, R14, R19 `[7,2]`.
- **Befund:** Laut palette.dart liegt Stufe 2 bei Index 2·2+1 auf 6E4632 (dunkelbraun), Stufe 3 auf 93624A (braun). Dunkelbraun oder braun haben acht der 16 nichtdeutsch benannten Rollen, keine der vier deutsch benannten. Der Hautton ist laut rollen.json erfunden, also eine Entscheidung des Nachtlaufs und keine Kanonvorgabe.
- **Regel:** Leitplanke 4 (keine Klischees über Gruppen; Herkunft nie Indiz).
- **Begründung:** E48 stützt sich auf „Wirkung im Spiel: keine sichtbare“. Für den Hautton trifft das nicht zu. E17 führt den Hautton als frei gewählt; die Verteilung über Gruppen wurde nie geprüft. Neuer Grund.
- **Vorschlag:** Hautstufen 2–6 unabhängig von Namen und Wurzeln verteilen; danach Sichtprüfung, weil sich der Kartenstand ändert.

### 2 · hoch · Geld als Beruf, Motiv und Färbung bei nichtdeutsch benannten Figuren

- **Datei:** wirksamer Kanon (R13, R15, R05, R01: STAMM, ÖFFENTLICH, GEHEIM); packages/burgstadt_core/data/rollen/faehigkeiten.json.
- **Stelle:** R13 Selin Aksoy (türkisch), R15 Derya Öztürk (türkisch), R05 Paulina Zielińska (polnisch), R01 Adnan Hodžić (bosnisch). Gegenstück: R04 Jonas Brinkmann (deutsch), laut E47 die Figur mit dem Mietbetrug.
- **Zitat:**
  - R13-STAMM: „Beruf: Bankkauffrau, Beraterin für Privatkredite in einer Filiale in Braunschweig“; Sprechweise „Bankdeutsch im Alltag („Das ist fällig.“ „Wir machen einen Tilgungsplan.“)“.
  - faehigkeiten R13: „Wer zahlt die Miete?“.
  - R13-ÖFFENTLICH: „antwortet sie trocken „Achthundert, achthundert, achthundert““; „er nennt sie „Kassenwartin““.
  - R13-GEHEIM: „Scheinbare Färbung: Sie drängt hart auf ihr Geld und wirkt dadurch unnachgiebig.“
  - R15-STAMM: „Beruf: Versicherungskauffrau im Außendienst“; faehigkeiten R15: „Zahlung statt Versicherung“.
  - R15-GEHEIM: „Scheinbare Färbung: Sie redet ständig über Geld, Schäden und Versicherungen, sogar über Kunibert, und wirkt dabei seltsam ungerührt.“
  - R15-ÖFFENTLICH: „rechnet sie bei jedem Malheur des Abends vor, wer dafür aufkommt“.
  - R05: faehigkeiten „Beleg bitte“; R05-GEHEIM: „Scheinbare Färbung: Sie ärgert sich lautstark über Jonas und das Mietgeld und wirkt dabei nachtragend.“
  - R01-GEHEIM: „Motiv: scheinbar – 3.800 Euro Türschaden bis Mitternacht“.
  - Die vier Geld-Fähigkeiten „Beleg bitte“ (R05), „Wer zahlt die Miete?“ (R13), „Zahlung statt Versicherung“ (R15) und „Was ist die Burg wert?“ (R16) gehören alle nichtdeutsch benannten Figuren.
- **Befund:** Die Geldfixierung steht nicht nur in einer Rolle. Sie zieht sich durch Beruf, Fähigkeit, Geheimnis, öffentliche Auftritte und Färbung. Scheinbare Geld-Motive und Geld-Färbungen liegen bei vier nichtdeutsch benannten Figuren (R01, R05, R13, R15). Der einzige deutsch benannte Geldfall ist R04.
- **Regel:** Leitplanke 4 (Klischee über Gruppen, Berufe, Färbungen). E47 nennt genau dieses Klischee („Geldgier und Kälte … ein bekanntes Klischee“).
- **Begründung:** E47 hat nur zwei Adjektive getauscht. „seltsam ungerührt“ meint dasselbe wie „kalt“ und trägt das Klischee weiter. Die Geldpointen in den öffentlichen Texten (Achthundert-Zeile, „Kassenwartin“, „rechnet vor, wer aufkommt“) hat E47 nicht erfasst. Neuer Grund.
- **Vorschlag:** Im Overlay die öffentlichen Geldpointen und das Adjektiv „ungerührt“ ersetzen. Beruf und Geheimnis von R13 und R15 sind Kanonentscheidung; das ist mit den Kanon-Autoren zu klären. Die Fähigkeiten „Beleg bitte“ und „Wer zahlt die Miete?“ auf Figuren aller Gruppen verteilen. Keine Daten geändert.

### 3 · mittel · Haarfarbe folgt der Herkunftsgruppe (Nachfolge E50, E54, E55)

- **Datei:** wirksamer Kanon, Look-Anker LF-R01…R20 (O); packages/pixel_engine/data/figuren/karten.json (haar).
- **Stelle:** alle 20 Rollen.
- **Zitat:** LF-R17 „a 38-year-old man with black hair“; LF-R03 „shoulder-length light brown hair“; LF-R04 „short blond hair“; LF-R10 „a short platinum blonde pixie cut“; LF-R07 „wavy light brown hair“; LF-R19 „short light brown hair“; LF-R20 „a long light brown braid“; LF-R01 „short dark brown hair“; LF-R02 „long dark curly hair“; LF-R06 „short black hair“; LF-R11 „long straight black hair“; LF-R13 „dark hair in a sleek ponytail“; LF-R14 „short dark brown hair“; LF-R15 „long dark brown wavy hair“; LF-R16 „slicked-back dark hair“; LF-R18 „dark curly hair“.
- **Befund:** Deutsch benannt (4): hell 3 (R03, R04, R10), dunkel 1 (R17). Nichtdeutsch benannt (16): hell 3 (R07, R19, R20), mittel 3 (R05, R09, R12), dunkel 10 (R01, R02, R06, R08, R11, R13, R14, R15, R16, R18).
- **Regel:** Leitplanke 4.
- **Begründung:** E55 weist den Einwand als Nutzerentscheidung zurück. Die Entscheidung betrifft die Mischung je Gruppe. Die Gegenprobe prüft nur „je Gruppe hell und dunkel“. Die Verteilung über alle Gruppen bleibt bestehen und stützt Befund 1. Neuer Grund.
- **Vorschlag:** Haarfarben über alle Gruppen gleich verteilen, Overlay-Ersetzungen ERSETZE-34 bis -38 fortführen, karten.json und rollen.json anpassen, neue Sichtprüfung. Nutzerentscheidung nötig, weil Look-Anker O betroffen sind.

### 4 · mittel · Verdachts- und Lügenfunktionen: E48-Prämisse neu geprüft

- **Datei:** wirksamer Kanon R02-GEHEIM, R01-GEHEIM (G), DW2-1 und DW3-2 (Ergebnistexte, nach E47 Spieltext); Entscheidungslog E47/E48.
- **Stelle:** Verteilung der Verdachtsfunktionen.
- **Zitat:** R02-GEHEIM: „Scheinbarer Verdacht: Sie stand im Dunkeln direkt neben der Eisentür, hat den Strom abgeschaltet und weiß alles über den Streich.“. DW2-1 Ergebnis C: „Rojda gibt den Streich zu. Sie hat um zwei vor zwölf den Hebel gezogen, der Schrei war ihr Track.“. DW3-2 Ergebnis C: „Rojda stand allein am Sicherungskasten, die Eisentür nur ein paar Schritte entfernt, ohne Zeugen. Das sieht nicht gut für sie aus.“
- **Befund:** Die Verdachts- und Lügenfunktionen (falsche Fährte, Streich, Lüge) liegen bei zwei nichtdeutsch benannten Figuren (R01, R02). E48 stützt sich darauf, die Verteilung sei „im Spiel an kein Herkunftsmerkmal mehr gebunden“. Das stimmt nicht: Hautton und Haarfarbe (Befunde 1 und 3) bilden die Gruppen sichtbar ab.
- **Regel:** Leitplanke 4 (Herkunft nie Indiz oder Pointe).
- **Begründung:** Neuer Grund aus Befund 1 und 3. Der Auftrag (Punkt 19) zählt Vor- und Nachnamen nicht als Herkunftsangabe; geprüft wurde deshalb die sichtbare Wirkung von Hautton, Haar und Textfunktion.
- **Vorschlag:** Nutzerentscheidung neu einholen: Verdachtsfunktionen über alle Gruppen mischen (Kanon) oder die sichtbaren Herkunftsmerkmale (Befunde 1 und 3) entkoppeln. Keine Änderung.

### 5 · mittel · Berufsbilder der Eltern nach Geschlecht

- **Datei:** wirksamer Kanon, STAMM-Zeilen (Feld Familie, O). Das Spiel zeigt das Feld nicht an (E38), der Auftrag rechnet O-Datensätze dennoch zum Spieltext (Punkt 17).
- **Stelle:** Familienfelder R01–R20.
- **Zitat:** R05 „die Mutter ist Zahnarzthelferin, der Vater Lagerist“; R13 „der Vater ist Mechatroniker in einem Autowerk, die Mutter Erzieherin in einer Kita“; R16 „der Vater war Schlosser, die Mutter Kantinenköchin“; R20 „der Vater ist Vermessungstechniker, die Mutter Grundschullehrerin“. Ausnahmen: R15 „der Vater unterrichtet Mathematik“, R19 „der Vater ist Krankenpfleger“.
- **Befund:** Von 17 Müttern mit Berufsangabe arbeiten alle in Pflege, Bildung, Verwaltung, Medizin, Kantine oder Änderungsschneiderei; keine in Technik oder Bau. Von 19 Vätern mit Berufsangabe arbeiten 17 in Technik, Handwerk, Industrie, Logistik, Verkehr oder Bau.
- **Regel:** Leitplanke 4 (Geschlecht).
- **Begründung:** E38 hat Familienfelder nur auf Herkunfts-Folklore geprüft. Das Geschlechtsmuster ist in keinem Log-Eintrag behandelt. Neuer Grund.
- **Vorschlag:** Familienberufe im Overlay gemischt besetzen, wie E38 es bei den Familienfeldern schon getan hat. Keine Änderung.

### 6 · mittel · Rollenmuster „Frau organisiert, Mann repariert“

- **Datei:** wirksamer Kanon, STAMM R08, R13, R05, R01 (O).
- **Stelle:** Charakterisierung R05, R08, R13 (Frauen) und R01 (Mann).
- **Zitat:** R08 „Lejla führt seit ihrem zwölften Lebensjahr den Familienkalender und vergisst keinen einzigen Geburtstag“; „ruft sie vor jedem wichtigen Spiel an, damit sie ihm Mut macht“. R13 „Selin ist die, die an jeden Geburtstag denkt und bei jedem Umzug die Kisten beschriftet“. R05 „Paulina macht seit Jahren die Steuererklärung für die ganze Verwandtschaft“. R01 „Adnan repariert danach, was in der Woche kaputtgegangen ist“.
- **Befund:** Drei Frauen werden über Erinnerung, Organisation und Fürsorge charakterisiert, ein Mann über Reparatur. R04 als Organisator ist eine Gegenprobe, ändert das Muster aber nicht.
- **Regel:** Leitplanke 4 (Geschlecht).
- **Vorschlag:** Aufgaben im Overlay tauschen: Erinnerung oder Organisation bei R01 oder R04, Reparatur bei R08 oder R13. Keine Änderung.

### 7 · mittel · Alter: der grantige, brummende Burgwart

- **Datei:** wirksamer Kanon BW-STAMM, BW-ZUSTAND, OA-24, R18-ÖFFENTLICH (O) und G2-07 (G).
- **Stelle:** Burgwart Eckehard Lüddecke, 71.
- **Zitat:** BW-STAMM „Art: stur, grantig, gerecht, mit überraschender Wärme.“; BW-ZUSTAND „ist zum Hauptgang wieder grantig-komisch“; OA-24 „Der Burgwart brummt: „Da ist er ja. Wenigstens einer mit Anstand.““; R18-ÖFFENTLICH „er brummte: „Weiß ich.““; G2-07 „Der Alte hat gebrummt“.
- **Befund:** Der 71-jährige Mann wird an mindestens fünf Stellen grantig oder brummend beschrieben. E54 hat „brummig/brummelig/grummelig“ bei den Bewohnern B08, B14 und B28 bewusst entfernt; diese Regel wurde beim Burgwart nicht angewandt.
- **Regel:** Leitplanke 4 (Alter), Gleichbehandlung mit E54.
- **Begründung:** E55 weist den Punkt mit „Einzelzug aus dem Kanon, an Wärme gebunden“ zurück. Das Wort steht aber in mehreren Datensätzen, O und G. Neuer Grund.
- **Vorschlag:** Overlay-Ersetzungen „brummt“ zu „sagt knapp“ und „grantig“ zu „knapp“ in den genannten Datensätzen (ANPASSUNG.md). Keine Daten geändert.

### 8 · mittel · Hexen-Andeutung bei B31 Ruth Köhler (64, Gärtnerin)

- **Datei:** packages/burgstadt_core/data/stadt/bewohner.json (B31: wesen, saetze, gerede).
- **Stelle:** B31.
- **Zitat:** wesen: „sie spricht mit Pflanzen so ausführlich wie mit Nachbarn und hat immer ein Körbchen Kräuter dabei“. saetze: „Die Weide am Haus ist so alt wie der Brunnen. Sie hat viel gehört und wenig gesagt, genau wie ich.“. gerede: „Man erzählt, die Gärtnerin rede nachts mit dem Nebelriesen, weil er die Beete nicht betritt, aber das ist nur Geschwätz vom Zaun.“
- **Befund:** Eine ältere Frau mit Kräuterkorb, sprechenden Pflanzen, Weide und einem Gerücht über nächtliche Gespräche mit einem Fabelwesen erfüllt das Bild der alten Kräuterhexe. Das verletzt die Leitplanke „keine Hexen“ durch Andeutung und ist zugleich ein Alters- und Geschlechtsklischee.
- **Regel:** Leitplanke „keine Hexen, kein Walpurgis, kein Teufel“; Leitplanke 4 (Alter, Geschlecht).
- **Begründung:** E55 weist die Kräuterfrau-Andeutung mit „es gibt keine Hexenmerkmale“ zurück. Das Gerücht über nächtliche Gespräche mit dem Nebelriesen ist aber ein magisches Merkmal und widerlegt diese Abwägung. Neuer Grund.
- **Vorschlag:** gerede streichen, Kräuterkorb und die Weide-Sätze entschärfen. Die Sichtkarte ändert sich dadurch nicht. Keine Daten geändert.

### 9 · mittel · Alter und Geschlecht: ältere Frauen über Hochzeiten und Tratsch

- **Datei:** packages/burgstadt_core/data/stadt/bewohner.json (B13, B16, B38); wirksamer Kanon R10-STAMM (O).
- **Stelle:** B13 (88), B16 (77), B38 (73), R10 Großmutter Inge (89).
- **Zitat:** R10-STAMM: „Die Großmutter Inge, 89, schreibt ihr noch Briefe mit Füller und will „vor dem Hundertsten noch eine Hochzeit erleben““. B13 wesen: „sie erinnert sich an jede Hochzeit der Gasse“. B16 wesen: „weiß zu jeder Hochzeit das Datum“; gerede: „darin stehen nur die Hochzeitstage der Gasse“. B38 nacht: „stickt im Halbdunkel an einem Hochzeitskissen, weil der Gedanke an das Fest sie nicht loslässt“.
- **Befund:** Vier Frauen zwischen 73 und 89 sind über Hochzeiten und deren Erinnerung definiert. Die älteren Männer B08 und B28 haben Gehstock und Zeitung. Das ist ein Altersklischee mit Geschlechtsbezug.
- **Regel:** Leitplanke 4 (Alter, Geschlecht).
- **Vorschlag:** Hochzeitsmotiv bei mindestens zwei der vier Frauen streichen oder einer anderen Figur geben. Bei Inge (R10) den Wunsch im Overlay ersetzen. Keine Daten geändert.

### 10 · mittel · Verdachts-Färbungen mit Gewalt- und Sammel-Bezug bei nichtdeutsch benannten Männern

- **Datei:** wirksamer Kanon R06-GEHEIM und R19-GEHEIM (G).
- **Stelle:** R06 Diyar Kaya (kurdisch), R19 Azad Tekin (kurdisch).
- **Zitat:** R06-GEHEIM: „Scheinbare Färbung: … weiß als Sanitäter genau, wie man jemanden kurz benommen macht, ohne ihn ernst zu verletzen.“. R19-GEHEIM: „Scheinbare Färbung: … wirkt, als sammle er etwas gegen die anderen.“
- **Befund:** Zwei nichtdeutsch benannte Männer tragen eine Färbung mit Gewalt-Wissen beziehungsweise mit Erpressungsanschein. Bei deutsch benannten Figuren gibt es keinen vergleichbaren Bezug (R10 heimlichtuerisch, R17 Spuk). E55 hat R06 als offene Färbung nur an die Kanon-Autoren weitergegeben.
- **Regel:** Leitplanke 4 (Klischee: Mann mit Gewaltwissen, Erpresser).
- **Vorschlag:** R06: den Satz über das gezielte Betäuben streichen (der Gang mit dem Feuerlöscher kann bleiben). R19: „sammle etwas gegen die anderen“ neutral fassen. Im Overlay. Keine Daten geändert.

### 11 · mittel · Folklore-Zeichen bei R13 (Granatapfel, Großmutter-Rezepte)

- **Datei:** wirksamer Kanon R13-STAMM und LF-R13 (O), R13-GEHEIM (G).
- **Stelle:** R13 Selin Aksoy.
- **Zitat:** R13-STAMM: „Signaturstück: eine rote Granatapfel-Brosche aus Emaille, ein Geschenk der Großmutter“. LF-R13: „a red enamel pomegranate brooch“. R13-GEHEIM: „ein kleines eigenes Café mit den Rezepten ihrer Großmutter eröffnen“. R13-STAMM: „wird weich und ausführlich, sobald es ums Backen geht“.
- **Befund:** E38 hat Folklore-Merkmale der Familien ersetzt (Pita, Pierogi, Revani …), weil die Zuordnung „Herkunft → Folklore“ ein Klischee-Muster ergab. Brosche und Großmutter-Rezepte bleiben bei derselben Figur. E55 hat das an die Kanon-Autoren gegeben, obwohl das Overlay es ohne Kanonänderung ersetzen kann.
- **Regel:** Leitplanke 4 (Klischee über Gruppen, Folklore).
- **Begründung:** E38-Logik, auf das Aussehen angewandt. Neuer Grund.
- **Vorschlag:** Brosche durch ein neutrales Schmuckstück ersetzen (LF-R13 und R13-STAMM im Overlay), Rezept-Motiv neutral fassen. Keine Daten geändert.

### 12 · gering · Namensnähe „Kunibert“ (Plagiat-Hinweis)

- **Datei:** wirksamer Kanon K-005, BW-AUSSAGE-2, LISTE-GEGENSTÄNDE.
- **Stelle:** Rüstung „Kunibert“.
- **Zitat:** K-005: „die Ritterrüstung „Kunibert““. BW-AUSSAGE-2: „Kunibert, du alter Hehler.“
- **Befund:** Gängiger historischer Vorname. Die Websuche findet eine Folge „Didi in der Ritterzeit“ (Serie „Nonstop Nonsens“, 1978) mit einem Ritter Kunibert auf einer Burg. Übernahme von Figur, Handlung oder Sätzen ist nicht erkennbar; der Nachtlauf selbst hat die Namensnähe notiert (FÜR DEN NUTZER). Kein Plagiat im Sinne des Auftrags.
- **Regel:** Plagiatsfrei (Hinweis).
- **Vorschlag:** Kanon-Entscheidung: beibehalten oder umbenennen. Keine Änderung.

### 13 · gering · Bock und Besen als mögliche Teufels- oder Walpurgis-Bilder

- **Datei:** packages/burgstadt_core/data/stadt/haeuser.json (H-073, H-123); bewohner.json (B17).
- **Stelle:** Häuser H-073 und H-123, Schornsteinfeger B17.
- **Zitat:** H-073 „Ein Geißbock aus Holz hängt unter dem Dachvorsprung“. H-123 Inschrift „Der Bock stößt, wer ihn ärgert“. B17 zubehoer „Kehrbesen“.
- **Befund:** Ziegenbock und Besen können als Teufels- oder Hexenbild gelesen werden. FÜR DEN NUTZER (Inhaltsrunde 17) hat das gemeldet; es ist nicht umgesetzt.
- **Regel:** „keine Hexen, kein Walpurgis, kein Teufel“.
- **Vorschlag:** Bock durch ein neutrales Tier ersetzen (H-073 und H-123 mit Inschrift). Der Besen ist Teil der Figurenkarte; eine Änderung braucht Sichtprüfung. Keine Daten geändert.

### 14 · gering · Verstecken- und Spurenhinweise in Stadttexten

- **Datei:** packages/burgstadt_core/data/stadt/haeuser.json (H-053, H-132); bewohner.json (B34).
- **Stelle:** Inschriften H-053 und H-132, Nachtplan B34.
- **Zitat:** H-053 „Hinter Läden wohnt, wer nicht gesehen werden will“. H-132 „Die Hecke schützt, was sie verbirgt“. B34 nacht: „Er fällt auf die Matratze, die Handschuhe noch an den Händen.“
- **Befund:** Für Stadt-, Bewohner- und Haustexte gilt die Regel, vor der Auflösung nichts nahezulegen (E27). Verstecken- und Spurenvermeidungs-Motive stehen noch offen (E44, FÜR DEN NUTZER).
- **Regel:** kein Text, der vor der Auflösung die Täterin nahelegt.
- **Vorschlag:** Inschriften neutral fassen („Hinter Läden wohnt man gern im Halbdunkel“, „Die Hecke schützt den Vorgarten“). Handschuhe bei B34 streichen. Keine Daten geändert.

### 15 · gering · Hausarbeit und Gartenmotive nach Geschlecht (Rest aus E55)

- **Datei:** packages/burgstadt_core/data/stadt/haeuser.json (H-119, H-059, H-070, H-113, H-133, H-147; Gegenbeispiele H-125, H-131).
- **Stelle:** Haustexte.
- **Zitat:** H-119 „Die Verkäuferin staubt es jeden Morgen ab, ohne es anzufassen.“ H-059 „Die Hausherrin gießt dort oben im Sommer ihre Kräutertöpfe.“ H-070 „Die Hausherrin erntet jeden August“. H-113 „Die Hausherrin lässt im Sommer Blüten darin schwimmen“. H-133 „Die Hausherrin stellt dort Blumen hinein“. H-147 „Die Frau aus dem Haus sammelt Blumen“. Gegenbeispiele: H-125 „Der Hausherr hat ihn an der Decke festgemacht“, H-131 „Der Hausherr malt sie jedes Frühjahr neu“.
- **Befund:** E55 hat die Staub-Hausarbeit bei H-080 auf den Hausherrn gelegt. H-119 blieb bei einer Verkäuferin, das ist inkonsistent. Garten, Blumen, Kräuter und Ernte sind fast durchgehend Frauen zugewiesen, Reparatur und Werkzeug Männern.
- **Regel:** Leitplanke 4 (Geschlecht).
- **Vorschlag:** H-119 neutral fassen, einige Gartenmotive auf Männer umstellen. Keine Daten geändert.

### 16 · gering · Requisiten nach Alter und Geschlecht

- **Datei:** packages/burgstadt_core/data/stadt/bewohner.json (Zubehör).
- **Stelle:** B13, B33, B43 (Frauen), B08 und B28 (Männer).
- **Zitat:** B13 „Strickzeug“; B33 „Häkelbeutel“; B43 „Lesebrille“; B08 „Gehstock“; B28 „Zeitung“.
- **Befund:** Ältere Frauen haben Handarbeit, ältere Männer Gehstock oder Zeitung. E55 nennt als Gegenbeispiel nur das Stricken eines Mannes im Haustext H-117; die Figuren-Requisiten bleiben nach Geschlecht getrennt.
- **Regel:** Leitplanke 4 (Alter, Geschlecht).
- **Vorschlag:** Requisiten umverteilen; Sichtprüfung nötig, daher Nutzerentscheidung. Keine Daten geändert.

## 3. Abwägungen ohne Befund

- **Alkohol:** Die Treffer „Punsch“ ohne Zusatz betreffen den Punschkessel als Gerät (LISTE-ORTE, LISTE-GEGENSTÄNDE, OA-03, D1-3, E1-12, R01/R05/R12/R17-ÖFFENTLICH). Jede Trinkstelle ist alkoholfrei: OA-04, OA-23, BW-ZUSTAND, laden/10. Kein Wein, Bier, Schnaps, Bar, keine Gaststätte; Teestube und Café sind alkoholfrei.
- **Verletzung:** nur Beule, benommen, keine offene Wunde, Kühlpack. „bewusstlos“ im wirksamen Kanon 0 Treffer. Kein Blut.
- **Herkunft im Wortlaut:** Kein Wurzel-Feld im wirksamen Kanon. Herkunfts- und Nationalitätswörter (Rumän, Roma, Türk, Kurd, Bosn, polnisch, Tuzla u. a.) 0 Treffer. Einzige Ausnahme: „Herkunft: Schartenfels, Bergland“ (BW-STAMM), ein Ort der Spielwelt, den E48 und E50 bewusst behalten haben.
- **Stadtbewohner:** Berufe nach Geschlecht ausgeglichen (B15, B35, B41 Männer in Pflege, Reinigung und Bedienung; B11, B12, B32, B39 Frauen im Handwerk). Dutt bei B09 (44), B27 (31), B38 (73), B13 (88); Glatze bei B06 (46), B08 (81), B18 (66), B28 (84). Keine Herkunfts-Gastronomie: Teestube mit deutscher Inhaberin und Bedienung (B07, B41).
- **Namen:** Außer Kunibert (Befund 12) keine Auffälligkeit im Stichwortscan. Schartenfels, Silberhau, Lüddecke und Nebelriese wurden nicht gesondert recherchiert.
- **Kanontreu:** Die Overlay-Änderungen (ERSETZE-17 bis -38, Familienfelder, Löschung der Wurzeln) sind dokumentiert (E4, E29, E38, E46–E48, E50, E54). Sie stehen keinem geprüften O-Faktum entgegen: Tatzeiten, Schlüssel, Stadttore, Zustand des Burgwarts, Nebel nur im Tal (K-002), Strom bis zum Morgen (STADT-04), Burgtor bis Phase 2 zu. Die Look-Anker-Änderungen (Haar, ERSETZE-34 bis -38) sind dokumentiert und kanonkonform.
- **DW-Ergebnisse:** DW3-3 nennt keine Person (E54). DW1-3 nennt den Punsch alkoholfrei, DW1-1 nennt „VT · 3“. Keine Herkunftswörter.
- **Kanon-Diff:** nur gefiltert gelesen. Gegenprüfer 32 hat den Schwerpunkt.

## 4. Grenzen

- G- und E-Datensätze (je rund 80 bis 120 KB) sowie R-Datensätze außerhalb der Stammzeilen und Geheimnistexte: nur per Stichwortscan, jede Trefferzeile geprüft.
- innenraeume/*.json und fallorte.json: nur per Stichwortscan, nicht zeilenweise gelesen.
- H-Hinweise des Kanons (K3, H-01 bis H-29): nur per Stichwortscan.
- Kanon-Diff 659d3ed..HEAD: nur geänderte O-Zeilen mit Leitplanken-Begriffen gelesen.
- Plagiat: nur zwei Suchen (Kunibert, „Ich zähle die Stunden, nicht die Schuld“). Die übrigen Namen und Sätze wurden nicht gesondert recherchiert.

## Urteil

Leitplanke 4 ist verletzt (Befunde 1 bis 11, 15 und 16). Hautton und Geld-Muster (Befunde 1 und 2) sind hoch, weil sie systematisch über die Herkunftsgruppen verteilt sind. Kanontreu: ja (Overlay-Abweichungen dokumentiert, kein Widerspruch zu geprüften O-Fakten). Plagiat: ja (Hinweis Befund 12).

Leitplanken eingehalten: nein · Kanontreu: ja · Plagiatsfrei: ja
