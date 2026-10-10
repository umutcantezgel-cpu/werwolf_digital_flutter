# Archiv des Sitzungs-Scratchpads (Sitzung f7a52164, gesichert 2026-10-09)

Quelle: `/tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/` – flüchtig, geht mit dem Container verloren.

Weißliste: nur `*.md`, `*.patch`, `*.json`, `*.csv`, `*.txt` ≤ 1 MB aus der obersten Ebene und den Ordnern `briefings/`, `bollwerk/`, `feinkorn/`. Nicht übernommen (bewusst): Bilder (wurden im Chat gezeigt; Burgstadt-HD-Bildsätze lassen sich mit `bash tool/hd_migbeleg.sh` bzw. den Proben in `packages/burgstadt_spiel/bin/` neu erzeugen), Binärdateien (`feinkorn/k0.exe`, `k0aot`), JS-Bundles (`lt.js*`), Python-Caches, Probeordner (`probe01/` 381 MB, `mig/`, `pruef_p5/` …). `quellen/` (Rohchat) existiert in diesem Container nicht; Passagenprüfung des Secret-Scans wird deshalb übersprungen – keine Datei hier enthält Team-Chat-Zitate (Prüfung: Sichtung der Dateiliste, Inhalte stammen aus dieser Sitzung).

Inhalt: Burgstadt-HD-Gesamtplan und Feinplan, 37 HD-Auftragsbriefings, FEINKORN-Auftragsbriefe und Rohmessungen, BOLLWERK-Bestandsnotizen und Gegenprüfer-Befunde, Arbeits-Patches.

| Datei | Bytes | sha256 (16) |
|---|---:|---|
| `BURGSTADT-HD-GESAMTPLAN.md` | 90251 | 86d624623d3f5882 |
| `ausgang_backup.txt` | 94 | 6d20b20e73fcdc8e |
| `b1.txt` | 190 | 17f633b9e073f07b |
| `b2.txt` | 190 | 17f633b9e073f07b |
| `banding.csv` | 2111 | 57acfbaca3348435 |
| `banding_probe.txt` | 149 | 6ddd19c6b03588bb |
| `bestand_probe.txt` | 8642 | f7103b809cb47265 |
| `bollwerk/befunde/D_durchhalten.md` | 3631 | 9b8d244d935c01dd |
| `bollwerk/befunde/K_klarheit.md` | 6557 | 18327f5347097953 |
| `bollwerk/befunde/U_nutzer.md` | 4691 | 2a4ab808e5b11a01 |
| `bollwerk/befunde/V_Z_A.md` | 13050 | 2800ba49f260c4b7 |
| `bollwerk/notizen_kanon_hoheit.md` | 4846 | 6b527d5048b59f3d |
| `bollwerk/notizen_look.md` | 2602 | 11b7305380330da5 |
| `bollwerk/notizen_mechanik.md` | 3685 | 3508266b01cedbde |
| `bollwerk/notizen_pruefung_archiv.md` | 7945 | 280e76b47b0bb800 |
| `bollwerk/notizen_steuerung.md` | 4235 | 139ca1015fe838a7 |
| `bollwerk/notizen_systeme_wiederverwertung.md` | 4983 | d6cf213e3b349baa |
| `bollwerk_rs_fin.md` | 30549 | ce06009d1e5f3923 |
| `bollwerk_rs_krimi.md` | 27196 | 9e9b1feb12cc78d4 |
| `briefings/FORM-KOPF.md` | 4248 | a013bd1934244f11 |
| `briefings/P0-AUTOR-01.md` | 4362 | d27ebe4ffe158796 |
| `briefings/P0-AUTOR-02.md` | 3243 | cfacef15e5563019 |
| `briefings/P0-AUTOR-03.md` | 4599 | 8700d095e7f82e8a |
| `briefings/P0-AUTOR-04.md` | 3661 | 13267bf4e4aae7cf |
| `briefings/P0-AUTOR-05.md` | 4466 | d5618020d5f7405f |
| `briefings/P0-AUTOR-06.md` | 4914 | 1a9772067f0f67c8 |
| `briefings/P0-GEGEN-01.md` | 3444 | db5b51bad6b6ccc2 |
| `briefings/P0-KUND-05.md` | 3175 | 6e65ccb4a8f8a1e7 |
| `briefings/P0-KUND-06.md` | 3158 | c1f3e199d946cb77 |
| `briefings/P0-PROBE-01.md` | 2793 | d00a4faf61dc77bb |
| `briefings/P0-PROBE-03.md` | 2732 | ff59e821459c3960 |
| `briefings/P0-SICHT-01.md` | 1966 | 2fdd9b4878cab131 |
| `briefings/P0-SICHT-02.md` | 1966 | d59411d21e9dbeb5 |
| `briefings/P0-SICHT-03.md` | 1966 | 5639c02b0121f9a4 |
| `briefings/P1-AUTOR-01.md` | 3899 | 1fee5f9e4d9365f2 |
| `briefings/P1-AUTOR-03.md` | 2858 | 7ecf7bf0e07acefc |
| `briefings/P1-AUTOR-04.md` | 1462 | 0ab1034f596fe258 |
| `briefings/P1-AUTOR-05.md` | 1409 | 745460c110b5b8fa |
| `briefings/P1-AUTOR-06.md` | 1543 | 8782b32b3bfc7370 |
| `briefings/P1-AUTOR-07.md` | 1685 | 9c540881b426edd4 |
| `briefings/P1-AUTOR-08.md` | 3794 | a3c746ffaf4bb12d |
| `briefings/P1-VAR-01.md` | 1286 | 683f13d7a2d60b9a |
| `briefings/P1-VAR-02.md` | 1262 | 7b0cde77a9593fbd |
| `briefings/P4-AUTOR-01.md` | 2170 | 620ccf131062309e |
| `briefings/P4-AUTOR-02.md` | 1998 | fa942968d766cfb0 |
| `briefings/P4-AUTOR-03.md` | 1996 | 0911800808fe82ed |
| `briefings/P4-AUTOR-04.md` | 2808 | b04be4124eed3edd |
| `briefings/P7-AUTOR-0102.md` | 2518 | 16981ee7720c5f1f |
| `briefings/P7-AUTOR-04.md` | 4011 | 6ecf747e27ec82a0 |
| `briefings/P7-AUTOR-07.md` | 1979 | 66c00aba8756d6d1 |
| `briefings/P7-AUTOR-10.md` | 2725 | b5efea7521fd9830 |
| `briefings/P7-KOPF.md` | 1379 | 781ed112f50432d9 |
| `briefings/REP-01.md` | 4081 | 63eb599cf5d62bdd |
| `briefings/REP-02.md` | 3645 | 2ab854eb7493b396 |
| `briefings/REP-03.md` | 3114 | ccf547b839be1a2e |
| `briefings/TEXTUR-KOPF.md` | 3115 | 71f9171d596cd600 |
| `counts.json` | 1327 | 9b6daaf0c2eff5a5 |
| `dichte.patch` | 19537 | a62edfd879f96756 |
| `eich_v2_loesung.md` | 3490 | ab8a784f028d0ec7 |
| `eichung_loesung.md` | 3490 | ab8a784f028d0ec7 |
| `f1.txt` | 714 | 0b173e19365ef861 |
| `f2.txt` | 714 | 0b173e19365ef861 |
| `feinkorn/auftraege/K0-DOKUMENTAR-01.md` | 3764 | 1b9d2a9b82cdbd1c |
| `feinkorn/auftraege/K0-GEGENPRUEFER-01.md` | 3780 | aa972015c845b2b1 |
| `feinkorn/auftraege/K0-KUNDSCHAFTER-01.md` | 3903 | ae8b4f64e1945a1d |
| `feinkorn/auftraege/K0-KUNDSCHAFTER-02.md` | 3818 | 18ddce9fd92838e3 |
| `feinkorn/auftraege/K0-LEISTUNGSPRUEFER-01.md` | 4863 | 7147e4ccfb70e075 |
| `feinkorn/auftraege/K0-TESTSCHREIBER-01.md` | 5176 | 8cd6f6529f394414 |
| `feinkorn/auftraege/K1-MATERIALMACHER-01.md` | 5334 | 44148f81da743566 |
| `feinkorn/auftraege/K1-MATERIALMACHER-02.md` | 5528 | a5aea0aeb30c0705 |
| `feinkorn/auftraege/K1-MATERIALMACHER-03.md` | 5608 | 2e2ab3fcf3299d53 |
| `feinkorn/auftraege/K1-MATERIALMACHER-04.md` | 5536 | 939f7e8ba844c050 |
| `feinkorn/mess/basis.json` | 3840 | 28b8a5373b3c09cb |
| `feinkorn/mess/k0_wege.json` | 2963 | 29be259842ccc00c |
| `feinkorn/mess/teststand/bestand_stderr.txt` | 190 | c81e6a3b1a42684a |
| `feinkorn/mess/teststand/bestand_stdout.txt` | 8594 | 6bc7b96333ab2abc |
| `feinplan.md` | 48626 | 133c3cec2518f788 |
| `fg.txt` | 161981 | 2b99169ddcb36870 |
| `files.txt` | 6494 | b7bcf09339bd0e5b |
| `final_counts.json` | 389 | 5bb9362460ca5a63 |
| `flimmer_probe.txt` | 673 | f49779d4ae177914 |
| `kandidaten.patch` | 11867 | cc202584b39007b4 |
| `kund05_legenden_dump.txt` | 38622 | d8a14480270ba452 |
| `licht_v2.patch` | 11093 | 0e3f6cbde69f288e |
| `neu.md` | 34919 | 1a9d012c7b7a7faf |
| `opus01.patch` | 35515 | c771c7625938ce9e |
| `palette_v2.patch` | 34373 | 564b6c2e15bbae7c |
| `parts.json` | 24371 | 73ade378eee77bd1 |
| `rep01_png.txt` | 2265 | 3df6c1da70f85c85 |
| `rep01_std_1.txt` | 1309 | 8059bd4872ec10ca |
| `rep01_std_2.txt` | 1309 | 8059bd4872ec10ca |
| `rep01_welt640.txt` | 1310 | 5e05cb3dc7fd2c0d |
| `selbst.md` | 3685 | 58e1d6e96048cb93 |
| `skalierung_v2.patch` | 9618 | a5c42523e3f2c73e |
| `state.json` | 89809 | e573c0afc0df0d4c |
| `state_before.json` | 89809 | e573c0afc0df0d4c |
| `szenen_a.json` | 3497 | 75af430082b3a4ce |
| `szenen_b.json` | 3445 | d8652a52022c141f |
