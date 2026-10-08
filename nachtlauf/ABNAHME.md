# ABNAHME – Nachtlauf „Spuk im Gewölbe – Burgstadt“

Abgehakt wird nur mit Beleg (Testausgabe, Bildpfad, Commit). `dart run tool/abnahme.dart` rechnet die messbaren Kriterien nach; nur dieses Werkzeug darf „ZIEL ERREICHT“ ausgeben. Kein Kriterium wird still abgesenkt.

| ID | Kriterium (wörtlich nach Master-Prompt §11) | Status | Beleg |
|---|---|---|---|
| Z-01 | Bestand: Alles aus der Funktionsliste von Phase 0 funktioniert oder ist begründet ersetzt; alle früheren Tests grün. | offen | Ausgangswerte: `nachtlauf/belege/phase0_ausgangstests.txt` |
| Z-02 | Pixel: Blocktest und Palettentest bestehen in Bildschirmfotos aller Viertel, von zehn Innenräumen und aller Menüs; alle Figuren haben dieselbe Pixeldichte. | offen | |
| Z-03 | Figuren: 20 Rollen und mindestens 40 Stadtbewohner mit acht Richtungen und allen Animationen; Sprite-Prüfung ohne Fehler; Porträts mit vier Ausdrücken; in der Figuren-Aufstellung finden zwei unabhängige Sichtprüfer keine verwechselbaren Silhouetten. | offen | |
| Z-04 | Stadt: sechs Viertel, mindestens 150 Gebäude, mindestens 40 betretbare Innenräume, davon 12 Fall-Orte, Keller- und Gangnetz, Wehrgang; Erkundungsbots erreichen jede Tür, niemand steckt fest. | offen | |
| Z-05 | Blicke: Der Detektivblick zeigt mindestens sieben Spurenarten, die andere Rollen nicht sehen; jede andere Rolle hat mindestens eine exklusive Sichtschicht oder Fähigkeit; Tests belegen die Sichtregeln je Rolle. | offen | |
| Z-06 | Teilen: Jeder Hinweis lässt sich an Einzelne oder an die Fallakte teilen; im Mehrspielertest sehen alle Empfänger ihn binnen einer Sekunde; Bot-Teams mit Teilen brauchen mindestens 30 Prozent weniger Schritte bis zur Lösung als Teams ohne. | offen | |
| Z-07 | Fall: Einführung, drei Phasen und Auflösung vollständig in der Stadt spielbar; Gespräche, Entscheidungen, Punkte und Endmatrix korrekt; der Löser bestätigt die Lösbarkeit für jede Rollenzahl von 4 bis 20. | offen | Kanon-Ausgang: `kanon.py pruefe` 0 Befunde (phase0_ausgangstests.txt) |
| Z-08 | Spielweisen: allein mit Bots in allen Rollen spielbar; simulierter Mehrspieler mit 4, 8 und 20 Teilnehmern ohne Abweichungen; Bots füllen fehlende Rollen. | offen | |
| Z-09 | Leistung: Spiellogik bei vierfach gedrosseltem Prozessor im Mittel höchstens 4 Millisekunden pro Bild; Nachladespitzen höchstens 50 Millisekunden; nach 20 Minuten Erkundung wächst der Speicher um höchstens 10 Prozent; Zeichenaufrufe im Budget jeder Qualitätsstufe. | offen | Messung als Näherung: Desktop-CPU + Faktor 4 bzw. Chrome-CDP-Drosselung (keine Handy-Hardware im Container) |
| Z-10 | Geräte: automatisierte Durchläufe auf Handy hoch, Handy quer und Computer ohne Darstellungs- oder Bedienfehler; Touch, Tastatur mit Maus und Gamepad vollständig. | offen | |
| Z-11 | Stabil: keine Fehler in der Konsole während aller automatisierten Durchläufe; Speichern und Fortsetzen funktionieren. | offen | |
| Z-12 | Inhalt: Gegenprüfer-Bericht bestätigt alle Leitplanken aus Abschnitt 3; alle Texte stimmen mit dem Kanon überein; nichts ist kopiert. | offen | |
| Z-13 | Lokal: kein Push (außer Sicherungs-Branch `nachtlauf/burgstadt`, Nutzerentscheidung N-00), keine Laufzeitabrufe fremder Server – belegt durch Netzwerkprüfung und den lokalen Verlauf. | offen | |
| Z-14 | Übergabe: Morgenbericht, Abschlussbericht mit Bildschirmfotos und Figuren-Aufstellung, Start- und Steuerungsanleitung, Liste FÜR DEN NUTZER mit allem, was nur Menschen prüfen können. | offen | |

## Funktionsliste Bestand (Phase 0, Grundlage für Z-01)
Mordakte (bleibt als Modus „Klassische Fälle“):
- Hub (Bento, Fall des Tages, Streak, Rang, Namensdialog, Rückkehr in Online-Raum), Fallakten (Story/Zufall/Tagesfall), Lobby (Klasse/Mantel/Hut, KI-Partner, Host-Konfiguration), Online (Raum erstellen/beitreten, Server-URL), Profil, Sammlung.
- Spiel: isometrische Szene (Flame), Joystick/WASD/Aktionsknopf, HUD, Intro, Ermittlung, Beratung, Nacht mit Schatten, Anklage, Ende mit Urteil/XP; Verhör mit Themen, Beweis vorlegen, Lügenmarke; Notizbuch/Beweiswand/Kombinieren; Signale, Minikarte, Toasts; Niedergeschlagen/Geist.
- Engine (`packages/mordakte_core`): Phasen, Hinweise (Labor/Zeit/verpassbar), Klassen, Effekte, Items, Schatten-KI, Bots, Fall-Generator (24 Varianten je Szenario), Enden, Datenschutz pro Spieler.
- Online-Server (`server/`), Online-Session mit Reconnect, Offline-Solo (LocalSession), Meta (XP, Ränge, Achievements, Sammlung).
- Entwickler-Einstiege `?autoplay=`, `?speed=`, `?fake=`, `?screen=`; Werkzeuge `validate`, `simulate`.
- Tests: `packages/mordakte_core` 22 Tests grün; Server-Smoke 63 OK; `validate` 4× OK; `simulate` alle Szenarien bis zum Ende; `flutter analyze` sauber; `kanon.py pruefe` 0 Befunde (1207 Datensätze).
- Bestandsfotos: `nachtlauf/bilder/bestand/` (12 Bilder).
