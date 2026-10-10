# NACHTRAG AUFTEILUNG · Burgstadt raus, der Rest wird eine App

Stand 2026-10-10 · Leitstand · **Vorrang vor MASTER-PROMPT, Anhängen A-1…A-9, PLAN und Startpaket**, wo sie widersprechen. Einziger Schreiber: Leitstand.

## Nutzerwille (wörtlich, 10.10.2026)
- „das eine raus den rest fusionieren“
- „das andere kannst du entfernen, dieses 3D-Game. Das kannst du dann in einen separaten Repo tun“
- „diese drei … die kannst du einfach fusionieren zu einer App“ (Mordakte klassisch, Partyabend Schlosskeller, Krimidinner)
- Neues Repo „burgstadt-schartenfels, mit Verlauf“, öffentlich; „Kopieren, prüfen, dann hier entfernen“; Zeitpunkt „Nach dem Merge von PR #43“.

## Stand
- Die Burgstadt liegt jetzt in `umutcantezgel-cpu/burgstadt-schartenfels` (`main` = d814992, HD-Linie als Branch `hd-linie` = 2f6db13). Teilbäume bitgleich mit `werwolf_digital_flutter@47611d8`.
- In diesem Repo entfernt der Leitstand die Burgstadt mit **einem Lösch-Commit L** auf `main`, sobald PR #43 gemergt ist, die Finalisierung „ZIEL ERREICHT“ meldet und 60 min Ruhe herrscht. Bis dahin bleibt alles wie im Master-Prompt.

## Regeln (gelten ab dem Moment, in dem L auf origin/main liegt)
1. **Erster Schritt** jeder Generation nach L: `origin/main` in `bollwerk` mergen. Bei Konflikten gewinnt die Löschung; gelöschte Pfade werden nicht wiederhergestellt.
2. **Gelöscht und nie wieder anlegen:** `lib/burgstadt/**`, `packages/burgstadt_core/**`, `packages/burgstadt_spiel/**`, `packages/pixel_engine/**`, `assets/burgstadt/**`, `nachtlauf/**`, `hd/**`, `tool/{abnahme.dart,alle_tests.sh,commit_gruen.sh,hd_*,layout_pruefsumme.dart,mass5a.py,lib/figurenstand.dart}`. Kein Paket, Import oder Asset mit `burgstadt` oder `pixel_engine`.
3. **Bleibt:** `krimidinner/**` (weiter nie ändern), `packages/room_host/**` (BE-07: WLAN über room_host; ohne Burgstadt-Tests, `RaumSpiel` weiter nur umsetzen), `tool/ton/**`, `tool/browser/**`, Schutzwerkzeuge, `android/ios/web` und alle Einstellungen.
4. **FEINKORN:** statt „`packages/pixel_engine/**` nur ergänzen“ gilt: FEINKORN aus `origin/bollwerk:packages/pixel_engine/lib/src/feinkorn` als eigenständiges Paket `packages/feinkorn` ohne Abhängigkeiten (nur `dart:`), Trennungstest mitnehmen. Spielcode importiert nur über `feinkorn_leben.dart` (Türregel L0.5 gilt sinngemäß für `package:feinkorn`). Im Wurzel-`pubspec.yaml` darf dafür genau `feinkorn` (Pfad) dazukommen.
5. **BE-08 neu:** Die App startet im Schlosskeller; das Menü erreicht den Hub mit den klassischen Fällen (und später die weiteren Partyabende). Die Burgstadt ist nicht mehr Teil der App. **BE-07 bleibt.**
6. **Ziele:**
   - **Z-21:** „Menü erreicht Burgstadt“ und „Schalter zurück auf `/burgstadt`“ entfallen; der Schalter führt zurück auf `/hub`.
   - **Z-22:** bleibt (room_host).
   - **Z-26** heißt jetzt „Burgstadt bleibt draußen“: keiner der Pfade aus Regel 2 vorhanden, kein `burgstadt_*`/`pixel_engine` im pubspec, `assets/fonts/**` und `krimidinner/**` unverändert. „LAYOUT GLEICH“ und „Türen 134/134“ entfallen.
   - **Z-30:** HD-Übernahme entfällt (HD lebt im Burgstadt-Repo); FEINKORN-Übernahme über `packages/feinkorn`.
   - Tor-Schichten, die `tool/alle_tests.sh` oder Burgstadt-Pakete aufrufen (L1, Paketliste in L0, Bestandsbild), werden auf die verbleibenden Pakete umgestellt; das ist eine erlaubte Anpassung eigener Werkzeuge unter `tool/bollwerk/**`.
7. **Frage A-12 / G2-1 (HD-Linie):** gegenstandslos.
8. **B-02:** Der Leitstand setzt `B-02 ERFÜLLT · K=<sha40>` erst, wenn L auf origin/main liegt; K ist dann der aufgeteilte Stand.
9. **Phase 4 (Krimidinner als zweiter Partyabend „Spuk im Gewölbe“):** kein Auftrag für BOLLWERK, bis ein eigener Nachtrag ihn erteilt.
