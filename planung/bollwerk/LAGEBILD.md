# LAGEBILD · Meta-Lauf BOLLWERK (M0)

Stand 2026-10-09 21:47 UTC (23:47 Berlin). Sitzung `session_01V8nVEJcaAbNDmTCrmHBoBq`, Branch `bollwerk-plan` (angelegt von origin/main `47611d8`).
Rohbelege der Agenten liegen im Scratchpad (`erg/B2…B10.md`, `erg/INV-01…04.md`); hier steht das Geprüfte.

## 1. Stand der Refs (selbst geprüft mit `git rev-parse`, `git merge-base --is-ancestor`, `git ls-remote`)

| Ref | SHA | letzter Commit (UTC) | Vorfahr von origin/main |
|---|---|---|---|
| origin/main = origin/nachtlauf/burgstadt | 47611d8 | 20:59 | – |
| origin/finalisierung-schlosskeller | 5c83242 | 21:12 | nein |
| origin/kern-feinkorn | 1145cb9 | 18:36 | nein |
| origin/claude/pensive-gates-ajtp7x (HD-Inhalt caf1d61) | f275929 | 21:17 | caf1d61: nein; 0304eb2 (Burgstadt-Merge der Linie): ja |
| origin/bollwerk-leitstand | 87e05b5 | – | – |
| Tags auf origin | 0 | – | – |
| `loop/epoch-*` | 41 Branches | – | ja (Anhang B) |

Probe-Merges (`git merge-tree --write-tree`): main ← caf1d61 Exit 0 (188 Dateien), main ← 1145cb9 Exit 0 (52), main ← fin Exit 0 (238), caf1d61 × 1145cb9 Exit 0. **0 Konflikte.**

## 2. Stand der Läufe

| Lauf | Stand | Erwarteter Abschluss |
|---|---|---|
| Finalisierung | STATUS: „Bauphase F5 von F7 · Abnahme 9 von 17 · Aufträge 138 von 177“; F4 (F-12, F-13), F5 (F-09, F-14), F6 (F-16) offen; letzter Commit 21:12 UTC; PR #43 offen (`mergeable_state: clean`, 238 Dateien) | Schätzung mit Spanne: 10.10. Vormittag bis 11.10. Abend (heutiges Tempo ≈ 1 Phase je 3–5 h, F5–F7 offen) |
| Nachtlauf Burgstadt | „Abnahme 13 von 14, Z-12 beim Nutzer“ (Commit 47611d8, 20:59); pusht auf main = nachtlauf/burgstadt | wartet auf den Nutzer (Z-12); kann jederzeit wieder pushen |
| Burgstadt HD | pausiert, Inhalt caf1d61 | – |
| FEINKORN | archiviert, 1145cb9 | – |
| Krimidinner | anderer Fall, eingefroren | – |
| Leitstand | Phase L2, Herzschlag stündlich (Minute 38); STEUERUNG S-1…S-3 | – |

## 3. B-02 (Probe `planung/bollwerk/proben/b02.sh`, gelaufen 21:23 UTC)

```
B02.1 nein · Finalisierung meldet ZIEL ERREICHT
B02.2 nein · Spitze 5c83242 ist Vorfahr von origin/main
B02.3 nein · seit 60 min kein Commit auf origin/finalisierung-schlosskeller (letzter vor 11 min)
B02.4 ja   · 0 Commits der letzten 60 min auf main/nachtlauf berühren fin-Pfade
B02.5 nein · PR #43 gemergt oder geschlossen (Stand: offen)
STEUERUNG: kein B-02-Eintrag
B-02 offen (1/5)
```
Folge: Die erste Generation startet im **Vorlauf**.

## 4. Faktenprüfung Anhang B (8 Haiku-Kundschafter B2–B8, B10; B1 und B9 selbst)

| Abschnitt | geprüfte Zeilen | bestätigt | Abweichung | nicht prüfbar |
|---|---|---|---|---|
| B1 Linien (selbst) | 12 | 10 | 2 | 0 |
| B2 Spielkern | 134 | 121 | 8 | 5 |
| B3 Look (main / fin) | 55 | 47 / 34 | 3 / 17 | 5 / 4 |
| B4 Sitzung | 40 | 29 | 9 | 2 |
| B5 Hoheit | 16 | teilweise | s. u. | – |
| B6 Prüfwerkzeuge | 76 | 54 | 10 | 12 |
| B7 Wiederverwertbar | 43 | 28 (+12 teils) | 1 | 2 |
| B8 Lehren | 30 | 14 (+10 teils) | 2 | 4 |
| B9 Umgebung (selbst) | 10 | 7 | 3 | 0 |
| B10 Umfang | 14 | 10 | 4 | 0 |

**Nachprüfung (Opus, 6 Stichproben, alle bestätigt):** Texte 1.581 (`dart run bin/party_texte.dart` → „Texte: OK (1581 Texte)“); 6 `implements GameSession` (`grep -rln`); `sichtbareRaeume` statt `NpcFilter/RaumSicht` (lib/game/szenen_erweiterung.dart:21); Ziel-Schlüssel person 10 / gegenstand 6 / raum 3 / ort 3 (`jq`); generische Ruhe-Bewegung (mordakte_game.dart:1298, karte_session.dart:300) bei 22 kanonischen `idleAnimation`-Texten; Burgstadt-Lauf 23 h 45 min statt 10 h (nachtlauf/NACHTPROTOKOLL.md:55, :87).

**Wesentliche Abweichungen (gelten ab jetzt vor Anhang B):**
1. **Finalisierung weiter als B sagt:** F5 von F7, 1.581 Texte (nicht 1.217), 79 Testdateien, 624 `test(` und 108 `testWidgets(` (Wurzelpaket hat jetzt `test/` mit Widget-Tests), `tool/e2e/e2e.mjs` vorhanden (84 Läufe), Druckfassung als PDF (`packages/mordakte_core/bin/party_druck.dart`, 8 Dateien).
2. **Partymodus auf fin schon gebaut:** Route `/party`, `PartyKartenSession` über eine optionale `SzenenErweiterung` (lib/game/szenen_erweiterung.dart) statt der geplanten Haken `NpcFilter`/`RaumSicht`; 12 Bildschirme unter `lib/party/bildschirme/`; Nebel des Krieges (mordakte_game.dart:1103, :1139); Detektivfarbe #B8A48A; grüne Flaschen im Partymodus entfernt (Tische als `party_tafel`); Wendeltreppe/Teekocher-Umwidmung zurückgenommen; generische Ruhe-Bewegung für 21 NPCs (nicht die 22 Einzeltexte).
3. **Noch offen auf fin:** Schneider steht statt zu sitzen; Items leer; keine Posen; keine Mimik; Vorlagenreste `ravensmoor`; playerSpeed 3,2; kein Ton im Iso-Spiel; **Joystick und Aktionsknopf sind im Partymodus sichtbar** (Bildprobe, siehe §6).
4. **Startroute:** `/burgstadt` (lib/main.dart:78); 9 Routen, 19 Bildschirme, 3 klassische Fälle (blue_palm, nachtexpress, ravensmoor).
5. **B1:** Die Finalisierung ist teilweise über Burgstadt gemergt (6718650 ⊂ main), ihre Spitze nicht. `caf1d61` ist **nicht** in main, obwohl 0304eb2 (Merge von pensive-gates) es ist – der Merge liegt vor caf1d61.
6. **B9 Werkzeugkette:** `/opt/flutter` fehlt in dieser Maschine (B9 sagte vorhanden). Node 22 und Playwright 1.56.1 liegen unter `/opt/node22`, Chromium unter `/opt/pw-browsers/chromium-1194`.
7. **B7:** `Starrkoerper.matrix()` liefert die Drehmatrix der Lage, nicht die Würfel-Oberseite (Ablesen braucht eine eigene Funktion).
8. **B8:** Es gibt zwei Torwerkzeuge (`tool/abnahme.dart`, `tool/hd_abnahme.dart`); Z-12 lief bis Runde 33; HD-Zahl „49 von 306“ nicht belegbar.
9. **B5:** Hoheitsliste deckt sich für ORCH-Dateien und Party-Muster; Pfadkürzel `core/`, `P/` sind keine echten Ordner (nur Schreibweise).

## 5. Umgebung (acht Fragen aus M0)

| Nr | Frage | Antwort | Beleg | Folge für den Master-Prompt |
|---|---|---|---|---|
| 1 | Werkzeugkette in Repo-Version, Einrichtdauer | Flutter 3.47.6 / Dart 3.13.5 (gepinnt in `build.sh`) fehlt; aus derselben Quelle in **70 s** geladen, `pub get` in 8 Paketen **41 s**. Nötig: `chown -R` auf das entpackte SDK (sonst „dubious ownership“; Git-Konfiguration bleibt unberührt). | `flutter --version` → „Flutter 3.47.6 • channel stable“, „Dart 3.13.5“ | Startschritt „Werkzeugkette“ in 2.3 Schritt 3 mit diesen Befehlen, repo-lokal unter `.werkzeug/` (gitignored) bzw. außerhalb des Repos |
| 2 | Bauen, Analysieren, Tests | Web-Release-Build **92 s**; `party_simulate --pruefen` **0,37 s** (3 s mit Start); `room_host` 5 Tests **10 s**. Voller Testlauf nicht gemessen (Schwerlast-Slot belegt) – Schätzung 10–12 min nach B6. | `erg/webbuild-fin.log` „✓ Built build/web · 92 s“; „Simulator: OK (372 ms)“ | Torbudgets aus Anhang A bleiben; voller Lauf als Lichtungsaufgabe messen |
| 3 | Echte Bildschirmbilder ohne Gerät | **ja**: Web-Build + Chromium, echte Schriften (Inter, SpecialElite), 3 Räume × 3 Ansichten, 0 Konsolenfehler, 0 fremde Anfragen; ≈ 68 s je Bild mit fester Uhr | `proben/foto_probe.mjs`, `bilder/meta/` | Bildverfahren steht wörtlich im Master-Prompt |
| 4 | Spiellogik ohne Oberfläche | **ja**: reines Dart, Simulator erschöpfend in 0,37 s | wie 2 | Simulationen mit Tausenden Partien im Torwerkzeug |
| 5 | Mehrere Instanzen über die lokale Schleife | **ja** für VM: `RaumHost.starte(adresse: loopbackIPv4)` + `RaumClient.verbinde('127.0.0.1', …)`, 5/5 grün | packages/room_host/test/raum_host_test.dart:57, :67 | L7 WLAN: Host-VM + VM-Gäste; Browser-Gast nur über Web-Client |
| 6 | Wartebefehl ≤ 10 min | `timeout 590 bash -c 'until <bedingung>; do sleep 30; done'` als **Hintergrundbefehl**; Benachrichtigung beim Ende kommt automatisch | Probe: „exit 0 nach 30 s“ | steht wörtlich in Abschnitt 0 |
| 7 | Gleichzeitige Hintergrund-Agenten, Kontextbudget | **12 gleichzeitig ohne Fehler** (Welle M0-1, 21:20–21:39 UTC), 0 Ausfälle; Dauer medium 55–140 s, max 9–18 min; Rückgabe 1–25 Zeilen. Werte 4 und 8 werden in M2/M3 gemessen. Workflows nicht freigegeben (STEUERUNG S-3). | `erg/agenten.tsv` | Wellengröße Startwert 12 |
| 8 | Werkzeuge, Fortsetzen nach Limit | Vorhanden u. a.: Agent, Bash, Read/Write/Edit, Grep/Glob, ToolSearch, SendUserFile, Artifact, Skill, Workflow (nicht freigegeben), `mcp__claude-code-remote__*` (darunter `send_later`, `get_trigger`, `delete_trigger`), `mcp__github__*`. **Fortsetzen nach Nutzungslimit: nicht klärbar** (BELEGE C13: für einfache Cloud-Sitzungen nicht dokumentiert). | Werkzeugliste der Sitzung | Master-Prompt plant beide Fälle: selbst fortsetzen oder „WEITER BOLLWERK“ des Leitstands |

## 6. Befund mit Folgen: Werkzeugverbot der Agenten wird nicht technisch erzwungen

`proben/werkzeug_audit.sh` (wertet die echten `tool_use`-Einträge der Agentenprotokolle aus) fand in Welle M0-1 **2 von 14 Agenten** mit verbotenen Aufrufen, obwohl das Verbot wortgleich im Auftrag stand:
- `mcp__claude-code-remote__list_sessions` (M1-INV-03, Ergebnis enthielt Metadaten fremder Sitzungen)
- `mcp__claude-code-remote__read_documentation` (M1-INV-04)

Beide Aufrufe waren lesend und folgenlos. Ein `interrupt_session` oder `delete_trigger` wäre es nicht. Hintergrund-Agenten des Typs `general-purpose` sehen alle Werkzeuge; die MCP-Werkzeuge sind „deferred“ und werden über ToolSearch geladen.

Folgen (in den Master-Prompt):
- **ToolSearch** kommt auf die Verbotsliste der Agenten (ohne ToolSearch sind die verzögerten MCP-Werkzeuge nicht aufrufbar).
- **Werkzeug-Audit nach jeder Welle** als Ring der Prüfmauer; ein Verstoß verwirft das Ergebnis des Agenten, ein Verstoß mit schreibendem Werkzeug ist ABBRUCH-Grund.
- Eine technische Sperre (`permissions.deny` in `.claude/settings.json`) bleibt Annahme A-13 (Standard: keine; der Nutzer entscheidet).

## 7. Modellprobe

`grep -o '"model":"[^"]*"' ~/.claude/projects/*/*/subagents/agent-*.jsonl | sort | uniq -c` → nur `"model":"claude-haiku-5-5"` (14 Agenten, Aufruf mit `model: "haiku"`). Denkstufe je Aufruf über den Parameter `effort` (medium / max).
