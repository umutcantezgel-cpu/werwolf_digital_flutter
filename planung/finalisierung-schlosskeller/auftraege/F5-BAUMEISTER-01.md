F5-BAUMEISTER-01 · Baumeister · Bauphase F5 · Kanon v1.0 · Schwierigkeit 3

## Baumeister
- **Aufgabe:** setzt einen Baustein auf der Schnittstelle des Orchestrators um (Dart/Flutter, Skripte), nur in den eigenen Dateien.
- **Gute Arbeit:** hält die Schnittstelle exakt ein, schreibt kleinen, lesbaren Code im Stil der Umgebung, lässt Analyse und Tests grün laufen und belegt das mit der Ausgabe.
- **Häufigste Fehler:** 1) fremde Dateien anfassen oder Schnittstellen „verbessern“, 2) Story-Text in Code schreiben statt Textschlüssel zu nutzen, 3) „sollte gehen“ ohne gelaufenen Test.

AUFGABE IN EINEM SATZ: Setze das Spielleitungsheft ohne Lösung und den Detektivbogen mit Ermittlungsbogen als PDF (Master 7.14).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: packages/mordakte_core/lib/src/party/druck/spielleitung.dart, content/party/schlosskeller/texte/ui-druck-spielleitung.json, packages/mordakte_core/test/party/druck_spielleitung_test.dart. UI-Präfix: ui.druck.spielleitung.*, ui.druck.bogen.*

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
1. spielleitungsheft(doc, k): pw.MultiPage mit Fuß (stil.fuss). Deckblatt: Falltitel, Baustein „Spielleitungsheft – ohne Lösung“, Fall-Code (k.satz.code.code), Personenzahl, Hinweis: Das versiegelte Auflösungsheft erst nach der Anklage öffnen.
2. Abschnitt Vorbereitung (Bausteine): welche Datei wofür ist (00 Spielleitung, 01 Detektivbogen, 10 Rollenhefte je Person, 11 versiegelte Fassungen an die vier Kernrollen, 12 Stimmkarten, 20 Indizkarten verdeckt nach Code bei der Spielleitung, 21 Hinweis-Umschläge geschlossen bei der Spielleitung, 90 Auflösungsheft versiegelt).
3. Abschnitt Ablauf in der Reihenfolge des Abends: Intro (k.satz.spielleitung.intro, jeden Baustein wortgleich über k.text, mit Marke „Vorlesen“), dann je Runde 1–3: Rundenstart vorlesen (rundenStart[r]); Pflichtgespräche mit Uhr (Rundendauer aus dem Bildschirm oder 30 Minuten); drei Entscheidungen: das Geburtstagskind wählt auf dem Detektivbogen, die Spielleitung gibt die Indizkarte mit dem genannten Code; Gruppenwahl: Stimmkarten verdeckt einsammeln, mischen, Werte zusammenzählen, Summe nie laut nennen, Umschlag nach Tabelle (k.satz.spielleitung.auszaehlung, je Stufe „ab Summe X → Umschlag CODE“, Summen unter 0 zählen als 0); Umschlag öffnen und vorlesen; Zwischenresümee vorlesen: resuemeeGruppe[r], dann die Restmenge nach dem Ermittlungsbogen des Geburtstagskinds (Tabelle aller Restmengen aus resuemeeRest: Namen der Personen → Baustein-Text), dann die Lage (resuemeeLage[r]: offen, spur, klar mit Regel aus dem Bogen). Nach Runde 3: Anklage vorlesen (anklage), Geburtstagskind klagt eine der vier Kernpersonen an, dann Auflösungsheft öffnen.
4. detektivbogen(doc, k): Kopf mit Falltitel und Baustein „Detektivbogen“. Je Runde die drei Entscheidungen (frage) mit ihren Optionen in der vorgegebenen Reihenfolge: Ankreuzkästchen, Optionstext, rechts „Karte CODE“. Unter jeder Entscheidung ein Feld „Gewählt: Karte ____“.
5. Ermittlungsbogen im detektivbogen: Tabelle Kernpersonen (Namen) × Faktarten (Bausteine je typ, z. B. ui.druck.bogen.typ.alibi) mit leeren Kästchen; darunter die Regeltexte wortgleich (regelText) und die Lage-Regel als Baustein (klar, sobald ein Schlüsselbeweis angekreuzt ist; Spur, sobald eine belastende Art angekreuzt ist; sonst offen). Hinweis-Baustein: Jede Indizkarte sagt, was anzukreuzen ist.
6. Ein Feld für den Namen der angeklagten Person und ein Punktefeld „____ von 9“ (die Punkte zählt erst das Auflösungsheft).
7. Schreibe ui-druck-spielleitung.json.
8. Schreibe test/party/druck_spielleitung_test.dart (mindestens 8 Tests): beide PDFs sind A4; das Spielleitungsheft enthält jeden Intro-Baustein und jeden Rundenstart wortgleich (flach() auf beiden Seiten vergleichen, erste 60 Zeichen genügen); es enthält jeden Umschlag-Code der Auszähltabelle; es enthält keinen Namen des Täters in einer Täter-Zuordnung und kein Wort „Täterfassung“; keine Finale-Bausteine (finale.*) und keine Auflösungsbausteine im Heft; der Detektivbogen nennt jeden Kartencode genau der Optionen; jede Frage steht wortgleich darin; Personenzahl 4 und 20 laufen ohne Überlauf; der Bogen nennt alle vier Kernpersonen.
9. Führe den Testweg aus, sieh dir mindestens drei Seiten als PNG an und behebe, was unschön oder schwer lesbar ist.

ABNAHMEKRITERIEN UND TESTWEG:
- `dart analyze lib/src/party/druck test` → No issues found.
- `dart test test/party/druck_spielleitung_test.dart` → alle grün, mindestens 8 Tests, jeder kann rot werden (eine Rot-Probe im Bericht belegen und zurücknehmen).
- `dart run bin/party_texte.dart` → „Texte: OK“ und `dart test test/party/texte_test.dart test/party/textpruefer_test.dart` grün.
- `dart run bin/party_druck.dart --pfad can --n 4` und `--pfad fatma --n 20` laufen ohne Fehler.

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 700 Wörter):
## Ergebnis F5-BAUMEISTER-01
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
Letzte Zeile exakt: === ENDE F5-BAUMEISTER-01 · BEREIT ZUR RÜCKGABE ===
