STAND · Kanon v0 · Welle 0 · freigegeben 0 von 204 · in Arbeit 0 · Reparatur 0 · Tag 1 von 14 · nächster Schritt: Plan freigeben → Kanon schreiben

# Krimidinner „Spuk im Gewölbe“ – Welle 0: Grobplan und Betriebsplan

## Kontext
Du willst ein vollständig spielbares Krimidinner (4–20 Rollen plus Geburtstagskind als Detektiv), das ein KI-Erzähler wortgetreu vorliest. Ich plane, prüfe und montiere; Haiku-Agenten schreiben die Massentexte. Das Repo `werwolf_digital_flutter` (App „Mordakte“) hat mit dem Krimidinner nichts zu tun. Es dient nur als dauerhafte Ablage, weil der Container flüchtig ist. Die App-Dateien fasse ich nicht an.

## 1. Verständnis und Betriebsart
1. Ich bin Produktionsleiter: Ich schreibe Kanon, Stilblatt, Look-Bibel, Pakete, Abnahmen und Montagevorlagen; alle Massentexte schreiben Haiku-Agenten.
2. Betriebsart: **autonom**. Haiku-Agenten laufen hier (Test bestanden: `claude-haiku-5-5`, auch im Workflow-Werkzeug).
3. Ich vergebe also selbst, sammle ein und fahre alle vier Regelkreise. Bei dir melde ich mich nur zu Tagesabschlüssen, gebündelten Entscheidungen und Eskalationen.
4. Jedes Paket ist eine eigene Datei. Ein Haiku-Agent liest nur diese Datei, ohne Vorwissen.
5. Der Kanon ist die einzige Wahrheit; Lösungsrelevantes kommt nur wortgleich aus Kanon-Auszügen.
6. Alles entsteht als Klartext-Formular mit festen Feldnamen, Kennungen und eindeutigen Bedingungsmarkierungen für den Erzähler.
7. Ein „Tag“ ist ein Produktionszyklus: eine Charge von höchstens 30 Paketen (H1–H3 à 10), Abnahme, Tagesabschluss, Prüfpunkt, Push. Du startest jeden Tag mit WEITER.
8. Gründlichkeit vor Tempo: Ich plane erst vollständig, prüfe vor jeder Freigabe, und es endet erst mit PRODUKTION ABGESCHLOSSEN.

## 2. Antworten und Standardannahmen
| Thema | Festlegung |
|---|---|
| Ablage | Laut deiner Antwort im öffentlichen Repo, Ordner `krimidinner/spuk-im-gewoelbe/`, Branch `claude/ecstatic-cerf-7kzi1c`. Push nach jedem Tag, kein PR. Commit-Texte nennen nur Kennungen und Zahlen. |
| Detektiv | Neutral: immer „das Geburtstagskind“ oder „du“, kein Name, kein Alter, keine Formen mit festem Geschlecht. Eigener Kanon-Eintrag K2-D: Alibi, eigene Beobachtungen, Ziel des Streichs, nie verdächtig. |
| Gruppe | 10 Frauen- und 10 Männerrollen, jeder Viererblock 2 + 2; Alter 25–38. Rollen dürfen auch gegengeschlechtlich besetzt werden. |
| Leitung | Eigene Spielleitung, spielt nicht mit: bedient die App, legt Beweisstücke aus, gibt Karten aus, führt Kartenaktionen aus. |
| Termin (*Standardannahme*) | Kein Termin → Planung vorwärts ohne Frist. Nennst du einen Termin, rechne ich den Tagesplan rückwärts und lasse Wellen überlappen. |
| Spielort (*Standardannahme*) | Ein normaler Wohn- oder Gastraum. Die vier Stationen sind dekorierte Ecken oder Tische. |

**Meine Festlegungen (Begründung kommt in K1):**
- **Region: Harz** (Oberharz, fiktive Burg). Silberbergbau und Münzgeschichte machen die Sammlermünze glaubhaft; das „Brockengespenst“ ist eine rational erklärbare Spukvorlage für den Streich. Walpurgis- und Hexenkitsch sind im Stilblatt ausgeschlossen.
- **Opfer: der kauzige Burgwart, als Erzählerfigur** (nicht gespielt).
  - Er existiert in jeder Besetzung und verdrängt keine Kernrolle.
  - Er hat Hausrecht, Torschlüssel und Vitrine; nur dazu passen die Stränge b und d.
  - Er ist nur kurz benommen und hat eine Gedächtnislücke (deshalb nennt er keinen Täter). Versorgt wird er von einer Rolle.
  - Der Freund, der als Veranstaltungstechniker arbeitet, wird eine gespielte Kernrolle.

## 3. Grobplan

### 3.1 Mengengerüst und Pakete (Mittelwerte; [L] = enthält Lösung)
| Welle | Pakete (Kennungen) | Anzahl | Wörter |
|---|---|---|---|
| 0 | nur Opus: Kanon K1–K9, Selbstprüfung, Feinplan, Stilblatt mit Musterkarten, Look-Bibel, Vorlagen | – | ca. 35 Tsd. |
| 1 | PROFIL-R01…R20 (Steckbrief, Dossier, Kleidung); ERZ-EINF-V1…V3; ERZ-VORST-A/B; HINW-STAT-1/2, HINW-DOK, HINW-GESPR-A/B; REQ-BAU-1/2, REQ-RAUM, REQ-KLANG-LICHT; BILD-TITEL-V1…V3, BILD-EINLADUNG-V1…V3, BILD-STATIONEN, BILD-LAGEPLAN-BURG, BILD-FIGUREN-1…5, BILD-BEWEISE-1/2, BILD-KARTEN-1/2; PRÜF-PROFIL-A/B, PRÜF-BILD, PRÜF-W1-SPOILER | 55 | ca. 45 Tsd. |
| 2–4 (je Phase) | Pn-R01…R20 (3 Aufträge, Spiegelstücke inkl. Ersatzfälle, Entscheidungskarte); DET-Pn [L]; ERZ-Pn (Phasenstart, Zwischenresümee, 5 Einwürfe); ERZ-ANS-Pn-A/B; PRÜF-Pn-SPIEGEL-A/B, PRÜF-Pn-KANON-A/B [L] | 3 × 28 = 84 | 3 × 24 Tsd. |
| 5 [L] | ERZ-EINGRENZ-1/2, ERZ-ANKLAGE, ERZ-ENDEN-RICHTIG-V1…V3, ERZ-ENDEN-FALSCH-V1…V3, ERZ-GEST-V1…V3, DET-MAPPE, REGELBLATT, SL-BESETZUNG/-ABLAUF/-AUFBAU/-REGELN, SL-LÖSUNG-1/2, PRÜF-AUFL | 21 | ca. 20 Tsd. |
| 6 [L] | LAUF-{04,08,12,16,20}-{BEST,SCHLECHT,GEMISCHT} (15), LAUF-06-GEMISCHT, LAUF-11-GEMISCHT; PRÜF-ZEIT-A/B, PRÜF-SKAL-A/B, PRÜF-DET-FAIRPLAY, PRÜF-ABSICHERUNG, PRÜF-ERZ-VORLESE-1/2, PRÜF-LEIT-1/2, PRÜF-SPOILER-1/2 | 29 | ca. 32 Tsd. |
| 7 | MONT-MAPPEN-1…4, MONT-SKRIPTBUCH, MONT-HANDBUCH, MONT-DESIGN, MONT-QB; LEKT-PROFIL/-P1/-P2/-P3/-ERZ/-SL/-DET | 15 | ca. 12 Tsd. |
| **Summe** | | **204** | **ca. 181 Tsd.** |
| + 20 % Puffer | REP-[Kennung]-1/2 | 41 | ca. 36 Tsd. |
| **Gesamt** | | **245 Läufe** | **ca. 217 Tsd.** |

**Plausibilität der Mengen:**
- **Aufträge:** 180 Aufträge mit 180 regulären Spiegelstücken, dazu 36 Ersatzspiegel.
- **Entscheidungen:** 60 Rollen-Entscheidungen; 9 Detektiv-Entscheidungen mit 27 Ergebnistexten.
- **Erzähler:** 15 Atmosphäre-Einwürfe (Pflicht: mindestens 12).
- **Kanon und Beweise:** etwa 70–90 Einträge in K3, davon 40–50 Hinweiskarten; 9–10 physische Beweisstücke.
- **Bilder:** etwa 65 Bildprompts.
- **Umfang:** Eine Rollenmappe hat rund 3.000 Wörter. Der Abend dauert ohne Ausklang etwa 3:10 (4 Rollen) bis 4:15 (20 Rollen); siehe K5 ZM-4.

### 3.2 Tagesplan (★ = kritischer Pfad; jeder Tag hat Charge a = Schreiben/REP und Charge b = PRÜF/LAUF auf bereits Freigegebenem)
| Tag | Inhalt |
|---|---|
| 1 ★ | Welle 0a: Kanon-Kern, K1–K4, Selbstprüfung (Lösungsweg, Gegenprobe, Absicherung, Last-, Zeit-, Spiegel-, Besetzungsprobe für alle 17 Besetzungen) |
| 2 ★ | Welle 0b: K5–K9, Stilblatt mit Musterkarten, Look-Bibel, Feinplan (204 Pakete), Vorlagen, Paketbau-Hilfe → **Kanon v1.0** |
| 3 ★ | W1-A. Zuerst der Design-Vorrang: BILD-TITEL ×3, BILD-EINLADUNG ×3, BILD-STATIONEN. Danach PROFIL-R01–08, ERZ-EINF ×3, ERZ-VORST-A, HINW ×4, REQ ×4, FIGUREN-1/2. Charge b: PRÜF-PROFIL-A |
| 4 ★ | W2-A: P1-R01–08, DET-P1, ERZ-P1, ANS-P1-A, dazu restliche Bilder W1-A. Charge b: PRÜF-P1-A, PRÜF-W1-SPOILER, PRÜF-BILD |
| 5 ★ | W3-A: Phase 2 für R01–08, dazu SL-AUFBAU, SL-ABLAUF, REGELBLATT. Charge b: PRÜF-P2-A |
| 6 ★ | W4-A: Phase 3 für R01–08, dazu SL-REGELN. Charge b: PRÜF-P3-A |
| 7 ★ | W5: Auflösung, Enden und Geständnis als Varianten, DET-MAPPE, SL-LÖSUNG. Charge b: PRÜF-AUFL |
| 8 ★ | Variantenwahl. LAUF-04 ×3, LAUF-06, LAUF-08 ×3, PRÜF-ZEIT-A, PRÜF-SKAL-A, PRÜF-DET-FAIRPLAY → **spielbare Fassung für 4–8 Rollen**. Parallel W1-B: PROFIL-R09–20, VORST-B, HINW-GESPR-B, FIGUREN-3–5 |
| 9–11 ★ | Kanon v1.1 (nur Ergänzungen), Reparaturen; Phasen 1–3 für R09–20 mit ERZ-ANS-B, SL-BESETZUNG, je Tag PRÜF-Pn-B |
| 12 ★ | LAUF-11, LAUF-12/16/20 je ×3, restliche PRÜF-Pakete aus Welle 6 |
| 13 ★ | Reparaturen aus den Probeläufen, MONT ×8; Charge b: LEKT ×7 |
| 14 ★ | Reparaturen aus dem Lektorat, deterministische Endmontage, Qualitätsbericht → PRODUKTION ABGESCHLOSSEN |

**Kritischer Pfad:** Kanon v1.0 → PROFIL R1–8 → P1 → P2 → P3 (R1–8) → Auflösung → LAUF 4/6/8 → B-Block P1–P3 → LAUF 11–20 → Reparaturen → Montage.

**Wenn der Termin drängt:** Die Wellen 2–4 überlappen; dann dauert die Produktion etwa 11 Tage.

**Reserve:** Etwa 75 freie Plätze. Sie fangen Reparaturquoten über 20 % und drei Blindläufe auf.

### 3.3 Die fünf größten Risiken und Gegenmaßnahmen
1. **Kanon-Drift und Spiegelbrüche:** Haiku erfindet Uhrzeiten oder Gegenstände; Auftrag und Spiegelstück entstehen in verschiedenen Paketen.
   - K4 legt je Gespräch einen Kernsatz fest, den beide Seiten wortgleich übernehmen.
   - Geschlossene Listen erlaubter Zeiten, Orte und Gegenstände.
   - Kanon-Auszüge werden deterministisch byte-gleich zusammengesetzt.
   - Zählprüfung vor jeder Abnahme; je Welle PRÜF-SPIEGEL und PRÜF-KANON.
2. **Fair Play in jeder Besetzung von 4 bis 20:**
   - Die Absicherungsmatrix hat die Spalten Quelle, Mindestbesetzung und „blockierbar durch E-…“. Für jede Schlussfolgerung gibt es einen nicht blockierbaren Weg (Beweisstück, Station oder Erzähler) und einen Weg über die Rollen 1–4.
   - Rollen-Entscheidungen verschieben Hinweise nur, sie löschen keine.
   - Jede falsche Detektiv-Option stützt sich auf R1–4 oder ein Beweisstück.
   - LAUF-BEST spielt mit 9 Punkten gegen maximal hinderliche Rollen-Entscheidungen.
3. **Spoiler-Lecks** (Dossiers Unschuldiger, vorgelesene Ansagen, Bildprompts, Stofffarbe):
   - Sichtklasse je Kanon-Feld: O = öffentlich, G = Rollengeheimnis, L = Lösung. Pakete bekommen L-Felder nur, wenn sie zwingend nötig sind.
   - Ansagen zu R01–R04 sind anonym formuliert, und alle Kernrollen haben gleichartige Optionen.
   - Die Stofffarbe kommt bei mindestens zwei Rollen vor.
   - PRÜF-SPOILER läuft über Steckbriefe, Einführung, Einladung und Bildprompts.
4. **Gesprächslast und Zeit:**
   - Das Anker-Raster wird Teil von K4: Kernpaarungen rotieren je Phase; jede Erweiterungsrolle hat einen Kernanker, einen Auftrag an r−4 bzw. die Gegenkernrolle und einen Paarauftrag; Ersatzziele fallen auf ohnehin geführte Gespräche.
   - Durchgerechnet ergibt das höchstens 7 Gespräche je Kernrolle bei 20 Rollen und 2–4 je Erweiterungsrolle.
   - Die Lastprobe läuft als Tabelle über alle 17 Besetzungen × 3 Phasen.
   - Ein Gespräch dauert 4 Minuten; je Phase gibt es höchstens 10 Erzähler-Ansagen.
5. **Vorlesbarkeit für den KI-Erzähler:**
   - Feste Markertypen (BESETZT, PUNKTBAND, D-OPTION, E-OPTION, ANGEKLAGT), jeweils mit `[ENDE BEDINGUNG]` und ohne Verschachtelung.
   - Einschübe nur als ganze Sätze; Uhrzeiten in Worten; die Aussprache steht in einem eigenen Feld.
   - Zwischenresümees sind pfadneutral.
   - PRÜF-ERZ-VORLESE prüft mit allen Bedingungen an und aus.

**Weitere Risiken:**
- Alkohol-Drift, auch in Bildprompts: Stoppliste und Negativliste („non-alcoholic apple-cinnamon punch, ceramic mugs; no wine, goblets, tankards, bottles“).
- Herkunft und Schuld: Funktionsmatrix, damit keine Herkunftsgruppe mehr als eine belastete Funktion trägt.
- Engpass Abnahme: Opus-Prüfagent mit festem Raster.
- Container-Neustart: Push nach jedem Tag.

**Punktbänder (Vorschlag für K6):** Die Bandgrenzen 3|4 und 6|7 sind dieselben wie in der Endmatrix. Angeklagt wird nur innerhalb des verbleibenden Kreises (immer aus R1–4).

| Punkte | Verdächtigenkreis | Erzähler |
|---|---|---|
| 0–3 | 4 | neutrale Motivzusammenfassung |
| 4–6 | 3 | Schlüsselhinweis nur als Richtung |
| 7–8 | 2 | Schlüsselhinweis benannt |
| 9 | 2 | der entscheidende Widerspruch wird ausgesprochen |

## 4. Betriebsarchitektur (autonom)
**Ablage** unter `krimidinner/spuk-im-gewoelbe/`:

| Ordner | Inhalt |
|---|---|
| `00_steuerung/` | STATUS, PRUEFPUNKT, PLAN (Paketverzeichnis), REGISTER, BEFUNDE, FEHLER, ENTSCHEIDUNGEN, OFFENE-FRAGEN, MASTER-PROMPT |
| `10_kanon/` | K1–K9 als Zeilen-Datensätze mit Kennung und Sichtklasse je Feld; dazu SELBSTPRUEFUNG, PROTOKOLL, VERSION |
| `20_vorlagen/` | eine versionierte Vorlage je Pakettyp, dazu ABNAHME mit Fehlercode-Katalog |
| `30_pakete/`, `40_rueckgaben/`, `50_abnahmen/`, `60_freigaben/` | Paketlauf von Ausgabe bis Freigabe |
| `70_montage/` | die 7 Endprodukte |
| `90_werkzeug/` | interne Hilfen (siehe Standardannahme unten) |

**Standardannahme mit Opt-out:**
- Kleine interne Hilfsskripte setzen Kanon-Auszüge in die Pakete, zählen Mengen, prüfen die Ersatzziel-, Last- und Spiegelregeln und montieren byte-gleich.
- Sie sind Werkzeug und kein Endprodukt; alle Endprodukte bleiben Klartext.

**Regelkreis 1 (Paket)** läuft als Workflow-Pipeline je Tag:
1. Haiku (`model: haiku`) liest nur seine Paketdatei und schreibt die Rückgabe mit Endmarke.
2. Die Zählprüfung läuft.
3. Ein Opus-Prüfagent vergibt die Punkte A–H mit Fundstellenliste und Fehlercode.
4. Das Urteil folgt nach Abschnitt 14: Freigabe ab 14/16 ohne eine 0; eine 0 bei A, C oder F bedeutet Neuausgabe.
5. Höchstens zwei Reparaturrunden, danach schreibe ich die Stelle selbst.

Je Workflow laufen höchstens 2 Agenten gleichzeitig (4 CPUs); H1–H3 verteilen sich auf 1–2 parallele Workflows. Ich lese selbst: alle Eskalationen, offenen Fragen, Kanon-Befunde und Variantenwahlen sowie jede zehnte Freigabe als Stichprobe.

**Regelkreise 2–4:**
- **Welle:** PRÜF-Pakete über die ganze Welle; ich entscheide jeden Befund (Reparatur, verworfen oder ÄNDERUNG).
- **Tag:** Tagesabschluss mit Statuszeile, Pufferverbrauch und Prüfpunkt, danach Commit und Push.
- **Lernen:** Fehlercodes je Pakettyp. Tritt derselbe Code zweimal auf, wird die Vorlage zu vN+1 und das Protokoll vermerkt es.

**Varianten:** Ich wähle nach festen Kriterien (Vorlesedauer, Leitplanken, Ton) als markierte Standardannahme; du kannst in der ENTSCHEIDUNG-Runde umwählen.

**Probeläufe:**
- Haiku bekommt einen verdichteten Durchspiel-Auszug je Besetzung und Pfad (1,5–4 Tsd. Wörter).
- **BEST:** 9 Punkte bei maximal hinderlichen Rollen-Entscheidungen.
- **SCHLECHT:** 0 Punkte.
- **GEMISCHT:** 4–6 Punkte.
- Dazu drei Blindläufe ohne Lösung, die prüfen, ob die richtige Spur erkennbar, aber nicht offensichtlich ist.

**Montage:** Freigaben werden deterministisch zusammengefügt. MONT-Pakete schreiben nur Deckblätter, Verzeichnisse und Überleitungen; danach folgt das Endlektorat (LEKT).

## 5. Umsetzung nach Freigabe dieses Plans (Welle 0, Tage 1–2)
1. **Ablage anlegen:** Ordner anlegen, Master-Prompt, Entscheidungen und diesen Grobplan ablegen, committen und pushen.
2. **Kanon-Kern als Workflow:**
   - Drei unabhängige Opus-Kernentwürfe mit verschiedenen Schwerpunkten: Locked-Room-Logik, Figuren und Komik, Skalierung und Fair Play.
   - Jeder Entwurf deckt Täter, Motivverflechtung, Minutenleiste ab 23:30, alle Pflichtfragen, Beweisstücke und das Skelett der 9 Detektiv-Entscheidungen ab.
   - Parallele Richter bewerten die Entwürfe; ich wähle einen aus und übernehme die besten Teile der anderen.
3. **K1–K9 schreiben:**
   - Ich schreibe K1 und K7 und verbinde alles.
   - Opus-Unteragenten schreiben K2–K6, K8 und K9 nach meiner Vorgabe; K4 je Phase parallel nach dem Anker-Raster.
4. **Selbstprüfung:**
   - Werkzeug-Proben: Last, Ersatzziele, Spiegel, Absicherung je Besetzung, Zeitkollisionen.
   - Adversariale Opus-Prüfer: Lösungsweg, Gegenprobe, Fair Play, Pflichtfragen, Leitplanken.
   - Danach Korrekturen und **Kanon v1.0**.
5. **Feinplan und Vorlagen:** Feinplan mit 204 Paketen (Kennung, Typ, Abhängigkeit, Umfang, Sitzung, Tag), Stilblatt mit einer Musterkarte je Textsorte, Look-Bibel, Vorlagen und Paketbau-Hilfe. Ein Testbau eines Pakets je Typ beweist, dass der Bau funktioniert.
6. **Tagesabschluss der Tage 1–2:**
   - Antwort beginnt mit [ENTHÄLT LÖSUNG]; Push.
   - Aufforderung, den Kanon als eigenes Dokument zu speichern; ich schicke ihn zusätzlich als Datei.
   - Danach warte ich auf WEITER für die erste Charge (Tag 3, Design-Vorrang).

## 6. Prüfung
- **Kanon:** Alle sieben Selbstprüfungen bestehen. Die Werkzeug-Proben melden null Verstöße: jede der 17 Besetzungen lösbar mit mindestens 2 bzw. bei 20 Rollen mindestens 3 Hinweisen, Gesprächslast höchstens 8, jeder Gesprächskern mit Auftrag, Spiegelstück und Ersatzfall.
- **Pakete:** Für jeden Pakettyp gibt es einen Testbau ohne unaufgelöste Kennungen. L-Felder landen nie in Paketen mit „Lösung: nein“.
- **Ablage:** `git status` ist sauber, der Push erfolgreich, die App-Dateien sind unverändert (`git diff --stat` zeigt nur `krimidinner/`).

Du als Nächstes: Plan freigeben. Danach schreibe ich Welle 0 (Kanon, Selbstprüfung, Feinplan, Stilblatt, Look-Bibel) und melde mich mit dem Tagesabschluss.
