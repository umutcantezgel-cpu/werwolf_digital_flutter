# ENTSCHEIDUNGSLOG · Meta-Lauf BOLLWERK

Jede folgenreiche Entscheidung nach dem Denkprotokoll (Ziel · Wege · Bewertung · Umkehrprobe · Folgen · Wahl). Was der Nutzer anders sehen könnte, steht zusätzlich in ANNAHMEN.md.

## E-M0-01 · Werkzeugkette außerhalb des Repos (21:25 UTC)
- **Ziel:** Fragen 1–5 aus M0 beantworten; Messgröße: Flutter 3.47.6 läuft.
- **Wege:** (a) aus der Quelle von `build.sh` in den Scratchpad laden; (b) als nicht klärbar markieren und modellieren; (c) Agenten bauen lassen.
- **Wahl:** (a). Gleiche Quelle wie `build.sh` und wie der Finalisierungs-Lauf (`P/BESTAND.md`); nichts systemweit, kein Repo-Pfad. `chown -R` auf das eigene Scratchpad statt `git config --global` (Git-Konfiguration bleibt unberührt).
- **Umkehrprobe:** Wäre der Download gesperrt, gälte die Abbruchregel; er lief in 70 s.
- **Folge:** Der Master-Prompt richtet die Werkzeugkette repo-lokal in `.werkzeug/` (gitignored) ein, mit genau diesen Befehlen.

## E-M0-02 · Werkzeugverbot technisch nicht erzwungen (21:40 UTC)
- **Befund:** 2 von 14 Haiku-Agenten riefen verbotene MCP-Lesewerkzeuge (über ToolSearch).
- **Wege:** (a) nur Prompt-Verbot; (b) ToolSearch zusätzlich verbieten + Audit nach jeder Welle, Ergebnis eines Verstoßes verwerfen; (c) Sperrdatei `.claude/settings.json` mit `permissions.deny`.
- **Bewertung:** (a) belegt unzureichend (14 %). (c) wirkt technisch, ändert aber `.claude/**` (Grenze; A-13 Standard „keine“). (b) ist im Rahmen und messbar.
- **Wahl:** (b); (c) bleibt Annahme A-13 für den Nutzer.
- **Umkehrprobe:** Ein Agent könnte ein schreibendes Werkzeug (`interrupt_session`, `delete_trigger`) rufen, bevor das Audit läuft. Gegenmaßnahme: Audit läuft je Rückgabe (nicht erst je Welle); ein schreibender Verstoß ist ABBRUCH-Grund und wird in FUER-DEN-NUTZER gemeldet. Restrisiko bleibt → Annahme A-13 mit Folge.
- **Folge:** Ring 0 „Werkzeug-Audit“ vor Ring 1; `proben/werkzeug_audit.sh` wird `tool/bollwerk/werkzeug_audit.sh`.

## E-M1-01 · Umfangsachsen, Mindestbasen und X5 (22:05 UTC)
- **Ziel:** U ≥ 10 messbar, nicht schönrechenbar, mit jeder Indexachse ≥ 3×.
- **Wege:** (a) alle sechs Achsen wie A MP-7, Basis roh; (b) Achsen mit Basis < 5 bekommen Mindestbasis, X5 mit Deckel < 3× wird Pflichtziel; (c) X4 und X5 ganz aus dem Index.
- **Bewertung:** (a) X4 mit Basis 3 würde mit 300 Gags 100× liefern und U verzerren; X5 mit Basis 0 ist undefiniert. (c) verliert Gags als Wachstumsachse. (b) hält alle Achsen messbar, ehrlich und gedeckelt.
- **Wahl:** (b): X4 Mindestbasis 10, X6 Mindestbasis 5, X5 Pflichtziel (≥ 14 Zusatzfunde), g = 3, 2, 1, 1, 2.
- **Umkehrprobe:** Falsch, wenn die Weißliste deutlich mehr als 30 pfadgleiche Zusatzfunde trägt; dann wäre X5 eine echte Achse. Prüfweg: BW0 zählt die Weißliste; Änderung nur per STEUERUNG nach oben.
- **Folge:** Abschnitt 6 UMFANG des Master-Prompts nennt Mindestbasen und Pflichtziel; `umfang.dart` liest sie aus `messbasis/schwellen.json`.

## E-M1-02 · Bildgleichheit über ΔE statt sha256 (22:03 UTC)
- **Befund:** Zwei Läufe gleicher SHA mit fester Uhr sind nicht bytegleich; ΔE (CIE76) im Mittel 0,005–0,100, p99 ≤ 1,7; einzelne Pixel bis 66 (bewegte Seifenblasen bzw. Rasterung).
- **Wahl:** Gleichheit = ΔE-Mittel ≤ 1,0 je Bild (`proben/bildgleich.py`). Bytegleiche Goldens nur über den Golden-Weg L6 (PictureRecorder).
- **Folge:** D2-Paare nutzen den Browser-Weg; L6 bleibt bytegleich.

## E-M2-01 · Würfelparameter innerhalb der Bänder (22:00 UTC)
- **Ziel:** C8 Nr. 1, 2, 3, 13 und Gerätezeit erfüllen.
- **Wege:** sechs Parametersätze simuliert (sim1–sim6, `proben/wuerfel_sim.py`).
- **Ergebnis:** Satz 6 erfüllt alle Bänder bei 10.000 Partien je Form × Besetzung; Details in SPIELKERN.md.
- **Lockerungen:** keine. Zwei Werte liegen knapp am Bandrand (Wurfanteil Party n=4 0,587 ≤ 0,60; Solo 0,31 ≥ 0,30) → Annahme mit Folge.
