part of 'engine.dart';

/// KI-Detektive: füllen Lobbys auf, übernehmen getrennte Spieler und spielen
/// in `simulate` ganze Fälle durch. Sie sind kooperativ: teilen sofort, bleiben
/// nachts zusammen, beleben wieder.
class _Brain {
  String? goal;
  String goalKind = '';
  List<Pt> path = [];
  int thinkMs = 0;
  int waitMs = 0;
  int stuckMs = 0;
  double lastX = 0;
  double lastY = 0;
  final Map<String, int> blacklist = {};
  final List<String> topics = [];
  int voteAt = -1;
}

extension _BotLogic on Engine {
  void _tickBots(int dt) {
    for (final p in _players.values) {
      if (!p.autopilot) continue;
      final b = _brains.putIfAbsent(p.id, _Brain.new);
      _botStep(p, b, dt);
    }
  }

  void _botStep(PlayerState p, _Brain b, int dt) {
    b.blacklist.updateAll((k, v) => v - dt);
    b.blacklist.removeWhere((k, v) => v <= 0);
    switch (_phase) {
      case Phase.intro:
        p.ready = true;
        return;
      case Phase.council:
        _botShareAndCombine(p);
        if (b.voteAt < 0) b.voteAt = _now + 3000 + _rt.nextInt(7000);
        if (_leadOptions.isNotEmpty) {
          final humanVotes = <String, int>{};
          for (final e in _leadVotes.entries) {
            if (_isHumanVoter(e.key)) humanVotes[e.value] = (humanVotes[e.value] ?? 0) + 1;
          }
          final own = _leadVotes[p.id];
          if (humanVotes.isNotEmpty) {
            // Menschen haben gewählt: zügig anschließen, bevor die Beratung vorzeitig endet.
            if (b.voteAt > _now + 1200) b.voteAt = _now + 400 + _rt.nextInt(600);
            // Später abgegebenen Menschen-Stimmen folgen, damit die Anzeige zum Ergebnis passt.
            // Bei Gleichstand der frühesten Option (so entscheidet auch _resolveLeadVote).
            final best = humanVotes.values.reduce(math.max);
            final target = humanVotes.entries.firstWhere((e) => e.value == best).key;
            if (_now >= b.voteAt && own != target) applyCommand(p.id, VoteLead(target));
          } else if (_now >= b.voteAt && own == null) {
            applyCommand(p.id, VoteLead(_rt.pick(_leadOptions)));
          }
        }
        return;
      case Phase.accusation:
        _botShareAndCombine(p);
        if (b.voteAt < 0) b.voteAt = _now + 4000 + _rt.nextInt(8000);
        if (_humanAccusations.isNotEmpty && b.voteAt > _now + 1200) b.voteAt = _now + 400 + _rt.nextInt(600);
        if (_now >= b.voteAt) {
          final own = _accuse[p.id];
          if (own == null) {
            _botAccuse(p);
          } else if (_humanAccusations.isNotEmpty && own.culprit != _botAccuseVote().culprit) {
            _botAccuse(p);
          }
        }
        return;
      case Phase.investigation:
      case Phase.night:
        b.voteAt = -1;
        break;
      default:
        return;
    }
    if (p.downed || p.hidden) return;
    if (p.channel != null) return;

    _botShareAndCombine(p);
    _botUseItems(p);
    if (p.alive && p.abilityCdMs == 0 && _rt.chance(0.002)) _botAbility(p);

    if (b.waitMs > 0) {
      b.waitMs -= dt;
      return;
    }

    // Gespräch fortsetzen
    if (b.topics.isNotEmpty && b.goal != null) {
      final topic = b.topics.removeAt(0);
      _ask(p, b.goal!, topic);
      b.waitMs = 900;
      if (b.topics.isEmpty) {
        b.blacklist['npc:${b.goal}'] = 600000;
        b.goal = null;
      }
      return;
    }

    b.thinkMs -= dt;
    if (b.thinkMs <= 0 || b.goal == null) {
      b.thinkMs = 700;
      _botChooseGoal(p, b);
    }
    final target = _goalPos(b);
    if (target == null) {
      b.goal = null;
      return;
    }

    final d = dist(p.x, p.y, target.$1, target.$2);
    final reach = b.goalKind == 'follow' ? 1.8 : Tuning.interactRange - 0.25;
    if (d <= reach) {
      b.path = [];
      if (!_botGoalStillValid(p, b)) {
        b.blacklist[b.goal!] = 5000;
        b.goal = null;
        b.thinkMs = 0;
        return;
      }
      _botAct(p, b);
      return;
    }
    _botMove(p, b, target, dt);
  }

  void _botShareAndCombine(PlayerState p) {
    for (final c in _clues.values.where((c) => c.holder == p.id && !c.onBoard).toList()) {
      _share(p, c.id);
    }
    final s = _s!;
    for (final k in s.combos) {
      if (_deductions.contains(k.id)) continue;
      if ((_clues[k.a]?.onBoard ?? false) && (_clues[k.b]?.onBoard ?? false)) {
        _combine(p, k.a, k.b);
      }
    }
  }

  void _botUseItems(PlayerState p) {
    if (!p.alive) return;
    for (var i = 0; i < p.inventory.length; i++) {
      final t = p.inventory[i];
      final use = switch (t) {
        ItemType.medkit => p.hp < p.maxHp || p.hasEffect('injured'),
        ItemType.antidote => p.hasEffect('poisoned'),
        ItemType.salts => p.hasEffect('panic'),
        ItemType.coffee => _phase == Phase.investigation && !p.hasEffect('caffeine'),
        ItemType.battery => _phase == Phase.night && !p.hasEffect('bright'),
        ItemType.flare => _shadow != null && dist(p.x, p.y, _shadow!.x, _shadow!.y) < 3,
        _ => false,
      };
      if (use) {
        _useItem(p, i);
        return;
      }
    }
  }

  void _botAbility(PlayerState p) {
    final a = p.detectiveClass.ability;
    if (a == 'scare' && _shadow == null) return;
    if (a == 'firstaid' && !_aliveDetectives.any((q) => q.hp < q.maxHp && dist(p.x, p.y, q.x, q.y) < 1.8)) return;
    _ability(p);
  }

  void _botChooseGoal(PlayerState p, _Brain b) {
    final s = _s!;
    final claimed = _claimedBy(p);
    bool free(String id) => !claimed.contains(id) && !b.blacklist.containsKey(id) && !b.blacklist.containsKey('npc:$id');

    // Niedergeschlagene Teamkameraden haben Vorrang.
    if (p.alive) {
      final down = _players.values.where((q) => q.downed).toList()
        ..sort((a, c) => dist(p.x, p.y, a.x, a.y).compareTo(dist(p.x, p.y, c.x, c.y)));
      if (down.isNotEmpty) return _setGoal(b, down.first.id, 'revive');
    }

    if (_phase == Phase.night && p.alive) {
      // Spuren des Schattens sind wertvoll – mutige Bots holen sie.
      final traces = _items.entries.where((e) => e.value.def.type == ItemType.trace && free(e.key)).toList()
        ..sort((a, c) => dist(p.x, p.y, a.value.x, a.value.y).compareTo(dist(p.x, p.y, c.value.x, c.value.y)));
      if (traces.isNotEmpty && p.hp > 1) return _setGoal(b, traces.first.key, 'item');
      final mates = _aliveDetectives.where((q) => q != p).toList()
        ..sort((a, c) {
          final ah = a.bot ? 1 : 0, ch = c.bot ? 1 : 0;
          if (ah != ch) return ah - ch;
          return dist(p.x, p.y, a.x, a.y).compareTo(dist(p.x, p.y, c.x, c.y));
        });
      if (mates.isNotEmpty) return _setGoal(b, mates.first.id, 'follow');
      final lit = s.map.rooms.where((r) => r.lit).toList();
      if (lit.isNotEmpty) return _setGoal(b, 'room:${lit.first.id}', 'safe');
    }

    if (p.ghost) {
      final ghostSpots = s.hotspots
          .where((h) => _hotspotVisible(p, h) && _availableCluesAt(p, h.id).isNotEmpty && free(h.id))
          .toList();
      if (ghostSpots.isNotEmpty) return _setGoal(b, _nearestHotspot(p, ghostSpots).id, 'hotspot');
      final mates = _aliveDetectives.toList();
      if (mates.isNotEmpty) return _setGoal(b, mates.first.id, 'follow');
      b.goal = null;
      return;
    }

    // Labor
    if (_labPending(p).isNotEmpty) {
      final lab = s.hotspots.where((h) => h.kind == HotspotKind.lab && _hotspotVisible(p, h)).firstOrNull;
      if (lab != null && free(lab.id)) return _setGoal(b, lab.id, 'hotspot');
    }

    // Gespräche
    NpcState? npc;
    var npcD = double.infinity;
    for (final n in _npcs) {
      final topics = _botTopics(p, n);
      if (topics.isEmpty || !free(n.id)) continue;
      final d = dist(p.x, p.y, n.x, n.y);
      if (d < npcD) {
        npcD = d;
        npc = n;
      }
    }

    // Hotspots
    final spots = s.hotspots
        .where((h) =>
            h.kind != HotspotKind.hide &&
            h.kind != HotspotKind.lab &&
            _hotspotVisible(p, h) &&
            free(h.id) &&
            (!_searchedBy.containsKey(h.id) || _availableCluesAt(p, h.id).isNotEmpty))
        .toList();
    final spot = spots.isEmpty ? null : _nearestHotspot(p, spots);
    final spotD = spot == null ? double.infinity : dist(p.x, p.y, spot.x + 0.5, spot.y + 0.5);

    if (npc != null && npcD <= spotD) return _setGoal(b, npc.id, 'npc');
    if (spot != null) return _setGoal(b, spot.id, 'hotspot');

    // Items
    if (p.inventory.length < Tuning.maxInventory) {
      final items = _items.entries.where((e) => free(e.key)).toList()
        ..sort((a, c) => dist(p.x, p.y, a.value.x, a.value.y).compareTo(dist(p.x, p.y, c.value.x, c.value.y)));
      if (items.isNotEmpty) return _setGoal(b, items.first.key, 'item');
    }

    // Dem nächsten Menschen folgen
    final humans = _aliveDetectives.where((q) => !q.bot && q != p).toList();
    if (humans.isNotEmpty) return _setGoal(b, humans.first.id, 'follow');
    b.goal = null;
  }

  /// Ziele, die andere gerade beanspruchen: Ziele steuernder Gehirne (ein eingefrorenes –
  /// Mensch wieder da – beansprucht nichts) und alles, woran jemand gerade arbeitet
  /// (Durchsuchen, Labor), damit niemand zum selben Fundort oder Labor nachläuft.
  Set<String> _claimedBy(PlayerState p) => {
        for (final q in _players.values)
          if (q != p) ...[
            if (q.autopilot && _brains[q.id]?.goal != null) _brains[q.id]!.goal!,
            if (q.channel != null) q.channel!.target,
          ],
      };

  /// Am Ziel angekommen: lohnt es sich noch? Sonst Ziel fallen lassen statt Fehlermeldung.
  bool _botGoalStillValid(PlayerState p, _Brain b) {
    final id = b.goal!;
    switch (b.goalKind) {
      case 'hotspot':
      case 'npc':
      case 'item':
        break;
      default:
        return true;
    }
    for (final q in _players.values) {
      if (q == p) continue;
      if (q.channel?.target == id) return false;
      final ob = _brains[q.id];
      if (q.autopilot && ob != null && ob.goal == id && ob != b) {
        // Beide wollen dasselbe: der Nähere (bei Gleichstand die kleinere ID) bleibt dran.
        final pos = _goalPos(b);
        if (pos == null) return false;
        final mine = dist(p.x, p.y, pos.$1, pos.$2), theirs = dist(q.x, q.y, pos.$1, pos.$2);
        if (theirs < mine || (theirs == mine && q.id.compareTo(p.id) < 0)) return false;
      }
    }
    if (b.goalKind == 'hotspot') {
      final h = _s!.hotspotById[id];
      if (h == null) return false;
      if (h.kind == HotspotKind.lab) return _labPending(p).isNotEmpty;
      if (_searchedBy.containsKey(id) && _availableCluesAt(p, id).isEmpty) return false;
    }
    return true;
  }

  List<String> _botTopics(PlayerState p, NpcState n) {
    if (!n.alive) {
      final notes = _s!.clues.where((d) => d.source.npc == n.id && _clueAvailable(p, d, ignoreChapter: true));
      return notes.isEmpty ? const [] : const ['__search'];
    }
    final heard = _heard[n.id] ?? const <String>{};
    return [
      for (final t in Topic.all)
        if (!heard.contains(t) && (t != Topic.rumor || p.detectiveClass.rumors)) t,
    ];
  }

  HotspotDef _nearestHotspot(PlayerState p, List<HotspotDef> list) {
    list.sort((a, c) => dist(p.x, p.y, a.x + 0.5, a.y + 0.5).compareTo(dist(p.x, p.y, c.x + 0.5, c.y + 0.5)));
    return list.first;
  }

  void _setGoal(_Brain b, String id, String kind) {
    if (b.goal != id) b.path = [];
    b.goal = id;
    b.goalKind = kind;
  }

  (double, double)? _goalPos(_Brain b) {
    final id = b.goal;
    if (id == null) return null;
    switch (b.goalKind) {
      case 'revive':
      case 'follow':
        final q = _players[id];
        if (q == null || (b.goalKind == 'revive' && !q.downed)) return null;
        return (q.x, q.y);
      case 'npc':
        final n = _npcById[id];
        return n == null ? null : (n.x, n.y);
      case 'item':
        final i = _items[id];
        return i == null ? null : (i.x, i.y);
      case 'hotspot':
        final h = _s!.hotspotById[id];
        return h == null ? null : (h.x + 0.5, h.y + 0.5);
      case 'safe':
        final r = _s!.map.roomById[id.substring(5)];
        return r == null ? null : (r.cx, r.cy);
    }
    return null;
  }

  void _botAct(PlayerState p, _Brain b) {
    final id = b.goal!;
    switch (b.goalKind) {
      case 'revive':
      case 'item':
      case 'hotspot':
        _interact(p, id);
        b.blacklist[id] = 30000;
        b.goal = null;
      case 'npc':
        final n = _npcById[id];
        if (n == null) {
          b.goal = null;
          return;
        }
        if (!n.alive) {
          _interact(p, id);
          b.blacklist['npc:$id'] = 600000;
          b.goal = null;
          return;
        }
        _interact(p, id);
        b.topics
          ..clear()
          ..addAll(_botTopics(p, n));
        b.waitMs = 600;
        if (b.topics.isEmpty) b.goal = null;
      case 'follow':
      case 'safe':
        b.waitMs = 800;
    }
  }

  void _botMove(PlayerState p, _Brain b, (double, double) target, int dt) {
    final grid = _grid!;
    if (b.path.isEmpty) {
      final goalTile = grid.nearestWalkable(target.$1.floor(), target.$2.floor(), maxRadius: 2);
      if (goalTile == null) {
        b.blacklist[b.goal!] = 20000;
        b.goal = null;
        return;
      }
      b.path = grid.findPath(Pt(p.x.floor(), p.y.floor()), goalTile) ?? [];
      if (b.path.isEmpty) {
        // Gleiche Kachel oder unerreichbar → direkt hinlaufen.
        if (Pt(p.x.floor(), p.y.floor()) != goalTile) {
          b.blacklist[b.goal!] = 20000;
          b.goal = null;
          return;
        }
      }
    }
    var step = Tuning.playerSpeed * (p.bot ? 0.8 : 0.95) * p.speedMul * dt / 1000;
    final ox = p.x, oy = p.y;
    if (b.path.isEmpty) {
      final d = dist(p.x, p.y, target.$1, target.$2);
      final k = math.min(1.0, step / math.max(d, 0.001));
      final (nx, ny) = grid.slide(p.x, p.y, (target.$1 - p.x) * k, (target.$2 - p.y) * k, Tuning.playerRadius);
      p.x = nx;
      p.y = ny;
    }
    while (step > 0 && b.path.isNotEmpty) {
      final next = b.path.first;
      final tx = next.x + 0.5, ty = next.y + 0.5;
      final d = dist(p.x, p.y, tx, ty);
      if (d <= step) {
        p.x = tx;
        p.y = ty;
        step -= d;
        b.path.removeAt(0);
      } else {
        p.x += (tx - p.x) / d * step;
        p.y += (ty - p.y) / d * step;
        step = 0;
      }
    }
    final moved = dist(ox, oy, p.x, p.y);
    if (moved > 0.001) {
      p.facing = math.atan2(p.y - oy, p.x - ox);
      p.moving = true;
      p.movingUntil = _now + 200;
      _afterMove(p);
    }
    if (dist(b.lastX, b.lastY, p.x, p.y) < 0.05) {
      b.stuckMs += dt;
      if (b.stuckMs > 2500) {
        b.stuckMs = 0;
        if (b.goal != null) b.blacklist[b.goal!] = 15000;
        b.goal = null;
        b.path = [];
      }
    } else {
      b.stuckMs = 0;
      b.lastX = p.x;
      b.lastY = p.y;
    }
  }

  /// Schlussfolgerung aus der Beweiswand.
  AccuseVote _deduce() {
    final s = _s!;
    final truth = _truth!;
    var cands = s.suspects.toList();
    for (final c in _clues.values.where((c) => c.onBoard && c.revealed)) {
      final v = truth.valueFor(c);
      if ((c.kind == ClueKind.trait || c.kind == 'sighting') && c.trait != null) {
        final next = cands.where((x) => x.traits[c.trait] == v).toList();
        if (next.isNotEmpty) cands = next;
      } else if (c.kind == ClueKind.alibi && c.def?.subject != null) {
        if (v == 'true') {
          final next = cands.where((x) => x.id != c.def!.subject).toList();
          if (next.isNotEmpty) cands = next;
        } else {
          final liar = cands.where((x) => x.id == c.def!.subject).toList();
          if (liar.isNotEmpty) cands = liar;
        }
      }
    }
    final contradicted = cands.where((x) => _contradicted.contains(x.id)).toList();
    if (contradicted.isNotEmpty) cands = contradicted;
    final culprit = cands.length == 1 ? cands.first : _rt.pick(cands);

    String? fromBoard(String kind) =>
        _clues.values.where((c) => c.onBoard && c.revealed && c.kind == kind).map(truth.valueFor).firstOrNull;
    final motive = fromBoard(ClueKind.motive) ??
        (culprit.motives.isNotEmpty ? _rt.pick(culprit.motives) : s.motives.first.id);
    final weapon = fromBoard(ClueKind.weapon) ?? _rt.pick(s.weapons).id;
    return AccuseVote(culprit: culprit.id, motive: motive, weapon: weapon);
  }

  void _botAccuse(PlayerState p) {
    final v = _botAccuseVote();
    applyCommand(p.id, Accuse(culprit: v.culprit, motive: v.motive, weapon: v.weapon));
  }

  /// Die Menschen entscheiden: Bots schließen sich der Mehrheit der Menschen an,
  /// sonst ziehen sie ihre eigenen Schlüsse.
  AccuseVote _botAccuseVote() {
    final human = _humanAccusations.values.toList();
    if (human.isEmpty) return _deduce();
    final counts = <String, int>{};
    for (final v in human) {
      counts[v.culprit] = (counts[v.culprit] ?? 0) + 1;
    }
    final top = counts.entries.reduce((a, c) => c.value > a.value ? c : a).key;
    return human.firstWhere((v) => v.culprit == top);
  }
}
