part of 'engine.dart';

/// Der „Schatten“ – der NPC-Täter in der Nacht. Die Steuerung läuft über
/// [KillerController], damit später ein Mensch (Steam-Version) übernehmen kann.
class _Shadow {
  double x;
  double y;
  String mode = 'roam'; // roam | hunt | stalk | flee | attack
  List<Pt> path = [];
  String? target;
  int repathMs = 0;
  int cooldownMs;
  int fleeMs = 0;
  bool witnessDone = false;
  int traceMs = 12000;

  _Shadow(this.x, this.y, this.cooldownMs);
}

/// Schnittstelle für die Täter-Steuerung (heute KI, später ein Spieler).
abstract class KillerController {
  /// Ein Schritt der Täter-Logik.
  void step(int dtMs);
}

extension _ShadowLogic on Engine {
  bool get _soloish => _aliveDetectives.length <= 1;

  void _spawnShadow() {
    final s = _s!;
    final grid = _grid!;
    final council = s.map.roomById[s.map.councilRoom];
    final rooms = s.map.rooms.where((r) => !r.lit).toList();
    rooms.sort((a, b) {
      final da = council == null ? 0 : dist(a.cx, a.cy, council.cx, council.cy);
      final db = council == null ? 0 : dist(b.cx, b.cy, council.cx, council.cy);
      return db.compareTo(da);
    });
    Pt? spot;
    for (final r in rooms) {
      spot = grid.nearestWalkable(r.cx.floor(), r.cy.floor(), maxRadius: 3);
      if (spot != null) break;
    }
    spot ??= s.map.spawn.first;
    _shadow = _Shadow(spot.x + 0.5, spot.y + 0.5, 14000);
  }

  void _shadowFlee() {
    final sh = _shadow;
    if (sh == null) return;
    sh
      ..mode = 'flee'
      ..fleeMs = Tuning.shadowFleeMs
      ..path = []
      ..target = null
      ..cooldownMs = math.max(sh.cooldownMs, 8000);
  }

  bool _inLitRoom(double x, double y) => _grid!.roomAtPos(x, y)?.lit ?? false;

  void _tickShadow(int dt) {
    final sh = _shadow;
    final grid = _grid;
    final truth = _truth;
    if (sh == null || grid == null || truth == null) return;

    final speed = (_soloish ? Tuning.shadowSpeedSolo : Tuning.shadowSpeed) * (sh.mode == 'flee' ? 1.3 : 1.0);
    sh.cooldownMs -= dt;

    // Herzschlag-Warnung
    for (final p in _aliveDetectives) {
      if (_now - p.lastShadowNearAt > 3000 &&
          dist(p.x, p.y, sh.x, sh.y) < Tuning.shadowNearRadius &&
          grid.lineOfSight(p.x, p.y, sh.x, sh.y)) {
        p.lastShadowNearAt = _now;
        _emit(GameEvent(Ev.shadowNear, to: p.id));
      }
    }

    // Spuren hinterlassen – der Grund, nachts das Licht zu verlassen.
    sh.traceMs -= dt;
    if (sh.traceMs <= 0 && !_inLitRoom(sh.x, sh.y)) {
      sh.traceMs = 18000 + _rt.nextInt(8000);
      final t = Pt(sh.x.floor(), sh.y.floor());
      final open = _items.values.where((i) => i.def.type == ItemType.trace).length;
      if (open < 2 && grid.walkable(t.x, t.y)) {
        final id = 'trace_${++_traces}';
        _items[id] = _MapItem(ItemDef(id: id, type: ItemType.trace, x: t.x, y: t.y, chapter: _chapter));
        _dirtyAll();
      }
    }

    if (sh.mode == 'flee') {
      sh.fleeMs -= dt;
      if (sh.path.isEmpty) sh.path = _pathAwayFromDetectives(sh) ?? [];
      _shadowMove(sh, speed, dt);
      if (sh.fleeMs <= 0) {
        sh.mode = 'roam';
        sh.path = [];
      }
      return;
    }

    sh.repathMs -= dt;
    if (sh.repathMs <= 0) {
      sh.repathMs = 600;
      _shadowDecide(sh);
    }
    _shadowMove(sh, speed, dt);

    switch (sh.mode) {
      case 'hunt':
        final t = _players[sh.target];
        if (t == null || !t.alive) {
          sh.mode = 'roam';
          break;
        }
        if (dist(sh.x, sh.y, t.x, t.y) <= Tuning.shadowAttackRange) {
          if (t.protected || _inLitRoom(t.x, t.y)) {
            _shadowFlee();
            _emit(GameEvent(Ev.shadowRepelled, args: {'reason': 'group'}));
          } else {
            _shadowAttack(sh, t);
          }
        }
      case 'stalk':
        final npc = _npcById[sh.target];
        if (npc == null || !npc.alive) {
          sh.mode = 'roam';
          break;
        }
        if (dist(sh.x, sh.y, npc.x, npc.y) <= 1.1) {
          final watched = _aliveDetectives.any((p) => dist(p.x, p.y, npc.x, npc.y) < 3.5);
          if (watched) {
            sh.mode = 'roam';
            sh.path = [];
          } else {
            npc.alive = false;
            sh.witnessDone = true;
            _emit(GameEvent(Ev.npcKilled, args: {'npc': npc.id}));
            _dirtyAll();
            _shadowFlee();
            sh.fleeMs = 4000;
          }
        }
      default:
        break;
    }
  }

  void _shadowDecide(_Shadow sh) {
    final grid = _grid!;
    final shTile = Pt(sh.x.floor(), sh.y.floor());

    // 1) Jagd auf isolierte Detektive
    if (sh.cooldownMs <= 0) {
      PlayerState? best;
      var bestScore = double.infinity;
      for (final p in _aliveDetectives) {
        if (p.protected || _inLitRoom(p.x, p.y)) continue;
        final d = dist(sh.x, sh.y, p.x, p.y);
        final threat = _clues.values.where((c) => c.foundBy == p.id).length * 0.3;
        final score = d - threat;
        if (score < bestScore) {
          bestScore = score;
          best = p;
        }
      }
      if (best != null) {
        sh.mode = 'hunt';
        sh.target = best.id;
        sh.path = grid.findPath(shTile, Pt(best.x.floor(), best.y.floor())) ?? [];
        return;
      }
    }

    // 2) Zeugen beseitigen (einmal pro Nacht, nach etwas Zeit)
    if (!sh.witnessDone && _nightElapsed > Tuning.nightMs * 0.2) {
      final truth = _truth!.truth;
      final witnesses = _npcs
          .where((n) =>
              n.alive &&
              n.def.witness &&
              n.id != truth.culprit &&
              !_aliveDetectives.any((p) => dist(p.x, p.y, n.x, n.y) < 4))
          .toList();
      if (witnesses.isNotEmpty) {
        witnesses.sort((a, b) => dist(sh.x, sh.y, a.x, a.y).compareTo(dist(sh.x, sh.y, b.x, b.y)));
        final w = witnesses.first;
        final goal = grid.nearestWalkable(w.x.floor(), w.y.floor(), maxRadius: 2);
        if (goal != null) {
          sh.mode = 'stalk';
          sh.target = w.id;
          sh.path = grid.findPath(shTile, goal) ?? [];
          return;
        }
      }
    }

    // 3) Herumstreifen
    if (sh.mode != 'roam' || sh.path.isEmpty) {
      sh.mode = 'roam';
      sh.target = null;
      final rooms = _s!.map.rooms.where((r) => !r.lit).toList();
      if (rooms.isEmpty) return;
      final r = _rt.pick(rooms);
      final goal = grid.nearestWalkable(r.x + _rt.nextInt(r.w), r.y + _rt.nextInt(r.h), maxRadius: 3);
      if (goal != null) sh.path = grid.findPath(shTile, goal) ?? [];
    }
  }

  List<Pt>? _pathAwayFromDetectives(_Shadow sh) {
    final grid = _grid!;
    final rooms = _s!.map.rooms.where((r) => !r.lit).toList();
    if (rooms.isEmpty) return null;
    RoomDef? far;
    var farD = -1.0;
    for (final r in rooms) {
      final d = _aliveDetectives.fold<double>(
          double.infinity, (m, p) => math.min(m, dist(r.cx, r.cy, p.x, p.y)));
      if (d > farD) {
        farD = d;
        far = r;
      }
    }
    final goal = grid.nearestWalkable(far!.cx.floor(), far.cy.floor(), maxRadius: 3);
    if (goal == null) return null;
    return grid.findPath(Pt(sh.x.floor(), sh.y.floor()), goal);
  }

  void _shadowMove(_Shadow sh, double speed, int dt) {
    var step = speed * dt / 1000;
    // Bei der Jagd direkt auf das Ziel zulaufen, wenn es nah und sichtbar ist.
    if (sh.mode == 'hunt') {
      final t = _players[sh.target];
      if (t != null && dist(sh.x, sh.y, t.x, t.y) < 2.2 && _grid!.lineOfSight(sh.x, sh.y, t.x, t.y)) {
        final d = dist(sh.x, sh.y, t.x, t.y);
        final k = math.min(1.0, step / math.max(d, 0.001));
        sh.x += (t.x - sh.x) * k;
        sh.y += (t.y - sh.y) * k;
        return;
      }
    }
    while (step > 0 && sh.path.isNotEmpty) {
      final next = sh.path.first;
      final tx = next.x + 0.5, ty = next.y + 0.5;
      final d = dist(sh.x, sh.y, tx, ty);
      if (d <= step) {
        sh.x = tx;
        sh.y = ty;
        step -= d;
        sh.path.removeAt(0);
      } else {
        sh.x += (tx - sh.x) / d * step;
        sh.y += (ty - sh.y) / d * step;
        step = 0;
      }
    }
  }

  void _shadowAttack(_Shadow sh, PlayerState p) {
    p.stats.attacks++;
    p.nerves = math.max(0, p.nerves - 30);
    _emit(GameEvent(Ev.attacked, args: {'player': p.id}));
    _damage(p, 1);

    // Ungeteilte Notizen beschädigen oder stehlen.
    final unshared = _clues.values.where((c) => c.holder == p.id && !c.onBoard && c.def != null).toList();
    _rt.shuffle(unshared);
    for (final c in unshared.take(2)) {
      if (c.revealed) {
        c.stage = 0;
        c.pending = Evolve.lab;
        c.revealChapter = null;
        _emit(GameEvent(Ev.clueLost, to: p.id, args: {'clue': c.id, 'player': p.id, 'mode': 'damaged'}));
      } else {
        _clues.remove(c.id);
        _emit(GameEvent(Ev.clueLost, to: p.id, args: {'clue': c.id, 'player': p.id, 'mode': 'stolen'}));
      }
    }

    if (p.alive) {
      if (p.hasEffect('injured')) {
        if (_rt.chance(0.4)) _addEffect(p, 'poisoned');
      } else {
        _addEffect(p, 'injured');
      }
      _addEffect(p, 'adrenaline');
      _grantSighting(p);
    }
    sh.cooldownMs = _soloish ? Tuning.shadowAttackCooldownSoloMs : Tuning.shadowAttackCooldownMs;
    _shadowFlee();
    _dirtyAll();
  }

  /// Sichtung: ein Merkmal des Täters, das das Team noch nicht kennt.
  void _grantSighting(PlayerState p) {
    final truth = _truth!;
    final known = _clues.values
        .where((c) => c.revealed && (c.kind == ClueKind.trait || c.kind == 'sighting') && (c.onBoard || c.holder == p.id))
        .map((c) => c.trait)
        .toSet();
    final traits = _s!.traits.keys.where((t) => !known.contains(t)).toList();
    final pool = traits.isEmpty ? _s!.traits.keys.toList() : traits;
    if (pool.isEmpty) return;
    final trait = _rt.pick(pool);
    final id = 'sight_${++_sightings}';
    _clues[id] = ClueInst(
      id: id,
      def: null,
      kind: 'sighting',
      stage: 1,
      pending: null,
      revealChapter: null,
      trait: trait,
      fixedValue: truth.culprit.traits[trait],
      holder: p.id,
      foundBy: p.id,
    );
    p.stats.found++;
    _emit(GameEvent(Ev.clueFound, to: p.id, args: {'clue': id}));
    if (p.ghost) _shareInst(p, _clues[id]!);
  }
}
