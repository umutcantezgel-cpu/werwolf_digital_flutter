# ABNAHME · FEINKORN · Entwurf K0

Quelle: MASTER-PROMPT.md, Abschnitt 12 (Wortlaut), Abschnitt 8 (Prüfwerkzeuge), Abschnitt 10 (Phasentore); Begriffe aus Abschnitt 6, Raummodell und Verweise aus Abschnitt 7, Vorgaben aus Abschnitt 0 und 1.

Stand: Entwurf in Bauphase K0 · Abnahme 0 von 16 · alle Zeilen Status „offen“, Beleg-Spalte leer.

## Zählregel

- Abnahme a von 16: Ein K gilt erst als erfüllt, wenn alle seine Zeilen belegt sind (Beleg-Spalte gefüllt, Status „belegt“).
- Abgehakt wird nur mit Beleg: Testlauf, Bildschirmfoto, Messwert oder Protokoll (§12).

## Konventionen

- Zeilen: Jeder Unterpunkt von §12 ist eine Zeile, Kennung K-nn.m. Steht ein Unterpunkt unter einem Oberpunkt, wird der Oberpunkt mit Doppelpunkt vorangestellt. Enthält ein Aufzählungspunkt mehrere getrennt prüfbare Aussagen, wird er geteilt. Teile, die nicht am Satzanfang stehen, beginnen mit „[…]“. Der Wortlaut ist unverändert übernommen.
- Schwelle: (1) Zahl aus dem Kriterium übernommen. (2) Kein Zahlwert, aber ein Universalwort: „0“ bei keine, kein, nichts, null, nicht, unverändert, verlustfrei; „100 %“ bei alle, aller, jede, jeder, jedes, vollständig. Die Ableitung steht in Klammern mit dem Wort. (3) Verweis auf einen Abschnitt des Master-Prompts, mit dem dortigen Wert. (4) Sonst „siehe K0-Festlegung“ (Liste unten).
- Prüfmethode: Typ vorangestellt (Test, Werkzeug, Bildschirmfoto, Protokoll). „Werkzeug fehlt“ heißt: laut §8 zu bauen, noch nicht im Repo. „Grenze der Umgebung“ markiert Zeilen, die die Umgebung nicht messen kann (keine Handys, kein Android-SDK, kein Xcode). Dort steht zusätzlich „Testplan echte Geräte (FÜR DEN NUTZER)“ und der Ersatzbeleg.
- Vorhandene Werkzeuge: tool/feinkorn/bestand.dart (Aufruf aus dem Repo-Wurzelordner: dart run tool/feinkorn/bestand.dart, mit --schreibe Messbasis anlegen, mit --vergleiche gegen Messbasis prüfen, Exit 1 bei Abweichung; Präfixe der Ausgabe: + neu, - entfernt). tool/feinkorn/messen.mjs (node tool/feinkorn/messen.mjs buildOrdner ausgabe.json, optional --ansichten, --klassen hoch,mittel,einfach, --sekunden 8; liefert je Klasse Ladezeit, Bilder pro Sekunde, Intervall Median und p99, Rechenlast, JS-Heap, fremde Netzaufrufe, Konsolenfehler; CPU-Drosselung hoch 1×, mittel 4×, einfach 6×; Standardansicht ist buffetsaal, nicht Thekensaal). Messbasis: noch nicht angelegt (K0).
- Kanon-Quelle für Abgleiche (nur lesen, §0): origin/finalisierung-schlosskeller, Pfad krimidinner/spuk-im-gewoelbe/10_kanon/.

## Phasentore (Abschnitt 10)

| K | Titel | Phasentor |
|---|---|---|
| K-01 | Aufgebaut auf dem Bestand | K2 (Tor K-05 und K-01) |
| K-02 | Blockdaten | K1 (Tor K-02 und K-03) |
| K-03 | Darstellung | K1 (Tor K-02 und K-03) |
| K-04 | Handyschonung | K6 (Tor K-04, K-12 und K-13) |
| K-05 | Physik | K2 (Tor K-05 und K-01) |
| K-06 | Bewegung | K3 (Tor K-06 und K-07) |
| K-07 | Figuren | K3 (Tor K-06 und K-07) |
| K-08 | Orte und Detailtiefe | K4 (Tor K-08 und K-09) |
| K-09 | Materialien und Stimmung | K4 (Tor K-08 und K-09) |
| K-10 | Verzahnung | K5 (Tor K-10 und K-11) |
| K-11 | Bestehende Designs verschärft | K5 (Tor K-10 und K-11) |
| K-12 | Geräte und Geräteklassen | K6 (Tor K-04, K-12 und K-13) |
| K-13 | Werkzeuge und Dokumentation | K6 (Tor K-04, K-12 und K-13) |
| K-14 | Spiel und Bestand | K7 (Tor K-14, K-15 und K-16) |
| K-15 | Geprüft und übergeben | K7 (Tor K-14, K-15 und K-16) |
| K-16 | Auf main | K7 (Tor K-14, K-15 und K-16) |

Zusätzlich gilt: Das K6-Tor belegt alle bisherigen Kriterien erneut. Ein Phasentor ist bestanden, wenn alle Tests grün sind, die Budgets je Geräteklasse eingehalten sind, die Bestandsprüfung keine Abweichung zur Messbasis zeigt, die Berichte von Sichtprüfer, Bestandswächter und Gegenprüfer keine schweren Befunde enthalten, die App mit der bisherigen Darstellung unverändert lauffähig ist und ein Commit angelegt und kern-feinkorn gepusht ist (§10).

## K-01 · Aufgebaut auf dem Bestand · Tor K2

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-01.1 | Die Bestandsprüfung zeigt gegenüber der Messbasis: keine neuen Abhängigkeiten in der App | Werkzeug: dart run tool/feinkorn/bestand.dart --vergleiche Messbasis (Messbasis vor dem ersten Eingriff mit --schreibe anlegen). Protokoll: keine Zeile mit Präfix „+ abhaengigkeit“, „+ dev-abhaengigkeit“, „+ paket-abhaengigkeit“ oder „+ paket-aufgeloest“. | 0 neue (aus „keine“) | | offen |
| K-01.2 | Die Bestandsprüfung zeigt gegenüber der Messbasis: unveränderte Build-, Signatur-, Store- und Berechtigungseinstellungen | Werkzeug: bestand.dart --vergleiche Messbasis. Protokoll: keine Abweichung in den Bereichen android-signatur, ios-signatur, build-datei, android-berechtigung, ios-berechtigung, ios-entitlements, android-name, ios-name. | 0 Abweichungen (aus „unveränderte“) | | offen |
| K-01.3 | Die Bestandsprüfung zeigt gegenüber der Messbasis: unveränderte App-Kennung und Versionsnummer | Werkzeug: bestand.dart --vergleiche Messbasis. Protokoll: keine Abweichung in den Bereichen android-kennung, ios-kennung, version, name. | 0 Abweichungen (aus „unveränderte“) | | offen |
| K-01.4 | Die Pixel-Bausteine sind ein klar getrennter Teil, folgen den Konventionen des Projekts und enthalten keinen Spielinhalt, belegt durch die Trennungsprüfung. | Werkzeug fehlt: Trennungsprüfung (§8). Vorgesehen: Suche im Ordner der Pixel-Bausteine nach Namen, Orten und Texten aus dem Kanon-Stand; Trefferzahl im Protokoll. Konventionen: Sichtprüfung des Aufbaus gegen die Konventionen der Messbasis. | 0 Treffer Spielinhalt (aus „keinen“); Konventionen: siehe K0-Festlegung (Konventionsliste der Messbasis) | | offen |
| K-01.5 | Der Prüfstand läuft nur auf den Pixel-Bausteinen; die Release-Prüfung findet ihn nicht im veröffentlichten Build. | Test: Release-Prüfung. Web-Release-Build (flutter build web --release); Suche im Build-Ausgabeordner nach den Kennungen von Prüfstand und Modellschau; Protokoll mit Trefferzahl. Grenze der Umgebung: APK und IPA sind nicht baubar, Ersatz ist der Web-Release; Testplan echte Geräte (FÜR DEN NUTZER) für die Store-Builds. Kennungen: siehe OFFENE FRAGEN. | 0 Treffer im Release-Build (aus „nicht“) | | offen |

## K-02 · Blockdaten · Tor K1

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-02.1 | Eine Szene zeigt gleichzeitig Blockkörper in allen drei Blockgrößen ihrer Geräteklasse. | Bildschirmfoto: messen.mjs legt je Geräteklasse und Ansicht ein Foto ab (Ausgabe_Klasse_Ansicht.png). Werkzeug fehlt: Zählung der Blockgrößen je Szene (§8, Blockzahl je Geräteklasse). Protokoll: Anzahl verschiedener Blockgrößen je Szene und Klasse. | 3 je Geräteklasse (Wortlaut „allen drei“); Startwerte §0: hoch 2,5 / 1 / 0,5 cm, mittel 5 / 2 / 1 cm; einfach: siehe K0-Festlegung | | offen |
| K-02.2 | Speichern und Laden ist verlustfrei, geprüft Block für Block. | Test: flutter test, Speichern, Laden und Vergleich jedes Blocks (Position, Material, Blockgröße). Werkzeug fehlt: Block-für-Block-Vergleich (§8, Testschreiber). Protokoll: Anzahl verglichener Blöcke und Abweichungen. | 0 Abweichungen (aus „verlustfrei“) | | offen |
| K-02.3 | Eine große synthetische Welt in Abschnitten lässt sich durchqueren. | Test: flutter test. Synthetische Welt im Testcode erzeugen, alle Abschnitte nacheinander laden und wieder freigeben. Protokoll: Anzahl geladener und durchquerter Abschnitte. | 100 % der Abschnitte durchquert (aus „lässt sich durchqueren“); Weltgröße: siehe K0-Festlegung | | offen |
| K-02.4 | […] der Speicher schwankt dabei um höchstens 10 %. | Werkzeug fehlt: Speicher-Zeitreihe während K-02.3 (messen.mjs liefert nur Endwerte; Vorschlag: Abtastung je Abschnittswechsel, Dart über ProcessInfo.currentRss aus dart:io). Protokoll: Minimum, Maximum und Bezugswert je Lauf; Bezugsgröße siehe OFFENE FRAGEN. | höchstens 10 % Schwankung (Wortlaut) | | offen |

## K-03 · Darstellung · Tor K1

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-03.1 | Jede Lichtart aus 7.3, die die Technik trägt, ist mit Bildschirmfotos belegt. | Bildschirmfoto: messen.mjs-Fotos je Geräteklasse; Serie je Lichtart über eigene Testszenen (Werkzeug fehlt: automatisierte Bildschirmfotos, §8). Protokoll: Tabelle Lichtart mal Foto-Datei. | 100 % der Lichtarten aus 7.3, die die Technik trägt (aus „Jede“); 7.3 nennt 6 Lichtarten: kaltes Grundlicht, warme Punktlichter mit Flackern, Schatten aus der Form, dunklere Fugen und Ecken, leuchtende Materialien, Taschenlampenkegel | | offen |
| K-03.2 | Jede Grenze steht begründet unter FÜR DEN NUTZER. | Protokoll: Sichtprüfung des Abschnitts FÜR DEN NUTZER; jede nicht umgesetzte Lichtart aus 7.3 steht mit Begründung. Dateiname siehe OFFENE FRAGEN. | 100 % der nicht umgesetzten Lichtarten mit Begründung (aus „Jede“) | | offen |
| K-03.3 | Blockkanten bleiben auf allen Bildschirmdichten der Zielgeräte scharf (±1 px). | Grenze der Umgebung. Ersatz: Web-Build in Headless-Chromium (Playwright) mit mehreren Geräte-Pixeldichten (deviceScaleFactor); Kantenversatz in Pixeln an Blockkanten messen (Werkzeug fehlt). Testplan echte Geräte (FÜR DEN NUTZER) für die Zielgeräte. | ±1 px (Wortlaut); Zielgeräte und Pixeldichten: siehe K0-Festlegung | | offen |
| K-03.4 | Beim Schwenken bleibt das Flimmern unter der Schwelle aus K0. | Grenze der Umgebung (Software-WebGL ohne GPU). Werkzeug fehlt: Flimmerprüfung per Bildvergleich (§8). Vorgesehen: Bildfolge beim Schwenken (Schema messen.mjs, Phase bewegt), Helligkeitsdifferenz je Block über aufeinanderfolgende Bilder. Testplan echte Geräte (FÜR DEN NUTZER). | siehe K0-Festlegung (Flimmerschwelle) | | offen |
| K-03.5 | Die bisherige Darstellung ist über einen Schalter erreichbar. | Test: Widget- oder Integrationstest (flutter test). Schalter auf bisherige Darstellung stellen, Darstellung wird gerendert. Bildschirmfoto der bisherigen Darstellung nach dem Umschalten. | 1 Schalter (Wortlaut „einen“) | | offen |

## K-04 · Handyschonung · Tor K6

Gemeinsame Hinweise: Jede Messung je Geräteklasse (hoch, mittel, einfach) im vollen Thekensaal mit allen Figuren. Werkzeug: messen.mjs mit --ansichten für den Thekensaal (Query siehe OFFENE FRAGEN) und --klassen hoch,mittel,einfach. Grenze der Umgebung gilt für alle Zeilen mit Gerätewerten; der Ersatz ist Chromium mit CPU-Drosselung.

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-04.1 | Bildrate: hoch mindestens 60, mittel und einfach mindestens 30 Bilder pro Sekunde. | Grenze der Umgebung. Werkzeug: messen.mjs, Feld bilderProSekunde je Klasse, Phase bewegt (Phasenwahl siehe OFFENE FRAGEN). Ersatz: Chromium mit Drosselung 1× / 4× / 6×, kein Gerät. Testplan echte Geräte (FÜR DEN NUTZER). | hoch mindestens 60 · mittel mindestens 30 · einfach mindestens 30 Bilder/s (Wortlaut) | | offen |
| K-04.2 | Im 99. Perzentil dauert ein Bild höchstens doppelt so lang wie die Zielbildzeit. | Grenze der Umgebung. Werkzeug: messen.mjs, Feld intervallP99Ms je Klasse und Phase; Vergleich mit 2 × Zielbildzeit. Testplan echte Geräte (FÜR DEN NUTZER). | höchstens 2 × Zielbildzeit (Wortlaut „doppelt so lang“); Zielbildzeit: siehe K0-Festlegung | | offen |
| K-04.3 | In ruhigen Momenten sinkt die Rechenlast um mindestens 50 % gegenüber dem bewegten Spiel; | Grenze der Umgebung (Rechenlast nur als relative Größe übertragbar). Werkzeug: messen.mjs, Felder rechenlast in Phase ruhig und rechenlast in Phase bewegt je Klasse. Berechnung: 1 − ruhig / bewegt, mindestens 0,50. | Senkung um mindestens 50 % (Wortlaut) | | offen |
| K-04.4 | […] im Hintergrund rechnet die App nichts. | Werkzeug fehlt: Hintergrund-Lauf (messen.mjs misst nur die sichtbare Seite). Vorgesehen: Seite nach dem Laden in den Hintergrund setzen, 8 s warten, Hauptthread-Arbeit per CDP (Performance.getMetrics, TaskDuration) messen. Protokoll: Arbeit im Hintergrund in ms. | 0 (aus „nichts“) | | offen |
| K-04.5 | Im 30-Minuten-Dauertest bleibt der Wärmezustand im Normalbereich, wo die Testumgebung ihn messen kann; sonst steht der Test im Testplan für echte Geräte. | Grenze der Umgebung. Ersatz: messen.mjs mit --sekunden 1800, je Klasse, nur Thekensaal (Laufzeit rund 60 Minuten je Klasse, weil ruhig und bewegt je 1800 s laufen); Protokoll mit Rechenlast und Heap am Ende. Wärme ist nicht messbar. Testplan echte Geräte (FÜR DEN NUTZER): 30-Minuten-Dauertest mit Wärmeprotokoll. | Dauer 30 Minuten (Wortlaut); Wärmenormalbereich: siehe K0-Festlegung | | offen |
| K-04.6 | Wird ein Gerät warm, stuft die App sich nachweislich herunter. | Grenze der Umgebung. Ersatz: Test (flutter test) der Herunterstufungslogik mit injiziertem Wärmesignal; Protokoll zeigt den Wechsel auf eine niedrigere Stufe. Testplan echte Geräte (FÜR DEN NUTZER): Wärme am Gerät. | mindestens 1 Herunterstufung nach dem Wärmesignal (aus „stuft … herunter“); Wärmeschwelle: siehe K0-Festlegung | | offen |
| K-04.7 | Der Arbeitsspeicher bleibt im Budget. | Grenze der Umgebung (JS-Heap statt Gerätespeicher). Werkzeug: messen.mjs, Feld jsHeapMB je Klasse; Vergleich mit dem Budgetwert. Testplan echte Geräte (FÜR DEN NUTZER). | siehe K0-Festlegung (Arbeitsspeicher aus der Budgettabelle) | | offen |
| K-04.8 | Nach 30 Minuten liegt er höchstens 10 % über dem Wert nach 2 Minuten. | Grenze der Umgebung. Werkzeug fehlt: Zeitreihe des JS-Heaps (messen.mjs liefert nur den Endwert je Phase). Vorgesehen: Abtastung alle 10 s über 30 Minuten in Phase bewegt; Vergleich Wert nach 2 Minuten mit Wert nach 30 Minuten. Testplan echte Geräte (FÜR DEN NUTZER). | höchstens 10 % über dem Wert nach 2 Minuten (Wortlaut); Dauer 30 Minuten | | offen |
| K-04.9 | Die App wächst höchstens um das Größenbudget aus K0. | Grenze der Umgebung (native Größe). Werkzeug fehlt: App-Größenmessung (§8). Ersatz: Größe des Web-Build-Ordners (du -sb buildOrdner) gegen den Messbasis-Wert, Zuwachs in Bytes. Testplan echte Geräte (FÜR DEN NUTZER): Größe der nativen Store-Builds. | Zuwachs höchstens Größenbudget; Größenbudget: siehe K0-Festlegung | | offen |
| K-04.10 | Bis zum spielbaren Schlosskeller dauert es höchstens 2 Sekunden länger als in der Messbasis. | Grenze der Umgebung (Web statt nativ). Werkzeug: messen.mjs, Feld ladezeitMs je Klasse, mit demselben Werkzeug vor dem ersten Eingriff als Messbasis. Differenz nach Änderung minus Messbasis. Messpunkt „spielbar“: siehe OFFENE FRAGEN. Testplan echte Geräte (FÜR DEN NUTZER). | höchstens 2 s Mehrzeit gegenüber der Messbasis (Wortlaut) | | offen |
| K-04.11 | Die Budgettabelle ist eingehalten. | Protokoll: Abgleich aller Messwerte (messen.mjs, bestand.dart, Größenmessung, Zählwerke) gegen die Budgettabelle je Geräteklasse; eine Zeile je Feld mit Ist, Soll und erfüllt ja oder nein. Grenze der Umgebung für geräteabhängige Felder; Testplan echte Geräte (FÜR DEN NUTZER). | siehe K0-Festlegung (Budgettabelle je Geräteklasse, §7.10) | | offen |

## K-05 · Physik · Tor K2

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-05.1 | Dieselbe Eingabeaufzeichnung endet bei 30, 60 und 120 Bildern pro Sekunde im selben Zustand. | Werkzeug fehlt: Determinismus-Test (§8, Bau in K2). Vorgesehen: dieselbe Eingabeaufzeichnung bei Bildrate 30, 60 und 120 abspielen; die Physik-Rate bleibt fest (§7.4); Endzustand (Position, Lage, Material aller Blockkörper und Partikel) als Prüfsumme. Protokoll: drei Prüfsummen gleich ja oder nein. | 30, 60 und 120 Bilder/s (Wortlaut); 0 Abweichungen im Endzustand (aus „selben“) | | offen |
| K-05.2 | Derselbe Startwert ergibt in 100 Wiederholungen denselben Endzustand. | Werkzeug fehlt: Determinismus-Test. 100 Läufe mit identischem Startwert; Prüfsumme des Endzustands je Lauf. Protokoll: Anzahl gleicher Prüfsummen von 100. | 100 Wiederholungen (Wortlaut); 0 Abweichungen (aus „denselben“) | | offen |
| K-05.3 | Die Fallzeit aus 1 m Höhe weicht höchstens 2 % von der Formel ab. | Werkzeug fehlt: Physik-Messszene Fall (§8). Vorgesehen: Körper aus 1 m Höhe fallen lassen, Zeit bis zum Aufprall in Sekunden aus den Simulationsschritten bei fester Rate, Abgleich mit der Formel. Formel: siehe OFFENE FRAGEN. Protokoll: Abweichung in Prozent. | höchstens 2 % (Wortlaut) bei 1 m Höhe; Formel: siehe OFFENE FRAGEN | | offen |
| K-05.4 | Ein Stapel aus zehn Kisten steht 60 s und wandert dabei höchstens 1 mm. | Werkzeug fehlt: Physik-Messszene Stapel (§8, Prüfstand nach 7.9 mit Kisten). Vorgesehen: zehn Kisten stapeln, 60 s simulieren, Verschiebung gegenüber der Startlage in mm. Umrechnung Welt zu mm und Bezug der 1 mm: siehe OFFENE FRAGEN. Protokoll: Maximum. | höchstens 1 mm (Wortlaut); 10 Kisten, 60 s (Wortlaut) | | offen |
| K-05.5 | Holz, Glas, Stein und Wachs zerbrechen nach ihrem Muster, belegt durch Bildfolgen. | Werkzeug fehlt: automatisierte Bildfolgen (§8) über die Physik-Messszene Bruch (Prüfstand). Je Material eine Bildfolge; Sichtprüfung gegen das Muster aus 7.4 (Holz entlang der Faser, Glas in Scherben, Stein an den Kanten, Wachs krümelt). Protokoll: Tabelle Material mal Bildfolge mal erfüllt ja oder nein. | 4 Materialien (Aufzählung), je 1 Bildfolge; Muster laut 7.4 | | offen |
| K-05.6 | Partikel kommen zur Ruhe und lagern sich ab. | Werkzeug fehlt: Physik-Messszene Staub und Krümel (§8). Vorgesehen: Simulation bis zur Ruhe-Schwelle, Protokoll: Zahl bewegter Partikel am Ende; Ablagerung: Zahl der Blöcke der Welt vor und nach dem Lauf. | siehe K0-Festlegung (Ruhe-Schwelle für Partikel) | | offen |
| K-05.7 | Schüttgut bildet Häufchen mit stabilem Böschungswinkel, höchstens 5 Grad vom Materialwert entfernt. | Werkzeug fehlt: Physik-Messszene Sandhaufen (Prüfstand nach 7.9). Vorgesehen: Böschungswinkel aus dem Blockprofil des ruhenden Haufens; Abgleich mit dem Materialwert der Materialbibliothek (7.6). Protokoll: Abweichung in Grad. | höchstens 5 Grad (Wortlaut) vom Materialwert; Materialwert: siehe K0-Festlegung (Materialbibliothek 7.6) | | offen |
| K-05.8 | Außerhalb extremer Posen durchdringt nachschwingende Kleidung den Körper nicht, geprüft vom Sichtprüfer. | Bildschirmfoto und Sichtprüfung: Sichtprüfer (§4) prüft Bildfolgen aller Posen außerhalb der extremen Posen (automatisierte Bildfolgen, Werkzeug fehlt). Protokoll: Liste der Posen mit Bildnummer und durchdrungenen Stellen. | 0 durchdrungene Stellen außerhalb extremer Posen (aus „nicht“); extreme Posen: siehe K0-Festlegung | | offen |

## K-06 · Bewegung · Tor K3

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-06.1 | Die Lückenprüfung findet in allen Posen und Übergängen null offene Stellen an Gelenken. | Werkzeug fehlt: Lückenprüfung an Gelenken (§8, Bau in K3). Vorgesehen: alle Posen und Übergänge aus 7.5 abspielen, je Bild offene Gelenkstellen zählen. Protokoll: Summe je Pose und Übergang. | 0 offene Stellen (aus „null“) in 100 % der Posen und Übergänge (aus „allen“) | | offen |
| K-06.2 | Alle Zustände aus 7.5 und alle Ruhe-Animationen aus dem Kanon sind erreicht und mit Bildstreifen belegt. | Test und Bildstreifen: je Zustand aus 7.5 und je Ruhe-Animation aus dem Kanon einen Lauf starten und einen Bildstreifen speichern. Protokoll: Checkliste mit den Zuständen und allen Ruhe-Animationen des Kanons; jeder Eintrag mit Bildstreifen-Datei. | 100 % der 8 Zustände aus 7.5 (Stehen, Gehen, Sitzen auf Bänken, Tür öffnen, Gegenstand untersuchen, Erschrecken, Taschenlampe schwenken, Reden mit Gesten) und 100 % der Ruhe-Animationen aus dem Kanon (7.5 nennt 4 Beispiele) | | offen |
| K-06.3 | Beim Gehen gleiten Füße höchstens 1 cm pro Schritt. | Werkzeug fehlt (nicht in §8 genannt, siehe OFFENE FRAGEN): Fußgleiten aus den Skelettdaten. Vorgesehen: je Schritt Fußposition in Weltkoordinaten während des Bodenkontakts, größte Verschiebung in cm. Protokoll: Wert je Schritt. | höchstens 1 cm (Wortlaut) je Schritt | | offen |
| K-06.4 | Außer beim Erschrecken springt kein Gelenk zwischen zwei Bildern um mehr als 25 Grad. | Werkzeug fehlt (Teil der Lückenprüfung an Gelenken, §8). Vorgesehen: Gelenkwinkel je Bild aus den Skelettdaten; Differenz aufeinanderfolgender Bilder, Zustand Erschrecken ausgenommen. Protokoll: größte Differenz je Gelenk in Grad. | höchstens 25 Grad (Wortlaut) je Gelenk zwischen zwei Bildern; Ausnahme: Zustand Erschrecken | | offen |
| K-06.5 | In 60 Sekunden Stillstand bewegt sich jede Figur sichtbar, belegt durch Bildvergleich. | Test: Figur 60 Sekunden ohne Eingabe laufen lassen (Schema messen.mjs, Phase ruhig). Bildvergleich: Pixeldifferenz im Figurenbereich zwischen Bildern im Abstand von 1 Sekunde. Protokoll je Figur: Differenzwert und ja oder nein. | 60 Sekunden (Wortlaut); 100 % der Figuren (aus „jede“); „sichtbar“: siehe K0-Festlegung (Sichtbarkeitsschwelle) | | offen |

## K-07 · Figuren · Tor K3

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-07.1 | Alle Figuren des Kanons liegen als Modelle aus Pixel-Blöcken vor, erzeugt mit dem Baukasten: 20 Rollen, der Detektiv in m- und w-Fassung und Herr Schneider. | Werkzeug fehlt: Kanon-Abgleich der Figuren (§8). Vorgesehen: Liste der Kanon-Figuren (Kanon-Pfad siehe Konventionen) gegen die Rezepte im Figuren-Baukasten; zusätzlich je Modell prüfen, dass es aus einem Rezept erzeugt wurde. Protokoll: Anzahl Modelle, fehlende Figuren. | 100 % des Kanon-Umfangs (aus „Alle“); Wortlaut-Umfang: 20 Rollen, Detektiv m, Detektiv w, Herr Schneider (Summe 23 oder 21, siehe OFFENE FRAGEN) | | offen |
| K-07.2 | Je Figur gibt es ein Figurenblatt mit vier Ansichten und sechs Schlüsselposen. | Bildschirmfoto: Figurenblatt je Figur exportieren. Protokoll: Zahl der Ansichten (vorne, Seite, hinten, Dreiviertel) und Zahl der Schlüsselposen je Figur. | 4 Ansichten und 6 Schlüsselposen je Figur (Wortlaut) | | offen |
| K-07.3 | Der Kanon-Abgleich ist grün | Protokoll: Kanon-Abgleich-Bericht mit Status grün, wenn K-07.4 und K-07.5 erfüllt sind. Werkzeug fehlt: Kanon-Abgleich (§8). | siehe K0-Festlegung (Definition „grün“; Vorschlag: K-07.4 und K-07.5 erfüllt) | | offen |
| K-07.4 | Die Grundfarben liegen unter neutralem Licht höchstens ΔE2000 = 3 vom Kanon-Farbcode entfernt | Werkzeug fehlt: Farbabgleich. Vorgesehen: Grundfarben der Modelle unter neutraler Lichtvorlage rendern und mit dem Kanon-Farbcode über ΔE2000 vergleichen. Protokoll: ΔE2000-Wert je Grundfarbe. Liste der Grundfarben: siehe OFFENE FRAGEN. | höchstens ΔE2000 = 3 (Wortlaut) je Grundfarbe | | offen |
| K-07.5 | […] alle Merkmale sind vorhanden. | Werkzeug fehlt: Kanon-Abgleich (§8). Merkmalliste je Figur aus den Kanon-Feldern (Statur, Größe, Haltung, Kleidungsschichten, Zubehör, Farbcodes laut 7.6) gegen das Modell. Protokoll: je Merkmal ja oder nein. | 100 % der Merkmale (aus „alle“) | | offen |
| K-07.6 | Die Sichtprüfer-Checkliste ist je Figur zu mindestens 90 % erfüllt, | Werkzeug fehlt: Sichtprüfer-Checkliste je Figur (§4, §8), Grundlage sind die Bildschirmfotos der Figurenblätter und Ansichten. Protokoll: erfüllte Punkte in Prozent je Figur. Checkliste: siehe OFFENE FRAGEN. | mindestens 90 % (Wortlaut) je Figur | | offen |
| K-07.7 | […] darunter die Erkennbarkeit im gedimmten Licht und in jeder Geräteklasse. | Bildschirmfoto: messen.mjs-Fotos je Geräteklasse (hoch, mittel, einfach) und Ansicht bei gedimmtem Licht (Lichtvorlage siehe OFFENE FRAGEN). Sichtprüfer-Bewertung je Foto. Protokoll: Erkennbarkeit je Figur und Klasse ja oder nein. Grenze der Umgebung: Chromium statt Gerätedisplay. Testplan echte Geräte (FÜR DEN NUTZER). | siehe K0-Festlegung (Mindestwert Erkennbarkeit); 3 Geräteklassen (hoch, mittel, einfach) und gedimmtes Licht | | offen |

## K-08 · Orte und Detailtiefe · Tor K4

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-08.1 | Alle Orte aus 7.7 sind aus Pixel-Blöcken gebaut; | Protokoll: Ortsliste aus 7.7 (Eingang, Thekensaal, West-Saal, Ost-Saal, Vorratsraum, Durchgang, Turmgang, Schlossfassade) gegen die Raumrezepte; je Ort ja oder nein für Rezept und Modell aus Pixel-Blöcken. | 100 % der Orte aus 7.7 (aus „Alle“) | | offen |
| K-08.2 | […] Lage und Maße stimmen auf ±2 cm mit dem Kanon überein. | Werkzeug fehlt: Kanon-Abgleich der Orte (§8). Vorgesehen: Lage und Maße aus dem Kanon-Raumstand gegen die Hüllquader des Raummodells, Abweichung in cm. Bis der Raumstand vorliegt: vorläufig nach dem Quellmaterial, gekennzeichnet (§10). | ±2 cm (Wortlaut) | | offen |
| K-08.3 | Die Detail-Checkliste aus 7.7 ist je Raum vollständig. | Bildschirmfoto je Punkt: Detail-Checkliste aus 7.7 (11 Punkte) je Raum abhaken. Protokoll: Tabelle Raum mal 11 Punkte, ja oder nein. | 100 % der 11 Punkte je Raum (aus „vollständig“) | | offen |
| K-08.4 | Die Detailprüfung findet keine Fläche über 0,25 m² ohne Farb- oder Formvariation. | Werkzeug fehlt: Detailprüfung (§8, Farb- und Formvariation je Fläche). Vorgesehen: Flächen je Raum aus dem Modell, Flächen über 0,25 m² ausfiltern, je Fläche Farb- und Formvariation messen. Protokoll: Anzahl Flächen über 0,25 m² ohne Variation. | 0 Flächen über 0,25 m² (Wortlaut) ohne Variation (aus „keine“); Mindestvariation: siehe K0-Festlegung | | offen |
| K-08.5 | Nahaufnahmen bei vierfacher Vergrößerung zeigen in jedem Raum noch Struktur, geprüft vom Sichtprüfer. | Bildschirmfoto: Nahaufnahme je Raum bei vierfacher Vergrößerung (Bezug siehe OFFENE FRAGEN). Sichtprüfer-Bewertung auf sichtbare Struktur. Protokoll je Raum: ja oder nein. | vierfache Vergrößerung (Wortlaut); 100 % der Räume (aus „jedem“) | | offen |
| K-08.6 | Alle Indizien des Kanons liegen als Modelle in Indiz-Blockgröße vor. | Werkzeug fehlt: Kanon-Abgleich (§8). Protokoll: Kanon-Indizienliste gegen die Modelle; je Indiz ja oder nein und Blockgröße aus dem Rezept. | 100 % der Kanon-Indizien (aus „Alle“); Indiz-Blockgröße laut Kanon, Startwert §0 Schlüsselindizien 0,5 cm | | offen |

## K-09 · Materialien und Stimmung · Tor K4

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-09.1 | Die Materialbibliothek aus 7.6 ist vollständig, mit allen Eigenschaften je Material. | Protokoll: Abgleich der Materialbibliothek (14 Materialien laut 7.6) mit den Eigenschaften je Material laut 7.6; Tabelle Material mal Eigenschaft, ja oder nein. | 100 % der 14 Materialien (aus „vollständig“) mit allen Eigenschaften; Anzahl Eigenschaften: siehe OFFENE FRAGEN (7 laut 7.6, 8 laut §6) | | offen |
| K-09.2 | Die mittlere Helligkeit im Spielbild liegt in jedem Raum zwischen 20 und 25 %. | Bildschirmfoto: Spielbild je Raum (messen.mjs-Fotos oder Playwright). Werkzeug fehlt: Helligkeitsmessung als mittlere Helligkeit in Prozent über alle Pixel des Spielbilds; Definition siehe OFFENE FRAGEN. Protokoll je Raum. | zwischen 20 und 25 % (Wortlaut) in jedem Raum; Helligkeitsmaß: siehe OFFENE FRAGEN | | offen |
| K-09.3 | Lichtpunkte flackern. | Werkzeug fehlt: Flackernachweis. Vorgesehen: Bildfolge über zwei Sekunden auf die warmen Lichtpunkte (RGB 255, 147, 41 laut 7.7), Helligkeit je Bild als Zeitreihe; Protokoll: Varianz und Sinus-Anpassung. | siehe K0-Festlegung (Flackerkennwert; 7.7: „leichtes Sinus-Flackern“) | | offen |
| K-09.4 | Nebel des Krieges und Aufblenden entsprechen 7.7, belegt durch Messung und Bildfolgen. | Test: Ereignis „Tür auf“ (7.8) auslösen. Bildfolge beim Öffnen; Zeit bis volle Helligkeit in Sekunden messen; Schwärze außerhalb des Sichtfelds per Pixelwert prüfen. Protokoll: Schwärze in Prozent, Aufblendzeit in Sekunden. | Schwärze außerhalb des Sichtfelds 100 % (7.7); Aufblenden radial in 0,4 s (7.7) | | offen |

## K-10 · Verzahnung · Tor K5

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-10.1 | Der Schlosskeller entsteht vollständig über Szenenvertrag und Kanon-Adapter. | Test: flutter test, Integrationstest: Schlosskeller nur über Szenenvertrag und Kanon-Adapter laden. Suche im Code nach Szenenaufbau außerhalb von Vertrag und Adapter; Protokoll mit Trefferzahl. | 100 % (aus „vollständig“) | | offen |
| K-10.2 | Jede Story-Physik aus 7.8 ist ausgelöst und belegt, je Pfad, wo der Kanon es verlangt. | Test: je Story-Physik-Auslöser (Kerzenständer, Vitrine, Turmtür, Kamin) ein Testlauf je Pfad, den der Kanon verlangt; Ereignis ausgelöst ja oder nein; Bildfolge als Beleg. | 100 % der Story-Physik aus 7.8 (aus „Jede“); je Pfad laut Kanon (4 Täter-Pfade, §1) | | offen |
| K-10.3 | Die Rückblende läuft in jedem Pfad mit Physik. | Test: Rückblende je Pfad starten (4 Pfade), Zahl bewegter Körper je Bild im Protokoll. Protokoll je Pfad: ja oder nein. | 100 % der 4 Pfade (aus „jedem Pfad“; §1) | | offen |
| K-10.4 | Bei jeder Wiedergabe stehen alle Körper und Partikel in jedem Bild an derselben Stelle. | Werkzeug fehlt: Determinismus-Test (§8). Vorgesehen: Rückblende mehrfach abspielen, je Bild die Positionen aller Körper und Partikel vergleichen. Protokoll: Zahl abweichender Bilder je Wiedergabe (Ziel null). | 0 Abweichungen je Bild (aus „derselben Stelle“); Anzahl Wiedergaben: siehe K0-Festlegung | | offen |
| K-10.5 | Indizien liegen je Pfad an ihren Kanon-Orten. | Werkzeug fehlt: Kanon-Abgleich (§8). Vorgesehen: Indizienpositionen je Pfad aus dem Szenenvertrag gegen die Kanon-Orte. Protokoll je Pfad und Indiz: ja oder nein. | 0 Abweichungen von den Kanon-Orten (Wortlaut „an ihren Kanon-Orten“) | | offen |
| K-10.6 | Taschenlampe und Seifenblasen funktionieren wie in 7.8. | Test und Bildschirmfoto: Taschenlampe einschalten, Schatten des Kegels auf dem Foto prüfen. Pfeife auslösen, Bildfolge: Seifenblase steigt auf und platzt an einer Wand. Protokoll: ja oder nein je Funktion. | Soll laut 7.8: Taschenlampenkegel wirft Schatten; Seifenblasen steigen auf und platzen an Wänden | | offen |

## K-11 · Bestehende Designs verschärft · Tor K5

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-11.1 | Die Bestandsliste aller Bilder ist vollständig; | Protokoll: Bestandsliste aller Bilder und Grafiken aus der Messbasis (§8) gegen die Dateien im Repo (Suche in den Asset-Ordnern); Zählung und fehlende Einträge. | 100 % der Bilder und Grafiken (aus „aller“) | | offen |
| K-11.2 | […] jedes hat einen Nachfolger aus Pixel-Blöcken oder eine Begründung. | Protokoll: Zuordnungstabelle Bild zu Nachfolger-Rezept oder Begründung; Zeilen ohne Eintrag zählen als Fehler. | 100 % der Bilder (aus „jedes“): Nachfolger aus Pixel-Blöcken oder Begründung | | offen |
| K-11.3 | Für jeden Raum und jede Figur liegt ein Vorher-nachher-Bildpaar vor. | Bildschirmfoto: Vorher-nachher-Paar je Raum (7.7) und je Figur (K-07.1), Ablage in der Galerie. Protokoll: Zahl der Paare je Raum und Figur. | 100 % der Räume (7.7) und Figuren (aus „jeden“ und „jede“) | | offen |
| K-11.4 | Der Sichtprüfer bewertet jedes Paar; | Sichtprüfer-Bewertung: Protokoll mit einer Zeile je Paar, Bewertung abgegeben ja oder nein. | 100 % der Paare (aus „jedes“) | | offen |
| K-11.5 | […] kein Nachfolger ist schlechter lesbar als das Original. | Sichtprüfer-Bewertung je Paar: schlechter lesbar ja oder nein. Protokoll: Anzahl Paare mit ja. Bewertungsskala: siehe OFFENE FRAGEN. | 0 schlechter lesbare Nachfolger (aus „kein“) | | offen |

## K-12 · Geräte und Geräteklassen · Tor K6

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-12.1 | Automatisierte Durchläufe auf iOS und Android je Geräteklasse, hochkant und quer, zeigen keine Darstellungs- oder Bedienfehler. Sie laufen auf angeschlossenen Geräten oder in der Testumgebung des Projekts. | Grenze der Umgebung (keine Handys, kein Android-SDK, kein Xcode). Ersatz: Web-Build in Headless-Chromium, Schema messen.mjs je Geräteklasse (CPU 1× / 4× / 6×), Viewport hochkant und quer; Protokoll: Darstellungs- und Bedienfehler (Konsolen- und Seitenfehler). Werkzeug fehlt: messen.mjs kennt nur die Ausrichtung quer mit 1280 × 720. Testumgebung des Projekts: siehe OFFENE FRAGEN. Testplan echte Geräte (FÜR DEN NUTZER) für iOS und Android. | 0 Darstellungs- und Bedienfehler (aus „keine“); Matrix 2 Plattformen × 3 Geräteklassen × 2 Ausrichtungen = 12 Läufe | | offen |
| K-12.2 | Die automatische Anpassung wählt die passende Klasse und senkt bei Bedarf Blockgröße, Licht und Partikel. | Grenze der Umgebung. Test: flutter test mit simulierten Leistungswerten je Klasse; Protokoll: gewählte Klasse und gesenkte Parameter. Testplan echte Geräte (FÜR DEN NUTZER): Auswahl auf dem Gerät. | siehe K0-Festlegung (Auswahlregel und Senkungsparameter je Klasse, aus der Budgettabelle) | | offen |
| K-12.3 | Die Figuren bleiben in jeder Klasse lesbar, belegt durch Bildschirmfotos. | Bildschirmfoto: messen.mjs-Fotos je Geräteklasse; Sichtprüfer-Bewertung nach K-07.6 und K-07.7. Protokoll je Klasse: ja oder nein. Grenze der Umgebung (Chromium statt Gerätedisplay). Testplan echte Geräte (FÜR DEN NUTZER). | 100 % der Figuren in jeder Geräteklasse (aus „in jeder Klasse“) | | offen |
| K-12.4 | Mit reduzierter Bewegung gibt es keine Kameraerschütterung | Test: Einstellung „reduzierte Bewegung“ aktivieren (Name siehe OFFENE FRAGEN). Positionsprotokoll der Kamera je Bild: Versatz ohne Eingabe in Pixeln. Protokoll: größter Versatz. | 0 Kameraerschütterung (aus „keine“) | | offen |
| K-12.5 | […] und weniger Partikel. | Test: gleiche Eingabeaufzeichnung mit und ohne reduzierte Bewegung; Zählung aktiver Partikel je Bild. Protokoll: Mittelwert je Lauf. | weniger Partikel als ohne reduzierte Bewegung (Wortlaut „weniger“); Zahl: siehe K0-Festlegung (Budgettabelle) | | offen |

## K-13 · Werkzeuge und Dokumentation · Tor K6

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-13.1 | Die Modellschau zeigt jedes Modell mit Drehteller, Lichtvorlagen, Blockgrößen und Material-Ansicht. | Werkzeug fehlt: Modellschau (7.9, nur Entwicklungsbuild). Bildschirmfoto je Modell in den vier Ansichten (Drehteller, Lichtvorlagen, Blockgrößen, Material-Ansicht). Protokoll: Modelle mal 4 Ansichten, ja oder nein. | 100 % der Modelle (aus „jedes“); 4 Ansichten je Modell | | offen |
| K-13.2 | Der Bild-zu-Block-Wandler macht aus einem Bild ein bearbeitbares Startmodell. | Test: Werkzeug fehlt: Bild-zu-Block-Wandler (7.6, außerhalb der App). Eigenes Testbild (keine fremden Bilder) einlesen, Startmodell erzeugen, in der Modellschau öffnen, einen Bearbeitungsschritt speichern und neu laden. Protokoll: Startmodell vorhanden ja oder nein; Bearbeitung erhalten ja oder nein. | 1 Bild ergibt 1 bearbeitbares Startmodell (Wortlaut „ein … ein“); „bearbeitbar“: siehe K0-Festlegung | | offen |
| K-13.3 | Ein Haiku-Agent ohne Vorwissen baut nach der Anleitung „Pixel-Bausteine in einem neuen Spiel nutzen“ eine eigene Mini-Szene, belegt durch Protokoll. | Protokoll: Lauf eines Haiku-Agenten ohne Vorwissen, der nur die Anleitung „Pixel-Bausteine in einem neuen Spiel nutzen“ und die Bausteine erhält; Schritte und Ergebnis der Mini-Szene. Ausführung durch den Orchestrator (die Anleitung entsteht in K6). | 1 Haiku-Agent ohne Vorwissen; 1 eigene Mini-Szene (Wortlaut); Anleitung „Pixel-Bausteine in einem neuen Spiel nutzen“ | | offen |

## K-14 · Spiel und Bestand · Tor K7

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-14.1 | Mit der neuen Darstellung als Standard sind alle Tests der App grün, auch die Kriterien des Finalisierungs-Laufs zu Bild, Figuren, Spoiler-Schutz und Ablauf. | Test: flutter test, alle Tests der App bei eingeschalteter neuer Darstellung als Standard. Protokoll: Anzahl Tests, bestanden, fehlgeschlagen. Die Kriterien des Finalisierungs-Laufs sind Teil der Suite; ausführen, nicht ändern (§3). | 0 fehlgeschlagene Tests (aus „alle … grün“); Kriterien des Finalisierungs-Laufs: siehe dessen Stand | | offen |
| K-14.2 | Bestehende Funktionen, Daten und Speicherstände funktionieren unverändert, belegt durch Regressionstests. | Test: flutter test, Regressionstests für Funktionen und Daten. Werkzeug fehlt: Speicherstand-Test (§8, Testschreiber): Bestandsspeicherstände laden und Inhalt vergleichen. Protokoll: Abweichungen je Speicherstand. | 0 Abweichungen (aus „unverändert“) | | offen |
| K-14.3 | Die Netzwerkprüfung beim Spielen zeigt nur Verbindungen aus der Messbasis. | Werkzeug: bestand.dart --vergleiche Messbasis; keine Zeile mit Präfix „+ netzziel“. Laufzeit: messen.mjs, Feld fremdeNetzaufrufe; jeder Eintrag muss in der Netzziel-Liste der Messbasis stehen. Hinweis: messen.mjs zählt jeden Aufruf außerhalb von localhost. | 0 Verbindungen außerhalb der Messbasis (aus „nur“) | | offen |
| K-14.4 | Die Protokolle der App zeigen beim Spielen keine Fehler. | Werkzeug: messen.mjs, Feld konsolenfehler je Klasse und Ansicht. Grenze der Umgebung für die App-Protokolle auf dem Gerät. Testplan echte Geräte (FÜR DEN NUTZER): Protokollauszug vom Gerät. | 0 Konsolenfehler (aus „keine“) | | offen |
| K-14.5 | Neue Abhängigkeiten von Werkzeugen außerhalb der App stehen in einer Lizenzliste; | Protokoll: Lizenzliste (Dateiname siehe OFFENE FRAGEN) gegen neue Abhängigkeiten außerhalb der App: Werkzeuge in tool/feinkorn und dev-Abhängigkeiten laut bestand.dart (Präfix „+ dev-abhaengigkeit“). Jede neue Zeile steht in der Liste. | 100 % der neuen Abhängigkeiten außerhalb der App in der Lizenzliste (Wortlaut „stehen in einer Lizenzliste“) | | offen |
| K-14.6 | […] es gibt keine fremden Modelle, Texturen oder Marken. | Protokoll: Herkunftsliste je Modell, Textur und Marke (Quelle und Rezept). Sichtprüfer-Bewertung auf Marken und fremde Vorlagen. Werkzeug fehlt: Herkunftsliste. | 0 (aus „keine“) | | offen |

## K-15 · Geprüft und übergeben · Tor K7

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-15.1 | Die Berichte von Gegenprüfer und Bestandswächter enthalten keine offenen schweren Befunde. | Protokoll: Durchsicht der Berichte von Gegenprüfer und Bestandswächter; je Befund Schwere und Status; Anzahl offener schwerer Befunde. Ablage der Berichte: siehe OFFENE FRAGEN. | 0 offene schwere Befunde (aus „keine“) | | offen |
| K-15.2 | Abschlussbericht, Vorher-nachher-Galerie und Anleitung liegen im Repo. | Protokoll: Prüfung der drei Dateien im Repo (git ls-files auf kern-feinkorn und main), drei Treffer nötig. Dateinamen siehe OFFENE FRAGEN. | 3 von 3 Dokumenten im Repo (Aufzählung) | | offen |
| K-15.3 | FÜR DEN NUTZER enthält: einen Testplan für echte Handys: je ein älteres und ein aktuelles Gerät mit iOS und mit Android, ein Partyabend von drei Stunden mit Akku- und Wärmeprotokoll | Protokoll: Sichtprüfung des Abschnitts FÜR DEN NUTZER gegen den Wortlaut. Der Testplan ist selbst „Testplan echte Geräte (FÜR DEN NUTZER)“. Geräte-Liste, Dauer und Protokolltypen (Akku, Wärme) prüfen. | 4 Geräte (je 1 älteres und 1 aktuelles, mit iOS und mit Android); Partyabend 3 Stunden (Wortlaut) | | offen |
| K-15.4 | FÜR DEN NUTZER enthält: die Fragen, die nur Menschen beantworten: Wirken die Figuren lebendig? Machen Dreck und Physik Spaß? Wie wirkt es im Vergleich zur alten Darstellung? | Protokoll: Sichtprüfung des Abschnitts FÜR DEN NUTZER; die drei Fragen sind wortgleich vorhanden, je Frage ja oder nein. | 3 Fragen (Aufzählung) | | offen |
| K-15.5 | FÜR DEN NUTZER enthält: eine kurze Änderungsliste für die nächste Veröffentlichung in den Stores. | Protokoll: Sichtprüfung des Abschnitts FÜR DEN NUTZER auf eine Änderungsliste für die nächste Store-Veröffentlichung. | 1 Änderungsliste (Wortlaut „eine“); Umfang „kurz“: siehe K0-Festlegung | | offen |

## K-16 · Auf main · Tor K7

| Kennung | Kriterium (wörtlich) | Prüfmethode | Schwelle | Beleg | Status |
|---|---|---|---|---|---|
| K-16.1 | Die Integration begann erst nach der Freigabe aus Abschnitt 3. | Protokoll: Zeitpunkt der Freigabe (Tag schlosskeller-1.0 auf origin oder „weiter“ nach BEREIT ZUR INTEGRATION, §3) gegen den ersten Integrationscommit (git log auf kern-feinkorn und main); Eintrag im ENTSCHEIDUNGSLOG. | 0 Integrationsschritte vor der Freigabe (aus „erst nach“) | | offen |
| K-16.2 | Der Secret-Scan ist leer; | Werkzeug fehlt: Secret-Scan (§8, vor jedem Push). Protokoll: Ausgabe leer. Befehl siehe OFFENE FRAGEN. | 0 Treffer (aus „leer“) | | offen |
| K-16.3 | […] der Rohchat steht nicht im Verlauf. | Protokoll: Suche im Git-Verlauf (git log --all -p) nach Marken aus quellen/schlosskeller-teamchat.txt. Marker siehe OFFENE FRAGEN. Der Ordner quellen/ liegt im Arbeitsbaum derzeit nicht vor. | 0 Treffer (aus „nicht“) | | offen |
| K-16.4 | kern-feinkorn ist in main zusammengeführt und gepusht. | Protokoll: git fetch origin, dann git merge-base --is-ancestor kern-feinkorn origin/main, Exit 0 (zusammengeführt und auf origin). | ja (Vorfahr-Prüfung, Wortlaut „zusammengeführt und gepusht“) | | offen |
| K-16.5 | main lokal und origin/main zeigen auf denselben Commit. | Protokoll: git fetch origin, dann git rev-parse main und git rev-parse origin/main; identische Hashes. | 0 Abweichung (aus „denselben“) | | offen |
| K-16.6 | Der Stand von origin/main vor der Integration ist Vorfahr dieses Commits; es gab also keinen Force-Push. | Protokoll: git merge-base --is-ancestor Stand-vor-Integration main, Exit 0. Hash des Stands vor der Integration festhalten (siehe OFFENE FRAGEN). Der Vorfahr-Nachweis schließt einen Force-Push auf main aus. | ja (Vorfahr); Force-Pushes 0 (aus „keinen“) | | offen |
| K-16.7 | Der Tag feinkorn-1.0 liegt auf diesem Commit und ist gepusht. | Protokoll: git rev-parse feinkorn-1.0^{commit} gleich git rev-parse main; git ls-remote --tags origin feinkorn-1.0 zeigt den Tag. | 0 Abweichung zum main-Commit (aus „diesem Commit“); gepusht: ja | | offen |
| K-16.8 | Eine vorhandene CI ist auf main grün. | Protokoll: letzter CI-Lauf auf main, gh run list --branch main --limit 1, Feld conclusion. Im Repo fehlt derzeit eine CI-Konfiguration (.github/workflows auf origin/main und kern-feinkorn nicht vorhanden), siehe OFFENE FRAGEN. | letzter CI-Lauf auf main erfolgreich (Wortlaut „grün“) | | offen |

## Schwellen, die in K0 festzulegen sind

1. Budgettabelle je Geräteklasse (§7.10): sichtbare Blöcke, Blockkörper, Partikel und Lichter; Ziel-Bildrate und Rechenzeit je Bild; Arbeitsspeicher; Zuwachs der App-Größe; Ladezeit. Betrifft K-04.7, K-04.11, K-12.2, K-12.5.
2. Größenbudget (Zuwachs der App-Größe). Betrifft K-04.9.
3. Flimmerschwelle für das Schwenken. Betrifft K-03.4.
4. Physikrate, fest und unabhängig von der Bildrate (§0, §7.4). Betrifft K-05.1 bis K-05.4.
5. Wärmenormalbereich im 30-Minuten-Dauertest und Wärmeschwelle für das Herunterstufen. Betrifft K-04.5, K-04.6.
6. Zielbildzeit je Geräteklasse, abgeleitet aus der Ziel-Bildrate. Betrifft K-04.2.
7. Blockgrößen je Geräteklasse, Startwerte laut §0 (hoch 2,5 / 1 / 0,5 cm; mittel 5 / 2 / 1 cm) und Festlegung für einfach nach Messung. Betrifft K-02.1.
8. Zielgeräte und Bildschirmdichten. Betrifft K-03.3.
9. Größe der synthetischen Welt für die Durchquerungsprüfung. Betrifft K-02.3, K-02.4.
10. Ruhe-Schwelle für Partikel (wann kommt ein Partikel zur Ruhe). Betrifft K-05.6.
11. Materialwerte für den Böschungswinkel aus der Materialbibliothek (7.6). Betrifft K-05.7.
12. Liste der extremen Posen. Betrifft K-05.8.
13. Sichtbarkeitsschwelle für die Bewegung in 60 Sekunden Stillstand. Betrifft K-06.5.
14. Helligkeitsmaß und Definition des Spielbilds. Betrifft K-09.2.
15. Flackerkennwert für die Lichtpunkte („leichtes Sinus-Flackern“, 7.7). Betrifft K-09.3.
16. Mindestvariation je Fläche bei der Detailprüfung. Betrifft K-08.4.
17. Definition „grün“ für den Kanon-Abgleich und Mindestwert der Erkennbarkeit im gedimmten Licht und je Geräteklasse. Betrifft K-07.3, K-07.7.
18. Messpunkt „spielbar“ für die Ladezeit. Betrifft K-04.10.
19. Anzahl der Wiedergaben der Rückblende für den Determinismus-Test. Betrifft K-10.4.
20. Bewertungsskala für die Lesbarkeit der Nachfolger. Betrifft K-11.5.
21. Definition „bearbeitbar“ für das Startmodell. Betrifft K-13.2.
22. Auswahlregel der automatischen Anpassung und Senkungsparameter je Klasse. Betrifft K-12.2.
23. Zahl der Partikel bei reduzierter Bewegung. Betrifft K-12.5.
24. Umfang der „kurzen“ Änderungsliste. Betrifft K-15.5.
25. Mindestwerte der Sichtprüfer-Checklisten (Look, Detail, Kanon). Betrifft K-07.6, K-08.3, K-11.4.

## Offene Fragen

1. Messbasis: Dateiname und Ablage fehlen. Sie muss vor dem ersten Eingriff mit bestand.dart --schreibe und messen.mjs angelegt werden. Betrifft K-01.1 bis K-01.3, K-04.10, K-14.3.
2. Phase für die Bildrate (K-04.1): ruhig oder bewegt? Vorschlag: bewegt, der strengere Fall.
3. Zielbildzeit (K-04.2): Definition fehlt. Kandidat: Kehrwert der Ziel-Bildrate.
4. Thekensaal: Die Standardansicht von messen.mjs ist buffetsaal. Query-Parameter für den Thekensaal mit allen Figuren fehlt (K-04, K-12.3).
5. Messpunkt „spielbar“ (K-04.10): messen.mjs misst bis zur Flutter-Ansicht und zwei Bildern. Ist das der Punkt „spielbarer Schlosskeller“?
6. Universalwörter als Schwelle: Bitte bestätigen, dass keine, nicht, nichts, null, unverändert und verlustfrei als 0 gelten und alle, jede, jeder, jedes, aller und vollständig als 100 %. Die Zeilen sind so markiert.
7. Bezug der 10 % (K-02.4, K-04.8): Schwankung relativ zu welchem Wert (Mittelwert, Startwert, Minimum)? Zudem fehlt eine Zeitreihe des Speichers. Welche Größe gilt: JS-Heap oder Dart-RSS?
8. Fallformel (K-05.3): Im Text nicht genannt. Welche Formel und welcher Wert für die Fallbeschleunigung gelten?
9. Maßstab Welt zu mm (K-05.4) und Bezug der 1 mm: je Kiste oder für den Stapel?
10. Eigenschaften je Material (K-09.1): 7.6 nennt 7 Eigenschaften, §6 nennt 8 mit Reibung. Welche Liste gilt?
11. Helligkeitsmaß (K-09.2): Luminanz oder Luma, Umrechnung von sRGB, Bereich des Spielbilds ohne Oberfläche und Anzeige?
12. Anzahl der Figuren (K-07.1): Ist der Detektiv in den 20 Rollen enthalten? Dann sind es 21 Modelle, sonst 23.
13. K-07.3 und K-07.7: Ist die Erkennbarkeit Teil der 90 % (K-07.6) oder eine eigene Schwelle? Welche Lichtvorlage ist „gedimmt“?
14. Sichtprüfer-Checklisten (Look, Detail, Kanon, §4): Im Planungsordner noch nicht vorhanden. Wer legt sie fest, und in welcher Phase?
15. Grundfarben je Figur (K-07.4): Liste aus dem Kanon-Feld?
16. Bewertungsskala Lesbarkeit (K-11.5): ja oder nein, oder Stufen?
17. Zoom-Bezug (K-08.5): Vierfache Vergrößerung gegenüber welcher Ansicht?
18. Testumgebung des Projekts (K-12.1): Gibt es sie, und mit welchem Befehl? Zielgeräte-Liste für K-03.3 und K-12.1 fehlt.
19. messen.mjs kennt nur die Ausrichtung quer mit 1280 × 720 und keine Pixeldichte. Erweiterung nötig für K-03.3 und K-12.1.
20. Schalter „reduzierte Bewegung“ (K-12.4, K-12.5): Name und Ort?
21. Werkzeuge laut §8, die in den Prüfmethoden gebraucht werden und noch fehlen: Trennungsprüfung, Release-Prüfung, Blockzählung, Block-Vergleich, Flimmerprüfung, Bildfolgen und Bildschirmfoto-Serien, Physik-Messszenen (Fall, Stapel, Bruch, Staub, Sandhaufen), Determinismus-Test, Lückenprüfung, Kanon-Abgleich, Detailprüfung, Secret-Scan. Ohne §8 sind: Fußgleiten (K-06.3), Farbabgleich (K-07.4), Helligkeit und Flackern (K-09.2, K-09.3), Hintergrund-Lauf (K-04.4), Zeitreihe Heap (K-04.8), App-Größe (K-04.9), Herkunftsliste (K-14.6), Bild-zu-Block-Wandler (K-13.2), Modellschau (K-13.1). Vorschlag: Jedes Werkzeug in der Phase bauen, deren Tor das Kriterium trägt. Orchestrator bestätigt die Zuordnung.
22. Speicherstände für K-14.2: Welche Bestandsspeicherstände dienen als Vorlage?
23. Rohchat-Marker (K-16.3): Welcher Fingerabdruck aus quellen/schlosskeller-teamchat.txt wird gesucht? Der Ordner quellen/ fehlt im Arbeitsbaum.
24. CI (K-16.8): Im Repo fehlt eine CI-Konfiguration (.github/workflows auf origin/main und kern-feinkorn). Gibt es eine CI außerhalb des Repos? Falls nicht, ist das Kriterium nicht erfüllbar, und die Entscheidung liegt beim Orchestrator.
25. Ablage und Dateinamen: FÜR DEN NUTZER, ENTSCHEIDUNGSLOG, PRÜFPUNKT, STATUS, PLAN, Lizenzliste, Abschlussbericht, Vorher-nachher-Galerie, Anleitung, Berichte von Gegenprüfer und Bestandswächter. Der Master-Prompt nennt die Namen nicht.
26. Stand von origin/main vor der Integration (K-16.6): Wo wird der Hash festgehalten?
27. Secret-Scan (K-16.2): Welches Werkzeug?
28. Name und Kennung des Prüfstand-Einstiegs für die Release-Prüfung (K-01.5).
29. „Bearbeitbar“ (K-13.2) und „kurz“ (K-15.5): Definitionen fehlen.
30. Der Kanon liegt auf origin/finalisierung-schlosskeller unter krimidinner/spuk-im-gewoelbe/10_kanon/. Bestätigen, dass dieser Stand als Quelle für K-07, K-08, K-10 und K-11 gilt.

=== ENDE ABNAHME · ENTWURF K0 ===

## K0-Festlegungen (Orchestrator, verbindlich; Begründung im ENTSCHEIDUNGSLOG)
- Kanon-Quelle ist `content/party/schlosskeller/` (E-F003), nicht `krimidinner/spuk-im-gewoelbe/` (anderer Fall) – Offene Frage 30 ist damit beantwortet.
- Budgets und Herunterstufen: BUDGET.md (E-F015). Zielbildzeit = 1/Ziel-Bildrate; K-04.1 misst im bewegten Spiel (E-F018).
- Flimmerschwelle: ≤ 2 % Pixel mit Lumasprung > 10 % bei 0,5-px-Schwenk (E-F016).
- Helligkeit K-09.2: mittlere Luma Y′ (Rec. 709) der Weltpixel je Raum 0,20–0,25 (E-F018).
- Fallformel K-05.3: t = √(2h/g), g = 9,81 m/s²; Stapel K-05.4: Drift des Schwerpunkts der obersten Kiste.
- Figuren K-07: 23 Modelle (E-F017). „Gedimmtes Licht“ = Lichtvorlage Stromausfall.
- Messbasis: `planung/feinkorn/MESSBASIS.md` und `messbasis/` (bestand.txt, browser_vorschau.json, k0_darstellungswege.json).
- CI: Im Repo gibt es keine CI (kein .github/); K-16.8 gilt als erfüllt, wenn keine CI existiert („eine vorhandene CI“), Vermerk im Abschlussbericht.
