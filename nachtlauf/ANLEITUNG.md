# Burgstadt Schartenfels: Start und Steuerung

Du ermittelst als Detektiv (das Geburtstagskind) in einer nächtlichen, verschlossenen Burgstadt. Allein übernehmen Bots alle anderen Rollen; im WLAN spielen Freundinnen und Freunde die Rollen. Drei Nachtphasen, die der Uhrturm anschlägt, führen am Morgen zu Eingrenzung, Anklage und einem von vier Enden.

## 1. Starten

- **Vorbereitung:** Flutter 3.47.6 (Dart ab 3.13.5). Im Projektordner `flutter pub get`.
- **Android und iOS:** `flutter run` mit Gerät oder Emulator. Release-APK: `flutter build apk --release`. iOS-Builds gehen nur auf macOS.
- **Web:** `flutter build web --release --no-web-resources-cdn` → `build/web` mit einem statischen Webserver lokal ausliefern (keine Abrufe fremder Server).
- **Desktop:** noch nicht eingerichtet (`flutter create --platforms=windows,macos,linux` legt die Ordner an).
- Die App startet direkt in der Burgstadt. „Klassische Fälle“ im Hauptmenü führt zur bisherigen Mordakte.

## 2. Hauptmenü

- **Allein spielen (Detektiv):** neuer Fall, alle anderen Rollen sind Bots. Unter **Besetzung** stellst du 4 bis 20 Rollen ein.
- **Fortsetzen:** erscheint, wenn ein Spielstand da ist (Abschnitt 6).
- **Im WLAN spielen:** Abschnitt 5.
- **Optionen:** Abschnitt 7.
- **Klassische Fälle:** die bisherige Mordakte.

## 3. Steuerung

**Touch:** Die linke Bildhälfte ziehen steuert das Gehen; der Joystick sitzt dort, wo der Daumen aufsetzt. Die rechte Bildhälfte ziehen schaut um, ein kurzer Tipp rechts löst die Aktion aus. Rechts unten liegen die Knöpfe Aktion („Reden“, „Öffnen“, „Ansehen“), Licht, Blick, Akte und Menü.

| Aktion | Touch | Tastatur, Maus | Gamepad |
|---|---|---|---|
| Vor, zurück | Joystick hoch, runter | W, S oder ↑, ↓ | linker Stick oder Steuerkreuz ↑, ↓ |
| Seitwärts | Joystick links, rechts | A, D | linker Stick oder Steuerkreuz ←, → |
| Drehen, umsehen | rechte Hälfte ziehen | Maus ziehen; ←, → drehen | rechter Stick |
| Rennen | – | Umschalt | linken Stick drücken oder LB |
| Aktion (reden, öffnen, ansehen) | Aktionsknopf oder kurz rechts tippen | E oder Leertaste | A |
| Detektivblick | Knopf „Blick“ | Q | Y |
| Handylicht | Knopf „Licht“ | F oder L | X |
| Fallakte | Knopf „Akte“ | Tab | Back (Select) |
| Stadtkarte | Menü → „Stadtkarte“ | M | RB |
| Menü, zurück | Knopf „Menü“ | Esc, Rücktaste | Start, B |
| In Menüs wählen | antippen | ↑, ↓ wählen; Enter oder Leertaste bestätigen | Steuerkreuz wählt, A bestätigt |

## 4. Im Spiel

- **Erkunden:** Unter dem Fadenkreuz steht, was du im Blick hast: eine Tür („Öffnen“), einen Ort oder Gegenstand („Ansehen“) oder eine Figur („Reden“). Manche Türen schließt der Burgwart erst in einer späteren Phase auf; die Oberstadt öffnet sich mit Phase 2.
- **Reden:** Eine Figur in der Nähe antwortet mit Sprechblase und Hinweiskarten. Stadtbewohner erzählen aus ihrer Nacht.
- **Untersuchen:** Aktion an einer Station bringt Funde. Jede Rolle findet anderes.
- **Detektivblick:** Die Szene wird entsättigt, Spuren leuchten (Fußspuren, Fingerabdrücke, Staub, Wachs, Schleifspuren, Fasern, verwischte Abdrücke). Die Spur in der Mitte wird benannt.
- **Stadtkarte und Kompass:** Draußen zeigt ein Kompass die Himmelsrichtung. Die Karte zeigt die Oberstadt mit deinem Standort; besuchte Häuser sind farbig, unbesuchte Fall-Orte zeigen „?“. Ab Phase 2 bringt ein Tipp auf einen besuchten Fall-Ort dich direkt vor seine Tür; mit Tastatur oder Gamepad wählst du mit den Pfeilen und bestätigst mit Enter oder A.
- **Fallakte:**
  - Es gibt zwei Reiter: **Fallakte** ist die gemeinsame Akte, **Meine Notizen** enthält, was du weißt und noch nicht geheftet hast.
  - Mit Tastatur oder Gamepad: Links und rechts wechselt den Reiter, hoch und runter wählt einen Eintrag.
  - **An die Akte heften:** In „Meine Notizen“ mit Enter oder A heften. Alle sehen den Hinweis dann.
  - **Teilen mit …:** In „Meine Notizen“ Q (Gamepad Y) drücken oder antippen, dann die Person wählen. Nur sie erfährt den Hinweis.
  - **Faden:** In der Fallakte den ersten Eintrag mit Enter, A oder „Faden ziehen“ wählen, dann den zweiten Eintrag. Verbundene Einträge tragen ein „~“.
- **Lagerunde:** am Ende jeder Phase. Die Meldekarten werden vorgelesen, die Rollen entscheiden, dann triffst du drei Entscheidungen (A, B oder C) und siehst ihr Ergebnis. Nach Phase 3 folgt die Eingrenzung.
- **Anklage:** Du wählst eine Person aus dem Verdachtskreis. Danach zeigt der Morgen das Ende und deine Punkte (von 9).

## 5. Im WLAN spielen

- **Voraussetzung:** Alle Geräte sind im selben WLAN.
- **Eröffnen:** Eine Person (in der App, nicht im Browser) wählt „Partie eröffnen“ und spielt den Detektiv. Sie sieht Adresse und Code, die Liste der Mitspielenden und stellt die Rollenzahl ein (4–20). Bots übernehmen die Rollen, die niemand spielt.
- **Beitreten:** Die anderen wählen „Einer Partie beitreten“ und geben Adresse (z. B. `192.168.1.23`; der Port 47100 ist voreingestellt), den Code (4 Zeichen) und ihren Namen ein, über die Bildschirmtastatur oder die echte Tastatur. Danach „Verbinden“.
- **Start:** Die Gastgeberin oder der Gastgeber startet die Partie. Jede Person bekommt eine Rolle mit eigenem Wissen, eigenen Funden und einer eigenen Fähigkeit.
- **Teilen:** über die Fallakte, gezielt an eine Person oder an alle über die Akte.
- **Lagerunde:** Jede Rolle trifft ihre eigene Entscheidung. Wer zu lange braucht, wird nach 90 Sekunden vertreten. Danach entscheidet der Detektiv.
- **Verbindung:** Bricht sie ab, geht die Partie beim Gastgeber weiter. Ein Wiederverbinden mit derselben Rolle bietet die App noch nicht an.

## 6. Speichern und Fortsetzen

- **Automatisch:** alle 60 Sekunden in der Erkundung und bei jedem Uhrturm-Schlag.
- **Von Hand:** Menü → „Speichern“. Auch „Hauptmenü“ speichert.
- **Fortsetzen:** stellt Fall, Ort und Blickrichtung wieder her. Nach dem Ende eines Falls wird der Stand gelöscht.
- **Im WLAN-Spiel:** Es wird nicht gespeichert.

## 7. Optionen

Erreichbar im Hauptmenü und in der Pause. Die Optionen bleiben gespeichert.

- **Bild:** sparsam, mittel oder hoch (Pixel auf der kurzen Bildseite: 135, 180, 216).
- **Sichtfeld:** 54° bis 80°.
- **Kopfwippen, Flackern:** an oder aus. „Flackern aus“ beruhigt Kerzen und Licht.
- **Blick-Empfindlichkeit:** 0,5 bis 2.
- **Lautstärke:** 0 bis 10.
- **Tutorial:** Hinweiskarten zur Steuerung an oder aus.
