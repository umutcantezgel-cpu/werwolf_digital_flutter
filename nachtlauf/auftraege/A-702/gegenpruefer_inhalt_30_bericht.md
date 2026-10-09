HEAD e7e4219

# Gegenprüfung Inhalt A-702u/30 · gegenpruefer_inhalt_30

Auftrag: A-702u, Gegenprüfer Inhalt, dritte ID mit Schwerpunkt Herkunft und Klischee (Leitplanke 4, Punkte 20 und 21).

## Stand und Testlauf

- Schritt 0: `git merge --ff-only nachtlauf/burgstadt` meldet „Already up to date“. `nachtlauf/burgstadt` ist Vorfahr von HEAD e7e4219. `git status` im Worktree ist leer. Es wurde nichts geändert, nicht committet und nicht gebaut.
- `dart pub get --offline`: ok.
- `dart run bin/leitplanken.dart --burgstadt`: 125 Dateien, 0 Treffer, 0 Fehler, 0 Warnungen. Der Scanner findet keine Andeutungen; die Befunde unten stammen aus der manuellen Lektüre.
- `dart run bin/kanon.dart --wirksam`: 1276 Datensätze (264 O, 559 G, 453 L, aus der Ausgabe gezählt).
- Hinweis zur Ordnergrenze: Ich habe den Ordner `nachtlauf/auftraege/A-702/` einmal per `ls` aufgelistet, um die Berichtsdatei zu prüfen. Dabei habe ich nur Dateinamen gesehen. Keine Datei dort wurde geöffnet, kein fremder Prüfbericht gelesen.

## Urteil

Leitplanken eingehalten: nein. Zwei Befunde (M1, M2) verstoßen gegen die Leitplanken 4 (Alter) und 3 (keine Hexen; das Bild der Kräuterhexe ist eine Hexen-Andeutung). Drei Klischee-Muster (M3 bis M5) sind nicht durch E23 bis E54 abgewogen. Kanontreu: ja. Plagiatsfrei: ja (ein Anklang, G5).

Befunde: hoch 0 · mittel 5 · gering 6.

## Methode und Abdeckung

- Vollständig gelesen: alle 44 Stadtbewohner (bewohner.json), alle 160 Häuser (haeuser.json mit Inschriften und Geschichten), faehigkeiten.json (20 Rollen), rollen.json (21 Figuren), erzaehler.json, tutorial.json, alle 264 öffentlichen Kanon-Datensätze (O), die Personendatensätze R01 bis R20 (STAMM, ÖFFENTLICH, GEHEIM, LÜGE; 80 Datensätze), alle DW- und DET-Datensätze, ANPASSUNG.md vollständig und das Entscheidungslog E23 bis E54 vollständig.
- Kanon-Diff `git diff 659d3ed HEAD -- K*.md`: 176 geänderte O- und G-Zeilen gesichtet. Stichproben gegen den wirksamen Kanon (K-002, K-004, BSO-01, BSO-11, DET-B6, BW-AUSSAGE-3, H-104 bis H-370) stimmen überein.
- Übrige G-Datensätze außerhalb der Rollen (H-G 221, G-Gespräche 180, E-Entscheidungen 60, MK 12; zusammen 270 KB): Schlüsselwortscan für alle fünf Leitplanken, 166 Trefferzeilen einzeln gelesen. Nicht jede Zeile wurde vollständig gelesen.
- Rollen-Datensätze WISSEN und VERBINDUNGEN (G): Schlüsselwortscan, die Treffer mit Geld-, Herkunfts- und Altersbezug wurden gelesen.
- Innenraum-Daten (innen_haeuser, innen_fallorte): Objektbeschriftungen gelesen, Schlüsselwortscan. Karten-Rasterdaten, Geometrie der Teile und Materialwerte in karten.json wurden nur technisch geprüft, nicht inhaltlich. Die Teile-IDs in teile_*.json wurden gesichtet.
- Look-Anker (LF) und rollen.json verglichen. R03 und R04 sind konsistent (Strickjacke, Bluse, Jeans, Wanderstiefel; Pullover, Karohemd, Uhr).

## Befunde

### M1 · mittel · Alters-Klischee beim Burgwart (Leitplanke 4, Alter)

- Stelle: wirksamer Kanon BW-STAMM (Art und Sprechweise), LF-BW, R02-GEHEIM, R18-ÖFFENTLICH, H-209, G2-07, G2-51 (Burgwart Eckehard Lüddecke, 71, m).
- Zitat: „stur, grantig, gerecht, mit überraschender Wärme“ · LF-BW „warm grumpy smile“ · R02-GEHEIM „mag den Brummbär“ · H-209 „der Burgwart brummte“ · G2-51 „Wer einem alten Mann den Schlüsselbund abnimmt, will was damit.“
- Begründung: E50 führt „brummig bei alten Männern“ als Klischee-Muster der Stadtbewohner. E54 hat deshalb „brummig/brummelig/grummelig“ bei B08, B14 und B28 entfernt. Beim Burgwart (71, m) bleibt dasselbe Altersbild in Art, Sprechweise, Look-Anker und mindestens fünf weiteren Texten. Das ist keine der Abwägungen E23 bis E54. Der Kanonwortlaut ist hier kein Gegengrund, denn Charakterwörter sind keine Kanon-Fakten.
- Vorschlag: Per Overlay in ANPASSUNG.md (Begriffsersetzungen) „grantig“ durch „knapp“ ersetzen, „Brummbär“ streichen, „brummte“ durch „sagte“, LF-BW „grumpy“ durch „dry“. Kanon-Dateien bleiben unverändert.

### M2 · mittel · Kräuterfrau-Andeutung bei Ruth Köhler (Leitplanke 3 keine Hexen; Leitplanke 4 Alter und Geschlecht)

- Stelle: packages/burgstadt_core/data/stadt/bewohner.json, B31 (64, w, Gärtnerin, wohnt in H-111): WESEN, SAETZE, GEREDE.
- Zitat: „sie spricht mit Pflanzen so ausführlich wie mit Nachbarn und hat immer ein Körbchen Kräuter dabei“ · „Nimm Melisse, die beruhigt.“ · GEREDE „Man erzählt, die Gärtnerin rede nachts mit dem Nebelriesen“.
- Begründung: Einzeln harmlos. Zusammen ergibt sich das Bild der Kräuterhexe: ältere Frau, Körbchen mit Kräutern, Zwiegespräch mit Pflanzen, Heilrat, nächtliche Rede mit einem Geist. Dafür gibt es keine Abwägung in E23 bis E54.
- Vorschlag: Den Satz über das Sprechen mit Pflanzen und die nächtliche Geisterrede streichen; GEREDE auf ein Gartenthema umstellen; den Melisse-Satz neutral formulieren oder einer anderen Figur geben. Die Datei gehört zum Nachtlauf, nicht zum Kanon.

### M3 · mittel · Haarfarbe folgt dem Namensmuster (Leitplanke 4, Erscheinungsbild; Punkt 21b)

- Stelle: packages/pixel_engine/data/figuren/rollen.json (haar.rampe und haar.stufe), LF-Anker im wirksamen Kanon (Overlay ERSETZE-34 bis -38).
- Zitat: dunkel (schwarz oder dunkelbraun): R01 Hodžić, R02 Baran, R06 Kaya, R08 Mehmedović, R11 Demir, R13 Aksoy, R15 Öztürk, R16 Softić, R18 Şahin. Hell: R03 Hartwig, R04 Brinkmann, R10 Thielemann. LF-R13 „dark hair in a sleek ponytail“.
- Begründung: 9 von 12 Figuren mit türkisch-, kurdisch- oder bosnisch klingendem Namen haben dunkles Haar. Von den deutsch klingenden Figuren (R03, R04, R10, R17) sind drei hell und eine (R17) dunkel. E54 mischt die Haarfarben nur innerhalb der Wurzelgruppen des Kanons. Diese Gruppen sind im Spiel nicht mehr sichtbar. Das Muster nach Namensgruppe bleibt damit sichtbar. Nach Punkt 19 sind Namen keine Herkunftsangabe; deshalb mittel als Erscheinungsbild-Klischee und nicht hoch.
- Vorschlag: Vier bis fünf der neun dunklen Figuren (z. B. R06, R11, R16, R18) auf mittlere oder helle Töne setzen, dafür R04 oder R10 dunkler machen. Die Änderung ändert Figurendaten und braucht danach eine neue Sichtprüfung (Z-03).

### M4 · mittel · Geld-Muster bei Berufen und Färbungen (Leitplanke 4, Berufe, Färbungen, Fallfunktionen)

- Stelle: wirksamer Kanon R13-ÖFFENTLICH, R13-GEHEIM, R13-VERBINDUNGEN, R15-GEHEIM, R15-ÖFFENTLICH, R15-WISSEN, R16-GEHEIM, R16-WISSEN, R16-VERBINDUNGEN, R05-GEHEIM; faehigkeiten.json (Berufe R05, R13, R15, R16).
- Zitat: R13-GEHEIM „Sie drängt hart auf ihr Geld und wirkt dadurch unnachgiebig.“ · R13-ÖFFENTLICH „er nennt sie ‚Kassenwartin‘“ · R13-VERBINDUNGEN „R05 (… die beiden nennen sich halb im Scherz ‚die Gläubigerinnen‘)“ · R15-GEHEIM „Sie redet ständig über Geld, Schäden und Versicherungen … und wirkt dabei seltsam ungerührt.“ · R15-ÖFFENTLICH „schließt jedes Mal mit ‚Das ist abgedeckt‘“ · R16-GEHEIM „die Kreditanfrage über dreitausend Euro … wirkt wie ein Tatmotiv“.
- Begründung: Die einzelnen Texte sind nach E47 (Adjektive neutral) und E50 (Geldbezug aus Beruf und Lage) abgewogen. Neu ist das Muster: Die Figuren, die Geld prüfen, fordern oder bewerten, sind Selin (Bank), Derya (Versicherung), Amar (Immobilien mit Kreditanfrage) und Paulina (Steuer). Alle vier tragen nichtdeutsch klingende Namen. Der deutsche Geldverstoß (Mietbetrug, Autokredit) trägt Jonas (R04). Bei Derya und Selin bleibt trotzdem eine geldfixierte, abweisende Färbung. E47 hat diese Gefahr benannt; die Einzelfall-Abwägung erfasst die Häufung nicht.
- Vorschlag: „seltsam ungerührt“ (R15) und „unnachgiebig“ (R13) streichen. Den Satz „wirkt wie ein Tatmotiv“ (R16) auf die Lage von Jonas beziehen statt auf Amar. Die Verteilung der Geldfunktionen auf die Berufe ist Nutzerentscheidung (E47).

### M5 · mittel · Hausherrin-Muster: Frau im Haushalt, Mann im Handwerk (Leitplanke 4, Geschlecht)

- Stelle: packages/burgstadt_core/data/stadt/haeuser.json, Hausherrin in H-054, H-059, H-070, H-080, H-083, H-113, H-117, H-120, H-127, H-133, H-154 (dazu H-093, H-103, H-129). Gegenprobe Hausherr in H-077, H-098, H-114, H-125, H-131, H-136, H-157.
- Zitat: H-080 „das die Hausherrin jeden Morgen abstaubt“ · H-120 „die Hausherrin spült ihn abends sorgfältig aus“ · H-093 „Die Hausherrin nimmt sie zum Gedenken an den Pfarrer. Ihr Mann hält das für Aberglauben“ · H-131 „Der Hausherr malt sie jedes Frühjahr neu“.
- Begründung: Elf von 14 Hausherrinnen sind bei Haushaltsarbeit gezeigt (abstauben, spülen, einkochen, Kräuter gießen, Wolle sortieren). Kein Hausherr ist es (0 von 7). Dazu kommt H-093: die Frau abergläubisch, der Mann vernünftig. E38 hat nur das Wort „Hausfrau“ durch „Hausherrin“ ersetzt. Das Muster bleibt.
- Vorschlag: In fünf bis sechs Häusern die Tätigkeit auf einen Hausherrn verlagern oder neutral formulieren („die Hausleute“). In H-093 die Rollen tauschen oder neutral formulieren.

### G1 · gering · Alters- und Geschlechtsrequisiten bei älteren Figuren (Leitplanke 4)

- Stelle: bewohner.json B13 (88, w) Zubehör „Strickzeug“; B33 (79, w) „Häkelbeutel“; B43 (85, w) „Lesebrille“; B08 (81, m) WESEN „redet nur über den Berg und die alten Zeiten“, Zubehör „Gehstock“; B05 (74, w) WESEN „sie weiß alles besser“; B38 (73, w) WESEN „Spitzzüngig“. haeuser.json H-103 (B43) „die Nachbarn widersprechen ihr“.
- Begründung: Jede Angabe ist für sich individuell. Zusammen zeichnen sie die älteren Frauen als Strick-, Häkel- und Besserwisserinnen. E40 und E54 haben Häkelbilder, Katzen- und Kuchenpointe sowie „brummig“ entfernt. Diese Requisiten blieben.
- Vorschlag: Strickzeug durch ein Radio, Häkelbeutel durch ein Einkaufsnetz ersetzen; Charakterwörter ohne Altersbezug formulieren.

### G2 · gering · Gewalt-Färbung bei Diyar Kaya (Leitplanke 4, Färbung; Leitplanke 2)

- Stelle: wirksamer Kanon R06-GEHEIM (scheinbare Färbung), R06-ÖFFENTLICH (Feuerlöscher); rollen.json R06 (Haar schwarz, Stoppelbart, dunkelrotes Halstuch).
- Zitat: „weiß als Sanitäter genau, wie man jemanden kurz benommen macht, ohne ihn ernst zu verletzen“ · „dunkelrotes Halstuch, das er im Qualm vor Mund und Nase zieht“.
- Begründung: E47 hat „Wissen aus dem Sanitäterberuf“ akzeptiert. Neu ist die Verbindung mit türkisch oder kurdisch klingendem Namen, schwarzem Haar, Bart und dem Halstuch vor dem Mund. Das ergibt ein gewaltbereit wirkendes Erscheinungsbild. Gering, weil der Text berufsbezogen ist und das Tuch als Rauchschutz begründet wird.
- Vorschlag: Die scheinbare Färbung auf Ort und Zeitfenster umstellen statt auf Gewaltwissen.

### G3 · gering · Herkunftsanklang in Haustext (Leitplanke 4; Entscheidung N-02, E48)

- Stelle: haeuser.json H-090 (Bewohner B40): „Im Hof steht ein Ölbaum im Kübel, den die Familie seit der Auswanderung eines Großonkels pflegt.“
- Begründung: Auswanderung und mediterraner Baum sind ein Herkunftsmotiv im Ambiente. E48 hat Herkunft aus den Spieldaten genommen.
- Vorschlag: Ölbaum durch Lorbeer ersetzen, „Auswanderung“ streichen.

### G4 · gering · Folklore-Symbol bei türkisch klingendem Namen (Leitplanke 4; Logik E38)

- Stelle: wirksamer Kanon R13-STAMM (Kleidung), LF-R13; rollen.json R13 (Merkmal).
- Zitat: „eine rote Granatapfel-Brosche aus Emaille, ein Geschenk der Großmutter“.
- Begründung: Der Granatapfel wirkt bei dieser Figur als Herkunftszeichen. E38 hat Folklore-Familienmerkmale bei Rollen mit nichtdeutschen Wurzeln gestrichen; dieses Kleidungsmerkmal blieb.
- Vorschlag: Andere Brosche (z. B. Anker oder Schmetterling). Die Entscheidung liegt bei den Kanon-Autoren; ein Overlay ist möglich.

### G5 · gering · Anklang an ein Bibelwort (Leitplanke 5, Original statt Kopie)

- Stelle: haeuser.json H-077, Inschrift „Der Wind weiß, wohin er will · 1798“.
- Begründung: Umformung von Joh 3,8 („Der Wind weht, wo er will“). Keine wörtliche Kopie, aber ein bekannter Bibelsatz.
- Vorschlag: Eigene Inschrift.

### G6 · gering · Pronomen-Stimmigkeit im Haus H-111 (Prüfauftrag E54)

- Stelle: haeuser.json H-111 (Bewohnerin B31, Gärtnerin, w): „Im Frühjahr schneidet der Gärtner die Ruten für Körbe ab und verkauft sie am Untertor.“
- Begründung: Im Haus wohnt die Gärtnerin B31. Der Satz nennt einen männlichen Gärtner. Entweder ist eine dritte Person gemeint, die nicht benannt ist, oder es liegt eine Unstimmigkeit vor.
- Vorschlag: „die Gärtnerin“ schreiben oder die dritte Person benennen.

## Bekannte Punkte, nicht als Befund gezählt

- Verteilung der Fallfunktionen (R01 falsche Fährte, R02 Lügnerin, R03 und R04 deutsch) und der Nachname „Hodžić“: E42 bis E48 und N-02. Namen gelten nach Punkt 19 nicht als Herkunft.
- DW3-2 „Das sieht nicht gut für sie aus“ (Rojda am Sicherungskasten): Teil der Fallfunktion, E47.
- R18 „Besserwisserin“ und „Einspruch!“, R05 „nachtragend“, R14 „Groll“: E47 und E50. Die Häufung unter M4 wird nicht doppelt gezählt.
- Burgwart-Herkunft „Schartenfels, Bergland“: Ort der Spielwelt, E50.
- Punsch und Punschkessel: alkoholfrei durchgängig (OA-04, OA-23, BW-ZUSTAND, DW1-3, Stimmungstext). „Kater Paşa“ (LEITPLANKEN-AUSNAHMEN) und „hungriger Kater“ (G2-33, Tier) sind kein Verstoß.
- „Gespenst“, „Geist“, „Geisterstunde“ und „Kessel“ in den G-Texten gehören zum Streich und zum Track. Kein Hexenbezug.
- Besen des Schornsteinfegers (B17): kein Hexenbezug; E44 hat ihn für den Nutzer offen gelassen.

## Prüfpunkte des Auftrags

- Punkte 17 und 18 (Spieltext O, G und DW; ERSETZE-23 bis -30): keine Herkunftsangabe in angezeigten Texten. Wurzeln sind gelöscht, Familienfelder nennen keine Herkunftsorte. Alkoholfreiheit ist durchgängig gesichert.
- Punkt 19 (Herkunft als Motiv, Indiz oder Pointe): keine Herkunftsangabe im wirksamen Kanon (O, G, DW) und in den Stadt- und Spieldaten gefunden. Klischee-Muster siehe M3, M4, G2 und G4.
- Punkt 21a (Stadtbewohner): 21 Frauen und 23 Männer. Pronomen in allen 44 Datensätzen konsistent. Alle Namen deutsch. Keine Hör-Motive und keine Gruppenwörter mehr.
- Punkt 21 (Haustexte H-036, H-056, H-122, H-125, H-139): konsistent mit den Bewohnern (Glaserin, Fuhrunternehmerin, „Der Bewohner“, „Der Hausherr“, Otto Stern).
- Punkt 21b (Haarfarben): siehe M3.
- Punkt 15 (Kanon-Diff, Aussehen von R03 und R04): konsistent.
- Kanontreu: wirksamer Kanon und K-Dateien (O-Zeilen) stimmen in den Stichproben überein. Abweichungen sind im Overlay dokumentiert (E38, E41, E48).
- Plagiat: Schlüsselwortsuche nach Filmen, Serien, Büchern und Liedern ohne Treffer. G5 ist ein Anklang.

Leitplanken eingehalten: nein · Kanontreu: ja · Plagiatsfrei: ja
