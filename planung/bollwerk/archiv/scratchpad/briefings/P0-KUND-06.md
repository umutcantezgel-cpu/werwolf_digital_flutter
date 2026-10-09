Du bist Kundschafter im Projekt „Burgstadt HD“. Paket **P0-KUND-06 · Belegblick-Liste** (HZ-01, HZ-14).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md und /home/user/werwolf_digital_flutter/hd/rollen/KUNDSCHAFTER.md und halte dich an die Regeln.

## Hintergrund
Für jeden Vorher/Nachher-Vergleich brauchen wir feste, reproduzierbare Kamerablicke: 6 Viertel der Oberstadt, 12 Fall-Orte, Gangnetz, Burg (5 Räume + Hof), 8 Bildschirme (Erkundung, Fallakte, Hauptmenü, Lagerunde, Optionen, Stadtkarte, WLAN/Lobby, Anklage) und das Tutorial – jeweils quer (1280×720) und hoch (1080×2400). Heute wählen die Werkzeuge Blicke teils automatisch (z. B. „bester Blick“ nach Sichtweite); wir wollen eine feste Liste.

## Quellen (nur lesen)
- `packages/burgstadt_spiel/bin/belegfotos.dart` (wie Viertel-, Innenraum- und Bildschirmfotos heute gewählt werden: `Kamerablick`, `sichtweite`, Auswahl)
- `packages/burgstadt_spiel/bin/bereichsfotos.dart`, `stadtfotos.dart`, `bildschirmfoto.dart`, `spieltest.dart`
- `packages/burgstadt_core/data/stadt/haeuser.json` (Viertel), `packages/burgstadt_core/data/innenraeume/fallorte.json` (Fall-Orte), `packages/burgstadt_core/lib/src/welt/burg.dart`, `stadtgenerator.dart`
- `packages/burgstadt_spiel/lib/src/bildschirme/*.dart` (welche Bildschirme es gibt, wie man sie im Werkzeug öffnet)

## Auftrag
1. Lies, wie belegfotos.dart die Blicke heute bestimmt, und beschreibe das Verfahren (Datei:Zeile).
2. Führe die heutigen Werkzeuge aus, um die tatsächlich gewählten Blicke zu erhalten: `cd /home/user/werwolf_digital_flutter/packages/burgstadt_spiel && /opt/flutter/bin/dart run bin/belegfotos.dart /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/kund06/quer 1280 720` und dasselbe mit `1080 2400` in `.../kund06/hoch`. Falls das Werkzeug die gewählten Positionen nicht ausgibt, ermittle sie, indem du eine KOPIE des Werkzeugs im Scratch-Ordner `/tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/kund06/` anlegst, die zusätzlich `marke x z yaw` druckt, und diese Kopie mit `dart run <pfad>` aus dem Paketordner startest (Repo-Dateien nicht ändern).
3. Schreibe `/home/user/werwolf_digital_flutter/hd/kundschaft/P0-KUND-06.md`:
   - `# P0-KUND-06 · Belegblicke` + Commit.
   - Tabelle `| Nr | Gruppe (Viertel/Fall-Ort/Gangnetz/Burg/Bildschirm/Tutorial) | Name | Bereich-id | x | z | yaw | pitch | Format(e) | Herkunft (heutiges Werkzeug Datei:Zeile oder neu) |` – vollständig: 6 Viertel, 12 Fall-Orte (Namen aus fallorte.json), Gangnetz (≥ 2 Blicke), Burg (5 Räume + Hof), 8 Bildschirme, Tutorial; Werte mit 2 Nachkommastellen.
   - Für Bildschirme statt Kamera: wie der Bildschirm im Werkzeug erreicht wird (Funktion/Zeile).
   - Hinweis, welche Blicke bei 1080×2400 (hochkant) anders gewählt werden müssen.
   - OFFENE FRAGEN, SELBSTPRÜFUNG (Anzahl Blicke je Gruppe), letzte Zeile `ENDE PAKET P0-KUND-06`.

Ändere keine Dateien im Repo außer der Ausgabedatei. Zeige keine Bilder; nenne nur Pfade. Antworte am Ende knapp mit der Zahl der Blicke je Gruppe und dem Dateipfad.
