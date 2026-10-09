ABNAHME F3-TEST-01 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 1 · Grenzen 2 · Summe 9/10 · Prüfung 16 von ORCH geschärft (E-029)

# Bericht F3-TEST-01

## Ergebnis F3-TEST-01
- Geänderte Dateien (neu, nur eigene): `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/dossier_test.dart`, `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/erzaehler_test.dart`, `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/spoiler_test.dart`. Die 12 geänderten Gesprächsdateien im Arbeitsbaum stammen von anderen Agenten.
- Anzahl Tests: dossier 15, erzaehler 8, spoiler 9 (zusammen 32: 15 echte Prüfungen, 16 Rot-Proben, 1 Gegenprobe).
- Analyse: `No issues found!`
- Tests: `Some tests failed.` (31 grün, 1 rot: Prüfung 16 auf echten Daten)
- Rot auf echten Daten: Prüfung 16 „Kein Satz aus Pfadwissen steht am Tisch“, 2 Fundstellen:
  - Gespräch `g_can_1_2` (gespraeche-r1-b1.json), Text: „auf der toilette im turm“ (Quelle: Täterprofil can.crimeExecution)
  - Gespräch `g_can_2_1` (gespraeche-r2-b1.json), dieselbe Folge.
  - Einordnung: Der Satz ist die erlaubte Behauptung der Lüge `luege_can_toilette`. Dieselbe Wendung steht im unschuldigen Profil von Can (`innocentProfile`) und in `aufloesung.can.unschuldig`, der Fakt gilt also in allen Pfaden. Die Regel wertet nur das Täterprofil als Pfadquelle. Befund nach Regel, Entscheidung offen (siehe unten).
  - Alle anderen echten Prüfungen (Schritte 1–7, 9–12, 14, 15, 17): keine Fundstellen.
- Rot-Proben (alle grün, Erkennung funktioniert):
  - Schritt 1: Dossier `enes` entfernt → Zusammensetzen meldet „wirft“.
  - Schritt 2: `spur_griff_papier` aus `taeter-ahmet` entfernt → gemeldet.
  - Schritt 3: `b_damir_ahmet_blieb` (verborgen) unter `weiss` von Ahmet → gemeldet.
  - Schritt 4: `luege_fatma_buffet` aus Fatmas `verbirgt` entfernt → gemeldet.
  - Schritt 5: `g_ahmet_1_3` entfernt bzw. `nr` auf 5 gesetzt → gemeldet.
  - Schritt 6: Sabotage von `gw_ahmet_1` entfernt → gemeldet.
  - Schritt 7: „TODO“ im Dossier von Ahmet → gemeldet.
  - Schritt 8 (Vorgabe): verborgene Beobachtung unter `weiss` → gemeldet.
  - Schritt 9: `finale.ahmet.ende_meister` entfernt → Lückenliste nennt ihn.
  - Schritt 10, 11, 12: Auswertung mit künstlichen Bausteinlisten (fremde Kennung, Auflösung vor dem Finale, falscher Restschlüssel) → gemeldet.
  - Schritt 13 (Vorgabe): Finaltext fehlt → Lückenliste nennt ihn.
  - Schritt 14: „Nur Olli bleibt.“ → Name gemeldet.
  - Schritt 15: „Ein wahrer Hinweis …“ → `wahrer` gemeldet.
  - Schritt 16 (a): Spurtext `spur_ring_messing` in `runde.1.start` → gemeldet.
  - Schritt 17: Preisgabe mit `b_damir_ahmet_weg` (nur Pfad ahmet) → gemeldet.
  - Gegenprobe: Folge, die auch pfadneutral steht, wird nicht gemeldet.
- Laufzeit je Datei: dossier ca. 1,8 s, erzaehler ca. 1,5 s, spoiler ca. 1,5 s (Gesamtlauf 2,1 s).

## OFFENE FRAGEN
1. Bonus-Hinweise (`bonus.json`) sind nicht Teil von Prüfung 16. Die Vorgabe zählt sie nicht auf, und `erzaehler.dart` nennt sie die einzige Ausnahme. Mit ihnen gäbe es 8 weitere Treffer, z. B. `h_fatma_1_falsch` mit „beim scheppern war ahmet nicht“ (Quelle `b_damir_ahmet_weg`, nur Pfad ahmet). Bitte entscheiden: aufnehmen oder ausnehmen.
2. Die Vorgabe nennt nur `killerProfile`. Das `innocentProfile` der Kernfiguren gilt aber ebenfalls nur in einem Teil der Pfade. Heute ändert das kein Ergebnis. Bitte bestätigen.
3. „Ganze Wörter“ in Prüfung 15 ist mit Rot-Probe (b) („wahrer“) nicht vereinbar. Umgesetzt als Wortanfang. Damit werden auch „wahrscheinlich“ und „Sicherung“ gemeldet.
4. Schritt 5 „Partner besetzt“ und „nie die Rolle selbst“ ist durch den Gesprächsplan konstruktiv erfüllt und mit Daten nicht rot zu machen. Anzahl und Nummern sind rot-geprüft.
5. Festlegungen, weil die Vorgabe sie offen lässt: Gruppen in Schritt 10 sind „keine kooperative Stimme, Täter sabotiert“ und „alle kooperativ“. „Erste Option“ ist die Anzeigereihenfolge von `optionen()`.
6. Der Lauf gilt für den Stand mit den umgeschriebenen Gesprächsdateien. Der Treffer bei Wojtek (`g_kaan_3_2`) aus meiner Vorabprüfung war während der Arbeit verschwunden, weil der Text geändert wurde. Nach dem Umbau bitte erneut laufen lassen.
7. Ein `git log` zu Beginn lief nur lesend, außerhalb der erlaubten Git-Befehle.
8. `dart analyze` lief nur auf meine drei Dateien. Der ganze Testordner ist nicht geprüft, weil dort andere Agenten parallel arbeiten.
=== ENDE F3-TEST-01 · BEREIT ZUR RÜCKGABE ===
