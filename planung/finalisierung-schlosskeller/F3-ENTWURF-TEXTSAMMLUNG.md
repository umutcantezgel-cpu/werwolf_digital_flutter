# Entwurf · Textsammlung für F3 (Vorlage für F3-ORCH-00)

Stand: Entwurf während F2. Wird mit dem F2-Tor geprüft und in F3-ORCH-00 festgeschrieben (`content/party/schlosskeller/texte/SCHLUESSEL.md`).

## Grundsätze
- **Eine Quelle:** Jeder Text, den Spielende sehen oder hören, steht genau einmal im Kanon.
  - Tatsachen (Beobachtungen, Spuren, Entscheidungen, Hinweise) stehen schon in den Kanon-Dateien und werden nicht neu geschrieben.
  - Die Textsammlung enthält nur Erzählerbausteine, Dossier-Prosa, Gespräche, Wahltexte, den Detektiv-Bogen und Oberflächentexte.
- **Verweise statt Abschrift:** Dossiers und Gespräche nennen Tatsachen über Kennungen (`beobachtung:<id>`, `luege:<id>`, `nebendelikt:<id>`). Das Zusammensetzen je Pfad macht der Code. So kann pfadabhängiges Wissen nicht falsch abgeschrieben werden.
- **Sichtbarkeit:** Jeder Schlüssel trägt `sichtbar`:
  - `tisch`: alle, vor dem Finale
  - `rolle`: nur die eigene Rolle, verdeckt
  - `detektiv`: nur der Detektiv
  - `finale`: erst ab dem Finale
  - Der Spoiler-Test prüft alles mit `tisch` und `detektiv` über alle vier Pfade.

## Dateien und Schlüssel
| Datei | Schlüssel | Inhalt | Sichtbar | Autor |
|---|---|---|---|---|
| `texte/erzaehler.json` | Kennungen aus `Erzaehler.katalog()` (81): `intro.*`, `runde.N.start`, `bonus.rahmen`, `resuemee.gruppe.*`, `resuemee.rest.*` (12), `resuemee.lage.N.*` (9), `anklage.start`, `finale.<pfad>.<ende>` (16), `rueckblende.<pfad>` (4), `aufloesung.*` (24) | Erzählerbausteine | tisch, finale | Intro- und Finale-Autoren, ORCH führt zusammen |
| `texte/dossiers.json` | `dossier.<rolle>.{wer, ziel, besetzung}`, `dossier.<rolle>.weiss[]`, `dossier.<rolle>.verbirgt[]`; Kernrollen zusätzlich `dossier.<rolle>.taeter.{tarnung, tatwissen, verbirgt[]}` | Prosa plus Verweise | rolle | Dossier-Autoren (Blöcke) |
| `texte/gespraeche.json` | `gespraech.<rolle>.r<N>.<1–3>` mit `partner`, `thema`, `ziel`, `preisgabe[]` (nur Verweise auf Pflichtgespräch-Beobachtungen, Lügen oder öffentliche Zeitleiste), `text` | Pflichtgespräche | rolle | Gesprächs-Autoren |
| `texte/wahlen.json` | `wahl.<rolle>.r<N>.{a, b}`, Kernrollen zusätzlich `.sabotage` | Rundenwahl | rolle | Wahl- und Dilemma-Autoren |
| `texte/detektiv.json` | `detektiv.<m\|w>.*`, `ermittlungsbogen.*` | Detektiv-Bogen | detektiv | Detektiv-Autor |
| `texte/ui.json` | `ui.*` | Oberfläche | tisch | ORCH |

## Regeln für Gespräche (P-1)
- Preisgaben sind nur Pflichtgespräch-Beobachtungen, die behauptete Fassung einer Lüge oder öffentliche Zeitleisten-Einträge.
- Nie Nebendelikte oder verborgene Beobachtungen. Sonst schließt die Runde am Tisch zusammen mit einem Alibi aus einer Entscheidung schon in Runde 1 aus, und „nach Runde 2 genau zwei“ hält am Tisch nicht.
- Partner sind Rollen oder der Detektiv. Fehlt die Rolle, greift `besetzung.json#ersatzpartner`, sonst der Detektiv.

## Folgen für den PLAN (Vorschlag)
- **F3-AUTOR-31..33 (Bonus-Texte)** entfallen als Schreibauftrag, weil die 36 Hinweise schon im Kanon stehen (E-024). Sie werden Prüfauftrag für SENS und KONT.
- **F3-AUTOR-34..35 (Indiz- und Entscheidungstexte)** entfallen ebenso. Fundtexte sind `zeigt` und `harmlos` der Spuren sowie die Fragen und Optionen in `entscheidungen.json`. Sie werden Prüfauftrag; Korrekturen macht ORCH im Kanon.
- **Gesprächsaufträge:** 20 Rollen × 3 Runden × 3 Gespräche = 180. Die Blöcke bleiben (5 × 3 Aufträge zu je 12).
- **Wahltexte:** 60 Wahlen und 12 Sabotagen. Die Varianten-Regel gilt für die 4 Kernrollen.
