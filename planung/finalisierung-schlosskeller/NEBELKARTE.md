# NEBELKARTE

Format: Risiko → Frühwarnzeichen → Gegenmaßnahme. Wirkung (W) und Unsicherheit (U) von 1 bis 3; Neubewertung an jedem Phasentor.

| Nr | Risiko | Frühwarnzeichen | Gegenmaßnahme | W | U |
|---|---|---|---|---|---|
| 1 | Kanon-Drift: App, Druck und Prompts erzählen Verschiedenes | Widersprüche in Prüfberichten | eine Quelle, alles erzeugt, Validator in jedem Testlauf | 3 | 2 |
| 2 | Ein Fix in einem Pfad bricht einen anderen | Plausibilitätsprüfer wird woanders rot | nach jeder Kanon-Änderung alle vier Pfade prüfen | 3 | 2 |
| 3 | Fall zu schwer oder zu leicht | bei perfektem Spiel bleiben zwei Verdächtige, oder die Gruppe löst ohne Detektiv | Hinweiswirkungen nachjustieren; Gegenprüfer sucht Abkürzungen | 3 | 2 |
| 4 | Zu viele Erzählertexte | Katalog wächst unkontrolliert | feste Fächer statt Volltexte | 2 | 2 |
| 5 | Lücken zwischen den Personenzahlen | Besetzungsprüfer rot | Besetzungsreihenfolge, Ersatzpartner, NPC-Karten | 3 | 2 |
| 6 | Spoiler am gemeinsamen Gerät | Spoiler-Prüfer findet Täterinfo vor dem Finale | getrennte Ansichten, Verdeckt-Schalter, neutrale Druckcodes, E-008 | 3 | 2 |
| 7 | Figuren im Dunkeln nicht unterscheidbar | Farbabstand unter Schwelle, Befunde des Sichtprüfers | Palette, Silhouetten, Merkmale schärfen | 2 | 3 |
| 8 | Ton kippt ins Brutale oder Klischeehafte | Befunde des Sensibilitätslesers | Ton-Leitfaden, Schneider überlebt, Humor-Momente | 3 | 2 |
| 9 | Stimme weicht vom Text ab | Wortgleich-Test rot | nur Bausteine vorlesen, sonst Text | 2 | 1 |
| 10 | Push nach main scheitert | abgelehnter Push oder Konflikte | holen, zusammenführen, neu testen, nie erzwingen; bei Schutzregel Pull Request | 3 | 2 |
| 11 | Bestand bricht | alte Tests rot | Partymodus getrennt, Regression an jedem Phasentor | 3 | 1 |
| 12 | Belastung ungleich, ein Pfad zu leicht | Fallrechner: Trefferquote je Pfad weicht stark ab | gleiche feste Belastung je Kernrolle (V-12), Simulator je Pfad | 3 | 2 |
| 13 | Web-Build lädt CanvasKit oder Schrift-Fallbacks aus dem Netz | E2E-Netzprüfung meldet fremde Hosts | `--no-web-resources-cdn`, Schriften im Projekt, Font-Fallback lokal | 2 | 2 |
| 14 | Git-Proxy lehnt Push auf `finalisierung-schlosskeller` oder main ab | Push-Fehler 403 | E-003: Sitzungsbranch, Pull Request, FÜR DEN NUTZER | 2 | 2 |
| 15 | Paralleler Design-Agent ändert dieselben Dateien | Merge-Konflikte beim Holen von origin | Partymodus in eigenen Dateien; vor jedem Tor holen und zusammenführen | 2 | 3 |
| 16 | Erschöpfender Simulator zu langsam oder unsound | CLI über 5 Minuten, Test über 60 Sekunden, oder ein Test bleibt grün, obwohl eine Sequenz F-06 verletzt | Zustand = (Pfad, aufgedeckte Fakten, Gruppenqualitäten) mit Memo; Restmenge als Funktion der Faktenmenge; nur die Endenmatrix hängt allein an Punkten und Anklage (E-013) | 2 | 2 |
| 17 | Haiku-Texte driften (erfundene Fakten, lange Sätze) | Textprüfer- und Kontinuitätsbefunde | geschlossene Kanon-Auszüge, Textprüfer vor Abnahme, höchstens 2 Nachbesserungen | 2 | 2 |
| 19 | Gruppe löst den Fall ohne Detektiv (Tischgespräche, wahre Hinweise) | Gegenprüfer oder Spieltest: Restmenge 1 ohne richtige Entscheidung | W-1, Pflichtgespräche pfadneutral, Rollenwissen nur zusammen mit Entscheidungsbeweisen entlastend | 3 | 2 |
| 20 | Haiku-Auftrag läuft über die Ausgabegrenze | Abbruch nach langer Laufzeit (L-02) | Aufträge teilen, Längengrenze, `effort: high` für Prüfungen (E-017) | 2 | 1 |
| 18 | Container-Neustart verliert Arbeitsstand | Neustart-Hinweis der Umgebung | häufige Commits, PRÜFPUNKT nach jedem Block, Werkzeugkette per Skript wiederherstellbar | 2 | 2 |

## Vorab-Scheitern (Angenommen, das Projekt ist gescheitert)
1. **Die vier Pfade widersprechen sich im Detail.** Frühwarnzeichen: Kontinuitätsbefunde nach F3. Gegenmaßnahme: Tatmatrix und Plausibilitätsprüfer zuerst, Texte nur aus Kanon-Auszügen.
2. **Die Gruppenwahl ist am Tisch langweilig oder durchschaubar.** Frühwarnzeichen: Gegenprüfer erkennt die Täterwahl. Gegenmaßnahme: Dilemma je Rolle aus Geheimnis oder Loyalität, Sabotage-Option für den Täter, Simulatorstatistik.
3. **Die App ist auf dem Handy schwer bedienbar.** Frühwarnzeichen: Spieltester-Befunde. Gegenmaßnahme: einfacher Ablauf, große Schaltflächen, Spielleiter-Modus.
4. **Der Druck ist unbrauchbar.** Frühwarnzeichen: Überlauf, falsche Codes. Gegenmaßnahme: Layout-Messung im Test, Druckprüfer mit gerenderten Seiten.
5. **Die Übergabe scheitert an der Umgebung.** Frühwarnzeichen: Push-Ablehnung. Gegenmaßnahme: E-003, früher Probe-Push am F0-Tor.
