# Mordakte

Kooperatives **2.5D-Murder-Mystery** für Android und iOS (Flutter + Flame).
1–6 Detektive – online mit Freunden oder solo mit KI-Partnern – laufen frei per Joystick
durch isometrische, komplett im Code gezeichnete Schauplätze, sammeln Hinweise, verhören
Verdächtige und überleben die Nacht, in der ein Schatten isolierte Ermittler jagt.

## Spielablauf

Jeder Fall hat 3 Kapitel:

1. **Intro** – Kapiteltext.
2. **Ermittlung** (4 Min) – Hotspots durchsuchen, Verdächtige befragen, Beweise vorlegen,
   Items aufheben. Gefundene Hinweise sind privat, bis man sie auf die **Beweiswand** teilt.
   Zwei passende Hinweise lassen sich zu einer Schlussfolgerung kombinieren.
3. **Beratung** – das Team stimmt über die nächste Spur ab (schaltet Räume/Hotspots frei).
4. **Nacht** – Licht aus. Der Schatten greift isolierte Detektive an, tötet Zeugen und
   beschädigt ungeteilte Notizen. Er hinterlässt Spuren, die Merkmale des Täters verraten.
5. Kapitel 3 endet mit der **Anklage** (Täter, Motiv, Waffe) und einem zusammengesetzten
   **Ende** (Urteil × Team-Schicksal × Täter-Epilog × Geheimnis).

Weitere Mechaniken: Hinweise entwickeln sich (Labor, Zeit), verpassbare Spuren, 5 Klassen
(Forensikerin, Profiler, Ex-Cop, Journalistin, Sanitäter) mit Fähigkeiten, Buffs/Debuffs,
Nerven, Niedergeschlagen → Wiederbeleben → Geist-Modus, Emotes/Schnellchat/Pings.
Meta: Rang & XP, Freischaltungen, Enden-Sammlung, Fall des Tages mit Streak, Achievements.

Jedes Szenario hat 24 Fall-Varianten (Täter/Motiv/Waffe per Seed): Der erste Durchlauf ist
die Story-Variante, danach wird jeder Fall neu gewürfelt.

## Szenarien

| Datei | Setting |
|---|---|
| `content/scenarios/ravensmoor.json` | Herrenhaus in einer Gewitternacht, 1890er |
| `content/scenarios/nachtexpress.json` | Nachtzug im Alpen-Schneesturm, 1931 |
| `content/scenarios/blue_palm.json` | Neon-Motel in Florida, 1986 |

Neue Szenarien sind reine JSON-Dateien – Format in [`content/SCHEMA.md`](content/SCHEMA.md).
Prüfen und probespielen:

```bash
cd packages/mordakte_core
dart run bin/validate.dart              # Format, Karte, Erreichbarkeit, Lösbarkeit
dart run bin/simulate.dart alle 4 2     # KI-Detektive spielen Fälle komplett durch
```

## Projektstruktur

```
packages/mordakte_core/   Reines Dart: Szenario-Modell, Raster/A*, Regeln, Engine, Schatten-KI,
                          KI-Detektive, Fall-Generator, Enden, Protokoll, RoomRuntime
server/                   Dart-WebSocket-Server (autoritativ, eine RoomRuntime pro Raum)
lib/game/                 Flame-Renderer (Iso-Räume, Figuren, Licht, Wetter, Joystick)
lib/ui/, lib/app/         Screens & Overlays (go_router, Provider)
lib/meta/                 Fortschritt, Freischaltungen, Sammlung, Fall des Tages
lib/session/              LocalSession (offline), OnlineSession (WebSocket), FakeSession (Dev)
content/scenarios/        Vorgefertigte Fälle
```

Solo läuft komplett offline: Die App startet dieselbe `RoomRuntime` wie der Server im Prozess.

## Entwickeln

Flutter 3.47.6 (Dart 3.13).

```bash
flutter pub get
flutter run                                   # Gerät/Emulator
flutter build apk --release                   # Android
flutter build ios --release                   # iOS (auf macOS)
flutter analyze
(cd packages/mordakte_core && dart test)
```

Web-Vorschau (Entwickler-Einstiege): `?autoplay=ravensmoor&speed=8` (KI spielt einen echten
Fall im Zeitraffer), `?fake=night` / `?fake=ending` (Testzustände), `?screen=cases`.

## Online-Server

```bash
cd server && dart pub get && dart run bin/server.dart        # PORT=8080, SCENARIO_DIR=../content/scenarios
```

Die App verbindet sich mit `--dart-define=MORDAKTE_SERVER=wss://<host>/ws` (Standard:
`ws://localhost:8080/ws`, in der App unter „Online spielen → Erweitert“ änderbar).
Deployment (Railway): `railway.toml` + `server/Dockerfile`, Build-Kontext ist das Repo-Root –
im Railway-Dienst muss das Root Directory leer sein. Details in [`server/README.md`](server/README.md).

## Ausblick

- Steam-Version mit spielbarem Täter: Der Schatten läuft bereits über eine
  `KillerController`-Schnittstelle; Desktop-Plattformen per `flutter create --platforms=windows,macos,linux`.
- Englische Texte: Szenario-Texte sind `{"de": …}`-Objekte, UI über `lib/l10n/app_de.arb`.
