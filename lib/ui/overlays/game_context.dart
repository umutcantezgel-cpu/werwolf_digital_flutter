import 'package:flutter/material.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/app_state.dart';
import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../../session/game_session.dart';

/// Alles, was Overlays über das laufende Spiel wissen müssen.
class GameCtx {
  GameCtx({required this.app, required this.session, required this.cv, required this.l});

  final AppState app;
  final GameSession session;
  final CaseView cv;
  final L l;

  late final ScenarioDef? scenario = cv.scenarioId == null ? null : session.scenarios[cv.scenarioId];
  late final Color accent = accentOf(scenario);
  String get me => session.playerId;
  bool get isHost => cv.hostId == me;

  void send(Command c) => app.send(c);

  LobbyPlayer? player(String id) => cv.lobby.where((p) => p.id == id).firstOrNull;

  DetectiveView? detective(String id) => session.world.value?.detective(id);

  /// Anzeigename eines Spielers („Du“ für sich selbst).
  String nameOf(String? id, {bool youForMe = true}) {
    if (id == null) return '?';
    if (id == me && youForMe) return l.common_you;
    return player(id)?.name ?? detective(id)?.name ?? id;
  }

  String get myClass => player(me)?.cls ?? detective(me)?.cls ?? 'forensic';

  int coatOf(String id) => player(id)?.coat ?? detective(id)?.coat ?? 0;
  String hatOf(String id) => player(id)?.hat ?? detective(id)?.hat ?? 'none';

  String npcName(String? id) => id == null ? '?' : (scenario?.suspectById[id]?.name.resolve() ?? id);

  String clueName(String? id) {
    if (id == null) return '?';
    final def = scenario?.clueById[id];
    if (def != null) return def.name.resolve();
    if (id.startsWith('sight_')) return l.clue_sighting_title;
    return l.clue_kind_other;
  }

  String hotspotName(String? id) => id == null ? '?' : (scenario?.hotspotById[id]?.name.resolve() ?? id);

  String leadName(String? id) => id == null ? '?' : (scenario?.leadById[id]?.name.resolve() ?? id);

  String comboName(String? id) => id == null ? '?' : (scenario?.comboById[id]?.name.resolve() ?? id);

  /// Beweisstärke wie in der Engine: aufgedeckte Hinweise auf der Wand (gelogene Alibis doppelt)
  /// + Schlussfolgerungen + Widersprüche.
  int get strength {
    var s = 0;
    for (final c in cv.board.where((c) => c.revealed)) {
      switch (c.kind) {
        case ClueKind.trait:
        case ClueKind.motive:
        case ClueKind.weapon:
        case 'sighting':
          s += 1;
        case ClueKind.alibi:
          s += c.value == 'false' ? 2 : 1;
      }
    }
    return s + cv.deductions.length + cv.contradictions;
  }

  /// Merkmale eines Verdächtigen als (Label, Wert) – erst, wenn er befragt wurde.
  List<(String, String)>? traitsOf(String npcId) {
    final s = scenario;
    final def = s?.suspectById[npcId];
    if (s == null || def == null) return null;
    if ((cv.heard[npcId] ?? const []).isEmpty) return null;
    return [
      for (final e in s.traits.entries)
        if (def.traits[e.key] != null)
          (e.value.label.resolve(), e.value.values[def.traits[e.key]]?.resolve() ?? def.traits[e.key]!),
    ];
  }
}

String formatClock(int ms) {
  final s = (ms / 1000).ceil().clamp(0, 5999);
  return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
}
