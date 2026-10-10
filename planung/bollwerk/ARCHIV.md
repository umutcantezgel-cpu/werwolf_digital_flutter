# ARCHIV · Linien und ihre Übernahme (Vorlauf, A-9 §8)

Quelle: `planung/bollwerk/BESTAND.md` §2. Die SHA ist der Stand beim Eintrag (G1, 10.10.2026 02:30 UTC); BW8 trägt origin/main neu ein. Archiv-Branches legt nur der Leitstand an. Geprüft mit `bash tool/bollwerk/archiv_pruefen.sh` (Z-29) und `--uebernahmen` (Z-30).

| Linie | Ref | SHA | Klasse | Art | Archiv-Branch |
|---|---|---|---|---|---|
| main (Basis) | main | 47611d8 | Basis | – (kommt in BW0 und BW8 per Hereinholen) | archiv/vor-bollwerk (Leitstand, vor dem main-Push) |
| Finalisierung | finalisierung-schlosskeller | ea8d765 | läuft → Basis ab B-02 | – (kommt über origin/main mit B-02) | nicht nötig |
| FEINKORN | kern-feinkorn | 1145cb9 | zusammenführen | Merge im Vorlauf (`Merge kern-feinkorn@1145cb9`, G1, Tor grün an e1e1f9d; Spielcode nur über `feinkorn_leben.dart`) | archiv/feinkorn-1145cb9 (falls abgesagt) |
| Burgstadt HD | claude/pensive-gates-ajtp7x | caf1d61 | zusammenführen nur nach A-2 Definitionen | zurückgestellt: Merge erst, wenn danach L1 grün ist („LAYOUT GLEICH“, `hd_migbeleg` bytegleich) oder „A12: ja“ | archiv/hd-caf1d61 |
| Nachtlauf Burgstadt | nachtlauf/burgstadt | 47611d8 | eingefroren | – (kommt über main) | – |
| Krimidinner | main | 47611d8 | eingefroren | – (`krimidinner/**` auf main, nie geändert) | – |
| Jules-Optimierung | loop/epoch-* | (42 Refs) | nur archivieren | – (schon Vorfahr) | nicht nötig |
| Krimidinner-Kanon-PR | claude/ecstatic-cerf-7kzi1c | d92a675 | nur archivieren | – (gemergt) | nicht nötig |
| Kinder-Probe | bollwerk-probe | b8b74fa | nur archivieren | – | bleibt liegen |
| Meta-Archiv | claude/pensive-gates-ajtp7x | f275929 | mitführen | Übernahme je Pfad `aus claude/pensive-gates-ajtp7x@<sha>:planung/bollwerk/archiv/<pfad>` (offen) | – |
