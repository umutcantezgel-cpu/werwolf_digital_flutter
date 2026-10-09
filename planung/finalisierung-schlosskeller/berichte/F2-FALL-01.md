ABNAHME F2-FALL-01 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-025)

# Bericht F2-FALL-01

## Bericht F2-FALL-01

### Simulator-Ausgabe

```
Simulator · Spuk im Schlosskeller · 768 Optionsfolgen je Pfad × 4 Anklagen
Gruppenergebnisse ändern die Restmenge nie (W-1); geprüft über alle Hinweise.

Pfad ahmet: 3072 Spiele
  Enden: Meister-Detektiv 55 · Teilerfolg 713 · Justizirrtum 1635 · Totale Eskalation 669
  Punkte: 0:2 1:17 2:64 3:140 4:196 5:182 6:112 7:44 8:10 9:1
  Restmenge nach Runde 3: 1:384 2:24 3:144 4:216
  Rate-Enden (Anklage außerhalb der Restmenge): 1344; Treffer trotz Restmenge > 1: 384
  Restmenge 1 mit weniger als 9 Punkten: 383 Folgen
  Bestes Spiel: Restmenge nach Runde 1/2/3 = 4/2/1
Pfad fatma: 3072 Spiele
  Enden: Meister-Detektiv 55 · Teilerfolg 713 · Justizirrtum 1635 · Totale Eskalation 669
  Punkte: 0:2 1:17 2:64 3:140 4:196 5:182 6:112 7:44 8:10 9:1
  Restmenge nach Runde 3: 1:384 2:36 3:168 4:180
  Rate-Enden (Anklage außerhalb der Restmenge): 1392; Treffer trotz Restmenge > 1: 384
  Restmenge 1 mit weniger als 9 Punkten: 383 Folgen
  Bestes Spiel: Restmenge nach Runde 1/2/3 = 4/2/1
Pfad olli: 3072 Spiele
  Enden: Meister-Detektiv 55 · Teilerfolg 713 · Justizirrtum 1635 · Totale Eskalation 669
  Punkte: 0:2 1:17 2:64 3:140 4:196 5:182 6:112 7:44 8:10 9:1
  Restmenge nach Runde 3: 1:384 2:36 3:168 4:180
  Rate-Enden (Anklage außerhalb der Restmenge): 1392; Treffer trotz Restmenge > 1: 384
  Restmenge 1 mit weniger als 9 Punkten: 383 Folgen
  Bestes Spiel: Restmenge nach Runde 1/2/3 = 4/2/1
Pfad can: 3072 Spiele
  Enden: Meister-Detektiv 55 · Teilerfolg 713 · Justizirrtum 1635 · Totale Eskalation 669
  Punkte: 0:2 1:17 2:64 3:140 4:196 5:182 6:112 7:44 8:10 9:1
  Restmenge nach Runde 3: 1:393 2:69 3:171 4:135
  Rate-Enden (Anklage außerhalb der Restmenge): 1488; Treffer trotz Restmenge > 1: 375
  Restmenge 1 mit weniger als 9 Punkten: 392 Folgen
  Bestes Spiel: Restmenge nach Runde 1/2/3 = 4/2/1

Simulator: OK (344 ms)
```

Der Lauf war grün, `pruefe()` und `pruefeSchwellen()` meldeten keinen Verstoß. Die Zahlen unten stammen aus Auswertungen über dieselben Funktionen (`Ermittlung.faktenVon`, `Simulator.verlauf`) in einem Hilfsskript im Scratchpad.

### Verteilungen je Pfad

Punkte und Enden sind in allen vier Pfaden identisch: Enden Meister 55 (1,8 %), Teilerfolg 713 (23,2 %), Justizirrtum 1635 (53,2 %), Totale Eskalation 669 (21,8 %) von je 3072 Spielen. Die Punkteverteilung ist ebenfalls gleich, und jeder Pfad hat genau eine 9-Punkte-Folge.

| Pfad | Restmenge nach R3: 1 / 2 / 3 / 4 | Rate-Enden | Treffer trotz Rest > 1 | Rest 1 mit < 9 Pkt. | Bestes Spiel R1/R2/R3 |
|---|---|---|---|---|---|
| ahmet | 384 / 24 / 144 / 216 | 1344 | 384 | 383 | 4/2/1 |
| fatma | 384 / 36 / 168 / 180 | 1392 | 384 | 383 | 4/2/1 |
| olli | 384 / 36 / 168 / 180 | 1392 | 384 | 383 | 4/2/1 |
| can | 393 / 69 / 171 / 135 | 1488 | 375 | 392 | 4/2/1 |

Unterschiede gibt es nur bei der Restmenge. Der Grund sind die Alibi-Fakten: In den Pfaden ahmet, fatma und olli fehlt der Alibi-Fakt des Täters, es bleiben zwei (`f_alibi_*`). Im Pfad can gibt es keinen Alibi-Fakt für can, also bleiben drei. Mehr Alibis bedeuten mehr Entlastung, daher weniger Restmenge 4 (135 statt 180 bis 216). Die Gesamtzahl der Fakten ist mit 18 von 30 pro Pfad gleich.

### Abkürzungen

- **Eine Entscheidung reicht.** Pro Pfad gibt es genau eine Einzelwahl, die allein auf Restmenge 1 führt, und sie liegt immer in e3_2. Die richtige Option ist in ahmet, olli und can `e3_2_kerzenstaender`, in fatma `e3_2_fatma`. Alle anderen Einzeloptionen lassen die Restmenge bei vier.
- **Warum.** In jedem Pfad existiert genau ein Schlüsselbeweis (`f_k_<Täter>`), und er hängt nur an der richtigen e3_2-Option. Die Fakten-Liste von `e3_2_kerzenstaender` in `entscheidungen.json` nennt drei (`f_k_ahmet`, `f_k_can`, `f_k_olli`), aber pro Pfad entsteht nur einer. R-UEBERFUEHRT macht daraus Restmenge 1, unabhängig von den übrigen acht Entscheidungen. E-024 nennt diesen Schritt ausdrücklich („Mit dem Schlüsselbeweis bleibt genau eine Person“).
- **Die 383 Folgen.** Es sind alle Folgen mit richtiger e3_2-Wahl außer der Bestfolge (384 − 1). Im Pfad can kommen 9 Folgen mit `e3_2_fatma` dazu (392). Diese kommen ohne Schlüsselbeweis über R-ENTLASTET auf 1.
- **Zusatz im Pfad can.** 12 von 768 Folgen (1,6 %) erreichen Restmenge 1 schon nach Runde 2 mit nur 5 richtigen Entscheidungen. Der Auslöser ist die falsche Option `e2_1_ascheneimer`, die `f_nd_ahmet_umschlag` aufdeckt. Zusammen mit dem Alibi aus `e1_1_damir` schließt das Ahmet aus. Das Muster steht im Nachtrag von E-024. F-06 („nach Runde 2 mit 6 richtigen genau 2“) bleibt grün.

### Ratestrategien

Ende jeweils bei richtiger Anklage (bei falscher Anklage steht Justizirrtum, wenn die Punkte 4 bis 9 betragen, sonst Totale Eskalation).

| Strategie | ahmet | fatma | olli | can |
|---|---|---|---|---|
| A: immer erste Option (= Kerzenständer in e3_2) | 9, Meister | 7, Meister | 8, Meister | 6, Teilerfolg |
| B: immer Option mit Ziel „person“, sonst erste (= e3_2_fatma) | 8, Meister | 8, Meister | 7, Meister | 5, Teilerfolg |
| C: „immer Kerzenständer“ | identisch mit A | | | |
| D: Runde 1 richtig, R2/R3 geraten (96 Kombinationen) | Mittel 5,83; Meister 28/96 (29 %) | identisch | identisch | identisch |

- A und C sind identisch, weil der Kerzenständer in e3_2 die erste Option ist.
- Bei A ist die erste Option in ahmet 9/9, olli 8/9, fatma 7/9 und can 6/9 richtig. Im Pfad can führt A bereits nach Runde 2 auf Restmenge 1.
- Bei D liegt die Restmenge nach R3 bei 1 in 48/96 (ahmet, fatma, olli) bzw. 57/96 (can).

### Schwierigkeit

- Meister braucht mindestens 7 von 9 richtigen Entscheidungen und eine richtige Anklage. Bei reinem Zufall erreichen 7,2 % der Folgen (55 von 768) mindestens 7 Punkte. Mit zufälliger Anklage (eine von vier) ergibt das 1,8 % Meister. Die mittlere Punktzahl liegt bei 4,33 von 9.
- Mit richtiger Runde 1 steigt die Meisterquote auf 29 % (Strategie D).
- Strategie A gewinnt ohne Nachdenken in drei von vier Pfaden. Im Pfad can landet sie bei 6 Punkten und damit im Teilerfolg.
- Deutung: Die Zufallsquote von 1,8 % ist für eine Party niedrig, die Ausgangslage für Denkende ist gut. Der Schwierigkeitsgrad hängt aber stark an der Reihenfolge der Optionen und an e3_2. Das passt nur, wenn die Reihenfolge nicht verrät, was richtig ist (siehe Vorschlag 1).

### Bonus-Hinweise

- Es gibt 36 Hinweise (4 Pfade × 3 Runden × 3 Qualitäten), wie in F-08 gefordert.
- Von den 12 wahren Hinweisen benennen 8 den Täter als „belastet“ im Klartext: in R1 für ahmet, fatma und olli mit Namen, für can verschlüsselt („das leuchtende Gesicht“). In R2 geschieht das in allen vier Pfaden direkt (`h_ahmet_2_wahr`, `h_fatma_2_wahr`, `h_olli_2_wahr`, `h_can_2_wahr`). Die übrigen 4 wahren Hinweise (R3) entlasten einen Nicht-Täter.
- Formal ändert nichts davon die Restmenge (W-1 grün). Die menschliche Einschätzung dagegen verschiebt sich nach einem wahren R1 bei ahmet, fatma und olli stark, nach R2 in allen Pfaden. Das ist eine Deutung und nicht gemessen.
- Ein Pfad, der deutlich mehr verrät, gibt es nicht. Der Pfad can ist in R1 nur verschlüsselter.
- Abweichung von E-024: Dort steht für R3 „die Spätankunft der Täterperson“. In `bonus.json` entlastet der wahre R3-Hinweis dagegen Can (drei Pfade) bzw. Ahmet (can).

### Vorschläge

| Nr | Fundstelle | Befund mit Zahl | Vorschlag | Wirkung auf F-06–F-08 |
|---|---|---|---|---|
| 1 | `entscheidungen.json`, Optionsreihenfolge aller neun Entscheidungen | Die erste Option ist richtig in 9/9 (ahmet), 8/9 (olli), 7/9 (fatma), 6/9 (can). Strategie A gewinnt drei von vier Pfaden. Allein e3_2 zu tauschen bringt nichts: B bleibt Meister in drei Pfaden. | Die Optionsreihenfolge je Entscheidung mischen, nicht nur e3_2. Die Ratestrategie „erste Option“ als Kennzahl im Bericht führen. | F-06: Zahlen und Enden bleiben gleich, nur die Reihenfolge ändert sich. Der Ausweis der Rate-Enden wird erweitert. |
| 2 | `bonus.json`, `h_ahmet_1_wahr`, `h_ahmet_2_wahr`, `h_fatma_1_wahr`, `h_fatma_2_wahr`, `h_olli_1_wahr`, `h_olli_2_wahr`, `h_can_1_wahr`, `h_can_2_wahr` | 8 von 12 wahren Hinweisen benennen den Täter als „belastet“ im Klartext. | Die Texte der wahren R1- und R2-Hinweise so umformulieren, dass der Name der Täterperson im Satz fehlt. Die Wirkung bleibt `belastet`. | F-06 (W-1) und F-08 (36 Hinweise, maschinenlesbare Wirkung) bleiben unberührt. Es ändert sich nur der Text. |
| 3 | `bonus.json`, `h_*_3_wahr` (4 Hinweise) gegen ENTSCHEIDUNGSLOG E-024, Bonus-Abschnitt | E-024 verlangt für R3 wahr die Spätankunft der Täterperson. Tatsächlich entlasten die wahren R3-Hinweise Can (ahmet, fatma, olli) bzw. Ahmet (can). | Abweichung klären. Entweder E-024 nachziehen oder den wahren R3-Hinweis auf die Spätankunft der Täterperson umstellen (`belastet`, pfadpassend). | F-08: Die Prüfung „wahrer Hinweis belastet keinen Unschuldigen“ bleibt grün. F-06 bleibt unberührt. |
| 4 | `entscheidungen.json`, `e2_1_ascheneimer` im Pfad can | 12 von 768 Folgen (1,6 %) erreichen nach R2 Restmenge 1 mit 5 richtigen. Auslöser ist `f_nd_ahmet_umschlag` aus der falschen Option. | Prüfen, ob die falsche Option im Pfad can ohne Nebendelikt-Fakt auskommen kann (nur harmlose Fassung). Das bestehende Muster aus dem E-024-Nachtrag wäre damit entschärft. | F-06: „nach R2 mit 6 richtigen genau 2“ und das bestes Spiel bleiben unverändert (es wählt die Option nicht). |
| 5 | `packages/mordakte_core/lib/src/party/simulator.dart` (`auszaehlen`) und `bin/party_simulate.dart` | Der Bericht weist nur Rate-Enden (Anklage außerhalb der Restmenge) aus. Die Ratestrategien A, B und D fehlen. | Je Pfad eine Zeile für Ratestrategien ergänzen (Punkte und Ende bei richtiger Anklage). Keine neue Prüfregel. | F-06 („Rate-Enden getrennt ausgewiesen“) wird ergänzt. Kein Prüfergebnis ändert sich. |

## OFFENE FRAGEN

- Ist gewollt, dass ein einzelner Schlüsselbeweis in e3_2 die Restmenge allein auf 1 setzt (E-024 spricht dafür), sodass die Hälfte der Zufallsfolgen ohne weitere Deduktion überführt?
- Ist die Abweichung bei R3 wahr (E-024 gegen `bonus.json`) beabsichtigt oder ein Nachtrag, der nicht übernommen wurde?
- Wie ist „Option mit Person“ zu verstehen, wenn in e1_1 und e1_2 beide Optionen ein Ziel mit Person haben? Hier wurde die erste gewählt.
- Ein Zielwert für die Schwierigkeit fehlt im Kanon. Die Einordnung „passend“ ist eine Deutung.
- Die Wirkung der Hinweise auf die menschliche Einschätzung ist nicht gemessen. Dafür fehlt ein Spieltest.
- Die Wahrscheinlichkeit für wahr, neutral oder falsch bei einer realen Gruppe ist nicht ausgewertet.
- Selbstprüfung: alle vier Pfade betrachtet, Aussagen mit Zahl oder Fundstelle belegt. Keine Kanon- oder Repo-Datei geändert. Die Hilfsskripte `f2_analyse.dart`, `f2_reihenfolge.dart` und `f2_r2.dart` liegen nur im Scratchpad (System-Temp). Git wurde nicht geschrieben, Netz nicht genutzt.

=== ENDE F2-FALL-01 · BEREIT ZUR RÜCKGABE ===
