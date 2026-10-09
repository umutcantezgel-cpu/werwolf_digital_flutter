# F5-Entwurf · Druckspiel und Besetzung (F5-ORCH-01)

Stand: Entwurf während der F4-Bildschirmwelle. Code entsteht erst nach dem F4-Tor.

## Neu verankern (drei Sätze)
- F5 macht aus Kanon und Textsammlung je Fall-Code und Personenzahl einen PDF-Satz. Mit ihm läuft der Abend ganz ohne App (Master 7.14, F-14).
- Wer druckt, sieht außen nur neutrale Codes. Die Zuordnung steht im versiegelten Auflösungsheft.
- Der Satz ist zuerst ein Datenmodell (`DruckSatz`), erst danach PDF. Der Drucktest spielt das Datenmodell 100-mal wie eine Gruppe am Tisch und vergleicht das Ende mit dem Simulator.

## Datenmodell (`packages/mordakte_core/lib/src/party/druck/modell.dart`)
`DruckSatz.aus(kanon, texte, code, rollen, detektiv)` erzeugt:

| Teil | Inhalt | Sichtbarkeit |
|---|---|---|
| `spielleitung` | Ablauf, Intro, Rundenstarts, Anklage; Auszähltabelle der Gruppenwahl für genau diese Personenzahl; Resümee-Bausteine nach Restmenge und Lage | ohne Lösung, pfadneutral |
| `detektivbogen` | 9 Entscheidungen, Optionen in der App-Reihenfolge des Codes, je Option ein Indizkarten-Code; Ermittlungsbogen (Faktarten je Kernperson, Ausschlussregeln R-ENTLASTET, R-ÜBERFÜHRT); Punktefeld | offen |
| `rollenhefte` | je besetzte Rolle: wer ich bin, Ziel, Pflichtgespräche mit dem Partner aus dem Gesprächsplan für diese Personenzahl, Besetzungshinweis | offen, nur für die Rolle |
| `fassungen` | je Kernrolle ein versiegelter Umschlag mit „was ich weiß / verberge“ und Rundenwahl, im eigenen Pfad die Täterfassung; alle vier gleich lang (aufgefüllt) | Umschlag mit Code |
| `indizkarten` | je Option eine Karte: außen Code, innen die Aufdeckungen des Pfads (wortgleich `Ermittlung.aufdecken`), dazu Ankreuzhilfen für den Ermittlungsbogen (Faktart und Person) | Karte mit Code |
| `stimmkarten` | je Rolle und Runde zwei Karten (A, B; bei der Täterrolle ist B die Sabotage). Rückseite ein Wert: A = 1, B = 0, Sabotage = −1. Gleiches Aussehen bis auf den Wert | verdeckt |
| `umschlaege` | 9 Hinweis-Umschläge (3 Runden × 3 Qualitäten): außen Code, innen `bonus.rahmen` und der Hinweis des Pfads | Umschlag mit Code |
| `aufloesung` | versiegelt: richtige Option je Entscheidung (als Code), Endentabelle Punkte × Anklage → Ende, Finaltext und Rückblende des Pfads, Auflösung je besetzter Rolle, Zuordnung aller Codes | versiegelt |

- **Codes:** Zwei Zeichen aus dem Fall-Code-Alphabet plus Ziffer, aus `FallCode.rng` gezogen und je Satz eindeutig. Kein Code verrät Art oder Pfad. Die Reihenfolge der Indizkarten im Druck folgt den Codes, nicht den Entscheidungen.
- **Auszählung (G-1 auf Papier):**
  - Die Spielleitung sammelt die Stimmkarten verdeckt, mischt sie und summiert die Werte.
  - Die Tabelle im Spielleitungsheft nennt für genau diese Personenzahl je Runde, ab welcher Summe welcher Umschlag geöffnet wird. Das ist die Schwelle aus `Gruppenwahl.qualitaet` mit der Summe als wirksamer Stimmenzahl.
  - Die Summe wird nie laut genannt (E-025).
- **Restmenge ohne Auflösungsheft (F-14):** Jede Indizkarte trägt ihre Kreuze für den Ermittlungsbogen. Die Regeln im Bogen ergeben dieselbe Restmenge wie `Ermittlung.restmenge`. Die Spielleitung liest den Resümee-Baustein der Restmenge aus ihrem Heft vor.

## PDF (`druck/*.dart`, Paket `pdf`)
- A4 hoch, Schriften Inter und Special Elite aus `assets/fonts` (Bytes von außen, Kern ohne `dart:io`).
- Ein Dokument je Teil, Dateinamen nur mit Nummer und Teil (Stand E-033/E-035): `00-spielleitung.pdf`, `01-detektivbogen.pdf`, `10-rollenhefte.pdf`, `11-fassungen.pdf`, `12-stimmkarten.pdf`, `20-indizkarten.pdf`, `21-umschlaege.pdf`, `90-aufloesung-versiegelt.pdf`. Umschläge stehen gesammelt in einer Datei; ein Code im Dateinamen hätte nichts genützt.
- **Überlaufschutz:**
  - Jede Seite wird mit `pw.MultiPage` gesetzt.
  - Karten haben eine feste Größe; ihr Text wird vor dem Satz mit der Textmessung des Pakets geprüft. Läuft er über, verkleinert sich die Schrift bis 9 pt. Reicht das nicht, ist das ein Fehler und der Test wird rot.
- `bin/party_druck.dart --code XXXXX --n 12 --detektiv w [--aus ordner]` erzeugt den Satz.
- Die App bietet bei „Druckspiel“ einen Download: Web über einen Blob-Link, sonst eine Datei.

## Tests
- **`druck_test`:**
  - Jeder Teil ist A4.
  - Kein Text außerhalb der Bausteine: Alle Sätze stammen aus der Textsammlung, dem Kanon oder `ui-druck.json`.
  - Neutrale Codes außen (kein Personen- oder Pfadname auf Außenseiten).
  - Alle vier Kernfassungen haben gleich viele Seiten.
  - 100 Zufallsspiele über das Datenmodell (Optionen, Stimmen, Anklage) ergeben dasselbe Ende und dieselbe Restmenge wie `Spiel`.
- **`besetzung_test` (F-09):** Für jede Personenzahl von 4 bis 20 sind alle Pflichtgespräche besetzt oder ersetzt, kein Gespräch hängt an einer unbesetzten Rolle. Jede Lösung ist mit den gedruckten Teilen erreichbar.
- **Druckprüfer (F5-DRUCK-01/02):** Die Seiten werden zu PNG gerendert (`pdftoppm`, falls vorhanden, sonst Chromium mit PDF-Ansicht) und dem Nutzer gezeigt (SendUserFile).

## Offene Punkte (Denkprotokoll beim Bau)
- Bei den Stimmkarten verrät der Wert −1 der Spielleitung, dass sabotiert wurde, aber nicht von wem. Am Bildschirm gibt es diese Information nicht. Ein Ausweg wären Wertcodes statt Zahlen. Das wäre aufwendiger und brächte am Tisch kaum Schutz. Entscheidung im Bau, Eintrag in E-031.
- NPC-Karten im Druck: Personen-Ziele unbesetzter Rollen bekommen dieselbe Indizkarte. Ihr Kopf sagt „Diese Person spielt heute niemand“, wie die Fundkarte der App (F4-BAUMEISTER-09).
