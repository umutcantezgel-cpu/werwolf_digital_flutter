# Burgstadt HD – STATUS

STAND · Kern v1.0 · Phase 0 von 9 · Tag 1 · Schicht 2 · Zielabstand 0 von 14 · Pakete 11 von 306 · Plätze 4 von 4 · nächster Schritt: T1/S2 abschließen (Messwerkzeuge, Ausgang)

## Phase 0 – Fundament (Zielbeitrag)
1. P0 schafft die Werkzeuge, mit denen jede spätere Verbesserung gemessen wird: Layout-Prüfsumme, Kontaktbogen, Flimmer-, Banding- und Szenenmessung, `hd_abnahme`.
2. P0 friert den Ausgang ein (Commit, Bilder, Messwerte, Nachtlauf-Abnahme 12/14), damit HZ-12 und HZ-13 gegen echte Zahlen geprüft werden.
3. P0 liefert die Audits (Palette, Dichte, Test-Bindungen, Kanon, Räume, Belegblicke), ohne die P1 nicht sicher umbauen kann, und eicht die Sichtprüfer.

## Schichtprotokoll
| Schicht | Pakete angenommen | Reparaturen | Commit | Bemerkung |
|---|---|---|---|---|
| T1/S1 | P0-OPUS-01, P0-OPUS-02, P0-KUND-01…06 (8) | 0 | ef8aac4, 64d415f | Branch auf `c54fe9c`, Flutter 3.47.6 / Dart 3.13.5; `tool/ton` braucht pub get; 6 Audits angenommen (Palette 167+150 Stellen, Dichte 64, Test-Bindungen 79, Kanon 26 Raumarten, Räume 42 Vorlagen/53 Innen-Bereiche, Belegblicke 51); E-044…E-046 |
| T1/S2 | P0-OPUS-03, P0-AUTOR-01, P0-AUTOR-02 (3 von 7) | 0 | 6ca419c, 0ac2248 | Z-13-Zeile, hd_commit.sh, Layout-Prüfsumme 35a1b855fb2fd753 im Schnelllauf, Kontaktbogen; Migrationsbeleg-Bildsatz (198 Bilder) deterministisch; laufen: P0-AUTOR-03/04, P0-PROBE-01, P0-AUTOR-05 (vorgezogen) |

## Zielabstand (HZ erfüllt)
| HZ | Stand |
|---|---|
| HZ-01 … HZ-14 | 0 von 14 erfüllt |
