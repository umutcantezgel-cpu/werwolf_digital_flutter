F3-BAUMEISTER-01 · Baumeister · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING BAUMEISTER:
- **Aufgabe:** setzt einen Baustein auf der Schnittstelle des Orchestrators um (Dart/Flutter, Skripte), nur in den eigenen Dateien.
- **Gute Arbeit:** hält die Schnittstelle exakt ein, schreibt kleinen, lesbaren Code im Stil der Umgebung, lässt Analyse und Tests grün laufen und belegt das mit der Ausgabe.
- **Häufigste Fehler:** 1) fremde Dateien anfassen oder Schnittstellen „verbessern“, 2) Story-Text in Code schreiben statt Textschlüssel zu nutzen, 3) „sollte gehen“ ohne gelaufenen Test.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Baue den Textprüfer (Satzlängen, Fachwörter, Alkohol, Drogen, Rauchen, Ziffern und Abkürzungen im Vorlesetext) und den Textlint (Uhrzeiten, Raumnamen, alte Personennamen gegen den Kanon) mit Tests und einer CLI, die alle Spielertexte prüft.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG: Regeln aus planung/finalisierung-schlosskeller/TON-LEITFADEN.md §4 (Sprache, messbar), §5 (Fachwortliste mit Ersatz), §6 (Inhaltsregeln: Wörter für Alkohol, Drogen, Rauchen; Ausnahmen: „Rauch“ und „Qualm“ nur für den Kamin, „Kater“ nur die Katze, „weinrot“ ist eine Farbe, „Bargeld“ ist kein Barbetrieb). Räume und Orte: content/party/schlosskeller/raeume.json (rooms[].name, rooms[].anzeigename, orte[].name). Alte Personennamen: figuren.json figuren[].quelle.name (falls vorhanden). Uhrzeiten: alle Uhrzeiten, die im Kanon vorkommen (zeitleiste.json zeit, tatmatrix/*.json t, fall.json runden.uhrzeit, finaleUhrzeit, morgenUhrzeit sowie Uhrzeiten in Kanon-Texten).

SCHNITTSTELLEN:
- content/party/textregeln.json (neu, fallneutral): {"fachwoerter": {"<wort>": "<ersatz>"}, "verboten": {"alkohol": [..], "drogen": [..], "rauchen": [..]}, "ausnahmen": [..], "vorlesen": {"abkuerzungen": ["ca.", "z. B.", "Nr.", "usw.", "bzw."], "klammern": true, "ziffern": true}, "saetze": {"mittelHoechstens": 14, "hoechstens": 25}, "raumwortEndungen": ["saal", "raum", "gang", "keller", "kammer", "küche", "halle", "hof", "turm"], "raumAusnahmen": [..]}. Wörter werden als ganze Wörter ohne Groß- und Kleinschreibung geprüft; für Alkoholwörter auch Wortanfänge zusammengesetzter Wörter (Bierkasten), außer sie stehen in ausnahmen.
- packages/mordakte_core/lib/src/party/textpruefer.dart (reines Dart, kein dart:io):
  class TextQuelle { final String ort; final String text; final bool vorlesen; }
  class TextBefund { final String ort; final String regel; final String auszug; }
  class Textpruefer { Textpruefer(Map<String, Object?> regeln); List<String> saetze(String text); int woerter(String satz); List<TextBefund> pruefe(TextQuelle q); List<TextBefund> pruefeMittel(String bereich, List<TextQuelle> quellen); }
  List<TextQuelle> textQuellen(Kanon kanon, Textsammlung t)  // alle Texte, die Spielende sehen oder hören: Textsammlung (Erzähler-Bausteine mit vorlesen: true; Detektiv, UI, Dossiers, Täterfassungen, Gespräche thema/ziel/text, Wahlen a/b/sabotage mit vorlesen: false) und Kanon-Felder (beobachtungen text, Spuren zeigt und harmlos, entscheidungen frage, Optionstext und Begründungstext, bonus text, zeitleiste text, luegen behauptung und wahrheit, nebendelikte text, figuren alltag und persoenlichesZiel, setting-Texte) mit vorlesen: false. ort ist eine lesbare Fundstelle, z. B. „texte/erzaehler-intro.json#intro.start“ oder „beobachtungen.json#b_hana_wachs“.
  List<TextBefund> textLint(Kanon kanon, List<TextQuelle> quellen)  // Uhrzeiten (Muster H:MM oder HH:MM) müssen im Kanon vorkommen; Raumwörter (Wort endet auf eine raumwortEndung) müssen ein Raum- oder Ortsname aus raeume.json oder in raumAusnahmen sein; alte Personennamen sind verboten.
- packages/mordakte_core/bin/party_texte.dart: CLI, prüft alle textQuellen mit Textprüfer und Textlint, gibt Befunde mit Fundstelle aus, am Ende „Texte: OK (<n> Texte)“ oder „Texte: <k> Befunde“, Exitcode 1 bei Befunden. Mittelwert je Bereich (Datei der Textsammlung bzw. Kanon-Datei).
- packages/mordakte_core/test/party/textpruefer_test.dart und textlint_test.dart: Einheitstests der Regeln mit kleinen Probetexten (je Regel mindestens ein Treffer und ein Nicht-Treffer, Ausnahmen wie „weinroter Mantel“, „Bargeld“, „Qualm im Kaminsaal“, „Kater“ als Katze), Satztrennung (Abkürzungen, Anführungszeichen „…“, Auslassungspunkte), Mittelwertregel, sowie ein Test, dass textQuellen jede der 38 Textdateien und jede genannte Kanon-Feldart abdeckt (Zählung über eine Probe-Sammlung oder den echten Kanon). KEIN Test, der den ganzen echten Korpus fehlerfrei verlangt (das macht der Orchestrator am Tor).

EIGENE DATEIEN: content/party/textregeln.json, packages/mordakte_core/lib/src/party/textpruefer.dart, packages/mordakte_core/bin/party_texte.dart, packages/mordakte_core/test/party/textpruefer_test.dart, packages/mordakte_core/test/party/textlint_test.dart. (Den Export im Barrel macht der Orchestrator; importiere im Test und in der CLI package:mordakte_core/src/party/textpruefer.dart.)

GRENZEN: Ändere NUR deine eigenen Dateien. Keine Kanon- oder Textdateien ändern, auch wenn die CLI dort Befunde zeigt (die meldest du). Keine neuen Abhängigkeiten, kein Netz, keine Git-Befehle außer git status und git diff.

WERKZEUG: Du arbeitest direkt im Repo /home/user/werwolf_digital_flutter (kein eigener Arbeitsbaum). Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core. Vorhandene API (nur benutzen): package:mordakte_core/mordakte_core.dart mit Kanon (Kanon.lade, kanon.json[datei], kanon.figuren, kanon.beobachtungen, kanon.gegenstaende, kanon.zeitleiste, kanon.entscheidungenJson, kanon.bonusJson), Textsammlung (Textsammlung.lade(leser): bausteine, dossiers (DossierRoh: wer, weiss, verbirgt, ziel, besetzung; TextPunkt text/ref), taeter (TaeterRoh), gespraeche (Gespraech: thema, ziel, text), wahlen (WahlText: a, b, sabotage), dateien[name]['bereich']). Testhilfe test/party/kanon_hilfe.dart (repoWurzel, leseJson, kanon). Stil wie lib/src/party/*.dart: deutsche Bezeichner und Kommentare, kurz. Analyse muss sauber sein: dart analyze lib bin test.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN §4–§6, texte.dart, kanon.dart und die Kanon-Dateien.
2. Schreibe textregeln.json mit der vollständigen Fachwortliste aus §5, den Verbotslisten aus §6 (ergänze naheliegende Formen: Bier, Biere, Wein, Weine, Sekt, Schnaps, Cocktail, Bar, Kneipe, Fass, Prost, betrunken, Pegel, Alkohol; Drogen, Joint, kiffen, Rauschmittel; Zigarette, Zigaretten, E-Zigarette, rauchen, raucht, geraucht, Raucher, dampfen, Vape, Shisha) und den Ausnahmen.
3. Schreibe textpruefer.dart mit Textpruefer, textQuellen und textLint.
4. Schreibe die CLI und die beiden Testdateien.
5. Führe aus: dart analyze lib bin test ; dart test test/party/textpruefer_test.dart test/party/textlint_test.dart ; dart run bin/party_texte.dart. Rot-Proben: je Regel zeigen, dass der Test rot wird, wenn du die Regel in einer Kopie im System-Temp abschaltest.

ABNAHMEKRITERIEN: Analyse 0 Befunde; deine Tests grün; CLI läuft und listet die Befunde des heutigen Korpus; kein Story-Text im Code (Wortlisten stehen in textregeln.json).

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 1.200 Wörter):
## Ergebnis F3-BAUMEISTER-01
- Geänderte Dateien: <Liste>
- Analyse: <letzte Zeile>
- Tests: <letzte Zeile>
- Rot-Proben: <je Regel>
- CLI auf dem heutigen Korpus: <Zahl der Texte, Zahl der Befunde, die 30 wichtigsten Befunde als Liste mit Fundstelle und Regel>
## OFFENE FRAGEN

SELBSTPRÜFUNG: Jede Regel aus §4–§6 umgesetzt? Ausnahmen getestet? Nur eigene Dateien? Tests gelaufen?
Letzte Zeile exakt: === ENDE F3-BAUMEISTER-01 · BEREIT ZUR RÜCKGABE ===
