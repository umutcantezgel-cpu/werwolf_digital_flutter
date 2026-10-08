# VORLAGE ERZ-ANSAGEN · v1 · Ansagen zu Rollen-Entscheidungen

## AUFGABE
Schreibe für Phase {{PHASE}} alle Erzähler-Ansagen zu den Rollen-Entscheidungen der Rollen {{ROLLEN}}, deren Folge eine Ansage ist ({{ANZAHL}} Ansagen: {{ANSAGEN}}).

## STIL
- Erzählerstimme nach Stilblatt, vorlesbar, Uhrzeiten und Zahlen in Worten, Bedingungen nur in der Markierungssyntax des Stilblatts, nie verschachtelt.
- Je Ansage 30 bis 60 Wörter, eingeschlossen in [NUR WENN E…-NN OPTION k GEWÄHLT] … [ENDE BEDINGUNG], mit Kennung A-E…-NN-k davor.
- Ansagen zu den Rollen 01 bis 04 sind anonym („Jemand am Tisch …“). Ansagen zu Rollen ab 05 dürfen den Namen nennen.
- Jede Ansage setzt genau die Folge aus dem Entscheidungs-Datensatz um, nicht mehr.

## VERBOTE
- Keine Deutung, wer verdächtig ist; keine Hinweise über die Folge hinaus.
- Keine Ansagen zu Optionen, deren Folge eine reine Kartenaktion ist.

## SCHRITTE
1. Lies die E-Datensätze. Notiere jede Option, deren Folge eine Ansage verlangt.
2. Schreibe je solche Option eine Ansage mit Kennung und Markierung.
3. Prüfe Anonymität bei Rollen 01 bis 04.

## MUSTER
M-04

## FORMULAR
    KENNUNG: {{ID}}
    A-E{{PHASE}}-NN-k:
    [NUR WENN E{{PHASE}}-NN OPTION k GEWÄHLT]
    <Ansage>
    [ENDE BEDINGUNG]
    (für jede Ansage wiederholen)
    OFFENE FRAGEN: …

## SELBSTPRUEFUNG
    SELBSTPRÜFUNG:
    - Ansagen: [Zahl] (Soll {{ANZAHL}}), je 30–60 Wörter: ja/nein
    - Rollen 01–04 anonym: ja/nein
    - Markierungen korrekt und geschlossen: ja/nein
    - Offene Fragen: [Anzahl]
