F5-BAUMEISTER-03 · Baumeister · Bauphase F5 · Kanon v1.0 · Schwierigkeit 3

## Baumeister
- **Aufgabe:** setzt einen Baustein auf der Schnittstelle des Orchestrators um (Dart/Flutter, Skripte), nur in den eigenen Dateien.
- **Gute Arbeit:** hält die Schnittstelle exakt ein, schreibt kleinen, lesbaren Code im Stil der Umgebung, lässt Analyse und Tests grün laufen und belegt das mit der Ausgabe.
- **Häufigste Fehler:** 1) fremde Dateien anfassen oder Schnittstellen „verbessern“, 2) Story-Text in Code schreiben statt Textschlüssel zu nutzen, 3) „sollte gehen“ ohne gelaufenen Test.

AUFGABE IN EINEM SATZ: Setze Indizkarten, Hinweis-Umschläge und das versiegelte Auflösungsheft mit Endentabelle als PDF (Master 7.9, 7.14).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: packages/mordakte_core/lib/src/party/druck/karten.dart, packages/mordakte_core/lib/src/party/druck/aufloesung.dart, content/party/schlosskeller/texte/ui-druck-karten.json, packages/mordakte_core/test/party/druck_karten_test.dart. UI-Präfix: ui.druck.karte.*, ui.druck.umschlag.*, ui.druck.aufloesung.*

WERKZEUG: Du arbeitest direkt im Repo /home/user/werwolf_digital_flutter (Stand Commit 89db391). Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core . Probe des ganzen Satzes: dart run bin/party_druck.dart --pfad olli --n 12 --aus /tmp/<ordner> ; Seiten ansehen: pdftoppm -r 50 -png /tmp/<ordner>/<datei>.pdf /tmp/<ordner>/s und die PNGs mit dem Read-Werkzeug anschauen.
Lies vor dem Schreiben: lib/src/party/druck/satz.dart, satz_stil.dart, modell.dart, deinen Stub, test/party/druck_hilfe.dart, test/party/druck_modell_test.dart, content/party/schlosskeller/texte/ui.json (Format), planung/finalisierung-schlosskeller/F5-ENTWURF-DRUCK.md, TON-LEITFADEN.md (§1–§4).

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

REGELN DES DRUCKS (Master 7.14, F-14, E-008):
- Alles A4 hoch, gut lesbar (Text mindestens 9 pt), schwarzweiß druckbar, kein abgeschnittener Text. Fließtext mit pw.MultiPage; Karten und Umschläge mit fester Größe vorher mit stil.passendeGroesse messen – ein Überlauf ist ein Fehler, nie stillschweigend kürzen.
- Wer druckt, sieht außen nur neutrale Codes: Außenseiten von Indizkarten, Hinweis-Umschlägen und Fassungen zeigen Code und einen neutralen Hinweis, nie einen Pfad, nie „Täter“, nie eine Qualität. Innenseiten stehen auf der anderen Hälfte hinter einer Faltlinie.
- Kein Text entsteht im Code: Story-Texte wortgleich aus dem DruckSatz bzw. k.text(kennung); Überschriften, Hinweise und Anleitungen als Bausteine `ui.druck.<teil>.*` NUR in deiner eigenen UI-Datei (Format wie texte/ui.json: {"settingId":"spuk_im_schlosskeller","bereich":"ui","hinweis":"…","eintraege":[{"id":"ui.druck.…","text":"…"}]}). Erlaubt im Code sind Satzzeichen, Ziffern, Codes und Trenner wie ' · '.
- Ton (TON-LEITFADEN §1–§4): kurze Sätze, Alltagssprache, keine Fachwörter, kein Alkohol, keine Drogen, kein Rauchen, keine Marken; Anleitungen in der Du- bzw. Ihr-Form.

GRENZEN: Ändere NUR deine eigenen Dateien; lege keine weiteren an. Keine anderen Dateien, kein Kanon, kein pubspec, kein pub get, keine neuen Abhängigkeiten, kein Netz. Keine Git-Befehle außer git status und git diff (nur lesen) – auch kein git log. Nichts außerhalb des Repos schreiben außer System-Temp und PNG-Proben unter /tmp. Zwei andere Baumeister arbeiten gleichzeitig an anderen Druckteilen: fasse deren Dateien nicht an; ist deren Teil unfertig, ist das nicht dein Befund.

ARBEITSSCHRITTE:
1. indizkarten(doc, k): je Indizkarte (k.satz.indizkarten, schon nach Code sortiert) eine Karte A5 quer, zwei je A4-Seite mit Schnittlinie. Jede Karte ist längs gefaltet: links außen der Code groß (stil.aussenseite mit Baustein „Indizkarte. Erst umdrehen, wenn das Geburtstagskind diesen Code gewählt hat.“), rechts innen: ziel als Überschrift; bei unbesetztePerson der Baustein „Diese Person spielt heute niemand. Die Karte sagt, was sie weiß.“; jeder Fund wortgleich als Absatz; unten „Für den Ermittlungsbogen:“ und je Kreuz „Name – Faktart“ (Faktart als Baustein ui.druck.karte.typ.<typ>; ohne Kreuze ein Baustein „Nichts anzukreuzen“). Innenseite vorher mit stil.passendeGroesse messen.
2. umschlaege(doc, k): je Hinweis-Umschlag eine A4-Seite, quer gefaltet: obere Hälfte außen (Code groß, Baustein „Hinweis-Umschlag. Erst öffnen, wenn die Spielleitung diesen Code nennt.“), untere Hälfte innen: die Texte des Umschlags (k.satz.umschlag(code).texte) wortgleich, darüber Baustein „Vorlesen“. Außen nie Runde oder Qualität.
3. aufloesungsheft(doc, k): Deckblatt „Versiegelt – erst nach der Anklage öffnen“ (Baustein) mit Falltitel und Fall-Code. Dann: Wer es war (figurName(taeter)); Punkte: Tabelle der neun Entscheidungen (Frage gekürzt auf die ersten 60 Zeichen aus k.satz.detektivbogen) mit dem Code der richtigen Karte, Feld zum Ankreuzen, Summe; Endentabelle: je EndeRegel eine Zeile (Anklage richtig/falsch als Baustein, Punkte von–bis, Name des Endes) mit Verweis auf den Abschnitt; je Ende ein Abschnitt mit Name und den Bausteinen aus finale[id] wortgleich (Finaltext, dann Rückblende); Auflösung für alle: zuerst die Tabelle „Runden mit Zusammenhalt“: welche Umschlag-Codes als Zusammenhalt zählen (Umschläge mit Qualität wahr), dann je Zahl 0–3 den Baustein aus gruppe[n] wortgleich, dann je besetzter Rolle (in k.satz.aufloesung.rollen) Name und Text wortgleich; zum Schluss die Codeliste (codes, sortiert nach Code).
4. Schreibe ui-druck-karten.json.
5. Schreibe test/party/druck_karten_test.dart (mindestens 9 Tests): alle drei PDFs A4; Indizkarten-PDF hat genau ceil(Karten/2) Seiten; jede Karte zeigt ihren Code; jeder Fund jeder Karte steht wortgleich (erste 50 Zeichen nach flach()) darin; auf keiner Indizkarte und keinem Umschlag stehen die Wörter wahr, neutral, falsch, Täter oder ein Ende-Name; jeder Umschlag-Text steht wortgleich im Umschlag-PDF; das Auflösungsheft nennt den Täter, jeden Ende-Namen und jeden finale-Baustein (erste 50 Zeichen); für alle vier Pfade und n = 4 / 20 ohne Überlauf; Rot-Probe im Bericht.
6. Führe den Testweg aus, sieh dir mindestens vier Seiten als PNG an (Indizkarte, Umschlag, Endentabelle, Finale) und verbessere die Lesbarkeit.

ABNAHMEKRITERIEN UND TESTWEG:
- `dart analyze lib/src/party/druck test` → No issues found.
- `dart test test/party/druck_karten_test.dart` → alle grün, mindestens 9 Tests, jeder kann rot werden (eine Rot-Probe im Bericht belegen und zurücknehmen).
- `dart run bin/party_texte.dart` → „Texte: OK“ und `dart test test/party/texte_test.dart test/party/textpruefer_test.dart` grün.
- `dart run bin/party_druck.dart --pfad can --n 4` und `--pfad fatma --n 20` laufen ohne Fehler.

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 700 Wörter):
## Ergebnis F5-BAUMEISTER-03
- DATEIEN: Liste mit Zeilenzahl
- UMGESETZT: je Arbeitsschritt eine Zeile (Nr. → was, wo)
- UI-BAUSTEINE: Anzahl und Präfix
- TESTS: Anzahl, letzte Zeile von dart test
- ANALYSE: letzte Zeile von dart analyze
- TEXTE: letzte Zeile von dart run bin/party_texte.dart
- SICHTPROBE: welche Seiten du als PNG angesehen hast und was dir auffiel
## OFFENE FRAGEN
- (oder „keine“)

SELBSTPRÜFUNG: Alle Schritte umgesetzt? Nur eigene Dateien geändert? Jeder Text aus Bausteinen oder Satzdaten? Außen nur Codes? Kein Überlauf (passendeGroesse)? Tests und Analyse grün?
Letzte Zeile exakt: === ENDE F5-BAUMEISTER-03 · BEREIT ZUR RÜCKGABE ===
