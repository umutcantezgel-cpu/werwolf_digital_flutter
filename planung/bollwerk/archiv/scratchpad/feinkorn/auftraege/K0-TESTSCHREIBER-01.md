K0-TESTSCHREIBER-01 · Testschreiber · Bauphase K0 · Version 1 · Schwierigkeit 2

## Rollenbriefing (Testschreiber)
- Aufgabe: Verhalten einer Schnittstelle mit schnellen, deterministischen Tests absichern.
- Gute Arbeit: jeder Test prüft eine klare Aussage mit erwarteten Zahlen; Grenzfälle (Ränder, leere/volle/einheitliche Abschnitte); Tests laufen in Sekunden.
- Häufige Fehler: (1) Tests, die nur „läuft ohne Fehler“ prüfen, (2) Erwartungswerte aus dem Code abschreiben statt herleiten, (3) langsame Tests mit riesigen Körpern.
- Unsicherheit: OFFENE FRAGE notieren, nicht raten; eine Abweichung des Codes vom Doku-Kommentar ist ein BEFUND, kein Grund, den Test anzupassen.

## Aufgabe
Schreibe die Tests für die Blockdaten (Blockkoerper, Farbtafel, Materialtabelle) und die Trennungsprüfung der Pixel-Bausteine.

## Das Projekt in fünf Sätzen
FEINKORN ist der Ausbau einer bestehenden iOS- und Android-App: Figuren, Gebäude und Gegenstände bestehen aus winzigen Pixel-Blöcken mit Material statt aus Bildern. Jeder Block erfüllt eine Funktion – er bestimmt, wie etwas aussieht, Licht annimmt, klingt, sich bewegt und zerbricht –, und abgelöste Blöcke fliegen als Dreck, Splitter oder Krümel und bleiben liegen. Figuren aus Pixel-Blöcken bewegen sich lebendig mit Skelett, Ruhe-Animationen und nachschwingender Kleidung. Alles baut auf der vorhandenen Technik auf, ändert sie nicht und läuft schonend auf Handys. Erstes Werkstück ist der Schlosskeller des Murder-Mystery-Spiels; jede Arbeit wird gemessen, nach Checkliste geprüft und nur vom Orchestrator integriert.

## Auszug Szenenvertrag/Kanon
Die Pixel-Bausteine (package:pixel_engine/feinkorn.dart) enthalten keinen Spielinhalt: keine Namen, Orte oder Texte des Murder-Mysterys (Master-Prompt §3).

## Schnittstellen
/home/user/feinkorn/packages/pixel_engine/lib/src/feinkorn/daten/blockkoerper.dart (Blockkoerper: blockgroesse, breite/tiefe/hoehe, eintrag(Farbeintrag), wert, setze, fuelle, bloecke, speicherBytes, jederBlock; Abschnitte 32³: leer / einheitlich / voll) und daten/material.dart (kMaterialien, materialVon, Bruchmuster, Klang). Lies beide vollständig.

## Eigene Dateien
Nur neu: /home/user/feinkorn/packages/pixel_engine/test/feinkorn_daten_test.dart und /home/user/feinkorn/packages/pixel_engine/test/feinkorn_trennung_test.dart.

## Grenzen (Bestandsschutz)
Keine andere Datei ändern (auch nicht lib/), nichts committen, pushen, installieren; keine Sitzungs-, Agenten- oder Remote-Werkzeuge; nur im Ordner /home/user/feinkorn. Keine neuen Abhängigkeiten (pubspec bleibt).

## Arbeitsschritte
1. feinkorn_daten_test.dart: (a) leerer Körper: bloecke 0, wert überall 0, auch außerhalb; (b) setze/wert Rundreise an Ecken, Abschnittsgrenzen (31/32/33), Rand; (c) fuelle über mehrere Abschnitte: ganze Abschnitte werden einheitlich (speicherBytes klein: nur das Einheitlich-Feld), Teilabschnitte voll; bloecke = Volumen exakt; (d) einheitlicher Abschnitt am Körperrand (z. B. breite 40) zählt nur die Blöcke im Körper; (e) setze in einheitlichen Abschnitt wandelt ihn in vollen, Rest bleibt gleich; (f) jederBlock besucht genau bloecke Blöcke, jeden einmal; (g) Farbtafel: gleiche Einträge ergeben gleichen Index, Index 0 ist Luft, 256. Eintrag wirft StateError; (h) Materialtabelle: 14 Materialien mit Kennung 1..14 in Reihenfolge, Namen Sandstein, Kalkmörtel, Eiche, Eisen, Messing, Glas, Wachs, Stoff, Leder, Porzellan, Papier, Ruß, Staub, Erde; alle Eigenschaften in gültigen Bereichen (streuung, rauheit, haerte, abprall in 0..1; dichte > 0); Schüttgut (bruch koerner oder kruemel) hat boeschungGrad > 0; materialVon(0) == null.
2. feinkorn_trennung_test.dart: liest alle .dart-Dateien unter lib/src/feinkorn/ und lib/feinkorn.dart und prüft: (a) kein Import aus mordakte_core, burgstadt_*, flutter oder ../../ außerhalb von src/feinkorn (erlaubt: dart:, eigene relative Pfade innerhalb src/feinkorn, package:pixel_engine/feinkorn.dart); (b) keine verbotenen Wörter (Groß/Klein egal) aus dieser Liste: schlosskeller, mordakte, detektiv, schneider, ahmet, fatma, olli, can (nur als ganzes Wort), thekensaal, kerzenständer, kerzenstaender, buffetsaal, kaminsaal, turmgang, vorratsraum, windfang, burgstadt, schartenfels. Gib bei Treffern Datei:Zeile im Fehlertext aus.
3. Führe aus: cd /home/user/feinkorn/packages/pixel_engine && /opt/flutter/bin/dart analyze --fatal-infos test/feinkorn_daten_test.dart test/feinkorn_trennung_test.dart && /opt/flutter/bin/dart test test/feinkorn_daten_test.dart test/feinkorn_trennung_test.dart
4. Wenn ein Test einen echten Fehler im Code zeigt: Test NICHT abschwächen, sondern als BEFUND melden (Datei:Zeile, erwartete und tatsächliche Werte).

## Abnahmekriterien und Testweg
Beide Dateien analysieren ohne Befund; alle Tests laufen in < 10 s; jede Aussage aus Schritt 1 und 2 ist ein eigener test(); Befunde gemeldet statt verdeckt.

## Ausgabeformular
ÄNDERUNGEN · TEST (Befehl, Ergebnis) · BEFUNDE · OFFENE FRAGEN · SELBSTPRÜFUNG.

## Selbstprüfung
Nur die zwei Testdateien neu? Keine Schwellen erfunden? Befunde nicht weggetestet?

=== ENDE K0-TESTSCHREIBER-01 · BEREIT ZUR RÜCKGABE ===
