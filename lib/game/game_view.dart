import 'package:flutter/material.dart';

import '../session/game_session.dart';

/// Die 2.5D-Spielszene (Flame) inkl. Joystick, Aktionsknopf und Tastatur.
///
/// Vertrag für die UI: `GameView(session: s)` füllt den verfügbaren Platz.
/// Interaktionen laufen ausschließlich über [GameSession.send]/[GameSession.move];
/// Dialoge, Beweiswand usw. öffnet die UI als Reaktion auf Session-Ereignisse.
class GameView extends StatefulWidget {
  const GameView({super.key, required this.session});

  final GameSession session;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) => const ColoredBox(color: Color(0xFF0B0910));
}
