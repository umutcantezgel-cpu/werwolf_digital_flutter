import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mordakte_core/mordakte_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'progression.dart';

/// Bevorzugte Ausrüstung (wird in der Lobby automatisch gesetzt).
class Loadout {
  final String cls;
  final int coat;
  final String hat;

  const Loadout({this.cls = 'forensic', this.coat = 0, this.hat = 'fedora'});

  Map<String, dynamic> toJson() => {'cls': cls, 'coat': coat, 'hat': hat};

  factory Loadout.fromJson(Map<String, dynamic> j) => Loadout(
    cls: j['cls'] as String? ?? 'forensic',
    coat: (j['coat'] as num? ?? 0).toInt(),
    hat: j['hat'] as String? ?? 'fedora',
  );
}

/// Etwas, das durch einen Rangaufstieg freigeschaltet wurde.
class Unlock {
  /// `class`, `hat`, `coat`
  final String kind;
  final String id;

  const Unlock(this.kind, this.id);
}

/// Ergebnis der Verbuchung eines Spiels (für den End-Bildschirm).
class GameResult {
  final int xpBefore;
  final int xpGained;
  final int dailyBonus;
  final int rankBefore;
  final int rankAfter;
  final bool newEnding;
  final int endingsInScenario;
  final int streak;
  final List<String> newAchievements;
  final List<Unlock> unlocks;

  const GameResult({
    required this.xpBefore,
    required this.xpGained,
    required this.dailyBonus,
    required this.rankBefore,
    required this.rankAfter,
    required this.newEnding,
    required this.endingsInScenario,
    required this.streak,
    required this.newAchievements,
    required this.unlocks,
  });

  int get xpAfter => xpBefore + xpGained + dailyBonus;
  bool get rankUp => rankAfter > rankBefore;
}

/// Was die App während eines Spiels mitzählt (falls die Engine keine Statistik liefert).
class GameTally {
  int combos = 0;
  int revives = 0;
  bool ghostHelped = false;
}

/// Persistente Meta-Progression: Name, XP/Rang, Freischaltungen, Enden-Sammlung,
/// Fall des Tages + Serie, Erfolge, Statistik.
class MetaStore extends ChangeNotifier {
  MetaStore._(this._prefs);

  final SharedPreferences? _prefs;
  final Map<String, String> _memory = {};

  static Future<MetaStore> load() async {
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {
      prefs = null; // z. B. blockierter Speicher im Browser → nur im Speicher
    }
    final m = MetaStore._(prefs);
    m._read();
    return m;
  }

  /// Nur für Tests/Vorschau ohne Speicher.
  factory MetaStore.memory() => MetaStore._(null).._read();

  String? _name;
  int _xp = 0;
  int _streak = 0;
  int _bestStreak = 0;
  String? _lastDay;
  String? _dailyDone;
  final Map<String, Set<String>> _endings = {};
  final Set<String> _storySolved = {};
  final Set<String> _solvedScenarios = {};
  final Set<String> _achievements = {};
  final Map<String, int> _stats = {};
  Loadout _loadout = const Loadout();
  String? _serverUrl;

  // --- Lesen -----------------------------------------------------------------

  String? get name => _name;
  bool get hasName => (_name ?? '').trim().isNotEmpty;
  int get xp => _xp;
  int get rank => rankForXp(_xp);
  int get streak => _currentStreak(DateTime.now());
  int get bestStreak => _bestStreak;
  Loadout get loadout => _loadout;
  String? get serverUrl => _serverUrl;
  Set<String> get achievements => Set.unmodifiable(_achievements);
  Set<String> endingsFor(String scenarioId) => Set.unmodifiable(_endings[scenarioId] ?? const <String>{});
  int get totalEndings => _endings.values.fold(0, (a, s) => a + s.length);
  bool storySolved(String scenarioId) => _storySolved.contains(scenarioId);
  bool scenarioSolved(String scenarioId) => _solvedScenarios.contains(scenarioId);
  bool dailyDone(DateTime now) => _dailyDone == dayKey(now);
  int stat(String key) => _stats[key] ?? 0;

  bool classUnlocked(String cls) => rank >= classUnlockRank(cls);
  bool hatUnlocked(String hat) => rank >= hatRank(hat);
  bool coatUnlocked(int coat) => rank >= coatRank(coat);

  int _currentStreak(DateTime now) {
    if (_lastDay == null) return 0;
    final today = dayKey(now);
    final yesterday = dayKey(now.subtract(const Duration(days: 1)));
    return (_lastDay == today || _lastDay == yesterday) ? _streak : 0;
  }

  // --- Schreiben ---------------------------------------------------------------

  set name(String? v) {
    _name = v?.trim();
    _put('name', _name ?? '');
    notifyListeners();
  }

  set loadout(Loadout v) {
    _loadout = v;
    _put('loadout', jsonEncode(v.toJson()));
    notifyListeners();
  }

  set serverUrl(String? v) {
    _serverUrl = (v == null || v.trim().isEmpty) ? null : v.trim();
    _put('server', _serverUrl ?? '');
    notifyListeners();
  }

  /// Nur Entwickler-Einstieg: XP direkt setzen.
  void debugSetXp(int xp) {
    _xp = xp;
    _write();
    notifyListeners();
  }

  /// Verbucht ein beendetes Spiel genau einmal.
  GameResult record({
    required EndingView ending,
    required String scenarioId,
    required String mode,
    required String playerId,
    required bool online,
    required Set<String> allScenarioIds,
    required GameTally tally,
    DateTime? now,
  }) {
    final date = now ?? DateTime.now();
    final today = dayKey(date);
    final xpBefore = _xp;
    final rankBefore = rank;

    final gained = ending.xp[playerId] ?? Tuning.xpVerdict[ending.verdict] ?? 0;
    var bonus = 0;
    if (mode == 'daily' && _dailyDone != today) {
      bonus = dailyBonusXp;
      _dailyDone = today;
    }

    // Serie: aufeinanderfolgende Tage mit mindestens einem abgeschlossenen Fall.
    if (_lastDay != today) {
      final yesterday = dayKey(date.subtract(const Duration(days: 1)));
      _streak = _lastDay == yesterday ? _streak + 1 : 1;
      _lastDay = today;
    }
    if (_streak > _bestStreak) _bestStreak = _streak;

    final set = _endings.putIfAbsent(scenarioId, () => <String>{});
    final newEnding = set.add(ending.endingId);

    final solved = const {'perfect', 'solid', 'partial'}.contains(ending.verdict);
    _inc('cases');
    if (solved) {
      _inc('solved');
      _solvedScenarios.add(scenarioId);
      if (mode == 'story') _storySolved.add(scenarioId);
    }
    if (ending.verdict == 'perfect') _inc('perfect');
    final myStats = ending.stats[playerId] ?? const <String, int>{};
    final revives = myStats['revives'] ?? tally.revives;
    final combos = myStats['combos'] ?? tally.combos;
    _inc('revives', revives);
    _inc('combos', combos);
    if (online) _inc('online');
    final myAwards = ending.awards[playerId] ?? const <String>[];
    final ghostHelped = tally.ghostHelped || myAwards.contains('geist') || (myStats['ghostHelp'] ?? 0) > 0;
    if (ghostHelped) _inc('ghost');

    _xp += gained + bonus;
    final rankAfter = rank;

    final newAch = <String>[];
    void grant(String id, bool cond) {
      if (cond && _achievements.add(id)) newAch.add(id);
    }

    grant('first_case', true);
    grant('perfect', ending.verdict == 'perfect');
    grant('all_survived', ending.team == 'all');
    grant('revive3', stat('revives') >= 3);
    grant('secret', ending.secret);
    grant('all_scenarios', allScenarioIds.isNotEmpty && _solvedScenarios.containsAll(allScenarioIds));
    grant('streak5', _streak >= 5);
    grant('ghost_helper', ghostHelped);
    grant('online', online);
    grant('combos10', stat('combos') >= 10);

    final unlocks = <Unlock>[];
    if (rankAfter > rankBefore) {
      bool fresh(int r) => r > rankBefore && r <= rankAfter;
      for (final c in detectiveClasses.values) {
        if (fresh(c.unlockRank)) unlocks.add(Unlock('class', c.id));
      }
      for (final e in hatUnlockRank.entries) {
        if (fresh(e.value)) unlocks.add(Unlock('hat', e.key));
      }
      for (var i = 0; i < coatUnlockRank.length; i++) {
        if (fresh(coatUnlockRank[i])) unlocks.add(Unlock('coat', '$i'));
      }
    }

    _write();
    notifyListeners();
    return GameResult(
      xpBefore: xpBefore,
      xpGained: gained,
      dailyBonus: bonus,
      rankBefore: rankBefore,
      rankAfter: rankAfter,
      newEnding: newEnding,
      endingsInScenario: set.length,
      streak: _streak,
      newAchievements: newAch,
      unlocks: unlocks,
    );
  }

  void _inc(String key, [int by = 1]) => _stats[key] = (_stats[key] ?? 0) + by;

  // --- Persistenz --------------------------------------------------------------

  String? _get(String k) => _prefs != null ? _prefs.getString('mordakte.$k') : _memory[k];

  void _put(String k, String v) {
    if (_prefs != null) {
      _prefs.setString('mordakte.$k', v);
    } else {
      _memory[k] = v;
    }
  }

  void _read() {
    try {
      final n = _get('name');
      _name = (n == null || n.isEmpty) ? null : n;
      final s = _get('server');
      _serverUrl = (s == null || s.isEmpty) ? null : s;
      final lo = _get('loadout');
      if (lo != null && lo.isNotEmpty) _loadout = Loadout.fromJson(jsonDecode(lo) as Map<String, dynamic>);
      final raw = _get('progress');
      if (raw == null || raw.isEmpty) return;
      final j = jsonDecode(raw) as Map<String, dynamic>;
      _xp = (j['xp'] as num? ?? 0).toInt();
      _streak = (j['streak'] as num? ?? 0).toInt();
      _bestStreak = (j['best'] as num? ?? 0).toInt();
      _lastDay = j['last'] as String?;
      _dailyDone = j['daily'] as String?;
      for (final e in (j['endings'] as Map? ?? const {}).entries) {
        _endings[e.key as String] = {...(e.value as List).cast<String>()};
      }
      _storySolved.addAll((j['story'] as List? ?? const []).cast<String>());
      _solvedScenarios.addAll((j['solved'] as List? ?? const []).cast<String>());
      _achievements.addAll((j['ach'] as List? ?? const []).cast<String>());
      for (final e in (j['stats'] as Map? ?? const {}).entries) {
        _stats[e.key as String] = (e.value as num).toInt();
      }
    } catch (e) {
      debugPrint('Meta: Fortschritt nicht lesbar ($e)');
    }
  }

  void _write() {
    _put(
      'progress',
      jsonEncode({
        'xp': _xp,
        'streak': _streak,
        'best': _bestStreak,
        'last': _lastDay,
        'daily': _dailyDone,
        'endings': {for (final e in _endings.entries) e.key: e.value.toList()},
        'story': _storySolved.toList(),
        'solved': _solvedScenarios.toList(),
        'ach': _achievements.toList(),
        'stats': _stats,
      }),
    );
  }
}
