F2-TEST-04 · Testschreiber · Bauphase F2 · Kanon v1.0 · Schwierigkeit 1

ROLLENBRIEFING TESTSCHREIBER: Du schreibst automatische Tests für eine vorgegebene Schnittstelle. Gute Arbeit: Grenzwerte und Randfälle zuerst, ein Test prüft eine Sache, Testnamen sagen auf Deutsch, was erwartet wird; läuft grün und wird rot, wenn man die geprüfte Regel bricht. Häufigste Fehler: 1) Tests, die nie rot werden können, 2) Umsetzung im Test nachbauen statt Ergebnisse zu prüfen, 3) zufällige oder zeitabhängige Tests.

AUFGABE IN EINEM SATZ: Teste die Dilemma-Regeln der Gruppenwahl: jede Option hat Kosten und Nutzen aus Geheimnis oder Loyalität, keine Option ist für eine Rolle in allen Runden kostenlos, und Sabotage zählt netto −1.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: packages/mordakte_core/test/party/gruppenwahl_dilemma_test.dart

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
1. Test „Option A kostet die Rolle etwas und hilft der Gruppe“: für alle 60 Wahlen: a.kosten.art ist geheimnis, freund oder ziel; a.nutzen.art ist gruppe.
2. Test „Option B nützt der Rolle und kostet die Gruppe“: b.kosten.art ist gruppe; b.nutzen.art ist ziel oder freund.
3. Test „Sabotage nur in der Täterfassung der Kernrollen“: bTaeter gibt es genau bei den vier Kernrollen in allen drei Runden, mit art sabotage, kosten.art gruppe und nutzen.art tarnung.
4. Test „keine Option ist für eine Rolle in allen drei Runden kostenlos“: für jede Rolle und jede Option (a, b, bTaeter) ist kosten in jeder Runde vorhanden und nicht leer; zusätzlich: für jede Rolle ist a.kosten.art in keiner Runde gruppe.
5. Test „Bezüge stimmen“: bei quelle loyalitaet zeigt a.kosten.bezug und b.nutzen.bezug auf loyalitaet.zu der Figur aus figuren.json; bei quelle geheimnis zeigt a.kosten.bezug auf das Nebendelikt der Figur (gegenstaende.json nebendelikte, Feld person) oder, wenn sie keins hat, auf persoenlichesZiel.
6. Test „Sabotage zählt netto −1“: für n von 4 bis 20 und jede Zahl k kooperativer Stimmen ohne Täterrolle von 1 bis n−1: Gruppenwahl.wirksam(kooperativ: k, sabotage: true) ist k−1; und auswerten(rollen: n, kooperativ: k, taeterSabotiert: true) ist gleich qualitaet(k − 1, n), während taeterSabotiert: false gleich qualitaet(k + 1, n) ist. Bei k = 0 bleibt wirksam 0.
7. Test „Sabotage kann ein wahres Ergebnis kippen“: finde mit festen Literalen ein Beispiel (z. B. n = 5, k = 2), bei dem die kooperative Täterstimme wahr ergibt und Sabotage nicht; schreibe die Werte als Literal in den Test.
8. Rot-Probe als eigener Test: Lade einen Kanon, in dem bei einer Wahl a.kosten.art auf gruppe gesetzt ist, und zeige, dass deine Prüffunktion aus Schritt 1 (als Funktion im Test, die die Wahlen-Liste bekommt) den Verstoß meldet.

ABNAHMEKRITERIEN UND TESTWEG: Mindestens 8 Tests, alle grün; Rot-Probe läuft; 60 Wahlen gezählt. Befehle: dart analyze test ; dart test <deine Dateien> (im Ordner packages/mordakte_core).

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F2-TEST-04
- Geänderte Dateien: <Liste>
- Anzahl Tests: <Zahl je Datei>
- Analyse: <letzte Zeile der Ausgabe>
- Tests: <letzte Zeile der Ausgabe>
- Rot-Proben: <je Probe: was manipuliert, welcher Test rot>
- Gezählte Wahlen: <Zahl>; Kernrollen mit bTaeter: <Liste>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Mengen gezählt? Nur eigene Dateien angelegt (git status zeigt nur sie als neu)? Tests gelaufen? Jede Prüfung kann rot werden?
Letzte Zeile exakt: === ENDE F2-TEST-04 · BEREIT ZUR RÜCKGABE ===
