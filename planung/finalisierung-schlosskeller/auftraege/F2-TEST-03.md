F2-TEST-03 · Testschreiber · Bauphase F2 · Kanon v1.0 · Schwierigkeit 1

ROLLENBRIEFING TESTSCHREIBER: Du schreibst automatische Tests für eine vorgegebene Schnittstelle. Gute Arbeit: Grenzwerte und Randfälle zuerst, ein Test prüft eine Sache, Testnamen sagen auf Deutsch, was erwartet wird; läuft grün und wird rot, wenn man die geprüfte Regel bricht. Häufigste Fehler: 1) Tests, die nie rot werden können, 2) Umsetzung im Test nachbauen statt Ergebnisse zu prüfen, 3) zufällige oder zeitabhängige Tests.

AUFGABE IN EINEM SATZ: Teste die Lösbarkeit und Fairness des Entscheidungsmodells (F-06) erschöpfend über alle Pfade, Optionsfolgen, Gruppenergebnisse und Anklagen.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: packages/mordakte_core/test/party/simulator_test.dart

WERKZEUG: Du arbeitest direkt im Repo /home/user/werwolf_digital_flutter (kein eigener Arbeitsbaum). Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core . Die Kanon-Dateien liegen unter content/party/schlosskeller/ (nur lesen). Testhilfe: test/party/kanon_hilfe.dart (repoWurzel, leseJson(pfad), ladeKanon(), kanon, pruefer) – nur benutzen. Ein Kanon mit veränderten Daten für Rot-Proben entsteht so: Kanon.lade((p) { final j = leseJson('$repoWurzel/content/party/schlosskeller/$p'); /* j gezielt ändern */ return j; }).
VORHANDENE API (package:mordakte_core/mordakte_core.dart, nur benutzen, nicht ändern):
- Ermittlung(kanon): fakten (Map<String, Fakt> mit id, typ, personen, beobachtung, spur), entscheidungen (9, sortiert nach runde, nr; Entscheidung mit id, runde, nr, art, frage, optionen (EntscheidungsOption id, text, ziel, fakten), richtig (Map pfad→optionId), begruendungFuer(pfad)), regeln, runde(r), entscheidung(id), faktPfade(faktId), gibtEs(faktId, pfad), faktenVon(optionId, pfad) → Set<String>, aufdecken(optionId, pfad) → List<Aufdeckung(fakt, entstanden, text)>, istRichtig(entscheidungId, optionId, pfad), bestesSpiel(pfad) → List<String> Options-Kennungen, stand(faktIds) → Map<person, Set<typ>>, restmenge(faktIds) → Set<String>, spurJson(id), beobachtungJson(id).
- Gruppenwahl(kanon): qualitaet(kooperativ, rollen) → Qualitaet (enum wahr, neutral, falsch), static wirksam({kooperativ, sabotage}), auswerten({rollen, kooperativ, taeterSabotiert}) (kooperativ = A-Stimmen OHNE Täterrolle), static zusammengehalten(q), wahlen (List<Map>), wahl(rolle, runde), hinweise (List<Map>), hinweis(pfad, runde, q).
- Enden(kanon): regeln (EndeRegel id, name, richtig, punkteVon, punkteBis), passend(punkte, richtig), ende(punkte, richtig) (wirft StateError, wenn nicht eindeutig).
- FallCode: static lesen(eingabe) → FallCode?, FallCode.zufall(Rng), code, seed, rng(), pfad(pfade), static fuerPfad(ziel, pfade), alphabet, laenge. Rng(seed) aus package:mordakte_core.
- Besetzung(kanon): besetzt(n), istBesetzt(rolle, n), npc(n), partner(wunsch, n, sprecher:), ersatz, Besetzung.detektiv == 'detective'.
- Spiel(kanon): phase (enum PartyPhase titel, einrichtung, rollen, intro, gespraeche, entscheidungen, gruppenwahl, bonus, resuemee, anklage, finale, aufloesung, ende), einrichten(Einstellungen(rollen:, detektiv: 'm'|'w', code:)), weiter(), waehle(entscheidungId, optionId), abstimmen(kooperativ:, taeterSabotiert:), anklagen(person), pfad, runde, punkte, ende (EndeRegel), bausteine (List<String>), bekannteFakten([bis]), restmenge([bis]).
- Simulator(kanon): folgen() (alle 768 Optionsfolgen), verlauf(pfad, optionen) → Verlauf(optionen, punkte, richtigJeRunde, restNachRunde (3 Mengen), fakten, rest), auszaehlen() → Map<pfad, PfadBericht(enden, punkte, restGroesse, spiele, rateEnden, rateTreffer, kuerzerAlsBest)>, pruefe() → List<String> Verstöße, pruefeBegruendungen(), pruefeSchwellen().
Lies vor dem Schreiben: lib/src/party/entscheidungen.dart, gruppenwahl.dart, enden.dart, fall_code.dart, ablauf.dart, simulator.dart und content/party/schlosskeller/fall.json, entscheidungen.json, bonus.json, gruppenwahl.json, figuren.json, besetzung.json. Hintergrund: planung/finalisierung-schlosskeller/ENTSCHEIDUNGSLOG.md Abschnitt E-024.
Stil: wie test/party/*.dart (deutsche Testnamen und Kommentare, kurz; erste Zeile ein Kommentar mit dem Kriterium, z. B. „// F-08: …“). Analyse muss sauber sein: dart analyze test.
GRENZEN: Lege NUR deine eigenen Dateien an (Liste oben). Keine anderen Dateien ändern, keine Kanon-Dateien, kein pubspec, keine Abhängigkeiten. Kein Netz. Keine Git-Befehle außer git status und git diff (nur lesen). Nichts außerhalb des Repos schreiben (außer System-Temp). Tests dürfen nicht zufällig oder zeitabhängig sein (Rng mit festem Seed ist erlaubt). Andere Agenten schreiben gleichzeitig andere Testdateien im selben Ordner: fasse deren Dateien nicht an, und wenn deren Tests rot sind, ist das nicht dein Befund – führe für deine Abnahme nur deine eigenen Dateien aus.

ARBEITSSCHRITTE:
1. Test „Simulator ohne Verstoß“: Simulator(kanon).pruefe() und pruefeSchwellen() sind leer (Fehlermeldung listet die Verstöße); Laufzeit unter 60 Sekunden (Stopwatch, Erwartung im Test).
2. Test „bestes Spiel: 9 Punkte, nach Runde 2 genau zwei, am Ende genau die Täterperson“: für jeden Pfad verlauf(pfad, ermittlung.bestesSpiel(pfad)).
3. Test „0 richtige → mindestens 2 Restverdächtige“: über alle folgen() mit punkte == 0 in jedem Pfad.
4. Test „Hinweise ändern die Restmenge nie (W-1 scharf)“: für jeden Pfad und jede Folge ist restmenge(fakten ∪ Kennungen aller 36 Hinweise) gleich restmenge(fakten); zusätzlich ausdrücklich der Fall 0 richtige mit den drei wahren Hinweisen des Pfads.
5. Test „für jede Zahl richtiger Entscheidungen gilt dasselbe“: gruppiere nach punkte 0–9 und prüfe Schritt 4 je Gruppe (Ergebnis je Gruppe zählen, jede vorkommende Gruppe hat mindestens eine Folge).
6. Test „Runde 1 und 2 richtig → genau zwei nach Runde 2“: alle Folgen mit richtigJeRunde[0] == 3 und richtigJeRunde[1] == 3.
7. Test „die Täterperson scheidet nie aus“: in jeder Folge jedes Pfads ist pfad in jeder restNachRunde.
8. Test „Rate-Enden werden getrennt gezählt“: auszaehlen(): je Pfad ist die Summe der enden gleich spiele (768 × 4), rateEnden > 0, und rateEnden zählt genau die Anklagen außerhalb der Restmenge (unabhängig nachgezählt über folgen()).
9. Test „Optionen mit 0 Punkten zeigen weder Schlüsselbeweis noch Zusatzindiz (D-1)“.
10. Test „jede falsche Fährte belastet einen Unschuldigen und wird durch eine im Pfad richtige Entscheidung widerlegt“.
11. Test „bestes Spiel deckt jedes Nebendelikt auf“: stand(fakten) des besten Spiels enthält für alle vier Kernpersonen nebendelikt.
12. Test „keine Entscheidung deckt Falsches auf“: für jede Option und jeden Pfad: jede Aufdeckung mit entstanden == true hat gibtEs(fakt, pfad) == true; jede mit entstanden == false ist die harmlose Fassung (spurJson(spur)['harmlos']) einer Spur, die es in diesem Pfad nicht gibt.
13. Test „Begründungsketten nutzen nur Vorwissen“: pruefeBegruendungen() ist leer.
14. Rot-Proben als eigene Tests: (a) Kanon, in dem in entscheidungen.json bei e3_2 richtig.fatma auf e3_2_kerzenstaender gesetzt ist → pruefe() ist nicht leer; (b) Kanon, in dem ein falscher Hinweis (qualitaet falsch) als wirkung die Täterperson seines Pfads belastet → pruefe() meldet es.

ABNAHMEKRITERIEN UND TESTWEG: Mindestens 15 Tests, alle grün, Laufzeit der Datei unter 60 Sekunden; beide Rot-Proben laufen. Befehle: dart analyze test ; dart test <deine Dateien> (im Ordner packages/mordakte_core).

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F2-TEST-03
- Geänderte Dateien: <Liste>
- Anzahl Tests: <Zahl je Datei>
- Analyse: <letzte Zeile der Ausgabe>
- Tests: <letzte Zeile der Ausgabe>
- Rot-Proben: <je Probe: was manipuliert, welcher Test rot>
- Laufzeit der Datei: <Sekunden>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Mengen gezählt? Nur eigene Dateien angelegt (git status zeigt nur sie als neu)? Tests gelaufen? Jede Prüfung kann rot werden?
Letzte Zeile exakt: === ENDE F2-TEST-03 · BEREIT ZUR RÜCKGABE ===
