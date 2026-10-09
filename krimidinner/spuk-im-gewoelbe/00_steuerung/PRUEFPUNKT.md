[ENTHÄLT LÖSUNG]
# PRÜFPUNKT · Ende Tag 2 (Welle 0 abgeschlossen) · 08.10.2026

STAND · Kanon v1.0 · Welle 0 · freigegeben 0 von 204 · in Arbeit 0 · Reparatur 0 · Tag 2 von 14 · nächster Schritt: WEITER → Tag 3

## Was fertig ist
- **Kanon v1.0:** `10_kanon/`, 1.211 Datensätze in K1–K9.
  - Selbstprüfung bestanden (`SELBSTPRUEFUNG.md`): Werkzeug-Proben 0 Befunde; zwei adversariale Prüfrunden eingearbeitet.
  - Änderungen in `PROTOKOLL.md`, Version in `VERSION.md`.
  - Gesamtdokument: `GESAMT-KANON.md`, erzeugt mit `python3 90_werkzeug/kanon.py gesamt`.
- **Feinplan:** `00_steuerung/PLAN.md`, 204 Pakete mit Kennung, Typ, Vorlage, Welle, Tag, Charge, Sitzung, Lösung, Parameter, Umfang, Abhängigkeit und Status.
- **Vorlagen:** `20_vorlagen/`, 44 Vorlagen plus ABNAHME und Bausteine.
- **Stilblatt und Look-Bibel:** K8 und K9 (öffentlich, ohne Lösung).
- **Werkzeuge** (`90_werkzeug/`):

| Werkzeug | Aufgabe |
|---|---|
| `kanon.py` | Proben, Tabellen, Gesamtdokument |
| `raster.py` | Gesprächsraster |
| `plan.py` | Feinplan |
| `bau.py` | Pakete, Reparaturaufträge, Durchspiel-Auszüge |
| `zaehl.py` | Zählprüfung |
| `freigabe.py` | Übernahme in 60_freigaben, Plan, Register |
| `tageslauf.js` | Workflow für einen Produktionstag |

- **Probebau gegen v1.0:** 165 von 204 Paketen bauen ohne Fehler. Die übrigen 39 sind Prüf-, Montage- und Lektoratspakete; sie warten planmäßig auf freigegebenes Material.

## Ablauf eines Produktionstags (Regelkreis 1)
1. `python3 90_werkzeug/bau.py --tag N` (Charge a) baut 30_pakete/<ID>.r0.md.
2. Workflow `90_werkzeug/tageslauf.js` mit `args: {ids: [...]}`:
   - Haiku schreibt die Rückgabe nach 40_rueckgaben.
   - Opus prüft mit `zaehl.py` und ABNAHME (A–H) und schreibt nach 50_abnahmen.
   - Bei REPARIEREN oder NEU baut `bau.py --runde n` den Reparaturauftrag.
   - Höchstens zwei Reparaturen, danach Eskalation.
3. Für jede Freigabe `python3 90_werkzeug/freigabe.py <ID> <Runde>`. Eskalationen schreibt der Produktionsleiter selbst. Jede zehnte Freigabe liest er als Stichprobe.
4. Charge b (Prüfpakete) mit `bau.py --tag N --charge b`, Befunde in BEFUNDE.md.
5. Am Tagesende STATUS, FEHLER und PRÜFPUNKT nachführen, committen, pushen und den Tagesabschluss schreiben.

## Nächster Tag (Tag 3, Welle 1 A, Design-Vorrang)
Charge a (29 Pakete):
- **Bilder:** BILD-TITEL-V1/V2/V3, BILD-EINLADUNG-V1/V2/V3, BILD-STATIONEN, BILD-FIGUREN-1/2.
- **Steckbriefe:** PROFIL-R01 bis R08 (R03 mit Lösung).
- **Erzähler:** ERZ-EINF-V1/V2/V3, ERZ-VORST-A.
- **Hinweise:** HINW-STAT-1/2, HINW-DOK, HINW-MELDE.
- **Requisiten:** REQ-BAU-1/2 (mit Lösung), REQ-RAUM, REQ-KLANG-LICHT.

Charge b (nach Freigabe der Steckbriefe R01–R08): PRÜF-PROFIL-A.

## Wiederaufnahme nach Container-Neustart
1. Branch `claude/ecstatic-cerf-7kzi1c` auschecken.
2. Diese Datei und `STATUS.md` lesen.
3. `python3 90_werkzeug/kanon.py pruefe` muss 0 Befunde melden.
4. Danach mit dem nächsten Schritt oben weitermachen. Pakete im Zustand „in Arbeit“ (Status im PLAN) werden aus der letzten vorhandenen Runde fortgesetzt.
