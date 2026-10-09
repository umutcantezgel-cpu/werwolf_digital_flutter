F4-TEST-02 · Testschreiber · Bauphase F4 · Kanon v1.0 · Schwierigkeit 3

## Testschreiber
- **Aufgabe:** schreibt automatische Tests für eine vorgegebene Schnittstelle.
- **Gute Arbeit:** Grenzwerte und Randfälle zuerst, ein Test prüft eine Sache, Testnamen sagen auf Deutsch, was erwartet wird; läuft grün und wird rot, wenn man die geprüfte Regel bricht.
- **Häufigste Fehler:** 1) Tests, die nie rot werden können, 2) Umsetzung im Test nachbauen statt Ergebnisse zu prüfen, 3) zufällige oder zeitabhängige Tests.

AUFGABE IN EINEM SATZ: Schreibe den Test, dass die Karte vor dem Finale in allen vier Pfaden gleich ist (F-12 karte_pfadgleich_test, E-008), auf der Ebene, die der Renderer wirklich bekommt.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: test/party_widgets/karte_pfadgleich_test.dart

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
ZUSÄTZLICHE API (nur benutzen): lib/party/karte_session.dart → class PartyKartenSession implements GameSession, SzenenErweiterung ( PartyKartenSession(PartySitzung sitzung, {bool rueckblendeModus = false, double zeitraffer = 25}); ValueListenable<WorldSnapshot?> world; ValueListenable<CaseView?> caseView (hotspots: Map<String,String>); void move(x, y, facing); void send(Command); Future<void> dispose(); String? npcAktion(String npcId); String? hotspotAktion(String hotspotId); SzenenLicht? get licht (dunkel, punkte: List<SzenenLichtpunkt> mit x, y, z, radius, farbe, flackern; taschenlampe; helleRaeume); Set<String>? sichtbareRaeume(double x, double y); double? hervorhebung(String npcId); LookDef? get detektivAussehen; Offset? get kamera ). Lies lib/party/karte_session.dart, lib/game/szenen_erweiterung.dart, packages/mordakte_core/lib/src/party/karte.dart und packages/mordakte_core/test/party/karte_test.dart (dort steht die Kernfassung; dein Test prüft die App-Ebene).

GRENZEN: Ändere NUR deine eigenen Dateien (Liste oben); lege keine weiteren an. Keine anderen Dateien, kein Kanon, kein pubspec, kein `flutter pub get`, keine neuen Abhängigkeiten, kein Netz. Keine Git-Befehle außer git status und git diff (nur lesen). Nichts außerhalb des Repos schreiben (außer System-Temp). Andere Agenten arbeiten gleichzeitig im selben Repo an anderen Dateien: fasse sie nicht an; sind deren Dateien gerade unfertig oder rot, ist das nicht dein Befund – prüfe nur deine eigenen Dateien. Zeigt „Waiting for another flutter command to release the startup lock“, einfach warten. Spoilerschutz (E-008): Vor dem Finale verrät dein Bildschirm nie, wer der Täter ist – außer in der verdeckten Ansicht der Täterrolle selbst. Nie eine Stimmenzahl, nie die Qualität eines Hinweises anzeigen.

ARBEITSSCHRITTE:
1. Schreibe eine Funktion, die aus einer PartyKartenSession eine vergleichbare Momentaufnahme macht: caseView.value!.hotspots (sortiert), world.value!.npcs als Liste von (id, x, y), licht (dunkel, taschenlampe, helleRaeume sortiert, punkte als (x, y, z, radius, farbe.toARGB32(), flackern)), npcAktion für jede NPC-Kennung aus world, hotspotAktion für jede Hotspot-Kennung des Szenarios (sitzung.daten.szenario.hotspots), sichtbareRaeume an den Ermittlungsorten aller Figuren (partyDaten.karte.figuren) und kamera, hervorhebung je NPC, detektivAussehen (coat, skin, hair, hat).
2. Spielverlauf je Pfad: neueSitzung(rollen: n, pfad: p) für p in den vier Pfaden; spieleBis(s, PartyPhase.entscheidungen); dann für jede der neun Entscheidungen: Momentaufnahme, s.schlageVor(option), Momentaufnahme, s.bestaetigen(), Momentaufnahme, s.fundGelesen(); dazwischen mit spieleBis(s, PartyPhase.entscheidungen, runde: r) in die nächste Runde. Die Optionen wählst du für alle Pfade gleich (Liste fest im Test: einmal die jeweils erste Option des Kanons, einmal die jeweils letzte).
3. Test 1–6: Für n in {4, 12, 20} und beide Optionslisten sind die Momentaufnahmen aller vier Pfade an jeder Stelle gleich.
4. Test 7: Vor dem Bestätigen gibt npcAktion für jede Person außerhalb der laufenden Entscheidung null zurück, für die Ziele der laufenden Entscheidung einen nicht leeren Text.
5. Test 8: Nach dem Bestätigen steht der Hotspot einer gewählten Gegenstands- oder Raumoption auf 'searched'.
6. Test 9 (Gegenprobe, muss Unterschiede finden): Nach dem Finale (spieleBis bis PartyPhase.finale) liefert PartyKartenSession(s, rueckblendeModus: true) in den Pfaden ahmet und can verschiedene kamera- oder hervorhebung-Werte nach einigen Ticks (warte mit await Future<void>.delayed(const Duration(milliseconds: 300))). So ist belegt, dass der Vergleich Unterschiede überhaupt sieht.
7. Räume jede Session mit addTearDown(session.dispose) ab; Tests sind deterministisch (keine Zufallszahlen, keine Uhrzeit außer der kurzen Wartezeit in Test 9).

ABNAHMEKRITERIEN UND TESTWEG:
- `flutter analyze test/party_widgets/karte_pfadgleich_test.dart` → No issues found.
- `flutter test test/party_widgets/karte_pfadgleich_test.dart` → alle grün, Laufzeit unter 120 s.
- Mindestens 9 Tests; jeder Test kann rot werden (Rot-Probe im Bericht belegen: was du kurz verändert hast und dass der Test dann rot war; die Veränderung danach zurücknehmen).

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 700 Wörter):
## Ergebnis F4-TEST-02
- DATEIEN: Liste mit Zeilenzahl
- UMGESETZT: je Arbeitsschritt eine Zeile (Nr. → was, wo)
- TESTS: Anzahl, Ausgabe der letzten Zeile von flutter test
- ANALYSE: letzte Zeile von flutter analyze
- ROT-PROBEN: je Probe eine Zeile
## OFFENE FRAGEN
- (oder „keine“)

SELBSTPRÜFUNG: Alle Schritte umgesetzt? Nur eigene Dateien geändert (git status zeigt nur sie)? Jeder sichtbare Text aus Bausteinen? Tests und Analyse gelaufen und grün? Spoilerschutz eingehalten?
Letzte Zeile exakt: === ENDE F4-TEST-02 · BEREIT ZUR RÜCKGABE ===
