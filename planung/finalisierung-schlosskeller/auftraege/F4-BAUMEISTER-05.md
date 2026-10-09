F4-BAUMEISTER-05 · Baumeister · Bauphase F4 · Kanon v1.0 · Schwierigkeit 3

## Baumeister
- **Aufgabe:** setzt einen Baustein auf der Schnittstelle des Orchestrators um (Dart/Flutter, Skripte), nur in den eigenen Dateien.
- **Gute Arbeit:** hält die Schnittstelle exakt ein, schreibt kleinen, lesbaren Code im Stil der Umgebung, lässt Analyse und Tests grün laufen und belegt das mit der Ausgabe.
- **Häufigste Fehler:** 1) fremde Dateien anfassen oder Schnittstellen „verbessern“, 2) Story-Text in Code schreiben statt Textschlüssel zu nutzen, 3) „sollte gehen“ ohne gelaufenen Test.

AUFGABE IN EINEM SATZ: Baue das Erzählerfeld mit abschaltbarer lokaler Stimme und Wortgleich-Prüfung (Master 7.12) als ErzaehlerFeld.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: lib/party/erzaehler_ausgabe.dart, lib/party/stimme.dart, lib/party/stimme_web.dart, lib/party/stimme_stub.dart, content/party/schlosskeller/texte/ui-erzaehler.json, test/party_widgets/erzaehler_test.dart. UI-Präfix: ui.erzaehler.*

WERKZEUG: Du arbeitest direkt im Repo /home/user/werwolf_digital_flutter (kein eigener Arbeitsbaum, Stand Commit cd2cfd9). Vor jedem flutter- oder dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; dann cd /home/user/werwolf_digital_flutter . Flutter 3.47 mit Dart 3.11 (Records, Patterns, switch-Ausdrücke erlaubt). Stil wie lib/party/*.dart: deutsche Bezeichner und kurze deutsche Doc-Kommentare, kleine Widgets, keine Magie.
Lies vor dem Schreiben: lib/party/sitzung.dart, lib/party/party_stil.dart, lib/party/party_seite.dart, lib/party/bildschirme/karte.dart (Beispiel für Aufbau und Stil), deinen Stub (eigene Datei), test/party_widgets/hilfe.dart und ablauf_test.dart, content/party/schlosskeller/texte/ui.json, planung/finalisierung-schlosskeller/TON-LEITFADEN.md (§1–§4), content/party/schlosskeller/texte/SCHLUESSEL.md (Sichtbarkeit).

VORHANDENE API – nur benutzen, nie ändern:
lib/party/sitzung.dart → class PartySitzung extends ChangeNotifier (ein Abend; alle Bildschirme bekommen nur sie)
  Texte:   String text(String kennung)  // Erzähler-, Detektiv-, Hinweis- und UI-Baustein wortgleich
           String ui(String kennung, [Map<String,String> werte])  // UI-Baustein, Platzhalter {name} aus werte
           bool hatText(String kennung)
           List<String> get erzaehler  // Bausteine, die der Erzähler beim letzten Schritt ausgegeben hat (in Lesereihenfolge)
  Figuren: String figurName(id) · String figurTitel(id) · Color figurFarbe(id) · String spielerName(rolle) (Spielername, sonst Figurname)
           String personAmTisch(id)  // Rolle oder Detektiv ('detective') → Name am Tisch
           Map<String,Object?> figur(id) // Kanon-Datensatz (nur lesen)
  Ablauf:  PartyPhase get phase · int get runde · bool get kannWeiter · void weiter() · void zurEinrichtung()
           PartyPhase: titel, einrichtung, rollen, intro, gespraeche, entscheidungen, gruppenwahl, bonus, resuemee, anklage, finale, aufloesung, ende
  Einrichtung: int get minRollen (4) · int get maxRollen (20) · List<String> rollenBei(int n) (feste Besetzungsreihenfolge)
           void einrichten({required int rollen, required String detektiv /* 'm'|'w' */, String? code /* leer/ungültig = Zufall */, bool druck = false, int rundendauerMinuten = 30, Map<String,String> namen = const {}, String geburtstagskind = ''})
           Map<String,String> namen · String geburtstagskind · bool stimmeAn · Duration rundendauer · FallCode get fallCode · Einstellungen get einstellungen · List<String> get besetzt
           static FallCode zufallsCode([int? seed]) ; FallCode.lesen(String) → FallCode? (aus mordakte_core; 5 Zeichen aus FallCode.alphabet)
  Verdeckt: String? get verdeckt · void zeigeVerdeckt(String rolle) · void verdecken()
           Dossier dossier(String rolle)          // NUR wenn verdeckt == rolle, sonst StateError
           bool istTaeter(String rolle)           // NUR verdeckt (oder nach dem Finale)
           ({String a, String b}) wahl(String rolle) // Rundenwahl der laufenden Runde, NUR verdeckt; bei der Täterrolle ist b die Sabotage
  Runde:   String get rundenName · String get rundenKern · String get rundenUhrzeit ("00:30")
           List<({Gespraech gespraech, String partner})> gespraeche(int runde)  // Pflichtgespräche aller besetzten Rollen mit tatsächlichem Partner
  Gruppenwahl: List<String> get offeneWaehler · bool get alleGestimmt · void stimme(String rolle, {required bool kooperativ}) // NUR verdeckt; schließt die Ansicht, wertet nach der letzten Stimme aus
  Karte:   Entscheidung? get laufendeEntscheidung · KartenZiel? get vorschlag · Map<String,List<Aufdeckung>> get funde · letzterFund …  (Kartenbildschirm baut ORCH)
  Anklage: List<String> get kernverdaechtige · void anklagen(String person) · String? get angeklagt
  Nach dem Finale: bool get nachFinale · String get pfad · EndeRegel get ende (id, name, richtig) · Rueckblende get rueckblende   // vorher StateError
  Spiel (nur lesen): sitzung.spiel.punkte (erst nach dem Finale anzeigen), sitzung.kanon.fall['titel'|'untertitel'|'runden']
mordakte_core (package:mordakte_core/mordakte_core.dart):
  class Dossier { String rolle; bool taeter; String wer, ziel, besetzung; String? tarnung; List<DossierZeile> weiss, verbirgt, tatwissen; Map<int, List<(Gespraech, String)>> gespraeche /* Runde → (Gespräch, Partner-Kennung) */; Map<int, WahlText?> wahlen }
  class DossierZeile { String art; String text; String? behauptung }  // art 'luege': text = Wahrheit, behauptung = was die Rolle behauptet
  class Gespraech { String id, rolle, partner, thema, ziel, text; int runde, nr; List<String> preisgabe }
  class WahlText { String id, a, b; String? sabotage }
  class KartenZiel { String option, entscheidung; ZielArt art (person|gegenstand|raum); String kanonId; String? person; String raum; String name }
  class Aufdeckung { String fakt; bool entstanden; String text }
lib/party/party_stil.dart (gemeinsamer Stil – nur benutzen):
  Keller.* Farben (nacht, stein, kerze, kerzeHell, papier, papierGedaempft, linie, gefahr, notlicht) und TextStyles (titel, ueberschrift, text, leise, marke, erzaehler), Keller.breite
  PartyRahmen({child, marke, titel, untertitel, aktionen: [Widget], scroll: true}) · PartyKnopf({text, onPressed, haupt: true, icon}) · PartyTafel({child, padding, akzent: Color?}) · FarbPunkt(Color, {groesse})
lib/party/erzaehler_ausgabe.dart → ErzaehlerFeld({required PartySitzung sitzung, required List<String> kennungen})  // zeigt Bausteine wortgleich
lib/party/rueckblende_ansicht.dart → RueckblendeAnsicht({required PartySitzung sitzung, VoidCallback? onFertig})  // Zeitraffer auf der Karte, erst nach dem Finale
Testhilfe test/party_widgets/hilfe.dart (nur benutzen): PartyDaten get partyDaten · PartySitzung neueSitzung({int? rollen, String pfad = 'ahmet', String detektiv = 'w'}) · void spieleBis(PartySitzung s, PartyPhase ziel, {int? runde}) · Widget rahmen(Widget kind)
Zuordnung Phase → Bildschirm steht in lib/party/party_seite.dart (Funktion bildschirm(s)); Beispiel für Tests: test/party_widgets/ablauf_test.dart.

TEXTE DER OBERFLÄCHE (F-11, Verzahnung):
- Kein sichtbarer Text als Zeichenkette im Dart-Code. Jeder sichtbare Satz, jedes Wort auf Knöpfen und Überschriften kommt aus sitzung.ui('ui.…'), sitzung.text(…) oder aus Kanon-Daten (Namen, Titel, Dossier, Fundtexte). Erlaubt im Code sind nur Satzzeichen, Ziffern und Trenner wie ' · '.
- Deine UI-Bausteine stehen NUR in deiner eigenen Datei (siehe EIGENE DATEIEN) im Format {"settingId":"spuk_im_schlosskeller","bereich":"ui","hinweis":"…","eintraege":[{"id":"ui.<präfix>.<name>","text":"…"}]}. Kennungen nur Kleinbuchstaben, Ziffern, Unterstrich, Punkte. Jede Kennung nur einmal im ganzen Projekt.
- Vorhandene gemeinsame Bausteine (ui.json, nur lesen): ui.allgemein.weiter, ui.allgemein.zurueck, ui.allgemein.detektiv, ui.allgemein.runde ({nr}), ui.allgemein.uhrzeit ({uhrzeit}), ui.verdeckt.frage ({name}), ui.verdeckt.weitergeben ({name}), ui.verdeckt.schliessen, ui.verdeckt.neutral.
- Ton (TON-LEITFADEN): Du-Form an die Gruppe, kurze Sätze (höchstens 20 Wörter), Alltagssprache, keine Fachwörter, keine Zungenbrecher, kein Alkohol, keine Drogen, kein Rauchen, keine Marken, freundlich und ein wenig schaurig-schön.

GRENZEN: Ändere NUR deine eigenen Dateien (Liste oben); lege keine weiteren an. Keine anderen Dateien, kein Kanon, kein pubspec, kein `flutter pub get`, keine neuen Abhängigkeiten, kein Netz. Keine Git-Befehle außer git status und git diff (nur lesen). Nichts außerhalb des Repos schreiben (außer System-Temp). Drei andere Baumeister arbeiten gleichzeitig im selben Repo an anderen Dateien: fasse sie nicht an; sind deren Dateien gerade unfertig oder rot, ist das nicht dein Befund – prüfe nur deine eigenen Dateien. Zeigt „Waiting for another flutter command to release the startup lock“, einfach warten. Spoilerschutz (E-008): Vor dem Finale verrät dein Bildschirm nie, wer der Täter ist – außer in der verdeckten Ansicht der Täterrolle selbst. Nie eine Stimmenzahl, nie die Qualität eines Hinweises anzeigen.

ARBEITSSCHRITTE:
1. Behalte die öffentliche Schnittstelle ErzaehlerFeld({super.key, required PartySitzung sitzung, required List<String> kennungen}) exakt bei (andere Bildschirme benutzen sie). Mache daraus ein StatefulWidget.
2. Darstellung: je Baustein eine PartyTafel mit Keller.erzaehler, Text exakt sitzung.text(kennung). Bausteine, deren Kennung mit 'intro.lacher.' beginnt, tragen oben eine kleine Marke (Baustein „Rückblick“). Sanftes Einblenden je Tafel (höchstens 400 ms, gestaffelt); der volle Text ist sofort im Widgetbaum (Tests und Bedienhilfen).
3. Kopfzeile des Feldes: Schalter „Erzählerstimme“ (Icon volume_up/volume_off mit Tooltip-Baustein) bindet sitzung.stimmeAn; ein Knopf „Noch einmal vorlesen“ nur, wenn die Stimme an ist und eine Stimme verfügbar ist.
4. lib/party/stimme.dart: abstract class Stimme { bool get verfuegbar; Future<bool> sprich(String text); void stopp(); static Stimme erzeugen() } mit bedingtem Import: export 'stimme_stub.dart' if (dart.library.js_interop) 'stimme_web.dart'; beide Dateien definieren Stimme erzeugeStimme(). Stub: verfuegbar false, sprich liefert false.
5. stimme_web.dart: nur dart:js_interop (kein package:web, keine neue Abhängigkeit). window.speechSynthesis und SpeechSynthesisUtterance über @JS-Erweiterungstypen. Nur Stimmen mit localService == true und lang, das mit 'de' beginnt; gibt es keine, ist verfuegbar false. Sprache de-DE, Tempo 0.95.
6. Wortgleich-Prüfung (7.12): Eine Funktion bool wortgleich(PartySitzung s, String kennung, String text) → text == s.text(kennung). Vor jedem Vorlesen prüft das Feld wortgleich; nur dann wird gesprochen, sonst bleibt es beim Bildschirmtext. Bei stimmeAn liest das Feld nach dem Aufbau alle Bausteine nacheinander vor; stopp() beim Abbauen des Widgets und beim Abschalten.
7. Schreibe ui-erzaehler.json.
8. Schreibe test/party_widgets/erzaehler_test.dart mit mindestens 7 Tests: zeigt für ['intro.start', 'runde.1.start'] genau beide Texte wortgleich; Lacher-Baustein trägt die Rückblick-Marke, andere nicht; Schalter setzt sitzung.stimmeAn; wortgleich ist wahr für den echten Text und falsch für einen veränderten; mit Stub-Stimme (Test läuft in der VM) kein Absturz bei stimmeAn = true; unbekannte Kennung führt zu einem Fehler im Test (expect(… , throwsArgumentError) über sitzung.text) und das Feld zeigt nie einen Text, der nicht aus sitzung.text kommt; kein Überlauf bei 390×844 mit allen Intro-Bausteinen.
9. Führe den Testweg aus (zusätzlich flutter analyze lib/party/stimme_web.dart) und behebe alles, bis er grün ist.

ABNAHMEKRITERIEN UND TESTWEG:
- `flutter analyze lib/party/erzaehler_ausgabe.dart lib/party/stimme.dart lib/party/stimme_web.dart lib/party/stimme_stub.dart test/party_widgets/erzaehler_test.dart` → No issues found.
- `flutter test test/party_widgets/erzaehler_test.dart` → alle grün, mindestens 7 Tests; jeder Test prüft eine Sache und kann rot werden.
- `cd packages/mordakte_core && dart run bin/party_texte.dart` → „Texte: OK“ (prüft auch deine UI-Bausteine) und `dart test test/party/texte_test.dart test/party/textpruefer_test.dart` grün.
- `grep -nE "Text\\('[A-ZÄÖÜa-zäöü]|text: '[A-ZÄÖÜa-zäöü]" lib/party/erzaehler_ausgabe.dart lib/party/stimme.dart lib/party/stimme_web.dart lib/party/stimme_stub.dart` → keine Treffer (kein sichtbarer Text im Code).
- Bildschirm bei 1280×800 und 390×844 ohne Überlauf: teste beide Größen mit tester.view.physicalSize = Size(…); tester.view.devicePixelRatio = 1; und erwarte keine Ausnahme (tester.takeException() ist null).

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 700 Wörter):
## Ergebnis F4-BAUMEISTER-05
- DATEIEN: Liste mit Zeilenzahl
- UMGESETZT: je Arbeitsschritt eine Zeile (Nr. → was, wo)
- UI-BAUSTEINE: Anzahl und Präfix
- TESTS: Anzahl, Ausgabe der letzten Zeile von flutter test
- ANALYSE: letzte Zeile von flutter analyze
- TEXTE: letzte Zeile von party_texte
- GREP: Ergebnis der Prüfung auf Text im Code
## OFFENE FRAGEN
- (oder „keine“)

SELBSTPRÜFUNG: Alle Schritte umgesetzt? Nur eigene Dateien geändert (git status zeigt nur sie)? Jeder sichtbare Text aus Bausteinen? Tests und Analyse gelaufen und grün? Spoilerschutz eingehalten?
Letzte Zeile exakt: === ENDE F4-BAUMEISTER-05 · BEREIT ZUR RÜCKGABE ===
