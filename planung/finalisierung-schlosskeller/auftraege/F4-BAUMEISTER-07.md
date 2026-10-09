F4-BAUMEISTER-07 · Baumeister · Bauphase F4 · Kanon v1.0 · Schwierigkeit 3

## Baumeister
- **Aufgabe:** setzt einen Baustein auf der Schnittstelle des Orchestrators um (Dart/Flutter, Skripte), nur in den eigenen Dateien.
- **Gute Arbeit:** hält die Schnittstelle exakt ein, schreibt kleinen, lesbaren Code im Stil der Umgebung, lässt Analyse und Tests grün laufen und belegt das mit der Ausgabe.
- **Häufigste Fehler:** 1) fremde Dateien anfassen oder Schnittstellen „verbessern“, 2) Story-Text in Code schreiben statt Textschlüssel zu nutzen, 3) „sollte gehen“ ohne gelaufenen Test.

AUFGABE IN EINEM SATZ: Baue das E2E-Gerüst, das jeden Pfad mit jedem Ende und den Personenzahlen 4, 7, 12, 16 und 20 automatisch vom Titel bis zum Ende spielt, prüft und mit Fotos belegt (F-12, F-16).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

EIGENE DATEIEN: tool/e2e/e2e.mjs, tool/e2e/laeufe.mjs, tool/e2e/README.md

WERKZEUG: Du arbeitest direkt im Repo /home/user/werwolf_digital_flutter (Stand Commit 28e90a9). Node 22 und Playwright 1.56.1 liegen in tool/e2e/node_modules; Chromium unter /opt/pw-browsers/chromium-1194/chrome-linux/chrome (kein Browser-Download, kein npm install). Der Web-Build liegt in build/web (der Orchestrator baut ihn; du baust NICHT selbst). Vorhanden und als Vorbild zu lesen: tool/e2e/server.mjs (statischer Server, nur localhost), tool/e2e/probe.mjs (ein Lauf mit Fotos), tool/e2e/package.json ("test": "node e2e.mjs"), lib/party/skript.dart (Entwickler-Einstieg und Skript), lib/party/sitzung.dart (Phasen).
ENTWICKLER-EINSTIEG: http://127.0.0.1:<port>/?party=schlosskeller&pfad=<ahmet|fatma|olli|can>&n=<4..20>&skript=<entscheidungen>,<gruppe>,<anklage>&takt=<ms>&zeitraffer=<s/s>&fotos=<0|1>[&semantik=1]
- Das Spiel meldet in der Browser-Konsole: `PARTY geladen fall=…`, bei jedem Schritt `PARTY phase=<phase> runde=<r>[ entscheidung=<id>]`, an Fotostellen `PARTY foto=<name>`, am Ende `PARTY fertig pfad=<p> ende=<ende_id> punkte=<n> rollen=<n>`, bei Fehlern `PARTY fehler …`.
- Mit fotos=1 wartet das Spiel an jeder Fotostelle mindestens 1,2 s, mit fotos=0 nur takt.
- semantik=1 schaltet die Bedienhilfen ein: Texte des Bildschirms stehen dann im DOM (flt-semantics-host und aria-label).
- Skript je Ende: ende_meister = best,a,richtig · ende_teilerfolg = schlecht,a,richtig · ende_justizirrtum = best,a,falsch · ende_eskalation = schlecht,b,falsch.

GRENZEN: Ändere NUR deine eigenen Dateien (Liste oben); lege keine weiteren an. Keine anderen Dateien, kein Kanon, kein pubspec, kein `flutter pub get`, keine neuen Abhängigkeiten, kein Netz. Keine Git-Befehle außer git status und git diff (nur lesen). Nichts außerhalb des Repos schreiben (außer System-Temp). Andere Agenten arbeiten gleichzeitig im selben Repo an anderen Dateien: fasse sie nicht an; sind deren Dateien gerade unfertig oder rot, ist das nicht dein Befund – prüfe nur deine eigenen Dateien. Zeigt „Waiting for another flutter command to release the startup lock“, einfach warten. Spoilerschutz (E-008): Vor dem Finale verrät dein Bildschirm nie, wer der Täter ist – außer in der verdeckten Ansicht der Täterrolle selbst. Nie eine Stimmenzahl, nie die Qualität eines Hinweises anzeigen. Kein Netz außer 127.0.0.1. Fotos und Berichte nur unter tool/e2e/fotos/ (ist gitignored).

ARBEITSSCHRITTE:
1. laeufe.mjs: exportiere die Liste aller 80 Läufe {pfad, ende, n, skript, fotos} für pfad × ende × n ∈ {4, 7, 12, 16, 20}; fotos = (n === 7). Dazu 4 Semantik-Läufe (je Pfad, ende_meister, n = 7, semantik=1, fotos=0).
2. e2e.mjs: startet einen Server (starteServer aus server.mjs, build/web), einen Chromium (headless) und arbeitet die Läufe mit höchstens 2 gleichzeitigen Seiten ab (je Seite ein eigener Browser-Kontext, Ansicht 1280×800). Parameter: Läufe mit Fotos takt=400&zeitraffer=60&fotos=1, ohne Fotos takt=40&zeitraffer=240&fotos=0. Zeitlimit je Lauf 6 Minuten mit, 3 Minuten ohne Fotos.
3. Je Lauf prüfen: (a) `PARTY fertig` kommt; (b) ende und pfad stimmen mit dem Lauf überein; (c) die Phasenfolge aus den `PARTY phase=`-Zeilen ist titel? → einrichtung → rollen → intro → 3 × (gespraeche → entscheidungen → gruppenwahl → bonus → resuemee) → anklage → finale → aufloesung → ende (titel und einrichtung erscheinen als Fotostellen; prüfe die Reihenfolge der übrigen); (d) 0 Konsolenfehler (type error), 0 pageerror, 0 `PARTY fehler`; (e) 0 Anfragen an andere Hosts als 127.0.0.1/localhost (data: und blob: sind erlaubt).
4. Fotos: bei Läufen mit fotos=1 an jeder `PARTY foto=`-Meldung nach 200 ms ein Bildschirmfoto nach tool/e2e/fotos/e2e/<pfad>_<ende>_n<n>/<nnn>_<name>.png (Fotos nacheinander, nie zwei gleichzeitig je Seite).
5. Semantik-Läufe zusätzlich: an den Fotostellen gespraeche_r1, gespraeche_r2, gespraeche_r3 den Bildschirmtext lesen (document.querySelector('flt-semantics-host')?.innerText plus alle aria-label-Werte) und prüfen, dass die Rundenuhrzeit 00:30, 01:15 bzw. 02:00 vorkommt (gleiche Uhrzeit in Bild und Erzähler; der Erzählertext der Runde steht ebenfalls im Text). Und an jeder Fotostelle vor `finale` außer dossier und wahl_verdeckt_*: Der Bildschirmtext enthält nicht den Satz „Nur für dich“ und keinen Satz der Täterfassung des Pfads (lies content/party/schlosskeller/texte/taeter-<pfad>.json, Feld tarnung; prüfe die ersten 40 Zeichen).
6. Bericht: tool/e2e/fotos/e2e/bericht.json (je Lauf: pfad, ende, n, ok, ende_ist, punkte, dauer_s, fehler[], fremd[], fotos) und bericht.md (Tabelle aller Läufe, Summe bestanden/gesamt, Liste der Fehler). Rückgabewert des Prozesses 0 nur, wenn alle Läufe bestanden.
7. Aufruf mit Filter für schnelle Proben: node e2e.mjs --nur pfad=ahmet,n=4 (beliebige Felder, Komma-getrennt) und --parallel 1|2.
8. README.md (kurz, deutsch): Zweck, Voraussetzungen (Web-Build ohne CDN: flutter build web --release --no-web-resources-cdn -o build/web), Aufrufe, wo Fotos und Bericht liegen.
9. Teste dein Gerüst mit node e2e.mjs --nur pfad=ahmet,n=4 und mit node e2e.mjs --nur pfad=can,ende=ende_eskalation,n=7 (mit Fotos) und mit einem Semantik-Lauf (--nur pfad=olli,semantik=1). Führe NICHT alle 84 Läufe aus – das macht der Orchestrator.

ABNAHMEKRITERIEN UND TESTWEG:
- Die drei Probeaufrufe aus Schritt 9 laufen durch und melden „bestanden“; ein absichtlich falscher Erwartungswert (z. B. ende vertauscht in einer Kopie der Laufliste im Speicher) wird als Fehler erkannt – belege das im Bericht.
- node --check e2e.mjs und node --check laeufe.mjs ohne Fehler.

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 700 Wörter):
## Ergebnis F4-BAUMEISTER-07
- DATEIEN: Liste mit Zeilenzahl
- UMGESETZT: je Arbeitsschritt eine Zeile (Nr. → was, wo)
- TESTS: Anzahl, Ausgabe der letzten Zeile von flutter test
- PROBELÄUFE: je Lauf eine Zeile mit Ergebnis
## OFFENE FRAGEN
- (oder „keine“)

SELBSTPRÜFUNG: Alle Schritte umgesetzt? Nur eigene Dateien geändert (git status zeigt nur sie)? Jeder sichtbare Text aus Bausteinen? Tests und Analyse gelaufen und grün? Spoilerschutz eingehalten?
Letzte Zeile exakt: === ENDE F4-BAUMEISTER-07 · BEREIT ZUR RÜCKGABE ===
