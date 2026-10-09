# M1-INV-01 Inventar App-Teile (Baum: scratchpad/wt/fin)

Startroute ohne URL-Parameter: `/burgstadt` (main.dart:78, `_ => Routes.burgstadt`, übergeben über main.dart:30 und main.dart:34). Router-Default ist `/` (router.dart:46, `initialLocation = Routes.hub`), wird aber von main.dart nicht genutzt.

| Teil | Art | Fundstelle | Zahl/Zweck |
|---|---|---|---|
| Route `/` (hub) | Route | lib/app/router.dart:17, :54 | HubScreen, Startkacheln |
| Route `/cases` | Route | lib/app/router.dart:18, :55 | CasesScreen, Fallauswahl |
| Route `/collection` | Route | lib/app/router.dart:19, :56 | CollectionScreen, Sammlung |
| Route `/profile` | Route | lib/app/router.dart:20, :57 | ProfileScreen, Profil |
| Route `/online` | Route | lib/app/router.dart:21, :58 | OnlineScreen, Raumcode-Eingabe |
| Route `/lobby` | Route | lib/app/router.dart:22, :59 | LobbyScreen; Redirect ohne Session (router.dart:50) |
| Route `/game` | Route | lib/app/router.dart:23, :60 | GameScreen; Redirect ohne Session (router.dart:50) |
| Route `/burgstadt` (Start) | Route | lib/app/router.dart:24, :61; Start lib/main.dart:78 | BurgstadtSeite, Startseite Burgstadt |
| Route `/party` | Route | lib/app/router.dart:25, :62; main.dart:60 | PartySeite, Partymodus |
| HubScreen | Bildschirm | lib/ui/screens/hub_screen.dart:23 | Startbildschirm mit Kacheln, Tagesfall, Streak |
| CasesScreen | Bildschirm | lib/ui/screens/cases_screen.dart:17 | Fallauswahl mit Modus-Wahl |
| CollectionScreen | Bildschirm | lib/ui/screens/collection_screen.dart:20 | Sammlung mit Tabs, Enden, Raster |
| ProfileScreen | Bildschirm | lib/ui/screens/profile_screen.dart:22 | Profil, Statistik, Klassen, Freischaltungen |
| OnlineScreen | Bildschirm | lib/ui/screens/online_screen.dart:31 | Online-Einstieg, vierstelliger Raumcode |
| LobbyScreen | Bildschirm | lib/ui/screens/lobby_screen.dart:23 | Lobby: Spieler, Bots, Klassen, Host-Konfiguration |
| GameScreen | Bildschirm | lib/ui/screens/game_screen.dart:32 | Spiel: Szene plus phasenabhängige Overlays |
| AufloesungBildschirm | Bildschirm | lib/party/bildschirme/aufloesung.dart:11 | Auflösung und Ende (Phasen aufloesung, ende) |
| AnklageBildschirm | Bildschirm | lib/party/bildschirme/anklage.dart:10 | Anklage gegen eine der vier Kernpersonen |
| EinrichtungBildschirm | Bildschirm | lib/party/bildschirme/einrichtung.dart:12 | Einrichtung des Abends |
| FinaleBildschirm | Bildschirm | lib/party/bildschirme/finale.dart:13 | Finale mit Rückblende |
| GruppenwahlBildschirm | Bildschirm | lib/party/bildschirme/gruppenwahl.dart:10 | Gruppenwahl reihum und verdeckt |
| IntroBildschirm | Bildschirm | lib/party/bildschirme/intro.dart:10 | Intro (Phase intro) |
| KartenBildschirm | Bildschirm | lib/party/bildschirme/karte.dart:13 | Entscheidungen des Detektivs auf der Karte |
| FundKarte | Bildschirm | lib/party/bildschirme/npc_karte.dart:11 | Fundkarte nach einer Entscheidung |
| ResuemeeBildschirm | Bildschirm | lib/party/bildschirme/resuemee.dart:11 | Bonus-Hinweis und Zwischenresümee |
| RollenBildschirm | Bildschirm | lib/party/bildschirme/rollen.dart:16 | Verdeckte Rollenvergabe und Dossier |
| RundeBildschirm | Bildschirm | lib/party/bildschirme/runde.dart:13 | Rundenzentrale mit Erzählertext |
| TitelBildschirm | Bildschirm | lib/party/bildschirme/titel.dart:10 | Titelbildschirm (Phase titel) |
| blue_palm | Klassischer Fall | content/scenarios/blue_palm.json:2-3 | „Blue Palm Motel“ |
| nachtexpress | Klassischer Fall | content/scenarios/nachtexpress.json:2-3 | „Nachtexpress 1931“ |
| ravensmoor | Klassischer Fall | content/scenarios/ravensmoor.json:2-3 | „Ravensmoor“ |
| story | Modus | lib/ui/screens/cases_screen.dart:306 (Default cases_screen.dart:62); Text lib/l10n/lookup.dart:230-241 | Solo-Modus Geschichte (Fallmodus 1 von 3) |
| random | Modus | lib/ui/screens/cases_screen.dart:307 | Solo-Modus Zufall (Fallmodus 2 von 3) |
| daily | Modus | lib/ui/screens/cases_screen.dart:308 (enabled nur bei daily) | Solo-Modus Tagesfall (Fallmodus 3 von 3) |
| BurgstadtSeite | Einstieg (Route) | lib/burgstadt/burgstadt_seite.dart:9 | Startseite „Burgstadt Schartenfels“, Route `/burgstadt` |
| lib/burgstadt/** | Modul | lib/burgstadt/ (11 Dateien) | 11 Dateien, Einstieg burgstadt_seite.dart:9; Bausteine u.a. burgstadt_ansicht.dart:20, wlan_app.dart:12, daten_laden.dart:12 (kanonPfad) |
| PartySeite | Einstieg (Route) | lib/party/party_seite.dart:24; Route router.dart:62; Dev-Start main.dart:60 | Partymodus, Route `/party` |
| lib/party/** | Modul | lib/party/ (27 Dateien: 15 oben, 12 in bildschirme/) | 27 Dateien, Einstieg party_seite.dart:24; Skript-Parameter PartyDev skript.dart:22 |
| krimidinner/** | Modul (Planung, kein Dart-Einstieg) | krimidinner/spuk-im-gewoelbe/ (128 Dateien: 116 .md, 6 .py, 1 .js, 5 .gitkeep) | Kein Dart-Einstieg; Kanon-Pfad in lib/burgstadt/daten_laden.dart:12 |
| lib/game/dev/** | Vorschau | lib/game/dev/ (3 Dateien) | 3 Dateien; Einstieg preview_main.dart:22 main(); Klassen ScenarioPreviewSession :12, ShowcaseSession :12 |

Hinweise zur Zählung:
- Bildschirme 19 = 7 in lib/ui/screens/** plus 12 in lib/party/bildschirme/. BurgstadtSeite und PartySeite sind Routen-Seiten und hier nicht mitgezählt.
- AchievementList (lib/ui/screens/collection_screen.dart:282) ist ein öffentliches Widget und kein Bildschirm, nicht mitgezählt.
- Modi 3 = Solo-Fallmodi story, random, daily. Partymodus und Burgstadt sind eigene Teile, nicht mitgezählt.
- Klassische Fälle nur content/scenarios/*.json (3). Der Partyfall content/party/schlosskeller ist kein klassischer Fall und nicht mitgezählt.
- Routen 9 (router.dart:54-62).

Summen: Routen 9, Bildschirme 19, klassische Fälle 3, Modi 3
