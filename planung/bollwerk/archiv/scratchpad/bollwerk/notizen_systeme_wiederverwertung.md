# Runden/Zufall (Bericht) – Kern
- KEIN Würfel/Glückssystem im Repo. Einziges Vorbild: engine.dart:803 Spurfund 50/30/20.
- Rng mordakte_core/lib/src/util/rng.dart (mulberry32 + FNV-1a hashString), KEIN eigener Unit-Test, Web-Gleichheit nur behauptet (kein -p chrome Lauf). Modulo-Verzerrung nextInt (vernachlässigbar).
- Muster je Entscheidung: Rng(code.seed ^ Rng.hashString(eid)) (ablauf.dart:128) → Wurf-Seed 'wurf:<eid>:<versuch>'.
- Party-Spiel 13 Phasen: titel, einrichtung, rollen, intro, gespraeche, entscheidungen, gruppenwahl, bonus, resuemee, anklage, finale, aufloesung, ende. ziel: 10× person, 6× gegenstand, 3× raum (Look-Leser sagte 12/6/3 → nachprüfen!). 30 Fakten; Simulator 768 Folgen (2^8×3) in 0,3 s, Test < 60 s.
- Erzaehler: Baustein-Kennungen (runde.N.start, finale.pfad.ende, rueckblende.pfad); S-1 nur Detektivwissen vor Finale.
- Tatmatrix/PersonZustand/Abschnitt.posAm(t) → Animationsgrundlage. RaumGraph.weg A*, sichtlinie, lichtAm, karte→MapDef.
- Abstimmung Mordakte: „nachvollziehbar statt verdecktem Losentscheid“ (endings.dart) → Würfel offen sichtbar. E-025: verdeckte Qualität/Stimmenzahl.
- Burgstadt Schartenfels = kooperativer Krimi Ich-Perspektive (DET + R01–R20, Täterin R03), FallZustand/FallBots/spieleDurch/Figur.auftrag (Vorbild Entscheidung→Auftrag→Bewegung), BurgstadtRaum wahlFrist 90 s.
- Weitere RNGs: Zufall (xorshift32, statischer Zähler aufrufe → Layout-Prüfsumme!), Lcg (pixel_engine werkzeug), _Zufall (nicht web-sicher), FeinZufall, dart:math (nur Optik). NIE für Spiellogik außer Rng.
- Namensgleichheit Kanon/Spiel/Ort/Abschnitt in mordakte_core und burgstadt_* → eindeutige Namen.
- LocalSession ohne clockSeed → Solo nicht reproduzierbar (Engine).
- commit_gruen.sh pusht fest auf nachtlauf/burgstadt mit git add -A → NICHT verwenden.
- Finalisierung ändert gerade content/party/schlosskeller/* (entscheidungen.json, Texte), entscheidungen.schema.json (luege), simulator.dart, textpruefer.dart; neue Tests dossier/erzaehler/spoiler.

# Wiederverwertung FEINKORN/HD/Nachtlauf (Bericht)
- FEINKORN Physikwelt (kein Körper-gegen-Körper, Kontakt nur Boden/Kasten), Starrkoerper (Kontaktpunkte jede 2. Randblockmitte – Ecken fehlen evtl.; matrix() → Oberseite), Partikel, Prüfsumme (web-sicher), Material (14) – direkt/anpassen; KEINE Physik-Unit-Tests.
- IsoAnsicht == Iso (32/16/40).
- Würfel bei Standardzoom < 1 px → eigene Würfelbühne/Overlay mit größerer Skala.
- Klang: FEINKORN nur Enum; tool/ton (klangwerk, geraeusche, erzeuge; 44 WAVs 16bit mono 22050 Hz) + Tonausgabe (burgstadt_spiel ton.dart, lib/burgstadt/ton_audioplayers.dart, Pool 6); assets/burgstadt/ton/ angemeldet; Iso-Spiel hat keinen Ton. tool/ton braucht pub get (sonst 46 Analysefehler).
- Burgstadt HD: Phase 1/9, 49/306 Pakete, HZ 0/14; auf main bis 96e9e5b (Merge 0304eb2); 8 Commits nur auf HD-Branch; Formen stuhl/bank/tisch (Mesh, nur Maße/Varianten); blasen_layout.dart (nur HD-Branch, 1000 Lagen 0 Überlappung); hashTeil (werkzeug.dart, VM=Web Golden).
- Nachtlauf: Burgstadt Schartenfels 160 Gebäude, 59 Innenräume, 66 Figuren, WLAN; 75 Commits; 53/53 Aufträge; Abnahme 13/14 (Z-12 offen, 27 Runden ohne Konvergenz). ~10 h.
- Lehren BEWÄHRT: ein Abnahmewerkzeug als einzige Quelle für ZIEL ERREICHT; Commits grün mit Pfadliste (hd_commit.sh-Muster); Maßstäbe im Code statt Sichtprüfer; Sichtprüfer eichen (Eichbilder mit bekannten Fehlern); Leistung in Thread-CPU-Zeit (CLOCK_THREAD_CPUTIME_ID via ffi); Paketvertrag Haiku (≤400 Zeilen + Test + Probe, Endmarke, max 2 Reparaturen dann Opus); Rollenbriefings „3 häufigste Fehler“; Verbot von Sitzungs-/Agenten-/Remote-Werkzeugen für Haiku (Sichtprüfer hatten list_sessions/interrupt_session aufgerufen, hd/FEHLER.md); Variantenregel ★ (2–3 Haiku parallel an Schlüsselstellen); Abbruchregel Prüfschleifen (E40); PRÜFPUNKT/STATUS/stündliches NACHTPROTOKOLL/MORGENBERICHT 07:00; früh Bilder zeigen; Worktrees vor Löschen abgleichen; Kürzungsleiter statt stilles Absenken.
- Lehren FEHLER: E28 `|| echo` verschluckte rote Tests; E31 Abnahmewerkzeug endete still (asFuture an beendetem Strom); E52 main nach nur „schnell“ gepusht + Build-Cache (.dart_tool/flutter_build leeren, Manifeste prüfen); E36 Messung unter Parallellast; Agenten schreiben in Messbaum; Handkorrekturen verschieben Fehler; Z-12 27 Runden ohne Konvergenz → Gestaltungsfragen früh an Nutzer; geschätzte Zeiten im Log (echte Uhrzeit TZ=Europe/Berlin date); L-01 Backticks in Heredocs; Analyse rot ohne pub get; Wasm doppelt so schnell, nicht übernommen; große Pläne von Richtungswechseln überholt.
- Zeiten: Schnelllauf ~280 s (heute gemessen 3m49 inkl. Worktree); flutter analyze 5–9 s; HD 15–20 Haiku-Pakete/h bei 4 Plätzen; Container 4 Kerne, ~16 GB, keine GPU.
- Empfehlung Durchstich zuerst: 1 Entscheidung + 1 sichtbare Aktion + 1 Würfelwurf, Vorher/Nachher-Bild an Nutzer, bevor Haiku-Wellen breit ausrollen.
