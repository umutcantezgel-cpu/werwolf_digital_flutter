**Selbstprüfung** (Trefferzahl je Pflicht-Muster über alle 136 Dateien, `rg`, Zeilen; „Nr.“ = Nummer in Abschnitt 1):

| Muster | Zeilen-Treffer | Verteilung und Befund |
|---|---|---|
| `kTexelsPerMeter\|texelsPerMeter\|TexelsPerMeter` | 38 | welt_geometrie.dart 13 (Nr. 58, 59, 60, 62, 63); mesh.dart 10 (Nr. 1, 2, 3); demo_scene.dart 7 (Nr. 30); baker.dart 5 (Nr. 14, 20, 22); renderer.dart 3 (Nr. 4, 6, 10). Alles in Tabelle. |
| `(?i)dichte` | 7 | mesh.dart 3 (Nr. 1); renderer.dart 2 (Nr. 4, 6); tool/abnahme.dart 1 (Nr. 50); tool/ton/umgebung.dart 1 (verworfen: „dichtes Blubbern“). |
| `\b32\b` | 96 | texturen.dart 63 (Nr. 33 bis 37); portraet.dart 4 (Nr. 27 bis 29); demo_scene.dart 3 (Nr. 31); texturen_test.dart 2 (Nr. 38); portraet_test.dart 1 (Nr. 40); mesh.dart 1 (Nr. 1); baker.dart 1 (Nr. 15). Verworfen: bewohner_karten.dart 7, welt_geometrie.dart 2 (Kachelblöcke), spuren_geometrie.dart 1 (Meterwert 0,32), tool/ton 5, übrige 6 Einzeltreffer (Skalierung, Zufall, UI, Stadtdaten, Bewohnerkarten-Bin, pruef.dart). |
| `48\s*[x×*,]\s*80` | 0 | kein Treffer; das Sprite-Maß steht als `breite = 48, hoehe = 80` (Nr. 16). |
| `\b48\b` | 16 | baker.dart 1 (Nr. 16); texturen.dart 2 (Nr. 37: Z. 413, 460). Verworfen: 13 (tool/ton 4, schriftprobe 2, kanon_test 2, oberstadt 2, camera.dart 1, spiel.dart 1, erkundung.dart 1). |
| `\b80\b` | 25 | baker.dart 1 (Nr. 16); teile_koepfe_probe.dart 1 (Nr. 49). Verworfen: 23 (tool/ton 10, UI, Kamerapositionen, Palette, PNG-Signatur, kanon.dart, stadtgenerator.dart). |
| `\b24\b` | 50 | texturen.dart 6 (Nr. 36, 37: Z. 299, 334, 462, 577, 692, 711); baker.dart 1 (Nr. 16). Verworfen: 43 (u. a. baker.dart:42 `kopfStil = 1.24`, Stadtgenerator, Tests, UI, Audio). |
| `\b77\b` | 7 | baker.dart 1 (Nr. 16). Verworfen: 6 (tool/ton 5, fledermaeuse_test.dart:93 Kameraposition). |
| `\b64\b` | 62 | texturen.dart 18 (Nr. 35, 37); portraet.dart 3 (Nr. 26); portraet_test.dart 4 (Nr. 40, 41); texturen_test.dart 3 (Nr. 38; Z. 46 in Abschnitt 3). Verworfen: 34 (tool/ton 14, pixel_test.dart 9 Testpuffer 64×36, Palette 2, leistung.dart 2, Einzeltreffer 7). |
| `64\s*[x×*,]\s*64` | 3 | portraet.dart:1 (Nr. 26); portraet_test.dart:43 (Nr. 40); texturen_test.dart:37 (Nr. 38). Alles in Tabelle. |
| `(?i)mip` | 12 | renderer.dart 7 (Nr. 5, 6, 11); texture.dart 2 (Doku, Abschnitt 3); fledermaeuse.dart 2 (Nr. 53); mesh.dart 1 (Doku Z. 72, verworfen). |
| `\blevel\b` | 2 | renderer.dart:158-159 (Himmelsstufe), verworfen. |
| `\blv\b` | 14 | renderer.dart 12 (Nr. 7, 8, 9, 11, 12); texturen_test.dart 2 (Z. 45-46, Abschnitt 3). |
| `log2` | 0 | kein Treffer; die Sprite-Stufe nutzt `math.log(...) / math.ln2` (Nr. 11). |
| `mipCap` | 0 | kein Treffer; der Cap heißt `maxLevels` (texture.dart:18) bzw. `< 4` (renderer.dart:32). |
| `u =`, `v =`, `uv`, `* 32`, `/ 32` (Muster aus dem Auftrag) | 42 | dichte-relevant in Tabelle: Nr. 2, 3, 56 (spuren_geometrie.dart:96-97). Übrige: Variablen (`u`, `v`, `uv`), Schleifenzähler, Bit-Operationen, Blockschlüssel (welt_geometrie.dart:179, 240), Silhouette (bewohner_karten.dart:462, 464), UV-Kopie (renderer.dart:269-270). |
| `_Tex(` | 30 | alle in Abschnitt 4 bzw. Tabelle (Nr. 33 bis 35); texturen.dart:116 ist die Klassendefinition. |
| `SpriteImage` | 38 | Typ- und Konstruktoraufrufe. Größenbezug in Tabelle: Nr. 5, 16 bis 19, 26 bis 29, 39, 51, 52. Übrige ohne Dichtebezug. |

Hinweis zur Vollständigkeit: Bei den Mustern mit vielen Treffern (`\b32\b`, `\b64\b`, `\b24\b`) sind die Texel-Literale in `texturen.dart` in Gruppen erfasst (Nr. 36, 37). Jeder Treffer wurde mit Kontext gelesen (Dateien und Zeilen in Abschnitt 1 und 2). Alle `tool/ton`-Treffer sind Audio.
