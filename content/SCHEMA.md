# Mordakte – Szenario-Format (`content/scenarios/<id>.json`)

Ein Szenario ist **eine** JSON-Datei. App (als Asset) und Server (von Platte) laden alle
`*.json` in `content/scenarios/`. Die Dart-Modelle stehen in
`packages/mordakte_core/lib/src/scenario/scenario_def.dart`, ein vollständiges kleines
Beispiel in `packages/mordakte_core/lib/src/scenario/sample_scenario.dart`.

Prüfen: `dart run packages/mordakte_core/bin/validate.dart content/scenarios/<id>.json`

## Grundregeln

- Alle Texte sind Objekte `{"de": "..."}` (Englisch später als `"en"` daneben).
- Alle IDs sind eindeutig (Präfixe: Hotspots `h_`, Hinweise `c_`, Items `i_`, Spuren `l_`, Kombis `k_`).
- Koordinaten sind Kacheln: `x` = Spalte (nach Osten), `y` = Zeile (nach Süden), Ursprung oben links.
- Der Bildschirm ist isometrisch: Norden/Westen sind „hinten“, Süden/Osten „vorne“.

## Ablauf, den das Szenario füllt

3 Kapitel. Kapitel 1 und 2: Intro → Ermittlung (4 Min) → Beratung (Spurwahl) → Nacht.
Kapitel 3: Intro → Ermittlung → Anklage → Ende. In der Nacht jagt der „Schatten“ (der
NPC-Täter) isolierte Detektive, tötet evtl. einen Zeugen und beschädigt ungeteilte Notizen.

## Felder

| Feld | Inhalt |
|---|---|
| `id` | Dateiname ohne `.json`, z. B. `ravensmoor` |
| `title`, `tagline`, `synopsis` | Titel, Einzeiler, Fallakte (2–4 Sätze) |
| `difficulty` (1–3), `minutes` | Anzeige im Fallakten-Menü |
| `theme` | `palette` (alle 11 Schlüssel als `#rrggbb`: background, floor, floorAlt, wall, wallTop, trim, accent, light, danger, text, fog), `weather` (`rain`/`snow`/`neon`/`dust`/`none`), `lightning` (bool), `dayAmbient` (0..1), `nightAmbient` (0..1) |
| `map` | siehe unten |
| `hotspots` | siehe unten |
| `items` | `{id, type, x, y, chapter}` – type: `coffee`, `battery`, `salts`, `antidote`, `medkit`, `flare` |
| `victim` | `{name, text, hotspot, look}` – `hotspot` zeigt auf den `body`-Hotspot |
| `traits` | Merkmale: `{"shoe": {"label": {...}, "values": {"sneaker": {...}, ...}}}` |
| `suspects` | siehe unten |
| `motives`, `weapons` | `{id, name, reveal}` – `reveal` ist der Text des aufgedeckten Motiv-/Waffen-Hinweises und muss zu **jedem** Täter passen |
| `story` | Wahrheit des ersten Durchlaufs `{culprit, motive, weapon}` |
| `clues` | siehe unten |
| `combos` | siehe unten |
| `chapters` | genau 3, siehe unten |
| `endings` | siehe unten |

### `map`

```json
"map": {
  "rows": ["####", "#..#", "#..#", "####"],
  "rooms": [{"id": "salon", "name": {"de": "Salon"}, "x": 1, "y": 1, "w": 2, "h": 2, "floor": "carpet", "lit": true, "outdoor": false}],
  "props": [{"type": "sofa", "x": 1, "y": 1, "color": "#552222"}],
  "spawn": [[1, 2], [2, 2]],
  "councilRoom": "salon"
}
```

- `rows`: alle Zeilen **gleich lang**, max. 30×30. Zeichen: `#` Wand, `W` Wand mit Fenster,
  `.` Boden, `+` Tür (offen), `L` verschlossene Tür (öffnet sich nur durch eine Spur), ` ` Leere.
- Jeder Raum ist ein Rechteck **innerhalb** der Wände (nur Bodenkacheln). Räume dürfen sich
  nicht überlappen. Türkacheln liegen in der Wand zwischen zwei Räumen.
- `floor`: `parquet`, `planks`, `carpet`, `checker`, `tiles`, `stone`, `metal`, `linoleum`,
  `grass`, `gravel`, `asphalt`, `snow`.
- `lit: true` = Schutzraum: nachts beleuchtet, dort greift der Schatten nicht an. 1–2 Räume,
  inkl. `councilRoom`.
- `outdoor: true` = Wetter-Partikel fallen hier sichtbar.
- Props sind 1×1 Kacheln auf Bodenkacheln. Typen: `table chair armchair sofa bed desk bookshelf
  cabinet wardrobe piano fireplace plant lamp clock crate barrel bathtub sink toilet counter stove
  fridge seat luggage statue vending neon_sign pool_table bar_stool tv bush tree car candles`
  (blockieren) und `rug bloodstain papers puddle` (Dekor, begehbar).
  **Hohe Props** (bookshelf, cabinet, wardrobe, clock, fridge, statue, vending, lamp, tree,
  fireplace, neon_sign) gehören an die **Nord- oder Westwand** eines Raums, sonst verdecken sie Spieler.
- **Begehbarkeit**: Jede Bodenkachel muss vom Spawn aus erreichbar sein (verschlossene Türen
  zählen als offen). Props dürfen keine Durchgänge/Türen blockieren. Lass in jedem Raum einen
  freien Weg von mindestens 1 Kachel Breite zwischen allen Türen.
- `spawn`: 6 freie Bodenkacheln im `councilRoom`.

### `hotspots`

```json
{"id": "h_desk", "name": {"de": "Schreibtisch"}, "x": 3, "y": 2, "kind": "search",
 "searchMs": 2500, "requires": {"lead": "l_x"} , "fromChapter": 1, "ghost": false}
```

- `kind`: `search` (durchsuchen), `lab` (genau **1** pro Szenario), `hide` (Versteck, 2–3, am
  besten auf einem `wardrobe`/`cabinet`), `blood` (nur für Forensik-Blick sichtbar, 1–2),
  `body` (genau 1, die Leiche – auf einer **freien** Bodenkachel).
- Ein Hotspot liegt auf einem Prop (z. B. Schreibtisch) **oder** einer Bodenkachel; er muss von
  einer begehbaren Nachbarkachel aus erreichbar sein.
- `requires`: `{"class": "forensic"|"profiler"|"excop"|"journalist"|"medic"}` oder
  `{"lead": "<lead-id>"}`. `ghost: true` = nur Geister sehen ihn (1–2 pro Szenario, mit
  `ghost`-Hinweis).

### `suspects` (4–5)

```json
{"id": "butler", "name": {...}, "role": {...}, "bio": {...},
 "look": {"coat": "#1d1d22", "skin": "#e2b99a", "hair": "#cfcfcf", "hat": "none", "build": "tall"},
 "x": 12, "y": 14, "traits": {"shoe": "lacquer", "hand": "right"},
 "candidate": true, "motives": ["debt"], "witness": true,
 "lines": {"greet": {...}, "alibi": {...}, "alibiLie": {...}, "victim": {...},
           "observation": {...}, "rumor": {...}, "nervous": {...}, "annoyed": {...}}}
```

- `x/y`: freie Bodenkachel, an der die Person steht.
- `hat`: `none bowler fedora cap bun top beret cloche`; `build`: `slim normal broad tall small`;
  `outfit`: `suit` (Standard) oder `dress` (Kleid).
- `traits`: Wert für **jedes** Merkmal aus `traits`.
- `candidate`: kann Täter sein (3–4 Kandidaten). Kandidaten brauchen ≥1 Motiv in `motives`.
- `lines`: alle 8 Schlüssel. `alibi` ist die wahre Version (Unschuldiger), `alibiLie` die
  Version, wenn diese Person der Täter ist – **beide müssen plausibel klingen**. `rumor` hört
  nur die Journalistin. `nervous`/`annoyed`: Reaktion auf vorgelegte Beweise.
- Zeilen ≤ 140 Zeichen, keine Spoiler, die nur in einer Täter-Variante stimmen.

### `clues` (14–20)

```json
{"id": "c_footprint", "kind": "trait", "trait": "shoe", "name": {...},
 "found": {...}, "reveal": {"de": "Der Abdruck stammt von {value}."},
 "evolve": "none", "chapters": 1,
 "source": {"hotspot": "h_window"},
 "chapter": 1, "expires": 1, "requires": null, "ghost": false, "secret": false}
```

- `kind`:
  - `trait` – deckt den Täter-Wert von `trait` auf. `reveal` enthält `{value}` (wird durch den
    Wert-Text ersetzt, z. B. „Lackschuhe“).
  - `motive` – deckt das echte Motiv auf (Text kommt aus `motives[].reveal`). Kein `reveal` nötig.
  - `weapon` – deckt die echte Waffe auf (Text aus `weapons[].reveal`).
  - `alibi` – mit `subject` (Kandidat): `reveal` = Alibi hält, `revealFalse` = Alibi gelogen.
  - `story` – reine Atmosphäre/Story, fester Text in `found`.
- `found`: Text, sobald gefunden. **Darf nichts über die Lösung verraten.**
- `evolve`: `none` (sofort aufgedeckt), `lab` (im Labor analysieren), `time` (deckt sich nach
  `chapters` Kapitelwechseln selbst auf). Mischung: ~40 % none, ~35 % lab, ~25 % time.
- `source`: `{"hotspot": "<id>"}` **oder** `{"npc": "<suspect-id>", "topic": "alibi|victim|observation|rumor"}`.
  Mehrere Hinweise pro Hotspot sind erlaubt (max. 2).
- `chapter`: ab welchem Kapitel auffindbar. `expires`: verblasst am Ende dieses Kapitels, wenn
  nicht gefunden (2–3 solche „verpassbaren“ Spuren pro Szenario).
- `requires`: wie bei Hotspots (Klasse/Spur) – für Klassen-Spezialhinweise.
- `secret: true`: genau 1, schwer zu finden (z. B. hinter einer Spur), löst das geheime Ende aus.
- `ghost: true`: nur an `ghost`-Hotspots, `kind: story`.

**Lösbarkeit (wird vom Validator geprüft):**
- Für **jeden** Kandidaten als Täter müssen die nicht-verpassbaren, nicht-geheimen
  `trait`-Hinweise ihn eindeutig von allen anderen Verdächtigen unterscheiden. Plane 2–3
  Merkmale mit je 2–4 Werten, sodass jede Kandidaten-Kombination einzigartig ist, und gib
  jedem Merkmal ≥2 Hinweisquellen (verschiedene Orte/Kapitel).
- ≥2 `motive`-Hinweise und ≥2 `weapon`-Hinweise.
- Für jeden Kandidaten ≥1 `alibi`-Hinweis.

### `combos` (2–4)

```json
{"id": "k_shoes", "a": "c_footprint", "b": "c_shoes", "name": {...}, "text": {...},
 "reveals": ["c_footprint"], "lead": "l_secret_room"}
```

Wenn beide Hinweise auf der Beweiswand liegen, kann das Team sie verbinden. `reveals` deckt
Hinweise sofort auf, `lead` fügt eine (`hidden`) Spur zur nächsten Beratung hinzu. Der Text muss
zu jeder Täter-Variante passen.

### `chapters` (genau 3)

```json
{"title": {...}, "intro": {...}, "night": {...},
 "leads": [{"id": "l_garden", "name": {...}, "text": {...},
            "unlock": {"hotspots": ["h_shed"], "doors": [[16, 6]], "items": []},
            "requiresClue": null, "hidden": false}]}
```

- Kapitel 1 und 2: je 2–3 Spuren. Kapitel 3: `leads: []`, `night` leer.
- Eine Spur schaltet Hotspots/Türen/Items frei. Hotspots mit `requires.lead` müssen von
  einer Spur freigeschaltet werden. Spuren-IDs sind global eindeutig (Kapitel 2 darf
  dieselben Freischaltungen unter neuer ID erneut anbieten).
- `hidden: true` = erscheint nur, wenn eine Kombination sie freischaltet.

### `endings`

```json
"endings": {
  "verdict": {"perfect": {"title": {...}, "text": {...}}, "solid": {...}, "partial": {...}, "wrong": {...}, "unsolved": {...}},
  "team": {"all": {...}, "some": {...}, "lone": {...}, "none": {...}},
  "culprit": {"<jeder Kandidat>": {"caught": {...}, "escaped": {...}}},
  "secret": {...}
}
```

Das Ende wird zusammengesetzt aus Urteil + Team-Schicksal + Täter-Epilog (+ Geheimnis).
Texte 1–3 Sätze, stimmungsvoll, ohne Annahmen über Motiv/Waffe.

## Stil

Deutsch, Noir-Krimi, knapp und atmosphärisch. Keine echten Personen/Marken. Jugendfrei (USK 12):
Spannung statt Gore.
