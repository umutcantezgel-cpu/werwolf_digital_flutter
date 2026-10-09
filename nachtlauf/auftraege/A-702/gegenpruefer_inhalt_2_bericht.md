# Gegenprüfung Inhalt, zweite Runde · Auftrag A-702c

Worktree: `/home/user/werwolf_digital_flutter/.claude/worktrees/agent-aa3143031dbeb5c4c`
Stand: HEAD `d511fac` (Schritt 0, `git merge --ff-only nachtlauf/burgstadt`, ff von `fb0ec24`). Kein Commit, kein Push, keine Daten geändert.

## Urteil

- Leitplanken eingehalten: **nein**
- Kanontreu: **nein**
- Plagiatsfrei: **ja** (mit einer Abwägung, siehe G3)
- Befunde: hoch 2 / mittel 5 / gering 12

Begründung in Kürze:
- Leitplanken: H1 nennt im Spieltext die Täterfunktion einer Rolle; M5 zeigt, dass die Leitplanke „Täterin nicht vor der Auflösung nahelegen“ für die Stadt- und Kanon-Spuren ausgelegt werden muss.
- Kanontreu: H2 (Ortsliste, 148 von 160 Hausnamen ohne Kanon-Ort), M1 bis M4 (Kleidung, Teile, Nachtpläne, Saum-Andeutung).
- Plagiat: keine Übernahme aus Film, Serie, Spiel, Buch oder Lied gefunden.

## Prüfumfang

Vollständig gelesen (Auftrag Z. 5):
- `packages/burgstadt_core/data/`: `innenraeume/haeuser.json` (2580 Z.), `innenraeume/fallorte.json` (992), `stadt/bewohner.json` (2703), `stadt/haeuser.json` (2013), `rollen/faehigkeiten.json` (532)
- `packages/burgstadt_spiel/data/texte/`: `erzaehler.json` (125), `tutorial.json` (181)
- `packages/pixel_engine/data/figuren/`: `rollen.json` (412), `karten.json` (67), `teile_kleidung.json` (172), `teile_koepfe.json` (235)
- `nachtlauf/kanon/ANPASSUNG.md` (139)

Weitere Quellen:
- Scanner-Quelle `packages/burgstadt_core/lib/src/pruef/leitplanken.dart` (649 Z.) und Ausnahmen `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md`.
- Kanon-Maßstab (nur `[O]`-Zeilen, `[L]` nur zur Widerspruchsprüfung, nie zitiert): K2 (`ROLLEN-KERN`, `05-12`, `13-20`) und K3-`HINWEISE` komplett als O-Zeilen; K5-`DETEKTIV` und K5-`MECHANIK`, K6, K7, K9 als O-Zeilen; K8-`STILBLATT` vollständig; K1 als O-Zeilen plus gezielte L-Abfragen zur Täterrolle; `FORMAT.md`, `PROTOKOLL.md`.
- Ohne O-Zeilen (Maßstab leer): K4-Dateien, K3-`KERN`/`P1`–`P3`, K5-`P1`–`P3`.
- Nicht als Kanon verwendet: `10_kanon/entwuerfe/` (Entwürfe).
- Berichte unter `nachtlauf/auftraege/A-702/` nicht gelesen.

Scanner (Testbefehl, mit `/opt/flutter/bin/dart`):
- `dart pub get --offline`: ok.
- `dart run bin/leitplanken.dart --burgstadt`: Geprüfte Dateien 112, Summe 0 Treffer, 0 Fehler, 0 Warnungen, Exit 0.
- Der Scanner findet nur Einzelwörter und Phrasen aus seiner Liste. Die manuelle Lesung ist deshalb die eigentliche Prüfung.

## Befunde

Jeder Befund nennt Schwere, Datei, Stelle, Zitat, Regel und Vorschlag. Zitate stammen aus Spieltexten oder aus O-Zeilen des Kanons.

### Hoch

**H1 · Täterfunktion im Spieltext (Fähigkeit R03)**
- Datei: `packages/burgstadt_core/data/rollen/faehigkeiten.json`, Fähigkeit „Spur verwischen“, Z. 59–83.
- Stelle: `wirkung.details` (Z. 62), `sichtschicht.zeigt` (Z. 69), `ausloeser` (Z. 81–83).
- Zitat: „Merle kann die Abdruckspur bei BSO-01 verwischen.“ · „Falsche Fährten sind nur im Rahmen von LR-2 und @R03-LÜGE erlaubt.“ (Z. 62) · „Merle sieht, welche Abdrücke noch unverwischt sind …“ (Z. 69).
- Regel: Leitplanke „kein Text, der vor der Auflösung die Täterin nahelegt“. Die Fähigkeit bindet genau eine Rolle an die Beweisspur BSO-01. Im O-Kanon ist sie nicht belegt. Sie entspricht der Täterfunktion im L-Kanon (nur zur Widerspruchsprüfung gelesen, nicht zitiert). Der Verweis auf LR-2 und @R03-LÜGE ist zudem eine Designer-Notiz im Spieltext.
- Vorschlag: Fähigkeit streichen oder einer Rolle ohne Bezug zu BSO-01 geben (z. B. allgemeines Abdruck-Lesen für mehrere Rollen). Designer-Verweise aus dem Spieltext entfernen. Vor Freigabe prüfen, ob die Fähigkeitskarte anderen Spielern sichtbar wird.

**H2 · Orte außerhalb der geschlossenen Liste**
- Dateien: `packages/burgstadt_core/data/stadt/haeuser.json` und `stadt/bewohner.json`.
- Befund: 148 von 160 Häusern tragen einen Namen ohne Bezug zu einem Kanon-Ort (nur 12 Häuser haben ein `ort`-Feld mit ORT-01 bis ORT-12). Zusätzlich stehen Gassen und Viertel im Text, die nicht in LISTE-ORTE stehen. Beispiele:
  - Hausnamen: „Haus zum Goldenen Hut“ (haeuser.json Z. 32), „Haus am Schiefen Eck“ (Z. 100), „Haus zum Lindenbaum“ (Z. 244), „Pfarrhaus am Lindenplatz“ (Z. 1078), „Hauerhaus an der Stollengasse“ (Z. 1750), „Hauerhaus am Schartenweg“ (Z. 1764).
  - Gassen in Texten: „Obergasse“ (haeuser.json Z. 934), „Untertorgasse“ (bewohner.json Z. 521), „Hauptgasse“ (Z. 1460).
  - Viertel: „Burgberg“ mit 22 Häusern (nicht in ANPASSUNG-Viertelliste).
- Regel: `10_kanon/FORMAT.md` Z. 24: „Was nicht in einer Liste steht, darf in Spieltexten nicht als Ort, lösungsrelevanter Gegenstand oder Zeitpunkt auftauchen.“ LISTE-ORTE in `nachtlauf/kanon/ANPASSUNG.md` Z. 63. Der Stadtgenerator übernimmt die Hausnamen als Gebäudenamen (`packages/burgstadt_core/lib/src/welt/stadtgenerator.dart` Z. 320 und Z. 338).
- Vorschlag: Kanon-Eigner entscheidet. Entweder LISTE-ORTE per Ergänzung (PROTOKOLL v1.1) um die Stadtnamen und das Viertel „Burgberg“ erweitern, oder die Hausnamen aus der Ausgabe nehmen. Bis dahin keine Freigabe.

### Mittel

**M1 · Kanon-Kleidung und Accessoires bei R03 und R04**
- Datei: `packages/pixel_engine/data/figuren/karten.json` Z. 5 (R03) und Z. 6 (R04). Ergänzend `rollen.json` Z. 102 (R04 `"uhr"`).
- Zitat: R03 `"schuhe-stiefel","schuhe-arbeitsschuhe","notizbuch"`; R04 `"schuhe-stiefel","schuhe-arbeitsschuhe","taschenuhr-kette"`.
- Kanon: K2-`ROLLEN-KERN` Z. 25 (R03-STAMM): „braune Wanderstiefel (Sonderangebot)“. Z. 34 (R04-STAMM): „braune Wanderstiefel (Sonderangebot)“ und „Armbanduhr mit großem Ziffernblatt“. K3-`HINWEISE` Z. 35 (H-15): „dasselbe Wanderstiefelmodell mit Stollen“.
- Regel: Kanontreu (Kleidung nach STAMM, Sohlen-Hinweis H-15). „Arbeitsschuhe“ sind Adnans Kanon-Schuh (K2 Z. 7).
- Vorschlag: Teil für Wanderstiefel definieren. Arbeitsschuhe und Taschenuhr bei R03 und R04 entfernen, Armbanduhr verwenden.

**M2 · Nicht definierte Teil-IDs in `karten.json`**
- Datei: `packages/pixel_engine/data/figuren/karten.json` gegen `teile_kleidung.json` und `teile_koepfe.json` (Prüfung per JSON-Lesen, keine Datei geändert).
- Befund: 29 von 74 verwendeten Teil-IDs sind nicht definiert. Beispiele: `schuhe-stiefel` (BW, R03, R04, R06), `brille` und `brille-stirn` (BW, R05, R12, B04, B43), `oberteil-weste` (BW, R12, R14, R20), `oberteil-hemdkragen` (BW, R05, R12, R13), `schal` (R06, R20, B19, B33), `notizbuch` (R03), `kamera` (R19), `bart-kurz`, `frisur-kurz`, `kopf-hut`, `kopf-muetze`.
- Folge: kanonische Teile (Strickweste und Brille des Burgwarts, Kameragurt von R19, Notizbuch von R03) werden nicht oder nur mit Ersatz dargestellt.
- Regel: Kanontreu (Kleidung nach STAMM).
- Vorschlag: Teil-IDs vereinheitlichen und fehlende Teile definieren. Der Rendering-Pfad selbst ist nicht geprüft.

**M3 · Nachtpläne widersprechen Stationshinweisen in Phase 2 und 3**
- Dateien: `packages/burgstadt_core/data/stadt/bewohner.json` und `nachtlauf/kanon/ANPASSUNG.md`.
- Phasenzeiten laut STADT-05 (ANPASSUNG Z. 38): Phase 2 endet 03:00, Phase 3 endet 04:30.
- Befunde:
  - B07, Wirtin der Teestube, Thermoskanne (bewohner.json Z. 399): in Phase 3 schläft sie zu Hause (Z. 411–415). Dagegen H-S02 (ANPASSUNG Z. 72, Phase 3): „Auf dem Marktplatz steht eine Frau mit Thermoskanne und zählt jeden Schlag laut mit.“ Und H-S14 (Z. 108, Phase 3, Teestube): „Die Inhaberin stellt dir eine Kanne Kräutertee hin …“.
  - B10, Schreinermeister mit Arbeitshaus H-058 (Z. 560): in Phase 3 ist er zu Hause (Z. 590–596). Dagegen H-S08 (Z. 90, Phase 3): „In der Werkstatt hobelt der Meister seit vierzig Jahren an derselben Bank.“
  - B03, Bäckerin (Z. 155–165): in Phase 2 ist sie bis 03:00 zu Hause. Dagegen H-S15 (Z. 112, Phase 2): „Die Bäckerin sagt: Der Ofen wird jeden Morgen um drei Uhr angeheizt, auch heute.“
- Regel: Kanontreu (Stadt-Hinweise an Fall-Orten, Phasenbezug).
- Vorschlag: Nachtpläne so ändern, dass die jeweilige Person zur Phase an der Station ist. Alternativ die Hinweise ohne Personenbezug formulieren.

**M4 · Nicht-kanonische Saum-Andeutung nahe dem Laken-Beweis**
- Datei: `packages/burgstadt_core/data/stadt/bewohner.json` Z. 2309 (B38, Schneiderin).
- Zitat: „Den Saum habe ich heute Nacht zweimal aufgetrennt, weil die Hand nicht ruhig war.“
- Kanon: Der Saum ist Beweismerkmal des Bettlakens (K1 BSO-06, Z. 197: „am Saum fehlt ein Streifen“; K3 H-13, Z. 33). Eine nächtliche Tätigkeit am Saum ist im Kanon nicht angelegt.
- Regel: Kanontreu (keine lösungsnahen Fakten außerhalb des Kanons).
- Vorschlag: Satz streichen oder ohne Nachtbezug und ohne Saum umformulieren.

**M5 · Täterin-Nähe der kanonischen Spuren (Auslegung nötig)**
- Dateien: K3-`HINWEISE.md`, O-Zeilen, die in Spieltexte übernommen werden.
- Stellen:
  - H-18 (Z. 38, Phase 1): „dahinter Merle mit der Hand an der Tasche ihrer Strickjacke; im Hintergrund die leere Samtmulde der Vitrine“.
  - H-47 (Z. 95, Phase 2): „Merle meldet: Bei der Führung hatte sie den Taler in der Hand, als Jonas gegen Kunibert krachte.“
  - H-49 (Z. 99, Phase 3): „Adnan meldet: Merle kam erst eine knappe Minute vor dem Schrei an den Kamin, mit eiskalten Händen.“
- Regel: Leitplanke „kein Text, der vor der Auflösung die Täterin nahelegt“. Die drei Spuren zeigen in allen Phasen auf dieselbe Rolle. Spuren gehören zum Spielprinzip, aber die Leitplanke trennt Spur und Nennung nicht.
- Vorschlag: Kanon-Eigner legt fest, ob Spuren erlaubt sind, wenn Gegenspuren in gleicher Dichte stehen. Sonst H-18 und H-47 entschärfen (in Phase 1 keine eindeutige Verortung der Hand, in der Meldekarte keine Aussage über den Taler).

### Gering

**G1 · Drogen-Andeutung im Apotheken-Umfeld (Abwägung)**
- `bewohner.json` Z. 227 (B04): „Er mischt in Ruhe ein Pulver im Mörser, weil die Nachfrage nach Hustensaft gestiegen ist.“; Z. 238: „Ich zähle Tabletten und die Minuten …“; Z. 243 (Gerede): „Angeblich hat der Nebelriese neulich eine Apotheke ausgeräumt …“; Z. 1874 (B31): „Nimm Melisse, die beruhigt.“
- Regel: Leitplanke Drogen, auch nicht als Andeutung. Kein Drogenbezug im engeren Sinn, aber im Umfeld des benommenen Burgwarts betäubungsnah lesbar.
- Vorschlag: Pulver, Tabletten und Hustensaft durch unverfängliche Tätigkeiten ersetzen. Melisse-Satz und Apotheken-Gerede streichen oder umformulieren.

**G2 · Gaststätten-Anklänge**
- `haeuser.json` Z. 426 (H-033): „Färberei zum Blauen Faß“. Z. 1468 (H-116): „Heute ist es eine Teestube ohne Schild, die nur Bekannte betreten.“
- Regel: Gaststätten sind Teestuben, Cafés, Bäckereien.
- Vorschlag: Hausnamen ändern (z. B. „Zum Blauen Tuch“), Satz zu H-116 neutral formulieren.

**G3 · Anklang an eine fremde Catchphrase (Plagiat-Abwägung)**
- `packages/pixel_engine/data/figuren/rollen.json` Z. 369: „runder Anstecker „Einspruch!“ am Kragen“. Kanon K2-`ROLLEN-13-20` Z. 52 (R18): „ruft „Einspruch!“, sobald sie aufgeregt ist“.
- Regel: Original statt Kopie. „Einspruch!“ ist ein allgemeines Gerichtswort und zugleich die deutsche Kernformel der Spielreihe „Ace Attorney“.
- Vorschlag: Abwägung. Ggf. eigene Ausrufe-Floskel für die Figur.

**G4 · Ungenutztes Kopftuch-Teil**
- `packages/pixel_engine/data/figuren/teile_koepfe.json` Z. 190: `"kopf-kopftuch"`. Derzeit von keiner Figur verwendet.
- Regel: Klischees über Gruppen. Eine Verwendung für eine Figur wäre ein Verstoß.
- Vorschlag: Teil entfernen oder nicht verwenden.

**G5 · Kleidungstypen weichen vom Kanon und von `rollen.json` ab**
- `karten.json`: Z. 7 (R05, Cordblazer), Z. 17 (R15, bordeauxroter Blazer), Z. 18 (R16, Sakko): jeweils `oberteil-uniformjacke`. Z. 9 (R07) und Z. 21 (R19), Lederjacke: `oberteil-arbeitsjacke`. Z. 13 (R11, Daunenjacke): `oberteil-arbeitsjacke`. Z. 19 (R17, „brauner Lederhut“ laut K2-`ROLLEN-13-20` Z. 43): `kopf-filzhut`.
- Schuhtypen widersprechen sich zwischen `rollen.json` und `karten.json` bei R07, R10, R13, R16, R18 und R19.
- Regel: Kanontreu (STAMM-Kleidung).
- Vorschlag: an K2-STAMM angleichen, Schuhtypen in beiden Dateien vereinheitlichen.

**G6 · Wortwahl „Stadtschloss“**
- `faehigkeiten.json` Z. 300 (R12): „ein kleines befestigtes Stadtschloss aus dunklem Bruchstein“. Kanon K-001 (ANPASSUNG Z. 30): „die kleine, renovierte Stadtburg“.
- Vorschlag: „Stadtburg“.

**G7 · Uhrzeiten der Nachtpläne außerhalb LISTE-ZEITEN**
- `bewohner.json`: Die Nachtpläne nennen zahlreiche Zeiten (z. B. Z. 162 „02:40“, Z. 2299 „05:00“), die nicht in LISTE-ZEITEN stehen. Der O-Kanon nutzt selbst Zeiten außerhalb der Liste (K2-`ROLLEN-05-12` Z. 44: 23:50 und 23:51; K1 Z. 46, OA-14: 23:52).
- Regel: die Geschlossenheit der Zeitliste ist im Kanon selbst nicht durchgehalten. Klärungsbedarf.
- Vorschlag: Kanon-Eigner klärt, ob Nachtplan-Zeiten in Spieltexte gelangen. Wenn ja, Liste ergänzen; sonst nicht ausgeben.

**G8 · „Ratsstube“ außerhalb der Ortsliste**
- `packages/burgstadt_spiel/data/texte/erzaehler.json` Z. 92: „Die Ratsstube wirkt wie vergessen.“
- Vorschlag: „Das Rathaus wirkt wie vergessen.“

**G9 · Andeutung ohne Wahrheitsdatensatz**
- `bewohner.json` Z. 2443 (B40): „Auf einem steht ein Name aus dem Bergland, mehr sage ich nicht.“ Im Kanon gibt es dazu kein HW-Gegenstück.
- Vorschlag: streichen oder ohne Hinweischarakter formulieren.

**G10 · „Verlaufen“-Echo ohne Kanonbasis (Täterin-Nähe)**
- `bewohner.json` Z. 1283 (B21): „Oder jemand, der sich verlaufen hat.“ Z. 2698 (B44): „Wer sich verirrt, folgt dem Seil.“ `haeuser.json` Z. 1594 (H-126): „… Wanderer, die sich ohnehin verlaufen.“
- Kontext: Das Alibi einer Rolle lautet im O-Kanon auf „verlaufen“ (K2-`ROLLEN-KERN` Z. 26; K8 KM-02). Die drei Sätze stärken dieses Motiv, ohne dass der Kanon es an dieser Stelle verlangt.
- Vorschlag: Formulierungen wechseln.

**G11 · Kanon-Wortlaut „bewusstlos“ und die Leitplanke zur Verletzung**
- K2-`ROLLEN-KERN` Z. 54 (BW-ZUSTAND): „Kurz bewusstlos“. K1 Z. 52 (OA-20): „bewusstlos“. Leitplanke laut K8 Z. 23: Verletzung nur „Beule“, „benommen“, „Kühlpack“. Die Spieltexte in `faehigkeiten.json` vermeiden das Wort bereits.
- Vorschlag: Kanon-Eigner klärt. In Spieltexten „benommen“ verwenden.

**G12 · Scanner-Ausnahmen mit Spieltext-Einträgen**
- `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md` Z. 15 (`bewohner.json`, „Wirtin“) und Z. 16 (`haeuser.json`, „gelagert“). Der Kopf der Datei (Z. 2) sagt: „Nur Regelzitate und Negativ-Anweisungen, nie Spieltext.“
- Inhaltlich unschädlich: Teestube ist alkoholfrei, „gelagert“ ist ein Fehlalarm der Regel „gelage“. Formal nicht im Sinn des Kopfs.
- Vorschlag: Ausnahmen auf Regelzitate beschränken. Fehlalarme über die Regel präzisieren.

## Prüfnotizen ohne Befund

- Scanner: 112 Dateien, 0 Treffer.
- Alkohol: alle Getränke sind alkoholfrei. Punsch laut K1 OA-04 und erzaehler.json („Der Punsch im Gewölbe ist warm und alkoholfrei“). Teestube mit Tee, keine Schenke, keine Bar.
- Drogen: keine Begriffe im Datenbestand außer den in G1 genannten Grenzfällen.
- Herkunft: keine Herkunft als Motiv, Indiz oder Pointe gefunden. Die Stablampe „HODŽIĆ VT · 3“ (K1 BSO-03, Z. 194) trägt das Firmenlabel „Hodžić Veranstaltungstechnik“. Das ist ein Besitzer-Indiz, kein Herkunftsindiz. Kulturelle Details (Bağlama, Džezva, Tufahije, Revani, Pita) sind warme Farbe. Die Großmutter, die „wie ein Gericht“ schlichtet (K2-`ROLLEN-13-20` Z. 52), ist kein Witz über die Herkunft (K8 Z. 24).
- Verletzung: nur Beule, benommen, Kühlpack (`faehigkeiten.json` Z. 142 und 156, K2 BW-ZUSTAND). Das Opfer ist nie in ernster Gefahr.
- Hexen, Walpurgis, Teufel, Film-Vampire: keine Treffer (Scanner und Suche nach Dracula, Nosferatu, Hexe, Teufel, Walpurgis, Vampir).
- Original statt Kopie: keine Figuren, Namen oder Sätze aus Film, Serie, Spiel, Buch oder Lied gefunden. Geprüft wurden u. a. Sherlock, Watson, Dracula, Harker, Helsing, Gandalf, Harry, Hogwarts, Tatort, Minecraft, Zelda. Einzige Randfälle: „Lindenbaum“ als Hausname (Schubert-Titel, kein Liedzitat) und G3.
- Mustersätze aus K8 Abschnitt 11: keine wörtlichen Übernahmen in die Daten.
- ERSETZE-Regeln aus ANPASSUNG: keine Reste von „Harz“, „Brockengespenst“, „Silberhauer“, „Oberharz“, „Nationalpark“ in den Daten. Durchgängig „Nebelriese“, „Bergland“, „Naturpark“, „Bergwald“.
- Uhrzeiten in vorlesbaren Texten (`erzaehler.json`): keine Ziffern. Zahlen in Bewohnersätzen sind ausgeschrieben (z. B. B13 „achtundachtzig“).
- Stationen ORT-01 bis ORT-12: in `fallorte.json` (Stationen) und `haeuser.json` (ort-Felder, Inschriften) übereinstimmend.
- Inschriften und Geschichten der Häuser (`inschrift`, `geschichte`) werden im Code derzeit nicht gelesen. Sie sind trotzdem Spieltext-Daten und wurden geprüft.

## Grenzen

- Die Täterrolle wurde nur aus L-Zeilen ermittelt, um Täterin-Nähe zu prüfen. Sie ist hier nicht genannt und nicht zitiert.
- Herkunft und Lizenz der Kanon-Vorlage (`krimidinner/`) sind nicht geprüft.
- Rendering und Spielverhalten sind nicht geprüft. M2 beruht nur auf dem Datenabgleich.
- Git: nur Schritt 0 ausgeführt. Die Prüfung hat außer dieser Berichtsdatei keine Dateien angelegt. `.dart_tool` entstand durch `pub get` und ist per `.gitignore` ausgenommen.

## Abschluss

Leitplanken eingehalten: nein · Kanontreu: nein · Plagiatsfrei: ja
