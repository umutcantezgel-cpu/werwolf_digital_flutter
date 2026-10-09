F2-FALL-01 · Fallrechner · Bauphase F2 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING FALLRECHNER: Du fährst den Simulator und liest die Zahlen wie ein Spielleiter, der wissen will, ob der Abend fair und spannend wird. Gute Arbeit: nennt Verteilungen mit Zahlen, sucht Abkürzungen und einfache Ratestrategien, vergleicht die vier Pfade, trennt Messung von Meinung. Häufigste Fehler: 1) Zahlen ohne Deutung, 2) Deutung ohne Zahlen, 3) Vorschläge, die eine Abnahmeregel brechen.

AUFGABE IN EINEM SATZ: Fahre den Simulator, werte Verteilungen, Abkürzungen und Schwierigkeit je Pfad aus und schlage höchstens fünf begründete Änderungen vor.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Vor dart-Befehlen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; dann cd packages/mordakte_core. Simulator: dart run bin/party_simulate.dart (Bericht und Prüfung). Lies: content/party/schlosskeller/entscheidungen.json, bonus.json, gruppenwahl.json, fall.json, beobachtungen.json, gegenstaende.json, figuren.json (Felder luegen, nebendelikt, visualSpecs), STORY-BIBEL.md Kapitel 8–10; Code lib/src/party/entscheidungen.dart, gruppenwahl.dart, simulator.dart, erzaehler.dart, ablauf.dart; planung/finalisierung-schlosskeller/ENTSCHEIDUNGSLOG.md Abschnitt E-024 (Modell und Begründung) und ABNAHME.md Zeilen F-06 bis F-09.

GRENZEN: Nur lesen. Keine Datei ändern oder anlegen (außer im System-Temp), keine Git-Schreibbefehle, kein Netz. Zitiere Kanon-Stellen nur kurz mit Datei und Kennung.

ARBEITSSCHRITTE:
1. Simulator laufen lassen, Ausgabe vollständig übernehmen (als Codeblock).
2. Je Pfad: Verteilung der Punkte, der Enden und der Restmenge nach Runde 3 in einer Tabelle; Unterschiede zwischen den Pfaden benennen.
3. Abkürzungen: Welche Entscheidungen allein reichen für eine Restmenge von 1? Wie viele Optionsfolgen mit weniger als 9 Punkten enden mit Restmenge 1, und woran liegt es? Prüfe ausdrücklich e3_2.
4. Ratestrategien ohne Nachdenken, je Pfad ausgerechnet (über verlauf() oder von Hand aus entscheidungen.json): immer die erste Option; immer die Option mit Person; immer „Kerzenständer“ in e3_2; Runde 1 richtig, Rest geraten. Welche Punktzahl und welches Ende ergibt sich bei richtiger Anklage?
5. Schwierigkeit: Wie viele Punkte braucht man für Meister-Detektiv, und wie wahrscheinlich ist das bei zufälligem Wählen (Anteil der Folgen mit ≥ 7)? Ist das für eine Party passend?
6. Bonus-Hinweise: Lies bonus.json. Wie stark verschiebt ein wahrer Hinweis je Runde die menschliche Einschätzung (nicht die formale Restmenge)? Gibt es einen Pfad, in dem die Hinweise deutlich mehr verraten als in anderen?
7. Höchstens fünf Vorschläge mit Zahl, Fundstelle und Wirkung auf die Abnahmekriterien F-06 bis F-08.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 1.800 Wörter):
## Bericht F2-FALL-01
### Simulator-Ausgabe
### Verteilungen je Pfad
### Abkürzungen
### Ratestrategien
### Schwierigkeit
### Bonus-Hinweise
### Vorschläge
| Nr | Fundstelle | Befund mit Zahl | Vorschlag | Wirkung auf F-06–F-08 |
## OFFENE FRAGEN

SELBSTPRÜFUNG: Alle vier Pfade betrachtet? Jede Aussage mit Zahl oder Fundstelle? Keine Datei geändert?
Letzte Zeile exakt: === ENDE F2-FALL-01 · BEREIT ZUR RÜCKGABE ===
