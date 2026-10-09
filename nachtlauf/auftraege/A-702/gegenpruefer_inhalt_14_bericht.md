HEAD 72df36b

# Gegenprüfung Inhalt · Auftrag A-702n · Prüfer gegenpruefer_inhalt_14

Schwerpunkt: Punkt 15 (Kanon-Änderung v1.0, Diff 659d3ed..HEAD und Overlay). Unabhängige Prüfung; kein anderer Prüfbericht gelesen.

## Ergebnis

- Leitplanken eingehalten: ja
- Kanontreu: nein (Befund 1)
- Plagiatsfrei: ja
- Befunde: hoch 1 · mittel 2 · gering 5
- Z-12 (E26) ist mit diesem Urteil nicht erfüllt, denn gezählt wird nur „ja · ja · ja“.

## Stand und Git (Nutzerwunsch: alles auf main)

- Schritt 0 ausgeführt: `git merge --ff-only nachtlauf/burgstadt` im Worktree, Fast-Forward d92a675 → 72df36b. HEAD ist 72df36b.
- origin/main steht auf d92a675 und ist Vorfahr von nachtlauf/burgstadt (72df36b). Die Strecke umfasst 95 Commits; ein Push `nachtlauf/burgstadt:main` wäre ein reiner Fast-Forward.
- Lokal liegt keine Arbeit außerhalb von origin/main und origin/nachtlauf/burgstadt. `rev-list --branches` gegen beide Refs ergibt 0 Commits. Der Stash ist leer.
- Lokales main liegt 13 Commits hinter origin/main und hat keine eigenen Commits. Es ist nicht ausgecheckt.
- Nicht geprüft: nicht committete Änderungen in der Hauptarbeitskopie und in den anderen Worktrees (Worktree-Isolation). Dieser Worktree ist sauber.
- Ein Push auf main ist nach Z-13 und N-01 erst nach der Abnahme zulässig. Die Abnahme ist mit Befund 1 offen. Gepusht und committet wurde nichts. Befehl, wenn freigegeben: `git push origin nachtlauf/burgstadt:main`, danach `git branch -f main origin/main`. Kein Force nötig.

## Prüfumfang

- Auftrag A-702n vollständig gelesen; ENTSCHEIDUNGSLOG E23–E41 gelesen (Punkt 9a).
- Kanon-Diff 659d3ed..HEAD für K*.md: 22 Dateien, 154 Hunks. Geändert: 29 [O]-Zeilen (+/−), 75 [G]-Zeilen (+/−), 58 [L]-Zeilen (+/−). Alle geänderten [O]-Zeilen einzeln gelesen; [G] und [L] auf Widersprüche gesichtet, überwiegend in gekürzter Fassung, Zeit- und Herkunftsaussagen in voller Länge.
- nachtlauf/kanon/ANPASSUNG.md vollständig gelesen.
- packages/pixel_engine/data/figuren/rollen.json (R03, R04) gegen K2-STAMM-Kleidung und die LF-Anker in K9.
- Stichprobe Spieltexte und Daten: erzaehler.json, tutorial.json, haeuser.json, bewohner.json, faehigkeiten.json.
- Scanner `dart run bin/leitplanken.dart --burgstadt` mit dem Dart-SDK 3.13.5 aus /opt/flutter (dart war nicht im PATH; `pub get` nicht nötig): 119 Dateien, 0 Treffer, 0 Fehler, 0 Warnungen.

## Befunde

### 1 · hoch · Herkunft des Gespensterlakens widerspricht Kanon v1.0

- Stelle: nachtlauf/kanon/ANPASSUNG.md, HW-S05 [L]: „Das Gespensterlaken stammt aus der Pension; das Wäschezeichen auf dem Stofffetzen bestätigt es.“ HW-S09 [L]: „das Gespensterlaken stammt aus der Pension (ORT-05, Strang c).“ H-S05 [O] (Station ORT-03, Phase 2): „Das Zeichen gehört zur Pensionswäsche.“ Außerdem packages/burgstadt_core/data/stadt/haeuser.json, Zeile 364 (Pension): „die Wäsche trägt das Zeichen Schartenfels 7“.
- Kanon: K1-GRUNDWAHRHEIT.md, Z-2140 [L]: R02 nimmt um 21:40 „ein ausgemustertes Burglaken mit dem roten Wäschezeichen „Schartenfels 7“ aus dem Wäschekorb“ auf der Hofebene. K2-ROLLEN-KERN.md, R02-WISSEN [G], nennt dieselbe Herkunft. K1, BS-02 [L], verweist bei der scheinbaren Deutung auf die Burgwäsche (Z-2140). Die Pension kommt im Kanon nicht vor.
- Regel: Der Kanon v1.0 ist verbindlich; Overlay-Wahrheiten dürfen ihm nicht widersprechen. Die Einstufung „bestätigend“ setzt voraus, dass der Hinweis den Kanon bestätigt (ANPASSUNG, Kopf).
- Wirkung: Dasselbe Beweisstück hat in der Lösung zwei Herkünfte. Die öffentliche Hinweiskarte H-S05 bestätigt die Pensionsherkunft, obwohl R02 selbst die Burgwäsche kennt.
- Vorschlag: HW-S05 und HW-S09 auf „Farbe“ ohne Herkunftsaussage setzen. In H-S05 und in haeuser.json das Zeichen „Schartenfels 7“ für die Pension streichen, zum Beispiel nur die Zimmernummer nennen. Danach Kanontreu neu prüfen.

### 2 · mittel · LISTE-ZEITEN ist lückenhaft gegenüber dem Schlusssatz von v1.0

- Stelle: K1-GRUNDWAHRHEIT.md, LISTE-ZEITEN [O] mit dem Satz „Andere Uhrzeiten nennen nur Rollenkarten, Hinweise und Beweisstücke.“ ANPASSUNG.md, LISTE-ZEITEN-Ergänzung; STADT-01 [O] (22:00); STADT-05 [O] (00:25, 01:30, 03:00, 04:30).
- Befund: Öffentliche OA-Datensätze mit Zeitangabe stehen außerhalb der Liste. In keiner Liste: OA-01 16:30, OA-02 17:35, OA-04 19:00, OA-06 21:00, OA-09 22:05. Nur über den Bereich „ab 00:05 … bis 00:30“ gedeckt: OA-24 00:06, OA-25 00:07, OA-26 00:12, OA-27 00:15, OA-28 00:20. Die Overlay-Ergänzung erfasst 22:00 und die Uhrturm-Zeiten nur als Tatsachen (STADT-01/05), nicht als Aussagen. E29 B3, E34 B-1 und E41 haben die Stadtzeiten entschieden. Neu ist der Schlusssatz von v1.0. E41 hat nur das Feld LISTE-ZEITEN gegen die Kanonänderung geprüft, nicht die OA-Zeiten.
- Regel: FORMAT.md: „Was nicht in einer Liste steht, darf in Spieltexten nicht als … Zeitpunkt auftauchen.“
- Vorschlag: LISTE-ZEITEN im Overlay um die OA-Zeiten ergänzen oder den Schlusssatz in einer Kanon-Ergänzung (v1.1, mit Protokoll) präzisieren.

### 3 · mittel · Funktionsmatrix FM-1 ordnet Herkunft Tatfunktionen zu (neu in v1.0)

- Stelle: K1-GRUNDWAHRHEIT.md, FM-1 [L]: „deutsch – Täterin (R03) und Hauptverdächtiger mit echtem Vergehen (R04); bosnisch – Hauptverdächtiger ohne Vergehen (R01); kurdisch – Hauptzeugin (R02); polnisch und türkisch – keine belastete Funktion …“.
- Regel: Leitplanke „Herkunft ist nie Motiv, Indiz oder Pointe“. E38 B1 hat die Zuordnung „Herkunft → Muster“ bei den Familienfeldern beanstandet; FM-1 wendet dasselbe Ordnungsprinzip auf die Tatfunktionen an.
- Einordnung: Nicht spielsichtbar ([L]). Im Spieltext ist Herkunft kein Indiz: Der Verdacht gegen R01 stützt sich auf Lampe und Code-Zettel. Deshalb kein Verstoß im Spieltext, aber das Ordnungsprinzip widerspricht dem Geist der Leitplanke.
- Vorschlag: Matrix nach Rollen-IDs ordnen und die Herkunftsangaben streichen.

### 4 · gering · Silberhau fehlt in LISTE-ORTE

- Stellen: ANPASSUNG K-001 [O] (Bergstädtchen Silberhau), K1 K-002 [O] (neu: „Im Tal um Silberhau …“), ANPASSUNG STADT-04 [O] und H-S12 [O] (Stadtwerk aus Silberhau). LISTE-ORTE enthält den Ort nicht.
- Regel: FORMAT.md: „Was nicht in einer Liste steht, darf … nicht als Ort … auftauchen.“
- Vorschlag: „Silberhau (Bergstädtchen im Tal, nur Farbe)“ in LISTE-ORTE aufnehmen.

### 5 · gering · Auffindezeit des Burgwarts

- LISTE-ZEITEN: „00:01 der Burgwart wird in der Speisekammer gefunden und kommt zu sich.“ BS-01 [L] und K2-ROLLEN-KERN [G]: Adnan und das Geburtstagskind kommen um 00:00:25 herein. PF-3 [L]: zu sich um 00:00:50.
- Vorschlag: „kurz nach Mitternacht“ im öffentlichen Eintrag.

### 6 · gering · Leihgabe des Talers ist neue Tatsache

- ANPASSUNG H-S03 [O] und HW-S03 [L]: „Leihgabe des Stadtmuseums“, eingestuft als „bestätigend (K-008)“. K-008 sagt nichts zu einer Leihgabe; K-001 gibt Burg und Heimatmuseum der Stiftung.
- Vorschlag: Einstufung „Farbe“, oder die Leihgabe als Kanon-Fakt ergänzen.

### 7 · gering · Overlay ändert den Wortlaut von OA-27

- Kanon OA-27 [O] (00:15): „den Burgweg rauf … Bis zum Nachtisch.“ ANPASSUNG OA-27: „die Serpentinen rauf … Bis zum Morgengrauen.“ Kein Faktenwiderspruch.
- Vorschlag: Begründung in ANPASSUNG ergänzen oder den Kanonwortlaut zurückholen.

### 8 · gering · R04-Steckbrief ohne Vorbehalt

- K2-ROLLEN-KERN, R04-STAMM [O]: „Beruf: Vertriebler für Medizintechnik“, vorher mit „(so erzählt er es)“. R04-LÜGE [G] führt den Beruf als Fassade. Kein Widerspruch zu den Gegenbeweisen, aber der Steckbrief liest sich nun als Tatsache. Hinweis, kein zwingender Änderungsbedarf.

## Geprüft ohne Befund

- Zeitstrang: 23:52 (Merle „acht vor zwölf“ aufs Klo, Adnan reißt die Turmtür auf), 23:53 (Jonas), 23:54 (Box, Wehrgang), 23:56 (Verbunden), 23:58 (Knall, Schlag 23:58:22), 00:00:25 (Eintritt), 23:59:40 (Merle am Kamin). Die geänderten Alibis, Meldekarten und Hinweise (H-02, H-06, H-11, H-14, H-17, H-49, H-50) stimmen mit den Wissen-Datensätzen überein. Die Eisentür quietscht beim Öffnen: Eintritt 23:58:05 und Austritt 23:58:45 passen zu DET-B3.
- HW-14: Gestrickt sind nur Merle (Strickjacke) und Jonas (Strickpullover); R01 und R02 scheiden aus. Konsistent mit BW-AUSSAGE-3.
- R03 und R04 in rollen.json stimmen mit K2-STAMM-Kleidung und den LF-Ankern (K9) überein. R03: strickjacke-zopf dunkelgrün (Rampe 5, Stufe 2), Bluse, Jeans (Rampe 6, Stufe 4; laut E41 blau), Wanderstiefel, Haarspange, Sommersprossen, kein Zubehör, also kein Notizbuch. R04: pullover olivgrün (Rampe 5, Stufe 4), kariertes Hemd, Jeans (Rampe 6, Stufe 3), Wanderstiefel, Armbanduhr. Hinweis: R03 und R04 sind beides grüne Strickoberteile. Das ist nach HW-14 gewollt; die Unterscheidung prüft die Sichtprüfung.
- Scanner: 0 Treffer. Wortsuche über Spieltexte, Daten, Figurendaten und Overlay: keine Treffer für Alkohol, Drogen, Blut, Hexen, Walpurgis, Teufel, Herkunftsklischees, bekannte Figuren oder Werke. Punsch ist überall alkoholfrei (erzaehler.json Zeile 119, K1 OA-04, K8 GL-14). „bewusstlos“ kommt in Spieltexten und Daten nicht mehr vor (ERSETZE-17 greift); „kurz benommen“ steht in faehigkeiten.json Zeile 142.
- Lagerunden-Dauer (ZM-2) ist in den Spieltexten nicht fest genannt. Die Umsetzung im Code ist nicht geprüft.
- Notizbuch als Zubehör bei drei Bewohnern in bewohner.json: betrifft nicht R03; kleine Zubehörteile werden nicht gezeichnet (E37 H1).

## Punkt 9a (E23–E41)

- Anerkannt ohne neuen Grund: Kanon-Spuren als O-Hinweise (E23, E27 M5), ERSETZE bewusstlos → benommen (E29), Familienfelder per Overlay und Wanderstiefel aus zwei Teilen (E38), Großmutter-Motive (E38, E39), Teile im Code (E27 M2), R03-Fähigkeit nur für R03 (E27 H1), „Einspruch!“ (E27 G3), Dutt bei älteren Bewohnerinnen (E40, offen).
- Widersprochen mit neuem Grund: Stadtzeiten als LISTE-ZEITEN-Ergänzung (Befund 2). Neu sind der Schlusssatz von v1.0 und die OA-Lücke.

## Begründung Kanontreu: nein

Befund 1 widerspricht verbindlichen Kanon-Fakten in einer Lösungsaussage und einer öffentlichen Hinweiskarte. Die übrigen Befunde betreffen Listen und Formulierungen, keine Fakten.

Dateihoheit: Nur diese Berichtsdatei wurde angelegt; keine Daten geändert. Kein Commit, kein Push, kein App-Build. Andere Prüfberichte und der Berichtsordner A-702/ wurden nicht gelesen.

Leitplanken eingehalten: ja · Kanontreu: nein · Plagiatsfrei: ja
