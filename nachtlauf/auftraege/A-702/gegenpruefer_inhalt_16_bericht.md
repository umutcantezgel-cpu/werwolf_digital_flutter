HEAD 388fa25

# Gegenprüfung Inhalt · Punkt 16 (Schwerpunkt Kanon-Änderung) · gegenpruefer_inhalt_16

Auftrag A-702o, Punkt 16. Unabhängige Prüfung, ohne Kenntnis anderer Berichte. Geprüfter Stand: `HEAD 388fa25` (nach Fast-Forward von d92a675 auf nachtlauf/burgstadt). Es wurden keine Daten geändert, kein Commit, kein Push, kein Build ausgeführt. Frühere Berichte in nachtlauf/auftraege/A-702/ wurden weder gelesen noch durchsucht.

## Ergebnis

- Befunde: hoch 0 · mittel 3 · gering 5
- Leitplanken: Keine harte Regel verletzt. Der Scanner (`dart run bin/leitplanken.dart --burgstadt`) meldet 0 Treffer in 119 Dateien. Die eigene Lektüre findet keine Alkohol-, Drogen-, Blut-, Hexen-, Gaststätten- oder Herkunftsmotive. Ein Klischeerisiko besteht bei der Funktionsmatrix FM-1 (M3) und bei Familienmerkmalen (G1, G5). Das wird als Befund geführt, nicht als Verletzung.
- Kanontreu: nein. Die in dieser Runde geänderte O-Zeile K-002 (über der Burg klarer Himmel, Nebel nur im Tal und auf dem unteren Burgweg) wird von Spiel- und Stadttexten widersprochen (M1).
- Plagiatsfrei: Keine Übereinstimmung mit bekannten Figuren, Titeln oder Zitaten gefunden.

## Prüfumfang und Methode

- Kanon-Diff `git diff 659d3ed HEAD -- krimidinner/spuk-im-gewoelbe/10_kanon/K*.md`: 22 Dateien, 1175 Diff-Zeilen, vollständig gelesen. Maßstab sind die [O]-Zeilen, [L]/[G] nur für Widersprüche.
- `nachtlauf/kanon/ANPASSUNG.md`: vollständig gelesen (160 Zeilen). Begriffsersetzungen, Orts- und Stadt-Hinweise, Familienfelder, LISTE-ZEITEN, LISTE-ORTE.
- `nachtlauf/ENTSCHEIDUNGSLOG.md`: E23, E27, E29, E31, E33, E34, E35, E37, E38, E39, E40, E41 und E42 gelesen (Zeilen 147–429).
- Stadtdaten (`packages/burgstadt_core/data`): `stadt/bewohner.json` mit allen 44 Startzeiten, Volltextsuche und Lektüre der relevanten Pläne (Teestube, Wärter, Uhrturm, Rathaus, Nebel). `stadt/haeuser.json` per Suche und Lektüre der Stellen zu Pension, Kirchenburg und Stadtmuseum. `innenraeume/*.json` und `rollen/faehigkeiten.json` per Suche und Stichprobe.
- Spieltexte: `packages/burgstadt_spiel/data/texte/erzaehler.json` vollständig gelesen. `tutorial.json` per Suche.
- Figuren: `packages/pixel_engine/data/figuren/rollen.json` (R01–R04 gelesen), `karten.json` (Farbrampen), `bewohner.json` (Rampen). `teile_*.json` per Suche.
- Werkzeug: `dart pub get --offline` und der Leitplanken-Scanner, Dart aus `/opt/flutter/bin`. Ergebnis: 119 Dateien, 0 Treffer, Exit 0.

Einschränkung: Abnahmepunkt 10 (vollständige Lektüre aller genannten Dateien) ist nicht vollständig erfüllt. `innenraeume/*.json`, `faehigkeiten.json`, `haeuser.json`, `tutorial.json` und `teile_*.json` wurden gezielt durchsucht und stichprobenartig gelesen, nicht vollständig. Die 44 Nachtpläne wurden auf Startzeit, Burgbezug, Strom, Nebel und Täterinnen-Hinweise durchsucht, die zentralen Pläne gelesen, nicht jeder Eintrag einzeln. `GESAMT-KANON.md` ist eine Sammeldatei und nicht Teil des Prüfmaßstabs; sie wurde nicht geprüft.

## Befunde

### M1 · mittel · Nebel in der Oberstadt widerspricht K-002 (Kanon v1.0)

- Kanon, geändert in dieser Runde: `krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md`, `@K-002 [O]`. Zitat: „Über der Burg ist der Himmel klar … Im Tal um Silberhau und auf dem unteren Burgweg liegt dichter Eisnebel (Inversionswetterlage)“.
- Widerspruch im Spiel:
  - `packages/burgstadt_spiel/data/texte/erzaehler.json`, `/orte/hof[1]` (Burghof): „Nebel über den Mauern“.
  - Ebd., `/laden[8]`: „Draußen steht der Nebel dicht“.
  - Ebd., `/orte/stadt[0]`: „Nur der Mond ist da“. Ebd., `/orte/ORT-12[1]` (Kirchenburg): „Alte Grabsteine im Mondlicht“.
- Widerspruch in Stadt-Hinweisen und -Daten:
  - `nachtlauf/kanon/ANPASSUNG.md`, `@H-S24 [O]` (Kirchenburg, Phase 2): „Bei Eisnebel hältst du dich besser am Geländer fest“. Ebenso `packages/burgstadt_core/data/stadt/haeuser.json` (Kirchenburg, „bei Eisnebel“).
  - `packages/burgstadt_core/data/stadt/bewohner.json`: 19 Wetter-Nebel-Stellen in der Oberstadt, zum Beispiel B08 (03:30–05:30): „der Nebel ist so dicht, dass er nur die Lampe des Nachbarn sieht“, B09 (00:30–01:10): „hört im Nebel ein Bellen vom Untertor her“, sowie ein Friedhof „im Nebel“ (02:00–03:30). Der Nebelriese ist nicht mitgezählt.
- Regel: Kanontreu. Die Oberstadt liegt nach K-001 am höchsten Punkt, also nicht im Talnebel.
- Vorschlag: Der Kanon ist verbindlich. Spiel- und Stadttexte an K-002 anpassen, Nebel nur im Tal und auf dem unteren Burgweg; H-S24 und die Mondlicht-Zeilen angleichen. Soll Nebel in der Oberstadt bleiben, muss K-002 durch die Kanon-Autoren geändert werden.

### M2 · mittel · Teestube „Zur Laterne“ in Phase 2 offen, Inhaberin schläft bis 02:50

- Stelle: `nachtlauf/kanon/ANPASSUNG.md`, `@H-S13 [O]` (Quelle ORT-07, Phase 2): „Der Tee dampft, und an jedem Tisch geht es nur um den Stromausfall.“ Ebenso `packages/burgstadt_spiel/data/texte/erzaehler.json`, `/orte/ORT-07[0]`: „Warmer Tee, Honigkuchen und Kerzen auf jedem Tisch.“
- Gegenstück: `packages/burgstadt_core/data/stadt/bewohner.json`, B07 (Inhaberin der Teestube): 01:30–02:50 „schläft“, 02:50–03:20 auf dem Marktplatz, 03:20–05:30 „Sie öffnet die Teestube“.
- Phase 2 läuft von 01:30 bis 03:00 (STADT-05). Die Station ist in Phase 2 besuchbar, die Teestube aber geschlossen.
- Regel: E27 M3 hat die Nachtpläne ausdrücklich auf die Stationshinweise der Phasen abgestimmt. Für die Teestube ist das nicht umgesetzt. Keine Kanon-Zeile betroffen, es ist ein Stadt-internes Konsistenzproblem.
- Vorschlag: H-S13 nach Phase 3 verschieben, dort passt H-S14. Den Ortstext für Phase 1–2 als geschlossene Teestube formulieren (Laterne dunkel, keine Gäste, kein Tee).

### M3 · mittel · Funktionsmatrix FM-1: Begründung in E42 trägt nicht, Klischeerisiko

- Stelle: `krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md`, `@FM-1 [L]`: „bosnisch – Hauptverdächtiger ohne Vergehen (R01); kurdisch – Hauptzeugin (R02) … Begründung: Die Mehrheitsgruppe trägt beide belasteten Funktionen mit Schuld, damit keine Minderheitsgruppe mit Schuld oder Betrug verbunden wird.“
- Abwägung, die hier widersprochen wird: `nachtlauf/ENTSCHEIDUNGSLOG.md`, E42, „Abgewogen, bleibt“, FM-1: „keine andere Gruppe trägt eine belastete Funktion … Das ist eine Vorsichtsmaßnahme gegen Klischees und kein Klischee.“
- Neuer Grund gegen die Abwägung:
  1. Die Begründung widerspricht der eigenen Matrix. R01 ist Hauptverdächtiger (`@R01-PLOT`), R02 trägt „scheinbaren Verdacht“ (`@R02-PLOT`). Beide Figuren mit nichtdeutschen Wurzeln tragen in Phase 1 und 2 den Verdacht.
  2. „Keine Minderheitsgruppe mit Schuld oder Betrug“ widerspricht dem Kanon. R02 hat den Hauptschalter selbst umgelegt und lügt über den Streich (`@R02-GEHEIM`, `@R02-LÜGE`). R01 hat Code und Lampe für den Streich gegeben und ist für die zerstörte Hauptsicherung mitverantwortlich (`@R01-GEHEIM`).
  3. Die Matrix koppelt Herkunft an Verdachts-Funktionen. Das ist das Muster, das E38 als „Herkunft → Folklore“ beanstandet hat, jetzt auf Funktionsebene. Im Spiel wird Herkunft nicht als Indiz verwendet, das Klischeerisiko bleibt aber bestehen.
- Vorschlag: FM-1 nach Rollen-IDs führen, wie E42 selbst als Anregung notiert. Begründung in FM-1 und E42 korrigieren. Den Erstverdacht bei R01 als bewusste Designentscheidung mit Gegenprobe dokumentieren.

### G1 · gering · Großmutter-Lenkung bleibt in zwei nichtdeutschen Familien (E39 B-08)

- Stelle: `nachtlauf/kanon/ANPASSUNG.md`, `@R05-STAMM [O]`: „Die Großmutter Halina wohnt mit im Haus; sonntags lösen die drei Frauen am Küchentisch das große Kreuzworträtsel …“. `@R18-STAMM [O]`: „Die Großmutter ruft jeden Sonntag an, lässt sich Elifs Woche wie einen Fall vortragen und spricht am Ende ihr Urteil …“.
- Regel: Klischee-Leitplanke. E39 B-08 begründet „R05 bleibt, weil ein einzelner Fall kein Muster ist“. Neuer Grund: R18 behält die Großmutter als Familienrichterin, die Familie lenkt. Es sind also zwei Familien, nicht eine.
- Vorschlag: Den Urteils-Satz bei R18 streichen oder auf „ruft an“ begrenzen. R05 wie R13 behandeln, die Großmutter wohnt zwei Straßen weiter.

### G2 · gering · Wärter spricht von Ersatzsicherungen im verschlossenen Torhaus

- Stelle: `packages/burgstadt_core/data/stadt/bewohner.json`, B06 (Wärter im Stromhaus), Satz: „Die Ersatzsicherungen aus dem Torhaus passen nicht, das habe ich selbst probiert.“
- Gegenstück: K1, `@PF-3 [L]`: „Festnetz und Ersatzsicherungen liegen im verschlossenen Torhaus … das Tor ist verschlossen“. STADT-03: Das Burgtor öffnet sich erst zu Beginn von Phase 2.
- Vorschlag: „… sagt der Burgwart“ schreiben oder den Satz auf die Zeit nach Phase 2 beschränken.

### G3 · gering · Anrede in R02-Wissen

- `krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-KERN.md`, Zeile 19 (R02-WISSEN [G], 23:58): „vor Schreck fällt dir das Handy aus der Hand …“. Rojda ist dritte Person, die übrige Zeile sagt „ihr“.
- Vorschlag: „ihr“.

### G4 · gering · Grammatik in G3-23 (Antwort von Jonas)

- `krimidinner/spuk-im-gewoelbe/10_kanon/K4-GESPRAECHE-P3.md`, Zeile 16: „Zurückgeben hab ich sie ihn nicht sehen.“
- Vorschlag: „Zurückgeben hab ich ihn nicht gesehen.“

### G5 · gering · Familienmerkmal Kaffee bei R12 (E38-Muster)

- Stelle: `nachtlauf/kanon/ANPASSUNG.md`, `@R12-STAMM [O]` (bosnisch): „Sonntags gibt es bei den Eltern Kaffee und eine lange Diskussion darüber, wer ihn am besten kocht.“
- Regel: E38 führt Džezva (bosnischer Kaffee) als beanstandetes Muster. Bei R01 wurde ein vergleichbares Ritual (Pita) entfernt, bei R12 bleibt es. Das ist inkonsistent.
- Vorschlag: „… Kuchen und eine lange Diskussion darüber, wer ihn am besten backt“, also ohne Speise als Herkunftsmarker.

## Geprüft ohne Befund

- Kanon-Änderungen gegen den Spielstand: LISTE-ZEITEN. Uhrturm schlägt 03:00 (B03, B07). Ofen um 03:00, Bäckerin ab 02:00 in der Backstube (B03). Tore um 22:00 (STADT-01). Phasenstart 00:30 und Auftrag des Burgwarts um 00:25 (OA-29). Alle 44 Nachtpläne beginnen um 00:30 oder später. Kein Burgbezug in den Nachtplänen (Burgtor, Wehrgang, Turm, Burghof).
- Pension und Wäschezeichen (E42): `haeuser.json` nennt den blauen Stempel. „Schartenfels 7“ erscheint nur als Burgwäsche.
- Begriffsersetzungen (ERSETZE-01 bis -18): Keine Reste von „Osterode“, „Harz“, „Silberhauer“ oder „Brockengespenst“ in Spiel-, Stadt- und Figurendaten. „Naturpark“, „Bergland“ und „Silberbergbau“ sind angekommen. „bewusstlos“ erscheint nur als „benommen“.
- Stadt-Hinweise H-S/HW-S: Alle Einstufungen sind Farbe, entlastend oder bestätigend. „Stützt“ ist immer „–“.
- Stromausfall: Keine Nachtplan-Angabe setzt funktionierenden Strom voraus (Radio, Telefon, Kühlschrank).
- R03 und R04 gegen `rollen.json` und `karten.json`: R03 hat eine dunkelgrüne Strickjacke mit Zopfmuster (Rampe 5), weiße Bluse, Jeans, Wanderstiefel, Haarspange, Sommersprossen. Das Notizbuch ist entfernt (LF-R03). R04 hat einen olivgrünen Pullover (Rampe 5), kariertes Hemd, Jeans, Wanderstiefel und Armbanduhr. Grün (Rampe 5) kommt nur bei R03 und R04 vor. `bewohner.json` nutzt keine grüne Rampe.
- Täterinnen-Hinweise in den Stadtdaten: Keine Treffer für Strickjacke, Stollen, Wanderstiefel, Geisterbahn, Verlaufen, Angst im Dunkeln, Taler oder Laken als Merkmal der Täterin. Der B09-Satz zum Hund wurde bereits in E35 korrigiert.
- Verletzungen: nur „Beule“, „benommen“ und Kühlpack. Kein Blut.
- Alkohol, Drogen, Gaststätten: keine Treffer. Der Punsch ist ausdrücklich alkoholfrei (`erzaehler.json` `/laden[10]`, `burg.dart`).
- Plagiat: Stichprobe bekannter Figuren, Titel und Zitate (u. a. Dracula, Harry Potter, Sherlock, Herr der Ringe, Asterix, Pumuckl, Lassie, Nosferatu) ohne Treffer. „Geisterstunde“ ist als Titel des Tracks ein gewöhnliches Wort.

## Bereits abgewogen, nicht als Befund gezählt

- E42: „00:01 … kommt zu sich“ (LISTE-ZEITEN) gegen Z-0000e (00:00:50). Rundung, im Log notiert.
- E27 M5 und D3-3: „Der Abdruck stammt von Merle“ in Phase 3. Spur des Falls.
- E27 H1: Fähigkeit von R03 nur für R03 sichtbar.
- E23 und E29: „bewusstlos“ durch „benommen“ ersetzt (ERSETZE-17).
- E38 und E39: Familienfelder außer den genannten Stellen.

Leitplanken eingehalten: ja · Kanontreu: nein · Plagiatsfrei: ja
