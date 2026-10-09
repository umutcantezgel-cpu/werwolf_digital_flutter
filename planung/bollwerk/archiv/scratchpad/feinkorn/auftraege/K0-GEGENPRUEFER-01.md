K0-GEGENPRUEFER-01 · Gegenprüfer · Bauphase K0 · Version 1 · Schwierigkeit 2

## Rollenbriefing (Gegenprüfer)
- Aufgabe: gezielt kaputtmachen – hier: den Gesamtplan angreifen, bevor er festgeschrieben wird (Plan-Schleife Runde 1 von höchstens 3).
- Gute Arbeit: konkrete Befunde mit Fundstelle (Datei:Zeile), Schweregrad (schwer / mittel / leicht) und Vorschlag; jeder Befund prüfbar.
- Häufige Fehler: (1) Allgemeinplätze statt Fundstellen, (2) Stilfragen als schwere Befunde, (3) Behauptungen ohne Abgleich mit Master-Prompt oder Messwerten.
- Unsicherheit: OFFENE FRAGE notieren, nicht raten.

## Aufgabe
Greife den K0-Plan an: Findet jedes Abnahmekriterium K-01…K-16 einen Weg zum Beleg, sind Abhängigkeiten, Budgets, Grenzen und Dateihoheit stimmig, und ist nichts still abgesenkt?

## Das Projekt in fünf Sätzen
FEINKORN ist der Ausbau einer bestehenden iOS- und Android-App: Figuren, Gebäude und Gegenstände bestehen aus winzigen Pixel-Blöcken mit Material statt aus Bildern. Jeder Block erfüllt eine Funktion – er bestimmt, wie etwas aussieht, Licht annimmt, klingt, sich bewegt und zerbricht –, und abgelöste Blöcke fliegen als Dreck, Splitter oder Krümel und bleiben liegen. Figuren aus Pixel-Blöcken bewegen sich lebendig mit Skelett, Ruhe-Animationen und nachschwingender Kleidung. Alles baut auf der vorhandenen Technik auf, ändert sie nicht und läuft schonend auf Handys. Erstes Werkstück ist der Schlosskeller des Murder-Mystery-Spiels; jede Arbeit wird gemessen, nach Checkliste geprüft und nur vom Orchestrator integriert.

## Auszug Szenenvertrag/Kanon
Planungsordner /home/user/feinkorn/planung/feinkorn/: MASTER-PROMPT.md (Vorgabe), ABNAHME.md, PLAN.md, BUDGET.md, SZENENVERTRAG.md, ENTSCHEIDUNGSLOG.md, NEBELKARTE.md, ROLLENBRIEFINGS.md, AUFTRAGSVORLAGE.md, FUER-DEN-NUTZER.md, STATUS.md, PRUEFPUNKT.md, BESTAND-BILDER.md, KANON-AUSZUG.md; Messwerte in messbasis/*.json; Prototyp-Bilder in bilder/k0/.

## Schnittstellen
Nur lesen: die Dateien oben, dazu /home/user/feinkorn/packages/pixel_engine/lib/src/feinkorn/** und /home/user/feinkorn/lib/game/ (zum Abgleich mit dem Bestand).

## Eigene Dateien
Nur neu: /home/user/feinkorn/planung/feinkorn/berichte/K0-GEGENPRUEFER-01.md

## Grenzen (Bestandsschutz)
Keine andere Datei ändern; nichts committen, pushen, installieren; keine Sitzungs-, Agenten- oder Remote-Werkzeuge; nur im Ordner /home/user/feinkorn; keine Builds, keine Browserläufe.

## Arbeitsschritte
1. Lies MASTER-PROMPT.md vollständig (Vorgabe) und dann alle Planungsdateien.
2. Für jedes K-01…K-16: Welche Aufträge in PLAN.md liefern den Beleg? Fehlt einer, ist das ein Befund (schwer).
3. Prüfe Abhängigkeiten im PLAN (zirkulär? zu spät? Tor-Kriterien vor ihren Bausteinen?).
4. Prüfe BUDGET.md gegen die Messwerte in messbasis/*.json und ENTSCHEIDUNGSLOG E-F005: realistisch? widersprüchlich?
5. Prüfe Bestandsschutz und Dateihoheit (E-F004, E-F012): gibt es geplante Änderungen an Dateien des Finalisierungs-Laufs oder neue Abhängigkeiten?
6. Prüfe, ob eine Vorgabe des Master-Prompts still abgesenkt wurde (z. B. Varianten-Regel, Figurenblätter vor Animation, Prüfstand, Modellschau, Bild-zu-Block-Wandler, Klang, Stimmung 20–25 %, Aufblende 0,4 s, 23 Figuren).
7. Prüfe die Grenzen der Umgebung (keine Geräte): Sind die Ersatzbelege ehrlich benannt?

## Abnahmekriterien und Testweg
Jeder Befund mit Fundstelle, Schweregrad und Vorschlag; Abdeckungstabelle K-01…K-16 → Aufträge.

## Ausgabeformular
ÄNDERUNGEN · ABDECKUNG (Tabelle) · BEFUNDE (nummeriert, schwer/mittel/leicht) · OFFENE FRAGEN · SELBSTPRÜFUNG.

## Selbstprüfung
Nur die Berichtsdatei neu? Jeder Befund mit Fundstelle? Keine Stilfragen als schwer?

=== ENDE K0-GEGENPRUEFER-01 · BEREIT ZUR RÜCKGABE ===
