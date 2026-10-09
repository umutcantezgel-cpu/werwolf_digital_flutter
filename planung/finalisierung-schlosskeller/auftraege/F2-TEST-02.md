F2-TEST-02 · Testschreiber · Bauphase F2 · Kanon v1.0 · Schwierigkeit 1

ROLLENBRIEFING TESTSCHREIBER: Du schreibst automatische Tests für eine vorgegebene Schnittstelle. Gute Arbeit: Grenzwerte und Randfälle zuerst, ein Test prüft eine Sache, Testnamen sagen auf Deutsch, was erwartet wird; läuft grün und wird rot, wenn man die geprüfte Regel bricht. Häufigste Fehler: 1) Tests, die nie rot werden können, 2) Umsetzung im Test nachbauen statt Ergebnisse zu prüfen, 3) zufällige oder zeitabhängige Tests.

AUFGABE IN EINEM SATZ: Teste die Endenmatrix und den Determinismus (F-07): jede Kombination aus Punkten und Anklage führt zu genau einem Ende, jedes Ende ist in jedem Pfad erreichbar, und gleicher Fall-Code mit gleichen Eingaben ergibt 1.000 Mal dasselbe Ende und dieselbe Bausteinfolge.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: packages/mordakte_core/test/party/enden_test.dart, packages/mordakte_core/test/party/determinismus_test.dart

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
1. enden_test.dart, Test „jede Kombination ergibt genau ein Ende“: für Punkte 0–9 und Anklage richtig/falsch hat Enden(kanon).passend(...) genau ein Element.
2. Test „Endenmatrix wie im Master“: feste Literal-Tabelle: richtig 7–9 → ende_meister, richtig 0–6 → ende_teilerfolg, falsch 4–9 → ende_justizirrtum, falsch 0–3 → ende_eskalation (alle 20 Kombinationen einzeln geprüft).
3. Test „jedes Ende in jedem Pfad erreichbar“: mit Simulator(kanon).folgen() und verlauf(pfad, folge) für jeden Pfad alle vier Enden über eine passende Anklage finden.
4. Rot-Probe „erkennt überlappende Matrix“: Kanon mit fall.json enden.matrix, in der ende_teilerfolg bis 7 reicht → passend(7, true) hat 2 Elemente und ende(7, true) wirft StateError.
5. determinismus_test.dart, Test „gleicher Code, gleicher Pfad“: 1.000 Codes aus FallCode.zufall(Rng(20261009)); für jeden: zweimal lesen(code.code) ergibt gleichen seed und gleichen pfad(kanon.pfade).
6. Test „Codes verteilen sich auf alle vier Pfade“: unter diesen 1.000 Codes kommt jeder Pfad mindestens 150 Mal vor.
7. Test „Eingabe wird normalisiert“: lesen mit Kleinbuchstaben, Leerzeichen und Bindestrich ergibt denselben Code; lesen mit falscher Länge oder Zeichen außerhalb von FallCode.alphabet (z. B. „O“, „0“, „1“) ergibt null.
8. Test „fuerPfad trifft den Pfad“: für jeden der vier Pfade gilt fuerPfad(p, pfade).pfad(pfade) == p.
9. Test „1.000 Wiederholungen: gleiches Ende und gleiche Bausteinfolge“: eine Hilfsfunktion spielt ein ganzes Spiel mit Spiel(kanon) von titel bis ende: einrichten(Einstellungen(rollen: 7, detektiv: 'w', code: …)), dann weiter() durch alle Abschnitte; in jeder Entscheidungsrunde je Entscheidung eine Option, die aus einem Rng mit festem Seed gewählt wird; abstimmen mit aus demselben Rng gewählten Werten; anklagen mit einer aus dem Rng gewählten Kernperson. Spiele denselben Ablauf (gleicher Code, gleicher Seed) 1.000 Mal und prüfe: ende.id und die Liste bausteine sind jedes Mal gleich wie beim ersten Lauf.
10. Test „verschiedene Codes, je eigener Ablauf deterministisch“: 200 verschiedene Codes mit je eigenem Seed, jeder zweimal gespielt → gleiche Ergebnisse.
11. Rot-Probe: zeige mit einem Test, dass zwei verschiedene Eingabefolgen (anderer Seed) bei mindestens einem Code verschiedene bausteine ergeben (der Vergleich kann also scheitern).

ABNAHMEKRITERIEN UND TESTWEG: Mindestens 11 Tests über beide Dateien, alle grün; Laufzeit der beiden Dateien zusammen unter 60 Sekunden; Rot-Proben laufen. Befehle: dart analyze test ; dart test <deine Dateien> (im Ordner packages/mordakte_core).

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F2-TEST-02
- Geänderte Dateien: <Liste>
- Anzahl Tests: <Zahl je Datei>
- Analyse: <letzte Zeile der Ausgabe>
- Tests: <letzte Zeile der Ausgabe>
- Rot-Proben: <je Probe: was manipuliert, welcher Test rot>
- Laufzeit: <Sekunden>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Mengen gezählt? Nur eigene Dateien angelegt (git status zeigt nur sie als neu)? Tests gelaufen? Jede Prüfung kann rot werden?
Letzte Zeile exakt: === ENDE F2-TEST-02 · BEREIT ZUR RÜCKGABE ===
