HEAD 063be37

# Gegenprüfung Inhalt · Auftrag A-702p · gegenpruefer_inhalt_17

**Urteil:** Leitplanken eingehalten: ja · Kanontreu: ja · Plagiatsfrei: ja
**Befunde:** hoch 0 / mittel 2 / gering 5

## 1. Stand und Vorgehen

- Schritt 0: `git merge --ff-only nachtlauf/burgstadt` von d92a675 auf 063be37 (Fast-Forward). Der Worktree war vorher sauber und ist es nach dem Lauf bis auf diesen Bericht.
- Testbefehl Punkt 11 (Dart aus dem Flutter-SDK unter /opt/flutter/bin): `dart pub get --offline`, danach `dart run bin/leitplanken.dart --burgstadt`. Ergebnis: 119 Dateien geprüft, 0 Treffer, 0 Fehler, 0 Warnungen. Der Scanner findet keine Andeutungen; deshalb die manuelle Lektüre unten.
- Keine Daten geändert, kein Commit, kein Push, kein Build. Hilfsdateien nur im Scratchpad-Unterordner `gegenpruefer_inhalt_17`. Frühere Berichte in `nachtlauf/auftraege/A-702/` nicht gelesen.
- Abnahme (Punkt 10): Vollständig gelesen wurden alle Textfelder und Datensätze der Dateien aus Punkt 5 (bewohner.json, haeuser.json, innenraeume/fallorte.json und haeuser.json, rollen/faehigkeiten.json, texte/erzaehler.json, texte/tutorial.json, figuren/karten.json, figuren/rollen.json, teile_kleidung.json und teile_koepfe.json bis auf die Geometrie), dazu ANPASSUNG.md (170 Zeilen), alle 223 öffentlichen Zeilen [O] aus K1 bis K9, der Entscheidungslog E23 bis E43 und der Diff 659d3ed..HEAD der K-Dateien. Nicht einzeln gelesen wurden Zahlen- und Koordinatenarrays (koerper, Materialzahlen) und die Rasterzeichen der Innenraumkarten. Sie wurden per Skript auf Grün (Rampe 5), Teilelisten, Namen und Ids geprüft.

## 2. Befunde

### B1 · mittel · Herkunftsmarkierte Eigentumsmarke als Spur (Abwägung E43 widersprochen, neuer Grund)

- **Stelle:** K1 LISTE-GEGENSTÄNDE [O] und BSO-03 [O]; K3 H-28 [O]; K8 GL-19 [O]; K2 R01-STAMM [O]; `faehigkeiten.json`, `rollen[0].beruf`.
- **Zitat:** „Stablampe mit Klebeband „HODŽIĆ VT · 3““ (LISTE-GEGENSTÄNDE). GL-19: „Schreibweise: die Stablampe „HODŽIĆ VT · 3“ | Aussprache: HOD-schitsch fau-te drei“. R01-STAMM: „Aussprache: AD-nan HOD-schitsch“, „Wurzeln: bosnisch“.
- **Regel:** Leitplanke 4: „Herkunft ist nie Motiv, Indiz oder Pointe.“
- **Zu E43:** E43 hält die Marke für „kein Herkunftsindiz“, weil die Spur über das Gerät laufe und nicht über die Herkunft. Neuer Grund gegen diese Abwägung: (a) GL-19 ist eine öffentliche Glossarzeile [O]. Sie schreibt am Beweisstück selbst die fremdsprachige Aussprache vor. Die Herkunft wird also im Beweisstück ausgespielt, nicht nur im Namen. (b) Die Spur braucht nur die Zuordnung Gerät zu Besitzer. Dafür genügt eine neutrale Kennung. Ein Herkunftsmerkmal, das für die Zuordnung nicht nötig ist, aber den Verdacht prägt, ist genau das, was die Leitplanke ausschließt.
- **Vorschlag:** Kanon-Verantwortung entscheidet. Umsetzbar als Overlay in ANPASSUNG.md mit `@ERSETZE` für die Marke („HODŽIĆ VT · 3“) und die Glossar-Aussprache durch eine herkunftsneutrale Kennung (z. B. Initialen und Firmenkürzel). Die K-Datensätze bleiben unverändert. Bleibt E43 bestehen, dann bitte im Bericht als bewusste Abwägung führen.

### B2 · mittel · Reinigungsfrau als Wisch- und Schweigefigur (Täterinnen-Nähe und Rollenklischee)

- **Stelle:** `bewohner.json`, `bewohner[34]` (B35 Anneliese Gruber, „Reinigungskraft im Rathaus“).
- **Zitat:** „Der Eimer steht noch im Flur, weil nach dem Knall niemand Lust hatte zu wischen.“; „Den Staub erzählt man nicht, der erzählt sich selbst.“; Gerede: „die Reinigungskraft habe den Nebelriesen beim Wischen gesehen, aber sie hat nur gelacht und weitergewischt“; Wesen: „sie putzt jeden Flur so gründlich, dass sie hinterher jeden Winkel kennt“.
- **Regel:** Leitplanke 5 (kein Text, der vor der Auflösung die Täterin nahelegt; nach E27 gilt das für Stadt- und Bewohnertexte) und Leitplanke 3 (Klischees über Gruppen).
- **Begründung:** Laut E27 gehört das Verwischen zum Gegenspiel der Täterseite (Fähigkeit R03, `faehigkeiten.json`). Die Spurenart „verwischt“ ist für alle mit Detektivblick sichtbar. Die Bewohnerin bündelt Wischen, Staub, Schweigen und Winkelwissen in einer Frauenrolle mit Putzberuf. So entsteht eine Spur, die Methode und Gruppe verknüpft. Die Figur steht außerhalb der Clique.
- **Vorschlag:** Die Sätze „Der Eimer … zu wischen“ und „Den Staub erzählt man nicht …“ sowie das Gerede „beim Wischen gesehen“ streichen oder neutral fassen. Den Wesenszug „kennt jeden Winkel“ auf eine andere Eigenschaft umstellen.

### G1 · gering · Geschlechterrollen in Dienst-, Pflege- und Hausarbeit

- **Stelle:** `bewohner.json`: Dienstberufe bei 8 von 21 Frauen (B01, B07, B15, B21, B25, B29, B35, B41), bei 3 von 23 Männern (B20, B24, B26). `haeuser.json`: H-117 „Die Hausherrin … spinnt im Winter daraus Socken für die ganze Gasse.“; H-118 „Die Frau im Haus zieht die Leine jeden Montag straff“; H-119 „Die Verkäuferin staubt es jeden Morgen ab“; H-120 „die Hausherrin spült ihn abends sorgfältig aus“.
- **Regel:** Leitplanke 3 (Klischees über Gruppen; Geschlecht zählt als Gruppe). Die Einzelbeschreibungen sind unauffällig; das Muster ist es.
- **Vorschlag:** Rollen ausgleichen (z. B. Pflegekraft, Friseur oder Reinigungskraft männlich). Hausarbeitssätze in H-117, H-118 und H-120 neutral fassen.

### G2 · gering · Bock-Motiv mit Teufelsanklang

- **Stelle:** `haeuser.json` H-073 (Haus zum Geißbock: „Der Bock stößt, wo der Weg sich teilt · 1636“) und H-123 (Haus zum Ziegenbock: „Der Bock stößt, wer ihn ärgert · 1731“).
- **Regel:** Leitplanke 5 (kein Teufel). Der Bock ist im Volksglauben ein Bild für Teufel und Hexensabbat; „stößt“ verstärkt die Anmutung.
- **Vorschlag:** Anderes Tier wählen (z. B. Hahn, Falke, wie in H-009 der Hirsch) und die Inschrift ohne „Bock“ fassen.

### G3 · gering · Besen und Kamin als Hexenbild

- **Stelle:** `bewohner.json`, `bewohner[16]` (B17 Reinhold Maier, Schornsteinfeger): `zubehoer` „Kehrbesen“; `nacht` „Er geht mit dem Besen die Gasse hinauf, weil ein Kamin dort seit dem Knall nicht mehr zieht.“ und „Er schläft erschöpft im Stuhl, den Besen an der Wand.“
- **Regel:** Leitplanke 5 (keine Hexen). Besen, Kamin und Nacht sind das klassische Hexenbild, auch wenn der Beruf echt ist.
- **Vorschlag:** Kehrgerät oder Kehrstange statt Besen, die Gassenszene entsprechend umformulieren.

### G4 · gering · Namensnähe „Kunibert“ (Plagiat-Hinweis)

- **Stelle:** K1 K-005 [O] („die Ritterrüstung „Kunibert““), OA-07 und OA-08 [O]; K8 GL-05 [O] („Rüstung | Schreibweise: Kunibert (ohne Artikel)“).
- **Prüfung:** Websuche (Abschnitt 6). „Ritter Kunibert“ ist als Figur einer Folge der Kinderserie Nonstop Nonsens („Didi in der Ritterzeit“, 1978, mit Burggespenst) und eines Ravensburger-Kinderspiels (2006) belegt. Die Rüstung hier ist eine andere Figur ohne Übernahme von Handlung oder Familie. Kunibert ist zugleich ein historischer Heiligenname (Kunibert von Köln). Keine Kopie, aber eine Namensnähe, die die Leitplanke „keine Namen aus Serien und Spielen“ formal berührt.
- **Vorschlag:** Kanon-Verantwortung: den Namen beibehalten und im Bericht als Heiligenname führen, oder per `@ERSETZE` umbenennen (betrifft mehrere Zeilen, Schreibweise exakt).

### G5 · gering · Handschuhe als Spurenmotiv

- **Stelle:** `bewohner.json`, `bewohner[33]` (B34 Tobias Renner): `zubehoer` „Handschuhe“; `nacht` „Er fällt auf die Matratze, die Handschuhe noch an den Händen.“
- **Regel:** Leitplanke 5 (keine Täterinnen-Nähe). Handschuhe sind das gängige Bild für Spurenvermeidung und stehen im Spiel neben verwischten Abdrücken.
- **Vorschlag:** Streichen.

## 3. Punkt 15: Kanon v1.0 und Overlay

- Diff 659d3ed..HEAD der K-Dateien: 29 geänderte [O]-Zeilen (alle geprüft), 133 geänderte G- und L-Zeilen (nur auf Widerspruch geprüft, nicht zitiert).
- **LISTE-ZEITEN:** Die Basis im Overlay ist wortgleich mit dem v1.0-Text (17:40 bis 00:30). Die Ergänzung mit Stadtzeiten passt dazu, ebenso die Regel, dass Zeitangaben in O-Datensätzen als Aussagen gelten. Im Spieltext taucht keine Zeitangabe außerhalb von Liste, Rolle, Hinweis oder Beweisstück auf. Die Nachtpläne der Bewohner sind Datenfelder ohne Textausgabe (E27 G7).
- **Familienfelder:** Die STAMM-Zeilen sind im Diff unverändert. Das Overlay ersetzt nur den Satzteil. Kein Konflikt mit v1.0.
- **Begriffsersetzungen:** Alle Harz-Bezüge in den öffentlichen Zeilen (Oberharz, Harzer, Osterode, Nationalpark Harz, „im Harz“, Brockengespenst, „in the Harz mountains“, „from the Harz mountains“) sind durch ERSETZE-01 bis ERSETZE-18 erfasst. Der Punsch (OA-23, K8, K9) ist durch ERSETZE-19 bis ERSETZE-21 alkoholfrei. „bewusstlos“ wird durch ERSETZE-17 in BW-ZUSTAND und OA-20 ersetzt. Im Spieltext außerhalb des Overlays gibt es keinen Harz- oder Brocken-Begriff.
- **Bewusste Abweichungen vom O-Wortlaut, alle dokumentiert:** OA-27 (Serpentinen, „Bis zum Morgengrauen“, E42), BW-STAMM (Herkunft), Familienfelder (E38 und E39), LISTE-ZEITEN (Ergänzung). Ein undokumentierter Widerspruch wurde nicht gefunden.
- **Aussehen R03 und R04:** `rollen.json` entspricht LF-R03 und LF-R04 v1.0. R03: Strickjacke mit Zopfmuster (Rampe 5, Stufe 2), Bluse (0/7), Jeans blau (6/4), Wanderstiefel (2/3), Notizbuch entfernt. R04: olivgrüner Strickpullover (5/4), kariertes Hemd (6/4), Jeans (6/3), Wanderstiefel (2/3), Uhr. `karten.json` setzt das um: Der Grundkörper des Rumpfs ist im Material „oberteil“ gefärbt (`figur.dart`), bei R04 also olivgrün; der Hemdkragen liegt im Material „darunter“. Grün (Rampe 5) kommt in `karten.json` und `rollen.json` nur bei R03 und R04 vor (Skriptprüfung).
- **Phasenbeginn 00:30** (STADT-05, Overlay) passt zum Kanon (L-Zeile, nur geprüft).
- **Himmel:** Nebel nur im Tal. Die Oberstadt hat Mond, Raureif und Frost. Die Legende vom Nebelriesen am Friedhof (H-S23) bleibt nach E43 zulässig.
- **Nicht geprüft:** Gesprächsfenster und Lagerunden nach ZM-2 sind Spielmechanik im Code, kein Spieltext.

## 4. Abwägungen aus Punkt 9a

- **E43 widersprochen:** Eigentumsmarke (B1), neuer Grund siehe B1.
- **Verifiziert und akzeptiert:** E23 und E29 (bewusstlos zu benommen, Overlay). E27 (Kanon-Spuren, Fähigkeit R03 nur für R03, „Einspruch!“, LISTE-ORTE, Teile im Code; `kopf-kopftuch` in `karten.json` ungenutzt). E31, E33, E34 und E35 (Stollen, Schacht, Wehrgang, Zeiten als Aussagen). E37 (Kleinteile nicht gezeichnet). E38 (Familienfelder, Wanderstiefel aus zwei Teilen, Talg; Eltern-Berufe ohne herkunftsspezifisches Muster, auch die deutschen Väter sind Handwerk oder Industrie). E39 (Großmutter-Motive, Teil-Kennungen, `frisur-afro` ungenutzt). E40 (Grün nur R03 und R04, neutrale Anrede, Dutt bewusst offen). E41 (Abgleich und Aussehen, siehe Abschnitt 3). E42 (Laken im Overlay, Phasenbeginn, Silberhau, OA-27). E43 (Himmel, Teestube, Familienfelder R05, R12 und R18, Punsch; R05-Frisur „bob“ ist in `rollen.json` und `karten.json` einheitlich).
- **Nicht als Befund gezählt:** Die Besetzung mit 16 von 20 Rollen nichtdeutscher Wurzeln (öffentliche Wurzeln-Felder [O]). Das ist eine Frage der Kanon-Verantwortung, keine Leitplankenverletzung im Text.

## 5. Geprüft ohne Befund

- **Alkohol und Drogen:** keine Treffer. Der Punsch ist überall alkoholfrei. Gaststätten sind Teestube, Bäckerei und Apotheke.
- **Blut und Verletzung:** nur Beule, benommen, Kühlpack.
- **Vampir, Walpurgis, Teufel, Hexe:** außer B1, G2 und G3 keine Treffer.
- **Herkunftsklischees gegen Rumänien, Roma oder andere Gruppen:** keine Treffer in Texten, Namen und Bewohnerdaten.
- **Papier-Requisiten** (Notizbuch bei B01, B04 und B06 u. a.): nicht gezeichnet. `bewohner_karten.dart`: „Notizbuch und Laterne bleiben unsichtbar.“ Kein K9-Befund.
- **Grün:** nur R03 und R04.

## 6. Plagiatsprüfung

- **Methode:** Stichwortsuche über alle Spieltexte, das Overlay und die öffentlichen Kanon-Zeilen (Filme, Serien, Spiele, Bücher, Lieder, bekannte Figurennamen, Zitatfragmente) sowie manuelle Lektüre. Keine Übereinstimmung mit Film-, Serien-, Spiel-, Buch- oder Liedtexten.
- **Websuche „Nebelriese“:** keine bekannte fiktive Figur. Die Treffer sind der Roman „Nebelmacher“ (Bernhard Trecksel, Figur Clach) und die Bodensee-Sage „Nebelmännle“. Quelle: https://www.lesejury.de/bernhard-trecksel/buecher/nebelmacher/9783734160325
- **Websuche „Kunibert“ (G4):** Quellen https://www.thetvdb.com/series/nonstop-nonsens/episodes/433804 und https://www.ebay.de/p/1405145341 (Gebrauchtangebot; die Angaben sind nicht unabhängig geprüft). Nur Ausschnitte der Treffer gelesen.
- **Ergebnis:** keine Kopie. Die Namensnähe bei „Kunibert“ ist gering.

## 7. Urteil

- **Leitplanken: ja.** Keine ausdrückliche Regel ist verletzt. B1 und B2 sind Abwägungsbefunde mit Änderungsvorschlag, G1 bis G5 sind geringe Hinweise.
- **Kanontreu: ja.** Die Overlay-Abweichungen sind dokumentiert, undokumentierte Widersprüche wurden nicht gefunden, das Aussehen von R03 und R04 ist konsistent.
- **Plagiatsfrei: ja.** Die Namensnähe „Kunibert“ ist als Hinweis geführt (G4).

Leitplanken eingehalten: ja · Kanontreu: ja · Plagiatsfrei: ja
