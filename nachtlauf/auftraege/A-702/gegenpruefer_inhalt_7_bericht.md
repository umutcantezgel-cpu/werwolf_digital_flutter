# Gegenprüfung Inhalt, Runde 7 (A-702h, Z-12)

**HEAD b458a8d** (Ausgabe von `git rev-parse --short HEAD` nach Schritt 0; Fast-Forward auf `nachtlauf/burgstadt`, Vollhash b458a8d837121238dab298a616058f41cdbabc2d)

## Ergebnis in Kürze

- **Befunde:** hoch 0 · mittel 0 · gering 1
- **Leitplanken-Scanner** (`cd packages/burgstadt_core && dart run bin/leitplanken.dart --burgstadt`): 119 Dateien geprüft, 0 Treffer, 0 Fehler, 0 Warnungen.
- **Befund 1** betrifft die Leitplanke „kein Text, der die Täterin nahelegt“. Alles Übrige ist ohne Regelverstoß; Anklänge stehen unter Hinweisen.

## Befunde

### 1. gering · Leitplanke „kein Text, der vor der Auflösung die Täterin nahelegt“

- **Datei:** `packages/burgstadt_core/data/stadt/bewohner.json`, `bewohner[B09].saetze[1]`
- **Zitat:** „Tiere sind offener als Menschen, sagt mein Vater. Der Hund hatte nur Angst vor dem Dunkel.“
- **Regel:** Leitplanke „kein Text, der vor der Auflösung die Täterin nahelegt“. Nach E27/M5 gilt sie für Bewohner-, Stadt- und Häusertexte.
- **Befund:** Der Satz greift ein öffentliches Merkmal der R03-Rolle wörtlich auf. R03-ÖFFENTLICH [O] (K2-ROLLEN-KERN): „Bekannt ist, dass sie seit einer Geisterbahnfahrt als Kind Angst im Dunkeln hat.“ Die öffentlichen Spuren (BSO-01 Absatz mit Stollenprofil, H-15 fehlender Stollen, H-14 „Gestricktes, Wolle“, H-47, H-43 Wehrgang) weisen auf R03 als naheliegende Täterinnen-Rolle. Zitiert wurde daraus nichts, L-Zeilen sind nicht herangezogen. Im Bewohner- und Stadtbestand steht dieses Merkmal nur hier. Der einzige andere Angst-Satz (B28, „wenn sie Angst hat“) bezieht sich auf die Stadt.
- **Abwägung E29/B2:** Der Hundesatz wurde bewusst gelassen. Geprüft wurde dort nur das Geschlechtermuster „Angst“. Neuer Grund gegen die Abwägung: Der Satz trägt das Täterinnenmerkmal als Wortecho, und E29 hat diesen Bezug nicht geprüft.
- **Vorschlag:** „Der Hund war nur verschreckt.“ oder den Satz streichen.

## Hinweise (keine Befunde)

Anklänge ohne Regelverstoß. Sie sind getrennt aufgeführt und stehen nicht im Befundzähler.

- **H1 Drogen-Anklang:** `innen-laden-2`, Legende `F.name` = „Krautfass“ (Gemüseladen). „Kraut“ ist Drogenslang. Kontext ist eindeutig Gemüse. Wie bei E27/G2 („Blaues Faß“) eher umbenennen, etwa „Gemüsefass“.
- **H2 Alkohol-Anklang Fass:** `stadt/haeuser.json` H-049 („Holzfass … Böttcher … das Fass bald ausläuft“), H-079 („Fässer mit Leinöl“). Ohne Gaststätte und ohne Alkoholbezug; Legenden wie „Mehlfass“, „Kornfass“ sind unkritisch.
- **H3 Familien- und Küchen-Muster in kanonischen Figurenzeilen [O]:** R01 („Pita und lange Telefonate mit der Verwandtschaft“), R05 („die drei Frauen am Küchentisch Pierogi“), R08 („Zum Bajram kocht die Großmutter für die halbe Verwandtschaft“), R13 („backt jeden Freitag Revani für die halbe Straße“), R15 („Menemen“), R16 („Großmutter singt alte Sevdalinke“), R18 („schlichtet jeden Familienstreit ‚wie ein Gericht‘“). Gegenbeispiele deutsche Rollen: R10 (Biikebrennen), R17 (Sonntagsmittagessen der Mutter). Es gibt keine Verallgemeinerung über eine Herkunftsgruppe, jede Stelle gehört zu einer konkreten Figur (Standard E34/B-2). Die klischeenahen Stellen sind R18 und R05. Bei Überarbeitung ausbalancieren.
- **H4 Altersklischee-Nähe:** `bewohner[B15].saetze[0]` („die Alten schlafen fest“), `saetze[1]` („Meine Schützlinge schlafen wie Kinder“). Konkrete Pflegesituation, aber nicht in E34/B-2 erfasst. An eine konkrete Person binden oder umformulieren.
- **H5 Berufsklischee-Nähe:** B21 („Schnell im Mund und schnell mit der Schere“), B05 („sie weiß alles besser“). Einzelcharaktere, kein Befund.
- **H6 Wolle-Cluster als Gegenspur-Dichte:** B13 (Zubehör Strickzeug), B18 („näht Mäntel aus Wolle und Filz“), B44 (Garnrolle), H-117 (Schafwolle, Socken). Dazu `innen-wohnstube-7` (Garnregal), `innen-werkstatt-2` (Garnrollen-Regal), `innen-laden-4` (Wollkiste). Das Material ist nicht täterinnen-exklusiv, da zehn weitere Figuren Strickjacken tragen. Kein Befund.
- **H7 Seil-Motiv und Abweichung von E33:** B44 `wesen` nennt „er dreht Stricke …“. E33 meldet dagegen „Seiler B44 ohne ‚Strick‘-Anspielung“. Weitere Seilstellen: H-034 („Seilerschaft“), H-087 („Glockenseil“), H-124 („Seil … ausgefranst“), B44 `saetze[0]` und `saetze[3]`. Kein Regelverstoß, aber Log und Daten passen nicht zusammen.
- **H8 Wehrgang außerhalb der Burg:** B37 `saetze[1]` („die Kirchenburg hat … einen Wehrgang“), H-106 („Mauern mit Wehrgang“), H-069 (Hausname „Haus zum Wehrgang“). Der Wehrgang ist der öffentliche Alibi-Ort der R03-Rolle. E27/H2 („nur als Farbe“) deckt die Erwähnung. Grenzfall: Ausklammern oder umformulieren.
- **H9 Berufs-Echo zu R03-Familie:** H-105 und B11 („Bibliothekarin“, Mutter von R03), B30 und H-048 („Zimmermann“, Bruder von R03), B31 („Gärtnerin“, Vater von R03). Generische Berufe, kein Befund.
- **H10 Hexen-Anklang:** H-037 Inschrift „Im Kessel brodelt, was die Gasse nährt“. Symbolik ohne Verbotsmotiv: Besen (B17), Eule (B18, H-004), Rabe (H-060), Krähe (H-158).
- **H11 Opfer-Doppeldeutigkeit:** `fallorte`, `innen-kirche` Legende `O.name` = „Opfertisch mit Kerzen“. Kirchenbegriff, aber nahe am Wort „Opfer“ für den Verletzten.
- **H12 Kräuter-Wirkung:** B31 `saetze[1]` („Nimm Melisse, die beruhigt.“). Harmloses Kraut ohne Drogenbezug.
- **H13 „Fremde“ als Pointe:** H-012 („dass Fremde husten“). Keine Herkunft, aber „Fremde“ als Lacher sollte man im Auge behalten.
- **H14 Scanner-Lücke bei „bewusstlos“:** K1 OA-20 und K2 BW-ZUSTAND tragen noch „bewusstlos“. Wirksam ist es durch ERSETZE-17 (E29) ersetzt. Der Burgstadt-Bestand enthält es nicht. Der Scanner erfasst das Wort nicht, weil es nicht auf der Verbotsliste steht. Vorschlag: Verbotsliste erweitern oder Kanonzeile ändern.
- **H15 Harz-Realorte in O-Zeilen:** Osterode (K-010, BW-STAMM), Goslar (R14), Wernigerode (R20). Braunschweig, Göttingen, Wolfsburg stehen in den Berufsfeldern der Figurendaten (O). ERSETZE-10 bis -16 erfassen sie nicht. Kanontreu ist gewahrt, die Welt-Konsistenz des fiktiven Schartenfels sollte man prüfen.
- **H16 Gerätetexte in den Ladetipps (außerhalb des Auftrags):** `erzaehler.json` `laden[0]` („Mit Umschalt rennst du.“) widerspricht E34 („Rennen nur noch in den Gerätetexten“). Weitere geräteabhängige Tasten: Tab (`laden[1]`), Q (`laden[2]`), F (`laden[3]`), E (`laden[4]`), Esc (`laden[5]`), Select (`laden[12]`).
- **H17 Entwicklerfeld mit Figurennamen:** `faehigkeiten.json` `rollen[R03].wirkung.details` nennt „Merle“ und die Abdruckspur BSO-01. Laut E27/H1 wird das Feld nicht angezeigt. Da die Datei ausgeliefert wird, sollten Entwicklerfelder ohne Figurennamen auskommen.

## Abwägungen

- **E23/M5 und E29/B1 (bewusstlos → benommen):** wirksam. Im Burgstadt-Bestand kein „bewusstlos“. Akzeptiert.
- **E27/M5 (Kanon-Spuren zeigen auf die Täterin):** akzeptiert. Kanon-Spuren sind der Zweck der Spuren. Die Regel bezieht sich auf die zusätzlichen Texte.
- **E27/H1, M2, G3, G4, G5, G7, G11:** akzeptiert. Die Kopftuch- und Afro-Teile (`kopf-kopftuch`, `frisur-afro`) werden von keiner Figur verwendet.
- **E27/H2 (LISTE-ORTE um Häuser, Gassen, Inschriften):** akzeptiert, als Farbe.
- **E27/G2, G6, G8, G9, G10, G12:** umgesetzt (Blaues Tuch, Stadtburg, Sitzungssaal, Inhaberin). Keine Verlauf- oder Verirr-Echos mehr.
- **E29/B2 (Angst):** widersprochen, nur für B09 (Befund 1). Die übrigen Angst-Stellen sind bereinigt.
- **E29/B3 (LISTE-ZEITEN, Stadtzeiten):** akzeptiert. Stadtzeiten 22:00, 00:25, 01:30, 03:00, 04:30 sind konsistent.
- **E31 (Saum, Knopf, „früh am Morgen“):** umgesetzt.
- **E33 (Schuhmacher, Stollen → Schacht, Laternen):** umgesetzt. Sohle, Absatz und Stollen im Schuhbezug sind nicht mehr vorhanden. Ausnahme Seil/Strick, siehe H7.
- **E34 (B-1 Zeiten in Aussagen, B-2 konkrete Personen, Knoten, Ziegelei, H-S22, B16, B21):** umgesetzt. Die Enkel-, Nachbarn-, Ehepaar- und Frau-Lang-Stellen sind konkret.

## Grenzen der Prüfung

- **Vollständig gelesen:** `ANPASSUNG.md` (141 Zeilen, alle Datensätze). Alle Textwerte von `bewohner.json` (1561), `stadt/haeuser.json` (1070), `innenraeume/haeuser.json` (1454, mit Rasterzeilen und Legenden), `innenraeume/fallorte.json` (576), `rollen/faehigkeiten.json` (262), `erzaehler.json` (68), `tutorial.json` (112) und `pixel_engine/figuren/rollen.json` (471). Bei `karten.json` alle 66 Figuren (Namen, Haut, Teile). Bei `teile_kleidung.json` und `teile_koepfe.json` alle Wertelisten je Schlüssel. Die Figurenkleidung wurde gegen die O-Zeilen abgeglichen; es gibt keine Abweichung.
- **Maßstab:** 223 O-Zeilen aus K1 bis K9 und 74 O-Zeilen aus ANPASSUNG. Die Hautwerte in `karten.json` zeigen über alle Herkunftsgruppen gestreute Stufen, keine erkennbare Zuordnung.
- **Entscheidungslog:** Zeilen 147 bis 283 (E23 bis E34) gelesen.
- **Nicht zitiert:** L- und G-Zeilen. Eine Widerspruchsprüfung gegen L-Zeilen habe ich nicht durchgeführt. FORMAT.md und PROTOKOLL.md wurden als Format- und Änderungsgrundlage gelesen, nicht als Maßstab.
- **Plagiat:** interne Prüfung aller Textwerte gegen bekannte Quellen sowie drei Websuchen. Gesucht wurden der Titel „Spuk im Gewölbe“ und die Kanonsätze „Im Reif lügt keiner“ und „Ich zähle die Stunden, nicht die Schuld“. Ohne Treffer. Kurze Sätze lassen sich nur begrenzt suchen.
- **Frühere Berichte** in A-702/ nicht gelesen; nur die Verzeichnisliste gesehen.
- **Worktree:** nichts geändert außer dieser Datei. `git status` war vor und nach dem Testbefehl sauber. Keine Commits, keine Pushes.

## Urteil

Ein geringer Verstoß gegen die Täterinnen-Leitplanke (Befund 1). Sonst keine Verstöße gegen Alkohol-, Drogen-, Herkunfts-, Blut-, Hexen-, Walpurgis-, Teufel-, Film- oder Original-Leitplanken. Kanontreu: Namen, Kleidung, Zeiten, Orte und Gegenstände stimmen mit den O-Zeilen überein. Der Wehrgang-Fall (H8) ist durch E27/H2 gedeckt und kein Befund. Plagiat: keine Übernahme erkennbar.

Leitplanken eingehalten: nein · Kanontreu: ja · Plagiatsfrei: ja
