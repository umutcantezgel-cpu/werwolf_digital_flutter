# FEINKORN · Szenenvertrag v1 (gemeinsamer Wert, nur Opus)

Über den Szenenvertrag sagt ein Spiel den Pixel-Bausteinen, was sie zeigen sollen (7.8). Der Vertrag ist spielinhaltsfrei: Kennungen sind Zeichenketten des Spiels, Inhalte kommen über Rezepte. Ein Kanon-Adapter des Spiels (`lib/game/feinkorn/kanon_adapter.dart`) übersetzt `content/party/schlosskeller/*.json` in diesen Vertrag.

## Maßstab und Achsen
1 Kachel = 1 m; x nach Osten, y nach Süden, z nach oben (wie `raeume.json` und `lib/game/iso_math.dart`). Ansicht isometrisch 2:1 (32/16/40 logische Pixel je Meter).

## Szene
```
Szene {
  id
  orte:      [Ort { id, rechteck (x, y, breite, laenge), hoehe, rezept, lichtvorlage }]
  koerper:   [Koerper { id, rezept, ort?, lage (x, y, z), drehung (Viertel um z), klasse: gebaeude|ausstattung|indiz,
                        beweglich: bool, zerbrechlich: bool, varianten: {schlüssel: wert} }]
  figuren:   [Figur { id, rezept, lage (x, y), blick (Winkel), zustand, ruhe (Ruhe-Animation), ausdruck }]
  lichter:   [Licht { id, art: punkt|kegel|leuchtend, lage, farbe 0xRRGGBB, radius, flackern 0..1, an: bool }]
  sicht:     { ortId: 0..1 }      // Nebel des Krieges: 0 = schwarz, 1 = sichtbar; Übergänge blendet die Darstellung
  klasse:    hoch|mittel|einfach  // Geräteklasse (Budget)
  saat:      int                  // Startwert für alles Zufällige (Determinismus)
}
```

## Ereignisse (Spiel → Bausteine)
| Ereignis | Wirkung |
|---|---|
| `TuerAuf(id)` / `TuerZu(id)` | Tür-Körper dreht, Ort hinter der Tür wird sichtbar (Aufblende radial 0,4 s, wenn `sicht` wechselt) |
| `Faellt(koerperId, impuls)` | Körper wird beweglich, Physik übernimmt; Aufprall → Klang, Bruch, Partikel |
| `Stoss(koerperId, impuls, punkt)` | Impuls auf einen Körper (umwerfen) |
| `GehtZu(figurId, x, y)` | Wegfindung über begehbare Flächen, Ausweichen |
| `Zustand(figurId, zustand)` | stehen, gehen, sitzen, tuer_oeffnen, untersuchen, erschrecken, lampe_schwenken, reden |
| `Ausdruck(figurId, ausdruck)` | Augen, Brauen, Mund (wenige Zustände) |
| `Licht(lichtId, an, flackern?)` | Lichtwechsel; Ruhendes wird bei Bedarf neu gebacken |
| `Sicht(ortId, wert)` | Nebel des Krieges je Ort |
| `Spur(ortId, art, lage, saat)` | Story-Spuren: scherben, splitter, russ, wachs |
| `Rueckblende(start|stopp, aufnahme)` | spielt eine Ereignisaufnahme deterministisch ab |

## Rückmeldungen (Bausteine → Spiel)
`Aufprall(koerperId, material, staerke, lage)` · `Ruht(koerperId)` · `Angekommen(figurId)` · `Tipp(x, y) → koerperId|figurId?` (Treffertest für Bedienung).

## Pflichten
- Alles Zufällige aus `saat` (gleiche Eingabe → gleiches Bild).
- Unsichtbare Orte (`sicht` = 0) werden nicht gebacken und nicht simuliert.
- Die Bausteine kennen keine Spielregeln, Texte oder Namen.
