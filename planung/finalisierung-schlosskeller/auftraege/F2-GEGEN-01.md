F2-GEGEN-01 · Gegenprüfer · Bauphase F2 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING GEGENPRÜFER: Du greifst ein fertiges Teil an, als wärst du eine Spielerin, die gewinnen will, ohne nachzudenken, oder eine, die den Täter vorab herausfinden will. Gute Arbeit: findet konkrete Wege mit Schritten, belegt jeden mit Datei und Kennung, schätzt die Schwere ein und schlägt die kleinste Korrektur vor. Häufigste Fehler: 1) Geschmacksurteile statt Angriffe, 2) Befunde ohne Fundstelle, 3) Korrekturen, die eine andere Regel brechen.

AUFGABE IN EINEM SATZ: Greife das Entscheidungsmodell, die Bonus-Hinweise und die Gruppenwahl an: Abkürzungen, Spoiler vor dem Finale, erkennbare Täterwahl, Raten und Begründungsketten, die nicht tragen.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Vor dart-Befehlen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; dann cd packages/mordakte_core. Simulator: dart run bin/party_simulate.dart (Bericht und Prüfung). Lies: content/party/schlosskeller/entscheidungen.json, bonus.json, gruppenwahl.json, fall.json, beobachtungen.json, gegenstaende.json, figuren.json (Felder luegen, nebendelikt, visualSpecs), STORY-BIBEL.md Kapitel 8–10; Code lib/src/party/entscheidungen.dart, gruppenwahl.dart, simulator.dart, erzaehler.dart, ablauf.dart; planung/finalisierung-schlosskeller/ENTSCHEIDUNGSLOG.md Abschnitt E-024 (Modell und Begründung) und ABNAHME.md Zeilen F-06 bis F-09.

GRENZEN: Nur lesen. Keine Datei ändern oder anlegen (außer im System-Temp), keine Git-Schreibbefehle, kein Netz. Zitiere Kanon-Stellen nur kurz mit Datei und Kennung.

ARBEITSSCHRITTE (je Punkt mindestens eine konkrete Angriffsprobe, auch wenn sie scheitert):
1. Abkürzungen: Gibt es einen Weg zur Lösung mit wenigen richtigen Entscheidungen oder über Wissen, das die formale Restmenge nicht zählt (Abwesenheit einer Spur, harmlose Fassungen in gegenstaende.json, Alibis ohne Nebendelikt)? Denke wie ein Mensch, nicht wie der Simulator.
2. Spoiler vor dem Finale: Was unterscheidet sich zwischen den Pfaden, bevor der Detektiv etwas aufdeckt (Fragen, Optionen, Karte, Erzähler-Bausteine in erzaehler.dart, Rahmen und Satzform der Hinweise in bonus.json)? Kann jemand aus der Satzform eines Hinweises seine Qualität erkennen?
3. Erkennbare Täterwahl: Kann die Gruppe aus der sichtbaren Angabe „zusammengehalten oder nicht“ auf die Sabotage der Täterrolle schließen, bei kleinen Rollenzahlen (4–7) besonders? Rechne Beispiele mit fall.json schwellen und Gruppenwahl.auswerten.
4. Raten: Wie viele Punkte bringt Raten in Runde 1, 2, 3? Gibt es eine Option, die in den meisten Pfaden richtig ist und deshalb ohne Nachdenken gewählt wird?
5. Begründungsketten: Prüfe jede Kette in entscheidungen.json gegen den Pfad. Trägt sie wirklich zur richtigen Option und nicht ebenso gut zur falschen? Nenne jede Kette, bei der beide Optionen gleich gut begründet wären.
6. Fair Play: Lügt das Spiel irgendwo mit eigener Stimme (Fakt, Hinweis-Rahmen, Begründung)? Ist jede falsche Fährte widerlegbar und belastet sie einen Unschuldigen?
7. Gruppenwahl: Hat jede Option echte Kosten? Gibt es eine Rolle, für die B immer besser ist?

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 1.800 Wörter):
## Bericht F2-GEGEN-01
| Nr | Bereich | Angriff (Schritte) | Fundstelle | Ergebnis | Schwere (leicht/mittel/schwer) | kleinste Korrektur |
## OFFENE FRAGEN

SELBSTPRÜFUNG: Alle sieben Punkte angegriffen? Jede Zeile mit Fundstelle? Keine Datei geändert?
Letzte Zeile exakt: === ENDE F2-GEGEN-01 · BEREIT ZUR RÜCKGABE ===
