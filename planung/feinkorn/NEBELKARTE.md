# FEINKORN · Nebelkarte (Risiko → Frühwarnzeichen → Gegenmaßnahme; Stand K0)

1. Technik trägt etwas nicht → Prototyp scheitert → beste Lösung im Bestand, Grenze unter FÜR DEN NUTZER. Stand: Darstellung A trägt (60 B/s); Schatten bewegter Lichter nur genähert (E-F006).
2. Handys heiß / Akku → Rechenlast ruhig hoch → Ruhemodus (Blitten gebackener Bilder), Geräteklassen, gebackenes Licht, Herunterstufen. Grenze: Wärme im Container nicht messbar → Testplan.
3. Zu viele Blöcke für einfache Geräte → Budget verfehlt → größere Blöcke, halbe Backskala, Backen nach Bedarf, notfalls bisherige Darstellung.
4. Lücken an Gelenken → Lückenprüfung rot → Rückabtastung + Gelenkkugeln (8/8 geschlossen gemessen).
5. Physik zittert/explodiert → Energie wächst → feste 120 Hz, Schlaf, Grenzwerte, Messszenen. Offen: Körper gegen Körper (K2).
6. Partikelflut → Bildzeit bricht ein → Partikel-Pool mit Budget, Ablagerung.
7. Flimmern beim Schwenken → Flimmerprüfung rot → Backen in Bildpixeln, ganzzahlige Lage, Detailstufen (E-F016).
8. App zu groß → Zuwachs > 3 MB → Rezepte statt Modelle, Klänge synthetisiert.
9. Bestand bricht → alte Tests rot / Bestandsbild weicht ab → Bestandsprüfung (tool/feinkorn/bestand.dart), Schalter, Regression an jedem Tor.
10. Werkzeuge im Store-Build → Release-Prüfung rot → Werkzeuge nur in `lib/game/dev/feinkorn_*_main.dart` und `packages/*/bin`.
11. Konflikt mit dem Finalisierungs-Lauf → Merge-Konflikte / rote F-Kriterien → eigener Ordner, Dateihoheit (E-F012), nur ein kleiner Haken in mordakte_game.dart, Merge nur herein an Toren.
12. Stimmung verloren → Helligkeit außerhalb 20–25 % → Messwert je Raum (E-F018), Alterungsdurchgänge.
13. Figuren unkenntlich → Kanon-Abgleich rot → Baukasten liest Kanon, Figurenblatt vor Animation.
14. (neu) Backzeit auf Handys zu lang → erstes Bild > 0,4 s oder Raum > Budget → Backofen v2 ohne Closures, Isolate, Backen nach Bedarf, halbe Backskala; AOT-Messung zeigte JIT schneller als AOT (Closures) → K1-OPUS-02.
15. (neu) Schattenkarten-Artefakte (Punkte in beleuchteten Quadern) → Sichtprüfer-Befund → Normalenversatz, Fußabdruck, ggf. Mehrfachabtastung (K1-OPUS-02).
16. (neu) F4 des Finalisierungs-Laufs ändert MordakteGame stark → Merge-Konflikt am Haken → Haken minimal halten, an jedem Tor gegen deren Stand mergen.
