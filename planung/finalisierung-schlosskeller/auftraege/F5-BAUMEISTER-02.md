F5-BAUMEISTER-02 · Baumeister · Bauphase F5 · Kanon v1.0 · Schwierigkeit 3

## Baumeister
- **Aufgabe:** setzt einen Baustein auf der Schnittstelle des Orchestrators um (Dart/Flutter, Skripte), nur in den eigenen Dateien.
- **Gute Arbeit:** hält die Schnittstelle exakt ein, schreibt kleinen, lesbaren Code im Stil der Umgebung, lässt Analyse und Tests grün laufen und belegt das mit der Ausgabe.
- **Häufigste Fehler:** 1) fremde Dateien anfassen oder Schnittstellen „verbessern“, 2) Story-Text in Code schreiben statt Textschlüssel zu nutzen, 3) „sollte gehen“ ohne gelaufenen Test.

AUFGABE IN EINEM SATZ: Setze Rollenhefte, die versiegelten Fassungen der vier Kernrollen und die Stimmkarten als PDF (Master 7.11, 7.14, G-1).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: packages/mordakte_core/lib/src/party/druck/rollen.dart, content/party/schlosskeller/texte/ui-druck-rollen.json, packages/mordakte_core/test/party/druck_rollen_test.dart. UI-Präfix: ui.druck.rollen.*, ui.druck.fassung.*, ui.druck.stimme.*

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
1. rollenhefte(doc, k): je besetzte Rolle (k.satz.besetzt, in dieser Reihenfolge) ein Heft, das mit einem Deckblatt beginnt: Falltitel, Baustein „Rollenheft“, Name und Titel der Figur, ein farbiger Balken in colorCode (k.kanon.figur(id)!['colorCode']), Baustein „Nur für dich. Erst lesen, wenn du dein Heft in der Hand hast.“ Danach (neue Seite) aus k.satz.rollenhefte[rolle]: Wer ich bin, Mein Ziel heute Nacht, Meine Pflichtgespräche je Runde (Partner aus dem Dossier: Kennung → k.figurName, der Detektiv als Baustein „das Geburtstagskind“; Thema, Ziel, So fängst du an), Hinweis zur Besetzung. Für Rollen, die keine Kernrolle sind (nicht in k.kanon.kernverdaechtige), zusätzlich: Was ich weiß, Was ich verberge (Lügen als „Du behauptest: … / In Wahrheit: …“), Meine Rundenwahl je Runde (a und b). Kernrollen bekommen diese drei Teile NICHT im Heft, sondern in ihrer Fassung; dort steht im Heft nur ein Baustein-Hinweis auf den Umschlag mit ihrem Code (Fassung.code).
2. fassungen(doc, k): je Kernrolle (k.satz.fassungen) eine Außenseite (stil.aussenseite mit Code und Baustein „Umschlag für {name}. Nur {name} öffnet ihn.“ – der Name darf außen stehen, denn alle vier bekommen einen) und dahinter die Innenseiten: Was ich weiß, Was ich verberge, Meine Rundenwahl je Runde (a und b; gibt es sabotage, steht sie statt b mit dem Baustein „Deine heimliche Wahl statt B“), bei dossier.taeter zuerst die Tafel „Nur für dich: Du warst es“ mit tarnung („Das erzählst du den anderen“) und tatwissen („So war es wirklich“). WICHTIG: Alle vier Fassungen haben gleich viele Seiten. Fülle kürzere mit Notizseiten (Baustein „Notizen“ und Linien) auf, bis alle so lang sind wie die längste. Miss die Seitenzahl, indem du jede Fassung zuerst in ein eigenes Probe-Dokument setzt und dessen Seiten zählst (doc.document.pdfPageList.pages.length nach dem Setzen, oder save() und in pdfPruefen zählen – nimm, was im Paket zuverlässig geht).
3. stimmkarten(doc, k): Karten 90 × 60 mm, acht je Seite mit Schnittlinien (stil.schnitt()). Jede Karte ist längs gefaltet: obere Hälfte Vorderseite (Spielername-Feld leer, Figurname, Baustein „Runde {nr}“, A oder B, der Text der Karte), untere Hälfte umgeknickt der Wert als Baustein („Wert: +1“, „Wert: 0“, „Wert: −1“) mit Faltlinie. Alle Karten sehen gleich aus bis auf Text und Wert; die Sabotage-Karte trägt auf der Vorderseite einfach „B“. Reihenfolge: nach Runde, dann Besetzungsreihenfolge, A vor B. Text vorher mit stil.passendeGroesse auf die Kartenfläche bringen.
4. Schreibe ui-druck-rollen.json.
5. Schreibe test/party/druck_rollen_test.dart (mindestens 8 Tests): alle drei PDFs A4; für Pfad fatma haben die vier Fassungen gleich viele Seiten (Seitenzahl des Fassungs-PDF ist durch 4 teilbar und jede Fassung beginnt mit ihrem Code – prüfe über seitenText); die Täterfassung von fatma enthält „Nur für dich“ und deren tarnung (erste 50 Zeichen), die drei anderen nicht; das Rollenheft-PDF enthält keinen tarnung-Text und kein „Nur für dich: Du warst es“; jede besetzte Rolle hat ein Deckblatt mit ihrem Namen; bei n = 4 erscheinen nur Ahmet, Fatma, Olli und Can; die Stimmkarten-PDF enthält jeden Kartentext (erste 40 Zeichen) und je Runde genau ein „−1“ (Täterrolle); n = 20 ohne Überlauf; Rot-Probe im Bericht.
6. Führe den Testweg aus, sieh dir mindestens vier Seiten als PNG an (Deckblatt, Rollenseite, Fassung, Stimmkarten) und verbessere die Lesbarkeit.

ABNAHMEKRITERIEN UND TESTWEG:
- `dart analyze lib/src/party/druck test` → No issues found.
- `dart test test/party/druck_rollen_test.dart` → alle grün, mindestens 8 Tests, jeder kann rot werden (eine Rot-Probe im Bericht belegen und zurücknehmen).
- `dart run bin/party_texte.dart` → „Texte: OK“ und `dart test test/party/texte_test.dart test/party/textpruefer_test.dart` grün.
- `dart run bin/party_druck.dart --pfad can --n 4` und `--pfad fatma --n 20` laufen ohne Fehler.

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 700 Wörter):
## Ergebnis F5-BAUMEISTER-02
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
Letzte Zeile exakt: === ENDE F5-BAUMEISTER-02 · BEREIT ZUR RÜCKGABE ===
