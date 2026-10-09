# Lückenanalyse v3 ↔ v2.3 ↔ Plan → Grundlage für v4

> **Nachtrag v4.1:** W7/W8 (Sperrdatei, Variablen) entfallen: v4.1 legt keine Einstellungsdatei an (C14 unbelegt, Umgebung geteilt); eine reine Verbotsdatei ist Annahme A-13 (Standard: keine). Diese Abweichung vom Plan steht in den Annahmen. Wellengröße: Standard ≤ 20 je Workflow (W12).

Kürzel: **v3** = META-PROMPT-BOLLWERK-v3.md · **MP** = META-PROMPT.md (v2.3) · **A/B/C** = META-ANHANG-A/B/C · **PL** = freigegebener Plan · L = Zeile

## 1. Changelog
**v1 → v2**
- Lichtungsaufgabe; Richtzeiten mit 1,5×-Regel.
- M0 legt META-AUFTRAG ab, setzt die Sperrdatei und pusht.
- B-02 wird einmal geprüft; ist sie offen, endet der Zug.
- Startschritte 2.3; Abläufe statt bedingter Verbote; der Master-Prompt steht für sich.
- Pflichtpunkte im Startpaket; doppelte Modellprobe.
- Kapazität = min(Parallelität, Last, Kontingent); Richter-Eichung in M-06.

**v2 → v3**
- Denkstufen je Rolle; CLAUDE_CODE_EFFORT_LEVEL verboten.
- ANTHROPIC_MODEL und enforceAvailableModels.
- M0-Frage 8 (Limit); Welle ≤ 2 Limitfenster.
- Rückgabe nur Kennung/Pfad/Status; Agenten ohne Git und Netz; Cache-Teilung je Welle.
- `/goal` nach dem Prompt; §11 stark erweitert.

## 2. Stärken von v3, die B fehlen (→ Ort in v4)
- **Abläufe statt „nicht …, bis …“** (L130) → §8.1. B verstößt mehrfach dagegen (A L396, L631; MP L122); diese Stellen umschreiben.
- **Sperrregel** mit Begründung 3 in Folge/20 insgesamt (L50) → §4 + A4.4.
- **Zug offen halten**, solange Arbeit läuft; Abbruch bei 3× Dauer (L51, L186) → §4, §8.7.
- **Modelle und Denkstufen:** doppelte Modellprobe (L64), Denkstufe je Rolle (L10), Verbot von EFFORT_LEVEL (L204) → §5, §8.8.
- **Kapazität** aus Tokens je Agent je Limitfenster (L115) → §7 M4, dazu das K-Glied in A MP-11.
- **Zusatzmaße** → §8.3 + C:
  - Überschneidung zweier Zufallspartien (L152)
  - WLAN: kein Gerät beeinflusst den Wurf (L102), die Gäste rechnen den Seed nach
- **Fabrik:** Stufe 1–3 mit Stufe 3 an Opus, Feld `status=BEREIT`, Welle teilt Cache (L178–180) → §8.6. Opus-Stichprobe als Ring 8 (L170) → §8.5.
- **Prüfung:** Rubrik P1–P13 ≥ 23/26 (L208), Kaltstart nur lesend (L219), Verdichtungs-Probe (L220) → §9. Ersatzregel M-09 bis M-12 (L237) → §10.
- **Design:** Tablet als dritte Ansicht (L156); Eichung mit verschlechterten Kontrollpaaren (L230) → §8.4.
- **Betriebswissen:** §11 (L241–254) → §11, jede Zeile mit BELEGE-Status (C1–C14).

## 3. Stärken von B, die v3 fehlen
- **Nutzerwille (A L13–54):** v3 fehlen:
  - App-Start im Schlosskeller samt Menü und Rückschalter
  - „Stark“ im Wortlaut (zweiter Anlauf, Umweg, lösbar)
  - Bilder in den Chat
  - Druckspiel bleibt, Nebel ist Pflicht, Kanon 1.0 unantastbar
  - „alle Agenten gleichzeitig“
  - Bild-Look + Leben (v3 L159 macht daraus eine Annahme)
- **Deutungen (A3):** Keller = fünf Sandsteinstufen; „manchmal“ = 30–60 % der Züge; „archivieren“ = an Ort und Stelle.
- **Harte Regeln A4.1–A4.10:**
  - Push-Form, Staging, `commit.sh`
  - Bestandsschutz, eingefrorene Vergleichsstände
  - Rohchat und Passagenprüfung
  - Sperrliste und Liste `gewalt`, `ohneFlaschen`
  - WÜ-1 bis WÜ-6, Dateihoheit vor und nach B-02
  - Pool ohne Git, Stolperdraht, flock und Plattenwache
  - Werkzeugverbote für Agenten (Lehre aus hd/FEHLER: `interrupt_session`; im Loop kritisch)
- **Fakten B1–B10:**
  - SHAs, Probe-Merges mit 0 Konflikten
  - Fallen E28/E31/E36/E52
  - `abnahme.dart` und `commit_gruen.sh` nie benutzen
  - Workflow-Gleichzeitigkeit = 2
- **Mechanik C1–C8:**
  - Pech-Garantie, Budget-Ungleichung, Kettensperre
  - Seed-Formel, Pfadgleichheit, Weißliste
  - Spielformen mit Zahlen
  - Lösbarkeits**beweis**
- **Weitere Bausteine:**
  - Vorlauf V, Hoheit, FREIGABE-Weg
  - Linienklassen, Übernahme-Commits
  - HD nur `caf1d61` mit A-12; FEINKORN `1145cb9` mit K7
  - Umfang: Gewichte, 40-%-Regel, Pflichtziele, Füllstoff F1–F5
  - Look-Vertrag, D1–D3, Stilprüfung S1–S5
  - Torwerkzeug L0–L10 mit Mutanten und Golden
  - Barrierefreiheit, Fortsetzen, Datenschutz, „Fertig heißt nicht Store“
  - Ereignisbudget, Drossel, FLUG.md, Kürzungsleiter, Nebelkarte
  - Deploy-Hinweis und Rückweg
- **Meta-Abnahme:** M-02 Faktenprüfung, M-03 Regelvollständigkeit, M-04 Anforderungsmatrix, M-11 Wortsperre, M-13 Hoheit.

## 4. Widersprüche und Lösung
| # | Thema | v3 | B | Plan | Lösung |
|---|---|---|---|---|---|
| W1 | main-Push | Nachtlauf pusht (L145, L189, L199) | BW8 samt Tags (A L841–851) | nur Leitstand über `bollwerk-mc`; Nachtlauf meldet „BEREIT FÜR MAIN“ (PL L71, L135–146) | **Plan.** Z-MAIN wird MAIN-REIFE (Probe-Merge auf aktuellem main, 0 Konflikte, Tor grün). MP-16 geht an Merge-Bau und Leitstand. v3 L199 entfällt. |
| W2 | Tags/Archiv | nur bei Beleg (L191); Proxy sperrt Tags (L243) | Archiv-, vor-bollwerk- und Release-Tags (A L95–99, L424) | Archive als Branches, nur Leitstand (PL L44, L57) | **Plan.** `archiv/*` als Branches; `bollwerk-1.0` als Befehl für den Nutzer; v3 L140 „Archiv sichern“ macht der Leitstand. |
| W3 | B-02 | ohne Tag (L139) | Tag Pflicht (A L370–377); K = Tag (A L726) | 4 Bedingungen, 60 min (PL L63–69) | **Plan + B-Schritt 5** (fin-Pfade auf main ruhig). K = B-02-Commit in LAUF.md; FREIGABE nur als S-Eintrag. |
| W4 | B-02 offen | Zug beenden (L139) | Vorlauf (A L387–403) | Vorlauf (PL L121) | **B/Plan.** B-02 ist ein Phasentor; die Nummer 2.2 bleibt (L134). |
| W5 | Startbedingung „kein Lauf integriert in main“ | L139 | Burgstadt pusht laufend (B L23) | – | Streichen; wird zum Merge-Fenster in L4. |
| W6 | Abhängigkeiten | erlaubt, wenn zwingend (L41) | verboten (A L135) | v2.3-Regeln bleiben (PL L191) | **B.** Ausnahme nur als Annahme. |
| W7 | `.claude/settings.json` | Meta setzt sie (L80, L205) | nie ändern (A L146) | Sperrdatei (PL L72) gegen v2.3-Regeln (PL L191): **plan-intern widersprüchlich** | Ausnahme für genau diese Datei; der Leitstand legt sie vor L2 an (der Filter kann Selbstfreigaben sperren), danach unveränderlich, in MC entfernt. |
| W8 | Variablen | Umgebungsblock (L204) | – | nichts in „Default“ (PL L192) | Schlüssel `env` der Sperrdatei (in BELEGE prüfen), sonst eigene Umgebung. |
| W9 | Branches | `bollwerk` aus main + plan (L140) | Meta pusht `bollwerk` (MP L34, L84) | Meta → `bollwerk-plan`, Leitstand → `bollwerk` (PL L113) | **Plan.** |
| W10 | Herzschlag/Sperre | – | Kind mit Routine + `send_later` (A L117, L657); Übernahme nach 90 min (A L881) | Routine nur im Leitstand; LEASE gen/session (PL L50) | Kind nur `send_later`; LEASE nach Plan, die höhere Generation gewinnt. |
| W11 | Zugende | offen lassen (L51) | „Zug beenden“ (A L919) | Zugende-Marke + Weckruf (PL L52) | Läuft Arbeit, bleibt der Zug offen; sonst Marke + `send_later`. |
| W12 | Wellen | ≤ 1.000 je Workflow (L184) | ≤ 20 je Workflow (A L636) | – | Standard ≤ 20, mehrere parallel, Wert aus M3. |
| W13 | Form | Block als Nachricht, ohne Technik (L41, L199) | Datei + Anhänge, `dart`-Befehle (A L313, L336) | Text als Nachricht, 60 KiB (PL L102, L116) | Regeln im Block ≤ 60 KiB; Daten als Anhänge; Befehle bleiben konkret (Annahme). |
| W14 | Auslösewort | nie im Block (L128) | A1 mit „Ulttracode“ (A L16), „Ultracode an“ (A L333) | – | A1 als Anhang, im Block geschwärzt; Workflow-Automatik im Kind über L1b klären. |
| W15 | Würfel | Gewicht per Simulation (L103); Bot-Quote im Band (L165) | WÜ-4 bindend, Lösbarkeit 100 % (C8) | „lösbar bleibt“ (PL L5) | **B bindend.** Die Simulation stellt nur Bänder ein. |
| W16 | Umfangsbasis | Start des Nachtlaufs (L153) gegen L21 | B-02-Commit (A L463) | – | **B-02-Commit**, eingefroren. |
| W17 | Look | Annahme (L159); FEINKORN nur abgrenzen (L43) | BE-01, FEINKORN-Merge (K7) | PL L8 | **B.** |
| W18 | Spielweise | alte Spielweise archivieren (L96) | Kanon und Druckspiel bleiben; Schalter (A L138) | – | Archivieren nach A3. |
| W19 | Bericht/Bilder | Morgenbericht vom Nachtlauf (L193) | Chat-Befehle, SendUserFile, Ende M + 2 h (A L684) | Leitstand; Bilder vor B-02 nur im Morgenbericht (PL L168) | Nachtlauf legt MORGENBERICHT.md und Bögen ab, der Leitstand zeigt sie. Generationsfenster ≤ 12 h. PL L168 widerspricht „Bilder immer im Chat“ (A L32) → ein Bogen je Herzschlag. |
| W20 | Dateien | STATUS für Meta und Nacht (L192, L257) | ASCII, `meta/` (A L414, MP L130) | – | ASCII; Meta-Zustand unter `meta/`. |
| W21 | Push-Form | – | `<sha>:refs/heads/bollwerk` (A L100) | Regel `HEAD:bollwerk` (PL L72) | Eine Form für Befehl und Regel. |
| W22 | Kleinere Punkte | 2–4 h (L11); neue Sitzung (L197); Opus-Agenten nur zur Prüfung (L61); Doku lesen erlaubt (L54) | 6 h (MP L5); Autostart (MP L318); 4 Opus-Entwürfe (MP L181); kein Fetch; Option (c) früh auf main (A L403) | kein früher Merge (PL L37) | v3-Zeit; kein Autostart; Haiku-Entwürfe auf max mit höchstens 1 Opus-Ausnahme; Doku liest nur die Hauptsitzung; Option (c) streichen. |

## 5. Merge-Karte v4
| v4 | Quelle | Hinweise |
|---|---|---|
| §0–§1 | v3 + A1/A2 | Ziele um App-Start, Nebel, Druckspiel und „stark“ ergänzen; Nordstern: Generationen, 7 Tage ab B-02 (PL L178). |
| §2 Begriffe | v3 + A3 | Neu: Leitstand, Generation, LEASE, ZUSTAND, S/F/QUITTUNG, Vorlauf, Hoheit, MC. |
| §3 Ausgangslage | v3 + B1/B9 | Meta ist eine Kindsitzung; Anhänge mit Ref und SHA. |
| §4–§6 | v3 + MP §3 | W7, W9, W22; Werkzeugverbote aus MP L93–98. |
| §7 M0–M7 | v3 + MP M1–M4 | M1: 9 Leser + 10 % Nachprüfung. M2: Mechanik-Turnier + Simulation C8. M3: Fabrikprobe + Einbruchkriterien (MP L211); Design-Turnier. |
| §8.1–8.2 | v3 + A MP-0…20 | MP-2 → 2.2/2.3; neu 2.5 Generationen/LEASE/STEUERUNG · A4 → 3 · MP-6/9/C → 4 · MP-10/11/13 → 5 · MP-5/7/8/15 → 6 · MP-14 → 7 · MP-12 → 8 · MP-17 → 10 · MP-18 → 11 · MP-16 → 12 „BEREIT FÜR MAIN“ · MP-19 → 13 (idempotent, PL L54). |
| §8.3–8.4 | v3 + A MP-7/8 | W16; D2 mit 3 Ansichten. |
| §8.5 Prüfmauer | Ringe 1–8 ↔ L0–L10 | Ring 9 = Mutanten (L9). |
| §8.6–8.7 | v3 + A4.9 + MP-11/12 + PL L3 | W10–W12, W19; halbe Wellengröße bis B-02 (PL L132). |
| §8.8 | v3 → **Startpaket für den Leitstand** | `create_session`-Parameter, Startnachricht, Sperrdatei. |
| §9–§10 | v3 + MP M6/M7, M-02/03/04/11/13 | Kaltstart auch mit LEASE, S-Eintrag und Limit; neu M-13 Loop-Schnittstelle. |
| §11–§13 | v3 + B9 | BELEGE-Status je Zeile; letzte Zeile maschinenlesbar. |
| Anhang A | v2.3 überarbeitet | BE-02/05/09, A4.1/A4.2/A4.4, MP-2/12/16/18–20 nach W1–W4, W10, W19. |
| Anhang B | aktualisieren | `fin` = 83d6758; `bollwerk-leitstand` = 1f67f3e; keine Tags; `caf1d61`/`1145cb9` nicht in main; 0304eb2: Merge von pensive-gates in Burgstadt → HD könnte ohne A-12 auf main kommen. |
| Anhang C | v2.3 + v3 | Seed-Nachrechnung, Partie-Überschneidung, Bot-Quote. |

**Offen für L1b/BELEGE:**
- Workflow-Automatik und `/effort` im Kind
- ob das Prompt von `create_session` als Nutzerauftrag gilt
- Schlüssel `env` in den Einstellungen
- 60 KiB
- `send_later` im Kind
