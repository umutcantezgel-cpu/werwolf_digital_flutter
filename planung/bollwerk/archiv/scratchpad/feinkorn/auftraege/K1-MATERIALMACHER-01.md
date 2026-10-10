K1-MATERIALMACHER-01 · Materialmacher · Bauphase K1 · Version 1 · Schwierigkeit 2

## Rollenbriefing (Materialmacher)
- Aufgabe: Materialrezepte und Oberflächenmuster schreiben.
- Gute Arbeit: Muster ohne Rauschen, nach Material sofort lesbar, in Metern bemessen (gleich wirkend bei 2,5 / 1 / 0,5 cm), kachelfrei (keine sichtbaren Wiederholungen).
- Häufige Fehler: (1) Rauschteppich statt Struktur, (2) bekannte Texturen aus Spielen nachbauen, (3) grobe Klötzchen (Minecraft-Look) statt feiner Variation.
- Unsicherheit: OFFENE FRAGE notieren, nicht raten.

## Aufgabe
Schreibe die Oberflächenmuster für Sandstein (1) und Kalkmörtel (2) als Musterfunktionen und trage sie in registriereStein() ein.

## Das Projekt in fünf Sätzen
FEINKORN ist der Ausbau einer bestehenden iOS- und Android-App: Figuren, Gebäude und Gegenstände bestehen aus winzigen Pixel-Blöcken mit Material statt aus Bildern. Jeder Block erfüllt eine Funktion – er bestimmt, wie etwas aussieht, Licht annimmt, klingt, sich bewegt und zerbricht –, und abgelöste Blöcke fliegen als Dreck, Splitter oder Krümel und bleiben liegen. Figuren aus Pixel-Blöcken bewegen sich lebendig mit Skelett, Ruhe-Animationen und nachschwingender Kleidung. Alles baut auf der vorhandenen Technik auf, ändert sie nicht und läuft schonend auf Handys. Erstes Werkstück ist der Schlosskeller des Murder-Mystery-Spiels; jede Arbeit wird gemessen, nach Checkliste geprüft und nur vom Orchestrator integriert.

## Auszug Szenenvertrag/Kanon
Materialtabelle (gemeinsamer Wert, nur lesen): /home/user/feinkorn/packages/pixel_engine/lib/src/feinkorn/daten/material.dart. Stimmung (Master-Prompt 7.7): Gewölbekeller aus Sandstein bei Nacht, kalte Grundtöne, warme Kerzenpunkte; „jede Fuge im Sandstein, jede Kerbe in der Eichentür“.

## Schnittstellen
/home/user/feinkorn/packages/pixel_engine/lib/src/feinkorn/daten/muster.dart (lies die Regeln im Kopfkommentar!): typedef Muster = void Function(MusterOrt ort, Material m, MusterWert aus); MusterOrt hat x, y, z (Blockkoordinate im Körper), s (Blockgröße m), wx, wy, wz (Weltlage der Blockecke in m), seite (Seite.oben / sued / ost), hash (0..65535), zufall (0..1). MusterWert.setze(hell, dr, dg, db). Register: kMuster[materialKennung] = deineFunktion.
Probe: cd /home/user/feinkorn/packages/pixel_engine && /opt/flutter/bin/dart run bin/feinkorn_muster_probe.dart <png> <kennungen> (zeigt Wand, Boden, Kante in 2,5/1/0,5 cm und einen 4×-Ausschnitt).

## Eigene Dateien
Nur: /home/user/feinkorn/packages/pixel_engine/lib/src/feinkorn/daten/muster/stein.dart (Platzhalter ersetzen; Funktion registriereStein() muss bleiben) und neu /home/user/feinkorn/packages/pixel_engine/test/feinkorn_muster_stein_test.dart. Probebild nach /home/user/feinkorn/planung/feinkorn/bilder/k1/K1-MATERIALMACHER-01.png.

## Grenzen (Bestandsschutz)
Keine andere Datei ändern (nicht material.dart, nicht muster.dart, nicht alle.dart, nicht iso_backen.dart); nichts committen, pushen, installieren; keine Sitzungs-, Agenten- oder Remote-Werkzeuge; nur im Ordner /home/user/feinkorn; keine Spielinhalte (Namen, Orte, Texte des Krimis); kein dart:math Random; keine Bilddateien als Eingabe.

## Arbeitsschritte
1. Lies muster.dart, material.dart, darstellung/iso_backen.dart (wie das Muster angewendet wird) und bin/feinkorn_muster_probe.dart.
2. Erzeuge eine Probe vorher (Kennungen deiner Materialien) und sieh sie dir an (Read).
3. Gestaltung: Sandstein: feine Körnung (helle und dunkle Körner, 1–3 mm wirken als Einzelblock-Streuung nur bei 0,5 cm), waagerechte Ablagerungsschichten (Bänder 3–8 cm hoch, sanfte Helligkeitswechsel ±6 %), vereinzelte Eisenoxid-Flecken (rötlich, 5–15 cm, selten), Oberseiten etwas heller und glatter (abgetreten). Kalkmörtel: körnig-rau, leicht heller als Sandstein-Schatten, gräulich-beige, kleine Kalkeinschlüsse (hell, selten); keine Bänder.
4. Muster nur aus Blockkoordinate/Weltlage/hash ableiten; Merkmale in Metern (z. B. Abstand in m / ort.s = Blöcke). Für glatte Funktionen nutze ganzzahlige Hashes über Weltzellen (z. B. 5-cm-Zellen) und weiche Übergänge über Interpolation – kein Rauschen je Einzelblock über material.streuung hinaus.
5. Test (feinkorn_muster_stein_test.dart): je Material (a) deterministisch (gleicher Ort → gleiches Ergebnis), (b) hell in 0,6..1,4 und dr/dg/db in −24..24 über 10 000 Orte, (c) Maßstab: die mittlere Helligkeit über 1 m² ist bei s = 0,025 / 0,01 / 0,005 gleich (±0,03), (d) Variation vorhanden: Standardabweichung der Helligkeit über 1 m² > 0,02.
6. Probe nachher erzeugen, ansehen, beschreiben (Lesbarkeit je Blockgröße, 4×-Ausschnitt).
7. /opt/flutter/bin/dart analyze --fatal-infos und /opt/flutter/bin/dart test test/feinkorn_muster_stein_test.dart grün.

## Abnahmekriterien und Testweg
Tests grün; Probe zeigt in allen drei Blockgrößen dieselbe Struktur; Material ohne Erklärung erkennbar; kein Rauschteppich, keine Kachelung; Bild sofort an den Orchestrator (Pfad in der Rückgabe).

## Ausgabeformular
ÄNDERUNGEN · TEST · PROBE (Pfad, Beschreibung) · CHECKLISTE (Struktur, Maßstab, Rauschen, Kachel) · OFFENE FRAGEN · SELBSTPRÜFUNG.

## Selbstprüfung
Nur die eigenen Dateien? Merkmale in Metern? Kein Random? Kein Spielinhalt?

=== ENDE K1-MATERIALMACHER-01 · BEREIT ZUR RÜCKGABE ===
