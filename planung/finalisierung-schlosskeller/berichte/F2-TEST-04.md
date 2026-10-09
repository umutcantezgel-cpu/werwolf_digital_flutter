ABNAHME F2-TEST-04 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-025)

# Bericht F2-TEST-04

## Ergebnis F2-TEST-04
- Geänderte Dateien: /home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/gruppenwahl_dilemma_test.dart (neu; sonst keine Datei im Repo angefasst)
- Anzahl Tests: 20 in gruppenwahl_dilemma_test.dart (14 Prüfungen, 6 Rot-Proben als eigene Tests)
- Analyse: No issues found!
- Tests: 00:00 +20: All tests passed!
- Rot-Proben:
  - Als eigene Tests, mit manipuliertem Kanon in der Testhilfe, prüfen die Prüffunktionen, ob sie den Verstoß melden (alle grün): Option A mit Kosten „gruppe“ bei gw_ahmet_1 (Schritt 8); Option B mit Nutzen „gruppe“ bei gw_murat_2; fehlende Kosten in Runde 3 bei gw_olli_3; Täterfassung bei Nicht-Kernrolle gw_zeynep_1; Loyalitäts-Bezug auf „emine“ bei gw_ahmet_2; Geheimnis-Bezug auf fremdes Nebendelikt „nd_schmiere“ bei gw_murat_1.
  - Echte Rot-Proben in einer Kopie von Paket und Kanon im Scratchpad (Repo unverändert, Kopie danach gelöscht). Rot war jeweils:
    - A: gw_ahmet_1, Option A kosten = gruppe → Option-A-Test, kostenlos-Test, Geheimnis-Bezug-Test.
    - B: gw_murat_2, Option B nutzen = gruppe → Option-B-Test.
    - C: gw_olli_3, Option B ohne Kosten → Option-B-Test, kostenlos-Test.
    - D: Täterfassung bei gw_zeynep_1 → Sabotage-Test, kostenlos-Test.
    - E: Täterfassung bei gw_fatma_2 entfernt → Sabotage-Test, kostenlos-Test.
    - F: gw_ahmet_2, Kosten-Bezug emine → Loyalitäts-Bezug-Test.
    - G: gw_kaan_1, Kosten-Bezug persoenlichesZiel → Geheimnis-Bezug-Test.
    - H: Wahl gw_tugba_3 entfernt → 60-Wahlen-Test, kostenlos-Test.
    - I: lib wirksam zieht Sabotage nicht ab → Test netto −1, auswerten-Test, Kippen-Test.
    - J: lib wirksam ohne Untergrenze 0 → Test „bei null“.
    - K: lib wirksam zieht auch ohne Sabotage ab → Test „ohne Sabotage“, auswerten-Test, Kippen-Test.
    - Kontrolle ohne Eingriff: 20 von 20 grün.
- Gezählte Wahlen: 60 (20 Rollen × Runden 1 bis 3); Kernrollen mit bTaeter: ahmet, fatma, olli, can (je Runde 1 bis 3, also 12 Täterfassungen)

## OFFENE FRAGEN
- Keine inhaltlichen offenen Fragen.
- Nicht eigens rot geprobt: der Quellen-Test (quelle nur geheimnis oder loyalitaet) und der Literal-Test der Kernrollen. Beide würden bei einer Änderung der geprüften Daten rot, sind aber durch keine Probe belegt.
- Die Texte der Wahlen (text null, platzhalter true) sind nicht geprüft; das gehört zu F3.
- git status zeigt im selben Ordner fremde neue Dateien (determinismus_test.dart, enden_test.dart, gruppenwahl_test.dart). Die habe ich nicht angelegt, nicht geändert und nicht ausgeführt. dart analyze test meldete für den ganzen Testordner keine Befunde.
=== ENDE F2-TEST-04 · BEREIT ZUR RÜCKGABE ===
