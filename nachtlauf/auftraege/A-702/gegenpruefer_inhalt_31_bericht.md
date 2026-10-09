HEAD e13255f

# Gegenprüfung Inhalt · A-702v/31 (gegenpruefer_inhalt_31)

Auftrag A-702v, einunddreißigste unabhängige Runde (Z-12). Geprüfter Stand: `nachtlauf/burgstadt` nach `git merge --ff-only nachtlauf/burgstadt` auf `e13255f` (vorher `e7e4219`). Keine Daten geändert, kein Commit, kein Push, kein Build.

## 1. Vorgehen und Abdeckung

- **Scanner** `dart run bin/leitplanken.dart --burgstadt` (nach `dart pub get --offline`, Dart unter `/opt/flutter/bin/dart`): 125 Dateien, 0 Treffer, 0 Fehler, 0 Warnungen. Der Scanner findet keine Andeutungen; der Text wurde deshalb selbst gelesen.
- **Wirksamer Kanon** `dart run bin/kanon.dart --wirksam`: 1280 Datensätze. Der Spieltext (O-, G- und DW-Ergebnisdatensätze) umfasst 832 Zeilen und wurde vollständig gelesen. Die 453 L-Datensätze (Lösungsdaten) wurden nur stichprobenartig auf Widersprüche geprüft, soweit sie das Overlay und die DW-Ergebnisse betreffen.
- **Vollständig gelesen:** `nachtlauf/kanon/ANPASSUNG.md` (204 Zeilen), `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md`, `nachtlauf/ENTSCHEIDUNGSLOG.md` ab E23 bis E55, `packages/burgstadt_core/data/stadt/bewohner.json` (44 Bewohner), `stadt/haeuser.json` (160 Häuser), `rollen/faehigkeiten.json` (20 Rollen), `packages/burgstadt_spiel/data/texte/erzaehler.json` und `tutorial.json`, `packages/pixel_engine/data/figuren/rollen.json` (alle Textfelder).
- **Nur auf Namen und Bezüge geprüft:** `innenraeume/haeuser.json` (30 Räume) und `innenraeume/fallorte.json` (12 Orte) über Raum- und Objektnamen sowie Stationen. Die Rasterzeilen (`karte`) bestehen nachweislich nur aus Layoutzeichen (keine Wörter). Die Textfelder der Figurenkarten `karten.json` und `teile_*.json` sind Zahlen- und Kennungsdaten; geprüft wurden Verwendung und Figurenbezug (`kopf-kopftuch` und `frisur-afro` werden von keiner Figur genutzt).
- **Kanon-Diff** `git diff 659d3ed HEAD` für `krimidinner/spuk-im-gewoelbe/10_kanon/K*.md`: 29 geänderte [O]-Zeilen (+/-) gegen den wirksamen Kanon geprüft. Die K-Dateien selbst wurden nicht als eigene Quelle vollständig gelesen.
- **Nicht gelesen (wie beauftragt):** `nachtlauf/auftraege/A-702/` (andere Prüfberichte und Gegenproben), `content/party/`, `planung/`, `hd/`.

## 2. Befunde

### Mittel

**M1 · B31 Ruth Köhler: Hexen-Andeutung im Gerücht** (Leitplanke 4: keine Hexen)
- Stelle: `packages/burgstadt_core/data/stadt/bewohner.json`, Eintrag B31, Feld `gerede` (Zeile 1878); Kontext `wesen` (Zeile 1828).
- Zitat: „Man erzählt, die Gärtnerin rede nachts mit dem Nebelriesen, weil er die Beete nicht betritt, aber das ist nur Geschwätz vom Zaun.“
- Begründung (neuer Grund gegen E55): E55 hat die „Kräuterfrau-Andeutung“ bei B31 verworfen, weil es „keine Hexenmerkmale“ gebe. Das Gerücht bringt aber genau ein Hexenmerkmal hinzu: eine ältere Frau, die nachts mit einem Geist spricht. Zusammen mit Kräuterkorb, Hut und dem Satz „sie spricht mit Pflanzen so ausführlich wie mit Nachbarn“ entsteht das Bild der Kräuterhexe. Die Leitplanke „keine Hexen“ ist ausdrücklich, und das Gerücht ist öffentlich lesbar.
- Vorschlag: Gerücht neutral umformulieren, z. B. „Man erzählt, die Gärtnerin habe im Garten einen Schatten für den Nebelriesen gehalten, aber das ist nur Geschwätz vom Zaun.“

### Gering

**G1 · B09 Dörte Wagner: Hunde-Gerücht als Hexen-Muster** (Leitplanke 4)
- Stelle: `bewohner.json`, Eintrag B09, Feld `gerede` (Zeile 558).
- Zitat: „Man sagt, seit der Nebelriese durch die Gassen schleicht, bellen die Hunde im ganzen Viertel, und das liege an der Tierärztin.“
- Begründung: Eine Frau, deren Nähe Tiere unruhig macht, ist das klassische Hexen-Gerücht. E35 hat nur den Satz „Der Hund hatte nur Angst vor dem Dunkel“ geändert, nicht dieses Gerücht.
- Vorschlag: Ursache auf den Nebelriesen oder auf einen Nachbarn verlagern.

**G2 · B19 Antje Brandt: Frau singt beim Kochen** (Leitplanke 4: Geschlechter-Klischee)
- Stelle: `bewohner.json`, Eintrag B19, Feld `wesen` (Zeile 1101).
- Zitat: „sie summt beim Kochen und bringt Kindern das Atmen bei“.
- Begründung: Das Bild der singenden Frau in der Küche ist ein Rollenklischee. E54 und E55 haben die Hausarbeit nur in den Haustexten verteilt, nicht in den Bewohnerbeschreibungen.
- Vorschlag: Tätigkeit ohne Geschlechtercode, z. B. „summt beim Radfahren“.

**G3 · B21 Dagmar Krauß: Friseurin als Vertraute** (Leitplanke 4: Geschlechter-Klischee)
- Stelle: `bewohner.json`, Eintrag B21, Feld `wesen` und `saetze` (Zeile 1280).
- Zitate: „sie sieht den Leuten an, was sie bedrückt, und sagt es selten“ · „Das beruhigt die Leute immer.“
- Begründung: Die Friseurin als Trösterin und Vertraute ist ein verbreitetes Frauenbild. E44 hat „Geschlechterrollen in Dienstberufen“ bei R17 nur vertagt; hier geht es um eine Charaktereigenschaft, nicht um die Berufsverteilung.
- Vorschlag: Eigenschaft streichen oder fachlich begründen, z. B. „sieht im Spiegel, wie müde einer ist“.

**G4 · B13, B16, B38: ältere Frauen mit Handarbeit, Hochzeiten und Tratsch** (Leitplanke 4: Alter und Geschlecht)
- Stellen: `bewohner.json`, B13 `wesen` (Hochzeiten, Lieder) und `gerede` (Zeile 791: „sie zählt auch die Tauben, und die kommen immer zu spät“); B16 `wesen` („weiß zu jeder Hochzeit das Datum“) und `gerede` (Zeile 978: „darin stehen nur die Hochzeitstage der Gasse“); B38 `wesen` (Zeile 2262: „sie näht Hochzeitskleider und kritisiert jede Naht, die sie nicht selbst gesetzt hat“) und `nacht` (Hochzeitskissen).
- Begründung: Drei Frauen zwischen 73 und 88 Jahren erhalten dieselben Motive: Hochzeitserinnerung, Handarbeit, Gerede. E55 hat ein „Altersmuster bei älteren Frauen“ nur über das Gedächtnis verworfen. Das Muster Handarbeit plus Hochzeit plus Tratsch ist davon nicht erfasst. Schwere gering, weil es Einzelzüge sind.
- Vorschlag: B16 das Hochzeitsbuch durch eine Chronik der Gasse ersetzen; bei B38 Hochzeitskleider durch Trachten- oder Taufkleider ersetzen; bei B13 die Tauben-Pointe streichen.

**G5 · H-035 Buchbinderei: Pronomen passt nicht zur Bewohnerin** (Stimmigkeit, Punkt 21)
- Stelle: `packages/burgstadt_core/data/stadt/haeuser.json`, Eintrag H-035, Feld `geschichte` (Zeile 454).
- Zitat: „Die Buchbinderin wohnt im Obergeschoss und klopft abends mit dem Falzbein an die Dielen, damit die Nachbarn wissen, dass er noch da ist.“
- Begründung: Die Bewohnerin (B11, weiblich) wird mit „er“ fortgeführt; der Bezug ist eindeutig die Buchbinderin.
- Vorschlag: „dass sie noch da ist“.

**G6 · H-073 und H-123: Bock-Inschriften** (Leitplanke 4: kein Teufel, kein Walpurgis)
- Stellen: `haeuser.json`, H-073 `inschrift` (Zeile 933): „Der Bock stößt, wo der Weg sich teilt · 1636“; H-123 `inschrift` (Zeile 1555): „Der Bock stößt, wer ihn ärgert · 1731“.
- Begründung: Der Ziegenbock ist in der Folklore ein Teufels- und Walpurgismotiv; die Inschriften zeigen ihn als aggressives Tier. E44 hat diese Punkte nicht als Abwägung entschieden, sondern nach der Abbruchregel (E40) nur an den Nutzer vertagt. Das ist kein Entscheid zur Leitplanke, deshalb zählt die Stelle als Befund.
- Vorschlag: Tier durch ein unverfängliches Motiv ersetzen (z. B. Schwan), beide Inschriften anpassen.

**G7 · „wie ein hungriger Kater“: Spieltext steht in der Ausnahmeliste** (Leitplanke 4, Alkohol-Andeutung; Ausnahmeverfahren)
- Stellen: Spieltext G2-33, Ersatz-Antwort (Datensatz H-245), Quelle `krimidinner/spuk-im-gewoelbe/10_kanon/K4-GESPRAECHE-P2.md` Zeile 31; Ausnahmeeintrag `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md` Zeile 15.
- Zitat: „Die quietscht wie ein hungriger Kater.“
- Begründung: Die Kopfzeile der Ausnahmeliste sagt „Nur Regelzitate und Negativ-Anweisungen, nie Spieltext“. Der Eintrag für K4-GESPRAECHE-P2 ist aber ein Vergleich aus dem Spieltext. Im Deutschen ist „Kater“ zudem doppeldeutig (Katzenjammer). Der Vergleich ist als Katze eindeutig, deshalb liegt keine Verletzung der Alkohol-Leitplanke vor; die Ausnahme ist aber falsch eingetragen.
- Vorschlag: Vergleich ändern (z. B. „quietscht wie eine rostige Angel“) und den Ausnahmeeintrag streichen.

**G8 · „Einspruch!“ als Erkennungsspruch und Signaturstück von R18** (Leitplanke 4: Original statt Kopie)
- Stellen: Kanon R18-STAMM, Feld Sprechweise (`krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-13-20.md` Zeile 52); `packages/pixel_engine/data/figuren/rollen.json` Zeile 369 (Merkmal).
- Zitate: „ruft „Einspruch!“, sobald sie aufgeregt ist, auch bei ihren besten Freunden“ · „runder Anstecker „Einspruch!“ am Kragen“.
- Begründung (neuer Grund gegen E27 G3): E27 hat nur das Wort als allgemeinen Gerichtsbegriff bewertet. Als wiederkehrender Ausruf in der Sprechweise, als Signaturstück und als Ansage „Einspruch!:“ (E1-18, E2-18) wird es zum Markenzeichen einer bekannten Spielfigur. Das Wort allein ist unbedenklich; die Verwendung als Erkennungsspruch ist das Problem.
- Vorschlag: Ausruf und Anstecker durch eine andere Wendung ersetzen, z. B. „Halt, das prüfe ich!“.

## 3. Bereits entschiedene Abwägungen (E23–E55)

Diese Punkte wurden mit Entscheidungslog geprüft und nicht als Befund gezählt, weil kein neuer Grund vorliegt:
- **E27 M5**: Kanon-Spuren gegen die Täterin (z. B. R03 „Angst im Dunkeln“, Wachs- und Sohlenspuren, Lügenregel). Gilt als bewusste Abwägung.
- **E27 H1, E42**: R03-Fähigkeit „Spur verwischen“ nur für R03 sichtbar; DW3-3 nennt nur die Spur.
- **E29, E23**: „bewusstlos“ → „benommen“ (ERSETZE-17). Im wirksamen Spieltext ist „bewusstlos“ nicht mehr vorhanden.
- **E33–E39**: Kleinteile, Requisiten, Teil-Kennungen, ungenutzte Frisur- und Kopftuchteile, Wanderstiefel aus zwei Teilen, Hausarbeit (Haustexte).
- **E38, E43, E44, E48**: Familienfelder ohne Herkunftsorte; „Wurzeln“ gelöscht; der Burgwart-Eintrag „Herkunft: Schartenfels, Bergland“ ist ein Ort der Spielwelt. Keine Herkunftsangabe erscheint als Motiv, Indiz, Pointe oder Klischee.
- **E45, E42**: FM-1 im Kanon-Quelltext liegt beim Nutzer; die Overlay-Fassung nennt nur Rollen-IDs.
- **E46, E47**: Lampenmarke „VT · 3“; Färbungen R13 und R15 folgen dem Beruf; Punsch im Spieltext überall alkoholfrei.
- **E50**: DW3-3 Ergebnis C; Haarfarben-Entscheidung (E54) und Dutt-Frisuren.
- **E55**: Haarfarbe nach Namensklang; Altersmuster bei Gedächtnis; Burgwart „grantig“; Kräuter-Bausteine. Nur M1 (B31) und G4 (Handarbeit und Hochzeit) sind mit neuem Grund erneut aufgenommen.
- **E44**: Geschlechterrollen in Dienstberufen bei R17 wurden nach der Abbruchregel dem Nutzer übergeben; hier nicht erneut bewertet (G3 betrifft eine Charaktereigenschaft).

## 4. Kanontreu

- Die 29 geänderten O-Zeilen aus dem Diff 659d3ed..HEAD (u. a. K-002, K-004, LISTE-ZEITEN, BSO-01, BSO-11, H-02, H-06, H-11, H-14, H-17, H-49, H-50, BW-AUSSAGE-2 und -3, R03-ÖFFENTLICH, R04-STAMM, R11-ÖFFENTLICH, D1-2, D2-2, D3-2, IF-5, ZM-1 bis ZM-4, LR-3, GL-21, LF-R03, LF-R04) sind im wirksamen Kanon übernommen oder durch das Overlay konsistent überschrieben.
- Zeitlinie (LISTE-ZEITEN, STADT-01 bis STADT-05, OA-20, OA-27, Alibis, DW-Ergebnisse): keine Widersprüche zu den O-Zeilen gefunden.
- R03 und R04 (Aussehen): `rollen.json`, `karten.json` und die Look-Anker LF-R03 und LF-R04 stimmen überein. R03: dunkelgrüne Strickjacke mit Zopfmuster über weißer Bluse, Frisur schulterlang mit Spange, Sommersprossen, braune Wanderstiefel. R04: olivgrüner Strickpulli über kariertem Hemd, Armbanduhr mit großem Ziffernblatt, kurzes blondes Haar, Wanderstiefel.
- ERSETZE-Begriffe: keine Rückstände im wirksamen Spieltext (bewusstlos, Brockengespenst, Harz, Osterode, HODŽIĆ VT, Bordeaux, weinrot, rachsüchtig, Silberhauer, Wurzeln). „Herkunft“ steht nur noch im Burgwart-Eintrag (E48).
- Beobachtung ohne Zählung (Glocken, B28 und B37). B28 sagt „Die Kirchenglocken sind stumm, seit der Strom weg ist“, B37 hört dagegen „das Glockenspiel klirren“. Das ist vermutlich nicht gemeint, sollte aber geklärt werden.

**Kanontreu: ja.**

## 5. Plagiatsfrei

- Keine wörtliche Übernahme aus Filmen, Serien, Spielen, Büchern oder Liedern gefunden. Geprüft wurden Track-Texte, Inschriften, Sprüche, Codewörter, Gesprächsbedingungen und Namen.
- Einziger Kandidat: „Einspruch!“ (G8). Das Wort ist allgemein; die Verwendung als Erkennungsspruch ist das Problem.
- „Geisterstunde“ als Track-Titel ist ein gebräuchliches Wort und kein Werktitel (E47).

**Plagiatsfrei: ja.**

## 6. Verdikt

- **Leitplanken eingehalten: nein.** Grund: M1 (Hexen-Andeutung, mittel). Die Befunde G1 bis G4 und G8 verletzen Leitplanke 4 (Klischees über Geschlecht, Alter, Hexen-Motive); G5 ist eine Stimmigkeit; G6 und G7 sind Abgrenzungsfälle.
- **Kanontreu: ja.**
- **Plagiatsfrei: ja.**

Leitplanken eingehalten: nein · Kanontreu: ja · Plagiatsfrei: ja
