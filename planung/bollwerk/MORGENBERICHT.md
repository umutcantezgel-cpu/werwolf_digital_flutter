# MORGENBERICHT · BOLLWERK · Samstag, 10. Oktober 2026 (Generation 1)

## 1. Kurz gesagt
Die erste Nacht war Vorlauf, denn die Finalisierung ist noch nicht fertig (B-02 offen, 2 von 5 Bedingungen). In gut 2½ Stunden ist das Fundament entstanden: Werkzeugkette, Torwerkzeug mit bestandener Rot-Probe, der Würfelkern mit Pech-Garantie und Kettensperre, ein Simulator, der die Zahlen des Meta-Laufs bitgenau nachrechnet, und der FEINKORN-Merge. Eine unabhängige Prüfung des Würfelkerns fand 14 Befunde; 7 sind schon behoben, 3 brauchen einen kleinen Regel-Schritt („Kern 1.1“) in der nächsten Nacht. Am Spiel selbst sieht man noch nichts – das beginnt nach B-02.

## 2. Zuerst ansehen
- Torwerkzeug: `source tool/bollwerk/env.sh && dart run tool/bollwerk/bollwerk.dart schnell --vorlauf` (≈ 1 min, Endzeile `BOLLWERK GRÜN · schnell · <sha>`).
- Simulator: `dart run tool/bollwerk/runden_simulate.dart --modus baender --seeds 1000` und `--modus fairness`.
- Prüfbericht des Würfelkerns: `planung/bollwerk/berichte/G1/PRUEF-KERN-1.md`.

## 3. Vorher/Nachher-Kontaktbogen
Noch keiner: Die Vorher-Galerie entsteht erst in BW0 am B-02-Stand, Design-Arbeit erst ab BW3.

## 4. Die Nacht in Zahlen
- U: noch nicht messbar (Basis erst in BW0 an K). Vorbereitete Basiszahl X3: 42 Orte (roh 43).
- Abnahme: 0 von 35 (abgenommen wird erst am Ziel-Tor). Im Vorlauf grün belegt: L0, L2, L3, L4, L5 (`belege/tor-V.txt`, Stand 30fadff).
- Würfelkern, Beweise: erschöpfend 313.344 Läufe mit 0 Sackgassen, 0 Kettenverletzungen, 0 Budgetüberschreitungen, 0 Wertungsabweichungen (jetzt mit Ende und Restverdächtigen), 0 Faktenstand-Abweichungen; C8 1a: 640 Folgefälle grün.
- Bänder (Meta-Satz, 1.000 Partien je Form × Besetzung): Dart-Port = Python-Vorlage, 0 von 200 Kennzahlen abweichend. Fairness: |ρ| = 0,045, Geiz-Bot 4,0 Punkte.
- L3 Determinismus: 1.000 Codes, VM = Node = eingecheckte Liste.
- Tests: voller Bestandslauf 621 s, alles grün (L-1).
- Varianten: 0 (keine Variantenwelle; die Fabrik-Werkzeuge varianten.dart/vorrat.dart folgen).
- Agentenaufrufe: 3 (1 Opus-Prüfer, 2 Haiku-Berichte), Werkzeug-Audit 0 Verstöße.

## 5. Stand von `bollwerk`
Siehe Zugende-Zeile im Chat; Code-Stand 7164edf (Würfelkern, Tests, Torwerkzeug, FEINKORN, Archiv). TOR-SHA 30fadff.

## 6. Was auf Standardwahlen beruht
- X3-Basis 42 statt 43 (`wc` liegt oben im Turm, nicht im Keller). Kippt es, sinkt f_X3 um 2,4 %.
- Weißliste: neue pfadgleiche Kleinigkeiten der Schicht dürfen Zusatzfunde sein (Frage G1-2). Kippt es, bleibt Z-11 rot.
- Seifenblasen-Marken und „gründlich“ nach dem Spielkern, nicht nach dem Meta-Simulator (Frage G1-3). Kippt es, nichts zu tun.

## 7. Was nicht lief
- Keine Variantenwelle: Ohne varianten.dart/vorrat.dart wäre nichts zählbar geprüft worden.
- Meta-Archiv (107 Dateien) noch nicht übernommen: braucht eine Durchsicht auf Rohchat-Spuren.
- HD-Linie `caf1d61` zurückgestellt (Merge erst, wenn danach L1 grün ist; das prüft erst das Phasentor).
- L4-Modus `dauer` offen (braucht das Zeitmodell aus BW0).
- Rohchat fehlt in der Cloud: Secret-Scan ohne Passagenprüfung (G1-1).

## 8. Nächster Schritt und Restbedarf
G2 (Vorlauf, solange B-02 offen): Kern 1.1 (Marken, „gründlich“ im Abstecher, getrennter Bot-Strom) mit neuer Bandmessung; varianten.dart (Ringe 1–6), vorrat.dart; Weißlisten-Nachprüfung durch Opus; danach erste Variantenwelle für `content/runden/`. Ab B-02: BW0 (Basis an K), dann BW1. Restbedarf bis main unverändert: 6–7 Hauptlauf-Nächte nach B-02 (A-20).

## 9. Bis zum Store fehlt
Release-Signatur, Datenschutzerklärung, Altersangaben, Bildschirmfotos, `web/manifest.json`, Tests auf echten Geräten.
