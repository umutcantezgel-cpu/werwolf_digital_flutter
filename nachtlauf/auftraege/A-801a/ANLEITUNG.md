# Burgstadt Schartenfels: Start und Steuerung

*Stand: Code im Branch `nachtlauf/burgstadt`, Commit d511fac. Zahlen in eckigen Klammern verweisen auf die Fußnoten am Ende.*

Du bist der Detektiv in einer nächtlichen Burgstadt. Die übrigen Rollen laufen als Bots. Drei Nachtphasen führen am Morgen zur Anklage.

## 1. Starten

- **Vorbereitung:** Flutter 3.47.6, Dart ab 3.13.5. Im Projektordner `flutter pub get`.[^45]
- **Android und iOS:** `flutter run` mit Gerät oder Emulator. Release-APK: `flutter build apk --release`. iOS-Builds gehen nur auf macOS.[^45]
- **Web:** `flutter config --enable-web`, dann `flutter build web --release --no-web-resources-cdn`. Die Ausgabe liegt in `build/web` und lässt sich mit jedem statischen Webserver lokal ausliefern.[^45]
- **Desktop:** nicht eingerichtet. Die Ordner für Windows, macOS und Linux fehlen. Sie entstehen mit `flutter create --platforms=windows,macos,linux`.[^45]
- Die App startet auf der Burgstadt-Seite. Entwicklereinstiege per Adresse: `?bs=fall` (sofort ein Fall), `?bs=erkundung` (freie Erkundung), `?bsmess=1` (Messwerte in der Konsole).[^46]

## 2. Hauptmenü

- **Allein spielen (Detektiv):** neuer Fall; alle anderen Rollen sind Bots. Unter **Besetzung** stellst du 4 bis 20 Rollen ein (Zweierschritte, Start 4).[^26][^29]
- **Fortsetzen:** nur sichtbar, wenn ein Spielstand existiert (Abschnitt 5).[^30]
- **Im WLAN spielen:** ohne Funktion. Es erscheint nur der Hinweis „WLAN-Spiel: siehe Mehrspieler-Menü der App.“[^28]
- **Optionen:** siehe Abschnitt 6.[^26]
- **Klassische Fälle:** öffnet die bisherige Mordakte-Startseite.[^27]

## 3. Steuerung

Touch: Linke Bildhälfte ziehen steuert das Gehen (der Joystick sitzt dort, wo der Daumen aufsetzt). Rechte Bildhälfte ziehen schaut um; kurzes Tippen rechts ist Aktion. Rechts unten liegen fünf Knöpfe: Aktion („Reden“, „Öffnen“, „Ansehen“ oder „Aktion“), Licht, Blick, Akte, Menü.[^15][^16][^19]

| Aktion | Touch | Tastatur, Maus | Gamepad |
|---|---|---|---|
| Vor, zurück | Joystick hoch, runter | W, S oder ↑, ↓[^1] | linker Stick oder Steuerkreuz ↑, ↓[^13] |
| Seitwärts | Joystick links, rechts | A, D[^2] | linker Stick oder Steuerkreuz ←, →[^13] |
| Rennen | nicht belegt[^49] | Umschalt[^4] | linker Stick drücken oder LB[^13] |
| Umsehen | rechte Hälfte ziehen[^17] | Maus ziehen; ←, → drehen[^3] | rechter Stick[^14] |
| Aktion | Aktionsknopf, oder kurz rechts tippen[^16] | E oder Leertaste; Mausklick ohne Ziehen[^5][^16] | A[^12] |
| Detektivblick | Knopf „Blick“[^19] | Q[^7] | Y[^13] |
| Licht | Knopf „Licht“[^19] | F oder L[^6] | X[^13] |
| Fallakte | Knopf „Akte“[^19] | Tab[^8] | Back (Select)[^13] |
| Menü, zurück | Knopf „Menü“[^19] | Esc, Rücktaste[^10] | Start (Menü), B (zurück)[^13] |
| Menüs | antippen | ↑, ↓, W, S oder Tab wählen; Enter oder Leertaste bestätigen[^11][^25] | Steuerkreuz wählt, A bestätigt[^13] |

- Ein Tipp zählt nur, wenn du auf demselben Knopf loslässt.[^25]
- Die Knöpfe der Fallakte (Reiter, Heften, Faden) gehen nur per Tippen oder Klick. Tastatur und Gamepad haben dort keinen Fokus.[^38]
- M und RB sind belegt, aber kein Bildschirm reagiert darauf.[^9]

## 4. Im Spiel

- **Erkunden:** Unter dem Fadenkreuz steht, was im Blick liegt (bis 1,5 m): Tür („Öffnen“), Ort oder Gegenstand („Ansehen“), Figur („Reden“). Türen öffnen nur in bestimmten Phasen.[^24]
- **Reden:** Eine Figur im Blick (bis 2,4 m) antwortet mit Sprechblase und Hinweiskarten. Eine Antwortauswahl gibt es nicht.[^35]
- **Untersuchen:** Aktion an einer Station bringt Funde. Ohne neuen Fund folgt eine Meldung oder eine Aussage.[^36]
- **Karten:** Hinweiskarten erscheinen links oben, höchstens drei zugleich. Tutorial-Karten kommen einmal je Anlass, bleiben sieben Sekunden und lassen sich antippen.[^33][^34]
- **Detektivblick:** entsättigt die Szene und zeigt Spuren. Die Spur in der Mitte wird benannt.[^37]
- **Fallakte:** Reiter „Fallakte“ (gemeinsame Akte) und „Meine Notizen“ (bekannt, nicht geheftet). „An die Akte heften“ nimmt einen Hinweis auf.[^38]
- **Fäden:** Erst den ersten Akte-Eintrag wählen und „Faden ziehen“ drücken, dann beim zweiten „Faden hierher“. Verbundene Einträge tragen ein „~“. Nur Einträge in der Akte lassen sich verbinden.[^40]
- **Teilen:** Im Solo-Spiel gibt es nur das Heften an die Akte. Weitergeben an einzelne Rollen ist im Code angelegt, aber nicht bedienbar.[^39]
- **Lagerunde:** öffnet sich am Ende jeder Phase. Die Rollen entscheiden selbst; du wählst bei deinen Entscheidungen A, B oder C. Nach Phase 3 folgt die Eingrenzung.[^41]
- **Anklage:** Du wählst eine Person aus dem Verdachtskreis. Ein Klick genügt, es gibt keine Rückfrage. Danach zeigt der Morgen eines von vier Enden und die Punkte (von 9).[^42]
- **Fall-Uhr** (oben links): läuft nur in der Erkundung, nicht in Menü, Fallakte, Pause, Lagerunde oder Anklage.[^32]

## 5. Speichern und Fortsetzen

- **Automatisch:** alle 60 Sekunden in der Erkundung und bei jedem Uhrturm-Schlag (Phasenbeginn, Lagerunde).[^31]
- **Von Hand:** Menü, dann „Speichern“ (nur mit laufendem Fall). „Hauptmenü“ speichert ebenfalls.[^23]
- **Fortsetzen:** stellt Fall, Ort und Blickrichtung wieder her. Passt der Stand nicht mehr zur Version, erscheint „Der Spielstand passt nicht mehr zu dieser Version.“[^30]
- **Achtung:** Ein neuer Fall überschreibt den alten Stand spätestens nach 60 Sekunden Erkundung. Gelöscht wird nie etwas. Nach einem beendeten Fall bietet „Fortsetzen“ den letzten Zwischenstand vor dem Ende an.[^30]

## 6. Optionen

Aufruf im Hauptmenü oder in der Pause. Die Optionen gelten nur bis zum nächsten Laden der Burgstadt-Seite; danach sind sie wieder Standard.[^44]

- **Bild:** sparsam (135), mittel (180) oder hoch (216) Pixel auf der kurzen Bildseite. Standard: mittel.[^43]
- **Sichtfeld:** +6° je Druck, Start 62°. Nach 80° springt es beim nächsten Druck auf 54°.[^43]
- **Kopfwippen, Flackern:** an oder aus, Standard an.[^43]
- **Neigen zum Umsehen:** ohne Wirkung.[^44]
- **Lautstärke:** 0 bis 10 in Zweierschritten, Start 8.[^43]
- **Tutorial:** aus heißt: keine Tutorial-Karten.[^43][^33]

## Fußnoten (Opus entfernt diesen Block)

[^1]: `lib/burgstadt/tasten.dart:6–8` (W, ↑ = hoch; S, ↓ = runter). Gehen: `packages/burgstadt_spiel/lib/src/steuerung.dart:78–79`, `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:154–155`.
[^2]: `lib/burgstadt/tasten.dart:9–10` (A = links, D = rechts); `packages/burgstadt_spiel/lib/src/steuerung.dart:80–81`.
[^3]: `lib/burgstadt/tasten.dart:11–12` (← = drehLinks, → = drehRechts); `packages/burgstadt_spiel/lib/src/steuerung.dart:85–86`; `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:149`. Maus-Blick: `packages/burgstadt_spiel/lib/src/steuerung.dart:34–39`.
[^4]: `lib/burgstadt/tasten.dart:22` (Umschalt = rennen); `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:151`.
[^5]: `lib/burgstadt/tasten.dart:13` (E = aktion), `21` (Leertaste = bestaetigen und aktion); `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:236`.
[^6]: `lib/burgstadt/tasten.dart:14` (F, L = licht); `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:227–231`.
[^7]: `lib/burgstadt/tasten.dart:15` (Q = blick); `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:232`, `281–284`.
[^8]: `lib/burgstadt/tasten.dart:16` (Tab = akte und tab); `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:214–217`; `packages/pixel_engine/lib/src/ui/pixel_ui.dart:94` (Fokus abwärts in Menüs).
[^9]: `lib/burgstadt/tasten.dart:17` (M = karte); `lib/burgstadt/gamepad_eingabe.dart:64` (RB = karte). Kein Bildschirm wertet `Taste.karte` aus: Suche in `packages/burgstadt_spiel/lib` ohne Treffer.
[^10]: `lib/burgstadt/tasten.dart:18–19` (Esc = menue und zurueck, Rücktaste = zurueck); `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:235` (öffnet Pause), `526` (schließt Pause); `packages/burgstadt_spiel/lib/src/bildschirme/fallakte.dart:35`; `packages/burgstadt_spiel/lib/src/bildschirme/optionen_bildschirm.dart:12`.
[^11]: `lib/burgstadt/tasten.dart:20–21` (Enter, Leertaste = bestaetigen); `packages/pixel_engine/lib/src/ui/pixel_ui.dart:161` (Knopf mit Fokus wird bestätigt).
[^12]: `lib/burgstadt/gamepad_eingabe.dart:53` (A = bestaetigen und aktion).
[^13]: `lib/burgstadt/gamepad_eingabe.dart:54` (B = zurueck), `55` (X = licht), `56` (Y = blick), `57` (Start = menue), `58` (Back = akte), `59–62` (Steuerkreuz), `63` (linker Stick drücken und LB = rennen), `64` (RB = karte); Kopfzeile `6–9`.
[^14]: `lib/burgstadt/gamepad_eingabe.dart:27–40` (Achsen), `68` (Totzone 0,18), `76–79` (linker Stick = Gehen, rechter Stick = Blick).
[^15]: `lib/burgstadt/burgstadt_ansicht.dart:132–135` (Zeiger mit Mauskennung), `158–167` (Touch, Maus, Mausrad).
[^16]: `packages/burgstadt_spiel/lib/src/steuerung.dart:21` (Joystick-Radius 26 px), `29` (Treffer auf Knöpfen zählen nicht), `30–33` (linke Hälfte = Joystick, nur Touch), `34–39` (rechte Hälfte = Blick), `54` (Touch-Tippen rechts: unter 6 px und 0,35 s), `55` (Mausklick unter 3 px); Joystick-Ausschlag `61–72`.
[^17]: `packages/burgstadt_spiel/lib/src/steuerung.dart:34–39` (Blick, auch für die Maus), `88–89` (Blick wird zu Drehen und Nicken).
[^19]: `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:449–476` (fünf Knöpfe rechts: Aktion `452–457` mit Beschriftung `454`; Licht `459`; Blick `464`; Akte `466–474`; Menü `476`).
[^23]: `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:536–549` (Pause: Weiter, Speichern, Optionen, Hauptmenü; „Speichern“ nur mit Fall in `536`; Hauptmenü speichert in `547`).
[^24]: `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:40` (Reichweite 1,5 m), `241–257` (Ziel im Blick), `311–367` (Aktion), `334–345` (Türen), `335–340` (Türsperre nach Phase), `402–407` (Fadenkreuz), `439–447` (Name unter dem Fadenkreuz).
[^25]: `packages/pixel_engine/lib/src/ui/pixel_ui.dart:55–56` (Navigation), `73–89` (Zeiger), `92–101` (Fokus mit Tasten), `152–160` (Knopf löst aus, wenn Drücken und Loslassen auf demselben Knopf liegen), `161` (Bestätigen).
[^26]: `packages/burgstadt_spiel/lib/src/bildschirme/hauptmenue.dart:46–55` (Einträge), `57–83` (Aktionen), `86` (Hinweistext „Tippen, klicken oder Pfeiltasten + Eingabe“).
[^27]: `packages/burgstadt_spiel/lib/src/bildschirme/hauptmenue.dart:80–81`; `lib/burgstadt/burgstadt_seite.dart:28–30` (`klassisch` führt nach `/`); `lib/app/router.dart:15` (`/` = Startseite der Mordakte).
[^28]: `packages/burgstadt_spiel/lib/src/bildschirme/hauptmenue.dart:52`, `75–77` (WLAN-Aktion und Hinweis); `lib/burgstadt/burgstadt_seite.dart:28–30` (nur „klassisch“ wird behandelt); `packages/burgstadt_spiel/lib/src/fallsitzung.dart:6–8` (Modi Gastgeber und Gast); `packages/burgstadt_core/lib/src/netz/burgstadt_raum.dart:19–29` (WLAN-Raum; kein Aufruf des Konstruktors außerhalb des Kerns).
[^29]: `packages/burgstadt_spiel/lib/src/bildschirme/hauptmenue.dart:47` (Anzeige), `83` (Schritte 4, 6 … 20, dann 4); `packages/burgstadt_spiel/lib/src/spiel.dart:87` (Start 4).
[^30]: `packages/burgstadt_spiel/lib/src/bildschirme/hauptmenue.dart:49`, `58–65` (Fortsetzen, Hinweis in `61`); `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:75–90` (speichern; kein Speichern nach dem Ende, `77`), `93–112` (fortsetzen); `lib/burgstadt/spielstand_prefs.dart:6` (Schlüssel `burgstadt_spielstand_v1`), `9–12`, `15` (`loesche`, nirgends aufgerufen); `packages/burgstadt_spiel/lib/src/fallsitzung.dart:47–50` (Schema und Prüfsumme).
[^31]: `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:193–195` (Uhrturm-Ereignis speichert), `203–204` (60 Sekunden); `packages/burgstadt_core/lib/src/fall/fall_zustand.dart:93` (Phasenbeginn), `221` (Lagerunde).
[^32]: `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:145` (Takt der Erkundung), `180` (Fallzeit läuft nur hier), `409` (Anzeige); `packages/burgstadt_spiel/lib/src/spiel.dart:211–214` (nur der oberste Bildschirm läuft).
[^33]: `packages/burgstadt_spiel/lib/src/spiel.dart:243–265` (Karte, Tippen zum Weiter in `264`); `packages/burgstadt_spiel/lib/src/texte.dart:53–58` (einmal je Auslöser; Option aus = keine Karte), `61` (sieben Sekunden), `68–69` (Wegklicken).
[^34]: `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:485–494` (Titel), `205–207` (höchstens drei), `188–190` (Ereignisse).
[^35]: `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:260–277` (Figur im Blick: 2,4 m, enger Winkel), `311–326` (Gespräch); `packages/burgstadt_core/lib/src/fall/simulation.dart:413–430` (Antwort aus öffentlichem Alibi und Mitteilungen, keine Auswahl).
[^36]: `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:346–363` (Stationen und Objekte; Meldungen in `357` und `362`).
[^37]: `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:281–284` (Umschalten), `287–302` (Spur bis 2,5 m), `436–438` (Anzeige); `packages/burgstadt_spiel/lib/src/spiel.dart:302–317` (Entsättigung und Spuren).
[^38]: `packages/burgstadt_spiel/lib/src/bildschirme/fallakte.dart:35` (Schließen), `37–39` (Auswahl, Mausrad), `43` (keine Menünavigation), `58`, `62`, `66` (Reiter, Zurück), `84` (Markierung „~“), `108–110` (An die Akte heften), `115–131` (Faden); `packages/pixel_engine/lib/src/ui/pixel_ui.dart:92` (kein Fokus ohne Navigation).
[^39]: `packages/burgstadt_spiel/lib/src/bildschirme/fallakte.dart:108–110` (einziger Aufruf aus der Oberfläche, `teile('DET', 'akte', …)`); `packages/burgstadt_spiel/lib/src/fallsitzung.dart:137–140` (Teilen an eine Rolle, ohne Aufruf aus der Oberfläche); `packages/burgstadt_core/lib/src/fall/fall_zustand.dart:197–205`; `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:190–192` (Hinweis „Dir erzählt“).
[^40]: `packages/burgstadt_spiel/lib/src/bildschirme/fallakte.dart:115–131`; `packages/burgstadt_core/lib/src/fall/fall_zustand.dart:208–215` (nur Akte-Einträge, kein Doppel).
[^41]: `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart:208–213` (öffnet die Lagerunde); `packages/burgstadt_spiel/lib/src/bildschirme/lagerunde.dart:20–32` (Meldekarten, Bots entscheiden), `51–61` (Weiter, Zur Eingrenzung), `70–93` (Ergebnis, Auswahl A, B, C).
[^42]: `packages/burgstadt_spiel/lib/src/bildschirme/anklage.dart:29–44` (Ende, Punkte in `34`, Hauptmenü in `43`), `51–57` (Verdachtskreis; Klick sofort gültig, `52–54`); `packages/burgstadt_core/lib/src/fall/fall_zustand.dart:304–312` (klageAn; Enden in `308`).
[^43]: `packages/burgstadt_spiel/lib/src/optionen.dart:5–12` (Standardwerte); `packages/burgstadt_spiel/lib/src/bildschirme/optionen_bildschirm.dart:27–36` (Einträge), `38–56` (Aktionen; Sichtfeld `41–43`, Lautstärke `50–51`); `packages/burgstadt_spiel/lib/src/skalierung.dart:4–7` (Stufen 135, 180, 216).
[^44]: `packages/burgstadt_spiel/lib/src/optionen.dart:14–34` (zuJson und ausJson ohne Aufrufer im Repo); `lib/burgstadt/burgstadt_ansicht.dart:32` (neues Spiel-Objekt je Ansicht). Neigen: `packages/burgstadt_spiel/lib/src/optionen.dart:8`, `packages/burgstadt_spiel/lib/src/bildschirme/optionen_bildschirm.dart:32`, `48–49`; keine Sensor-Auswertung im Repo (Suche nach DeviceOrientation, accelerometer, motion ohne Treffer).
[^45]: `README.md:3` (Android, iOS), `64–70` (Flutter 3.47.6; `flutter pub get`, `flutter run`, `flutter build apk --release`, `flutter build ios --release` nur auf macOS), `91–92` (Desktop nachrüsten); `pubspec.yaml:7` (Dart-SDK); `build.sh:17–20` (Web-Build ohne `--no-web-resources-cdn`, siehe Redaktionshinweise); `netlify.toml:2` (Ausgabe `build/web`); Repo-Wurzel mit `android/`, `ios/`, `web/`, ohne Desktop-Ordner.
[^46]: `lib/main.dart:67–74` (Einstiege; Standard `Routes.burgstadt` in `73`); `lib/app/router.dart:22` (Route `/burgstadt`); `lib/burgstadt/burgstadt_seite.dart:12–18` (Parameter `bs`); `lib/burgstadt/burgstadt_ansicht.dart:24`, `45–55` (`bsmess`), `67–74` (`fall`, `erkundung`).
[^49]: `packages/burgstadt_spiel/lib/src/steuerung.dart:21–55` (keine Rennlogik für Touch); Rennen nur über `lib/burgstadt/tasten.dart:22` und `lib/burgstadt/gamepad_eingabe.dart:63`.

## Redaktionshinweise für Opus (vor Übergabe entfernen)

- Der Quellpfad aus dem Auftrag `packages/burgstadt_spiel/lib/src/eingabe.dart` existiert nicht. Die Eingabe-Klasse liegt in `packages/pixel_engine/lib/src/ui/eingabe.dart`.
- Testbefehl ausgeführt: 49 Treffer (unter dem Limit 80), alle oben belegt.
- Tutorial-Texte (`packages/burgstadt_spiel/data/texte/tutorial.json`) widersprechen dem Code: T01 („WASD oder Pfeile laufen“: ← und → drehen nur). T05 („dann eine Antwort wählen“: keine Auswahl). T10, T11 und T12 („dort den Hinweis heften“, „Faden“, „teilen“ per Tastatur oder Gamepad: in der Fallakte gibt es dafür keinen Fokus, und ein Teilen-Knopf fehlt). T13 und T16 („E“ bzw. „Knopf Aktion“ zum Wählen: in Lagerunde und Anklage wirkt E nicht, und dort gibt es keinen Aktion-Knopf).
- Ohne Wirkung im Code: Taste „karte“ (M, RB); der Schalter „Neigen zum Umsehen“ (der Eingabe-Kommentar in `packages/pixel_engine/lib/src/ui/eingabe.dart:1, 22` nennt Neigen, es gibt aber keine Auswertung); `Optionen.blickEmpfindlichkeit` ohne Bedienelement.
- Optionen werden nicht gespeichert (`Optionen.zuJson` ohne Aufrufer). Der Spielstand wird nie gelöscht; nach dem Ende zeigt „Fortsetzen“ den letzten Zwischenstand (Fußnote 30).
- Web: Der Befehl mit `--no-web-resources-cdn` kommt aus dem Auftrag. `build.sh:20` nutzt ihn nicht. Flutter ist in dieser Umgebung nicht installiert, der Befehl ist daher nicht geprüft.
- Desktop: Die Plattformordner fehlen. Das README (Ausblick) nennt das Nachrüsten.
- Das README beschreibt die Mordakte (Android und iOS), nicht die Burgstadt. Die Start-Angaben stammen aus README, `pubspec.yaml`, `build.sh` und `netlify.toml`.
- Die Daten nennen fünf Enden-IDs (EM-1 bis EM-5 in `krimidinner/spuk-im-gewoelbe/10_kanon/K6-AUFLOESUNG.md`). Der Code setzt nur EM-1 bis EM-4 (`packages/burgstadt_core/lib/src/fall/fall_zustand.dart:308`). Die Anleitung nennt vier.
- WLAN: Die Burgstadt-Oberfläche hat keinen Einstieg in das WLAN-Spiel. `packages/burgstadt_spiel/lib/src/fallsitzung.dart` und `packages/burgstadt_core/lib/src/netz/burgstadt_raum.dart` sind nicht angebunden.
