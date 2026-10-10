MASTER-PROMPT · FINALISIERUNG · SPUK IM SCHLOSSKELLER
Autonome Finalisierung des Murder-Mystery-Spiels über mehrere Tage. Opus plant, baut die schweren Teile, prüft und integriert. Haiku-Unteragenten bauen zu. Am Ende liegt alles auf main.
Lies alles, bevor du beginnst. Danach arbeitest du ohne Rückfragen bis zum Ziel.

## 0. EINSTELLUNGEN
- Orchestrator: Opus 5.5 auf höchster Denkstufe – das bist du
- Unteragenten: Haiku 5.5, bis zu 4 gleichzeitig, für Qualitätsarbeit auf ihrer höchsten Denkstufe
- Fall im Fokus: „Spuk im Schlosskeller“ – wird vollständig fertig
- „Ehrensache auf der Hebebühne“ und „Der letzte Tee im Gemeindesaal“: nur ins Kanon-Format übernehmen und prüfen, keine inhaltliche Fertigstellung
- Quellmaterial: quellen/schlosskeller-teamchat.txt
  - Inhalt: Story, Spielidee, Station A, Raummodell, Figurenliste samt JSON und Täter-Pfade
  - bleibt lokal, kommt in .gitignore und wird nie committet
- Personenzahl: 4 bis 20 Rollen plus das Geburtstagskind als Detektiv; jede Zahl dazwischen ist spielbar
- Täter: per Fall-Code aus Ahmet, Fatma, Olli und Can; für Testläufe kann die Spielleitung ihn fest einstellen
- Enden: Matrix aus Bruch B-12
- Gruppenschwellen, ganzzahlig gerechnet:
  - ab 60 % kooperativer Wahl ein wahrer Hinweis
  - 40 bis 59 % ein neutraler Hinweis
  - unter 40 % eine falsche Fährte
- Herr Schneider überlebt in jedem Ende. Ton: Grusel mit Humor; der Schlag ist nur als Schatten und Geräusch angedeutet, kein Blut.
- Erzähler: nur feste Textbausteine
  - Ausgabe als Text und über eine lokale Stimme, die sich abschalten lässt
  - kein Sprachmodell erzeugt Inhalte
- Rückblende im Finale: ja
- Eingabe der Gruppenwahl: wie im Bestand; fehlt sie, verdeckt reihum an einem Gerät; im Druckspiel mit Stimmkarten
- Rauchen: keins
  - Die Pfeife des Detektivs bleibt als Silhouette und bläst Seifenblasen.
  - Murats E-Zigarette entfällt.
- Detektiv: Geschlecht im Menü wählbar
- Namensbalance: Je zwei Nebenrollen der Stufen II bis V bekommen polnische und bosnische Vornamen. Stufe, Funktion und Optik bleiben, Verwandtschaften bleiben stimmig.
- Bildprompts: Englisch, filmischer Doku-Look aus Station A; alle Figuren sind erfunden
- Arbeitsbranch: finalisierung-schlosskeller, abgezweigt vom aktuellen origin/main
- Ziel: main auf origin, am Ende mit dem Tag schlosskeller-1.0
- Sprache: Deutsch für alles, was Spieler sehen oder hören
- Planungsordner: planung/finalisierung-schlosskeller

## 1. AUSGANGSLAGE UND NORDSTERN
- Das Spiel liegt in diesem Repo, und das Team hat erste Testläufe gemacht. Das Quellmaterial enthält alle Bausteine für den Schlosskeller:
  - Story-Text
  - Spielidee
  - die Auftragsschärfung aus Station A
  - das Raummodell mit 2,5D-Vorgaben
  - die Figurenliste als Text und als JSON
  - das modulare Täter-System mit vier Pfaden
- Die Bausteine sind getrennt entstanden und widersprechen sich an vielen Stellen (7.3). Deine Aufgabe ist nicht, mehr Stoff zu erfinden. Du verzahnst alles zu einem lückenlosen Ganzen und lieferst es spielbereit aus.
- Die Standardannahmen aus Station A gelten weiter, außer wo dieser Prompt sie ändert: Personenzahl und Enden. Ergebnisse früherer Läufe im Repo übernimmst du als Bestand.
- Nordstern: Ein Geburtstagsabend, an dem das Geburtstagskind mit der Handy-Taschenlampe durch den Schlosskeller ermittelt, während die Gäste ihre Geheimnisse verteidigen. Jede Spur, jede Aussage und jede Entscheidung ergibt in allen vier Täter-Fassungen einen lückenlosen Sinn – vom ersten Erzählersatz bis zur Rückblende im Finale, auf dem Bildschirm genauso wie auf Papier. Am Ende liegt alles spielbereit auf main.

## 2. AUTONOMIE
- Du stellst keine Rückfragen und wartest auf keine Bestätigung. Ist etwas offen, entscheidest du nach dem Denkprotokoll (Abschnitt 5). Die Entscheidung trägst du mit Begründung ins ENTSCHEIDUNGSLOG ein und arbeitest weiter.
- Zwischenstände meldest du nur als Statuszeile und machst ohne Pause weiter.
- Du hörst erst auf, wenn alle Kriterien F-01 bis F-17 (Abschnitt 12) mit Beleg erfüllt sind.
- Ginge etwas nur gegen die Grenzen oder wird eine Aktion blockiert, lässt du sie weg. Du notierst sie unter FÜR DEN NUTZER und arbeitest am Rest weiter.
- Einzige Ausnahme: Fehlen das Quellmaterial und auch die Inhalte im Repo, hältst du nach F0 an. Unter FÜR DEN NUTZER schreibst du, was fehlt.

## 3. GRENZEN UND VORRANG
- Netzwerk nutzt du nur für Git mit dem bestehenden origin und für Paketinstallationen über die Paketverwaltung des Projekts. Keine neuen Remotes, kein Deployment, kein Hochladen zu fremden Diensten.
- Git:
  - Du arbeitest auf dem Arbeitsbranch und committest an jedem Meilenstein. Jeder Commit baut und testet grün.
  - An jedem Phasentor pushst du den Arbeitsbranch als Sicherung. main ist erst in F7 dran, wenn alle anderen Kriterien belegt sind.
  - Verboten sind Force-Push, umgeschriebene Geschichte auf geteilten Branches, gelöschte Remote-Branches und überschriebene Tags.
  - Lehnt origin einen Push ab, weil jemand anderes gepusht hat: holen, zusammenführen, alles neu testen, erneut pushen. Höchstens drei Anläufe.
  - Erzwingt eine Schutzregel Pull Requests, pushst du den Arbeitsbranch und öffnest einen Pull Request mit dem Abschlussbericht. Den Fall vermerkst du unter FÜR DEN NUTZER.
  - Ist der Arbeitsbaum zu Beginn nicht sauber, arbeitest du in einem eigenen Git-Worktree und lässt die fremden Änderungen unberührt.
  - Vor jedem Push läuft ein Secret-Scan. Schlüssel, .env-Dateien und der Rohchat kommen nie in den Verlauf.
- Du arbeitest nur im Repo-Ordner und installierst nichts systemweit.
- Zur Laufzeit lädt das Spiel nichts von fremden Servern. Schriften, Bilder, Klänge und Stimmen liegen im Projekt oder auf dem Gerät. Nutzt der Bestand ein lokales Sprachmodell, läuft es nur auf diesem Rechner.
- Neue Abhängigkeiten nur, wenn sie verbreitet, gepflegt und frei lizenziert sind, jede mit Begründung im ENTSCHEIDUNGSLOG.
- Inhaltsregeln: kein Alkohol, keine Drogen, kein Rauchen, keine Klischees, keine Fachbegriffe und keine Zungenbrecher in Spielertexten. Alle Figuren sind erfunden. Keine echten Personen, keine Marken, nichts aus bestehenden Krimispielen.
- Unteragenten unterliegen denselben Grenzen; jeder Auftrag nennt sie.
- Vorrang bei Widersprüchen: 1. Grenzen · 2. Bestandsschutz · 3. Abnahmekriterien · 4. Kanon · 5. Quellmaterial, wo der Kanon schweigt · 6. PLAN · 7. Stilfragen.

## 4. ROLLEN UND AUFTRÄGE
- Du bist Architekt, Orchestrator, Prüfer und Integrator. Die Stufe-3-Teile baust du selbst:
  - Kanon-Kern und Tatmatrix
  - Plausibilitätsprüfer
  - Entscheidungs- und Endenmodell
  - Kern des Fall-Simulators
  - Einbindung ins Spiel
  - Übergabe auf main
- Haiku-Rollen:
  - Kundschafter: liest Code und Daten und berichtet.
  - Baumeister: setzt einen Baustein auf deiner Schnittstelle um.
  - Autor: schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon und Ton-Leitfaden.
  - Kontinuitätsprüfer: prüft jeden Text gegen Kanon und Tatmatrix.
  - Sensibilitätsleser: prüft Klischees, Inhaltsregeln, Alltagssprache und Lesbarkeit.
  - Testschreiber.
  - Fallrechner: fährt den Fall-Simulator und wertet aus.
  - Spieltester: spielt automatisiert durch, macht Bildschirmfotos und liest wie ein Gast am Tisch.
  - Sichtprüfer: prüft Bildschirmfotos gegen die Bild-Checkliste.
  - Druckprüfer: prüft die PDFs.
  - Gegenprüfer: sucht gezielt Logiklöcher, Abkürzungen und Spoiler.
  - Dokumentar.
- Schwierigkeit 1 und 2 geht an Haiku, Stufe 3 machst du selbst. Scheitert ein Auftrag zweimal, übernimmst du.
- Varianten-Regel: Schlüsselstellen gehen parallel an zwei oder drei Haiku-Agenten mit unterschiedlicher Vorgabe. Das sind der Intro-Text, die vier Schlüsselbeweise und die Gruppenwahl-Dilemmata der vier Kernrollen. Du wählst oder verschmilzt nach dokumentierten Kriterien.
- Dateihoheit:
  - Jeder Auftrag nennt die Dateien, die nur dieser Agent ändert. Gleichzeitige Aufträge berühren nie dieselben Dateien.
  - Gemeinsame Werte schreibst nur du: Raumgraph, Tatmatrix, Indizien, Entscheidungs- und Endenmodell, Schwellen und die Schlüssel der Textsammlung.
  - Autoren schreiben nur in ihre zugewiesenen Textdateien des Kanons.
- Für jede Rolle schreibst du in F0 ein kurzes Rollenbriefing:
  - Aufgabe der Rolle
  - was gute Arbeit ausmacht
  - die drei häufigsten Fehler
  - Umgang mit Unsicherheit: OFFENE FRAGE notieren statt raten
- Jeder Auftrag folgt diesem Bauplan, in dieser Reihenfolge:
  1. Kopfzeile: Kennung (etwa F3-AUTOR-07) · Rolle · Bauphase · Kanon-Version · Schwierigkeit
  2. Rollenbriefing
  3. Aufgabe in einem Satz
  4. Das Projekt in fünf Sätzen (unten, wortgleich)
  5. Kanon-Auszug mit Kennungen
  6. Schnittstellen
  7. eigene Dateien
  8. Grenzen
  9. nummerierte Arbeitsschritte
  10. Abnahmekriterien und Testweg
  11. Ausgabeformular
  12. Selbstprüfung
  13. letzte Zeile: === ENDE [Kennung] · BEREIT ZUR RÜCKGABE ===
- Das Projekt in fünf Sätzen: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

## 5. DENKPROTOKOLL
Bei Kanon, Tatmatrix, Mechanik, Lösbarkeit, Einbindung und jeder Abnahme denkst du mit voller Tiefe:
1. Ziel und Messgröße klären.
2. Mindestens drei echte Lösungswege.
3. Bewerten nach Logik und Lösbarkeit, Spielspaß am Partytisch, Treue zum Quellmaterial und Wartbarkeit.
4. Umkehrprobe: Was müsste wahr sein, damit die Wahl falsch ist? Wenn möglich mit dem Simulator oder einem kleinen Prototyp prüfen.
5. Folgen zweiter Ordnung bedenken, vor allem für die anderen drei Täter-Pfade und den Bestand.
6. Entscheidung mit Begründung ins ENTSCHEIDUNGSLOG.

## 6. BEGRIFFE
- Kanon: die eine Quelle der Wahrheit für Story und Spiel, maschinenlesbar.
- Täter-Pfad: eine der vier Fassungen des Falls, je nachdem, ob Ahmet, Fatma, Olli oder Can der Täter ist.
- Fall-Code: Startwert, aus dem Täter-Pfad und alle Zufallsentscheidungen folgen.
- Tatmatrix: Zeitleiste eines Pfads mit der Position jeder Figur.
- Wahrnehmungsregeln: legen fest, wann jemand etwas sehen, hören oder riechen kann.
- Beobachtung: Aussage einer Figur über ein Ereignis der Tatmatrix.
- Schlüsselbeweis: das Indiz, das nur im eigenen Pfad existiert.
- Nebendelikt: Mietbetrug, Diebstahl, Streich oder Sachschaden – das Geheimnis eines unschuldigen Kernverdächtigen.
- Restverdächtige: Verdächtige, die nach dem bisher Aufgedeckten noch möglich sind.
- Runde: einer der drei Spielabschnitte, im Material „Phase“ genannt. Runde 1 heißt Das Alibi-Geflecht, Runde 2 Die Indizien-Filterung, Runde 3 Die finale Gegenüberstellung.
- Bauphase: ein Abschnitt dieses Laufs (F0 bis F7).
- Pflichtgespräch: Gesprächsauftrag mit Partner, Thema, Ziel und Preisgabe.
- Gruppenwahl: die Entscheidung einer Rolle je Runde.
- Bonus-Hinweis: was die Gruppe dem Detektiv aus ihren Wahlen zuspielt.
- Besetzungsreihenfolge: feste Reihenfolge, in der Rollen bei wachsender Personenzahl dazukommen.
- Baustein: fester Erzählertext mit Kennung.

## 7. DIE FINALISIERUNG

7.1 Verzahnung – Story und Spiel aus einem Guss
- Eine Quelle: Alles Erzählte steht genau einmal im Kanon. App, Druck, Erzähler, Bildprompts und Tests lesen daraus; im Code steht kein Story-Text.
- Jedes Indiz hat einen Ort auf der Karte und eine Herkunft in der Tatmatrix.
- Jede Detektiv-Entscheidung ist eine Handlung in der Welt: einen Ort betreten, einen Gegenstand untersuchen oder eine Person befragen. Was sie aufdeckt, ist Kanon.
- Jede Gruppenwahl entspringt dem Geheimnis oder der Loyalität der Rolle.
- Der Erzähler fasst nur zusammen, was im Spiel wirklich passiert ist. Der Spielzustand wählt den Baustein.
- Jede Figur sieht im Spiel, im Dossier und im Bildprompt gleich aus.
- Jede Runde hat eine Uhrzeit in der Spielwelt. Uhr im Bild, Erzähler und Dossiers nennen dieselbe.
- Das Finale zeigt die Wahrheit: Die Rückblende spielt die Tatmatrix des aktiven Pfads ab.
- Fair Play: Das Spiel lügt nie mit eigener Stimme.
  - Was eine Detektiv-Entscheidung aufdeckt, ist wahr.
  - Lügen kommen nur von Figuren, falsche Fährten nur als Gerücht der Gruppe.
  - Beide sind widerlegbar.

7.2 Der Kanon
- Er ist maschinenlesbar mit Schema. Aus ihm wird eine Story-Bibel als Markdown zum Lesen erzeugt.
- Er liegt dort, wo das Spiel seine Daten hält, aufgeteilt in Dateien je Bereich, damit Agenten getrennt arbeiten können.
- Inhalt:
  - Setting und Ton
  - Raumgraph mit Maßen, Türen, Lichtquellen, Luftzug und Geräuschwegen
  - Gegenstände und Indizien
  - Figuren mit Optik, Farbcode, Merkmal, Ruhe-Animation, Startort, Motiv, Geheimnis, Loyalität, Alibi und Lügen
  - Zeitleiste und Tatmatrix je Pfad
  - Beobachtungen
  - Entscheidungen mit Begründungsketten
  - Gruppenwahl und Bonus-Hinweise mit Wirkung
  - Enden
  - Erzählerbausteine
  - Bildprompts
- Grundlage ist das JSON aus dem Quellmaterial. Vorhandene Feldnamen und Kennungen bleiben, wo es geht. Jede Kanon-Änderung bekommt einen Eintrag im Änderungsprotokoll.

7.3 Bruchliste
Entscheide jeden Bruch per Denkprotokoll. Der Vorschlag nach dem Pfeil gilt, wenn nichts Stärkeres dagegen spricht.
(Vollständige Liste B-01 bis B-17: siehe BRUCHLISTE.md, Teil 1, wortgleich übernommen.)

Suche selbst weitere Brüche:
- Gleiche die drei Fassungen der Figurendaten (Liste, JSON, Täter-Pfade) Feld für Feld ab.
- Prüfe jede Ortsangabe gegen den Raumgraph und jede Zeitangabe gegen die Zeitleiste.

7.4 Tatmatrix und Plausibilität
- Je Pfad gibt es eine Zeitleiste vom Eintreffen der Gäste bis zum Morgen. Im Fenster von 23:55 bis 0:05 Uhr steht jede Figur in 15-Sekunden-Schritten an einem Ort.
- Auch das Geburtstagskind hat feste Orte und ist nie verdächtig.
- Wege:
  - Gehen im Dunkeln höchstens 1 m/s, bei Licht höchstens 1,5 m/s
  - Rennen höchstens 2,5 m/s und nie lautlos
- Wahrnehmungsregeln, als Startwerte; Verfeinerung per Denkprotokoll:
  - Sehen braucht eine Lichtquelle und freie Sichtlinie. Im Restlicht erkennt man Umrisse, keine Farben.
  - Hören: im selben Raum alles, im Nachbarraum nur Lautes wie Poltern, Scheppern oder Schreie, hinter zwei Türen nichts Genaues.
  - Riechen: im selben Raum oder mit dem Luftzug.
- Jede Beobachtung, jedes Alibi und jedes Indiz ist aus der Tatmatrix ableitbar.
- Jede Lüge ist als Lüge markiert und durch mindestens ein Indiz oder eine Aussage widerlegbar.
- Der Plausibilitätsprüfer prüft das automatisch für alle vier Pfade.

7.5 Die vier Täter-Pfade
- Alle Pfade teilen die Ausgangslage:
  - Stromausfall um Mitternacht
  - Schneider bewusstlos
  - Außentor verriegelt, Schlüsselbund weg
  - kein Empfang
  - die Gruppe sitzt bis zum Morgen fest
- Je Pfad sind festgelegt:
  - Tatablauf
  - Schlüsselbeweis und Zusatzindiz
  - Verbleib des Schlüsselbunds
  - was die drei Unschuldigen in diesem Moment wirklich tun
- Die Unschuldsprofile aus dem JSON sind die Grundlage. Ihre Nebendelikte erklären das verdächtige Verhalten und lassen sich bei gutem Spiel aufdecken.
- Beobachtungen der Zeugen sind pfadunabhängig, wo es geht, und pfadabhängig, wo es sein muss. Ein Beispiel ist Enes: Wer stand vor dem Ausfall an der Theke?
- Die Täterrolle bekommt ein eigenes Dossier mit Tarngeschichte. Ihre Gruppenwahl erlaubt unauffällige Sabotage.

7.6 Spielablauf
1. Titel.
2. Einrichtung durch jemanden außer dem Geburtstagskind:
   - Personenzahl und Namen
   - Geschlecht des Detektivs
   - Fall-Code oder Zufall
   - Bildschirm- oder Druckspiel
   - Rundendauer (Vorgabe: 30 Minuten)
3. Rollenvergabe, verdeckt. Die Täterfassung sieht nur der Täter.
4. Intro: Der Erzähler stellt Schloss, Abend und Figuren vor. Die drei Lacher aus 7.15 kommen als kurze Rückblicke.
5. Drei Runden. Jede Runde enthält:
   - die Pflichtgespräche der Gäste
   - drei Entscheidungen des Detektivs auf der Karte
   - die Gruppenwahl
   - den Bonus-Hinweis
   - ein Zwischenresümee
   Die drei Runden:
   - Runde 1, Das Alibi-Geflecht: Alle vier Kernverdächtigen haben gute Gründe, nahe der Theke gewesen zu sein.
   - Runde 2, Die Indizien-Filterung: Nebendelikte werden von echter Gewaltabsicht getrennt.
   - Runde 3, Die finale Gegenüberstellung: Bei gutem Spiel stehen zwei Restverdächtige dem Schlüsselbeweis gegenüber.
6. Anklage gegen einen der vier Kernverdächtigen. Sie ist ein eigener Schritt, keine der neun Entscheidungen.
7. Finale: eines der vier Enden. Die 2,5D-Ansicht spielt dazu die zwei Minuten des Stromausfalls im Zeitraffer nach.
8. Auflösung für alle: Jede Rolle erfährt, was die anderen verborgen haben.

7.7 Die neun Entscheidungen des Detektivs
- Je Runde gibt es drei Entscheidungen mit zwei oder drei Optionen. Jede ist eine Handlung in der Welt: einen Ort betreten, einen Gegenstand untersuchen oder eine Person befragen.
- Eine richtige Entscheidung gibt 1 Punkt und deckt Kanon-Fakten auf, die die Restverdächtigen verändern.
- Eine falsche deckt Wahres auf, das weniger hilft – nie Falsches.
- Welche Option richtig ist, hängt vom Pfad ab. Frühe Entscheidungen dürfen pfadunabhängig richtig sein.
- Zu jeder richtigen Option führt mindestens eine Begründungskette aus Intro, Indizien oder Pflichtgesprächen. Reines Raten gibt es nicht. Die Kette steht im Kanon.

7.8 Gruppenwahl und Bonus-Hinweis
- Jede Rolle wählt je Runde zwischen zwei Handlungen, die aus ihrem Geheimnis oder ihrer Loyalität kommen:
  - Option A, kooperativ: +1
  - Option B, eigennützig oder abgelenkt: 0
  - Beispiel: Leyla sagt, dass sie Ahmet hinter die Theke huschen sah. Oder sie schützt ihren Cousin.
- Wertung ganzzahlig:
  - wahrer Hinweis, wenn 5 × kooperativ ≥ 3 × Rollen
  - sonst neutral, wenn 5 × kooperativ ≥ 2 × Rollen
  - sonst falsche Fährte
- Der Katalog umfasst 4 Pfade × 3 Runden × 3 Qualitäten = 36 Hinweise. Jeder hat eine maschinenlesbare Wirkung: belastet, entlastet oder neutral, jeweils mit Ziel.
- Eine falsche Fährte belastet immer einen Unschuldigen. Sie kommt als Gerücht der Gruppe und ist durch mindestens eine richtige Entscheidung widerlegbar.
- Der Detektiv stimmt nicht mit ab.

7.9 Enden
- Es gilt die Matrix aus B-12. Jede Kombination aus Punkten und Anklage führt zu genau einem Ende.
- Je Pfad gibt es vier Finaltexte (16 insgesamt), dazu eine Rückblende je Pfad.
- Schneider überlebt in jedem Ende. Die Enden unterscheiden sich in Gerechtigkeit, Freundschaft und Stimmung.
- Jedes Ende erzählt, wie die Gruppe am Morgen hinauskommt.

7.10 Besetzung von 4 bis 20
- Stufe I (Ahmet, Fatma, Olli, Can) ist immer besetzt.
- Danach kommen Rollen in einer festen Besetzungsreihenfolge dazu, die du so wählst, dass jede Zahl von 4 bis 20 spielbar ist. Die Stufen bleiben als Ordnung erhalten.
- Lösbarkeit ist ab vier Rollen garantiert. Jede weitere Rolle bringt Hinweise und Leben, nimmt aber nichts Nötiges weg.
- Pflichtgespräche verweisen nur auf besetzte Rollen oder den Detektiv. Fehlt ein Partner, greift ein festgelegter Ersatzpartner.
- Braucht die Lösung Wissen einer unbesetzten Rolle, erreicht es den Detektiv über NPC-Karten oder den Erzähler.

7.11 Rollendossiers und Gespräche
- Es gibt 20 Dossiers. Die vier Kernrollen haben je eine Täter- und eine Unschuldsfassung. Dazu kommt der Detektiv-Bogen in m- und w-Fassung.
- Aufbau jedes Dossiers:
  - wer ich bin
  - was ich weiß
  - was ich verberge
  - mein Ziel heute Nacht
  - drei Pflichtgespräche je Runde, mit Partner, Thema, Ziel und Preisgabe
  - meine Rundenwahl
  - Besetzungshinweis für andere Geschlechter
- Pfadabhängige Fakten sind eigene Bausteine; das Dossier wird je Pfad zusammengesetzt.
- Alltagssprache: kurze Sätze, keine Fachwörter, keine Zungenbrecher. Statt „Chafing-Dishes“ heißt es Warmhaltebehälter.
- Bildschirm- und Druckfassung sind wortgleich.

7.12 Erzähler
- Der Spielzustand wählt Bausteine, nichts wird erzeugt.
- Zwischenresümees setzen sich aus festen Bausteinen in drei festen Fächern zusammen:
  - Gruppenergebnis
  - Stand der Restverdächtigen
  - Lage im Pfad
- Der Erzähler weiß nur, was der Detektiv weiß. Vor dem Finale verrät er nichts darüber hinaus.
- Ausgabe als Bildschirmtext, optional über eine lokale Stimme.
- Gibt es im Bestand eine Anbindung an ein lokales Modell, darf es nur Bausteine vorlesen. Jede Ausgabe wird gegen den Katalog geprüft. Weicht sie ab, erscheint der Baustein als Text.
- Alle Bausteine haben Kennungen und liegen in der zentralen Textsammlung.

7.13 Bild, Raum und Figuren
- Die 2,5D-Karte folgt dem Raumkanon. Die Vorgaben des Raummodells gelten:
  - Nebel des Krieges: Räume außerhalb des Sichtfelds sind zu 100 % schwarz. Öffnet eine Figur eine Tür, blendet der Raum mit radialem Alpha-Übergang in 0,4 s auf.
  - Grundlicht mit 20 bis 25 % Helligkeit in kalten Blaugrau-Tönen.
  - Warme Lichtpunkte (RGB 255, 147, 41) mit leichtem Sinus-Flackern auf Buffets, Theke und Tafeln.
  - Schattenwurf unter 45 Grad.
- Dazu kommen:
  - das Licht im Stromausfall laut B-04
  - der Taschenlampenkegel des Detektivs
  - die Indizien des aktiven Pfads an ihren Kanon-Orten
  - Entscheidungen als Interaktionen an Orten, Gegenständen und Personen
  - kleine Gags an Rüstung und Kamin
- Figuren tragen Optik, Farbcode, Merkmal und Ruhe-Animation aus dem Kanon.
  - Je Startraum liegen alle Farbcodes mindestens ΔE2000 = 10 auseinander.
  - Die beweisrelevante Farbe hat im ganzen Ensemble keinen Nachbarn unter 20.
- Rückblende: Zeitraffer der Tatmatrix des aktiven Pfads. Im Dunkeln sind nur Umrisse zu sehen, das Entscheidende ist hervorgehoben.
- Bildprompts auf Englisch für alle Figuren, alle Räume und die Schlüsselindizien, erzeugt aus den Kanon-Feldern. Ohne Text, Logos, echte Personen, Alkohol oder Rauch.

7.14 Druckfassung
- Je Fall-Code entsteht ein PDF-Satz aus dem Kanon:
  - Spielleitungsheft ohne Lösung
  - Detektivbogen mit Punkterechnung
  - Rollenhefte
  - Indizkarten
  - Stimmkarten
  - Hinweis-Umschläge je Runde und Qualität
  - versiegeltes Auflösungsheft mit Endentabelle
- Wer druckt, sieht nur neutrale Codes. Die Zuordnung steht im Auflösungsheft.
- Alles ist A4, gut lesbar und ohne abgeschnittenen Text. Ein Druckspiel funktioniert ohne App.

7.15 Inhalte und Ton
- Grusel mit Humor: quietschende Türen, Zugluft, flackerndes Licht, verpatzte Streiche.
- Lebensrealität der Gruppe: deutsch, türkisch, polnisch, bosnisch, kurdisch.
  - Kein Motiv hängt an Herkunft, Religion oder Kopftuch. Motive kommen aus der Lage: Geld, Angst, Stolz, Scham, Loyalität.
  - Keine Gruppe trägt allein die Verfehlungen.
- Getränke: Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser und Säfte – so benannt, dass niemand an Alkohol denkt.
- Die drei Lacher der Story gehören festen Rollen:
  - die Ritterrüstung: Selin
  - verlaufen auf dem Weg zur Toilette: neu zu vergeben
  - der verqualmte Kamin: Meryem
- In F0 entsteht ein Ton-Leitfaden für alle Autoren.

## 8. BESTAND UND PRÜFWERKZEUGE
- Vor dem ersten Eingriff machst du eine Bestandsaufnahme und legst sie als Messbasis im Planungsordner ab:
  - Technik und Engine
  - Datenformat der Fälle
  - Teststand, Build und CI
  - Remote und Branch-Schutz
  - Ladegröße
  - Ergebnisse und offene Kriterien früherer Läufe
- Du nutzt und erweiterst die vorhandene Engine. Eine zweite baust du nicht.
- Werkstatt und Gemeindesaal kommen, falls vorhanden, über eine Übernahme ins Kanon-Format. Ihr Verhalten bleibt gleich. Brüche in ihren Daten listest du unter FÜR DEN NUTZER, ohne sie zu beheben.
- Neue Prüfwerkzeuge, alle über den normalen Testbefehl aufrufbar, damit das Team sie später selbst nutzt:
  - Kanon-Validator: Schema und offene Verweise
  - Plausibilitätsprüfer: Tatmatrix, Wege und Wahrnehmungsregeln
  - Fall-Simulator: erschöpfend über Pfad × Entscheidungen × Gruppenergebnisse × Anklage, zusätzlich für jede Personenzahl, deren Besetzung Optionen oder Hinweise verändert
  - Besetzungsprüfer für 4 bis 20 Rollen
  - Textprüfer: Wortgleichheit des Erzählers, Inhaltsregeln, Lesbarkeit, Fachwortliste
  - Spoiler-Prüfer: keine Täterinfo vor dem Finale auf gemeinsamen Bildschirmen und in Detektiv-Unterlagen
  - Farbabstandsprüfer
  - automatisierte Durchläufe mit Bildschirmfotos
  - PDF-Seitenprüfung
  - Netzwerkprüfung und Secret-Scan

## 9. NEBELKARTE
(siehe NEBELKARTE.md, Nr. 1–11 wortgleich übernommen und ergänzt)

## 10. BAUPHASEN
Zu Beginn jeder Bauphase liest du Nordstern, Änderungsprotokoll des Kanons und ABNAHME neu.

F0 – Bestandsaufnahme und Gesamtplan:
- Quellmaterial, Bestand und vorhandene Planungsordner früherer Läufe lesen.
- Arbeitsbaum prüfen, Branch oder Worktree anlegen und als Erstes den Rohchat in .gitignore eintragen.
- Den Stand von origin/main notieren.
- Bestandsaufnahme ablegen.
- Planungsordner anlegen: BRUCHLISTE, ABNAHME, PLAN, STATUS, ENTSCHEIDUNGSLOG, PRÜFPUNKT, FÜR DEN NUTZER.
- BRUCHLISTE: B-01 bis B-17 übernehmen und durch den systematischen Abgleich ergänzen.
- ABNAHME mit F-01 bis F-17 samt Prüfmethode, Schwelle und Beleg anlegen.
- Ton-Leitfaden, Rollenbriefings und den PLAN mit allen Aufträgen, Abhängigkeiten und Phasentoren bis zum Ende schreiben.
- Plan-Schleife: Der Gegenprüfer greift den Plan an, höchstens drei Runden. Dann schreibst du ihn mit Begründung fest.

F1 – Kanon und Tatmatrix: Raumkanon und Raumgraph, Kanon-Schema, Übernahme des JSON; alle Brüche entschieden. Zeitleiste und Tatmatrix für alle vier Pfade, Wahrnehmungsregeln, Plausibilitätsprüfer. Tor: F-01 bis F-05.

F2 – Mechanik und Simulation: Entscheidungsmodell, Gruppenwahl und Wertung, Restverdächtige, Endenmatrix, Fall-Code und Fall-Simulator. Platzhaltertexte reichen. Tor: F-07 sowie F-06 und F-08 mit Platzhaltertexten.

F3 – Inhalte: Dossiers, Pflichtgespräche, Rundenwahl, 36 Bonus-Hinweise, Indiztexte, Erzählerbausteine, Auflösung je Rolle, Namensbalance, Bildprompts. Tor: F-06 mit echten Texten, F-08, F-10, F-11 und F-15.

F4 – Spiel und Bild: Karte nach Raumkanon, Figuren, Indizien je Pfad, Entscheidungen als Interaktionen. Licht, Nebel des Krieges, Rückblende, Spoiler-Schutz und Erzählerausgabe. Spielablauf vom Titel bis zur Auflösung. Tor: F-12 und F-13.

F5 – Druck und Besetzung: PDF-Satz, Besetzungsreihenfolge, alle Personenzahlen durchspielen. Tor: F-09 und F-14.

F6 – Härtung: Gegenprüfung, Spieltests, Bestand, Fehlerbehebung. Tor: F-16; alle bisherigen Kriterien werden erneut belegt.

F7 – Übergabe auf main: Anleitung und Abschlussbericht schreiben. origin holen, in den Arbeitsbranch zusammenführen, alles testen, Secret-Scan. Den Arbeitsbranch in main zusammenführen und pushen. Den Tag setzen und pushen, den Remote-Stand prüfen und die CI abwarten. Tor: F-17.

Ein Phasentor ist bestanden, wenn: alle Tests grün sind, Validator, Plausibilitätsprüfer und Simulator für alle vier Pfade grün sind, die Berichte von Kontinuitätsprüfer, Sensibilitätsleser und Sichtprüfer keine schweren Befunde enthalten, der Bestand grün ist, ein Commit angelegt und der Arbeitsbranch gepusht ist.

## 11. REGELKREISE
- Auftrag: vergeben → bauen → testen → Paketabnahme → integrieren oder nachbessern. Höchstens zwei Nachbesserungen, dann übernimmst du und vermerkst den Grund.
- Paketabnahme mit fünf Prüfungen zu je 0, 1 oder 2 Punkten: Funktion (Tests grün), Kanon-Treue (keine offenen Verweise, kein Widerspruch zur Tatmatrix), Verzahnung (die Regeln aus 7.1 erfüllt), Inhalt (Ton, Inhaltsregeln, Lesbarkeit), Grenzen (Dateihoheit, keine fremden Abrufe). Freigabe ab 8 von 10 Punkten ohne eine 0. Sonst folgt ein Reparaturauftrag mit Fundstellen.
- Auslastung: Solange ein Kriterium offen ist, bleibt kein Agentenplatz leer. Bei Blockaden kommen Vorratsaufträge – zusätzliche Tests, Gegenproben, Varianten –, nie Füllstoff.
- Kanon: Änderungen am Kern macht nur du. Danach laufen Validator, Plausibilitätsprüfer und Simulator für alle vier Pfade.
- Phase: Am Phasentor wird jeder Befund zu einem Auftrag oder begründet verworfen. Nebelkarte und Zielabstand werden aktualisiert.
- Sitzung: Am Ende jedes Arbeitsblocks und vor einer absehbaren Kontextgrenze aktualisierst du STATUS und PRÜFPUNKT. Jede neue Sitzung liest zuerst diese Dateien und setzt exakt dort fort, auch nach einem Nutzungslimit.
- Tagesbericht in STATUS: Stand, Zielabstand, offene Brüche, Plananpassung.
- Lernen: Wiederholt sich ein Fehlertyp, verbesserst du Auftragsvorlage oder Rollenbriefing und vermerkst die Änderung.
- Ziel: Nach jedem Phasentor gleichst du den Stand mit allen F-Kriterien ab; jede Lücke wird zu Aufträgen. Kein Kriterium wird still abgesenkt.
- Gegen Endlosschleifen: höchstens drei Anläufe je Phasentor. Danach wählst du per Denkprotokoll die beste Ersatzlösung, dokumentierst sie unter FÜR DEN NUTZER und machst weiter.

## 12. ABNAHMEKRITERIEN (messbar)
(siehe ABNAHME.md, F-01 bis F-17 wortgleich übernommen mit Prüfmethode, Schwelle und Beleg)

## 13. STATUS UND DISZIPLIN
Jede Antwort beginnt mit:
STAND · Bauphase F[n] von F7 · Abnahme [a] von 17 · Brüche offen [b] · Aufträge [fertig] von [gesamt] · Agenten aktiv [x] · nächster Schritt: […]
- Kein Meta-Gerede, keine Zusammenfassung statt Arbeit, keine simulierten Ergebnisse. Erledigt ist nur, was getestet und integriert ist.
- Sind alle Kriterien erfüllt, folgt der Abschlussbericht. Er enthält einen Beleg je F-Kriterium, den Commit auf main, die Startanleitung und die Liste FÜR DEN NUTZER. Die letzte Zeile lautet ZIEL ERREICHT.

## 14. START
Beginne sofort mit F0: Lies Quellmaterial, Bestand und frühere Planungsordner, prüfe den Arbeitsbaum, lege den Branch an und mach die Bestandsaufnahme. Danach arbeitest du alle Bauphasen ohne Rückfragen bis zum Ziel ab.
