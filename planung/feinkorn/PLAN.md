# FEINKORN · PLAN (K0-Fassung, vor der Plan-Schleife)

Rollen: OPUS = Orchestrator (Stufe 3), sonst Haiku (Stufe 1–2). „nach“ = Abhängigkeit. Jede Zeile ist ein Auftrag nach AUFTRAGSVORLAGE. Varianten-Regel: ★ (2–3 Haiku parallel, Wahl nach dokumentierten Kriterien). Gemeinsame Werte (Blockgrößen, Materialtabelle, BUDGET, Physikwerte, SZENENVERTRAG) schreibt nur OPUS.

## K0 – Messbasis, Prototypen, Gesamtplan (Tor: Planungsordner vollständig, Plan-Schleife abgeschlossen, Push)
| Kennung | Rolle | Gegenstand | nach |
|---|---|---|---|
| K0-OPUS-01 | OPUS | Ordner/Branch, Messwerkzeuge (bestand.dart, messen.mjs), Browser-Messbasis | – |
| K0-KUNDSCHAFTER-01 | Kundschafter | Bestandsliste aller Bilder und Grafiken (BESTAND-BILDER.md) | – |
| K0-KUNDSCHAFTER-02 | Kundschafter | Kanon-Auszug Figuren/Räume/Gegenstände (KANON-AUSZUG.md) | – |
| K0-DOKUMENTAR-01 | Dokumentar | ABNAHME-Entwurf K-01…K-16 | – |
| K0-OPUS-02 | OPUS | Prototyp Darstellung A/B/C, Testraum, Messung | K0-OPUS-01 |
| K0-OPUS-03 | OPUS | Prototyp Physik (Kerzenständer, Krümel, Staub, Determinismus) | K0-OPUS-02 |
| K0-OPUS-04 | OPUS | Prototyp Bewegung (Skelett, Gelenkwege, Lückenprüfung) | K0-OPUS-02 |
| K0-TESTSCHREIBER-01 | Testschreiber | Tests Blockdaten + Trennungsprüfung | K0-OPUS-02 |
| K0-LEISTUNGSPRUEFER-01 | Leistungsprüfer | Teststand, Größen, Bestandsbild (MESSBASIS.md) | K0-OPUS-01 |
| K0-OPUS-05 | OPUS | Entscheidungen, BUDGET, SZENENVERTRAG, PLAN, Rollenbriefings, Nebelkarte | K0-OPUS-02..04 |
| K0-GEGENPRUEFER-01..03 | Gegenprüfer | Plan-Schleife (je Runde ein Angriff, ≤ 3 Runden) | K0-OPUS-05 |

## K1 – Fundament (Tor K-02, K-03)
| Kennung | Rolle | Gegenstand | nach |
|---|---|---|---|
| K1-OPUS-01 | OPUS | Blockdaten final: Abschnitte, kompaktes verlustfreies Format (Tafel + Lauflänge), Rezeptformat v1, Laden/Speichern | K0 |
| K1-OPUS-02 | OPUS | Backofen v2: abschnittsweise Nachbarschaft ohne Closures, Isolate-fähig, Backskala/Detailstufen mit Überblendung, Kantenabrieb, Glanzkante, Schattenkarte ohne Akne | K1-OPUS-01 |
| K1-OPUS-03 | OPUS | App-Anschluss: `lib/game/feinkorn/` Schicht + Haken in MordakteGame, Sprites in der Tiefensortierung, Lichtschicht/Nebel, Schalter (MetaStore), Vorschau `feinkorn_vorschau_main.dart` | K1-OPUS-02 |
| K1-OPUS-04 | OPUS | Geräteklassen: Einstufung (Backzeit + Bildzeit beim Start), Budget als Code, Herunterstufen | K1-OPUS-03 |
| K1-MATERIALMACHER-01 | Materialmacher | Oberflächenmuster Stein: Sandstein, Kalkmörtel | K1-OPUS-01 |
| K1-MATERIALMACHER-02 | Materialmacher | Oberflächenmuster Holz/Metall: Eiche (Faser), Eisen, Messing | K1-OPUS-01 |
| K1-MATERIALMACHER-03 | Materialmacher | Oberflächenmuster Glas, Wachs, Porzellan, Papier | K1-OPUS-01 |
| K1-MATERIALMACHER-04 | Materialmacher | Oberflächenmuster Stoffe, Leder, Ruß, Staub, Erde | K1-OPUS-01 |
| K1-BAUMEISTER-01 | Baumeister | Große synthetische Welt in Abschnitten, Durchquerung, Speicherkurve (K-02.3) | K1-OPUS-01 |
| K1-BAUMEISTER-02 | Baumeister | Szene mit drei Blockgrößen (K-02.1) | K1-OPUS-03 |
| K1-TESTSCHREIBER-01 | Testschreiber | Speichern/Laden Block für Block, Abschnitte, Rezepte | K1-OPUS-01 |
| K1-LEISTUNGSPRUEFER-01 | Leistungsprüfer | Flimmerprüfung (E-F016) als Werkzeug, Kantenschärfe je Pixeldichte | K1-OPUS-03 |
| K1-SICHTPRUEFER-01 | Sichtprüfer | Lichtarten-Fotos (7.3) und Kantenschärfe | K1-OPUS-03 |
| K1-BESTANDSWAECHTER-01 | Bestandswächter | Bestandsprüfung + Dateihoheit K1 | K1-OPUS-04 |
| K1-GEGENPRUEFER-01 | Gegenprüfer | Angriff Darstellung/Schalter | K1-OPUS-04 |

## K2 – Physik und Prüfstand (Tor K-05, K-01)
| Kennung | Rolle | Gegenstand | nach |
|---|---|---|---|
| K2-OPUS-01 | OPUS | Körper gegen Körper, Stapel, Schlaf, Grenzwerte | K1 |
| K2-OPUS-02 | OPUS | Bruch je Material (Faser, Scherben, Kanten, Krümel), Ablagerung als Weltblöcke, Schüttgut/Böschung | K2-OPUS-01 |
| K2-OPUS-03 | OPUS | Nachschwingende Kleidung, Kordeln, Haare (Ketten an Knochen, Körperkollision) | K2-OPUS-01 |
| K2-VARIANTE-01..03 ★ | Materialmacher | Look von Dreck und Splittern (drei Vorgaben) | K2-OPUS-02 |
| K2-BAUMEISTER-01 | Baumeister | Klang-Synthese je Klangfamilie, Abspielen über audioplayers | K1 |
| K2-BAUMEISTER-02 | Baumeister | Prüfstand-Einstieg `feinkorn_pruefstand_main.dart`: Kisten, Krüge, Sandhaufen, Holzwand | K2-OPUS-02 |
| K2-PHYSIKTESTER-01 | Physiktester | Fallzeit, Determinismus 100 ×, Bildraten 30/60/120 | K2-OPUS-01 |
| K2-PHYSIKTESTER-02 | Physiktester | Stapel 10 Kisten 60 s (≤ 1 mm) | K2-OPUS-01 |
| K2-PHYSIKTESTER-03 | Physiktester | Bruch-Bildfolgen Holz/Glas/Stein/Wachs | K2-OPUS-02 |
| K2-PHYSIKTESTER-04 | Physiktester | Ablagerung, Böschungswinkel (≤ 5°) | K2-OPUS-02 |
| K2-BESTANDSWAECHTER-01 | Bestandswächter | Release-Prüfung (Werkzeuge nicht im Store-Build), Bestandsprüfung | K2-BAUMEISTER-02 |
| K2-GEGENPRUEFER-01 | Gegenprüfer | Physik-Angriff (Tunneln, Explosion, Partikelflut) | K2-OPUS-03 |

## K3 – Bewegung und Figuren (Tor K-06, K-07)
| Kennung | Rolle | Gegenstand | nach |
|---|---|---|---|
| K3-OPUS-01 | OPUS | Figuren-Baukasten (Kanon-Felder look/visualSpecs/colorCode, Statur aus Zusatzwerten, Kleidungsschichten, Zubehör, Bearbeitungsschritte) | K2 |
| K3-OPUS-02 | OPUS | Animation: Zustände, Übergänge, Fußfixierung, Gelenkgrenzen, Vorbacken je Richtung (LRU) | K3-OPUS-01 |
| K3-OPUS-03 | OPUS | Wegfindung und Ausweichen | K3-OPUS-02 |
| K3-VARIANTE-01..03 ★ | Figurenbauer | Gesichtsstil (drei Vorgaben), Mimik-Zustände | K3-OPUS-01 |
| K3-FIGURENBAUER-01..23 | Figurenbauer | je Figur Rezept + Figurenblatt (4 Ansichten, 6 Posen): 20 Rollen, Detektiv m und w, Herr Schneider | K3-VARIANTE |
| K3-ANIMATOR-01..08 | Animator | Zustände (8) und Ruhe-Animationen aus `idleAnimation` (22) in Gruppen | K3-OPUS-02, Figurenblatt |
| K3-BAUMEISTER-01 | Baumeister | Kanon-Abgleich ΔE2000 und Merkmalsliste je Figur | K3-OPUS-01 |
| K3-TESTSCHREIBER-01 | Testschreiber | Lückenprüfung alle Posen, Fußgleiten ≤ 1 cm, Gelenksprung ≤ 25°, Stillstand bewegt | K3-OPUS-02 |
| K3-SICHTPRUEFER-01..03 | Sichtprüfer | Figurenblätter, gedimmtes Licht, je Klasse (3 Stimmen) | K3-FIGURENBAUER |
| K3-GEGENPRUEFER-01 | Gegenprüfer | Wiedererkennbarkeit, Kanon-Treue | K3-SICHTPRUEFER |

## K4 – Räume und Materialien (Tor K-08, K-09)
| Kennung | Rolle | Gegenstand | nach |
|---|---|---|---|
| K4-OPUS-01 | OPUS | Architektur-Baukasten: Quader mit Fugen, Gewölbe, Bögen, Stufen, Türen mit Beschlägen, Bänke, Theke, Lichtschächte, Alterungsdurchgänge | K1 |
| K4-VARIANTE-01..03 ★ | Raumbauer | Sandstein-Gewölbe (drei Vorgaben) | K4-OPUS-01 |
| K4-RAUMBAUER-01..08 | Raumbauer | Eingang mit Stufen/Windfang, Thekensaal, West-Saal mit Kamin, Ost-Saal, Vorratsraum, Durchgang, Turmgang (Wendeltreppe, Toiletten), Schlossfassade bei Nacht | K4-VARIANTE |
| K4-BAUMEISTER-01..06 | Baumeister | Ausstattung: Theke (Samoware, Kannen, Gläser, Bretter), Buffets, Kamin-Nische, Bänke/Tafeln, Jackenständer mit Jacken, Turmtür beschädigt, Rüstung, Vitrine, Lichtschächte, Notausgangsschild | K4-OPUS-01 |
| K4-BAUMEISTER-07..10 | Baumeister | 28 Indizien in Indiz-Blockgröße | K4-OPUS-01 |
| K4-MATERIALMACHER-05 | Materialmacher | Alterung: Kantenabrieb, Feuchte, Ruß, Staub in Ecken | K4-OPUS-01 |
| K4-TESTSCHREIBER-01 | Testschreiber | Maßabgleich ±2 cm, Detailprüfung (keine Fläche > 0,25 m² ohne Variation), Helligkeit 20–25 % | K4-RAUMBAUER |
| K4-SICHTPRUEFER-01..03 | Sichtprüfer | Detail-Checkliste je Raum, 4×-Nahaufnahmen (3 Stimmen) | K4-RAUMBAUER |
| K4-GEGENPRUEFER-01 | Gegenprüfer | Stimmung, Kanon-Lage | K4-SICHTPRUEFER |

## K5 – Verzahnung und Verschärfung (Tor K-10, K-11)
| Kennung | Rolle | Gegenstand | nach |
|---|---|---|---|
| K5-OPUS-01 | OPUS | Szenenvertrag final, Kanon-Adapter, Merge F4 des Finalisierungs-Laufs | K3, K4 |
| K5-OPUS-02 | OPUS | Story-Physik je Pfad, Rückblende deterministisch (Tatmatrix) | K5-OPUS-01 |
| K5-BAUMEISTER-01 | Baumeister | Taschenlampe mit Schattenmaske | K5-OPUS-01 |
| K5-BAUMEISTER-02 | Baumeister | Seifenblasen (aufsteigen, an Wänden platzen) | K5-OPUS-01 |
| K5-BAUMEISTER-03 | Baumeister | Spuren je Pfad (Scherben, Splitter, Ruß, Wachs) | K5-OPUS-02 |
| K5-DOKUMENTAR-01 | Dokumentar | Vorher-nachher-Paare je Raum und Figur | K5-OPUS-01 |
| K5-SICHTPRUEFER-01..03 | Sichtprüfer | Paare bewerten (Lesbarkeit nie schlechter) | K5-DOKUMENTAR-01 |
| K5-GEGENPRUEFER-01 | Gegenprüfer | Spoiler-Schutz, F-Kriterien | K5-OPUS-02 |

## K6 – Handyschonung, Geräte und Werkzeuge (Tor K-04, K-12, K-13; alle Kriterien erneut)
| Kennung | Rolle | Gegenstand | nach |
|---|---|---|---|
| K6-OPUS-01 | OPUS | Ruhemodus, Hintergrund ohne Rechnen, Herunterstufen, reduzierte Bewegung | K5 |
| K6-BAUMEISTER-01 | Baumeister | Modellschau (Drehteller, Lichtvorlagen, Blockgrößen, Material-Ansicht) | K5 |
| K6-BAUMEISTER-02 | Baumeister | Bild-zu-Block-Wandler (Werkzeug außerhalb der App) | K1 |
| K6-DOKUMENTAR-01 | Dokumentar | Anleitung „Pixel-Bausteine in einem neuen Spiel nutzen“ | K5 |
| K6-KUNDSCHAFTER-01 | Kundschafter (ohne Vorwissen) | Mini-Szene nach Anleitung (Protokoll) | K6-DOKUMENTAR-01 |
| K6-LEISTUNGSPRUEFER-01..03 | Leistungsprüfer | Budgets je Klasse, 30-min-Dauerlauf, Speicherkurve, Ladezeit | K6-OPUS-01 |
| K6-SICHTPRUEFER-01 | Sichtprüfer | hochkant/quer je Klasse, Lesbarkeit | K6-OPUS-01 |
| K6-GEGENPRUEFER-01 | Gegenprüfer | Gesamtangriff | K6-LEISTUNGSPRUEFER |

## K7 – Integration auf main (Tor K-14, K-15, K-16)
| Kennung | Rolle | Gegenstand | nach |
|---|---|---|---|
| K7-OPUS-01 | OPUS | Freigabe prüfen (Tag schlosskeller-1.0 oder „weiter“); bis dahin Vorrat | K6 |
| K7-OPUS-02 | OPUS | origin/main herein, Feinkorn Standard, alle Tests, Bestands-/Release-Prüfung | K7-OPUS-01 |
| K7-DOKUMENTAR-01 | Dokumentar | Abschlussbericht, Galerie, FÜR DEN NUTZER final | K7-OPUS-02 |
| K7-BESTANDSWAECHTER-01 | Bestandswächter | Schlussprüfung Bestand, Netz, Lizenzliste | K7-OPUS-02 |
| K7-GEGENPRUEFER-01 | Gegenprüfer | Bericht angreifen | K7-DOKUMENTAR-01 |
| K7-OPUS-03 | OPUS | Secret-Scan, Merge auf main, Tag feinkorn-1.0, Remote-Prüfung | K7-GEGENPRUEFER-01 |

## Vorrat (bei Blockaden, nie Füllstoff)
Zusätzliche Physik-Messszenen · Gegenproben älterer Pakete · weitere Materialvarianten · Detailstufen-Feinschliff · Backzeit-Optimierung · zusätzliche Figurenposen.

Aufträge gesamt (ohne Vorrat): 139 – K0 13 · K1 15 · K2 14 · K3 43 · K4 28 · K5 10 · K6 10 · K7 6 (Zeilen mit „01..03“ zählen einzeln).
