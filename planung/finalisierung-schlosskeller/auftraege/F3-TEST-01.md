F3-TEST-01 · Testschreiber · Bauphase F3 · Kanon v1.0 · Schwierigkeit 3

ROLLENBRIEFING TESTSCHREIBER: Du schreibst automatische Tests für eine vorgegebene Schnittstelle. Gute Arbeit: Grenzwerte und Randfälle zuerst, ein Test prüft eine Sache, Testnamen sagen auf Deutsch, was erwartet wird; läuft grün und wird rot, wenn man die geprüfte Regel bricht. Häufigste Fehler: 1) Tests, die nie rot werden können, 2) Umsetzung im Test nachbauen statt Ergebnisse zu prüfen, 3) zufällige oder zeitabhängige Tests.

AUFGABE IN EINEM SATZ: Schreibe die Tests für Dossiers, Erzählerbausteine und Spoilerschutz (F-10, F-11, S-1) über alle Rollen, Pfade und Besetzungen.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: packages/mordakte_core/test/party/dossier_test.dart, packages/mordakte_core/test/party/erzaehler_test.dart, packages/mordakte_core/test/party/spoiler_test.dart

WERKZEUG: Du arbeitest direkt im Repo /home/user/werwolf_digital_flutter (kein eigener Arbeitsbaum). Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core . Die Kanon-Dateien liegen unter content/party/schlosskeller/ (nur lesen). Testhilfe: test/party/kanon_hilfe.dart (repoWurzel, leseJson(pfad), ladeKanon(), kanon, pruefer) – nur benutzen. Ein Kanon mit veränderten Daten für Rot-Proben entsteht so: Kanon.lade((p) { final j = leseJson('$repoWurzel/content/party/schlosskeller/$p'); /* j gezielt ändern */ return j; }).
VORHANDENE API (package:mordakte_core/mordakte_core.dart, nur benutzen, nicht ändern):
- Textsammlung.lade(leser) mit leser = (p) => leseJson('$repoWurzel/content/party/schlosskeller/$p'). Felder: dateien, bausteine (Map Kennung → Text: Erzähler, Detektiv, UI), dossiers (Map rolle → DossierRoh mit wer, weiss, verbirgt (List<TextPunkt text|ref>), ziel, besetzung), taeter (Map rolle → TaeterRoh mit tarnung, tatwissen, verbirgt, ziel), gespraeche (List<Gespraech> id, rolle, runde, nr, partner, thema, ziel, text, preisgabe), wahlen (Map Kennung → WahlText id, a, b, sabotage), doppelt.
- Texte(kanon, sammlung): dossier(rolle, pfad, rollen) → Dossier(rolle, taeter, wer, ziel, besetzung, tarnung, weiss, verbirgt, tatwissen (List<DossierZeile art, text, behauptung>), gespraeche (Map runde → List<(Gespraech, tatsächlicherPartner)>), wahlen (Map runde → WahlText?)); gespraechsplan(n); lastVerstoesse(); aufloesen(ref, pfad); beobachtung(id); luege(id); besetzung.
- textVerweise(kanon, sammlung) → List<String> (leer = grün); textLuecken(kanon, sammlung) → List<String> (leer = vollständig).
- Erzaehler(kanon): katalog() (alle erlaubten Erzähler-Kennungen), intro(spiel), rundenStart(r), bonus(spiel) (liefert 'bonus.rahmen' und 'hinweis.<id>'; der Text eines Hinweises steht in bonus.json, nicht in der Sammlung), resuemee(spiel), restSchluessel(rest), anklage(), finale(spiel) ('finale.<pfad>.<ende>', 'rueckblende.<pfad>'), aufloesung(spiel).
- Spiel(kanon): Ablauf siehe test/party/determinismus_test.dart (Funktion spieleAbend): s.weiter(); s.einrichten(Einstellungen(rollen:, detektiv: 'm'|'w', code:)); dann je Phase waehle(entscheidungId, optionId), abstimmen(kooperativ:, taeterSabotiert:), anklagen(person), weiter(). s.bausteine (alle ausgegebenen Kennungen), s.restmenge([bis]), s.bekannteFakten([bis]), s.ende, s.pfad, s.phase. FallCode.fuerPfad(pfad, kanon.pfade) liefert einen Code für einen Pfad.
- Ermittlung(kanon).bestesSpiel(pfad) → Options-Kennungen; Kanon: kanon.figuren, kanon.beobachtungen, kanon.zeitleiste, kanon.gegenstaende, kanon.kernverdaechtige, kanon.pfade, kanon.json['<datei>.json'].
Lies vor dem Schreiben: lib/src/party/texte.dart, erzaehler.dart, ablauf.dart, besetzung.dart; test/party/texte_test.dart (Probe-Sammlungen für Rot-Proben: Funktion _probe), content/party/schlosskeller/texte/SCHLUESSEL.md (Sichtbarkeit, S-1, P-1 bis P-4).
Stil: wie test/party/*.dart (deutsche Testnamen und Kommentare, kurz; erste Zeile ein Kommentar mit dem Kriterium). Analyse muss sauber sein: dart analyze test.
HINWEIS ZUM STAND: Parallel werden die Pflichtgespräche überarbeitet. Solange das läuft, kann test/party/texte_test.dart rot sein (Regel P-2); das ist nicht dein Befund. Deine Tests prüfen die Regeln; zeigt ein Test auf echten Daten einen Befund, lass ihn rot und melde den Befund (Fundstelle) im Bericht. Schwäche nie eine Prüfung ab und nutze kein skip, damit ein Test grün wird.

GRENZEN: Lege NUR deine eigenen Dateien an (Liste oben). Keine anderen Dateien ändern, keine Kanon-Dateien, kein pubspec, keine Abhängigkeiten. Kein Netz. Keine Git-Befehle außer git status und git diff (nur lesen). Nichts außerhalb des Repos schreiben (außer System-Temp). Tests dürfen nicht zufällig oder zeitabhängig sein (Rng mit festem Seed ist erlaubt). Andere Agenten schreiben gleichzeitig andere Testdateien im selben Ordner: fasse deren Dateien nicht an, und wenn deren Tests rot sind, ist das nicht dein Befund – führe für deine Abnahme nur deine eigenen Dateien aus.

ARBEITSSCHRITTE:
dossier_test.dart (F-11):
1. „Jedes Dossier lässt sich zusammensetzen“: für jede Rolle × jeden Pfad × Besetzung 4, 12 und 20 (nur besetzte Rollen): dossier() wirft nicht; wer, ziel, besetzung nicht leer.
2. „Täterfassung nur im eigenen Pfad“: Kernrolle im eigenen Pfad: taeter, tarnung nicht leer, tatwissen enthält die zeigt-Texte aller Spuren dieses Pfads mit rolle schluesselbeweis, zusatzindiz und fundort (gegenstaende.json, Feld rolle der Spur); in fremden Pfaden taeter false und tatwissen leer.
3. „Unter ‚weiss‘ steht kein Geheimnis“: kein Verweis in weiss (Rohdaten) zeigt auf eine Beobachtung mit kanal verborgen, ein Nebendelikt oder eine Lüge.
4. „‚verbirgt‘ ist vollständig“: für jede Rolle und jeden Pfad enthält dossier().verbirgt jede eigene Beobachtung mit kanal verborgen, die es im Pfad gibt, das Nebendelikt der Rolle (falls vorhanden) und jede ihrer Lügen (Zeile mit art luege und nicht leerer behauptung). Vergleiche über die Texte aus dem Kanon.
5. „Pflichtgespräche je Besetzung“: für n in 4..20 und jede besetzte Rolle: je Runde genau 3 Gespräche, nr 1 bis 3, Partner besetzt und nie die Rolle selbst.
6. „Wahltexte“: jede Rolle hat je Runde einen Wahltext; Sabotage genau bei Kernrollen im eigenen Pfad, sonst null.
7. „Keine Platzhalter“: kein Text eines Dossiers, einer Täterfassung, eines Gesprächs oder einer Wahl enthält „OFFENE FRAGE“, „TODO“, „XXX“ oder spitze Klammern.
8. Rot-Probe: Probe-Sammlung (wie _probe in texte_test.dart), in der ein Dossier unter weiss eine verborgene Beobachtung trägt → die Prüfung aus Schritt 3 meldet sie. Schreibe die Prüfungen als Funktionen, die Befunde liefern, damit dieselbe Funktion echte Daten (leer) und Probe (nicht leer) prüft.
erzaehler_test.dart (F-10, Erzähler 7.12):
9. „Sammlung vollständig“: textLuecken(kanon, sammlung) ist leer (Fehlermeldung listet die Lücken).
10. „Durchgespielte Abende nutzen nur vorhandene Bausteine“: für jeden Pfad × Besetzung {4, 20} × drei Spielweisen (bestes Spiel mit Anklage des Täters; immer erste Option mit falscher Anklage; immer letzte Option mit Anklage des Täters) × Gruppe (kooperativ 0 und alle): jede Kennung in s.bausteine gibt es (hinweis.<id> in bonus.json, alles andere in der Sammlung); 'finale.<pfad>.<s.ende.id>' und 'rueckblende.<pfad>' kommen genau einmal vor; aufloesung.<kern>.taeter nur für die Täterperson.
11. „Vor dem Finale nichts aus Finale, Rückblende oder Auflösung“: alle Kennungen vor der ersten finale.-Kennung beginnen mit intro., runde., bonus.rahmen, hinweis., resuemee. oder anklage.
12. „Resümee nennt genau die sichtbare Restmenge“: in jedem Resümee steht Erzaehler.restSchluessel(s.ermittlung.restmenge(s.bekannteFakten(runde))), passend zur Runde.
13. Rot-Probe: Sammlung ohne finale.ahmet.ende_meister → textLuecken nennt ihn.
spoiler_test.dart (S-1):
14. „resuemee.rest.eins nennt keinen Namen“: kein Name aus figuren.json (Feld name) im Text.
15. „Rahmen verrät keine Qualität“: bonus.rahmen und resuemee.gruppe.1 bis .3 enthalten keines der Wörter wahr, falsch, gelogen, Lüge, Gerücht, sicher, genau gemerkt, richtig (ganze Wörter, Groß-/Kleinschreibung egal).
16. „Kein Satz aus Pfadwissen steht am Tisch“: Sammle die Texte, die nur in einem Teil der Pfade gelten: zeigt aller Spuren mit Feld rolle (gegenstaende.json), Beobachtungen mit pfade ungleich 'alle', killerProfile der vier Kernfiguren (figuren.json; alle Textfelder), Texte der Ereignisse in tatmatrix/ahmet.json, fatma.json, olli.json, can.json. Bilde daraus alle Folgen von 5 Wörtern (klein, ohne Satzzeichen). Am Tisch stehen: alle Erzählerbausteine außer finale.*, rueckblende.*, aufloesung.*; dossier.wer; thema und text aller Gespräche; frage und optionen[].text aus entscheidungen.json; bonus.rahmen. Kein Text am Tisch enthält eine dieser 5-Wort-Folgen. Melde Fundstelle und Folge. Wenn eine Folge auch in einem pfadneutralen Kanon-Text vorkommt (Beobachtungen mit pfade 'alle', Zeitleiste mit pfade 'alle', beschreibung in gegenstaende.json), zählt sie nicht.
17. „Preisgaben am Tisch gelten in allen Pfaden“: jede beobachtung: in einer preisgabe hat pfade 'alle'.
18. Rot-Proben: (a) runde.1.start mit dem zeigt-Text von spur_ring_messing → Prüfung 16 meldet ihn; (b) bonus.rahmen „Ein wahrer Hinweis …“ → Prüfung 15 meldet ihn; (c) resuemee.rest.eins mit „Nur Olli bleibt.“ → Prüfung 14 meldet ihn.

ABNAHMEKRITERIEN UND TESTWEG: Mindestens 18 Tests, Laufzeit je Datei unter 60 Sekunden; alle Rot-Proben laufen. Befehle: dart analyze test ; dart test test/party/dossier_test.dart test/party/erzaehler_test.dart test/party/spoiler_test.dart (im Ordner packages/mordakte_core). Ein Test, der auf echten Daten rot ist, bleibt rot und steht mit Fundstelle im Bericht.

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-TEST-01
- Geänderte Dateien: <Liste>
- Anzahl Tests: <Zahl je Datei>
- Analyse: <letzte Zeile der Ausgabe>
- Tests: <letzte Zeile der Ausgabe>
- Rot auf echten Daten: <je Test: Fundstellen, oder „keine“>
- Rot-Proben: <je Probe: was manipuliert, welcher Test rot>
- Laufzeit je Datei: <Sekunden>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Alle 18 Schritte umgesetzt? Nur eigene Dateien angelegt (git status zeigt nur sie als neu)? Tests gelaufen? Jede Prüfung kann rot werden?
Letzte Zeile exakt: === ENDE F3-TEST-01 · BEREIT ZUR RÜCKGABE ===
