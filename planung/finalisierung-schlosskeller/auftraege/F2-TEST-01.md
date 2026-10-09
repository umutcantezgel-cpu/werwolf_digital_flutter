F2-TEST-01 · Testschreiber · Bauphase F2 · Kanon v1.0 · Schwierigkeit 1

ROLLENBRIEFING TESTSCHREIBER: Du schreibst automatische Tests für eine vorgegebene Schnittstelle. Gute Arbeit: Grenzwerte und Randfälle zuerst, ein Test prüft eine Sache, Testnamen sagen auf Deutsch, was erwartet wird; läuft grün und wird rot, wenn man die geprüfte Regel bricht. Häufigste Fehler: 1) Tests, die nie rot werden können, 2) Umsetzung im Test nachbauen statt Ergebnisse zu prüfen, 3) zufällige oder zeitabhängige Tests.

AUFGABE IN EINEM SATZ: Teste die Gruppenwahl (F-08): Struktur der Wahlen, Schwellen für 4 bis 20 Rollen an den Grenzwerten und die 36 Bonus-Hinweise.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: packages/mordakte_core/test/party/gruppenwahl_test.dart

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
1. Test „je Rolle und Runde genau eine Wahl“: für jede der 20 Figuren und jede Runde 1–3 genau ein Eintrag in Gruppenwahl(kanon).wahlen mit Optionen a und b; quelle ist geheimnis oder loyalitaet; quelle loyalitaet nur bei Figuren mit loyalitaet.zu; genau die vier Kernrollen (fall.json kernverdaechtige) haben bTaeter mit art sabotage.
2. Test „Schwellen an den Grenzwerten 4 bis 20“: für jede Rollenzahl n von 4 bis 20 prüfe die kleinste Stimmenzahl, die wahr ergibt, und die kleinste für neutral, gegen eine FESTE Tabelle, die du aus der Regel im Master (wahr, wenn 5·A ≥ 3·N; neutral, wenn 5·A ≥ 2·N) von Hand ausrechnest und als Literal in den Test schreibst (17 Zeilen n → (minNeutral, minWahr)); zusätzlich prüfst du jeweils A−1 (darf die Stufe nicht erreichen). Keine Formel im Test.
3. Test „Qualität 0 und alle Stimmen“: 0 kooperative Stimmen ergeben bei jedem n falsch, n Stimmen ergeben wahr.
4. Test „36 Hinweise, je Pfad, Runde und Qualität genau einer“: zähle über Gruppenwahl(kanon).hinweise; hinweis(pfad, runde, q) liefert genau diesen.
5. Test „jeder Hinweis ist über eine Stimmverteilung erreichbar“: zu jedem der 36 gibt es ein n (4–20), eine Zahl kooperativer Stimmen ohne Täterrolle (0 bis n−1) und taeterSabotiert (ja/nein), sodass auswerten(...) seine Qualität ergibt.
6. Test „sichtbar ist nur, ob die Gruppe zusammengehalten hat“: zusammengehalten ist nur bei wahr true.
7. Test „Wirkung maschinenlesbar“: jede wirkung hat art belastet, entlastet oder neutral; bei belastet und entlastet eine Person aus den Kernverdächtigen; neutral ohne Person.
8. Rot-Probe als eigener Test „erkennt veränderte Schwelle“: Lade einen Kanon, in dem fall.json schwellen.wahr.gegen auf 4 gesetzt ist, und zeige, dass qualitaet(3, 5) dann nicht mehr wahr ist (im echten Kanon ist es wahr).

ABNAHMEKRITERIEN UND TESTWEG: Mindestens 8 Tests, alle grün; die Tabelle in Schritt 2 hat 17 Zeilen; die Rot-Probe läuft. Befehle: dart analyze test ; dart test <deine Dateien> (im Ordner packages/mordakte_core).

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F2-TEST-01
- Geänderte Dateien: <Liste>
- Anzahl Tests: <Zahl je Datei>
- Analyse: <letzte Zeile der Ausgabe>
- Tests: <letzte Zeile der Ausgabe>
- Rot-Proben: <je Probe: was manipuliert, welcher Test rot>
- Tabelle n → (minNeutral, minWahr): <17 Einträge>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Mengen gezählt? Nur eigene Dateien angelegt (git status zeigt nur sie als neu)? Tests gelaufen? Jede Prüfung kann rot werden?
Letzte Zeile exakt: === ENDE F2-TEST-01 · BEREIT ZUR RÜCKGABE ===
