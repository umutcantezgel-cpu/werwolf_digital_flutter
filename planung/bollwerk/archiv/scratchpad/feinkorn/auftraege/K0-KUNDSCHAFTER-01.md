K0-KUNDSCHAFTER-01 · Kundschafter · Bauphase K0 · Version 1 · Schwierigkeit 1

## Rollenbriefing (Kundschafter)
- Aufgabe: Code und Daten lesen und belastbar berichten, mit Datei:Zeile zu jeder Aussage.
- Gute Arbeit: vollständig (nichts ausgelassen), nachprüfbar (Fundstellen), knapp, keine Bewertung ohne Beleg.
- Häufige Fehler: (1) Stichprobe statt Vollständigkeit, (2) Vermutung als Tatsache, (3) Fundstellen ohne Zeilennummer.
- Unsicherheit: als OFFENE FRAGE notieren, nicht raten.

## Aufgabe
Erstelle die vollständige Bestandsliste aller Bilder und Grafiken, die die Mordakte-App heute zeigt (Szene, Figuren, Porträts, Gegenstände, Symbole, UI-Grafik), mit Vorschlag „Nachfolger aus Pixel-Blöcken“ oder „behalten, weil …“.

## Das Projekt in fünf Sätzen
FEINKORN ist der Ausbau einer bestehenden iOS- und Android-App: Figuren, Gebäude und Gegenstände bestehen aus winzigen Pixel-Blöcken mit Material statt aus Bildern. Jeder Block erfüllt eine Funktion – er bestimmt, wie etwas aussieht, Licht annimmt, klingt, sich bewegt und zerbricht –, und abgelöste Blöcke fliegen als Dreck, Splitter oder Krümel und bleiben liegen. Figuren aus Pixel-Blöcken bewegen sich lebendig mit Skelett, Ruhe-Animationen und nachschwingender Kleidung. Alles baut auf der vorhandenen Technik auf, ändert sie nicht und läuft schonend auf Handys. Erstes Werkstück ist der Schlosskeller des Murder-Mystery-Spiels; jede Arbeit wird gemessen, nach Checkliste geprüft und nur vom Orchestrator integriert.

## Auszug Szenenvertrag/Kanon
Kanon des Schlosskellers: /home/user/feinkorn/content/party/schlosskeller/ (raeume.json mit `einrichtung[].darstellung`, figuren.json mit `visualSpecs`, gegenstaende.json). Nur lesen.

## Schnittstellen
Keine (reiner Bericht).

## Eigene Dateien
Nur: /home/user/feinkorn/planung/feinkorn/BESTAND-BILDER.md (neu anlegen, Ordner ggf. anlegen).

## Grenzen (Bestandsschutz)
- Keine andere Datei ändern, nichts committen, nichts pushen, nichts installieren.
- Keine Sitzungs-, Agenten-, Trigger- oder Remote-Werkzeuge.
- Den Ordner /home/user/werwolf_digital_flutter NICHT verwenden; Arbeitsordner ist /home/user/feinkorn.

## Arbeitsschritte
1. Lies in /home/user/feinkorn: lib/game/scene/*.dart (floor_painter, wall_painter, prop_painter, figure_painter, markers, lighting, weather, iso_pen, palette, static_scene), lib/ui/widgets/portrait.dart, lib/ui/icons.dart, lib/ui/**, lib/game/game_view.dart, lib/game/input/*.dart, lib/game/mordakte_game.dart (nur Zeichenaufrufe), web/icons, android/app/src/main/res/mipmap-*, ios/Runner/Assets.xcassets.
2. Liste JEDES gezeichnete Element (z. B. jede Prop-Art in `prop_painter.dart` mit ihrem `case`, jede Figurenpose, jeder Marker-Typ, Porträt-Teile, Wettereffekte, UI-Symbole) als Tabellenzeile: Nr · Element · Art (Raum/Wand/Boden/Requisit/Figur/Porträt/Marker/Licht/Wetter/UI/Symbol/App-Icon) · Fundstelle Datei:Zeile · im Schlosskeller benutzt? (ja/nein mit Beleg, z. B. `darstellung`-Wert aus raeume.json) · Vorschlag (Nachfolger aus Pixel-Blöcken | behalten, weil …).
3. Ordne alle `darstellung`-Werte aus content/party/schlosskeller/raeume.json (`einrichtung`) den Prop-Arten zu; liste Werte ohne Zeichnung.
4. Zähle am Ende: Elemente gesamt, davon im Schlosskeller benutzt, Vorschläge Nachfolger / behalten.

## Abnahmekriterien und Testweg
- Jede Prop-Art aus prop_painter.dart ist gelistet (Testweg: Orchestrator vergleicht mit grep nach `case '`).
- Jede Zeile hat Datei:Zeile.
- Vorschlag „behalten“ nur für Bedienelemente, Symbole, App-Icons oder mit konkreter Begründung.

## Ausgabeformular
ÄNDERUNGEN (Dateien) · ERGEBNIS (Zahlen aus Schritt 4) · OFFENE FRAGEN · SELBSTPRÜFUNG.

## Selbstprüfung
- Habe ich alle Dateien aus Schritt 1 gelesen? Hat jede Zeile eine Fundstelle? Ist nur BESTAND-BILDER.md neu?

=== ENDE K0-KUNDSCHAFTER-01 · BEREIT ZUR RÜCKGABE ===
