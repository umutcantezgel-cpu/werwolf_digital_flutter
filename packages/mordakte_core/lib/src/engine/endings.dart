part of 'engine.dart';

/// Setzt das Ende aus Bausteinen zusammen: Urteil × Team-Schicksal × Täter × Geheimnis.
extension _EndingLogic on Engine {
  int get _evidenceStrength {
    final truth = _truth!;
    var strength = 0;
    for (final c in _clues.values.where((c) => c.onBoard && c.revealed)) {
      switch (c.kind) {
        case ClueKind.trait:
        case ClueKind.motive:
        case ClueKind.weapon:
        case 'sighting':
          strength += 1;
        case ClueKind.alibi:
          strength += truth.valueFor(c) == 'false' ? 2 : 1;
      }
    }
    return strength + _deductions.length + _contradicted.length;
  }

  /// Stimmen der Menschen, die selbst gewählt haben (ohne Bots und Autopilot).
  Map<String, AccuseVote> get _humanAccusations => {
        for (final e in _accuse.entries)
          if (_isHumanVoter(e.key)) e.key: e.value,
      };

  AccuseVote? _tallyAccusation() {
    if (_accuse.isEmpty) return null;
    // Die Menschen entscheiden: KI-Stimmen zählen nur, wenn kein Mensch angeklagt hat.
    final human = _humanAccusations;
    final votes = human.isNotEmpty ? human.values : _accuse.values;
    String? plurality(Iterable<String?> values) {
      final counts = <String, int>{};
      for (final v in values) {
        if (v != null) counts[v] = (counts[v] ?? 0) + 1;
      }
      if (counts.isEmpty) return null;
      final best = counts.values.reduce(math.max);
      final top = counts.entries.where((e) => e.value == best).map((e) => e.key).toList()..sort();
      return top.length == 1 ? top.first : _rt.pick(top);
    }

    final culprit = plurality(votes.map((v) => v.culprit))!;
    final backing = votes.where((v) => v.culprit == culprit);
    return AccuseVote(
      culprit: culprit,
      motive: plurality(backing.map((v) => v.motive)),
      weapon: plurality(backing.map((v) => v.weapon)),
    );
  }

  void _finish() {
    // KI-Stimmen nachholen, falls die Zeit abgelaufen ist.
    // Haben Menschen gewählt, schließen sich die KI-Stimmen ihrer Mehrheit an.
    for (final p in _players.values.where((p) => p.autopilot && !_accuse.containsKey(p.id))) {
      _accuse[p.id] = _botAccuseVote();
    }
    final truth = _truth!.truth;
    final accused = _tallyAccusation();
    final strength = _evidenceStrength;

    String verdict;
    if (accused == null) {
      verdict = 'unsolved';
    } else if (accused.culprit != truth.culprit) {
      verdict = 'wrong';
    } else {
      final m = accused.motive == truth.motive;
      final w = accused.weapon == truth.weapon;
      if (m && w && strength >= Tuning.strengthPerfect) {
        verdict = 'perfect';
      } else if ((m || w) && strength >= Tuning.strengthSolid) {
        verdict = 'solid';
      } else {
        verdict = 'partial';
      }
    }

    final all = _players.values.toList();
    final survivors = [for (final p in all) if (!p.ghost) p.id];
    final String team;
    if (survivors.isEmpty) {
      team = 'none';
    } else if (survivors.length == all.length) {
      team = 'all';
    } else if (survivors.length == 1) {
      team = 'lone';
    } else {
      team = 'some';
    }
    final secret = _clues.values.any((c) => c.onBoard && (c.def?.secret ?? false));
    final caught = verdict == 'perfect' || verdict == 'solid' || verdict == 'partial';
    final endingId = '$verdict.$team.${truth.culprit}${secret ? '.secret' : ''}';

    // Auszeichnungen
    final awards = <String, List<String>>{for (final p in all) p.id: <String>[]};
    void award(String id, int Function(PlayerState) score) {
      PlayerState? best;
      var bestScore = 0;
      for (final p in all) {
        final s = score(p);
        if (s > bestScore) {
          bestScore = s;
          best = p;
        }
      }
      if (best != null) awards[best.id]!.add(id);
    }

    award('spurensucher', (p) => p.stats.found);
    award('teamplayer', (p) => p.stats.shared);
    award('kombinierer', (p) => p.stats.combos * 2 + p.stats.contradictions * 2);
    award('lebensretter', (p) => p.stats.revives);
    award('ueberlebender', (p) => p.ghost ? 0 : p.stats.attacks);
    award('geist', (p) => p.ghost ? p.stats.ghostHelp : 0);

    final xp = <String, int>{};
    for (final p in all) {
      xp[p.id] = Tuning.xpVerdict[verdict]! +
          p.stats.found * Tuning.xpClueFound +
          p.stats.shared * Tuning.xpClueShared +
          p.stats.combos * Tuning.xpCombo +
          p.stats.revives * Tuning.xpRevive +
          p.stats.heals * Tuning.xpHeal +
          (p.ghost ? 0 : Tuning.xpSurvive) +
          (secret ? 100 : 0);
    }

    _ending = EndingView(
      verdict: verdict,
      team: team,
      secret: secret,
      caught: caught,
      truth: truth,
      accused: accused,
      strength: strength,
      endingId: endingId,
      awards: awards,
      xp: xp,
      stats: {for (final p in all) p.id: p.stats.toMap()},
      survivors: survivors,
      witnessesAlive: _npcs.where((n) => n.alive && n.id != truth.culprit).length,
    );
    _shadow = null;
    _enterPhase(Phase.ending, 0);
    _emit(const GameEvent(Ev.ending));
  }
}
