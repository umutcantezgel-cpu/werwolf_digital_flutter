ABNAHME F1-TEST-03 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-018)

# Bericht F1-TEST-03

## Ergebnis F1-TEST-03
- Arbeitsbaum: /home/user/werwolf_digital_flutter/.claude/worktrees/wf_cd2b025f-a54-2
- Geänderte Dateien:
  - /home/user/werwolf_digital_flutter/.claude/worktrees/wf_cd2b025f-a54-2/packages/mordakte_core/lib/src/party/farbe.dart (neu)
  - /home/user/werwolf_digital_flutter/.claude/worktrees/wf_cd2b025f-a54-2/packages/mordakte_core/test/party/farbabstand_test.dart (neu)
- Analyse: No issues found! (`dart analyze lib bin test`)
- Tests: im Arbeitsbaum +7 -3. Die drei Kanon-Tests sind rot, weil content/party/schlosskeller/figuren.json dort fehlt. In einer Kopie mit den Daten aus dem Branch finalisierung-schlosskeller: All tests passed (10/10).
- Kleinster Abstand je Startraum (aus der Kopie mit Kanon-Daten):
  - ost_saal: 11.8342 (baran/hakan)
  - thekensaal: 12.0688 (fatma/dilara)
  - west_saal: 12.8043 (meryem/kaan)
  - windfang: nur Serkan, kein Paar
- Kleinster Abstand der Beweisfarbe: 22.8685 (can/detective)

Die Referenzwerte stimmen mit 4 Nachkommastellen für 14 Sharma-Paare (Nr. 1–7, 9, 13, 15–19), jeweils auch in Umkehrung. Die Lab-Eingaben habe ich aus der Tabelle von Sharma et al. 2005 übernommen; sie sind hier nicht gegengeprüft, aber alle 14 Werte treffen die Implementierung.

Rot-Proben liefen in einer Kopie außerhalb des Arbeitsbaums, die Kanon-Daten sind unverändert:
- Aylin auf Cans Farbe gesetzt: Test „Beweisfarbe mindestens 20 zu allen“ rot mit „Beweisfarbe can / aylin: ΔE2000 = 0.0000“.
- Baran auf Ollis Farbe gesetzt (gleicher Raum): Test „im selben Startraum mindestens 10“ rot mit „olli / baran (Startraum ost_saal): ΔE2000 = 0.0000“.
- Der Test „erkennt zu nahe Farben“ prüft die manipulierte Liste im Test selbst und blieb grün.

Git: keine Schreibbefehle. `git status` zeigt nur die beiden neuen Verzeichnisse, pubspec.lock ist unverändert.

## OFFENE FRAGEN
1. Die Kanon-Dateien fehlen im Arbeitsbaum. content/party/schlosskeller/, kanon_hilfe.dart und die Kanon-Klasse existieren in HEAD d92a675 nicht. Sie liegen im Branch finalisierung-schlosskeller (Commits 2ff0403, c0df6c9, 4eeb0bd). Ich habe nicht ausgecheckt, weil Checkout verboten ist. Soll der Orchestrator die Kanon-Dateien vorher in den Arbeitsbaum bringen?
2. Statt kanon_hilfe.dart liest der Test figuren.json direkt aus dem eigenen Arbeitsbaum. Die Suche endet am .git-Ordner des Worktrees. Eine frühere Version hat bis in den Hauptcheckout hinaufgesucht; das ist korrigiert. Wenn Kanon-Hilfe und Kanon-Klasse bereitstehen, kann der Test darauf umgestellt werden.
3. Den Barrel-Export in mordakte_core.dart habe ich nicht gemacht (Orchestrator). Der Test importiert package:mordakte_core/src/party/farbe.dart.
4. Zusätzlich zu deltaE2000 und deltaE2000Lab habe ich labAusHex(String) öffentlich gemacht, damit die Hex-Umrechnung getestet werden kann.

=== ENDE F1-TEST-03 · BEREIT ZUR RÜCKGABE ===
