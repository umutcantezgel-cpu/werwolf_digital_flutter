## Bericht F6-SICHT-04

Prüfgegenstand: Läufe `ahmet`, `fatma`, `olli`, `can` mit Endung `ende_meister_n7` (Fotos aus Commit 081e258). Bild-Checkliste B1 bis B9, E-039 (SPIEL-01 Nr. 1 und 2) und E-040 gegengelesen.

### GEPRÜFT

- Je Lauf angesehen: 004 Gastdossier (Tim, in allen vier Läufen byte-gleich), 005 `dossier_taeter`, 018/034/050 `wahl_verdeckt_r1..3`, 019/035/051 `wahl_taeter_r1..3` (alle 12 Täterwahlen; im Lauf ahmet sind sie mit der verdeckten Wahl byte-gleich), 056 `finale`, 057 bis 059 `rueckblende_1..3`, 061 `ende`. Das sind 4 Täterdossiers, 12 Täterwahlen, 16 Finale- und Rückblendenbilder und 4 Endbildschirme.
- Vergrößerte Ausschnitte: ahmet 056 (Tisch), ahmet 057 (Mitte und rechts), can 057 (Mitte). Messungen: mittlere Helligkeit der Szene, Kopfzeile in allen 16 Bildern, roter Randbalken in 005.
- Quellen: ENTSCHEIDUNGSLOG E-008, E-030, E-034, E-035, E-038, E-039, E-040; BILD-CHECKLISTE; Kanon `raeume.json`, `basis.json`, `wahrnehmung.json`, `tatmatrix/can.json`, `texte/ui-rollen.json`, `texte/ui-druck-rollen.json`; Code `lib/party/karte_session.dart`, `tool/e2e/e2e.mjs`, `tool/e2e/README.md`, `packages/mordakte_core/test/party/druck_rollen_test.dart`; `auftraege/F4-BAUMEISTER-02.md` §4.
- Grenzen: keine Datei im Repo geändert, `git status` einmal, kein `git log`, kein dart-Lauf, kein Netz.

### ERGEBNIS JE PRÜFPUNKT (Aufgabe)

| Nr | Prüfpunkt | Ergebnis | Fundstelle und Beobachtung |
|---|---|---|---|
| P1 | Täteransicht vollständig lesbar, Scrollhinweis bei langem Text | erfüllt | 005 in allen vier Läufen: Abzeichen mit Pfeil unten rechts (x ca. 1009, y ca. 729) und Rollbalken rechts; Text ist per Scrollen vollständig |
| P2 | „Nur für dich“ oder gleichwertige Verdeckt-Marke an der Täteransicht | erfüllt, mit Befund 1 | Titelzeile „Nur für dich: Du warst es“ in 005 aller vier Läufe. Die Zeile nennt die Rolle selbst (Befund 1) |
| P3 | Täterwahl trägt „Nur für dich“ oder gleichwertige Marke | teilweise (offene Frage 1) | wahl_taeter_r1..3 (12 Bilder) ohne Marke. Einziger Verdeckt-Hinweis ist der Knopf „Fertig, Bildschirm zudecken“, den auch jede Gastwahl zeigt |
| P4 | Option B der Täterwahl als harmlose Handlung | erfüllt (12 von 12) | ahmet r1 B: „Ich halte mich zurück und erzähle lieber von den Stadtfesten, die meine Agentur plant.“; can r3 B: „Ich mache lieber Witze über die Ritterrüstung im Turmgang. Das lockert die Stimmung.“ |
| P5 | Täterwahl vollständig lesbar | erfüllt | Frage, zwei Karten und Knöpfe passen ohne Scroll auf den Bildschirm |
| P6 | Aufbau verrät auf einen Blick, wer Täter ist (Schritt 3) | ja, verrät (Befund 1) | Gastdossier 004: vier Karten (Wer ich bin, Was ich weiß, Was ich verberge, Mein Ziel heute Nacht), kein Balken. Täterdossier 005: eine lange Karte, roter Balken x 281 bis 286 und y 130 bis 726, Titel „Nur für dich: Du warst es“, Rollbalken rechts kürzer (also längerer Text) |
| P7 | Uhrzeile (hh:mm:ss) in jedem Foto ganz lesbar | erfüllt (16 von 16) | Zeile „Im Keller ist es … Uhr.“ liegt über der Szene, der Wiederholen-Knopf rechts daneben. Nichts ist verdeckt. Laut E-038 steht die Uhr bewusst über dem Bild |
| P8 | Szene malt nicht in die Kopfzeile | erfüllt (16 von 16) | Szene ist ab y ca. 181 abgeschnitten. Die Kopfzeile (x 560 bis 935, y 128 bis 178) hat Maximum 11 und Mittel 12, wie der Hintergrund darunter |
| P9 | Uhr läuft zwischen den Fotos weiter | erfüllt in allen vier Läufen | ahmet 23:52:47, 23:59:55, 00:08:32, 00:15:00; fatma 23:53:43, 00:01:11, 00:09:16, 00:15:00; olli 23:55:37, 00:02:31, 00:10:54, 00:15:00; can 23:53:35, 00:00:03, 00:08:02, 00:15:00 |
| P10 | Stromausfall-Bild: nur Umrisse und echte Lichter (Schritt 4, B9) | erfüllt im einzigen Stromfoto, sonst nicht prüfbar | ahmet 057 (23:59:55): grünes Notausgangslicht, weiße Lichtkegel (Handylampen, Stirnlampe), keine warmen Kerzenpunkte. Mittlere Szenenhelligkeit 11,2 gegenüber 16,9 bis 17,3 in den übrigen Ahmet-Bildern. Keine Stromfotos in fatma, olli, can (Befund 3) |
| P11 | Täter und Herr Schneider hervorgehoben | erfüllt | Je zwei Ringe auf Figuren in allen Rückblendenbildern |
| P12 | Kein Joystick, kein Aktionsknopf (B9) | erfüllt | Nur der Wiederholen-Knopf oben rechts über dem Bild; „Weiter“ liegt unten |
| P13 | Schritt 5: Ahmet kurz vor dem Scheppern auf dem Weg in den Ost-Saal (Lauf can) | nicht prüfbar | Kein Foto zwischen 23:58:00 und 23:58:40. Frühestes can-Foto ist 00:00:03. Kanon: Ahmet geht 23:58:22 bis 23:58:30 zum Jackenständer im Ost-Saal (`tatmatrix/can.json`, plaene.ahmet), Scheppern 23:58:40 (`basis.json`, ev_scheppern). Ahmet ist auf den namenlosen Bildern nicht sicher zu erkennen |
| P14 | Schritt 5: Bild stimmig zur Uhr (Lauf can) | teilweise | 00:00:03 liegt nach der Lichtrückkehr um 00:00:00 (`basis.json`, ev_licht_an). Die warmen Deko-Kerzen sind an, im Ausschnitt ist kein Kerzenschein an der Theke. Vorratsraum-Licht nicht prüfbar (offene Frage 2) |
| P15 | Ende, Punkte, Fall-Code lesbar (Schritt 6) | erfüllt (4 von 4) | ahmet 9 von 9, Ahmet, VPXWW; fatma 9 von 9, Fatma, HTLPU; olli 9 von 9, Olli, 4HTFW; can 9 von 9, Can, KLRVK; Ende „Meister-Detektiv“ |
| P16 | Wahlbildschirme lesbar (B7) | erfüllt | Fragen, Karten und Knöpfe scharf. „Das ist meine Wahl“ ist ohne Auswahl ausgegraut, bleibt aber als Knopf erkennbar |

### ERGEBNIS JE PRÜFPUNKT (Bild-Checkliste)

| Nr | Punkt | Ergebnis | Fotos und Begründung |
|---|---|---|---|
| B1 | Raum folgt dem Kanon | erfüllt, soweit erkennbar | Rückblende: Theke, Tafeln, Rüstung und Bücherregal an plausiblen Stellen; Details bei 1280 px zu klein. Wahl, Dossier, Ende: nicht prüfbar, dort ist kein Raum zu sehen |
| B2 | Nebel des Krieges | nicht anwendbar | Rückblende nach dem Finale. Im Rückblendenmodus gibt `sichtbareRaeume` null zurück (`lib/party/karte_session.dart`) |
| B3 | Licht der Ermittlung | nicht anwendbar, Teile erfüllt | Zeitraffer ohne Lichtkegel des Detektivs. Grünes Notausgangslicht und warme Punkte sind vorhanden |
| B4 | Figuren erkennbar | erfüllt | Im Stromausfall sind Figuren als gedämpfte Farbfiguren erkennbar, die Mantelfarben lassen sich unterscheiden |
| B5 | Ziele und Handlung | nicht anwendbar | Keine Karte und kein Aktionsknopf in den Bildern |
| B6 | Inhaltsregeln im Bild | erfüllt, soweit erkennbar | Ausschnitt ahmet 056: keine Flasche und kein Glas auf Tischen und Theke, keine Schrift in der Szene |
| B7 | Bildschirme lesbar | erfüllt | Alle 16 Szenenbilder und alle Dossier-, Wahl- und Endbilder. Befund 1 betrifft den Inhalt, nicht die Lesbarkeit |
| B8 | Spoilerschutz | erfüllt in den Bildern, Ausnahmeliste klären | Gastbildschirme und Wahlen nennen keine Rolle. Die Täteransicht ist nur als verdeckte Einzelansicht vorgesehen (E-008, E-030), steht aber nicht auf der B8-Ausnahmeliste (Befund 2). Titel: Befund 1 |
| B9 | Rückblende | erfüllt, Abdeckung lückenhaft | Uhr läuft, Ringe auf Täter und Schneider, keine Aktionsknöpfe. Der Stromausfall ist nur in einem Lauf fotografiert (Befund 3) |

### BEFUNDE

1. **mittel** · Täteransicht: Der Titel nennt die Rolle, und ein roter Balken hebt die Ansicht hervor. Fundstelle: `content/party/schlosskeller/texte/ui-rollen.json` (ui.rollen.taeter_titel) und `tool/e2e/fotos/e2e/*_ende_meister_n7/005_dossier_taeter.png` in allen vier Läufen (Balken x 281 bis 286, y 130 bis 726). Die Ansicht ist eine lange Karte mit dem Titel „Nur für dich: Du warst es“. Das Gastdossier 004 hat vier neutrale Karten und keinen Balken. Ein Blick über die Schulter auf das Gerät nennt damit die Täterrolle. E-035 hat genau diese Zeile im Druck als Verrat gestrichen: Die Druckfassung trägt „Nur für dich. Erst lesen, wenn du dein Heft in der Hand hast.“ (`ui-druck-rollen.json`), und `druck_rollen_test.dart:122` verbietet „Nur für dich: Du warst es“ im Rollenheft-PDF. Das Log regelt für den Bildschirm nur die verdeckte Einzelansicht (E-008, E-030), nicht Titel und Akzent. Das ist der neue Grund. Erwartet: Die Titelzeile der Täteransicht nennt die Rolle nicht, wie im Druck („Nur für dich.“), und der Akzent folgt dem Gastdossier. Bleibt „Du warst es“ bei der Vorgabe F4-BAUMEISTER-02 §4, braucht es einen E-Eintrag mit Begründung. Änderung: `ui.rollen.taeter_titel` auf „Nur für dich.“ kürzen, den Akzent (Keller.gefahr laut F4-BAUMEISTER-02 §4) prüfen und einen Partytest analog zu `druck_rollen_test.dart:122` für den Bildschirmtext ergänzen, oder einen E-Eintrag schreiben, der die Abweichung vom Druck begründet.

2. **mittel** · Ausnahmelisten widersprechen sich. Fundstelle: `planung/finalisierung-schlosskeller/BILD-CHECKLISTE.md` (B8, Zeile 14), `tool/e2e/README.md` (Zeile 37), `tool/e2e/e2e.mjs` (Zeilen 163 bis 166 und 170). B8 und README nennen als Ausnahmen vom Spoilerschutz nur `dossier` und `wahl_verdeckt_*`. `e2e.mjs` überspringt zusätzlich `dossier_taeter` und alle `wahl_taeter_*`, die E-039 eingeführt hat. Wörtlich gelesen wäre die Täteransicht vor dem Finale also ein Spoiler. Der Kommentar in `e2e.mjs:163` sagt, geprüft werde „Nur für dich“, geprüft wird aber nur die Tarnung. Erwartet: Eine Ausnahmeliste, die in B8, README und `e2e.mjs` gleich lautet, dem Stand von E-039 entspricht und auf E-008 und E-039 verweist. Änderung: B8 und README um `dossier_taeter` und `wahl_taeter_*` ergänzen und den Kommentar `e2e.mjs:163` an die tatsächliche Prüfung anpassen.

3. **leicht** · Stromausfall nur in einem von vier Läufen fotografiert. Fundstelle: `tool/e2e/fotos/e2e/{ahmet,fatma,olli,can}_ende_meister_n7/057_rueckblende_1.png` mit den Uhrzeiten 23:59:55, 00:01:11, 00:02:31 und 00:00:03. Der Stromausfall reicht von 23:58:00 bis 00:00:00 (`basis.json`, ev_knall und ev_licht_an). Nur der Lauf ahmet fängt ihn ein. Die Fotostellen rueckblende_1..3 liegen je Lauf zu anderen Uhrzeiten. Damit ist B9 im Stromausfall in drei von vier Läufen nicht belegt, und Ahmets Gang im Pfad can (23:58:22 bis 23:58:30, `tatmatrix/can.json`) ist nicht fotografiert (Schritt 5). Erwartet: Je Lauf mindestens ein Rückblendenfoto im Fenster 23:58:00 bis 23:58:40. Änderung: Eine Fotostelle mit fester Kanon-Uhrzeit ergänzen (z. B. 23:58:30) oder die Rückblendenfotos auf feste Uhrzeiten legen.

4. **leicht** · E2E-Gerüst prüft die Täterwahl nicht und lässt eine leere Täteransicht durch. Fundstelle: `tool/e2e/e2e.mjs` Zeilen 166 und 170. `wahl_taeter_r1..3` werden automatisch weder negativ noch positiv geprüft. Die positive Tarnungsprüfung an `dossier_taeter` entfällt bei leerem Text (`norm(taeter.text) &&`). Eine leere Täteransicht könnte den Lauf daher bestehen. Erwartet: Eine leere Täteransicht gilt als Fehler. Die Täterwahl hat mindestens eine strukturelle Prüfung, etwa zwei Karten und den Knopf „Fertig, Bildschirm zudecken“. Änderung: Die Leertext-Ausnahme in Zeile 166 streichen und für `wahl_taeter_*` die Struktur prüfen.

### GESAMTURTEIL

Bedingt bereit. Täteransicht, Täterwahl, Rückblendenuhr, Szenenkopf und Endbildschirme sind lesbar und im Wesentlichen wie spezifiziert. Alle zwölf Täterwahlen sind harmlos formuliert. Vor der Freigabe zu klären sind der Titel der Täteransicht (Befund 1) und die widersprüchlichen Ausnahmelisten (Befund 2). Die Befunde 3 und 4 betreffen die Foto- und E2E-Abdeckung.

### OFFENE FRAGEN

1. Soll eine Verdeckt-Marke für alle verdeckten Ansichten gelten? Derzeit trägt nur die Täteransicht eine Marke. Gastdossier und Wahlen tragen keine. Eine Marke nur an der Täterwahl würde die Rolle verraten. Eine neutrale Marke („Nur für dich.“) für alle verdeckten Ansichten wäre möglich. Entscheidung bei der Spielleitung.
2. Vorratsraum-Licht: `raeume.json` (licht_vorrat) schaltet die Lampe um 23:54:20 aus und um 00:00:18 wieder an. Die Rückblende dunkelt die ganze Szene einheitlich (`karte_session.dart`: 0,72 oder 0,94 je nach „thekensaal“, helleRaeume ist leer). Ob der Vorratsraum in den Bildern zu hell wirkt, etwa olli 056 um 23:55:37, konnte ich nicht sicher bestimmen. Bei Bestätigung wäre das ein Befund „mittel“ zu Schritt 5 (Bild stimmig zur Uhr).
3. Die Fotostelle wahl_verdeckt_rN zeigt in allen Läufen Ahmets Wahl. Im Lauf ahmet ist das Bild byte-gleich mit wahl_taeter. Die verdeckte Gastwahl ist damit nur für Ahmet belegt. Hinweis, kein Befund.
4. Ahmet im Pfad can bleibt nicht prüfbar (P13). Die Figuren haben kein Namensschild. Ein Foto bei 23:58:30 würde die Frage beantworten.
5. B6 nur eingeschränkt: Die Szenen sind bei 1280 px nur grob aufgelöst. Eine höher aufgelöste Aufnahme würde B6 vollständig belegen.

=== ENDE F6-SICHT-04 · BEREIT ZUR RÜCKGABE ===

## Strukturierte Befunde und Gegenproben

Urteil des Prüfers: Bedingt bereit: Täteransicht, Täterwahl, Rückblendenuhr und Endbildschirme sind lesbar und im Wesentlichen wie spezifiziert, aber der Titel der Täteransicht nennt die Rolle, die Ausnahmelisten widersprechen sich, und der Stromausfall ist nur in einem von vier Läufen fotografiert.

### Befund 1 · mittel
- **Ort:** content/party/schlosskeller/texte/ui-rollen.json (ui.rollen.taeter_titel); tool/e2e/fotos/e2e/{ahmet,fatma,olli,can}_ende_meister_n7/005_dossier_taeter.png (roter Balken x 281 bis 286, y 130 bis 726)
- **Befund:** Die verdeckte Täteransicht nennt die Rolle in der Titelzeile („Nur für dich: Du warst es“) und hebt sich durch einen roten Randbalken und eine einzelne lange Karte vom Gastdossier 004 ab (vier neutrale Karten, kein Balken). Ein Blick über die Schulter auf das Gerät nennt damit die Täterrolle. E-035 hat dieselbe Zeile im Druck als Verrat gestrichen (Druckfassung: „Nur für dich. Erst lesen, wenn du dein Heft in der Hand hast.“ in ui-druck-rollen.json; packages/mordakte_core/test/party/druck_rollen_test.dart:122 verbietet „Nur für dich: Du warst es“ im Rollenheft-PDF). Das Log regelt für den Bildschirm nur die verdeckte Einzelansicht (E-008, E-030), nicht Titel und Akzent; das ist der neue Grund.
- **Erwartet:** Die Titelzeile der Täteransicht nennt die Rolle nicht, wie im Druck („Nur für dich.“), und der Akzent folgt dem Gastdossier. Bleibt „Du warst es“ bei der Vorgabe F4-BAUMEISTER-02 §4, braucht es einen E-Eintrag mit Begründung.
- **Änderung:** ui.rollen.taeter_titel auf „Nur für dich.“ kürzen; Akzent (Keller.gefahr laut F4-BAUMEISTER-02 §4) prüfen; Partytest analog zu druck_rollen_test.dart:122 für den Bildschirmtext ergänzen, oder einen E-Eintrag schreiben, der die Abweichung vom Druck begründet.
- **Gegenprobe:** hält (mittel). Der Befund hält stand: Die Fundstelle ist belegt, die Titelzeile „Nur für dich: Du warst es“ mit rotem Randbalken ist auf den Fotos sichtbar und unterscheidet sich vom Gastdossier, und E-035 hat genau diese Zeile im Druck wegen des Aufbaus gestrichen. Das Log entscheidet nur, dass Täterinhalte in der verdeckten Einzelansicht stehen dürfen (E-008, E-030), nicht Titel oder Akzent auf dem Bildschirm; die Vorgabe §4 des Auftrags F4-BAUMEISTER-02 ist ein Auftrag, kein begründeter Logeintrag, und der Befund nennt mit dem Blick über die Schulter einen neuen Grund. Die Gegenprobe greift nicht, weil die Verdeckung der Ansicht nur im Auftrag beschrieben und nicht auf einem Foto belegt ist und die Vorgabe „Nur für dich“ auch mit gekürzter Titelzeile erfüllt bliebe.
  - Nachgeprüft: Gelesen: ENTSCHEIDUNGSLOG E-008, E-030 (Sitzung: Rundenwahl „am Bildschirm nicht ablesen“), E-034 (Zeile 906, „Nur für dich“ als Teilstring auf Rollen-Bildschirm und Druck), E-035 (Anlass und Fassungen), E-039 (GEGEN-01 Nr. 4, SPIEL-01 Nr. 2); Bild-Checkliste B8; Auftrag F4-BAUMEISTER-02 §4 und §8. Texte: ui-rollen.json Zeilen 59 bis 60, ui-druck-rollen.json, druck_rollen_test.dart Zeile 122, druck_test.dart Zeilen 144 bis 157. Fotos selbst angesehen: ahmet 003_rollen, 004_dossier, 005_dossier_taeter; fatma 005_dossier_taeter (Titelzeile, roter Randbalken links bei etwa x 281 bis 287, eine lange Karte, gegenüber vier neutralen Karten ohne Balken in 004). Gesucht nach Titel, Akzent, Schulter-Blick und Zwischenstufe im Log und in content/party sowie packages/*/lib. git status (leer). Nicht einzeln angesehen: olli und can 005 (gleicher Textbaustein); die Zwischenstufe ist nur im Auftrag beschrieben und auf keinem Foto belegt.

### Befund 2 · mittel
- **Ort:** planung/finalisierung-schlosskeller/BILD-CHECKLISTE.md (B8, Zeile 14); tool/e2e/README.md (Zeile 37); tool/e2e/e2e.mjs (Zeilen 163 bis 166 und 170)
- **Befund:** Die Ausnahmelisten widersprechen sich. B8 und README nennen als Ausnahmen vom Spoilerschutz nur dossier und wahl_verdeckt_*. e2e.mjs überspringt zusätzlich dossier_taeter und alle wahl_taeter_*, die E-039 eingeführt hat. Wörtlich gelesen wäre die Täteransicht vor dem Finale ein Spoiler. Der Kommentar in e2e.mjs:163 sagt, geprüft werde „Nur für dich“, geprüft wird aber nur die Tarnung.
- **Erwartet:** Eine Ausnahmeliste, die in B8, README und e2e.mjs gleich lautet, dem Stand von E-039 entspricht und auf E-008 und E-039 verweist.
- **Änderung:** B8 und README um dossier_taeter und wahl_taeter_* ergänzen; Kommentar e2e.mjs:163 an die tatsächliche Prüfung anpassen.
- **Gegenprobe:** hält (mittel). Der Widerspruch besteht: B8 und README nennen nur dossier und wahl_verdeckt_* als Ausnahmen, e2e.mjs überspringt zusätzlich dossier_taeter und wahl_taeter_* (Zeile 170), und E-039 hat diese Fotostellen eingeführt, ohne B8 oder README nachzuziehen. E-039 entscheidet die Fotostellen und die positive Semantikprüfung, aber nicht die Angleichung der Listen, daher greift (c) nicht. Die Täteransicht ist im Code verdeckt (zeigeVerdeckt/verdecken, StateError ohne verdeckte Ansicht) und nach E-008 nur in der verdeckten Einzelansicht zulässig, daher ist „Spoiler“ nur die wörtliche Lesart der Liste, nicht die Sache. Korrektur am Befund: Der Kommentar in e2e.mjs:163 behauptet nicht, dass „Nur für dich“ geprüft wird, er beschreibt den Inhalt der Ansicht; die Lücke ist die fehlende Prüfung der Tarnung allein, und das ändert die Schwere nicht.
  - Nachgeprüft: git status (nur dies, kein git log). Gelesen: BILD-CHECKLISTE.md Zeile 14 (B8), tool/e2e/README.md Zeile 37, tool/e2e/e2e.mjs Zeilen 150 bis 177 (Kommentar Zeile 163, Prüfung 164 bis 166, Überspringen Zeile 170), ENTSCHEIDUNGSLOG.md E-008 (Zeile 89), E-039 (SPIEL-01 Nr. 2, Zeile 1165) und Zeile 808, lib/party/skript.dart Zeilen 137 bis 158, packages/mordakte_core/lib/src/party/sitzung.dart Zeilen 149 bis 162 (zeigeVerdeckt, verdecken, StateError). Foto tool/e2e/fotos/e2e/olli_ende_meister_n7/005_dossier_taeter.png angesehen: Tafel „Nur für dich: Du warst es“, Knopf „Fertig, Bildschirm zudecken“.

### Befund 3 · leicht
- **Ort:** tool/e2e/fotos/e2e/{ahmet,fatma,olli,can}_ende_meister_n7/057_rueckblende_1.png (Uhr 23:59:55, 00:01:11, 00:02:31, 00:00:03); Fotostellen rueckblende_1..3
- **Befund:** Die Rückblendenfotos liegen je Lauf zu anderen Uhrzeiten. Nur im Lauf ahmet fällt ein Foto in den Stromausfall (23:58:00 bis 00:00:00, basis.json ev_knall und ev_licht_an). In fatma, olli und can liegt das erste Foto nach 00:00. B9 im Stromausfall ist damit in drei von vier Läufen nicht belegt, und Ahmets Gang im Pfad can (23:58:22 bis 23:58:30, tatmatrix/can.json) ist nicht fotografiert (Schritt 5).
- **Erwartet:** Je Lauf mindestens ein Rückblendenfoto im Fenster 23:58:00 bis 23:58:40.
- **Änderung:** Eine Fotostelle mit fester Kanon-Uhrzeit ergänzen (z. B. 23:58:30) oder die Rückblendenfotos auf feste Uhrzeiten legen.

### Befund 4 · leicht
- **Ort:** tool/e2e/e2e.mjs (Zeilen 166 und 170)
- **Befund:** Das E2E-Gerüst prüft wahl_taeter_r1..3 weder negativ noch positiv. Die positive Tarnungsprüfung an dossier_taeter entfällt bei leerem Text (norm(taeter.text) &&). Eine leere Täteransicht könnte den Lauf daher bestehen.
- **Erwartet:** Eine leere Täteransicht gilt als Fehler. Die Täterwahl hat mindestens eine strukturelle Prüfung, etwa zwei Karten und den Knopf „Fertig, Bildschirm zudecken“.
- **Änderung:** Die Leertext-Ausnahme in Zeile 166 streichen und für wahl_taeter_* die Struktur prüfen.

## Abnahme (Orchestrator)
- FREIGEGEBEN · 10/10
- Funktion 2 · Kanon-Treue 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2
- Entscheidungen: ENTSCHEIDUNGSLOG E-041.
