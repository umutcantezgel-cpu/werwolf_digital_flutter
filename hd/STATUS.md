# Burgstadt HD – STATUS

STAND · Kern v1.0 · PAUSIERT zugunsten FEINKORN (Nutzerentscheidung 2026-10-09) · Phase 1 von 9 · Tag 1 · Schicht T2/S3 · Zielabstand 0 von 14 · Pakete 49 von 306 · Plätze 0 von 4 · nächster Schritt beim Wiedereinstieg: hd/wip/LIESMICH.md

## Phase 0 – Fundament (Zielbeitrag)
1. P0 schafft die Werkzeuge, mit denen jede spätere Verbesserung gemessen wird: Layout-Prüfsumme, Kontaktbogen, Flimmer-, Banding- und Szenenmessung, `hd_abnahme`.
2. P0 friert den Ausgang ein (Commit, Bilder, Messwerte, Nachtlauf-Abnahme 12/14), damit HZ-12 und HZ-13 gegen echte Zahlen geprüft werden.
3. P0 liefert die Audits (Palette, Dichte, Test-Bindungen, Kanon, Räume, Belegblicke), ohne die P1 nicht sicher umbauen kann, und eicht die Sichtprüfer.

## Schichtprotokoll
| Schicht | Pakete angenommen | Reparaturen | Commit | Bemerkung |
|---|---|---|---|---|
| T1/S1 | P0-OPUS-01, P0-OPUS-02, P0-KUND-01…06 (8) | 0 | ef8aac4, 64d415f | Branch auf `c54fe9c`, Flutter 3.47.6 / Dart 3.13.5; `tool/ton` braucht pub get; 6 Audits angenommen (Palette 167+150 Stellen, Dichte 64, Test-Bindungen 79, Kanon 26 Raumarten, Räume 42 Vorlagen/53 Innen-Bereiche, Belegblicke 51); E-044…E-046 |
| T1/S2 | P0-OPUS-03, P0-AUTOR-01, P0-AUTOR-02 (3 von 7) | 0 | 6ca419c, 0ac2248 | Z-13-Zeile, hd_commit.sh, Layout-Prüfsumme 35a1b855fb2fd753 im Schnelllauf, Kontaktbogen; Migrationsbeleg-Bildsatz (198 Bilder) deterministisch; alle 7 angenommen |
| T1/S3 | P0-AUTOR-05, P0-AUTOR-06, P0-GEGEN-01, P0-SICHT-01…03 (vorgezogen aus T2/S1) (6) | REP-01…03 laufen | 700989a, d00b73e, 920a863 | Eichbilder; hd_abnahme-Gerüst (0/14, Figurenstand e5bb30ea3c); Gegenprüfung 17 Befunde (8 schwer) → REP-01…03; Eichlauf 77,8 % → E-047; Ausgang Nachtlauf 13/14 (E-048) |
| T2/S1 (Opus) | P1-OPUS-03 Palette v2 | 0 | d29628e | MIGRATIONSBELEG 1: 198/198 Bilder byte-gleich, Eichbilder 18/18 gleich |
| T2/S2 | P1-OPUS-02 Skalierung v2, P1-OPUS-01 Werkzeugkasten, P1-OPUS-05 Dichte 64, REP-01…03, P0-PROBE-02/03, P1-AUTOR-01/03, P7-AUTOR-01/02/04/07/10 | 3 REP | f60e38f, f955512, 96e9e5b, fccd652, e12254b, 0e5b9b2, 82b5b58, 56ad7eb, 2cc225e | „scharf“ 640×360 bei 720p; MIGRATIONSBELEG 2 (Dichte 64) 198/198 + Detektivblick 16/16; Ausgang eingefroren (115 Bilder, 52,6 ns/Pixel, Flimmern FERNE 0,242, Banding 5) |
| T2/S3 | P1-OPUS-04 Lichttabelle v2, Kandidaten-Register, P1-AUTOR-04/05/06/07/08, P1-VAR-01/02, Formen-Gerüst, P4-AUTOR-02/03/04 | 0 | f654c35, 194bf2c, 512f685, d58318e, c820593, (dieser) | Banding 5 → 8 Stufen, Sprung 2 → 1; Grün im Licht 0 %; erste HD-Texturen (pflaster_a/b, putzOcker_a) |

## Zielabstand (HZ erfüllt)
| HZ | Stand |
|---|---|
| HZ-01 … HZ-14 | 0 von 14 erfüllt |
