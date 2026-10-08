import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../session/fake_session.dart';
import '../../session/game_session.dart';
import '../game_view.dart';
import '../mordakte_game.dart';
import 'scenario_preview_session.dart';
import 'showcase_session.dart';

/// Entwicklungs-Vorschau des Renderers:
/// `flutter build web -t lib/game/dev/preview_main.dart`, Phase per URL
/// `?phase=night|council|investigation|accusation`, optional `&zoom=1.6`,
/// `&at=4.5,8.5` (Startposition), `&demo=1` (Showcase-Zustände) und
/// `&scenario=ravensmoor` (beliebiges Szenario aus `content/scenarios/`).
Future<void> main() async {
  final session = FakeSession();
  final q = Uri.base.queryParameters;
  final p = switch (q['phase']) {
    'night' => Phase.night,
    'council' => Phase.council,
    'accusation' => Phase.accusation,
    'investigation' => Phase.investigation,
    _ => null,
  };
  if (p != null) session.debugSetPhase(p);
  final zoom = double.tryParse(q['zoom'] ?? '');
  if (zoom != null) MordakteGame.debugInitialZoom = zoom;
  final at = (q['at'] ?? '').split(',').map(double.tryParse).toList();
  if (at.length == 2 && at[0] != null && at[1] != null) {
    session.move(at[0]!, at[1]!, 0.8);
    // Auf den nächsten Snapshot warten, damit die Szene dort startet.
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }
  GameSession s = q['demo'] == '1' ? ShowcaseSession(session) : session;
  final scenarioId = q['scenario'];
  if (scenarioId != null) {
    WidgetsFlutterBinding.ensureInitialized();
    final json = await rootBundle.loadString('content/scenarios/$scenarioId.json');
    final def = ScenarioDef.fromJson(jsonDecode(json) as Map<String, dynamic>);
    final preview = ScenarioPreviewSession(def, phase: p ?? Phase.investigation);
    if (at.length == 2 && at[0] != null && at[1] != null) {
      preview.move(at[0]!, at[1]!, 0.8);
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
    s = preview;
  }
  runApp(MaterialApp(
    title: 'Mordakte – Szene',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: Scaffold(
      backgroundColor: const Color(0xFF0B0910),
      body: GameView(session: s),
    ),
  ));
}
