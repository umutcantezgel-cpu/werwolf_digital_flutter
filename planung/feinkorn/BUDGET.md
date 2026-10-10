# FEINKORN · Budgettabelle je Geräteklasse (gemeinsamer Wert, nur Opus; E-F015)

Gilt im vollen Thekensaal mit allen Figuren (K-04). Messung: siehe ABNAHME und E-F010 (Browser-Näherung: hoch 1×, mittel 4×, einfach 6× CPU-Drosselung; echte Geräte im Testplan).

| Größe | hoch | mittel | einfach |
|---|---|---|---|
| Blockgröße Gebäude / Ausstattung / Indiz | 2,5 / 1 / 0,5 cm | 5 / 2 / 1 cm | 5 / 2 / 1 cm |
| Backskala (Bildpixel je logischem Pixel) | min(Pixeldichte, 3) | min(Pixeldichte, 2) | 1 |
| Blöcke je sichtbarem Raum (gebacken) | ≤ 4 Mio. | ≤ 1 Mio. | ≤ 0,5 Mio. |
| bewegte Blockkörper gleichzeitig | ≤ 16 | ≤ 8 | ≤ 4 |
| fliegende Partikel | ≤ 2 000 | ≤ 800 | ≤ 300 |
| dynamische Lichter | ≤ 12 | ≤ 8 | ≤ 4 |
| Ziel-Bildrate (bewegt) | 60 | 30 | 30 |
| Dart-Rechenzeit je Bild (bewegt) | ≤ 6 ms | ≤ 10 ms | ≤ 12 ms |
| 99. Perzentil Bildzeit | ≤ 33,3 ms | ≤ 66,7 ms | ≤ 66,7 ms |
| Rechenlast ruhig gegenüber bewegt | ≤ 50 % | ≤ 50 % | ≤ 50 % |
| Bildspeicher gebackener Sprites | ≤ 96 MB | ≤ 48 MB | ≤ 24 MB |
| Arbeitsspeicher-Zuwachs nach 30 min gegenüber 2 min | ≤ 10 % | ≤ 10 % | ≤ 10 % |
| Backzeit eines Raums (Hintergrund) | ≤ 1,5 s | ≤ 2,5 s | ≤ 3 s |
| erstes Bild eines aufgedeckten Raums | ≤ 0,4 s (Aufblende) | ≤ 0,4 s | ≤ 0,4 s |
| Ladezeit bis spielbar | ≤ Messbasis + 2 s | ≤ Messbasis + 2 s | ≤ Messbasis + 2 s |
| Physik | 120 Hz, ≤ 1 ms/Schritt | 120 Hz, ≤ 1 ms | 120 Hz, ≤ 1 ms |

Zuwachs der App-Größe (alle Klassen gemeinsam): ≤ 3 MB (Code und Rezepte; keine fertigen Modelle, keine neuen Klang-Dateien).

Herunterstufen (K-04, K-12): verfehlt das bewegte Spiel 10 s lang die Ziel-Bildrate oder steigt die Bildzeit im Dauerlauf um mehr als 25 % (Wärme-Näherung), sinkt die Klasse um eine Stufe: erst Partikel, dann Lichter, dann Backskala, dann Blockgröße – nie Figurenblockgröße über 2 cm. Hochstufen nach 60 s mit Reserve ≥ 30 %.
