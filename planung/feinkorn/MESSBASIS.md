# MESSBASIS · FEINKORN · Entwurf

Auftrag K0-LEISTUNGSPRUEFER-01 · Bauphase K0 · Version 1 · Stand 2026-10-09 (Messungen 17:46 bis 18:13 UTC)

Basis: Worktree /home/user/feinkorn, Branch kern-feinkorn, Basis-Commit e7e4219 (= origin/main laut Auftrag).

Hinweis zum HEAD: Während der Messung setzte eine fremde Seite um 18:14:42 UTC den Commit 6e37e1b „FEINKORN K0: Messbasis, Prototypen und Gesamtplan“ auf kern-feinkorn. HEAD ist seither 6e37e1b. Dieser Commit enthält ausschließlich neue FEINKORN-Dateien (42 Zugänge). `git diff --name-status e7e4219 HEAD` zeigt keine geänderte und keine gelöschte Datei. Die getrackten Basisdateien sind also unverändert, und die Aussagen dieses Dokuments gelten für e7e4219. Die Messdaten stammen aus der Zeit vor 18:14:42 UTC.

Nicht Teil der Messbasis (neue FEINKORN-Dateien, seit 6e37e1b getrackt): packages/pixel_engine/lib/src/feinkorn/, packages/pixel_engine/lib/feinkorn.dart, packages/pixel_engine/bin/feinkorn_k0*.dart, packages/pixel_engine/test/feinkorn_*_test.dart, lib/game/dev/feinkorn_k0_main.dart, tool/feinkorn/, planung/feinkorn/, build/web_feinkorn_k0.

Rohprotokolle (nicht im Repo): /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/feinkorn/mess/ (Ordner teststand/ mit allen Läufen).

Zahlen in diesem Dokument sind unverändert übernommen. Größen stehen in Bytes und in MiB (Bytes / 1.048.576), nicht gerundet, außer wo es ausdrücklich dasteht.

---

## 1. Umgebung

| Merkmal | Wert | Messweg |
|---|---|---|
| Rechner | Firecracker-VM, Linux 6.18.44-fc-v80 | `uname -r` |
| CPU | Intel(R) Xeon(R) Processor @ 2.10GHz, GenuineIntel, 2100,000 MHz | `grep -E "model name\|cpu MHz" /proc/cpuinfo` |
| Kerne | 4 logische CPUs (processor 0 bis 3); cpuinfo meldet cpu cores 4 und siblings 4. Ob es 4 physische Kerne oder Hyperthreads sind, ist daraus nicht sicher abzulesen. | `nproc`, `/proc/cpuinfo` |
| Speicher | MemTotal 16.480.952 kB; MemAvailable 15.497.600 kB (bei Start) | `grep -E "MemTotal\|MemAvailable" /proc/meminfo` |
| GPU | keine: /dev/dri fehlt | `ls /dev/dri` |
| Flutter | 3.47.6 (channel stable); entspricht der Pinnung in build.sh | `/opt/flutter/bin/flutter --version` |
| Dart | 3.13.5 (stable), mit dem Flutter-SDK ausgeliefert | `/opt/flutter/bin/dart --version` |
| Benutzer | root (Flutter meldet bei jedem Lauf eine Warnung) | Ausgabe der Läufe |
| Android | kein Android-SDK (adb nicht gefunden) | `which adb` |
| iOS | kein Xcode (xcodebuild nicht gefunden, Linux-Host) | `which xcodebuild` |
| Geräte | keine Testgeräte verfügbar | aus dem fehlenden adb abgeleitet |

Lastmittel (1 Minute) vor den einzelnen Läufen: 0,23 bis 1,96. Die höheren Werte stammen aus meinen eigenen vorherigen Läufen (direkt hintereinander gestartet); siehe Abschnitt 8.

## 2. Darstellung heute

Die vollständige Bestandsaufnahme aller Bilder und Grafiken steht in planung/feinkorn/BESTAND-BILDER.md (Auftrag K0-KUNDSCHAFTER-01, Stand 2026-10-09). Aus deren Kurzbefund übernommen, nicht von mir geprüft:

- Der Schlosskeller ist im Produktpfad nicht erreichbar. Er entsteht nur in der Dev-Vorschau „?party=schlosskeller“ (lib/game/dev/preview_main.dart:59–69).
- Im Renderer gibt es 34 Requisiten-Arten; der Schlosskeller benutzt 11 davon.
- Figuren: 21 (Opfer und 20 Verdächtige).

## 3. Teststand

### 3.1 Analyse

Befehl: `cd /home/user/feinkorn && /opt/flutter/bin/flutter analyze`

| Lauf | Beginn (UTC) | Wandzeit | Befunde | Exit |
|---|---|---|---|---|
| 1 | 18:06:36 | 9,05 s | 46 (alle error) | 1 |
| 2 | 18:09:13 | 4,84 s | 46 (alle error) | 1 |
| 3 | 18:10:06 | 4,66 s | 46 (alle error) | 1 |

Die Wandzeit von Lauf 1 ist höher, weil der Analyzer kalt startet. Alle 46 Befunde liegen in **tool/ton/test/ton_test.dart** (getrackt, also Teil der Basis). Verteilung: 39 undefined_function, 5 undefined_identifier, 1 uri_does_not_exist (package:test/test.dart), 1 creation_with_non_type (Timeout). In den FEINKORN-Pfaden gibt es keinen Befund.

Ursache (beobachtet, nicht behoben): tool/ton hat ein eigenes pubspec.yaml mit der dev-Abhängigkeit test. Das Wurzelpaket löst package:test nicht auf, und tool/ton hat kein .dart_tool. Die analysis_options.yaml im Wurzelordner schließt tool/ton nicht aus.

Die Analyse ist im Basisstand also rot.

### 3.2 Paket-Tests

Befehl je Paket: `cd /home/user/feinkorn/packages/<paket> && /opt/flutter/bin/dart test -r compact`

| Paket | bestanden | übersprungen | fehlgeschlagen | Wandzeit Lauf 1 | Lauf 2 | Lauf 3 |
|---|---|---|---|---|---|---|
| burgstadt_core | 266 | 0 | 0 | 14,68 s | 7,48 s | 7,50 s |
| burgstadt_spiel | 50 | 0 | 0 | 26,45 s | 17,52 s | 17,02 s |
| mordakte_core | 214 | 1 | 0 | 19,67 s | 11,25 s | 10,87 s |
| pixel_engine (nur getrackte Testdateien, siehe 3.3) | 282 | 0 | 0 | 16,97 s | 10,04 s | 9,72 s bzw. 9,38 s (Wiederholung B1 und B2, siehe unten) |
| room_host | 5 | 0 | 0 | 8,65 s | 1,48 s | 1,45 s |
| **Summe** | **817** | **1** | **0** | | | |

Die Spalte „Lauf 3“ für pixel_engine ist in der Tabelle durch die Wiederholung B1 und B2 ersetzt, weil Lauf 3 den Arbeitsstand mit neuen Testdateien lief (siehe 3.3).

Übersprungener Test: packages/mordakte_core/test/party/figuren_abgleich_test.dart:101, `markTestSkipped('Rohchat nicht lokal vorhanden (bleibt außerhalb des Repos)')`. Der Test hängt an Quellmaterial, das im Container nicht liegt.

### 3.3 Arbeitsstand während der Läufe

Während der Läufe kamen im Arbeitsstand zwei neue Dateien dazu, die nicht von mir stammen: packages/pixel_engine/test/feinkorn_daten_test.dart (Änderungszeit 18:10:24 UTC) und packages/pixel_engine/test/feinkorn_trennung_test.dart (18:10:39 UTC). Lauf 2 von pixel_engine (18:09:55 bis 18:10:05 UTC) lief noch ohne sie mit 282 bestanden; erst Lauf 3 (18:10:46 UTC) fand sie.

- Lauf 3 von pixel_engine lief mit diesen Dateien: 317 bestanden, 1 fehlgeschlagen, Exit 1. Der Fehler: feinkorn_daten_test.dart, „Blockkoerper: leerer Körper BEFUND-Kandidat: leer kostet keinen Block-Speicher“, Expected 0, Actual 8. Dieser Lauf gehört nicht zur Messbasis.
- Basis-Wiederholung nur mit den 10 getrackten Testdateien (`git ls-files 'test/*_test.dart'`, Befehl `dart test -r compact <Dateien>`): B1 282 bestanden, 0 fehlgeschlagen, 9,72 s; B2 282 bestanden, 0 fehlgeschlagen, 9,38 s.

### 3.4 Nicht ausgeführt

- tool/ton/test/ton_test.dart: nicht ausgeführt. Der Auftrag nennt nur packages/. Das Paket hat kein .dart_tool, und der Test setzt einen vorherigen Lauf von erzeuge.dart voraus, der Dateien unter assets/ schreibt.
- tool/e2e und tool/browser/geraete.js: nicht ausgeführt (Browser-Läufe sind im Auftrag ausgeschlossen).
- tool/pruefen.sh, tool/alle_tests.sh, tool/abnahme.dart, tool/hd_abnahme.dart, tool/layout_pruefsumme.dart, tool/mass5a.py, tool/quellabgleich.py, tool/secret_scan.sh, tool/commit_gruen.sh, tool/hd_commit.sh, tool/hd_migbeleg.sh, tool/lib/*, tool/ton/erzeuge.dart: nicht ausgeführt (Auftrag).

### 3.5 Prüfskripte unter tool/

Alle 30 Dateien unter tool/ (`find tool -type f`). Der Zweck stammt aus dem Kopfkommentar der Datei. Ausgeführt wurde nur tool/feinkorn/bestand.dart (Abschnitt 7).

| Datei | Art | Zweck laut Kopfkommentar |
|---|---|---|
| tool/abnahme.dart | Prüfskript | Abnahme Z-01 bis Z-14 (Nachtlauf „Burgstadt Schartenfels“): rechnet jedes Kriterium aus ABNAHME.md nach |
| tool/alle_tests.sh | Prüfskript | Gesamt-Testlauf aller Ebenen des Nachtlaufs; bricht beim ersten Fehler ab; optional Aufruf mit „schnell“ |
| tool/browser/geraete.js | Prüfskript | Ebene 9, Geräte: Web-Build auf drei Geräteprofilen (Playwright/Chromium), prüft Start, Netzabrufe, Bildrate, Fotos, Tastatur und Touch |
| tool/commit_gruen.sh | Werkzeug | Commit nur bei grünem Schnelltest |
| tool/e2e/foto.mjs | Prüfskript | Bildschirmfotos der Partymodus-Vorschau; prüft Konsolenfehler und Netzaufrufe außerhalb von localhost |
| tool/e2e/server.mjs | Werkzeug | kleiner statischer Server für die gebaute Web-Fassung (nur localhost), von foto.mjs genutzt |
| tool/e2e/package.json | Konfiguration | Paketdefinition für tool/e2e |
| tool/e2e/package-lock.json | Konfiguration | Sperrdatei zu tool/e2e/package.json |
| tool/e2e/.gitignore | Konfiguration | ignoriert node_modules/ und fotos/ |
| tool/feinkorn/bestand.dart | Prüfskript | FEINKORN-Bestandsprüfung: hält den Bestand als Textbild fest und vergleicht ihn mit der Messbasis (ausgeführt, Abschnitt 7) |
| tool/feinkorn/messen.mjs | Prüfskript | FEINKORN-Leistungsmessung im Browser: Ladezeit, Bildintervalle, Rechenlast und JS-Speicher je Geräteklasse über CPU-Drosselung (nicht ausgeführt) |
| tool/hd_abnahme.dart | Prüfskript | Burgstadt HD, Abnahme HZ-01 bis HZ-14 (Zielformel); meldet „HD-ZIEL ERREICHT“ nur, wenn alle 14 Kriterien erfüllt sind |
| tool/hd_commit.sh | Werkzeug | Burgstadt HD: Commit nur bei grünem Schnelllauf, unveränderten Spieltexten und gleicher Layout-Prüfsumme; nimmt nur genannte Pfade auf |
| tool/hd_migbeleg.sh | Prüfskript | Burgstadt HD, Migrationsbeleg (E-035): rendert einen festen Bildsatz und vergleicht zwei Bildsätze byteweise |
| tool/layout_pruefsumme.dart | Prüfskript | Layout-Prüfsumme für Burgstadt HD: baut die Welt wie das Spiel und hasht die kanonische Form (--pruefe oder --schreibe) |
| tool/lib/chat_passagen.py | Prüfskript | sucht längere wörtliche Passagen aus dem Rohchat in Dateien, die ins Repo gehen; Exit 1 bei Treffern |
| tool/lib/figurenstand.dart | Werkzeug | Figurenstand-Hash (E-039) für hd_abnahme.dart |
| tool/mass5a.py | Werkzeug | Bild-Näherung zum Maßstab 5a (E40): sucht Figurenpaare in einem Aufstellungsbild; Hilfsskript, kein Test |
| tool/pruefen.sh | Prüfskript | Gesamtprüfung des Repos (schnell, alles, e2e); Secret-Scan zum Schluss |
| tool/quellabgleich.py | Werkzeug | erzeugt content/party/schlosskeller/quellabgleich.json aus dem lokalen Rohchat (F-02); läuft nur lokal |
| tool/secret_scan.sh | Prüfskript | Secret-Scan vor jedem Push: Rohchat nicht im Verlauf, keine Chat-Kopfzeilen, keine Schlüsselmuster, keine .env, keine langen Passagen |
| tool/ton/erzeuge.dart | Werkzeug | erzeugt alle Klänge und Musikstücke nach assets/burgstadt/ton (schreibt Dateien, nicht ausgeführt) |
| tool/ton/test/ton_test.dart | Prüfskript | Abnahmetests für die Klangdateien (A-603a, Punkt 9); setzt einen vorherigen Lauf von erzeuge.dart voraus (nicht ausgeführt, siehe 3.4) |
| tool/ton/geraeusche.dart | Werkzeug | Geräusche und Alltagsklänge (Synthese-Funktionen für erzeuge.dart) |
| tool/ton/klangwerk.dart | Werkzeug | Synthese-Bausteine für alle Klänge |
| tool/ton/musik.dart | Werkzeug | drei eigene Musikstücke als Schleifen |
| tool/ton/umgebung.dart | Werkzeug | Umgebungsklänge und Tierrufe als periodische Schleifen |
| tool/ton/pubspec.yaml | Konfiguration | Paketdefinition für tool/ton (ton_werkzeug) |
| tool/ton/pubspec.lock | Konfiguration | Sperrdatei zu tool/ton/pubspec.yaml |
| tool/ton/analysis_options.yaml | Konfiguration | Analyse-Einstellungen für tool/ton (include lints/recommended) |

## 4. Build und CI

- .github/: nicht vorhanden (`ls -la .github` meldet „No such file or directory“). Im Repo gibt es also keine CI-Pipeline.
- Deploy-Dateien im Wurzelordner:

| Datei | Inhalt laut Kopf bzw. Konfiguration |
|---|---|
| netlify.toml | publish = build/web; command = `bash build.sh`; Weiterleitung /* auf /index.html (200) |
| vercel.json | buildCommand = `bash build.sh`; outputDirectory = build/web; rewrite /(.*) auf /index.html |
| railway.toml | Mordakte-Server; Dockerfile server/Dockerfile (vorhanden); Healthcheck /health; numReplicas = 1, weil Räume im Speicher liegen |
| build.sh | siehe unten |

- build.sh (Kopf gelesen, nicht ausgeführt): Flutter ist auf 3.47.6 gepinnt. Fehlt die SDK unter $HOME/flutter-3.47.6, lädt das Skript sie von storage.googleapis.com. Danach `flutter config --enable-web`, `flutter pub get` und `flutter build web --release --no-web-resources-cdn`. Optional wird MORDAKTE_SERVER per --dart-define übergeben.
- Die lokale Flutter-Version (3.47.6) stimmt mit der Pinnung überein.
- Gesamtprüfung lokal über tool/pruefen.sh (nicht ausgeführt, siehe 3.4).

## 5. Größe

Befehl je Zeile: `du -sb <Pfad>` (scheinbare Größe in Bytes).

| Pfad | Bytes | MiB | MB (dezimal) | Angabe Orchestrator |
|---|---|---|---|---|
| build/web_app_basis (gesamt) | 59.283.426 | 56,54 | 59,28 | 56 MB |
| build/web_app_basis/main.dart.js | 4.397.223 | 4,19 | 4,40 | 4,2 MB |
| build/web_app_basis/canvaskit/ | 37.851.412 | 36,10 | 37,85 | 37 MB |
| build/web_app_basis/assets/ | 16.699.102 | 15,93 | 16,70 | 17 MB |
| build/web_app_basis/assets/assets/ | 12.801.318 | 12,21 | 12,80 | 13 MB (Burgstadt-Klänge) |
| build/web_app_basis/icons/ | 304.430 | 0,29 | 0,30 | nicht angegeben |
| übrige Wurzeldateien | 31.259 | 0,03 | 0,03 | nicht angegeben |

Prüfsumme: 4.397.223 + 37.851.412 + 16.699.102 + 304.430 + 31.259 = 59.283.426 Bytes, also gleich der Gesamtgröße.

Der Messbuild der Browser-Messung ist ein anderer Build:

| Pfad | Bytes | MiB |
|---|---|---|
| build/web_vorschau_basis (gesamt) | 56.956.256 | 54,32 |
| build/web_vorschau_basis/main.dart.js | 2.091.445 | 1,99 |
| build/web_vorschau_basis/canvaskit/ | 37.851.412 | 36,10 |
| build/web_vorschau_basis/assets/ | 16.677.710 | 15,91 |

Build-IDs (aus .last_build_id): web_app_basis 2097f6a62148dbd9496146477c8ba068; web_vorschau_basis 094dafc3488b46413a5cf2de026fceb7. Die beiden Builds sind also verschieden. Die main.dart.js unterscheidet sich um rund 2,3 MB. Die Orchestrator-Angaben stimmen nicht durchgehend mit einer Einheit überein (siehe Abschnitt 9).

## 6. Browser-Messung

Quelle: basis.json im Messordner (Dateizeit 17:48 UTC) und das Protokoll basis.log. Build laut Datei: web_vorschau_basis. Dauer je Phase laut Datei: 8 s. Fremde Netzaufrufe: 0. Konsolenfehler: 0. Eine Kopie derselben Datei liegt identisch in planung/feinkorn/messbasis/browser_vorschau.json (cmp: identisch).

Messweg laut Auftrag: tool/feinkorn/messen.mjs (Headless-Chromium ohne GPU, Software-WebGL; Drosselung hoch 1×, mittel 4×, einfach 6× laut Kopf des Skripts). Ich habe die Messung nicht neu ausgeführt; sie ist eine einzige Messung je Zeile.

Ladezeit, ruhige Phase („ruhig“):

| Klasse | Drossel | Ansicht | Ladezeit ms | Bilder | Bilder/s | Median ms | p99 ms | Rechenlast | Skriptlast | Heap MB |
|---|---|---|---|---|---|---|---|---|---|---|
| hoch | 1 | buffetsaal | 582 | 52 | 6,4 | 150 | 200 | 0,999 | 0,991 | 22,1 |
| hoch | 1 | uebersicht | 598 | 56 | 7 | 150 | 183,3 | 0,999 | 0,992 | 18,4 |
| mittel | 4 | buffetsaal | 1879 | 24 | 3 | 300 | 416,6 | 0,998 | 0,982 | 23,6 |
| mittel | 4 | uebersicht | 1947 | 24 | 3 | 316,7 | 416,6 | 1 | 0,985 | 20,8 |
| einfach | 6 | buffetsaal | 2872 | 17 | 2,1 | 450 | 533,4 | 0,999 | 0,981 | 17,7 |
| einfach | 6 | uebersicht | 2867 | 18 | 2,2 | 416,6 | 499,9 | 1 | 0,982 | 23,5 |

Bewegte Phase („bewegt“, Pfeiltaste gehalten):

| Klasse | Drossel | Ansicht | Bilder | Bilder/s | Median ms | p99 ms | Rechenlast | Skriptlast | Heap MB |
|---|---|---|---|---|---|---|---|---|---|
| hoch | 1 | buffetsaal | 68 | 8,4 | 116,6 | 183,3 | 1 | 0,99 | 20,1 |
| hoch | 1 | uebersicht | 59 | 7,4 | 133,3 | 166,7 | 0,999 | 0,992 | 22,9 |
| mittel | 4 | buffetsaal | 33 | 4 | 249,9 | 300 | 0,998 | 0,979 | 23 |
| mittel | 4 | uebersicht | 27 | 3,4 | 283,3 | 333,3 | 1 | 0,984 | 24,5 |
| einfach | 6 | buffetsaal | 23 | 2,8 | 350 | 416,7 | 0,999 | 0,977 | 16,3 |
| einfach | 6 | uebersicht | 19 | 2,4 | 416,7 | 466,6 | 0,999 | 0,979 | 26,1 |

Fotos der Messung (6 PNG, basis_*.png) liegen im Rohprotokollordner, nicht im Repo.

Vorbehalte zu diesen Zahlen:
- Eine Messung je Zeile, keine Wiederholung. Die Messdauer ist 8 s je Phase, also kurz.
- Die Rechenlast liegt in allen 12 Phasen zwischen 0,998 und 1. Die Metrik ist damit nahe der Sättigung; ihre Aussagekraft ist nicht geklärt.
- Bilder/s stimmt nicht überall mit Bilder/8 s überein (z. B. hoch buffetsaal ruhig: 52 Bilder, angegeben 6,4 Bilder/s, rechnerisch 6,5). Das Messfenster steht nicht in der Datei. Die Werte sind so übernommen, wie sie geliefert wurden.
- Messung ist auf der VM ohne GPU gelaufen (Software-WebGL), nicht auf Geräten.

## 7. Bestandsbild

Datei: planung/feinkorn/messbasis/bestand.txt (152 Zeilen, 8.594 Bytes).

Befehle (aus /home/user/feinkorn):
- `/opt/flutter/bin/dart run tool/feinkorn/bestand.dart` schreibt 152 Zeilen auf die Standardausgabe; die Ausgabe ist mit der Datei identisch (cmp).
- `/opt/flutter/bin/dart run tool/feinkorn/bestand.dart --schreibe planung/feinkorn/messbasis/bestand.txt` meldet „BESTAND geschrieben · 152 Zeilen“.
- `/opt/flutter/bin/dart run tool/feinkorn/bestand.dart --vergleiche planung/feinkorn/messbasis/bestand.txt` meldet „BESTANDSPRÜFUNG · GLEICH · entfernt 0 · neu 0“, Exit 0.

Bereiche nach Zeilen:

| Zeilen | Bereich | Einträge |
|---|---|---|
| 1–16 | Abhängigkeiten (abhaengigkeit) | 16 |
| 17 | Dev-Abhängigkeiten | 1 |
| 18 | Version | 1 |
| 19 | Name | 1 |
| 20–116 | aufgelöste Pakete (pubspec.lock) | 97 |
| 117–119 | Pfad-Pakete | 3 |
| 120–127 | Android: Kennung (2), Signatur (1), Berechtigungen (4), Name (1) | 8 |
| 128–133 | iOS: Kennung (2), Signatur (1), Berechtigung (1), Name (2) | 6 |
| 134–149 | Build-Dateien (Prüfsummen) | 16 |
| 150–152 | Netzziele im Code | 3 |

## 8. Grenzen der Umgebung

- Kein Android-SDK, kein Xcode, keine Geräte. Alle Messungen laufen auf der Linux-VM bzw. im Headless-Browser. Aussagen über echte Handys sind damit nicht gedeckt.
- Akku und Wärme sind nicht messbar (kein Sensor in der VM).
- Keine GPU (kein /dev/dri). Die Browser-Messung läuft mit Software-WebGL. Die CPU-Drosselung 1×, 4× und 6× ist eine Näherung an Geräteklassen, kein Geräteprofil.
- Vier logische CPUs. Die Anzahl physischer Kerne ist nicht sicher bekannt.
- Fremde Last: Der Arbeitsstand wird von anderen Prozessen geteilt. Während der Läufe kamen neue Testdateien dazu (siehe 3.3). Um 18:13:41 UTC lief ein fremder dartvm-Prozess mit 96 % CPU, nicht von mir. Für die Browser-Messung (17:46 bis 17:48 UTC) gibt es keine Lastdaten; ob dort parallel schwere Läufe liefen, lässt sich aus den vorliegenden Dateien nicht belegen.
- Wiederholungen: Analyse dreimal, Paket-Tests dreimal (pixel_engine zusätzlich zweimal nur mit getrackten Dateien), Browser-Messung einmal.
- Das Rohchat ist nicht lokal. Ein Test in mordakte_core ist deshalb übersprungen.
- Die Läufe laufen als root; Flutter meldet das bei jedem Aufruf.

## 9. Offene Fragen

1. Welcher Build ist die Messbasis der App-Größe? web_app_basis (59.283.426 Bytes, main.dart.js 4.397.223 Bytes) oder web_vorschau_basis (56.956.256 Bytes, main.dart.js 2.091.445 Bytes), mit dem die Browser-Messung lief? Die Größenangaben des Auftrags beziehen sich auf web_app_basis.
2. Einheiten der Orchestrator-Angaben sind gemischt. Gesamt (56 MB, gemessen 56,54 MiB) und main.dart.js (4,2 MB, gemessen 4,19 MiB) entsprechen MiB. assets (17 MB, gemessen 16,70 MB dezimal) und assets/assets (13 MB, gemessen 12,80 MB dezimal) entsprechen dezimal gerundet. canvaskit (37 MB, gemessen 37,85 MB dezimal oder 36,10 MiB) passt zu keiner Einheit sauber. Welche Einheit gilt?
3. Analyse im Basisstand rot: 46 Befunde in tool/ton/test/ton_test.dart. Soll tool/ton vom Wurzelpaket ausgeschlossen werden, oder ist das eine Aufgabe außerhalb der Messbasis? Die Messbasis hält den Befund fest.
4. tool/ton/test/ton_test.dart wurde nicht ausgeführt. Soll es in der Messbasis einen eigenen Lauf bekommen, mit vorherigem erzeuge.dart-Lauf? Dafür müsste erzeuge.dart Assets schreiben.
5. Browser-Messung: eine Messung, 8 s je Phase, Rechenlast nahe 1, Messfenster unklar. Reicht das als Messbasis, oder ist eine Wiederholung nötig? Browser-Läufe sind in diesem Auftrag ausgeschlossen.
6. Fremde Dateien im Messordner: browser_vorschau.json (identisch mit basis.json) und k0_darstellungswege.json (Build web_feinkorn_k0, nicht Basis). Beide sind im Commit 6e37e1b enthalten, zusammen mit bestand.txt. Wer pflegt sie? Die Messung k0_wege.json im Rohprotokollordner ist ebenfalls nicht übernommen, weil sie FEINKORN-Prototypen misst.
6a. Der Commit 6e37e1b (18:14:42 UTC) stammt nicht von mir. Ob seine Fassungen von bestand.txt und browser_vorschau.json die endgültigen Messbasis-Dateien sind, ist hier nicht geprüft. Die Fassung von bestand.txt im Commit ist identisch mit der Datei im Arbeitsstand (`git diff` leer), und `--vergleiche` meldet GLEICH.
7. Fremder FEINKORN-Test in pixel_engine ist rot: feinkorn_daten_test.dart, „leer kostet keinen Block-Speicher“, Expected 0, Actual 8. Die Zuständigkeit liegt beim Entwickler der Datei.
8. Stand des Kanons auf origin (Master-Prompt, Abschnitt 8) ist nicht Teil dieses Auftrags und nicht geprüft.
9. Wärme und Akku sind laut Master-Prompt „soweit messbar“. Hier nicht messbar.
