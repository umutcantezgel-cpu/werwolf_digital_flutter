# MORGENBERICHT · BOLLWERK · Samstag, 10. Oktober 2026 (Generation 2, Zwischenstand bei ABBRUCH)

## 1. Kurz gesagt
Generation 2 lief 45 Minuten im Vorlauf (B-02 weiter offen) und endete mit einem **Abbruch nach Regel**: Ein Haiku-Agent hat einmal das Steuerwerkzeug `send_message` aufgerufen. Die Plattform hat den Aufruf blockiert, es ist nichts passiert – aber die harte Regel A-2 A4.2 macht jeden steuernden Werkzeugaufruf eines Agenten zum Abbruchgrund. Vorher ist alles gesichert worden. Fertig sind: der Würfelkern 1.1 nach dem Spielkern (Marke bei jedem Pech, „gründlich“ kostet auch im Abstecher, Würfel getrennt vom Bot-Zufall), neu gemessen und grün; die Prüfwerkzeuge der Variantenfabrik; die Befunde F-3…F-8 des Leitstands; das Meta-Archiv. Entscheidung nötig: FUER-DEN-NUTZER G2-2 (Empfehlung „A13: ja“).

## 2. Zuerst ansehen
- Torwerkzeug: `source tool/bollwerk/env.sh && dart run tool/bollwerk/bollwerk.dart schnell --vorlauf --ohne-belege` (≈ 2 min, Endzeile `BOLLWERK GRÜN · schnell · <sha>`; ohne eingerichtetes `.werkzeug/` greift jetzt das vorhandene SDK, Befund F-5).
- Würfelbänder: `dart run tool/bollwerk/runden_simulate.dart --modus baender --seeds 10000` (10 s).
- Rohvarianten: `planung/bollwerk/vorrat/roh/W1/*.jsonl`, Prüfung: `dart run tool/bollwerk/varianten.dart --welle W1 planung/bollwerk/vorrat/roh/W1/ABST-*.jsonl`.
- Verstoß: `planung/bollwerk/berichte/G2/VERSTOSS-W2-ABST-west_saal-1.txt`.

## 3. Vorher/Nachher-Kontaktbogen
Keiner: Vorher-Galerie erst in BW0 an K, Design-Arbeit erst ab BW3.

## 4. Die Nacht in Zahlen
- U: noch nicht messbar (Basis erst in BW0 an K).
- Abnahme: 0 von 35 (erst am Ziel-Tor). Vorlauf: Tor `schnell --vorlauf` grün an jedem Code-Commit (be5a990, 8dee563, 93c2fd9, 52632ba); Z-29 und Z-30 grün über `archiv_pruefen.sh`.
- Würfelkern 1.1, 10.000 Partien je Form × Besetzung: Wurfanteil 43,1–43,2 % (streng bis 56,2 %), Pech im 1. Anlauf 33,4–33,9 % (Grenze 35 %), längste Pech-Folge 2, jede Runde mit Wurf, Median 3 Pech-Szenen und 3 Erfolge mit Zusatz, unteres Glücksquartil 30–31 % weniger Abstecher und 42–45 % weniger Zusatzfunde, Gerät je Runde 3,3 min (Party) bzw. 5,4 min (Solo). Fairness: |ρ| = 0,038 (jetzt aus der echten Vorschau), Geiz-Bot 4,0 Punkte. Erschöpfend: 313.344 + 307.200 Läufe mit Salz-Strömen, 0 Sackgassen, 0 Kettenverletzungen, 0 Budgetüberschreitungen, 0 Wertungs- und Faktenabweichungen.
- Varianten: 135 roh (W1 72, W2 30, Füllstücke 60 – davon 15 mit Werkzeugverstoß verworfen); Ringe 1–6: 70 von 75 gesicherten grün (5 Ausfälle: Notlaterne, Pfeife ohne Seifenblasen, „nach draußen“); Ring 7 (Richter) nicht mehr gelaufen; übernommen 0.
- Agentenaufrufe: 10 Haiku (1 gestoppt), ≈ 1,88 Mio Agenten-Tokens; Werkzeug-Audit: 2 Verstöße (1 lesend → verworfen, 1 steuernd → Abbruch).

## 5. Stand von `bollwerk`
Siehe Zugende-Zeile im Chat. Code-Stand 52632ba (Kern 1.1 mit F-6-Rest). TOR-SHA unverändert 30fadff, Verschärfungen danach mit Rot-Probe (E-G2-02, E-G2-07).

## 6. Was auf Standardwahlen beruht
- HD-Linie der Burgstadt nicht zusammengeführt: 192 von 198 Burgstadt-Bildern würden sich ändern (G2-1). Kippt es („A12: ja“), Merge in einer späteren Generation.
- Weißliste 11 Zusatzfunde (die zwei Täter-Befunde bleiben draußen, von Opus nachgeprüft); die fehlenden 3 für Z-11 kommen als neue pfadgleiche Kleinigkeiten (G1-2).
- Kern 1.1 nach dem Spielkern (G1-3).

## 7. Was nicht lief
- Ring 7 für W1: die Richter wären der nächste Schritt gewesen.
- Folgeentscheidungen (FOLGE-e1_1) und ABST-west_saal-1 verworfen (Werkzeugverstöße), ABST-ost_saal-1 beim Abbruch gestoppt.
- L-9b (abgekoppelter Prozess über 2 h): lief beim Abbruch erst 45 min – weiter offen; lange Tore bleiben in Schichtgruppen.
- Zusatzfund-Slot, F2/F6-Anbindung der Schicht im Simulator, Vorlauf-Durchstich.

## 8. Nächster Schritt und Restbedarf
Nach der Entscheidung zu G2-2 (Empfehlung „A13: ja“): G3 im Vorlauf – Ring 7 für W1, verworfene Slots einmal neu, weitere Wellen nach `vorrat.dart`, L-9 neu. Ab B-02: BW0 (Basis an K, Türregel-Altlast der K0-Demo als erste Aufgabe), dann BW1. Restbedarf bis main unverändert 6–7 Hauptlauf-Nächte nach B-02.

## 9. Bis zum Store fehlt
Release-Signatur, Datenschutzerklärung, Altersangaben, Bildschirmfotos, `web/manifest.json`, Tests auf echten Geräten.
