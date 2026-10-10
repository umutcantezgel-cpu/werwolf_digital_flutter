# Bestand-Regression auf `f26f2de` (F-16)

Vergleich mit der Messbasis in BESTAND.md: Validator 4 × OK, Simulator 16 Läufe, alle Urteile `perfect`.

## `dart run bin/validate.dart`
```
== sample (eingebaut)
  Hinweis Kapitel 1: weniger als 2 sichtbare Spuren
  Hinweis weniger als 2 Verstecke
  Hinweis Merkmal shoe hat nur 1 verlässliche Hinweisquelle(n)
  Hinweis Weniger als 2 Motiv-Hinweise
  Hinweis Weniger als 2 Waffen-Hinweise
  OK – 11 Hinweise, 3 Verdächtige, 12 Fall-Varianten
== /home/user/werwolf_digital_flutter/content/scenarios/blue_palm.json
  OK – 20 Hinweise, 5 Verdächtige, 24 Fall-Varianten
== /home/user/werwolf_digital_flutter/content/scenarios/nachtexpress.json
  OK – 20 Hinweise, 5 Verdächtige, 24 Fall-Varianten
== /home/user/werwolf_digital_flutter/content/scenarios/ravensmoor.json
  OK – 20 Hinweise, 5 Verdächtige, 24 Fall-Varianten
```

## `dart run bin/simulate.dart alle 4 2`
```
== sample (4 Läufe, 1 Autopilot-Spieler + 2 Bots)
  Lauf 0: perfect.all.nephew.secret        Täter nephew/inheritance/poison · angeklagt nephew/inheritance/poison · Stärke 14 · Hinweise 12/11 · Angriffe 1 · Tote all · Zeugen † 2 · 15.0 Min
  Lauf 1: perfect.all.housekeeper.secret   Täter housekeeper/debt/poison · angeklagt housekeeper/debt/poison · Stärke 18 · Hinweise 16/11 · Angriffe 2 · Tote all · Zeugen † 1 · 15.1 Min
  Lauf 2: perfect.all.doctor.secret        Täter doctor/inheritance/candlestick · angeklagt doctor/inheritance/candlestick · Stärke 18 · Hinweise 16/11 · Angriffe 1 · Tote all · Zeugen † 2 · 15.0 Min
  Lauf 3: perfect.all.housekeeper.secret   Täter housekeeper/revenge/candlestick · angeklagt housekeeper/revenge/candlestick · Stärke 17 · Hinweise 15/11 · Angriffe 1 · Tote all · Zeugen † 1 · 15.1 Min
  Σ Urteile {perfect: 4} · Teams {all: 4} · Ø 15.0 Min · Ø Hinweise 14.8 · Ø Stärke 16.8 · Ø Angriffe 1.3 · Ø Zeugen † 1.5
== nachtexpress (4 Läufe, 1 Autopilot-Spieler + 2 Bots)
  Lauf 0: perfect.all.secretary.secret     Täter secretary/revenge/veronal · angeklagt secretary/revenge/veronal · Stärke 23 · Hinweise 21/20 · Angriffe 1 · Tote all · Zeugen † 2 · 15.1 Min
  Lauf 1: perfect.all.secretary.secret     Täter secretary/greed/scarf · angeklagt secretary/greed/scarf · Stärke 22 · Hinweise 19/20 · Angriffe 1 · Tote all · Zeugen † 2 · 15.0 Min
  Lauf 2: perfect.all.secretary.secret     Täter secretary/revenge/veronal · angeklagt secretary/revenge/veronal · Stärke 25 · Hinweise 23/20 · Angriffe 2 · Tote all · Zeugen † 2 · 15.2 Min
  Lauf 3: perfect.all.secretary.secret     Täter secretary/greed/candlestick · angeklagt secretary/greed/candlestick · Stärke 24 · Hinweise 21/20 · Angriffe 1 · Tote all · Zeugen † 2 · 15.0 Min
  Σ Urteile {perfect: 4} · Teams {all: 4} · Ø 15.1 Min · Ø Hinweise 21.0 · Ø Stärke 23.5 · Ø Angriffe 1.3 · Ø Zeugen † 2.0
== blue_palm (4 Läufe, 1 Autopilot-Spieler + 2 Bots)
  Lauf 0: perfect.all.viv                  Täter viv/blackmail/cable · angeklagt viv/blackmail/cable · Stärke 27 · Hinweise 22/20 · Angriffe 2 · Tote all · Zeugen † 2 · 15.1 Min
  Lauf 1: perfect.all.frank.secret         Täter frank/dienstverrat/cable · angeklagt frank/dienstverrat/cable · Stärke 28 · Hinweise 24/20 · Angriffe 3 · Tote all · Zeugen † 2 · 15.0 Min
  Lauf 2: perfect.all.sol.secret           Täter sol/insurance/flamingo · angeklagt sol/insurance/flamingo · Stärke 28 · Hinweise 24/20 · Angriffe 2 · Tote all · Zeugen † 2 · 15.1 Min
  Lauf 3: perfect.all.frank.secret         Täter frank/blackmail/flamingo · angeklagt frank/blackmail/flamingo · Stärke 26 · Hinweise 22/20 · Angriffe 2 · Tote all · Zeugen † 2 · 15.1 Min
  Σ Urteile {perfect: 4} · Teams {all: 4} · Ø 15.1 Min · Ø Hinweise 23.0 · Ø Stärke 27.3 · Ø Angriffe 2.3 · Ø Zeugen † 2.0
== ravensmoor (4 Läufe, 1 Autopilot-Spieler + 2 Bots)
  Lauf 0: perfect.all.aerztin              Täter aerztin/geheimnis/brieffoeffner · angeklagt aerztin/geheimnis/brieffoeffner · Stärke 22 · Hinweise 18/20 · Angriffe 0 · Tote all · Zeugen † 0 · 15.1 Min
  Lauf 1: perfect.all.aerztin.secret       Täter aerztin/erbe/gift · angeklagt aerztin/erbe/gift · Stärke 23 · Hinweise 20/20 · Angriffe 1 · Tote all · Zeugen † 1 · 14.9 Min
  Lauf 2: perfect.all.butler.secret        Täter butler/geheimnis/leuchter · angeklagt butler/geheimnis/leuchter · Stärke 25 · Hinweise 22/20 · Angriffe 1 · Tote all · Zeugen † 2 · 15.0 Min
  Lauf 3: perfect.all.butler.secret        Täter butler/geheimnis/gift · angeklagt butler/geheimnis/gift · Stärke 22 · Hinweise 20/20 · Angriffe 1 · Tote all · Zeugen † 1 · 15.0 Min
  Σ Urteile {perfect: 4} · Teams {all: 4} · Ø 15.0 Min · Ø Hinweise 20.0 · Ø Stärke 23.0 · Ø Angriffe 0.8 · Ø Zeugen † 1.0
```

## `cd server && dart run tool/smoke.dart`
```
  OK    zweites hello mit anderer Identität → err protocol
C2. Übergroße Nachrichten trennen vor dem Puffern
  OK    300-KB-Rahmen → Verbindung getrennt
  OK    fragmentierte Nachricht über 16 KB → Verbindung getrennt
  OK    Server lebt weiter ("ok rooms=1 players=0")
63 OK, 0 FAIL
```
