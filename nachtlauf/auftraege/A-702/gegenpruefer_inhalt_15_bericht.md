HEAD 388fa25

# Gegenprüfung Inhalt · gegenpruefer_inhalt_15 · Auftrag A-702o

**Geprüfter Stand:** HEAD 388fa25 (Commit „Nachtlauf: Auftrag A-702o (Inhalt Runde 15/16 nach E42)“). `git merge --ff-only nachtlauf/burgstadt` ergab ein Fast-Forward d92a675..388fa25 (im Reflog bestätigt). Der Worktree war vor der Prüfung sauber; geändert wurde nur diese Berichtsdatei.
**Kanon-Stand:** Kanon v1.0 (VERSION.md, freigegeben am 08.10.2026), Vergleich 659d3ed..HEAD für die K-Dateien.

## 1. Werkzeuge und Zählungen

- **Scanner:** `dart run bin/leitplanken.dart --burgstadt` in `packages/burgstadt_core` (Dart 3.13.5 unter `/opt/flutter/bin/cache/dart-sdk/bin/dart`, nicht im PATH). Ergebnis: 119 Dateien, 0 Treffer, Exit 0.
- **Ausnahmen** (`nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md`, 13 Einträge, Z. 4–16): Regelzitate in K8 (Hexen, Walpurgis, Teufelsmotive), englische Negativ-Anweisungen in K8/K9 (wine, beer, drinks), das Haustier Kater Paşa (K2-ROLLEN-13-20, ANPASSUNG), ein Tiervergleich in K4-GESPRAECHE-P2 („wie ein hungriger Kater“) und die technische Kennung `drink` in `content/scenarios/blue_palm.json` (außerhalb des Prüfbereichs). Die Ausnahmen verdecken keinen Spieltext.
- **Eigene Stichproben** (Grep über `packages/burgstadt_core/data` und `packages/burgstadt_spiel/data`): keine Treffer für Harz, Brocken, Brockengespenst, Osterode, bewusstlos, Blut, Hexe(n), Walpurgis, Teufel, Vampir, Drogen, Alkohol, Wein, Bier, Schnaps, Gaststätte, Gasthaus. Treffer gab es nur in Testdateien (`kanon_test.dart`, `leitplanken_test.dart`) und Codekommentaren.
- **Kanon-Zählung** (Skript im Scratchpad): 22 K-Dateien mit 223 O-Datensätzen, 223 eindeutige IDs, keine Doppel. Diff 659d3ed..HEAD (K*.md): 29 [O]-Datensätze neu und 29 entfernt; 133 [G]/[L]-Zeilen neu und 129 entfernt; 54 Zeilen neu und 54 entfernt ohne Datensatzkennung.
- Nichts geändert (kein Commit, kein Push, kein Build). Hilfsdateien nur im Scratchpad-Unterordner. Frühere Berichte in `nachtlauf/auftraege/A-702/` nicht gelesen und der Ordner nicht durchsucht.

## 2. Prüfumfang

- **Vollständig gelesen:** der Auftrag A-702o; ENTSCHEIDUNGSLOG E23, E27, E29, E31, E33, E34, E35, E37, E38, E39, E40, E41, E42; `nachtlauf/kanon/ANPASSUNG.md`; K8-STILBLATT.md, K9-LOOKBIBEL.md, K5-MECHANIK.md, K6-AUFLOESUNG.md, K7-LUEGENREGEL.md, VERSION.md, FORMAT.md.
- **Alle 223 O-Datensätze** (K1 bis K9) gelesen.
- **[G]/[L]-Zeilen:** gezielt geprüft (Stichworte, Widersprüche zu Spieltext und Overlay, Diff-Zeilen).
- **Spieltext-Daten:** `bewohner.json` (B01 bis B44), `stadt/haeuser.json` (H-001 bis H-160), `innenraeume/haeuser.json` und `fallorte.json`, `rollen/faehigkeiten.json` (R01 bis R20), `texte/erzaehler.json`, `texte/tutorial.json`.
- **Figurendaten:** `pixel_engine/data/figuren/rollen.json` (R03, R04, R05 vollständig), `karten.json` (R03, R04, R05, B01, B02; alle Karten per Skript), `teile_kleidung.json`, `teile_koepfe.json` (Skript).
- **Code:** Substring-Suche in `lib/` nach Plagiat-Begriffen und nach „Leiche“.

## 3. Befunde

### M1 · mittel · Eigentumsmarke „HODŽIĆ VT · 3“ ist das einzige Band zur falschen Fährte gegen R01

- **Stellen:** K1-GRUNDWAHRHEIT.md Z. 198 (BSO-03 [O]) und Z. 28 (LISTE-GEGENSTÄNDE [O]); K3-HINWEISE.md Z. 48 (H-28 [O]); K2-ROLLEN-KERN.md Z. 8–9 (R01-Datensatz); K8-STILBLATT.md Z. 123 (GL-19 [O]: „Aussprache: HOD-schitsch fau-te drei“); K5-ENTSCHEIDUNGEN-DETEKTIV.md Z. 8 (DW1-1 [L], Ergebnis A: „Es ist Adnans Lampe.“); K1 Z. 86 (Z-1830 [L]) und Z. 185 (BS-03 [L]).
- **Regel:** Leitplanke „Herkunft ist nie Motiv, Indiz oder Pointe“.
- **Befund:** Der Nachname auf dem Klebeband ist der Ausgangspunkt der falschen Fährte. R01 heißt Adnan Hodžić, Wurzeln „bosnisch“ (K2-ROLLEN-KERN Z. 7). Ergebnis A der DW1-1 stützt sich auf das Klebeband. GL-19 legt die Aussprache fest; der Name wird im Spiel also laut gesprochen.
- **Begründung E42** (ENTSCHEIDUNGSLOG Z. 421): „Im Spiel ist Herkunft kein Indiz: Der Verdacht gegen R01 beruht auf Lampe und Code-Zettel; „HODŽIĆ VT · 3“ ist eine Eigentumsmarke.“ Die Begründung ist formal schlüssig, trägt aber nicht ganz: Die Marke ist im Wortlaut der Lösung der Weg von der Lampe zu R01, und der Nachname ist eine herkunftsgekennzeichnete Angabe. Ein Kennzeichen ohne Nachnamen ließe die Mechanik erhalten, wenn Ergebnis A der DW1-1 entsprechend formuliert wird.
- **Zusammenhang:** FM-1 (E42, Z. 420) ordnet die Besetzung nach Wurzeln („Täterin und Hauptverdächtiger mit echtem Vergehen haben deutsche Wurzeln“). Der Eintrag ist [L] und im Spiel nicht sichtbar, zeigt aber, dass Herkunft als Ordnungskriterium der Lösung dient. E42 hält FM-1 bei und verweist die Umordnung nach Rollen-IDs an den Nutzer.
- **Einordnung:** Grenzfall. Das Gesamturteil „Leitplanken eingehalten: ja“ steht unter diesem Vorbehalt; die Entscheidung liegt bei der Kanon-Verantwortung.
- **Vorschlag:** Kennzeichen ohne Nachnamen (z. B. „VT · 3“) in BSO-03, H-28, LISTE-GEGENSTÄNDE, BS-03, Z-1830, DW1-1 und GL-19 (Aussprachefeld anpassen); Ergebnis A der DW1-1 umformulieren. Umsetzung über ERSETZE-Overlay oder im Kanon. Die Dateien wurden nicht geändert.

### G1 · gering · „Punsch“ ohne Zusatz „alkoholfrei“ in OA-23 und BW-ZUSTAND

- **Stellen:** K1-GRUNDWAHRHEIT.md, OA-23 [O] (Zeit 00:05): „einen Becher Punsch in der Hand“; K2-ROLLEN-KERN.md Z. 54, BW-ZUSTAND [O]: „warmem Punsch“.
- **Regel:** Leitplanke „Punsch immer alkoholfrei“.
- **Befund:** In der Sache gedeckt. GL-14 definiert den Punsch als alkoholfrei, K9 §6 verlangt „non-alcoholic“ für Bilder, erzaehler.json sagt „Der Punsch im Gewölbe ist warm und alkoholfrei.“ Die beiden Spielzeilen nennen den Zusatz nicht.
- **Vorschlag:** „alkoholfreien Punsch“ in OA-23 und BW-ZUSTAND (Kanon oder Overlay).

### G2 · gering · identischer früherer Beruf bei B13 und B33

- **Stellen:** bewohner.json Z. 738 (B13, Rosa Teutsch) und Z. 1945 (B33, Elfriede Ahrens): beide „Rentnerin, früher Weberin“.
- **Befund:** Die Nähe der beiden ist im Log bekannt. E32 (Z. 251) führt B13/B33 als knappe Grenzfälle der Sichtprüfung; E38 (Z. 337) unterscheidet B33 über eine blaue Haube; E40 (Z. 376) setzt B33 auf „Rentnerin, früher Weberin“. Der Beruf bleibt damit identisch.
- **Vorschlag:** Beruf einer der beiden Figuren ändern (im Bild nicht sichtbar).

### G3 · gering · Harz- und Brocken-Reste im Kanon-Fließtext ohne @-Kennung

- **Stellen:** K8-STILBLATT.md Z. 93 (GM-08, Einwurf-Tabelle: „Das Brockengespenst: ein Riesenschatten im Nebel …“), Z. 159 (M-06: „… in Osterode.“), Z. 199 (M-12, Bildprompt: „… in the Harz mountains …“); K9-LOOKBIBEL.md Z. 25 (Palette: „Hof, Brunnen, Harzwald“); K1-GRUNDWAHRHEIT.md Z. 8 („Der Burgwart ist nur kurz bewusstlos.“).
- **Befund:** Im Spieltext-Bestand (`packages/*/data`) kommt keiner dieser Begriffe vor; die Ersetzungen greifen dort. Die ERSETZE-Regeln (ANPASSUNG Z. 12–29) wirken aber nur auf Datensätze mit @-Kennung. GM-08 ist ein Einwurf für den Erzähler; würde er übernommen, stünde „Brockengespenst“ im Spiel. Die übrigen Stellen sind Kanon-intern, Bildprompt oder Palette.
- **Vorschlag:** GM-08 auf „Nebelriese“ ändern; Palette „Harzwald“ zu „Bergwald“; M-06 und M-12 angleichen; K1 Z. 8 „bewusstlos“ zu „benommen“.

### G4 · gering · Ziffern in vorlesbaren Texten und Geldbeträge in Ziffern (Stilblatt §5)

- **Regel:** K8-STILBLATT.md Z. 44: „In allen vorlesbaren Texten Uhrzeiten in Worten … Keine Ziffern“; Z. 45: „Geldbeträge in Worten“; Z. 47 erlaubt nur auf Spielerkarten Uhrzeiten als „23:47 Uhr“.
- **Stellen (Erzählertexte):** K3-HINWEISE.md Z. 43 (H-23 [O], Form Erzähler: „3.800 € bar bis 24 Uhr“, „Handschlag 23:30“); Z. 46 (H-26 [O]: „um 20:30“, „Um 23:54“); ANPASSUNG Z. 35 (K-010: „um 18:00“, „seit 23:00“), Z. 36 (STADT-01: „um 22:00“), Z. 37 (STADT-02: „um 23:58“), Z. 40 (STADT-05: „(00:25) um 00:30 … 01:30 … 03:00 … 04:30“).
- **Stellen (Spielerkarten):** K2-ROLLEN-13-20.md Z. 17 (R14-ÖFFENTLICH: „die 3.800 Euro“); faehigkeiten.json, R05 (Z. 116: „3.800 Euro“).
- **Befund:** Uhrzeiten in Ziffern stehen in vorlesbaren Erzählertexten. Die Geldbeträge verstoßen gegen Z. 45 auch auf den Karten, weil Z. 47 nur Uhrzeiten erlaubt. Die O-Datensätze folgen dabei ihren eigenen Ziffern; das Kanontreu-Urteil ist davon nicht berührt, die Stilregel aber schon.
- **Vorschlag:** Erzähltexte in Worten („kurz vor Mitternacht“, „um zehn Uhr“, „dreitausendachthundert Euro“); auf Karten dürfen Uhrzeiten bleiben, Geldbeträge sollten in Worten stehen.

### G5 · gering · R05-Frisur in den Figurendaten widerspricht dem Anker

- **Stellen:** `pixel_engine/data/figuren/rollen.json` Z. 115 (R05: `"frisur": "schulterlang"`); K9-LOOKBIBEL.md Z. 70 (LF-R05: „a 31-year-old woman with a dark blonde bob“); karten.json (R05: `frisur-bob`).
- **Befund:** Der Datenwert passt nicht zum Kanon-Anker. Nicht Teil des Auftrags (R03/R04), aber eine Abweichung vom Kanon in den Figurendaten.
- **Vorschlag:** `frisur` auf „bob“ setzen.

### G6 · gering · Armbanduhr von R04 ohne Gegenstück im Bild

- **Stellen:** rollen.json Z. 102 (R04: `"zubehoer": ["uhr"]`) und Z. 103 (Merkmal „großes Ziffernblatt“); K9-LOOKBIBEL.md Z. 69 (LF-R04: „big-faced wristwatch“).
- **Befund:** Der Anker verlangt eine Armbanduhr. E27 (ENTSCHEIDUNGSLOG Z. 198) hält fest: „Die Kanon-Armbanduhr ist bei 2,5D-Auflösung nicht darstellbar.“ Die Daten führen die Uhr, die Figur zeigt sie nicht.
- **Vorschlag:** Eintrag als „nicht darstellbar“ kennzeichnen oder Datenfeld und Anker abgleichen (Entscheidung bei Figurenteam und Kanon).

## 4. Geprüft ohne Befund

- **Verletzungen und Blut:** Im Spieltext nur Beule, „kurz benommen“ (ERSETZE-17), Kühlpack und „keine offene Wunde“ (K2-ROLLEN-KERN Z. 54). Kein Blut, kein Tod. Der Scherz „der ist seit 1911 tot“ betrifft die Rüstung Kunibert (OA-08, K1 Z. 40).
- **Alkohol, Drogen, Gaststätten:** keine Treffer in den Spieltext-Dateien. Teestube („Tee gibt es hier, mehr nicht“, B07, bewohner.json Z. 434; „Zur Laterne“ in LISTE-ORTE), Bäckerei am Untertor, Apotheke, Pension „Zum Uhrturm“ (LISTE-ORTE), Herberge der Bergleute (H-116, historisch).
- **Hexen, Walpurgis, Teufel, Vampire:** nicht im Spieltext. Die 13 Ausnahmen betreffen nur Regelzitate, Negativ-Anweisungen, das Haustier und einen Tiervergleich (siehe 1).
- **Herkunft:**
  - Die Festnamen (Pita, Pierogi, Newroz, Bağlama, Tufahije, Wigilia, Džezva, Revani, Menemen, Sevdalinke) stehen in den K2-Basisdatensätzen der Rollen R01, R05 bis R09, R12 bis R16 und R19 (sowie in Kopien und Testpaketen). Die ANPASSUNG ersetzt dort nur den Festsatz des Familienfelds (Z. 68 bis 70, E38; Z. 72 bis 84). Im Spieltext-Bestand kommt keiner der Begriffe vor.
  - Die Wurzeln (bosnisch, kurdisch, polnisch, türkisch, deutsch) bleiben als Angabe; Name, Wurzeln, Eltern und Geschwister bleiben nach ANPASSUNG Z. 70 unverändert.
  - **Beobachtung, kein Befund:** Bei R01 (Z. 72: Eltern kamen 1993 aus Tuzla), R05 (Z. 73: aus Opole) und R16 (Z. 82: Anfang der Neunziger aus Zenica) steht eine Einwanderungsgeschichte mit einfachen Elternberufen (Schweißer, Schlosser, Kantinenköchin). Sie hat keine Motiv-, Indiz- oder Pointenfunktion; das Klischee-Risiko geht an die Kanon-Verantwortung.
- **„Einspruch!“ (Anstecker R18, K2-ROLLEN-13-20 Z. 52):** Wortlaut aus dem Kanon, festgelegt in E27 G3 (ENTSCHEIDUNGSLOG Z. 204). Kein Befund.
- **Hinweise auf den Täter vor der Auflösung:** Außerhalb der R03-Rollenkarten (faehigkeiten.json, R03-Block) und des Verbindungstexts im R08-Steckbrief („im selben Seminar wie Merle“, faehigkeiten.json Z. 189, Kanon-Text) zeigt kein Spieltext auf R03. „Angst im Dunkeln“ fehlt; der Hund-Satz wurde nach E35 geändert (B09, bewohner.json Z. 553 bis 554). Das Stadtdetail „Strickzeug“ (B13, Z. 759) hat Bezug zur Strickspur, zeigt aber auf keine Rolle; bewusst halten.
- **Strickspur:** H-14 [O] (K3-HINWEISE.md Z. 34) und BW-AUSSAGE-3 [O] (K2-ROLLEN-KERN Z. 58: „was Gestricktes, Wolle“) treffen laut HW-14 [L] (K3 Z. 65) auch R04: „Gestrickt tragen unter den Rollen 1–4 nur Merle (Strickjacke) und Jonas (Strickpullover)“. Die Auflösung bleibt tragfähig: H-15 [O] (K3 Z. 35: „bei Merle fehlt am linken Absatz ein Stollen, bei Jonas sind alle Stollen heil“), HW-15 [L] (K3 Z. 66: „Der Abdruck im Wachs passt nur zu Merles linkem Stiefel.“) und S-5 [L] (K3 Z. 11). Kein Befund.
- **R03 und R04 gegen rollen.json (Punkt 15):**
  - R03: Oberteil `strickjacke-zopf` (Rampe 5, Stufe 2), darunter `bluse` (Rampe 0, Stufe 7), Unterteil Jeans (Rampe 6, Stufe 4), Schuhe Wanderstiefel (Rampe 2, Stufe 3), `zubehoer` leer. K9 LF-R03 (Z. 68): „dark green cable-knit cardigan over a white blouse“. Notizbuch entfernt (E41).
  - R04: Oberteil `pullover` (Rampe 5, Stufe 4), darunter `hemd` (Rampe 6, Stufe 4; Merkmal „kariertes Hemd“), Unterteil Jeans (Rampe 6, Stufe 3), Wanderstiefel (Rampe 2, Stufe 3). K9 LF-R04 (Z. 69): „olive green chunky knit sweater over a checked shirt“. Fleecejacke entfernt (E41, Z. 396; karten.json `oberteil-hemdkragen` statt `oberteil-fleece`). Uhr siehe G6.
  - Grün nach K9 §8: per Skript über die Figurendaten geprüft; nur R03 und R04 tragen Rampe 5 am Oberteil.
- **Zeitmodell:** Phase 1 beginnt um 00:30 (STADT-05 Z. 40, LISTE-ZEITEN Z. 66; E42 Z. 410 bis 411: „alle 44 Nachtpläne“). Der Auftrag des Burgwarts (OA-29) ist 00:25; OA-25 (00:07) und D2-2 („sieben nach zwölf“) passen dazu.
- **Zeitangaben außerhalb LISTE-ZEITEN:** 22:05 (R02, faehigkeiten.json Z. 36), 23:50/23:51 (R08, Z. 193), 21:20 (R19, Z. 481) auf Rollenkarten; OA-08 (21:20) und OA-14 (23:52) in O-Datensätzen. Der Kanon-Satz „Andere Uhrzeiten nennen nur Rollenkarten, Hinweise und Beweisstücke“ (K1 Z. 29) deckt sie; E34 B-1 gilt laut E42 (Z. 425).
- **Weckkontrolle:** „alle fünfzehn Minuten wecken“ (faehigkeiten.json R06, Z. 149; K1 Z. 58; K2 Z. 54) stimmt mit dem Kanon überein.
- **Gesprächsfenster, Lagerunde, Gong:** in den Spieltext-Dateien ohne Minutenangaben (tutorial.json Z. 139 nur der Titel „Die Lagerunde“).
- **Leiche:** nur in Codekommentaren (figure_painter.dart Z. 343; mordakte_game.dart Z. 682 und 865).
- **Overlay und Kanon:** ERSETZE-01 bis -18 (ANPASSUNG Z. 12–29) erfassen in Datensätzen Brockengespenst (04–09), Harz (10–16), bewusstlos (17) und Osterode (18). LISTE-ZEITEN (Z. 66) und STADT-05 (Z. 40) übernehmen den v1.0-Stand und ergänzen die Oberstadt-Zeiten.

## 5. Plagiat-Prüfung

Gesucht (Grep über Kanon-Dateien, `packages/` und `lib/`) nach: Holmes, Watson, Poirot, Marple, Mustard, Scarlet, Peacock, Dracula, Nosferatu, Helsing, Renfield, Frankenstein, Potter, Hogwarts, Gandalf, Frodo, Cluedo, „Happy Birthday“, „Stille Nacht“, „Tannenbaum“, „Lili Marleen“, „Hoch soll er leben“, „Recht ist Recht“.

Treffer:
- „Happy Birthday“ nur in `10_kanon/entwuerfe/KERN-ENTWURF-C.md` Z. 64 (Notiz zu einer Audiodatei). Kein Spieltext, kein K-Datensatz. Kein Befund.
- „Recht ist Recht“ in `packages/burgstadt_core/data/stadt/haeuser.json` Z. 389 („Recht ist Recht, auch bei Kerzenlicht · 1738“): gemeinfreies Sprichwort mit eigenem Zusatz. Kein Befund.
- „Dracula“ und „Nosferatu“ nur in `packages/burgstadt_core/test/leitplanken_test.dart` Z. 48 bis 49 (Testliste). Kein Spieltext.
- „Glück auf“ (BW-AUSSAGE-0, K2-ROLLEN-KERN Z. 55) ist ein Bergmannsgruß und gemeinfrei.

Ergebnis: keine übernommene Figur, kein übernommener Titel und kein übernommener Satz im Spieltext.

## 6. Urteil

- **Leitplanken eingehalten: ja.** Kein Textverstoß gegen Alkohol, Drogen, Blut, Hexen, Walpurgis oder Teufel; keine Herkunft als Motiv oder Pointe im Spieltext; der Punsch ist in der Sache alkoholfrei. M1 ist ein Grenzfall (Herkunft-kodierter Nachname als Weg zur falschen Fährte) und steht zur Entscheidung.
- **Kanontreu: ja.** Die Spieltexte folgen den 223 O-Datensätzen, dem Overlay und den v1.0-Änderungen (LISTE-ZEITEN, STADT-05, Familienfelder, ERSETZE-17/18). Offen sind Stil- und Datenfragen (G3 bis G6): Kanon-Fließtext, die Stilregel §5 und Figurendaten, nicht der Inhalt des Spieltexts.
- **Plagiatsfrei: ja.**
- **Befunde gesamt:** hoch 0, mittel 1, gering 6.

Leitplanken eingehalten: ja · Kanontreu: ja · Plagiatsfrei: ja
