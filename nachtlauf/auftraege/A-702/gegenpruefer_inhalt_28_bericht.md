HEAD e7e4219

# Gegenprüfung Inhalt A-702u/28 (gegenpruefer_inhalt_28)

Geprüfter Stand: nachtlauf/burgstadt, HEAD e7e4219. Schritt 0: `git merge --ff-only nachtlauf/burgstadt` ergab „Already up to date“; `git rev-parse --short HEAD` = e7e4219.

## Kurzurteil

- Befunde: hoch 0 · mittel 2 · gering 6
- Leitplanken eingehalten: nein. Grund: Befund 1 und Befund 2 sind Klischees über Gruppen (ältere Frauen; Frauen in Haushaltsrollen), also Leitplanke 4. Alkohol, Drogen, Blut, Hexen und Herkunft als Motiv sind eingehalten.
- Kanontreu: ja. Die O-Datensätze und das Overlay (ANPASSUNG.md) sind konsistent; die Befunde 5 bis 7 betreffen Kanon-Entscheidungen, keine Abweichung.
- Plagiatsfrei: ja.

## 1. Vorgehen und Abdeckung

Vollständig gelesen:
- Auftrag A-702u (alle Punkte) und das Entscheidungslog E23 bis E54 (Punkt 9a) mit dem Kontext E1 bis E22.
- nachtlauf/kanon/ANPASSUNG.md (Overlay, 204 Zeilen).
- Kanon-Diff `git diff 659d3ed HEAD -- krimidinner/spuk-im-gewoelbe/10_kanon/K*.md`: alle 58 geänderten [O]-Zeilen; die geänderten [G]-Zeilen (150) sind als Liste gesichtet.
- Wirksamer Kanon (`cd packages/burgstadt_core && dart run bin/kanon.dart --wirksam`, 1280 Zeilen): alle O-, G- und DW-Datensätze (823 Zeilen O/G plus 9 DW-Zeilen) gelesen. L-Datensätze nur auf Widersprüche gescannt, wie Punkt 17 verlangt.
- packages/burgstadt_core/data/stadt/bewohner.json: alle 44 Bewohner (Wesen, Sätze, Gerede, Nachtpläne, Aussehen).
- packages/burgstadt_core/data/stadt/haeuser.json: alle 160 Häuser (Name, Inschrift, Geschichte).
- packages/burgstadt_core/data/rollen/faehigkeiten.json: alle Texte.
- packages/burgstadt_spiel/data/texte/erzaehler.json und tutorial.json: alle Texte.
- packages/pixel_engine/data/figuren/rollen.json: alle 20 Rollen (Aussehen); karten.json stichprobenhaft (R02, R03, R04, R13, R16, R17).

Nur per Schlagwort und Stichprobe geprüft (keine Spieltext-Felder außer Namen und Ortsbezeichnungen): packages/burgstadt_core/data/innenraeume/haeuser.json und fallorte.json; teile_kleidung.json und teile_koepfe.json (Teile-Bibliothek ohne Spieltext).

Werkzeuge:
- `dart pub get --offline`: ok.
- `dart run bin/leitplanken.dart --burgstadt`: Geprüfte Dateien 125 · Summe 0 Treffer · 0 Fehler · 0 Warnungen.
- `dart run bin/kanon.dart --pruefe`: 0 Befunde, 1276 Datensätze.

Nicht gelesen, wie vom Auftrag vorgegeben: nachtlauf/auftraege/A-702/ (weder gelesen noch durchsucht, außer dem Anlegen dieser Datei), andere Prüfberichte, content/party/ (Punkt 22).

## 2. Pflichtpunkte

- Punkt 15 (Kanon-Diff v1.0): Die geänderten O-Zeilen (K-002 Nebel nur im Tal, K-004, BSO-01, BSO-11, H-02, H-06, H-11, H-14, H-17, H-49, H-50, LISTE-ZEITEN, R03- und R04-Ö-Zeilen, IF-5, ZM-1 bis ZM-4, LR-3, GL-21, LF-R03, LF-R04, D2-2, D3-2) sind mit ANPASSUNG.md konsistent. Die Zeitlinie wurde stichprobenhaft geprüft: Hebel 23:58, Taler 23:58:15, Burgwart kommt zu sich um 00:01 (wörtlich „kurz nach Mitternacht“ im Overlay), Taler in der Dose 00:06, Tor 00:07. Kein Widerspruch zu S-1 bis S-7 gefunden. Der Kanon-Prüfer meldet 0 Befunde.
- Punkt 17 (Spieltext): O, G und DW gelesen. Die DW-Ergebnistexte zählen als Spieltext (E47). Keine Befunde in den DW-Texten.
- Punkt 18 (Overlay ERSETZE-23 bis -30, wirksamer Kanon): „VT · 3“ ohne Nachnamen (DW1-1, GL-19, BSO-03); Punsch alkoholfrei in OA-04, OA-23, BW-ZUSTAND, GL-14, FÜNF-SÄTZE, DW1-3 und Erzähler laden/10. „Punschkessel“ nur als Gerät (E46). R01-Beruf ohne Nachnamen (faehigkeiten.json), R13/R15-Färbungen neutral ersetzt (siehe Befund 6).
- Punkt 19 (Herkunft): Keine Herkunft als Motiv, Indiz oder Pointe. „Wurzeln“ fehlt bei allen 20 Rollen; die Familienfelder nennen nur Wohnorte (Salzgitter, Gifhorn u. a.), keine Herkunftsgruppe. Einziges Restfeld: BW-STAMM „Herkunft: Schartenfels, Bergland“. Das ist ein Ort der Spielwelt, und das Feld wird nach fall_daten.dart nicht angezeigt (E48). Vornamen und Nachnamen wurden laut Auftrag nicht als Herkunftsangabe gewertet.
- Punkt 21 (E50 bis E54): Stadtbewohner: 21 Frauen, 23 Männer (wie E54). Pflege, Reinigung und Bedienung sind mit Männern besetzt (B15, B35, B41). Dutt, Haube und Glatze kommen auch bei Jüngeren vor (B09, B27; B03, B06). Keine „brummig“-, Hör- oder Gruppenwörter über Ältere (Schlagwortsuche ohne Treffer). Haustexte H-036, H-056, H-122, H-125 und H-139 sind korrekt gegendert. DW3-3 nennt nur die Spur. Haarfarben: rollen.json, karten.json und die LF-Anker stimmen für alle geprüften Rollen überein. Das Alters- und Geschlechtsmuster der Hochzeits-, Klatsch- und Haushaltsrollen wurde von E50 und E54 nicht erfasst (Befund 1 und 2).
- Punkt 22: content/party/ nicht geprüft (eigener Strang).

## 3. Befunde

### Befund 1 (mittel): Klatsch-, Hochzeits- und Besserwisser-Muster bei den älteren Frauen

- Datei: packages/burgstadt_core/data/stadt/bewohner.json (Zeilennummern aus der Datei), zusätzlich packages/burgstadt_core/data/stadt/haeuser.json (H-080).
- Stellen: B13 Rosa Teutsch (88) Z. 741; B16 Irmgard Roth (77) Z. 928, Satz Z. 974 und 976, Gerede Z. 978; B38 Hildegard Mosch (73) Z. 2262, Nacht Z. 2296, Satz Z. 2308; B05 Waltraud Schuller (74) Z. 253; B33 Elfriede Ahrens (79) Wesen (Gedächtnis-Archiv); B21 Dagmar Krauß (49) Z. 1235 („Schnell im Mund“, mild); H-080 (Hausherrin, „übersteht den Winter besser als sie selbst“).
- Zitate: „sie erinnert sich an jede Hochzeit der Gasse und an fast jeden Streit“ (B13); „sie kennt jede Familie der Gasse und weiß zu jeder Hochzeit das Datum“ (B16); „Spitzzüngig und gutmütig, sie näht Hochzeitskleider und kritisiert jede Naht“ (B38); „sie weiß alles besser und meint es trotzdem gut“ (B05); „seither geht er nachts nicht mehr allein“ (B16, Satz über ihren Mann).
- Regel: Leitplanke 4 (keine Klischees über irgendeine andere Gruppe). Auftrag Punkt 21 verlangt die Prüfung von Klischees über Geschlecht und Alter. E54 hat nur Dutt, „brummig“, Hör- und Gruppenwörter geregelt.
- Begründung: Alle sechs Frauen über 70 (B05, B13, B16, B33, B38, B43) tragen einen Wissens-, Gedächtnis- oder Urteilszug. Vier davon mit Klatsch-, Hochzeits- oder Besserwisser-Bezug (B05, B13, B16, B38). Das ergibt das stereotype Bild der klatschenden, besserwisserischen Älteren. Die älteren Männer (B08, B14, B22, B26, B28, B40) tragen diese Züge nicht. Im Kanon-Verbund passt R18 (25 Jahre, Kanon-G, unverändert) „wirkt dadurch wie eine Besserwisserin“ (K2-ROLLEN-13-20.md Z. 54) in dasselbe Muster. Der Einwand „nur Einzelpersonen“ greift nicht, weil die Zuschreibung an Geschlecht und Alter hängt. Die Nacht-Angst bei B16 ist ein weiteres Altersmotiv.
- Vorschlag: Wissens-, Klatsch- und Kritikzüge von Alter und Geschlecht lösen. Hochzeitsmotive streichen oder auf Männer und Jüngere verteilen (B13 Z. 741; B16 Z. 928, 976, 978; B38 Z. 2296, 2308). B05 Z. 253 „weiß alles besser“ durch „hat für Ausreden einen scharfen Blick“ ersetzen (ohne Besserwisser-Wort). B38 Z. 2262 „spitzzüngig, kritisiert jede Naht“ durch einen neutralen Zug ersetzen. B16 „geht nachts nicht mehr allein“ (Z. 974) einem Mann zuordnen oder streichen. B21 Z. 1235 durch einen neutralen Zug ersetzen. H-080 „übersteht den Winter besser als sie selbst“ streichen. Die Kanon-Datei R18-GEHEIM bleibt unverändert (Hinweis an die Kanon-Autoren, E50).

### Befund 2 (mittel): Haushalts- und Pflegetätigkeiten in den Häusern nur bei Frauen

- Datei: packages/burgstadt_core/data/stadt/haeuser.json, Feld „geschichte“ der Häuser H-054, H-059, H-070, H-080, H-083, H-113, H-116, H-117, H-118, H-119, H-120, H-127, H-133, H-147, H-154, H-074.
- Zitate: „Die Hausherrin spült ihn abends sorgfältig aus“ (H-120); „Die Hausherrin mahlt darin Pfefferminz und Holunderblüten für den Tee im Winter“ (H-127); „Die Hausherrin gießt dort oben im Sommer ihre Kräutertöpfe“ (H-059); „Die Hausherrin sortiert sie nach Farben und spinnt im Winter daraus Socken“ (H-117); „Die Frau im Haus zieht die Leine jeden Montag straff“ (H-118); „Die Frau aus dem Haus sammelt Blumen“ (H-147); „Heute flicken hier die Nachbarinnen ihre Wäsche“ (H-116); „Die Verkäuferin staubt es jeden Morgen ab“ (H-119); „wo die Wäscherin jeden Montag die Bottiche füllt“ (H-074).
- Gegenbeispiel bei den Männern: „Der Hausherr misst jeden Sommer nach“ (H-136), „Der Hausherr malt sie jedes Frühjahr neu“ (H-131), „Der Hausherr sagt, das Wasser im Keller bleibe warm“ (H-114), „Der Hausherr sagt, die Linde sei der einzige Bewohner“ (H-098). Keine männliche Hausarbeit in den Häusern.
- Regel: Leitplanke 4 (Klischee über Geschlecht). Auftrag Punkt 21 („Klischees über Geschlecht“). E54 hat nur die Berufe der Stadtbewohner ausgeglichen; die Hausszenen blieben unberührt. E38 hat nur das Wort „Hausfrau“ durch „Hausherrin“ ersetzt (15 Stellen), die Rollenverteilung nicht.
- Begründung: Etwa 17 Stellen zeigen Frauen in Haushalts-, Pflege- und Wäschetätigkeiten, Männer nie. Frauen im Handwerk gibt es durchaus (Glaserin H-036, Färberin H-033, Töpferin H-039, Buchbinderin H-035, Grafikerin H-046, Schneiderin H-101). Der Befund betrifft deshalb nicht die Berufe, sondern die Verteilung der Haushaltsarbeit, die ein sichtbares Geschlechtermuster bildet. Mittel, weil es systematisch über die Stadt verteilt ist.
- Vorschlag: Haushaltstätigkeiten (gießen, polieren, spülen, mahlen, Wäsche, Blumen, Socken, Staub) auf alle Geschlechter verteilen. Mindestens die Hälfte der Haushaltsszenen männlich besetzen, etwa „Der Hausherr spült ihn abends“ (H-120) oder „Der Vater zieht die Leine“ (H-118). Der Begriff „Hausherrin“ kann bleiben; die Tätigkeit wechselt.

### Befund 3 (gering): Altersmotive bei älteren Männern (Otto Stern)

- Datei: packages/burgstadt_core/data/stadt/bewohner.json Z. 448 (B08, Wesen) und Z. 466 (B08, Zubehör); packages/burgstadt_core/data/stadt/haeuser.json H-139.
- Zitate: „er redet nur über den Berg und die alten Zeiten“ (B08, Z. 448); „Heute wohnt dort Otto Stern mit seinem Gehstock und zählt abends die Lampen am Berg“ (H-139); Zubehör „Gehstock“ (Z. 466); B28 Satz „damals gab es keinen Nebelriesen, den man fürchten musste“.
- Regel: Leitplanke 4; Auftrag Punkt 21 (Alter).
- Begründung: Gehstock und „alte Zeiten“ sind das Standardbild des Rentners, der nur von früher erzählt. Gering, weil B08 sonst individuelle Züge hat.
- Vorschlag: Gehstock (Z. 466, H-139) durch einen neutralen Gegenstand ersetzen. Wesen (Z. 448) auf Gegenwartsbezug umstellen, etwa „hört jedem zu, der vom Berg erzählen will“.

### Befund 4 (gering): Verweis auf eine nicht angelegte Bewohnerin „Frau Lang“

- Datei: packages/burgstadt_core/data/stadt/bewohner.json Z. 913 und Z. 915 (B15 Timo Kessler, Sätze).
- Zitat: „Frau Lang im zweiten Stock kennt jede Geschichte dieser Stadt. Ihr Gedächtnis ist besser als meins.“
- Regel: Konsistenz der Stadtdaten; Altersmotiv wie Befund 1.
- Begründung: In bewohner.json (44 Einträge) und haeuser.json gibt es keine Person Lang. Die Figur ist im Spiel nicht auffindbar. E54 hat das Altersmotiv dieser Figur geändert, aber die Person fehlt.
- Vorschlag: Satz an einen vorhandenen Bewohner binden (etwa den Nachtpförtner B20) oder eine Figur mit Haus-ID anlegen. Das Gedächtnismotiv streichen (Befund 1).

### Befund 5 (gering): „brummig“-Altersmuster beim Burgwart (Kanon-Quellen)

- Quellen (Kanon, nur Hinweis): krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-KERN.md Z. 53 (BW-STAMM [O] „stur, grantig“) und Z. 18 (R02-GEHEIM [G] „Brummbär“); K1-GRUNDWAHRHEIT.md Z. 56 (OA-24 [O] „Der Burgwart brummt“) und Z. 176 (BW-ZUSTAND [O] „grantig-komisch“); K2-ROLLEN-13-20.md Z. 53 (R18-ÖFFENTLICH [O] „brummte“); H-209 [G] „der Burgwart brummte“.
- Regel: Auftrag Punkt 21 (a) (keine „brummig“-Wesen bei Älteren). Die Regel galt nach E54 für die Stadtbewohner; für den Burgwart (71) ist sie nicht ausdrücklich gesetzt.
- Begründung: Dasselbe Altersklischee, das E54 bei B08, B14 und B28 entfernt hat, bleibt beim Burgwart in Kanon-O-Zeilen bestehen.
- Vorschlag: Im Overlay (nachtlauf/kanon/ANPASSUNG.md) „brummt/brummte“ und „Brummbär“ durch neutrale Verben ersetzen (z. B. „sagt knapp“). Die Kanon-Dateien bleiben unverändert (Nachtlauf-Regel). Ob „grantig“ bleibt, entscheiden die Kanon-Autoren (FÜR DEN NUTZER).

### Befund 6 (gering): Geld- und Kälte-Färbung bei den beiden Frauen in Geldberufen (R13, R15)

- Datei: nachtlauf/kanon/ANPASSUNG.md Z. 38 (ERSETZE-27) und Z. 39 (ERSETZE-28); Quelle krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-13-20.md Z. 9 (R13-GEHEIM [G]), Z. 11 (R13-VERBINDUNGEN: „die Gläubigerinnen“), Z. 27 (R15-GEHEIM [G]).
- Zitate (wirksam): R13-GEHEIM „Sie drängt hart auf ihr Geld und wirkt dadurch unnachgiebig“; R15-GEHEIM „Sie redet ständig über Geld, Schäden und Versicherungen … und wirkt dabei seltsam ungerührt“.
- Regel: Leitplanke 4 (als Hinweis). Auftrag Punkt 19: Namen sind keine Herkunftsangabe und werden hier nicht als Herkunftsbefund gewertet.
- Begründung: E47 hat die Adjektive „kalt und berechnend“ und „denke nur in Beträgen“ ersetzt. Die Färbung „Geld und Kälte“ bleibt bei genau den beiden Frauen in Geldberufen, während Geldthemen bei den Männern als Handlung auftreten (R04 Mietbetrug, R16 Kredit). Das ist ein Geschlechtermuster in der Färbung, kein Herkunftsbefund.
- Vorschlag: Färbung auf Verhalten oder Situation umstellen, z. B. R15 „spricht dabei fast nur über Fristen und Beträge“; bei R04 oder R16 eine vergleichbare geldbezogene Färbung setzen. Entscheidung des Nutzers.

### Befund 7 (gering): Wolle- und Grünspur nach Kanon v1.0 nicht mehr eindeutig (R03, R04)

- Quellen (Kanon, Hinweis): K2-ROLLEN-KERN.md Z. 58 (BW-AUSSAGE-3 [O] „drunter ein Ärmel, was Gestricktes, Wolle“); K3-HINWEISE.md Z. 34 (H-14 [O]); K3-HINWEISE-P3.md Z. 40 (H-337 [G]) und Z. 76 (H-354 [G]) „kalte Hand, Wolle am Ärmel“; K2-ROLLEN-05-12.md Z. 58 (R10-LÜGE [G]). Figuren: K9-LOOKBIBEL.md (LF-R04 „olive green chunky knit sweater“); packages/pixel_engine/data/figuren/rollen.json (R03 oberteil strickjacke-zopf, Grünstufe 2; R04 oberteil pullover, Grünstufe 4).
- Regel: Konsistenz der Spuren mit den Figurenbildern (Kanontreu, Fairness). E27 M5 gilt für die Spuren des Falls, nicht für die Figurenbilder.
- Begründung: Vor v1.0 war die Wolle-Spur bei R03 eindeutig. Mit dem Strickpullover von R04 trägt ein zweiter Verdächtiger denselben Stoff am Ärmel. Zusammen mit dem grünen Oberteil (OA-10 „was Grünes“) trennt die Spur R03 und R04 nicht mehr sauber. Das ist kein Widerspruch zum Kanon. E45 hat aber nur die Sichtbarkeit der Strickware geprüft, nicht die Spurenlogik. Neuer Grund.
- Vorschlag: Kanon-Autoren prüfen die Wolle-Spur, z. B. durch das Zopfmuster als Merkmal bei R03 in BW-AUSSAGE-3 und H-14. Der Nachtlauf ändert den Kanon nicht.

### Befund 8 (gering): Abweichung im Entscheidungslog zur Jeansfarbe R03

- Datei: nachtlauf/ENTSCHEIDUNGSLOG.md Z. 398 („R03s erfundene Jeansfarbe ist jetzt blau [6,4] statt hellgrau“). Daten: packages/pixel_engine/data/figuren/rollen.json (R03 unterteil jeans, rampe 6, Stufe 3) und karten.json (R03 hose [6, 3]).
- Regel: Nachvollziehbarkeit des Kartenstands (E45, Z-03).
- Begründung: Log und Daten stimmen nicht überein. Die Daten sind die maßgebliche Quelle, der Log-Eintrag ist veraltet oder falsch.
- Vorschlag: Log auf [6,3] korrigieren oder die spätere Änderung nachvollziehbar erklären.

## 4. Gegenproben und Abwägungen (Punkt 9a)

- Bestätigt ohne neue Bewertung: E23 (Burgwart „benommen“, ERSETZE-17), E27 (Kanon-Spuren gegen die Täterin, M5; Nachtpläne B03, B07, B10), E31 bis E37 (Zeiten, Kleinteile, Taschenuhr), E38 (Familienfelder, Wanderstiefel aus zwei Teilen), E39 bis E41 (Kanon v1.0, LISTE-ZEITEN, FM-1 in der Quelle als Nutzerentscheidung), E42 bis E44 (Himmel, Teestube, Punsch, Silberhau), E46 (Lampenmarke, Lüftungsschacht), E48 (Wurzeln entfernt), E49 bis E53 (Schlosskeller und HD nicht Gegenstand; Layout-Prüfsumme nicht geprüft).
- Neu bewertet mit neuem Grund: E50 und E54 (Alters- und Geschlechtsmuster). Die Hochzeits-, Klatsch-, Besserwisser- und Haushaltsmuster wurden dort nicht erfasst (Befund 1 und 2). E45 (Kanon-Strickware, nur Sichtbarkeit geprüft, Befund 7). E47 (Färbungen R13 und R15: die Adjektive wurden getauscht, die Färbung blieb; Befund 6, nur als Hinweis).
- Nicht als Befund gewertet, mit Grund: „Einspruch!“ (allgemeines Gerichtswort, E27, E50); „Besserwisserin“ (R18, Kanon-G unverändert; in Befund 1 nur als Hinweis); „Punschkessel“ (Gerät, alle Trinkstellen alkoholfrei, E46); „Kater“ (Katze, nicht Katerstimmung); „Geisterstunde“ (geläufige Redewendung und Track-Titel); „Lindenbaum“ (Name eines Pflegehauses, kein Zitat); „Der Gamsbart zeigt …“ mit „Bei Nebel … Tannenholz“ (allgemeiner Spruch, E43); der Gerber-Eintrag H-045 und die „Fremde“ in H-012 (Ortsfarbe); Verletzung nur „Beule“, „benommen“, „Kühlpack“ (BW-ZUSTAND, OA-20, OA-23); Herkunftsfeld BW-STAMM (Spielwelt, nicht angezeigt).

## 5. Ergebnis je Prüfgegenstand

- Leitplanken: nein. Befund 1 und Befund 2 (Klischees über Gruppen, Leitplanke 4). Eingehalten: kein Alkohol und keine Drogen auch nicht als Andeutung (Punsch alkoholfrei an allen Trinkstellen; „bar“ nur als Bargeld; Wachs-„Spritzer“); kein Blut im Detail (Beule, benommen, Kühlpack); keine Hexen, kein Walpurgis, kein Teufel; keine Herkunft als Motiv, Indiz oder Pointe; kein Text, der vor der Auflösung zusätzlich die Täterin nahelegt (Stadt-, Bewohner- und Hausdaten geprüft; Kanon-Spuren nach E27 M5).
- Kanontreu: ja. Keine Abweichung von den O-Datensätzen oder vom Overlay festgestellt. Die Look-Änderungen (ERSETZE-34 bis -38) und die Befunde 5 bis 7 sind Overlay- oder Kanon-Entscheidungen, keine Abweichung.
- Plagiatsfrei: ja. Die Watchlist (Filme, Serien, Spiele, Bücher, Märchen, Lieder) ergab keine Zitate. Die Treffer „Einspruch!“, „Geisterstunde“, „Hab ich dich!“, „Ich bin nicht hier“ und „Schönes Licht, schreckliche Lage“ sind allgemeine Wörter oder eigene Wendungen. Keine Figur aus einem fremden Werk außer dem Kanon-Namen Kunibert (Rüstung).

Leitplanken eingehalten: nein · Kanontreu: ja · Plagiatsfrei: ja
