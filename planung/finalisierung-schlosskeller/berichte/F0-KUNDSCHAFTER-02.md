## Web-Start und Bootstrap

- **Einstiegs-HTML:** `web/index.html:17` setzt `<base href="$FLUTTER_BASE_HREF">`. Die gebaute Datei `build/web/index.html:17` zeigt `<base href="/">`, also hat der Build den Platzhalter mit `/` ersetzt.
- **Lade-Overlay:** `web/index.html:37-47`. Das Element `#mordakte-loading` wird bei `flutter-first-frame` entfernt (Zeilen 43-46).
- **Loader:** `web/index.html:56` lädt `<script src="flutter_bootstrap.js" async>`. Die Datei liegt nicht im Quellbaum, sie entsteht erst beim Build (`build/web/flutter_bootstrap.js`).
- **Weitere Head-Einträge:** Theme-Farbe `index.html:21`, Apple-Icon `index.html:28`, Favicon `index.html:31`, Manifest `index.html:34`.
- **Manifest** `web/manifest.json`: `start_url: "."` (Zeile 4), `display: standalone` (Zeile 5), Icons relativ unter `icons/` (Zeilen 13-30).
- **Dart-Start** `lib/main.dart`:
  - `14-16` `main()`: `WidgetsFlutterBinding.ensureInitialized()`, `Haptics.install()`.
  - `17` `SystemChrome.setSystemUIOverlayStyle(...)`.
  - `19` `final meta = await MetaStore.load();`.
  - `21-27` Szenarien über `ScenarioRepository.load()`. Bei Fehler: `debugPrint` (24) und Fallback auf `sampleScenarioJson` (25-26).
  - `29` `AppState(meta: meta, scenarios: scenarios)`.
  - `30-33` Dev-Einstieg und `?autoplay=<id>&speed=`.
  - `34` `runApp(MordakteApp(app: app, initialLocation: initial))`.
- **Dev-Query-Parameter:** Kommentar `main.dart:45-49`; `_devEntry` in `main.dart:50-74`. Unterstützt `name`, `xp`, `fake` (Phase), `open`, `life`, `screen` (`main.dart:67-73`: `cases|collection|profile|online`, sonst Hub). `_query` (`main.dart:37-43`) liest `Uri.base.queryParameters`.
- **App-Hülle** `lib/app/app.dart`: `_router = buildRouter(...)` (23), `MaterialApp.router` (39), `themeMode: ThemeMode.dark` (44), `locale: Locale('de')` (45), `routerConfig: _router` (53).
- **Assets** `pubspec.yaml:30-31`: `content/scenarios/` als Asset. Schriften `pubspec.yaml:32-42` (SpecialElite, Inter 400/600/700).
- **Sessions:** `lib/app/app_state.dart` mit `startSolo` (74), `startAutoplay` (95), `startOnline` (122), `openFake` (142), `leaveSession` (181). Die Factory liegt in `lib/session/session_factory.dart:15-40`.
- **Standard-Serveradresse:** `lib/session/session_factory.dart:9`: `const defaultServerUrl = String.fromEnvironment('MORDAKTE_SERVER', defaultValue: 'ws://localhost:8080/ws');`

## Netzquellen zur Laufzeit (Datei:Zeile)

1. **CanvasKit vom Google-CDN (Standardpfad).** Im Bootstrap, `build/web/flutter_bootstrap.js` Zeile 1: `n.canvasKitBaseUrl ? … : e.engineRevision && !e.useLocalCanvasKit ? W("https://www.gstatic.com/flutter-canvaskit", e.engineRevision) : "canvaskit"`. Die `buildConfig` in Zeile 41 enthält `engineRevision` (`692136cb…`) und kein `useLocalCanvasKit`, daher greift der CDN-Pfad. Im SDK wird das gesteuert in `.werkzeug/flutter/packages/flutter_tools/lib/src/runner/flutter_command.dart:1496` (`forcedUseLocalCanvasKit ?? (!useCdn || useLocalWebSdk)`). Der Schalter ist `--no-web-resources-cdn`.
2. **Service-Worker-Konfiguration.** `build/web/flutter_bootstrap.js` Zeile 41: `serviceWorkerVersion: "2857006024"`. Im Loader steht `serviceWorkerUrl:i=m(\`flutter_service_worker.js?v=${r}\`)` (Zeile 1). Die Datei fehlt in `build/web/`. Der SDK-Code kennzeichnet den Service Worker als veraltet: `.werkzeug/flutter/packages/flutter_tools/lib/src/web_template.dart:18-19`.
3. **Bootstrap, same-origin:** `web/index.html:56`.
4. **WebSocket zum Online-Server.** `lib/session/online_session.dart:257`: `final ch = WebSocketChannel.connect(_url);`. Die URL wird in Zeile 81 mit `Uri.parse(url)` gebaut und in Zeile 125 als `final Uri _url;` gespeichert. Der Verbindungs-Timeout ist `connectTimeout = 8 s` (Zeile 55).
   - Build-Zeit-Override: `build.sh:19-20` setzt `--dart-define=MORDAKTE_SERVER=…`, wenn die Umgebungsvariable gesetzt ist. Ohne Variable gilt `ws://localhost:8080/ws` (`session_factory.dart:9`).
   - Nutzer-Override zur Laufzeit: Textfeld `lib/ui/screens/online_screen.dart:40-42`, Speichern in `:71` (`app.meta.serverUrl = url == defaultServerUrl ? null : url;`), Reset-Knopf `:205`.
   - Persistenz: `lib/meta/meta_store.dart:157-159` (Setter, Schlüssel `server`) und `:289-290` (Lesen). Der Präfix ist `mordakte.` (`meta_store.dart:275-279`).
   - Verwendung beim Start: `lib/app/app_state.dart:129`.
   - Doku: `README.md:84`, `server/README.md:12-16`.
5. **Keine HTTP-Clients im Client.** In `pubspec.lock` gibt es kein `http`- oder `dio`-Paket. Eine Suche nach `HttpClient|package:http` in `lib/` ergab keine Treffer. Der Server-Code `server/lib/server.dart` (`/health`, `/ws`) läuft nicht im Browser.
6. **Schriften lokal.** `pubspec.yaml:32-42`. Kein `google_fonts`. `web/index.html` lädt keine Stylesheets und keine Google-Fonts-URL.
7. **Szenarien und Assets lokal.** `lib/session/scenario_repository.dart:13-21` (`AssetManifest`, `rootBundle`). Entwicklungsvorschau `lib/game/dev/preview_main.dart:48` und `:61`.
8. **Manifest- und Favicon-Icons lokal.** `web/manifest.json:13-30`, `web/index.html:28` und `:31`.
9. **Nur Build-Zeit (nicht Laufzeit):**
   - `build.sh:11`: Download des Flutter-SDK von `https://storage.googleapis.com/flutter_infra_release/…`.
   - `build.sh:5`: `FLUTTER_VERSION="3.47.6"`.
   - `netlify.toml:5-8` und `vercel.json` (Block `rewrites`, Zeilen 6-11): SPA-Rewrite auf `/index.html`.
10. **Keine externen Ressourcen in `web/index.html`.** Die einzigen URLs sind Kommentare (`index.html:12`, `:54`).

## flutter build web – relevante Optionen (wörtlich)

Ausgabe von `flutter build web -h` (mit `PUB_CACHE` und `FLUTTER_SUPPRESS_ANALYTICS=true`, nur Hilfe). Die Hilfe enthält keinen Renderer-Schalter wie `--web-renderer`.

- `--base-href`: „Overrides the href attribute of the <base> tag in web/index.html. No change is made to web/index.html file if this flag is not provided. The value must start and end with "/". For more information: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/base“
- `--[no-]web-resources-cdn`: „Use Web static resources hosted on a CDN.“ (defaults to on)
- `--static-assets-url`: „Used when serving the static assets from a different domain the application is hosted on. The value has to end with a slash "/". When this is set, it will replace all $FLUTTER_STATIC_ASSETS_URL in web/index.html for the given value.“
- `-O, --optimization-level`: „Sets the optimization level used for Dart compilation to JavaScript/Wasm.“ [0, 1, 2, 3, 4]
- `--[no-]source-maps`: „Generate a sourcemap file. These can be used by browsers to view and debug the original source code of a compiled and minified Dart application.“ (kein Standardwert angegeben)
- `--csp`: „Disable dynamic generation of code in the generated output. This is necessary to satisfy CSP restrictions (see http://www.w3.org/TR/CSP/).“
- `--dart2js-optimization`: „Sets the optimization level used for Dart compilation to JavaScript. Deprecated: Please use "-O=<level>" / "--optimization-level=<level>".“ [O1, O2, O3, O4]
- `--[no-]wasm-dry-run`: „Compiles wasm in dry run mode during JS only compilations. Disable to suppress warnings.“ (defaults to on)
- `--wasm`: „Compile to WebAssembly (with fallback to JavaScript).“
- `--[no-]strip-wasm`: „Whether to strip the resulting wasm file of static symbol names.“ (defaults to on)
- `-D, --dart-define=<foo=bar>`: „Additional key-value pairs that will be available as constants from the String.fromEnvironment, bool.fromEnvironment, and int.fromEnvironment constructors.“
- `--web-define=<API_URL=https://api.example.com>`: „Additional key-value pairs that will be available as template variables in web/index.html and web/flutter_bootstrap.js files during development and build.“
- `--dart-define-from-file=<use-define-config.json|.env>`: „…Multiple defines can be passed by repeating "--dart-define-from-file" multiple times.“
- `--release` („Build a release version of your app (default mode).“), `--profile`, `--debug`
- `--[no-]native-null-assertions`: „…This is enabled by default but only takes effect in sound mode…“ (defaults to on)
- `-t, --target=<path>`: „(defaults to "lib/main.dart")“
- `-o, --output`: „…By default, this is <current-directory>/build/<target-platform>.“
- `--[no-]tree-shake-icons`: „Tree shake icon fonts so that only glyphs used by the application remain.“ (defaults to on)
- `--[no-]pub`: „Whether to run "flutter pub get" before executing this command.“ (defaults to on)

Renderer: Der Build-Eintrag lautet `"renderer":"canvaskit"` (`build/web/flutter_bootstrap.js` Zeile 41). Im Build-Verzeichnis liegen außerdem `canvaskit/skwasm*.wasm`. Wie man den Renderer wählt, ist aus der Hilfe nicht ersichtlich.

## Browser-Schnittstellen-Muster (Zitat)

Die einzige Browser-Interop im Projekt ist `lib/session/token_store_web.dart`. Verwendet wird `dart:js_interop`. `dart:html` und `package:web` werden nirgends verwendet (Suche ohne Treffer).

Zitat `lib/session/token_store_web.dart:1`: `import 'dart:js_interop';`

Zitat `lib/session/token_store_web.dart:9-16`:
```dart
@JS('sessionStorage')
external _Storage get _sessionStorage;

extension type _Storage._(JSObject _) implements JSObject {
  external String? getItem(String key);
  external void setItem(String key, String value);
  external void removeItem(String key);
}
```

Zitat `lib/session/token_store_web.dart:18-24` (try/catch-Wrapper):
```dart
String? _get(String key) {
  try {
    return _sessionStorage.getItem(key);
  } catch (_) {
    return null;
  }
}
```

Die Auswahl der Plattform-Datei erfolgt über bedingten Export, `lib/session/token_store.dart:6`:
`export 'token_store_io.dart' if (dart.library.js_interop) 'token_store_web.dart';`

Gegenstück für Mobil: `lib/session/token_store_io.dart` (`shared_preferences`).

Plattformabfrage: `lib/ui/haptics.dart:9` `static bool _active = !kIsWeb;`.

Muster für Nutzergesten, die auch für Web Speech und Datei-Download gelten: `lib/ui/haptics.dart:5-7` (Kommentar: Browser blockieren die Vibration bis zur ersten Nutzergeste) und `:20-23` (Aktivierung über `PointerUpEvent` bzw. Tastendruck).

Für die Web Speech API und den Datei-Download gibt es im Repo kein Vorbild. Ein analoges `@JS('…')`-Muster wäre denkbar, ist aber nicht geprüft.

## Hub und Router – Einstiegspunkt für den Partymodus

**Routen** (`lib/app/router.dart`):
- `13-21`: `abstract final class Routes` mit `static const hub = '/'`, `cases`, `collection`, `profile`, `online`, `lobby`, `game`.
- `23-38`: `_fade(...)`, das `CustomTransitionPage` mit Fade und Slide liefert.
- `40-57`: `buildRouter(AppState app, {String initialLocation})`. `refreshListenable: app` (42). Redirect (43-47): `lobby` und `game` ohne Session gehen zu `hub`.
- `48-56`: `GoRoute(path: Routes.x, pageBuilder: (c, s) => _fade(s, const XScreen()))`, eine Zeile pro Route.

**Navigation:** `context.go(Routes.x)` (z. B. `lib/ui/screens/hub_screen.dart:140`, `:163`, `:185`, `:198`). Der Hub nutzt kein `Navigator.push`.

**Hub** (`lib/ui/screens/hub_screen.dart`):
- `23` `class HubScreen`, `35-56` `initState` (Online-Raum laden `:37`, Namensdialog `:54`).
- `78-83` Hilfsfunktion `stagger(...)` mit `var step = 0` für gestaffeltes Einblenden. Neue Kacheln sollten darüber laufen.
- `85-221`: `Scaffold` → `NoirBackdrop` → `SafeArea` → `SingleChildScrollView` → `ContentWidth(maxWidth: 520)` → `Column`.
- Reihe 1: Badge (`:107`) und Serie (`:109`), Zeilen 103-112.
- Reihe 2: Tagesfall `_DailyCard` (`:115-128`, nur wenn `dailyScenario != null`).
- Reihe 3: Fallakten mit Glow (`:137-156`, `onTap: context.go(Routes.cases)`) und Online (`:159-171`). Feste Zeilenhöhe `height: 156` (`:131`).
- Reihe 4: Sammlung (`:182-193`) und Profil (`:195-210`). Feste Höhe `height: 112` (`:178`).
- Motto `:214-218`.

**Kachel-Muster:** `BentoTile(onTap: () => context.go(Routes.online), child: _TileBody(icon: Icons.public_rounded, title: l.hub_online, subtitle: …))`, Zeilen 163-168. `_TileBody` ist in `hub_screen.dart:230-278` definiert.

**BentoTile:** `lib/ui/widgets/bento.dart:8-16` (Parameter `child`, `onTap`, `height`, `highlight`, `accent`, `padding`). Haptik beim Tippen in `:62-68`.

**Lokalisierung:** `lib/l10n/app_de.arb`, Hub-Schlüssel z. B. `hub_cases` (Zeile 53), `hub_online` (55), `hub_collection` (81), `hub_profile` (82), `hub_motto` (114). Generierte Klasse `L` (`l10n.yaml:5`), Dateien in `lib/l10n/gen/`. `lib/l10n/lookup.dart:8` ist die Erweiterung `LLookup`. `pubspec.yaml:29` setzt `generate: true`.

**Dev-Einstieg:** `lib/main.dart:67-73` ist der `switch (q['screen'])`. Dort kann man `'party' => Routes.party` ergänzen.

**Vorschlag, nicht umgesetzt:**
- `static const party = '/party';` in `router.dart:13-21`.
- Eine `GoRoute` nach dem Muster von `router.dart:49-55`.
- Eine Kachel in `hub_screen.dart` nach dem Muster von `:163-168`.
- Ein `?screen=party`-Eintrag in `main.dart:67-73`.

**Platzproblem:** Die Zeilen 3 und 4 haben feste Höhen (156 und 112). Für eine zusätzliche Kachel braucht man eine neue Zeile oder muss das Layout ändern (siehe OFFENE FRAGEN).

## Testbestand

1. **`packages/mordakte_core/test/engine_regression_test.dart`** (Dart `test`, `packages/mordakte_core/pubspec.yaml:11`).
   - 18 `test(`-Aufrufe im Quelltext, dazu Schleifen über Szenarien.
   - Gruppen: „Geister“ mit Schleife über `ravensmoor`, `nachtexpress`, `blue_palm` (`:57-63`), Lügen-Alibi (`:82`), Fall-Ansicht ohne Seed (`:105`), Bewegung nach Neuverbindung (`:119`), Tod in der Beratung (`:135`), Gegengift (`:153`), Erste Hilfe (`:165`), Signale (`:209`), Journalisten-Quelle (`:220`), bereits gezogene Schlussfolgerung (`:320`), KI-Detektive am selben Ort (`:333`), Abstimmungen mit Menschen (`:237-`).
   - Liest Szenarien aus `'../../content/scenarios'` (`:9`), muss also aus `packages/mordakte_core` laufen.
   - Start: `cd packages/mordakte_core && dart test` (`README.md:72`).

2. **`server/tool/smoke.dart`** (eigener Smoke-Test, Ausgabe OK/FAIL über `print`, `:286-289`).
   - Drei Teile: A Fake-Runtime (`:326`), B echte `RoomRuntime` (`:522`), C Schutz (`:662`).
   - Flags: `-v` (`:317`), `--fake-only` und `--real-only` (`:318-320`).
   - Verbindet sich mit `ws://127.0.0.1:<port>/ws` (`:340`, `:537`, `:673`).
   - Start: `cd server && dart run tool/smoke.dart` (`server/README.md:22`).

3. **`packages/mordakte_core/bin/validate.dart`** (Szenario-Prüfung, kein Test-Framework). Prüft Format, Karte, Erreichbarkeit und Lösbarkeit (`README.md:43`). Standardziel `content/scenarios` (`validate.dart:9`). Start: `dart run bin/validate.dart`.

4. **`packages/mordakte_core/bin/simulate.dart`** (Balance-Simulation, KI spielt ganze Fälle durch, `README.md:44`). Start: `dart run bin/simulate.dart alle 4 2`.

5. **`ios/RunnerTests/RunnerTests.swift:5-10`**: nur das Xcode-Template `testExample()` ohne Assertions.

6. **Kein `test/`-Verzeichnis in der Flutter-App.** Keine Widget- oder Integrationstests gefunden. `integration_test` taucht nur in `.dockerignore:24` auf.

7. **Statische Analyse:** `analysis_options.yaml:1-5` (`include: package:flutter_lints/flutter.yaml`, `flutter_lints` in `pubspec.yaml:25`). `packages/mordakte_core/analysis_options.yaml` nutzt `lints/recommended`.

8. **Prüfwerkzeuge außerhalb von Flutter** (Kanon-Pipeline unter `krimidinner/spuk-im-gewoelbe/90_werkzeug/`): `plan.py:205-208` (Assertion auf doppelte Kennungen), `kanon.py:366`, `freigabe.py:34`, `bau.py:835`, `zaehl.py:25`, `raster.py:104`. Dazu `krimidinner/spuk-im-gewoelbe/30_pakete/_test/*.r0.md` als Testpakete (keine Tests). `quellen/` ist per `.gitignore:55` von Git ausgeschlossen.

## OFFENE FRAGEN

1. **Unvollständiger Build?** `build/web/` enthält `canvaskit/`, `flutter.js`, `flutter_bootstrap.js` und `index.html`, aber kein `main.dart.js`. Ob der Build vollständig war, ist nicht geklärt.
2. **Lokaler oder CDN-CanvasKit?** Im Build liegt `canvaskit/` lokal, der Bootstrap wählt laut Zeile 1 aber den gstatic-Pfad. Welcher Pfad zur Laufzeit gilt, wurde im Browser nicht geprüft.
3. **Service Worker:** `serviceWorkerVersion` ist gesetzt, `flutter_service_worker.js` fehlt in `build/web/`. Ob der Loader die Datei anfordert, habe ich nicht vollständig nachgelesen.
4. **SDK-Version:** `.werkzeug/flutter/version` existiert nicht. Die Engine-Revision im Build (`692136cb…`) weicht von der Revision in `.metadata` (`5fc34683…`) ab. `build.sh:5` pinnt `3.47.6`. Die lokale SDK-Version habe ich nicht ausgelesen.
5. **Online-Standard ohne Variable:** Ohne `MORDAKTE_SERVER` zeigt die Web-Build-Vorgabe auf `ws://localhost:8080`. Ob das Deployment (Netlify/Vercel) eine `wss://`-Variable setzt, ist im Repo nicht erkennbar. Auf einer HTTPS-Seite würde `ws://` vom Browser geblockt. Das ist eine Schlussfolgerung, nicht getestet.
6. **Web Speech API und Datei-Download:** Kein Vorbild im Repo. Browser-Verhalten (Nutzergeste, Berechtigungen) ist ungeprüft.
7. **Hub-Layout:** Wo die Partykrimi-Kachel steht und ob die festen Höhen 156 und 112 bleiben, ist eine Designentscheidung.
8. **Renderer-Wahl:** Die CLI-Hilfe hat keinen Renderer-Schalter. Wie man `skwasm` erzwingt, ist nicht geklärt.
9. **Smoke-Test:** Ich habe `server/tool/smoke.dart` nur in Auszügen gelesen (`:21-40`, `:317-341`, `:522-538`, `:662-673`). Ob der Test den Server selbst startet, ist aus `server.port` (`:537`) geschlossen, aber nicht vollständig belegt.
10. **Keine Flutter-Tests:** Es gibt keine `flutter test`-Tests für Hub, Router oder Screens. Ob das so gewollt ist, ist nicht dokumentiert.

=== ENDE F0-KUNDSCHAFTER-02 · BEREIT ZUR RÜCKGABE ===