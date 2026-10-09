HEAD e13255f

Gegenprüfung Inhalt · gegenpruefer_inhalt_32 · Auftrag A-702v (Schwerpunkt Punkte 15, 18, 19, 21)

Ablage: Die Datei nachtlauf/auftraege/A-702/gegenpruefer_inhalt_32_bericht.md ist nicht geschrieben. Die Vorgabe dieses Laufs lässt keine Berichts-.md-Dateien zu. Der vollständige Text steht in diesem Feld und kann von dort abgelegt werden.

1. Stand und Vorgehen
- Schritt 0: git merge --ff-only nachtlauf/burgstadt, von e7e4219 auf e13255f. git status danach sauber. Keine Daten geändert, kein commit, kein push, kein Build. dart pub get --offline nur wie im Testbefehl.
- Werkzeuge: kanon.dart --pruefe mit 0 Befunden (Original 1211, wirksam 1276 Datensätze, 65 neu, 86 geändert, 38 ERSETZE). kanon.dart --wirksam: 264 O, 559 G, 453 L, 9 DW. leitplanken.dart --burgstadt: 125 Dateien, 0 Treffer. Der Scanner erfasst keine Andeutungen, deshalb habe ich selbst gelesen.
- Vollständig gelesen: der Auftrag (Punkte 1 bis 22), ENTSCHEIDUNGSLOG E23 bis E55 (Zeilen 147 bis 698), ANPASSUNG.md (204 Zeilen), alle 264 O-Datensätze des wirksamen Kanons, alle 9 DW-Ergebnisse, alle Kanon-Änderungen aus git diff 659d3ed HEAD (K1 bis K9, 426 geänderte Zeilen, alle 104 geänderten O- und G-Zeilen), alle 44 Stadtbewohner (Tabelle mit Geschlecht, Alter, Beruf, Wesen), die 19 Haustexte aus E54 und E55, alle Datensätze von R13 und R15.
- Nur gezielt (Stichwort oder Stichprobe): übrige G-Datensätze, übrige Häuser in haeuser.json, innenraeume, fallorte, faehigkeiten.json, rollen.json, karten.json, teile_*.json, erzaehler.json, tutorial.json. Damit ist Punkt 10 (alle genannten Dateien vollständig gelesen) nicht erfüllt. Das Urteil ist entsprechend mit diesem Vorbehalt zu lesen.
- Keine anderen Prüfberichte gelesen. Der Ordner nachtlauf/auftraege/A-702/ ist nicht durchsucht.

2. Urteil
Leitplanken eingehalten: nein. Befund 1 ist ein Klischee über eine Gruppe (Leitplanke 4). Befunde 2 und 3 stützen es.
Kanontreu: ja. Ich habe keinen Widerspruch zwischen den angezeigten O-, G- und DW-Texten und den Kanon-O-Datensätzen gefunden. Die Overlay-Abweichungen sind dokumentiert; die eine Präzisionsabweichung (Befund 6) ist gering.
Plagiatsfrei: ja. Keine Kopie erkannt. Eine Volltextsuche war nicht möglich.

3. Befunde

Befund 1 (hoch): Geld- und Kälte-Klischee bei zwei Frauen mit türkisch klingenden Namen (R13 Selin Aksoy, R15 Derya Öztürk).
- Stelle: K2-ROLLEN-13-20.md; Overlay ANPASSUNG.md Z. 38 und 39 (ERSETZE-27 und -28). Angezeigt: R13-GEHEIM, R13-STAMM, R13-ÖFFENTLICH, R15-GEHEIM, R15-ÖFFENTLICH.
- Zitat: R15-GEHEIM: „Sie redet ständig über Geld, Schäden und Versicherungen, sogar über Kunibert, und wirkt dabei seltsam ungerührt.“ R13-GEHEIM: „Sie drängt hart auf ihr Geld und wirkt dadurch unnachgiebig.“ R13-ÖFFENTLICH: „antwortet sie trocken „Achthundert, achthundert, achthundert““.
- Regel: Leitplanke 4 (keine Klischees über Gruppen; Herkunft nie Indiz). Punkte 19 und 21.
- Begründung: E47 hat erkannt, dass die beiden Adjektive „zwei türkischstämmige Frauen in Finanzberufen mit Geldgier und Kälte“ verbinden, und sie ersetzt. Der Grund trägt nach der Ersetzung nicht mehr: (a) „seltsam ungerührt“ meint dasselbe wie „kalt“; die Assoziation Geldgier plus Kälte bleibt. (b) Das Geld-Thema ist kein Einzelwort, sondern Dauer-Komik (Bankdeutsch, Tilgungsplan, Achthundert-Ruf, Rechnung bei jedem Malheur). (c) Das Muster reicht weiter: Geld-Färbungen liegen bei drei Frauen (R05 mit Quittungs-Pedanterie, R13, R15), und alle drei haben nichtdeutsche Namen. Der deutsch benannte Geldbetrüger R04 ist ein Mann. Dass die Geldthemen an Beruf und Lage hängen (E47), reicht nicht, weil gerade Finanzberufe bei beiden Frauen das Klischee nähren.
- Vorschlag: Bei R13 das Geld-Thema an die konkrete Schuld (Jonas) binden statt Dauer-Komik; bei R15 „seltsam ungerührt“ streichen; Geldthemen auf mehrere Rollen verteilen.

Befund 2 (mittel): Herkunft als Folklore: Café mit den Rezepten der Großmutter (R13).
- Stelle: K2-ROLLEN-13-20.md; R13-GEHEIM [G] und R13-STAMM [O] (Sprechweise 3).
- Zitat: „ein kleines eigenes Café mit den Rezepten ihrer Großmutter“; „wird weich und ausführlich, sobald es ums Backen geht“.
- Regel: Leitplanke 4; E38 (Muster „Herkunft → Folklore“).
- Begründung: E38 hat bei den Familienfeldern Speisen als Herkunftsmerkmal entfernt, weil das Muster das Problem ist, nicht die Einzelzeile. Hier liegt dieselbe Kopplung in Geheimnis und Sprechweise derselben Figur: Name, Finanzberuf, Großmutter-Rezept, Backen. Neu gegenüber E38 ist, dass das Motiv hier der Lebensplan ist.
- Vorschlag: Café-Motiv ohne Großmutter-Rezept; Backen-Zug streichen oder einer anderen Figur geben.

Befund 3 (mittel): Gewalt-Kompetenz als Verdacht bei einem männlichen Sanitäter mit nichtdeutschem Namen (R06 Diyar Kaya).
- Stelle: K2-ROLLEN-05-12.md Z. 18 (R06-GEHEIM, wirksam mit ERSETZE-17); R06-ÖFFENTLICH [O]; G1-29, G2-15 und H-140 (Feuerlöscher).
- Zitat: „weiß als Sanitäter genau, wie man jemanden kurz benommen macht, ohne ihn ernst zu verletzen“; „Nach dem Schrei marschiert er mit dem Feuerlöscher im Anschlag durchs dunkle Gewölbe, „falls das Gespenst brennt““.
- Regel: Leitplanke 4 (Gewalt-Klischee über eine Gruppe); Leitplanke Herkunft (Verdacht darf nicht an der Herkunft hängen).
- Begründung: v1.0 hat die frühere Fassung „eine Waffe durchs Gewölbe; ein kräftiger Mann mit einem schweren Gegenstand im Dunkeln macht Leute nervös“ gestrichen. Die Schlag-Kompetenz blieb als „Scheinbare Färbung“ bei der einzigen männlichen Figur, deren Verdacht auf Schlag-Können beruht, und sie ist nichtdeutsch benannt. Seit E55 ist der Punkt als „R06 Färbung“ an die Kanon-Autoren gegeben, aber nicht entschieden.
- Vorschlag: Sanitäter-Wissen auf Erste Hilfe begrenzen (z. B. stabile Seitenlage); den Feuerlöscher-Gag einer Figur ohne Verdachtsmoment geben oder streichen.

Befund 4 (gering): Geschlechter-Gag im Haustext H-136.
- Stelle: packages/burgstadt_core/data/stadt/haeuser.json, H-136 „Haus zum Grenzstein“, Feld geschichte.
- Zitat: „Die Hausherrin misst jeden Sommer nach und kommt immer auf ein anderes Ergebnis.“
- Regel: Punkt 21 (Klischee Geschlecht); E55 (Haltbar 2).
- Begründung: E55 hat den Messfehler vom Hausherrn auf die Hausherrin verlegt. Der Gag trägt damit das Muster „Frau misst falsch“.
- Vorschlag: „Die Nachbarn messen jeden Sommer nach und kommen immer auf ein anderes Ergebnis.“

Befund 5 (gering): Wesenszüge nach Geschlecht und Alter (Stadtbewohner).
- Stelle: packages/burgstadt_core/data/stadt/bewohner.json, Feld wesen: B38 (73), B01 (66), B05 (74) gegen B08 (81), B14 (70), B26 (68), B28 (84). Frauen allgemein herzlich (B03, B07, B16, B25), Männer wortkarg (B06, B18, B34, B44).
- Zitat: B38 „Spitzzüngig und gutmütig, sie näht Hochzeitskleider und kritisiert jede Naht“; B01 „Streng im Ton und weich im Herzen“; B08 „Ruhig und treu“; B06 „Wortkarg und pflichtbewusst“.
- Regel: Punkt 21 (Klischee Alter und Geschlecht); E54 (Alters- und Gruppenwörter bereinigt, Wesenszüge nicht).
- Begründung: Muster, keine Einzelzeile: ältere Frauen streng oder spitz, ältere Männer gutmütig oder höflich; Frauen warm, Männer schweigsam.
- Vorschlag: B38 „spitzzüngig“ zu „genau und direkt“; je ein Wesenszug pro Geschlecht über Kreuz tauschen (z. B. eine warme Note bei B06).

Befund 6 (gering): LISTE-ZEITEN weicht von Kanon v1.0 ab (00:01 durch „kurz nach Mitternacht“ ersetzt).
- Stelle: wirksam @LISTE-ZEITEN [O]; K1-GRUNDWAHRHEIT.md Z. 29 (v1.0: „00:01 der Burgwart wird in der Speisekammer gefunden …“) und Z. 52 (OA-20, „Zeit: 00:01“); ANPASSUNG.md Z. 86 (Overlay).
- Zitat Overlay: „kurz nach Mitternacht wird der Burgwart in der Speisekammer gefunden und kommt zu sich“.
- Regel: Maßstab Kanon (Punkte 5 und 15); der Overlay ersetzt nur, was nötig ist.
- Begründung: E44 hat die Zeit nach einem Quellenabgleich geändert (00:01 gegen 00:00:25, 00:00:50, 00:01:30). Das trägt nicht: 00:00:50 rundet auf 00:01, OA-20 nennt selbst 00:01, und alle anderen öffentlichen Zeiten der Liste sind numerisch (00:02, 00:03, 00:05). Die Liste der öffentlich bekannten Zeitpunkte wird dadurch unvollständig.
- Vorschlag: „00:01“ wieder setzen (Wortlaut v1.0).

4. Geprüft ohne Befund
- Alkohol und Drogen: Scanner 0. Punsch überall alkoholfrei; „Punschkessel“ ist nur Gerätename (E46, E50). Gastbetriebe: Teestube „Zur Laterne“ und Bäckerei. Keine Kneipe, keine Bar.
- Verletzung und Blut: nur Beule, benommen, Kühlpack; „keine offene Wunde“ (BW-ZUSTAND). Keine Blutdetails.
- Hexen, Walpurgis, Teufel, Film-Vampire: keine Treffer. Kräuter-Motive (B31, H-127) nach E55 unbewertet.
- Herkunft: keine Wurzeln mehr im wirksamen Kanon. „Herkunft“ steht nur noch in der L-Begründung von FM-1 und im Burgwart-Feld „Herkunft: Schartenfels, Bergland“ (E48). Familienfelder ohne Herkunftsorte. Stadt- und Innenraumdaten ohne Herkunftswörter.
- Täterin nahelegen: Stadt- und Haustexte enthalten keine Stiefel-, Stollen-, Wachs- oder Laken-Hinweise. Die Spuren gegen R03 sind Kanon (E27 M5) und nicht gewertet.
- ERSETZE-23 bis -30: im wirksamen Kanon umgesetzt („VT · 3“ ohne Nachname, „fau-te drei“, „Quelle des Schreis“, Firma ohne Nachnamen, Punsch alkoholfrei in Z-0005 und DW1-3). Die Färbungen von R13 und R15 sind im Wortlaut neutral, im Inhalt nicht (Befund 1).
- R03 und R04 gegen rollen.json: stimmig (R03 Strickjacke mit Zopfmuster, Jeans, Wanderstiefel, Notizbuch entfernt; R04 Strickpullover statt Fleecejacke, kariertes Hemd, Wanderstiefel). R15 „dunkelroter Blazer“ in rollen.json.
- Haustexte aus E54 und E55 (H-036, H-054, H-056, H-077, H-080, H-090, H-093, H-103, H-111, H-116, H-117, H-118, H-120, H-122, H-125, H-127, H-139, H-154): Pronomen und Namen stimmig. H-080 (Marienbild, Gebet) ist eine christliche Hausszene, kein Verstoß.
- Zeitgerüst (23:52 bis 00:30; Uhrturm 00:30, 01:30, 03:00, 04:30) konsistent zwischen LISTE-ZEITEN, DET-ALIBI, OA, H-52/HW-301, Meldekarten und STADT-05.
- DW1-1 bis DW3-3: alle neun gelesen. Keine Namensnennung bei DW3-3 (E54), Punsch alkoholfrei, keine Widersprüche.

5. Abwägungen, die ich nicht als Befund werte
- Burgwart „grantig“, „brummt“ und Alter (E34, E37, E55).
- Verteilung der Fallfunktionen (FM-1, L-Datensatz; Nutzerentscheidung N-02, E45, E47).
- Namen als Namen (E48, Punkt 19). Hinweis: Verdachtsmomente liegen überwiegend bei nichtdeutsch benannten Figuren (falsche Fährten R01, R02; scheinbare Färbungen R05, R06, R13, R14, R15), während Täterin R03 und Mietbetrüger R04 deutsch benannt sind. Das ist die Anlage aus E47 und N-02 und fließt nur in Befund 1 und 3 ein.
- VT-Marke (E46), „Einspruch!“ (E27), „Besserwisserin“ und DW3-1 (E50), Dutt, Haube, Glatze (E40, E54), Strickzeug und Gehstock als Einzelrequisiten (E55).

6. Offen für die Kanon-Autoren (ohne Befund)
- R06-Färbung (Befund 3), Wolle- und Grünspur R03 und R04, R13 Granatapfel-Brosche (E55).

Leitplanken eingehalten: nein · Kanontreu: ja · Plagiatsfrei: ja
