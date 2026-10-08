import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'burgstadt_ansicht.dart';

/// Startseite der App: „Burgstadt Schartenfels“ im Vollbild. „Klassische Fälle“
/// führt zum Bestand (Mordakte).
class BurgstadtSeite extends StatelessWidget {
  const BurgstadtSeite({super.key});

  static String? get _start {
    try {
      return Uri.base.queryParameters['bs'];
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BurgstadtAnsicht(
          start: _start,
          beiAktion: (a) {
            if (a == 'klassisch') context.go('/');
          },
        ),
      ),
    );
  }
}
