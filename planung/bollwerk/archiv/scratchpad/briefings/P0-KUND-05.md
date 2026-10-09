Du bist Kundschafter im Projekt „Burgstadt HD“. Paket **P0-KUND-05 · Bestandsaufnahme der Raumvorlagen** (HZ-07).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md und /home/user/werwolf_digital_flutter/hd/rollen/KUNDSCHAFTER.md und halte dich an die Regeln.

## Hintergrund
Burgstadt HD stattet jeden Innenraum mit eigener Möbelgeometrie (Formen), Wandaufbau (Fußleiste, Täfelung, Balkendecke) und Deko an Wänden, Decke und auf Möbeln aus. Dafür brauchen wir je Raumvorlage: Raumart, Maße, vorhandene Möbel (Formen), freie Wandflächen und Fenster.

## Quellen (nur lesen)
- `packages/burgstadt_core/data/innenraeume/haeuser.json` und `fallorte.json` (die Raumvorlagen: `bereiche` mit `id`, `name`, `karte` (Zeichenraster, 1 Zeichen = 0,5 m Kachel), `legende` (Zeichen → art/form/hoehe/textur/station/licht), `marken`, Wand-/Boden-/Deckentextur, Raumhöhe)
- `packages/burgstadt_core/lib/src/welt/bereich.dart` (Bedeutung der Felder, `KachelArt`)
- `packages/burgstadt_core/lib/src/welt/burg.dart` (die 5 Burgräume und der Hof, als Dart-Code)
- `packages/burgstadt_core/lib/src/welt/stadtgenerator.dart` und `oberstadt.dart` (Gangnetz `gaenge`; welche Vorlagen werden wie oft auf Häuser verteilt; wird die Vorlagen-ID überschrieben?)
- `packages/burgstadt_spiel/lib/src/welt_geometrie.dart` (wie Möbel heute gezeichnet werden: `switch (l.form)`)

## Auftrag
Schreibe `/home/user/werwolf_digital_flutter/hd/kundschaft/P0-KUND-05.md`:
1. `# P0-KUND-05 · Raumvorlagen` + Commit (`git -C /home/user/werwolf_digital_flutter rev-parse --short HEAD`).
2. **Formen-Inventar**: alle verschiedenen `form`-Werte in allen Legenden (Daten + burg.dart) mit Anzahl Vorkommen, typischer Höhe und wie welt_geometrie.dart sie heute zeichnet (Quader / eigene Geometrie, Datei:Zeile).
3. **Tabelle je Vorlage** (alle Vorlagen aus haeuser.json und fallorte.json, dazu 5 Burgräume, Hof und Gangnetz):
   `| id | Quelle Datei:Zeile | Name | Raumart (Wohnstube/Zunftstube/Werkstatt/Speicher/Laden/Fall-Ort/Burg/Gewölbe/Gang) | Größe (Kacheln B×T, Meter) | Raumhöhe | Wand/Boden/Decke-Textur | Möbel (form×Anzahl) | Stationen | Türen | Fenster (vorhanden? wie dargestellt?) | freie Wandlänge (m, grob) |`
   „Freie Wandlänge“: Summe der Wandkanten (Wandkachel neben begehbarer Kachel), an denen weder Tür noch Möbel (Objekt-Kachel) direkt anliegt – zähle mit einem kleinen Skript (Python oder Dart im Scratch-Ordner /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/kund05/, nicht im Repo), nicht schätzen.
4. **Raumarten-Zählung**: Anzahl Vorlagen je Raumart; Anzahl erzeugter Innen-Bereiche in der Stadt je Vorlage, falls der Generator Vorlagen mehrfach verwendet (Datei:Zeile der Logik).
5. **Vorlagen-ID**: wo und wie der Generator die `id` eines Bereichs beim Verteilen auf Häuser setzt (überschreibt er die Vorlagen-ID?), mit Datei:Zeile.
6. OFFENE FRAGEN, SELBSTPRÜFUNG (Zahl der Vorlagen je Datei, Skriptpfad), letzte Zeile `ENDE PAKET P0-KUND-05`.

Ändere keine Dateien im Repo außer der Ausgabedatei. Antworte am Ende knapp mit Anzahl Vorlagen, Anzahl Formen und dem Dateipfad.
