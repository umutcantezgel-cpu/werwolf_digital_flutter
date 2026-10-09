F4-TEST-01 · Testschreiber · Bauphase F4 · Kanon v1.0 · Schwierigkeit 2

## Testschreiber
- **Aufgabe:** schreibt automatische Tests für eine vorgegebene Schnittstelle.
- **Gute Arbeit:** Grenzwerte und Randfälle zuerst, ein Test prüft eine Sache, Testnamen sagen auf Deutsch, was erwartet wird; läuft grün und wird rot, wenn man die geprüfte Regel bricht.
- **Häufigste Fehler:** 1) Tests, die nie rot werden können, 2) Umsetzung im Test nachbauen statt Ergebnisse zu prüfen, 3) zufällige oder zeitabhängige Tests.

AUFGABE IN EINEM SATZ: Schreibe den Test, dass Spiel, Dossier und Bildprompt jede Figur aus denselben Kanon-Feldern zeigen (F-13 figuren_konsistenz_test).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: packages/mordakte_core/test/party/figuren_konsistenz_test.dart

WERKZEUG: Du arbeitest direkt im Repo /home/user/werwolf_digital_flutter. Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core . Testhilfe test/party/kanon_hilfe.dart (repoWurzel, leseJson, ladeKanon, kanon) – nur benutzen. Stil wie test/party/*.dart (erste Zeile Kommentar mit dem Kriterium, deutsche Testnamen).
Lies vor dem Schreiben: lib/src/party/szenario_export.dart (partySzenarioJson, renderLook, partyNpcKennungen), lib/src/party/bildprompts.dart, lib/src/party/farbe.dart, content/party/schlosskeller/figuren.json, bild.json, bildprompts.json, farbnamen.json, test/party/bildprompt_test.dart, test/party/farbabstand_test.dart, test/party/figuren_abgleich_test.dart (nicht doppeln, was dort schon steht).
Vorlage des Renderer-Szenarios: leseJson('$repoWurzel/content/scenarios/ravensmoor.json').

GRENZEN: Ändere NUR deine eigenen Dateien (Liste oben); lege keine weiteren an. Keine anderen Dateien, kein Kanon, kein pubspec, kein `flutter pub get`, keine neuen Abhängigkeiten, kein Netz. Keine Git-Befehle außer git status und git diff (nur lesen). Nichts außerhalb des Repos schreiben (außer System-Temp). Andere Agenten arbeiten gleichzeitig im selben Repo an anderen Dateien: fasse sie nicht an; sind deren Dateien gerade unfertig oder rot, ist das nicht dein Befund – prüfe nur deine eigenen Dateien. Zeigt „Waiting for another flutter command to release the startup lock“, einfach warten. Spoilerschutz (E-008): Vor dem Finale verrät dein Bildschirm nie, wer der Täter ist – außer in der verdeckten Ansicht der Täterrolle selbst. Nie eine Stimmenzahl, nie die Qualität eines Hinweises anzeigen.

ARBEITSSCHRITTE:
1. Renderer: Für jede Person aus kanon.personen außer dem Detektiv gibt es in partySzenarioJson(kanon, vorlage)['suspects'] genau einen Eintrag mit der Kennung aus partyNpcKennungen; name.de == figur['name'], look.coat == figur['colorCode'], look.skin/hair == figur.look.haut/haar (wenn vorhanden), look.build == look.statur, look.outfit == look.schnitt; Position = Ermittlungsort (floor der Ort-Koordinaten).
2. Detektiv: renderLook(detektiv) hat coat == colorCode des Detektivs und hat 'fedora' für kopf 'detektivhut'.
3. Kopftuch: Figuren mit look.kopftuchFarbe haben im Renderer headColor gleich diesem Wert; Figuren ohne haben keinen headColor.
4. Bildprompt: Für jede Figur enthält ihr Prompt in bildprompts.json den englischen Farbnamen, den farbnamen.json für ihren colorCode nennt, und keinen Farbnamen einer anderen Figur desselben Startraums, der ihr zugeordnet wäre (lies die Struktur der Dateien; teste nur, was die Dateien wirklich hergeben).
5. Deutscher Farbname: figur['farbname'] ist nicht leer und für jede Figur verschieden von dem Farbnamen jeder anderen Figur mit einem anderen colorCode.
6. Dossier-Rückbindung: Kommt in Dossier- oder Täterfassungstexten (content/party/schlosskeller/texte/dossiers-*.json, taeter-*.json; Felder wer, weiss, verbirgt) ein Kleidungsfarbwort der eigenen Figur vor (Wortstamm aus figur['farbname'], kleingeschrieben), dann nur mit diesem Stamm – nie mit dem Farbnamen einer anderen Figur desselben Startraums für die eigene Kleidung. Wenn das nicht sauber prüfbar ist, schreibe stattdessen: Jede Figur, die ein Dossier hat, hat einen farbname, und dieser steht nie im Dossier einer anderen Figur als deren eigene Farbe. Dokumentiere die Wahl im Bericht.
7. Rot-Proben: Kanon mit verändertem colorCode einer Figur (Kanon.lade mit gezielt geändertem figuren.json) → Renderer-Test findet die Abweichung nicht, aber der Bildprompt-Test (gegen die unveränderte bildprompts.json) wird rot. Belege mindestens zwei Rot-Proben.

ABNAHMEKRITERIEN UND TESTWEG:
- `dart analyze test` (im Ordner packages/mordakte_core) → No issues found.
- `dart test test/party/figuren_konsistenz_test.dart` → alle grün.
- Mindestens 7 Tests; jeder Test kann rot werden (Rot-Probe im Bericht belegen: was du kurz verändert hast und dass der Test dann rot war; die Veränderung danach zurücknehmen).

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 700 Wörter):
## Ergebnis F4-TEST-01
- DATEIEN: Liste mit Zeilenzahl
- UMGESETZT: je Arbeitsschritt eine Zeile (Nr. → was, wo)
- TESTS: Anzahl, Ausgabe der letzten Zeile von flutter test
- ANALYSE: letzte Zeile von flutter analyze
- ROT-PROBEN: je Probe eine Zeile
## OFFENE FRAGEN
- (oder „keine“)

SELBSTPRÜFUNG: Alle Schritte umgesetzt? Nur eigene Dateien geändert (git status zeigt nur sie)? Jeder sichtbare Text aus Bausteinen? Tests und Analyse gelaufen und grün? Spoilerschutz eingehalten?
Letzte Zeile exakt: === ENDE F4-TEST-01 · BEREIT ZUR RÜCKGABE ===
