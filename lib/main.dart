import 'package:flutter/material.dart';

import 'game/game_view.dart';
import 'session/session_factory.dart';

void main() {
  runApp(MaterialApp(
    title: 'Mordakte',
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: GameView(session: SessionFactory.fake())),
  ));
}
