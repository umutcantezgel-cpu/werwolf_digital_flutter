import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../game/szenen_erweiterung.dart';
import '../session/game_session.dart';
import 'sitzung.dart';

/// Speist den vorhandenen Renderer mit der Party-Karte (F4-ORCH-01, E-030).
///
/// Ermittlung: Detektiv als eigene Figur, alle Personen an ihren
/// Ermittlungsorten, offen sind nur die Ziele der laufenden Entscheidung.
/// `Interact` wählt nicht direkt, sondern macht einen Vorschlag; die Sitzung
/// fragt „Das ist endgültig“. Rückblende (erst nach dem Finale): Zeitraffer
/// der Tatmatrix mit dem Licht im Stromausfall (B-04).
class PartyKartenSession implements GameSession, SzenenErweiterung {
  PartyKartenSession(this.sitzung, {this.rueckblendeModus = false, this.zeitraffer = 25}) {
    final d = sitzung.kanon.figur((sitzung.kanon.figurenJson['detektiv'] as Map)['id'] as String)!;
    final ort = sitzung.kanon.graph.orte[d['ermittlungsOrt'] as String]!;
    _x = ort.x;
    _y = ort.y;
    _aussehen = LookDef.fromJson(renderLook(d));
    _offeneTueren = {
      for (final t in sitzung.kanon.graph.tueren.values)
        if (t.zustand == 'offen') ...[(t.von, t.nach), (t.nach, t.von)],
    };
    if (rueckblendeModus) {
      _rb = sitzung.rueckblende;
      zeit.value = _rb!.schritte.first;
    }
    sitzung.addListener(_publishCase);
    _publishCase();
    _tick();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
  }

  final PartySitzung sitzung;

  /// Rückblende statt Ermittlung.
  final bool rueckblendeModus;

  /// Spielsekunden je echter Sekunde in der Rückblende.
  final double zeitraffer;

  /// Aktuelle Uhrzeit der Rückblende (für die Anzeige).
  final ValueNotifier<Uhrzeit?> zeit = ValueNotifier(null);

  /// Rückblende zu Ende?
  final ValueNotifier<bool> fertig = ValueNotifier(false);

  late final Timer _timer;
  late final LookDef _aussehen;
  late final Set<(String, String)> _offeneTueren;
  Rueckblende? _rb;
  RueckblendeBild? _bild;
  double _rbSekunden = 0;
  final _world = ValueNotifier<WorldSnapshot?>(null);
  final _case = ValueNotifier<CaseView?>(null);
  final _events = StreamController<GameEvent>.broadcast();
  final _connected = ValueNotifier<bool>(true);
  double _x = 0, _y = 0, _f = 0.8;
  double? _korrekturX, _korrekturY;
  int _t = 0;
  int _version = 0;
  String? _letzterRaum;

  /// Detektiv an eine Stelle setzen (Entwickler-Skript, Kamera).
  void setzeDetektiv(double x, double y, {double facing = 0.8}) {
    _x = x;
    _y = y;
    _f = facing;
    _korrekturX = x;
    _korrekturY = y;
    _tick();
  }

  /// Rückblende von vorn.
  void neuStarten() {
    _rbSekunden = 0;
    fertig.value = false;
  }

  void _tick() {
    _t += 100;
    final rb = _rb;
    List<NpcView> npcs;
    if (rb != null) {
      final dauer = rb.schritte.last.minus(rb.schritte.first).toDouble();
      _rbSekunden = math.min(dauer, _rbSekunden + 0.1 * zeitraffer);
      if (_rbSekunden >= dauer) fertig.value = true;
      final t = rb.schritte.first.plus(_rbSekunden.floor());
      if (zeit.value != t) zeit.value = t;
      final b = _bild = rb.bild(t);
      npcs = [
        for (final e in b.personen.entries)
          if (sitzung.daten.npcKennung[e.key] case final id?) NpcView(id: id, x: e.value.x, y: e.value.y, alive: true),
      ];
    } else {
      npcs = [
        for (final f in sitzung.karte.figuren) NpcView(id: sitzung.daten.npcKennung[f.id]!, x: f.x, y: f.y, alive: true),
      ];
    }
    _world.value = WorldSnapshot(
      t: _t,
      phase: Phase.investigation,
      chapter: sitzung.runde.clamp(1, 3),
      phaseRemainingMs: 0,
      phaseTotalMs: 0,
      detectives: [
        DetectiveView(
          id: 'me', name: sitzung.personAmTisch('detective'), cls: 'forensic', coat: 0, hat: 'fedora', bot: false, connected: true,
          x: _x, y: _y, facing: _f, life: LifeState.alive, hp: 3, maxHp: 3, nerves: 100, hidden: false,
          moving: false, channel: null, effects: const [], downedLeftMs: 0,
        ),
      ],
      npcs: npcs,
      shadow: null,
      signals: const [],
      ackSeq: 0,
      correctX: _korrekturX,
      correctY: _korrekturY,
    );
    _korrekturX = _korrekturY = null;
  }

  void _publishCase() {
    final hotspots = <String, String>{};
    if (!rueckblendeModus) {
      final z = sitzung.karte.zustand(sitzung.spiel);
      for (final h in z.erledigt) {
        hotspots[h] = HotspotState.searched;
      }
      for (final h in z.offen.keys) {
        hotspots[h] = HotspotState.open;
      }
    }
    _case.value = CaseView(
      version: ++_version,
      roomCode: 'PARTY',
      hostId: 'me',
      scenarioId: sitzung.daten.szenario.id,
      mode: 'story',
      seed: 0,
      bots: 0,
      lobby: const [],
      phase: Phase.investigation,
      chapter: sitzung.runde.clamp(1, 3),
      notebook: const [],
      board: const [],
      deductions: const [],
      contradictions: 0,
      hotspots: hotspots,
      openDoors: const [],
      items: const [],
      inventory: const [],
      leadOptions: const [],
      leadVotes: const {},
      chosenLeads: const [],
      accusations: const {},
      heard: const {},
      deadNpcs: const [],
      abilityCooldownMs: 0,
      abilityCharges: 0,
      pingsLeft: 0,
      ending: null,
    );
  }

  // ---------------------------------------------------------------------------
  // GameSession

  @override
  String get playerId => 'me';

  @override
  String get roomCode => 'PARTY';

  @override
  bool get isOnline => false;

  @override
  ValueListenable<WorldSnapshot?> get world => _world;

  @override
  ValueListenable<CaseView?> get caseView => _case;

  @override
  Stream<GameEvent> get events => _events.stream;

  @override
  ValueListenable<bool> get connected => _connected;

  @override
  Map<String, ScenarioDef> get scenarios => {sitzung.daten.szenario.id: sitzung.daten.szenario};

  @override
  ScenarioDef? get scenario => sitzung.daten.szenario;

  @override
  void move(double x, double y, double facing) {
    _x = x;
    _y = y;
    _f = facing;
  }

  @override
  void send(Command command) {
    if (rueckblendeModus || command is! Interact) return;
    sitzung.schlageVorAn(sitzung.daten.kanonKennung[command.target] ?? command.target);
  }

  @override
  Future<void> dispose() async {
    sitzung.removeListener(_publishCase);
    _timer.cancel();
    await _events.close();
  }

  // ---------------------------------------------------------------------------
  // SzenenErweiterung

  KartenZustand get _zustand => sitzung.karte.zustand(sitzung.spiel);

  @override
  String? npcAktion(String npcId) {
    if (rueckblendeModus || sitzung.vorschlag != null) return null;
    final art = _zustand.ansprechbar[sitzung.daten.kanonKennung[npcId]];
    return art == null ? null : sitzung.ui('ui.karte.aktion.${art.name}');
  }

  @override
  String? hotspotAktion(String hotspotId) {
    final art = _zustand.offen[hotspotId];
    return art == null ? null : sitzung.ui('ui.karte.aktion.${art.name}');
  }

  static const _warm = Color(0xFFFF9329);

  @override
  SzenenLicht? get licht {
    final g = sitzung.kanon.graph;
    final kerzen = [
      for (final (x, y) in sitzung.karte.dekoKerzen) SzenenLichtpunkt(x, y, z: 0.9, radius: 1.5, farbe: _warm, flackern: 0.45),
    ];
    final b = _bild;
    if (rueckblendeModus && b != null) {
      final strom = b.helleRaeume.contains('thekensaal');
      return SzenenLicht(
        dunkel: strom ? 0.72 : 0.94,
        taschenlampe: false,
        helleRaeume: const {},
        punkte: [
          if (strom) ...kerzen,
          for (final l in b.lichter)
            SzenenLichtpunkt(l.x, l.y, radius: math.max(0.8, l.radius), farbe: _farbe(l.farbe), flackern: l.flackern),
        ],
      );
    }
    return SzenenLicht(
      dunkel: 0.77,
      punkte: [
        ...kerzen,
        for (final id in sitzung.karte.ermittlungsLichter)
          if (g.lichtquellen[id] case final l?)
            if (g.orte[l.ort] case final o?) SzenenLichtpunkt(o.x, o.y, z: 1.6, radius: l.radius, farbe: _farbe(l.farbe ?? '#FFF1C9'), flackern: l.flackern),
      ],
    );
  }

  static Color _farbe(String hex) => Color(int.parse(hex.substring(1), radix: 16) | 0xFF000000);

  @override
  Set<String>? sichtbareRaeume(double x, double y) {
    if (rueckblendeModus) return null;
    final raum = sitzung.kanon.graph.raumAn(x, y)?.id ?? _letzterRaum;
    if (raum == null) return null;
    _letzterRaum = raum;
    return {raum, for (final (a, b) in _offeneTueren) if (a == raum) b};
  }

  @override
  double? hervorhebung(String npcId) {
    final rb = _rb;
    if (rb == null) return null;
    return rb.hervorgehoben.contains(sitzung.daten.kanonKennung[npcId]) ? 1 : 0;
  }

  @override
  bool get ruheAnimation => true;

  @override
  bool get kleineEffekte => !rueckblendeModus;

  @override
  LookDef? get detektivAussehen => _aussehen;

  @override
  Offset? get kamera {
    final b = _bild;
    if (!rueckblendeModus || b == null) return null;
    final p = b.personen[_rb!.pfad];
    return p == null ? null : Offset(p.x, p.y);
  }
}
