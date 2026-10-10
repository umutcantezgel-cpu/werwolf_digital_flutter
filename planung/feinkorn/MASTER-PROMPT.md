MASTER-PROMPT · AUSBAU · FEINKORN – PIXEL-WELT FÜR DEN SCHLOSSKELLER
Autonomer Ausbau der bestehenden App über mehrere Tage, parallel zum Finalisierungs-Lauf. Figuren, Gebäude und Räume entstehen aus winzigen Pixel-Blöcken – schön anzusehen und schonend für Handys. Du baust auf dem auf, was besteht, und änderst nichts an der Technik. Opus plant, baut die schweren Teile, prüft und integriert. Haiku-Unteragenten bauen zu. Am Ende liegt alles auf main.
Lies alles, bevor du beginnst. Danach arbeitest du ohne Rückfragen bis zum Ziel.

## 0. EINSTELLUNGEN
- Orchestrator: Opus 5.5 auf höchster Denkstufe – das bist du
- Unteragenten: Haiku 5.5, bis zu 4 gleichzeitig, für Qualitätsarbeit auf ihrer höchsten Denkstufe
- Name des Ausbaus: FEINKORN (Arbeitstitel; ein besserer eigener Name ist erlaubt, kein bestehender Produktname)
- Grundsatz: ausbauen statt umbauen. Die App und ihre Technik bleiben, wie sie sind (Abschnitt 3).
- Plattformen: die bestehende App für iOS und Android
- Erstes Werkstück: „Spuk im Schlosskeller“ – Gebäude, Räume, Figuren und Indizien
- Geräteklassen und Blockgrößen, als Startwerte, die du nach Messung anpasst:
  - hoch: Gebäude 2,5 cm · Figuren und Ausstattung 1 cm · Schlüsselindizien 0,5 cm
  - mittel: je eine Stufe gröber, also 5 · 2 · 1 cm
  - einfach: noch gröber oder die bisherige Darstellung – du entscheidest nach Messung
  - Die Lesbarkeit der Figuren geht immer vor.
- Bildwirkung:
  - In der Standardansicht wirken die Pixel-Blöcke fein wie Pixel; beim Heranzoomen werden sie als kleine Blöcke sichtbar.
  - Figuren und Gebäude wirken in der 2,5D-Welt räumlich, mit Licht und Schatten aus ihrer Form – so weit die vorhandene Technik es trägt.
  - Kein Minecraft-Look: keine groben Klötze, keine bekannten Texturen.
- Jeder Block hat eine Funktion: Er trägt ein Material, und das Material bestimmt Aussehen, Licht, Klang, Bewegung und Bruch.
- Physik: feste Rate, je Startwert deterministisch; die Rate legst du in K0 nach Messung fest
- Partyabend: zwei bis drei Stunden auf einem Hauptgerät; daran misst sich der Akkuschutz
- Stimmung: verbindlich laut Raummodell (7.7)
- Inhaltsregeln wie im Finalisierungs-Lauf:
  - kein Alkohol, keine Drogen, kein Rauchen
  - die Pfeife des Detektivs bläst Seifenblasen
  - der Schlag ist nur Schatten und Geräusch, kein Blut
- Zuständigkeit: Kanon, Spiellogik, Texte und Druck gehören dem Finalisierungs-Lauf; du liest den Kanon nur
- Kanon-Quelle: origin/finalisierung-schlosskeller, sobald er dort liegt; vorher main und das Quellmaterial
- Quellmaterial: quellen/schlosskeller-teamchat.txt – von Hand in diesen Ordner kopiert, nie committen
- Arbeitsordner: eigener Ordner des Repos (Worktree oder Klon); den Ordner des Finalisierungs-Laufs fasst du nie an
- Arbeitsbranch: kern-feinkorn, abgezweigt vom aktuellen origin/main; liegt er schon vor, nutzt du ihn
- Ziel: main auf origin, erst nach der Freigabe aus Abschnitt 3; danach Tag feinkorn-1.0
- Planungsordner: planung/feinkorn
- Sprache: Deutsch für Dokumentation und alles, was Spieler sehen

## 1. AUSGANGSLAGE UND NORDSTERN
- Die App für iOS und Android ist zu großen Teilen programmiert und wird in den Stores veröffentlicht. Das Murder-Mystery zeigt seine Welt bisher mit Bildern: gezeichnete Figuren, Räume und Gegenstände in einer 2,5D-Darstellung mit Nebel des Krieges und Lichtstimmung.
- Parallel macht ein anderer Lauf den Fall „Spuk im Schlosskeller“ inhaltlich fertig. Er schreibt dazu den Kanon: die eine Quelle für Orte, Figuren, Indizien und Tatablauf in vier Täter-Pfaden.
- Neu: Figuren, Gebäude und Gegenstände bestehen aus winzigen Pixel-Blöcken mit Material.
  - Jeder Block erfüllt eine Funktion: Er bestimmt, wie etwas aussieht, wie es Licht annimmt, wie es klingt, sich bewegt und zerbricht.
  - Fällt etwas, staubt es; Splitter und Dreck fliegen und bleiben liegen.
- Das baust du auf dem Bestand auf: als klar getrennten Teil im bestehenden Projekt, nach dessen Aufbau und Konventionen. So können spätere Spiele die Pixel-Bausteine wiederverwenden.
- Zugleich verschärfst du alle bestehenden Designs:
  - Gebäude und Räume bekommen hohe Auflösung, Feinschliff und Detailtiefe.
  - Figuren werden präziser und lebendiger und bleiben dem Kanon treu.
- Was besteht und funktioniert, bleibt. Du ersetzt nur, was nachweislich besser wird. Die alte Lösung bleibt erreichbar, bis die neue abgenommen ist.
- Liegen Referenzbilder bei, beschreibst du ihre Bildsprache in Worten im Planungsordner. Sie geben Stimmung vor, nie Motive zum Abkupfern.
- Nordstern: Der Schlosskeller sieht aus wie ein handgebautes Miniaturmodell aus Millionen winziger Pixel-Blöcke – jede Fuge im Sandstein, jede Kerbe in der Eichentür, jede Kordel an Cans Kapuze ist da. Die Figuren atmen und bewegen sich, Licht flackert über rauen Stein, und wenn der Kerzenständer fällt, krümelt Wachs über den Boden. Das alles läuft flüssig auf ganz normalen Handys, einen ganzen Partyabend lang, ohne dass sie heiß werden oder der Akku einbricht.

## 2. AUTONOMIE
- Du stellst keine Rückfragen und wartest auf keine Bestätigung. Ist etwas offen, entscheidest du nach dem Denkprotokoll (Abschnitt 5). Die Entscheidung trägst du mit Begründung ins ENTSCHEIDUNGSLOG ein und arbeitest weiter.
- Zwischenstände meldest du nur als Statuszeile und machst ohne Pause weiter.
- Du hörst erst auf, wenn alle Kriterien K-01 bis K-16 (Abschnitt 12) mit Beleg erfüllt sind.
- Ginge etwas nur gegen die Grenzen oder wird eine Aktion blockiert, lässt du sie weg. Du notierst sie unter FÜR DEN NUTZER und arbeitest am Rest weiter.
- Zwei Ausnahmen, in denen du anhältst:
  - Du läufst im Ordner des Finalisierungs-Laufs; dort ist finalisierung-schlosskeller ausgecheckt. Dann schreibst du unter FÜR DEN NUTZER, wie der eigene Ordner anzulegen ist.
  - In K7 fehlt die Freigabe aus Abschnitt 3, und alle Vorratsaufträge sind erledigt. Dann schreibst du BEREIT ZUR INTEGRATION in STATUS und wartest auf „weiter“.

## 3. GRENZEN UND VORRANG
- Bestandsschutz – gilt vor allem anderen:
  - Die Technik der App bleibt unverändert. Du baust mit dem, was das Projekt schon nutzt, und folgst seinem Aufbau und seinen Konventionen.
  - In die App kommen keine neuen Abhängigkeiten. Für Werkzeuge außerhalb der App nur, wenn es ohne nicht geht, mit Begründung im ENTSCHEIDUNGSLOG.
  - Diese Einstellungen fasst du nicht an: Build, Signatur, Store-Einträge, Berechtigungen, App-Kennung und Versionsnummer.
  - Du lädst nichts in die Stores hoch; veröffentlichen macht das Team.
  - Die App verbindet sich mit nichts Neuem; bestehende Verbindungen bleiben, wie sie sind.
  - Bestehende Funktionen, Daten und Speicherstände bleiben erhalten. Was du ersetzt, bleibt über einen Schalter erreichbar, bis die Abnahme bestanden ist.
  - Erreichst du ein Ziel nur durch eine Änderung an der Technik, änderst du sie nicht. Du wählst die beste Lösung innerhalb des Bestands und notierst die Grenze unter FÜR DEN NUTZER.
  - Werkzeuge, Prüfstand und Modellschau erscheinen nie in der veröffentlichten App.
- Netzwerk nutzt du nur für Git mit dem bestehenden origin und zum Installieren der Abhängigkeiten, die das Projekt schon hat. Keine neuen Remotes, kein Hochladen zu fremden Diensten.
- Git:
  - Du arbeitest auf kern-feinkorn und committest an jedem Meilenstein. Jeder Commit baut und testet grün.
  - An jedem Phasentor pushst du kern-feinkorn als Sicherung.
  - Verboten sind: Force-Push, umgeschriebene Geschichte auf geteilten Branches, gelöschte Remote-Branches und überschriebene Tags.
  - Lehnt origin einen Push ab, weil jemand anderes gepusht hat: holen, zusammenführen, alles neu testen, erneut pushen. Höchstens drei Anläufe.
  - Erzwingt eine Schutzregel Pull Requests, öffnest du einen mit dem Abschlussbericht und vermerkst das unter FÜR DEN NUTZER.
  - Vor jedem Push läuft ein Secret-Scan. Schlüssel, Zugangsdaten und der Rohchat kommen nie in den Verlauf.
- Zusammenspiel mit dem Finalisierungs-Lauf:
  - Du arbeitest nur in deinem Ordner. Laufende Entwicklungs- und Testumgebungen des anderen Laufs störst du nicht; du nutzt eigene.
  - Dateien, die der andere Lauf besitzt, änderst du nie: Kanon, Spiellogik, Texte, Druck, sein Planungsordner und seine Tests.
  - Seinen Stand holst du an deinen Phasentoren per Merge von origin/finalisierung-schlosskeller herein, nie umgekehrt.
  - Fehlt dir im Kanon etwas, legst du Zusatzwerte in eigenen Dateien an, verknüpft über die Kanon-Kennungen. Den Wunsch notierst du unter FÜR DEN NUTZER.
  - Freigabe für main: Der Tag schlosskeller-1.0 liegt auf origin, oder der Nutzer gibt nach BEREIT ZUR INTEGRATION mit „weiter“ frei.
  - Nach der Freigabe darfst du Vergleichsbilder in den Tests des Spiels für die neue Darstellung erneuern. Die Kriterien selbst änderst du nie.
- Original statt Kopie: keine Modelle, Texturen oder Marken aus bestehenden Spielen, kein Minecraft-Look, keine echten Personen als Vorlage.
- Die Pixel-Bausteine enthalten keinen Spielinhalt: keine Namen, Orte oder Texte des Murder-Mysterys.
- Unteragenten unterliegen denselben Grenzen; jeder Auftrag nennt sie.
- Vorrang bei Widersprüchen: 1. Bestandsschutz und Grenzen · 2. Kriterien des Finalisierungs-Laufs · 3. Abnahmekriterien · 4. Kanon · 5. Szenenvertrag · 6. PLAN · 7. Stilfragen.

## 4. ROLLEN UND AUFTRÄGE
- Du bist Architekt, Orchestrator, Prüfer und Integrator. Die Stufe-3-Teile baust du selbst:
  - Analyse der bestehenden Darstellung und Anschlussplan
  - Blockdaten
  - Darstellung der Pixel-Blöcke mit der vorhandenen Technik
  - Physik
  - Bewegung mit Gelenklösung
  - Szenenvertrag
  - Einbindung und Übergabe auf main
- Haiku-Rollen:
  - Kundschafter: liest Code und Daten und berichtet.
  - Baumeister: setzt einen Baustein auf deiner Schnittstelle um.
  - Figurenbauer: baut Figuren mit dem Figuren-Baukasten nach Kanon und Figurenblatt.
  - Raumbauer: baut Orte und Ausstattung mit dem Architektur-Baukasten.
  - Materialmacher: schreibt Materialrezepte.
  - Animator: baut Posen, Zustände und Ruhe-Animationen.
  - Physiktester: baut Messszenen und misst.
  - Testschreiber.
  - Sichtprüfer: prüft Bildschirmfotos gegen Look-, Detail- und Kanon-Checkliste.
  - Leistungsprüfer: misst Bildzeit, Rechenlast, Speicher, Wärme und App-Größe.
  - Bestandswächter: prüft jede Änderung gegen den Bestandsschutz.
  - Gegenprüfer: versucht gezielt, etwas kaputtzumachen.
  - Dokumentar.
- Schwierigkeit 1 und 2 geht an Haiku, Stufe 3 machst du selbst. Scheitert ein Auftrag zweimal, übernimmst du.
- Varianten-Regel: Schlüsselstellen gehen parallel an zwei oder drei Haiku-Agenten mit unterschiedlicher Vorgabe. Das sind das Sandstein-Gewölbe, der Gesichtsstil der Figuren und der Look von Dreck und Splittern. Du wählst oder verschmilzt nach dokumentierten Kriterien.
- Dateihoheit:
  - Jeder Auftrag nennt die Dateien, die nur dieser Agent ändert.
  - Gleichzeitige Aufträge berühren nie dieselben Dateien.
  - Gemeinsame Werte schreibst nur du: Blockgrößen, Materialtabelle, Budgettabelle, Physikwerte und Szenenvertrag.
- Für jede Rolle schreibst du in K0 ein kurzes Rollenbriefing:
  - Aufgabe der Rolle
  - was gute Arbeit ausmacht
  - die drei häufigsten Fehler
  - Umgang mit Unsicherheit: OFFENE FRAGE notieren statt raten
- Jeder Auftrag folgt diesem Bauplan, in dieser Reihenfolge:
  1. Kopfzeile: Kennung (etwa K4-RAUMBAUER-07) · Rolle · Bauphase · Version · Schwierigkeit
  2. Rollenbriefing
  3. Aufgabe in einem Satz
  4. Das Projekt in fünf Sätzen (unten, wortgleich)
  5. Auszug aus Szenenvertrag und Kanon mit Kennungen
  6. Schnittstellen
  7. eigene Dateien
  8. Grenzen, ausdrücklich mit dem Bestandsschutz
  9. nummerierte Arbeitsschritte
  10. Abnahmekriterien und Testweg
  11. Ausgabeformular
  12. Selbstprüfung
  13. letzte Zeile: === ENDE [Kennung] · BEREIT ZUR RÜCKGABE ===
- Das Projekt in fünf Sätzen: FEINKORN ist der Ausbau einer bestehenden iOS- und Android-App: Figuren, Gebäude und Gegenstände bestehen aus winzigen Pixel-Blöcken mit Material statt aus Bildern. Jeder Block erfüllt eine Funktion – er bestimmt, wie etwas aussieht, Licht annimmt, klingt, sich bewegt und zerbricht –, und abgelöste Blöcke fliegen als Dreck, Splitter oder Krümel und bleiben liegen. Figuren aus Pixel-Blöcken bewegen sich lebendig mit Skelett, Ruhe-Animationen und nachschwingender Kleidung. Alles baut auf der vorhandenen Technik auf, ändert sie nicht und läuft schonend auf Handys. Erstes Werkstück ist der Schlosskeller des Murder-Mystery-Spiels; jede Arbeit wird gemessen, nach Checkliste geprüft und nur vom Orchestrator integriert.

## 5. DENKPROTOKOLL
Bei Blockdaten, Darstellung, Physik, Bewegung, Handyschonung, Einbindung und jeder Abnahme denkst du mit voller Tiefe:
1. Ziel und Messgröße klären.
2. Mindestens drei echte Lösungswege – alle innerhalb der vorhandenen Technik.
3. Nach Bildwirkung, Schonung der Handys, Verträglichkeit mit dem Bestand und Wiederverwendbarkeit für spätere Spiele bewerten.
4. Umkehrprobe: Was müsste wahr sein, damit die Wahl falsch ist? Wenn möglich mit Prototyp und Messung prüfen.
5. Folgen zweiter Ordnung bedenken: für die App in den Stores, den Finalisierungs-Lauf und spätere Spiele.
6. Entscheidung mit Begründung ins ENTSCHEIDUNGSLOG.

## 6. BEGRIFFE
- Pixel-Block: kleinster Baustein der Welt, ein Pixel mit Tiefe, immer mit Material.
- Blockgröße: Kantenlänge der Blöcke eines Körpers.
- Blockkörper: zusammenhängende Blöcke mit eigener Lage, Größe und Bewegung, etwa Kerzenständer, Tür oder Figur.
- Abschnitt: Teil der Welt, der als Einheit geladen, gezeichnet und wieder freigegeben wird.
- Material: Farbe und Streuung, Rauheit, Leuchten, Dichte, Härte, Reibung, Bruchmuster und Klang eines Blocks.
- Rezept: Bauanleitung als Daten, aus der ein Baukasten ein Modell erzeugt.
- Ablagerung: Partikel, die zur Ruhe kommen und wieder Blöcke der Welt werden.
- Schüttgut: Staub, Ruß, Asche, Erde und Krümel; es rutscht, bis es im Böschungswinkel liegt.
- Geräteklasse: hoch, mittel oder einfach, je nach Leistung des Handys.
- Messbasis: der gemessene Stand der App vor deinem ersten Eingriff.
- Ruhemodus: sparsamer Betrieb in Momenten ohne Bewegung.
- Szenenvertrag: die Schnittstelle, über die ein Spiel den Pixel-Bausteinen sagt, was sie zeigen sollen.
- Figurenblatt: Ansichten und Schlüsselposen einer Figur zur Abnahme.
- Prüfstand: Messszene ohne Murder-Mystery-Inhalt, nur im Entwicklungsbuild.
- Modellschau: Betrachter für alle Modelle, nur im Entwicklungsbuild.
- Kanon: die Quelle des Finalisierungs-Laufs für Orte, Figuren, Indizien und Tatablauf.

## 7. DER AUSBAU

7.1 Aufbauen statt umbauen
- Zuerst verstehst du, wie die App heute Szenen, Figuren, Bilder, Licht und Nebel darstellt. Daran knüpfst du an.
- Die Pixel-Bausteine sind ein klar getrennter Teil mit fünf Bereichen: Daten · Darstellung · Physik · Bewegung · Werkzeuge. Jeder Bereich hat eine Schnittstelle, Tests und Dokumentation.
- Spiele liefern Inhalte über den Szenenvertrag und eigene Rezepte. Ein Spiel bindet die Bausteine mit wenigen Schritten ein:
  - Szene laden
  - Ansicht setzen
  - Ereignisse senden wie „Tür auf“, „Gegenstand fällt“ oder „Figur geht zu“
- Was niemand sieht, rechnet nicht: Verdeckte Blöcke, Räume im Nebel und ruhende Dinge kosten so gut wie nichts.
- Die bisherige Bilddarstellung bleibt über einen Schalter erreichbar. Die einfachste Geräteklasse darf sie automatisch bekommen.

7.2 Blockdaten
- Jeder Blockkörper hat seine eigene Blockgröße; mehrere Größen stehen nebeneinander in einer Szene.
- Die Daten sind dünn besetzt: Luft und verdecktes Inneres kosten fast nichts.
- Die Welt liegt in Abschnitten, die nach Bedarf nachladen. So sind später größere Welten möglich.
- Gespeichert wird kompakt und verlustfrei. Modelle entstehen möglichst aus Rezepten, damit die App klein bleibt.

7.3 Darstellung
- In K0 probierst du mindestens zwei Wege aus, die Pixel-Blöcke mit der vorhandenen Technik darzustellen. Du misst sie je Geräteklasse und entscheidest per Denkprotokoll.
- Licht, so weit die Technik es trägt:
  - kaltes Grundlicht und warme Punktlichter mit Flackern
  - Schatten aus der Form der Blöcke
  - dunklere Fugen und Ecken
  - leuchtende Materialien wie Flammen, Notausgangsschild und Displays
  - der Taschenlampenkegel
  Licht für Ruhendes darf vorberechnet werden.
- Der Nebel des Krieges funktioniert wie im Bestand, jetzt auch für Pixel-Blöcke.
- Blockkanten bleiben auf allen Bildschirmdichten der Zielgeräte scharf. Beim Schwenken flimmern feine Blöcke nicht.
- Detailstufen wechseln per Überblendung.
- Für jede Geräteklasse gilt eine Budgettabelle. Die automatische Anpassung senkt Blockgröße, Licht und Partikel, nie die Lesbarkeit der Figuren.

7.4 Physik
- Die Simulation läuft mit fester Rate, unabhängig von der Bildrate, und ist je Startwert deterministisch.
- Was ruht, schläft. Bewegte Dinge sind Blockkörper, die mit ihren Blöcken zusammenstoßen.
- Zerbrechen je Material:
  - Holz splittert entlang der Faser.
  - Glas springt in Scherben.
  - Stein bröckelt an den Kanten.
  - Wachs krümelt.
- Abgelöste Blöcke werden Partikel. Sie fliegen, prallen ab, kommen zur Ruhe und lagern sich wieder als Welt ab. Partikel entstehen nur, wo jemand hinschaut.
- Schüttgut rutscht nach einfachen Schüttregeln, bis es im Böschungswinkel liegt.
- Kleidung, Kopftücher, Schals, Kapuzenkordeln und Haare schwingen nach.
- Jeder Aufprall klingt nach seinem Material: Messing scheppert, Holz poltert, Glas klirrt.

7.5 Bewegung und Figuren
- Jede Figur hat ein Skelett, ihre Blöcke folgen ihm. Die Gelenke bleiben geschlossen. Den Weg dahin wählst du in K0 per Prototyp, etwa Gelenkfüllung oder Neuaufbau der Blöcke je Bild.
- Zustände: Stehen, Gehen, Sitzen auf Bänken, Tür öffnen, Gegenstand untersuchen, Erschrecken, Taschenlampe schwenken, Reden mit Gesten.
- Figuren sind nie eingefroren: Sie atmen, verlagern das Gewicht und schauen umher.
- Die Ruhe-Animationen aller Figuren kommen aus dem Kanon, zum Beispiel:
  - Ahmet tippt aufs Handy.
  - Fatma nestelt am Reißverschluss.
  - Tim klopft Kabelkanäle ab.
  - Selin zuckt bei Geräuschen.
- Mimik in wenigen Zuständen über Augen, Brauen und Mund.
- Figuren finden Wege über begehbare Flächen und weichen einander aus.
- Motion Design: Antizipation, Nachschwingen, Bögen statt gerader Wege, Haltepunkte. Füße gleiten nicht, Hände greifen sichtbar.

7.6 Modellierung – bestehende Designs verschärfen
- Bestandsaufnahme aller Bilder und Grafiken der App. Jedes bekommt einen Nachfolger aus Pixel-Blöcken oder wird begründet behalten, etwa Bedienelemente und Symbole.
- Figuren-Baukasten:
  - Er liest Statur, Größe, Haltung, Kleidungsschichten, Zubehör und Farbcodes aus den Kanon-Feldern.
  - Feinschliff von Hand wird als Bearbeitungsschritt gespeichert, damit Rezept und Ergebnis zusammenpassen.
- Je Figur entsteht zuerst ein Figurenblatt: vorne, Seite, hinten, Dreiviertel und sechs Schlüsselposen. Animationen folgen erst nach seiner Abnahme.
- Architektur-Baukasten:
  - Quader mit Fugen, Gewölbe, Bögen und Stufen
  - Türen mit Schnitzwerk und Eisenbeschlägen
  - Bänke, Theke und Lichtschächte
  - Alterung in eigenen Durchgängen: Kantenabrieb, Feuchte, Ruß und Staub in Ecken
- Bild-zu-Block-Wandler, als Werkzeug außerhalb der App: Bestehende Bilder dienen als Startpunkt und Referenz für Farbe, Silhouette und Stimmung, nie als Endergebnis.
- Materialbibliothek: Sandstein, Kalkmörtel, Eiche, Eisen, Messing, Glas, Wachs, Stoffe, Leder, Porzellan, Papier, Ruß, Staub, Erde. Jedes Material hat Farbe und Streuung, Rauheit, Leuchten, Dichte, Härte, Bruchmuster und Klang.

7.7 Der Schlosskeller als Werkstück
- Alle Orte aus dem Raumkanon entstehen aus Pixel-Blöcken. Lage und Maße kommen aus dem Kanon, nicht aus eigenen Annahmen:
  - Eingang mit Stufen und Windfang
  - Thekensaal, West-Saal mit Kamin, Ost-Saal
  - Vorratsraum und Durchgang
  - Turmgang mit Wendeltreppe, Toiletten, Rüstung und Vitrine
  - außen über dem Eingang die Schlossfassade bei Nacht, für Intro und Abspann
- Detailtiefe je Raum nach Checkliste, mindestens:
  - Sandsteinquader mit Fugen, Kantenabrieb und Feuchtespuren
  - Gewölbebögen mit Schlusssteinen
  - Eichentüren mit Schnitzwerk, Eisenriegeln und Gebrauchsspuren
  - Theke mit Samowaren, Kaffeekannen, Gläsern und Schneidebrettern
  - Buffets mit Warmhaltebehältern, Brotkörben und Schalen
  - Kamin-Nische mit Ruß und Ascheneimer
  - Bänke mit abgewetzten Sitzflächen, Tafeln mit Maserung
  - Jackenständer mit den Jacken der Figuren
  - die beschädigte Turmtür mit frischen Splittern
  - Ritterrüstung, Vitrine mit Glas und Münzen
  - Lichtschächte mit Kippfenstern, Notausgangsschild
- Die Stimmung des Raummodells ist verbindlich:
  - Nebel des Krieges: außerhalb des Sichtfelds 100 % schwarz; öffnet sich eine Tür, blendet der Raum radial in 0,4 s auf
  - Grundlicht mit 20 bis 25 % Helligkeit in kalten Blaugrau-Tönen
  - warme Lichtpunkte (RGB 255, 147, 41) mit leichtem Sinus-Flackern auf Buffets, Theke und Tafeln
  - Die 45-Grad-Schatten des Raummodells sind der Stilmaßstab für die Grundbeleuchtung.
- Licht im Stromausfall, Indizien und ihre Lage je Täter-Pfad kommen aus dem Kanon.
- Indizien sind Modelle in Indiz-Blockgröße, so wie der Kanon sie festlegt. Beispiele: Kerzenständer mit Wachsresten, Maske, Schlüsselbund, Münze mit Schatulle, Umschlag, Quittungsblock, Splitter, Fasern, Ring und Handschuh.

7.8 Verzahnung mit dem Spiel
- Szenenvertrag: Das Spiel beschreibt Orte, Körper, Figuren, Lichter, Sichtbarkeit und Ereignisse, die Pixel-Bausteine zeigen sie. Ein Adapter übersetzt den Kanon in diesen Vertrag.
- Story-Physik:
  - Fällt der Kerzenständer, scheppert Messing, Wachs krümelt, Staub steigt.
  - An der Vitrine liegen Glasscherben, an der Turmtür Holzsplitter, im Kamin Ruß.
  - Wo der Kanon Spuren je Pfad vorsieht, entstehen sie je Pfad.
- Rückblende: Die Tatmatrix des aktiven Pfads läuft mit echter Physik, bei jeder Wiedergabe gleich. Der Schlag bleibt Schatten und Geräusch.
- Detektiv: Der Taschenlampenkegel wirft Schatten. Die Pfeife bläst Seifenblasen, die aufsteigen und an Wänden platzen.
- Alle Kriterien des Finalisierungs-Laufs zu Bild, Figuren, Spoiler-Schutz und Ablauf bleiben mit der neuen Darstellung erfüllt.

7.9 Prüfstand und Modellschau – nur im Entwicklungsbuild
- Prüfstand: kleine Szene ohne Murder-Mystery-Inhalt, mit Kisten, Krügen, einem Sandhaufen und einer Holzwand.
  - Man kann Dinge fallen lassen, umwerfen und zerbrechen; Dreck bleibt liegen.
  - Er dient als Messszene und als Muster für neue Spiele.
- Modellschau: zeigt jedes Modell mit Drehteller, Lichtvorlagen, Blockgrößen und Material-Ansicht. Das Team prüft damit Entwürfe.

7.10 Handyschonung
- In K0 legst du eine Budgettabelle je Geräteklasse fest:
  - sichtbare Blöcke, Blockkörper, Partikel und Lichter
  - Ziel-Bildrate und Rechenzeit je Bild
  - Arbeitsspeicher
  - Zuwachs der App-Größe
  - Ladezeit
- Ruhemodus: In ruhigen Momenten – beim Lesen, in Menüs, während der Gespräche am Tisch – sinkt die Bildrate, und es rechnet nur, was sich bewegt. Im Hintergrund rechnet die App nichts.
- Wird das Gerät warm, schaltet die App selbst eine Stufe herunter und später wieder hoch.
- Partikel werden wiederverwendet statt ständig neu angelegt; Ablagerung statt endloser Simulation.
- Maßstab für Akku und Wärme ist ein ganzer Partyabend auf einem Hauptgerät.

## 8. BESTAND UND PRÜFWERKZEUGE
- Vor dem ersten Eingriff nimmst du die Messbasis auf und legst sie im Planungsordner ab:
  - wie die App heute darstellt, dazu alle Bilder und Grafiken
  - Aufbau und Konventionen des Projekts
  - Teststand, Build und CI
  - App-Größe, Ladezeit, Bildrate, Rechenlast, Speicher und – soweit messbar – Wärme
  - Build-, Signatur-, Store- und Berechtigungseinstellungen und die Abhängigkeiten der App als Vergleichsstand für den Bestandsschutz
  - Stand des Kanons auf origin
- Prüfwerkzeuge nutzt du aus dem Bestand. Was fehlt, kommt als Werkzeug außerhalb der App dazu, über den normalen Testbefehl aufrufbar:
  - Leistungsmessung je Geräteklasse: Bildzeit, Rechenlast, Speicher, Blockzahl
  - automatisierte Bildschirmfotos und Bildfolgen
  - Lückenprüfung an Gelenken
  - Flimmerprüfung per Bildvergleich
  - Detailprüfung: Farb- und Formvariation je Fläche
  - Kanon-Abgleich der Figuren und Orte
  - Determinismus-Test
  - Physik-Messszenen für Fall, Stapel und Bruch
  - Trennungsprüfung: Pixel-Bausteine ohne Spielinhalt
  - Bestandsprüfung: Vergleich von Abhängigkeiten, Einstellungen und Verbindungen mit der Messbasis
  - Release-Prüfung: keine Werkzeuge im veröffentlichten Build
  - Secret-Scan
- Sind Testgeräte angeschlossen und kann das Projekt schon darauf testen, misst du auch auf echten Geräten.

## 9. NEBELKARTE
Jedes Risiko ist so beschrieben: Risiko → Frühwarnzeichen → Gegenmaßnahme.
1. Die vorhandene Technik trägt etwas nicht → ein Prototyp scheitert → beste Lösung im Bestand, Grenze unter FÜR DEN NUTZER; die Technik wird nie getauscht.
2. Handys werden heiß oder der Akku bricht ein → der Wärmezustand steigt im Dauertest, oder die Rechenlast bleibt in ruhigen Momenten hoch → Ruhemodus, Geräteklassen, vorberechnetes Licht, automatisches Herunterstufen.
3. Zu viele Blöcke für einfache Geräte → das Budget wird verfehlt → größere Blöcke, Detailstufen, Abschnitte, notfalls die bisherige Darstellung.
4. Lücken oder Verzerrung an Gelenken → die Lückenprüfung wird rot → Prototypen in K0, Gelenkfüllung oder Neuaufbau je Bild.
5. Physik zittert oder explodiert → Energie wächst, Stapel wandern → feste Rate, Schlafzustände, Grenzwerte, Messszenen.
6. Partikelflut → die Bildzeit bricht ein → Partikelbudget je Klasse, Ablagerung, Wiederverwendung.
7. Feine Blöcke flimmern beim Schwenken → die Flimmerprüfung wird rot → Detailstufen, kein Block kleiner als ein Bildschirmpixel.
8. Die App wird zu groß → der Zuwachs liegt über dem Budget → Rezepte statt fertiger Modelle, kompakte Speicherung.
9. Der Bestand bricht → alte Tests werden rot, oder Einstellungen weichen ab → Bestandswächter, Schalter, Regression an jedem Phasentor.
10. Werkzeuge rutschen in den Store-Build → die Release-Prüfung wird rot → Werkzeuge nur im Entwicklungsbuild.
11. Konflikt mit dem Finalisierungs-Lauf → Merge-Konflikte oder rote F-Kriterien → eigener Ordner, Dateihoheit, Integration erst nach der Freigabe.
12. Die Stimmung geht verloren → die Helligkeit liegt außerhalb von 20 bis 25 %, oder der Sichtprüfer meldet Befunde → Stimmungsvorgabe als Messwert, Alterungsdurchgänge.
13. Figuren verlieren ihre Wiedererkennbarkeit → der Kanon-Abgleich wird rot → Baukasten liest den Kanon, Figurenblatt vor Animation.

## 10. BAUPHASEN
Zu Beginn jeder Bauphase liest du Nordstern, Bestandsschutz, Szenenvertrag und ABNAHME neu.

K0 – Messbasis, Prototypen, Gesamtplan:
- Ordner prüfen (Ausnahme in Abschnitt 2), Quellmaterial und Bestand lesen, Messbasis aufnehmen, Kanon-Stand holen.
- Prototypen mit der vorhandenen Technik, alle je Geräteklasse gemessen:
  - zwei Darstellungswege in einem Testraum von 10 × 10 × 4 m mit Gebäudeblöcken und einer Figur
  - ein fallender Kerzenständer mit Krümeln und Staub
  - eine gehende Figur aus Pixel-Blöcken ohne Gelenklücken
- Entscheidungen zu Darstellung, Physik und Bewegung per Denkprotokoll.
- Planungsordner anlegen: ABNAHME mit K-01 bis K-16 samt Prüfmethode, Schwelle und Beleg, dazu PLAN, STATUS, ENTSCHEIDUNGSLOG, PRÜFPUNKT und FÜR DEN NUTZER.
- Festlegen: Budgettabelle je Geräteklasse, Szenenvertrag in erster Fassung, Flimmerschwelle und Rollenbriefings.
- PLAN mit allen Aufträgen, Abhängigkeiten und Phasentoren bis zum Ende schreiben.
- Plan-Schleife: Der Gegenprüfer greift den Plan an, höchstens drei Runden. Dann schreibst du ihn mit Begründung fest.

K1 – Fundament:
- Blockdaten, Abschnitte und Materialien.
- Darstellung im Bestand mit Licht und Nebel.
- Geräteklassen und Schalter zur bisherigen Darstellung.
- Tor: K-02 und K-03.

K2 – Physik und Prüfstand:
- Blockkörper, Zerbrechen, Partikel, Ablagerung, Schüttgut, nachschwingende Kleidung, Klang, Determinismus.
- Der Prüfstand vollständig.
- Tor: K-05 und K-01.

K3 – Bewegung und Figuren:
- Skelett, Gelenke, Zustände, Ruhe-Animationen, Mimik, Wegfindung.
- Figuren-Baukasten; erst die Figurenblätter, dann alle Figuren.
- Tor: K-06 und K-07.

K4 – Räume und Materialien:
- Architektur-Baukasten, Materialbibliothek, alle Orte und Indizien.
- Tor: K-08 und K-09.

K5 – Verzahnung und Verschärfung:
- Szenenvertrag mit Kanon-Adapter, Story-Physik, Rückblende, Detektiv.
- Vorher-nachher-Paare.
- Tor: K-10 und K-11.

K6 – Handyschonung, Geräte und Werkzeuge:
- Budgets, Ruhemodus, Herunterstufen bei Wärme, Geräteklassen.
- Modellschau, Bild-zu-Block-Wandler, Anleitung, Gegenprüfung.
- Tor: K-04, K-12 und K-13; alle bisherigen Kriterien werden erneut belegt.

K7 – Integration auf main:
- Auf die Freigabe aus Abschnitt 3 warten; bis dahin Vorratsaufträge.
- origin/main hereinholen, die neue Darstellung als Standard schalten und alle Tests der App laufen lassen.
- Bestandsprüfung, Release-Prüfung, Abschlussbericht, Anleitung und Secret-Scan.
- In main zusammenführen und pushen. Tag setzen und pushen, Remote-Stand prüfen, CI abwarten.
- Tor: K-14, K-15 und K-16.

Abhängigkeit: K4 und K5 brauchen den Raumkanon aus Phase F1 des Finalisierungs-Laufs. Liegt er noch nicht auf origin, baust du die Räume vorläufig nach dem Raummodell des Quellmaterials und kennzeichnest sie so. Weil Räume aus Rezepten entstehen, ist der spätere Umbau billig.

Ein Phasentor ist bestanden, wenn:
- alle Tests grün sind,
- die Budgets je Geräteklasse eingehalten sind,
- die Bestandsprüfung keine Abweichung zur Messbasis zeigt,
- die Berichte von Sichtprüfer, Bestandswächter und Gegenprüfer keine schweren Befunde enthalten,
- die App mit der bisherigen Darstellung unverändert lauffähig ist,
- ein Commit angelegt und kern-feinkorn gepusht ist.

## 11. REGELKREISE
- Auftrag: vergeben → bauen → testen → Paketabnahme → integrieren oder nachbessern. Höchstens zwei Nachbesserungen, dann übernimmst du und vermerkst den Grund.
- Paketabnahme mit fünf Prüfungen zu je 0, 1 oder 2 Punkten:
  - Funktion: Tests grün
  - Bild: Look- und Detail-Checkliste
  - Handyschonung: Budget eingehalten
  - Kanon-Treue: Orte und Figuren stimmen
  - Bestandsschutz: keine Änderung an der Technik, Dateihoheit gewahrt, nichts Neues in der App
  Freigabe ab 8 von 10 Punkten ohne eine 0; sonst folgt ein Reparaturauftrag mit Fundstellen. Eine 0 beim Bestandsschutz heißt: Die Änderung wird sofort zurückgenommen.
- Auslastung: Solange ein Kriterium offen ist, bleibt kein Agentenplatz leer. Bei Blockaden kommen Vorratsaufträge – zusätzliche Tests, Messungen, Gegenproben, Varianten –, nie Füllstoff.
- Kanon: An jedem Phasentor holst du den Stand des Finalisierungs-Laufs herein und gleichst Orte und Figuren ab. Abweichungen werden zu Aufträgen.
- Phase: Am Phasentor wird jeder Befund zu einem Auftrag oder begründet verworfen. Nebelkarte und Zielabstand werden aktualisiert.
- Sitzung: Am Ende jedes Arbeitsblocks und vor einer absehbaren Kontextgrenze aktualisierst du STATUS und PRÜFPUNKT. Jede neue Sitzung liest zuerst diese Dateien und setzt exakt dort fort, auch nach einem Nutzungslimit.
- Tagesbericht in STATUS: Stand, Zielabstand, Messwerte je Geräteklasse, Plananpassung.
- Lernen: Wiederholt sich ein Fehlertyp, verbesserst du Auftragsvorlage oder Rollenbriefing und vermerkst die Änderung.
- Ziel: Nach jedem Phasentor gleichst du den Stand mit allen K-Kriterien ab; jede Lücke wird zu Aufträgen. Kein Kriterium wird still abgesenkt.
- Gegen Endlosschleifen: höchstens drei Anläufe je Phasentor. Danach wählst du per Denkprotokoll die beste Ersatzlösung, dokumentierst sie unter FÜR DEN NUTZER und machst weiter.

## 12. ABNAHMEKRITERIEN (messbar)
Abgehakt wird nur mit Beleg: Testlauf, Bildschirmfoto, Messwert oder Protokoll.

K-01 Aufgebaut auf dem Bestand:
- Die Bestandsprüfung zeigt gegenüber der Messbasis:
  - keine neuen Abhängigkeiten in der App
  - unveränderte Build-, Signatur-, Store- und Berechtigungseinstellungen
  - unveränderte App-Kennung und Versionsnummer
- Die Pixel-Bausteine sind ein klar getrennter Teil, folgen den Konventionen des Projekts und enthalten keinen Spielinhalt, belegt durch die Trennungsprüfung.
- Der Prüfstand läuft nur auf den Pixel-Bausteinen; die Release-Prüfung findet ihn nicht im veröffentlichten Build.

K-02 Blockdaten:
- Eine Szene zeigt gleichzeitig Blockkörper in allen drei Blockgrößen ihrer Geräteklasse.
- Speichern und Laden ist verlustfrei, geprüft Block für Block.
- Eine große synthetische Welt in Abschnitten lässt sich durchqueren; der Speicher schwankt dabei um höchstens 10 %.

K-03 Darstellung:
- Jede Lichtart aus 7.3, die die Technik trägt, ist mit Bildschirmfotos belegt. Jede Grenze steht begründet unter FÜR DEN NUTZER.
- Blockkanten bleiben auf allen Bildschirmdichten der Zielgeräte scharf (±1 px).
- Beim Schwenken bleibt das Flimmern unter der Schwelle aus K0.
- Die bisherige Darstellung ist über einen Schalter erreichbar.

K-04 Handyschonung – je Geräteklasse, im vollen Thekensaal mit allen Figuren:
- Bildrate: hoch mindestens 60, mittel und einfach mindestens 30 Bilder pro Sekunde. Im 99. Perzentil dauert ein Bild höchstens doppelt so lang wie die Zielbildzeit.
- In ruhigen Momenten sinkt die Rechenlast um mindestens 50 % gegenüber dem bewegten Spiel; im Hintergrund rechnet die App nichts.
- Im 30-Minuten-Dauertest bleibt der Wärmezustand im Normalbereich, wo die Testumgebung ihn messen kann; sonst steht der Test im Testplan für echte Geräte.
- Wird ein Gerät warm, stuft die App sich nachweislich herunter.
- Der Arbeitsspeicher bleibt im Budget. Nach 30 Minuten liegt er höchstens 10 % über dem Wert nach 2 Minuten.
- Die App wächst höchstens um das Größenbudget aus K0.
- Bis zum spielbaren Schlosskeller dauert es höchstens 2 Sekunden länger als in der Messbasis.
- Die Budgettabelle ist eingehalten.

K-05 Physik:
- Dieselbe Eingabeaufzeichnung endet bei 30, 60 und 120 Bildern pro Sekunde im selben Zustand.
- Derselbe Startwert ergibt in 100 Wiederholungen denselben Endzustand.
- Die Fallzeit aus 1 m Höhe weicht höchstens 2 % von der Formel ab.
- Ein Stapel aus zehn Kisten steht 60 s und wandert dabei höchstens 1 mm.
- Holz, Glas, Stein und Wachs zerbrechen nach ihrem Muster, belegt durch Bildfolgen.
- Partikel kommen zur Ruhe und lagern sich ab. Schüttgut bildet Häufchen mit stabilem Böschungswinkel, höchstens 5 Grad vom Materialwert entfernt.
- Außerhalb extremer Posen durchdringt nachschwingende Kleidung den Körper nicht, geprüft vom Sichtprüfer.

K-06 Bewegung:
- Die Lückenprüfung findet in allen Posen und Übergängen null offene Stellen an Gelenken.
- Alle Zustände aus 7.5 und alle Ruhe-Animationen aus dem Kanon sind erreicht und mit Bildstreifen belegt.
- Beim Gehen gleiten Füße höchstens 1 cm pro Schritt.
- Außer beim Erschrecken springt kein Gelenk zwischen zwei Bildern um mehr als 25 Grad.
- In 60 Sekunden Stillstand bewegt sich jede Figur sichtbar, belegt durch Bildvergleich.

K-07 Figuren:
- Alle Figuren des Kanons liegen als Modelle aus Pixel-Blöcken vor, erzeugt mit dem Baukasten: 20 Rollen, der Detektiv in m- und w-Fassung und Herr Schneider.
- Je Figur gibt es ein Figurenblatt mit vier Ansichten und sechs Schlüsselposen.
- Der Kanon-Abgleich ist grün: Die Grundfarben liegen unter neutralem Licht höchstens ΔE2000 = 3 vom Kanon-Farbcode entfernt, alle Merkmale sind vorhanden.
- Die Sichtprüfer-Checkliste ist je Figur zu mindestens 90 % erfüllt, darunter die Erkennbarkeit im gedimmten Licht und in jeder Geräteklasse.

K-08 Orte und Detailtiefe:
- Alle Orte aus 7.7 sind aus Pixel-Blöcken gebaut; Lage und Maße stimmen auf ±2 cm mit dem Kanon überein.
- Die Detail-Checkliste aus 7.7 ist je Raum vollständig.
- Die Detailprüfung findet keine Fläche über 0,25 m² ohne Farb- oder Formvariation.
- Nahaufnahmen bei vierfacher Vergrößerung zeigen in jedem Raum noch Struktur, geprüft vom Sichtprüfer.
- Alle Indizien des Kanons liegen als Modelle in Indiz-Blockgröße vor.

K-09 Materialien und Stimmung:
- Die Materialbibliothek aus 7.6 ist vollständig, mit allen Eigenschaften je Material.
- Die mittlere Helligkeit im Spielbild liegt in jedem Raum zwischen 20 und 25 %.
- Lichtpunkte flackern. Nebel des Krieges und Aufblenden entsprechen 7.7, belegt durch Messung und Bildfolgen.

K-10 Verzahnung:
- Der Schlosskeller entsteht vollständig über Szenenvertrag und Kanon-Adapter.
- Jede Story-Physik aus 7.8 ist ausgelöst und belegt, je Pfad, wo der Kanon es verlangt.
- Die Rückblende läuft in jedem Pfad mit Physik. Bei jeder Wiedergabe stehen alle Körper und Partikel in jedem Bild an derselben Stelle.
- Indizien liegen je Pfad an ihren Kanon-Orten.
- Taschenlampe und Seifenblasen funktionieren wie in 7.8.

K-11 Bestehende Designs verschärft:
- Die Bestandsliste aller Bilder ist vollständig; jedes hat einen Nachfolger aus Pixel-Blöcken oder eine Begründung.
- Für jeden Raum und jede Figur liegt ein Vorher-nachher-Bildpaar vor.
- Der Sichtprüfer bewertet jedes Paar; kein Nachfolger ist schlechter lesbar als das Original.

K-12 Geräte und Geräteklassen:
- Automatisierte Durchläufe auf iOS und Android je Geräteklasse, hochkant und quer, zeigen keine Darstellungs- oder Bedienfehler. Sie laufen auf angeschlossenen Geräten oder in der Testumgebung des Projekts.
- Die automatische Anpassung wählt die passende Klasse und senkt bei Bedarf Blockgröße, Licht und Partikel. Die Figuren bleiben in jeder Klasse lesbar, belegt durch Bildschirmfotos.
- Mit reduzierter Bewegung gibt es keine Kameraerschütterung und weniger Partikel.

K-13 Werkzeuge und Dokumentation:
- Die Modellschau zeigt jedes Modell mit Drehteller, Lichtvorlagen, Blockgrößen und Material-Ansicht.
- Der Bild-zu-Block-Wandler macht aus einem Bild ein bearbeitbares Startmodell.
- Ein Haiku-Agent ohne Vorwissen baut nach der Anleitung „Pixel-Bausteine in einem neuen Spiel nutzen“ eine eigene Mini-Szene, belegt durch Protokoll.

K-14 Spiel und Bestand:
- Mit der neuen Darstellung als Standard sind alle Tests der App grün, auch die Kriterien des Finalisierungs-Laufs zu Bild, Figuren, Spoiler-Schutz und Ablauf.
- Bestehende Funktionen, Daten und Speicherstände funktionieren unverändert, belegt durch Regressionstests.
- Die Netzwerkprüfung beim Spielen zeigt nur Verbindungen aus der Messbasis.
- Die Protokolle der App zeigen beim Spielen keine Fehler.
- Neue Abhängigkeiten von Werkzeugen außerhalb der App stehen in einer Lizenzliste; es gibt keine fremden Modelle, Texturen oder Marken.

K-15 Geprüft und übergeben:
- Die Berichte von Gegenprüfer und Bestandswächter enthalten keine offenen schweren Befunde.
- Abschlussbericht, Vorher-nachher-Galerie und Anleitung liegen im Repo.
- FÜR DEN NUTZER enthält:
  - einen Testplan für echte Handys: je ein älteres und ein aktuelles Gerät mit iOS und mit Android, ein Partyabend von drei Stunden mit Akku- und Wärmeprotokoll
  - die Fragen, die nur Menschen beantworten: Wirken die Figuren lebendig? Machen Dreck und Physik Spaß? Wie wirkt es im Vergleich zur alten Darstellung?
  - eine kurze Änderungsliste für die nächste Veröffentlichung in den Stores

K-16 Auf main:
- Die Integration begann erst nach der Freigabe aus Abschnitt 3.
- Der Secret-Scan ist leer; der Rohchat steht nicht im Verlauf.
- kern-feinkorn ist in main zusammengeführt und gepusht.
- main lokal und origin/main zeigen auf denselben Commit.
- Der Stand von origin/main vor der Integration ist Vorfahr dieses Commits; es gab also keinen Force-Push.
- Der Tag feinkorn-1.0 liegt auf diesem Commit und ist gepusht.
- Eine vorhandene CI ist auf main grün.

## 13. STATUS UND DISZIPLIN
Jede Antwort beginnt mit:
STAND · Bauphase K[n] von K7 · Abnahme [a] von 16 · Aufträge [fertig] von [gesamt] · Agenten aktiv [x] · Bildzeit Geräteklasse mittel [ms] · nächster Schritt: […]
- Kein Meta-Gerede, keine Zusammenfassung statt Arbeit, keine simulierten Ergebnisse. Erledigt ist nur, was gemessen, getestet und integriert ist.
- Sind alle Kriterien erfüllt, folgt der Abschlussbericht. Er enthält:
  - einen Beleg je K-Kriterium
  - den Commit auf main
  - die Vorher-nachher-Galerie
  - die Startanleitung
  - die Liste FÜR DEN NUTZER
  Die letzte Zeile lautet ZIEL ERREICHT.

## 14. START
Beginne sofort mit K0: Prüfe deinen Ordner, lies Quellmaterial und Bestand, nimm die Messbasis auf, hole den Kanon-Stand und baue die Prototypen. Danach arbeitest du alle Bauphasen ohne Rückfragen bis zum Ziel ab.
