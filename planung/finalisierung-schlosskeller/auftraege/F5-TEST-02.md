F5-TEST-02 · Testschreiber · Bauphase F5 · Kanon v1.0 · Schwierigkeit 2

## Testschreiber
- **Aufgabe:** schreibt automatische Tests für eine vorgegebene Schnittstelle.
- **Gute Arbeit:** Grenzwerte und Randfälle zuerst, ein Test prüft eine Sache, Testnamen sagen auf Deutsch, was erwartet wird; läuft grün und wird rot, wenn man die geprüfte Regel bricht.
- **Häufigste Fehler:** 1) Tests, die nie rot werden können, 2) Umsetzung im Test nachbauen statt Ergebnisse zu prüfen, 3) zufällige oder zeitabhängige Tests.

AUFGABE IN EINEM SATZ: Schreibe den gebündelten Drucktest über alle Pfade und Personenzahlen (F-14 druck_test).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEI: packages/mordakte_core/test/party/druck_test.dart

WERKZEUG: Direkt im Repo /home/user/werwolf_digital_flutter (Stand Commit 2b0a85f). Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core . Testhilfen: test/party/kanon_hilfe.dart (kanon, repoWurzel, leseJson), test/party/druck_hilfe.dart (druckKontext, pdfPruefen, flach). Stil wie test/party/*.dart (erste Zeile Kommentar mit dem Kriterium, deutsche Testnamen).
GRENZEN: Lege NUR deine eigene Datei an. Keine anderen Dateien, kein Kanon, kein pubspec, kein Netz, keine Git-Befehle außer git status und git diff. Tests deterministisch (Rng mit festem Seed erlaubt). Zeigt ein Test auf echten Daten einen Befund, lass ihn rot und melde die Fundstelle – schwäche nie eine Prüfung ab, kein skip.

VORHANDENE API – nur benutzen, nie ändern (Paket packages/mordakte_core, reines Dart, Paket `pdf` 3.13.1 als `pw`):
lib/src/party/druck/satz.dart:
  class DruckKontext { Kanon kanon; Texte texte; DruckSatz satz; DruckStil stil; String fallTitel;
    String text(String kennung)   // Erzähler- und Hinweisbaustein wortgleich (texte.baustein)
    String ui(String kennung, [Map<String,String> werte])  // Baustein `ui.druck.*`, Platzhalter {name}
    String figurName(String id); String figurTitel(String id) }
  Future<List<DruckDatei>> druckDateien(DruckKontext k)   // ruft die Teile auf; Dateien 00-spielleitung … 90-aufloesung-versiegelt
  Jeder Teil ist eine Funktion void <teil>(pw.Document doc, DruckKontext k), die Seiten an doc anhängt.
lib/src/party/druck/satz_stil.dart → class DruckStil:
  static format (A4), static rand, static breite (nutzbare Breite), static minGroesse = 9
  pw.TextStyle titel([g]), ueberschrift([g]), text([g]), klein([g]), marke([g]), code([g])
  pw.Document neuesDokument(String titel)
  double hoehe(pw.Widget w, double breite)          // Höhe in pt beim Satz
  double passendeGroesse(pw.Widget Function(double g) bauen, double breite, double hoeheMax, {double start = 11, String wo})  // wirft StateError bei Überlauf
  pw.Widget kopf(String marke, String titel); pw.Widget fuss(pw.Context ctx, String links); pw.Widget abschnitt(String ueberschrift, List<String> absaetze, {double groesse})
  pw.BoxDecoration schnitt()   // gestrichelte Schnittlinie;  pw.Widget aussenseite(String code, String hinweis)
lib/src/party/druck/modell.dart → class DruckSatz (alles fertig berechnet, nur lesen):
  FallCode code; int rollen; String detektiv; List<String> besetzt; Map<String,String> gespraechsplan (Gesprächskennung → Partner)
  Spielleitungsheft spielleitung { List<String> intro; Map<int,String> rundenStart; Map<int,String> resuemeeGruppe; Map<String,String> resuemeeRest (Restmenge 'ahmet_fatma' → Baustein); Map<int, Map<String,String>> resuemeeLage (Runde → offen|spur|klar → Baustein); String anklage; List<Auszaehlung> auszaehlung }
  Auszaehlung { int runde; List<({int abSumme, String umschlag})> stufen }   // absteigend: ab dieser Summe gilt dieser Umschlag
  List<BogenEntscheidung> detektivbogen  { String id; int runde, nr; String frage; List<({String option, String text, String karte})> optionen }
  Ermittlungsbogen ermittlungsbogen { List<String> personen (vier Kernpersonen); List<String> typen (Faktarten: alibi, nebendelikt, spaetankunft, zusatzindiz, fundort, schluesselbeweis); List<Ausschlussregel> regeln (id, wenn, folge); Map<String,String> regelText (wortgleich); Set<String> belastend }
  Map<String, Dossier> rollenhefte   // je besetzte Rolle das Dossier dieses Pfads
  List<Fassung> fassungen            // vier Kernrollen: { String code; String rolle; Dossier dossier } (dossier.taeter nur im eigenen Pfad)
  List<Indizkarte> indizkarten       // { String code, entscheidung, option, ziel; bool unbesetztePerson; List<String> funde; List<({String person, String typ})> kreuze }, nach Code sortiert
  List<Stimmkarte> stimmkarten       // { String rolle; int runde; bool a; String text; int wert (A 1, B 0, Sabotage −1) }
  List<HinweisUmschlag> umschlaege   // { String code; int runde; Qualitaet qualitaet; List<String> kennungen; List<String> texte }
  Aufloesungsheft aufloesung { String taeter; Map<String,String> richtig (Entscheidung → Kartencode); List<EndeRegel> endentabelle (id, name, richtig, punkteVon, punkteBis); Map<String, List<String>> finale (Ende → Bausteine); Map<int,String> gruppe (Zahl der Runden mit Zusammenhalt → Baustein); List<String> rollen (Auflösungsbausteine); Map<String,String> codes (Code → Bedeutung) }
  Hilfen: Indizkarte karte(String code); HinweisUmschlag umschlag(String code); Set<String> restmengeAus(Iterable kreuze); String restSchluessel(Set<String>)
mordakte_core: class Dossier { String rolle; bool taeter; String wer, ziel, besetzung; String? tarnung; List<DossierZeile> weiss, verbirgt, tatwissen; Map<int, List<(Gespraech, String)>> gespraeche; Map<int, WahlText?> wahlen }; class DossierZeile { String art; String text; String? behauptung }; class Gespraech { String id, rolle, partner, thema, ziel, text; int runde, nr }; class WahlText { String id, a, b; String? sabotage }; enum Qualitaet { wahr, neutral, falsch }; Gruppenwahl.zusammengehalten(Qualitaet q) (nur wahr)
Testhilfe test/party/druck_hilfe.dart (nur benutzen): DruckKontext druckKontext({String pfad = 'ahmet', int n = 12, String detektiv = 'w'}) · PdfBefund pdfPruefen(Uint8List bytes) → (seiten, a4, text, seitenText) über pdfinfo/pdftotext · String flach(String s) (Zeilenumbrüche weg) · druckTexte, druckStil
Bild-Werkzeug: `pdftoppm -r 50 -png datei.pdf präfix` rendert Seiten zu PNG (nur zum Ansehen mit dem Read-Werkzeug, nicht im Repo ablegen).

ARBEITSSCHRITTE:
1. Lies test/party/druck_modell_test.dart, druck_spielleitung_test.dart, druck_rollen_test.dart, druck_karten_test.dart – dein Test prüft den ganzen Satz über die Breite, nicht die Details der Teile.
2. Für jeden Pfad × n ∈ {4, 7, 12, 16, 20} (20 Sätze, je ein test): druckDateien(druckKontext(pfad: p, n: n)) erzeugt acht Dateien mit den Namen 00-spielleitung.pdf bis 90-aufloesung-versiegelt.pdf; jede Datei ist A4 (pdfPruefen(...).a4); kein Dateiname enthält einen Personen- oder Pfadnamen.
3. Außenseiten neutral: Auf jeder Seite der Indizkarten und Umschläge kommt keines der Wörter Täter, Täterin, wahr, neutral, falsch, Gerücht und kein Name eines Endes vor (seitenText, Wortgrenzen beachten, Groß-/Kleinschreibung egal).
4. Fassungen: Das Fassungs-PDF hat eine durch 4 teilbare Seitenzahl; jede der vier Fassungen beginnt mit ihrem Code; nur die Fassung der Täterrolle enthält „Nur für dich“.
5. Spielleitungsheft und Detektivbogen enthalten keinen Finale- und keinen Auflösungsbaustein (je die ersten 50 Zeichen aller finale.*, rueckblende.* und aufloesung.* Bausteine; flach()).
6. Wortgleichheit: Alle Funde aller Indizkarten (k.satz.indizkarten) stehen wortgleich im Indizkarten-PDF – genügt für zwei Sätze (ahmet n = 4, can n = 20), je die ersten 50 Zeichen nach flach(); beachte, dass zweispaltige Karten von pdftotext -layout vermischt werden können (dann ohne -layout lesen: eigene kleine Hilfe in deiner Datei mit Process.runSync('pdftotext', [pfad, '-'])).
7. Laufzeit: Die 20 Sätze dauern; halte die Gesamtzeit unter 180 s (z. B. pro Satz nur die nötigen Dateien prüfen).

ABNAHMEKRITERIEN UND TESTWEG: `dart analyze test` → No issues found; `dart test packages/mordakte_core/test/party/druck_test.dart` → grün, mindestens 24 Tests, Laufzeit unter 180 s; mindestens zwei Rot-Proben im Bericht.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, höchstens 700 Wörter):
## Ergebnis F5-TEST-02
- DATEIEN: Liste mit Zeilenzahl
- UMGESETZT: je Arbeitsschritt eine Zeile
- TESTS: Anzahl, letzte Zeile von dart test, Laufzeit
- ANALYSE: letzte Zeile von dart analyze test
- ROT-PROBEN: je Probe eine Zeile (was verändert, welcher Test rot, zurückgenommen)
- BEFUNDE AUF ECHTEN DATEN: Fundstellen oder „keine“
## OFFENE FRAGEN
- (oder „keine“)
SELBSTPRÜFUNG: Nur die eigene Datei angelegt? Jeder Test kann rot werden? Tests gelaufen?
Letzte Zeile exakt: === ENDE F5-TEST-02 · BEREIT ZUR RÜCKGABE ===
