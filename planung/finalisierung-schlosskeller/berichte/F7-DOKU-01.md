## Ergebnis F7-DOKU-01
- DATEIEN: `/home/user/werwolf_digital_flutter/docs/partykrimi/ANLEITUNG.md`, 350 Zeilen (neu). Der Ordner `docs/partykrimi/` wurde angelegt. Der Druckausgang liegt in `/tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f7/druck/` (8 PDFs).
- UMGESETZT:
  1. Teil 1 „Für Gastgeber“: Abend, Ausrüstung, Start im Hauptmenü, Einrichtung (Personen, Namen, Detektiv, Fall-Code, Druck, Rundendauer, Stimme), verdeckte Rollenvergabe mit Zwischenstufe, Ablauf je Runde (Uhr, Karte, Gruppenwahl, Bonus, Resümee), Anklage, Finale, Auflösung, Ende, Erzählerstimme, Ausfall, Fall-Code, drei Lacher vorher absprechen.
  2. Teil 2 „Druckspiel“: Wann sinnvoll, die acht Dateien (App und Befehl), einseitig drucken, Teile falten und sortieren nach dem Spielleitungsheft, Rolle der Spielleitung, Stimmkarten mit Abreißstreifen und Tabelle, Fassungen, Auflösungsheft, bekannte Grenzen.
  3. Teil 3 „Für Entwickler“: Werkzeugkette, Aufbau, Regeln im Code, Prüfwerkzeuge mit Ausgaben, Einstieg `?party=` mit allen Parametern aus `skript.dart`, Texte ändern, Secret-Scan, Grenzen.
  4. Nachprüfung: 168 Zitate in „…“ gegen die Quellen geprüft. 157 sind wortgleich belegt. Die übrigen 11 sind Ausgaben der Werkzeuge, die ich im Quelltext der Skripte gegengeprüft habe. Zwei Zitate wurden auf den Wortlaut des Heftes korrigiert.
- NACHGEPRÜFT:
  - Ausgeführt: `party_druck.dart --pfad olli --n 7 --aus …/scratchpad/f7/druck` (Exit 0, 8 PDFs; Flutter-Root-Warnung, kein Fehler). `party_texte.dart` (OK, 1601 Texte). `party_pruefen.dart` (OK, 4 Pfade, 22 Personen). `party_bibel.dart --pruefen` (aktuell). `party_prompts.dart --pruefen` (aktuell, 42 Prompts). `party_simulate.dart --pruefen` (OK). `dart test` (389 bestanden, rund 2 Min.). `dart test test/party/texte_test.dart` (11 bestanden). `flutter test test/party_widgets` (129 bestanden). Die Syntax von `tool/pruefen.sh`, `tool/secret_scan.sh`, `tool/e2e/e2e.mjs` und `tool/e2e/server.mjs` wurde ohne Ausführung geprüft.
  - Nicht ausgeführt: `tool/pruefen.sh` und `tool/secret_scan.sh` (rufen Git-Befehle auf bzw. schreiben Build-Ordner), E2E-Läufe und `flutter build web` (Build nötig, Zeitaufwand), `git log` (verboten).
  - Beschriftungen nachgeschlagen: `ui.json`, `ui-titel`, `ui-einrichtung`, `ui-rollen`, `ui-runde`, `ui-gruppenwahl`, `ui-finale`, `ui-erzaehler`, `ui-npc`, `ui-druck-rollen`, `ui-druck-karten`, `ui-druck-spielleitung`, `erzaehler-intro.json`, `lib/l10n/app_de.arb` (Hub), `fall.json` (Titel), die Aktionslabels in `karte_session.dart`, Foto `002_einrichtung.png`, PDF-Seiten 1 bis 5 von `00-spielleitung.pdf` und Seite 1 von `12-stimmkarten.pdf`.
- OFFEN:
  - Browser-Test nicht gemacht: Neuladen (die Anleitung sagt „beginnt von vorn“, belegt nur durch fehlenden Speicher in `lib/party`), Abbruch, Erzählerstimme und Druck-Download in der App.
  - Die Adresse der App steht nicht im Repo. Die Anleitung verweist dafür auf das Team.
  - Ausfall während des Abends ist im Code nicht vorgesehen (`einrichten` nur in der Phase Einrichtung). Die Anleitung beschreibt nur, was die App kann.
  - Papierauszählung nicht von Hand durchgespielt.
  - Fotos in `tool/e2e/fotos` sind älter als E-039: `002_einrichtung.png` zeigt für Lejla noch „Die Buffet-Chefin“, `figuren.json` hat „Die Apothekerin“. Die Anleitung nennt keine Figurentitel.
  - Der Auftrag nennt „Partyabend“. Der Hub-Eintrag heißt „Partyabend: Spuk im Schlosskeller“ (`app_de.arb`). Die Anleitung nutzt den vollen Eintrag.
  - Git: `git status` zeigt außer meiner Datei `planung/finalisierung-schlosskeller/belege/BESTAND-f26f2de.md`. Die habe ich nicht angelegt, ich habe sie unberührt gelassen.

## OFFENE FRAGEN
- Rundendauer im Druck: Das Spielleitungsheft nennt immer 30 Minuten (`packages/mordakte_core/lib/src/party/druck/spielleitung.dart` Zeile 155 liest `fall.json` `rundendauerMinuten`). `DruckSatz.aus` bekommt keine Dauer. Die Wahl 20, 45 oder 60 Minuten wirkt nur am Bildschirm. Soll der Druck die gewählte Dauer übernehmen? Bis dahin nennt Teil 2 den Bruch.
- Fassung falten: FÜR-DEN-NUTZER sagt „mit der Schrift nach unten weglegen“. Das Spielleitungsheft (`ui.druck.spielleitung.teile.fassung`) sagt „mit der Schrift nach oben aufeinander“. Die Anleitung folgt dem Heft. Bitte klären.
- Lacher-Figuren: Der Master (7.15) nennt noch Selin, „neu zu vergeben“ und Meryem. Die Texte nutzen Sibel, Olli und Hana (Kennungen `selin`, `olli`, `meryem` in `setting.json`). Die Anleitung folgt den Texten. Soll der Master angeglichen werden?
- Fotos neu erzeugen, da sie älter als E-039 sind.

SELBSTPRÜFUNG: Keine Spoiler? Ja. Täterzuordnungen, Auszählschwellen, Endenkriterien und Beispielcodes stehen nicht in der Anleitung. Die drei Lacher nennen nur Rollen und den Gag aus FÜR-DEN-NUTZER. Jede Beschriftung wortgleich? 157 von 168 Zitaten wörtlich belegt, die übrigen 11 sind Werkzeugausgaben. Jeder Befehl lauffähig? Die Befehle aus Teil 3 wurden ausgeführt, außer `tool/pruefen.sh`, `tool/secret_scan.sh`, E2E und Build. Diese nur syntaktisch geprüft.
=== ENDE F7-DOKU-01 · BEREIT ZUR RÜCKGABE ===

## Abnahme (Orchestrator)
- FREIGEGEBEN · 10/10
- Funktion 2 · Kanon-Treue 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2
- Offene Fragen entschieden in E-040; Stand-Zeile, Rundendauer und Knopfname in der Anleitung nachgezogen.
