ABNAHME F2-TEST-01 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-025)

# Bericht F2-TEST-01

## Ergebnis F2-TEST-01
- Geänderte Dateien: /home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/gruppenwahl_test.dart (neu). Sonst nichts geändert, `git diff` ist leer. Im selben Ordner liegen fremde Testdateien (determinismus_test.dart, enden_test.dart, gruppenwahl_dilemma_test.dart), die ich nicht angefasst habe.
- Anzahl Tests: gruppenwahl_test.dart 13 (Wahlen 4, Schwellen 5, Bonus-Hinweise 4)
- Analyse: No issues found!
- Tests: 00:00 +13: All tests passed!
- Rot-Proben: Kopie des Pakets mit Kanon unter /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f2probe (Skript probe.py dort). Das Repo blieb unverändert. P0 ohne Manipulation: 13 grün.
  - P1 fall.json schwellen.wahr.gegen=4: rot „Tabelle“, „Sabotage netto −1“ und „Rot-Probe“ (deren Vergleich mit dem echten Kanon ist in der Kopie ebenfalls verändert)
  - P2 schwellen.neutral.gegen=3: rot „Tabelle“, „Sabotage netto −1“ und „erreichbar“ (neutral wird unerreichbar, weil wahr und neutral dieselbe Grenze haben)
  - P3 bonus.json h_can_3_falsch entfernt: rot „36 Hinweise je Pfad, Runde, Qualität“
  - P4 h_ahmet_1_wahr mit wirkung.person=tim: rot „Wirkung ist maschinenlesbar“
  - P5 h_ahmet_1_neutral mit person=ahmet: rot „Wirkung ist maschinenlesbar“
  - P6 gw_tim_1 quelle=loyalitaet: rot „quelle loyalitaet kommt nur bei Figuren mit loyalitaet.zu vor“
  - P7 gw_tim_1 quelle=zufall: rot „quelle ist geheimnis oder loyalitaet“
  - P8 gw_ahmet_1 ohne bTaeter: rot „genau die vier Kernrollen haben bTaeter …“
  - P9 gw_tim_2 entfernt: rot „je Figur und Runde genau eine Wahl … insgesamt 60“
  - P10 lib (Kopie): zusammengehalten zählt neutral mit: rot „sichtbar ist nur … nur wahr ergibt true“
  - P11 lib (Kopie): Sabotage ohne Abzug: rot „Sabotage netto −1“ und „wirksame Stimmen werden bei Sabotage nie negativ“
- Tabelle n → (minNeutral, minWahr), von Hand aus 5·A ≥ 3·N (wahr) und 5·A ≥ 2·N (neutral) gerechnet und außerhalb des Tests per Brute-Force bestätigt:
  - 4 → (2, 3)
  - 5 → (2, 3)
  - 6 → (3, 4)
  - 7 → (3, 5)
  - 8 → (4, 5)
  - 9 → (4, 6)
  - 10 → (4, 6)
  - 11 → (5, 7)
  - 12 → (5, 8)
  - 13 → (6, 8)
  - 14 → (6, 9)
  - 15 → (6, 9)
  - 16 → (7, 10)
  - 17 → (7, 11)
  - 18 → (8, 11)
  - 19 → (8, 12)
  - 20 → (8, 12)

## OFFENE FRAGEN
- Schritt 5 (Erreichbarkeit) prüft pro Qualität, nicht pro Hinweis. Alle Hinweise mit gleicher Qualität bekommen dasselbe Ergebnis, der Test kippt also nur, wenn eine Stufe unerreichbar wird (siehe P2). Eine stärkere Prüfung pro Hinweis lässt sich aus den Daten nicht ableiten.
- Klammer bei 0: Der Test „wirksame Stimmen werden bei Sabotage nie negativ“ setzt voraus, dass Sabotage ohne kooperative Stimme 0 ergibt. Bitte bestätigen oder streichen.
- Nicht abgedeckt, weil nicht im Auftrag: widerlegtDurch der falschen Hinweise, die Quellen der wahren und neutralen Hinweise sowie die Texte. Der Simulator prüft widerlegtDurch bereits in pruefe().
- gruppenwahl_dilemma_test.dart (fremder Agent, von mir nicht gelesen) liegt im selben Ordner. Eine Überschneidung bei der Gruppenwahl-Abdeckung ist möglich und nicht geprüft.

=== ENDE F2-TEST-01 · BEREIT ZUR RÜCKGABE ===
